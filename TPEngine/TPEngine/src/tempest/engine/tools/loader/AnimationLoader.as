package tempest.engine.tools.loader
{
	import com.adobe.utils.ArrayUtil;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import tempest.TPEngine;
	import tempest.common.handler.HandlerThread;
	import tempest.common.logging.*;
	import tempest.common.rsl.TRslLoader;
	import tempest.common.rsl.vo.TRslType;
	import tempest.engine.graphics.TPBitmap;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.animation.vo.AnimationSource;
	import tempest.engine.tools.SceneCache;
	import tempest.engine.vo.config.SceneConfig;

	public class AnimationLoader
	{
		private static const log:ILogger = TLog.getLogger(AnimationLoader);
		private static var waitingList:Object = {};
		private static var Num:int = 1;
		private static var loaderNums:int = 0;
		//
		private static var _needList:Object = {}; //等待加载资源的APD
		private static var _waitingArr:Array = []; //等待加入加载队列的加载器
		private static var _waitingList:Dictionary = new Dictionary(); //等待加入队列的加载器索引
		private static var _loadingList:Dictionary = new Dictionary(); //正在加载的加载器
		private static var _ht:HandlerThread = new HandlerThread();

		public static function loadAnimation(ani:Animation):void
		{
			var $ani:Animation = ani;
			$ani.guid = Num++;
			var $path:String = $ani.path;
			//如果有缓存 直接设置
			if (SceneCache.AnimationSourceCache[$path])
			{
				ani.source = SceneCache.AnimationSourceCache[$path];
				return;
			}
			//如果已经在等待列表 返回
			if (_needList[$ani.guid])
				return;
			//获取加载器
			var loaderObj:Object = _waitingList[$path] || _loadingList[$path];
			if (!loaderObj) //如果没有加载器 创建加载器
			{
				var loader:TRslLoader = new TRslLoader($path, TRslType.RES, TPEngine.decode);
				loader.id = $path;
				_waitingArr.push(loader);
				loaderObj = _waitingList[$path] = {loader: loader, needs: []};
			}
			TRslLoader(loaderObj.loader).priority = $ani.guid;
			loaderObj.needs.push($ani.guid);
			_needList[$ani.guid] = {ap: $ani, loader: loaderObj};
			_waitingArr.sortOn("priority", Array.NUMERIC);
			//开始加载
			loadNext();
		}

		private static function loadNext():void
		{
			var loader:TRslLoader;
			while (_waitingArr.length != 0 && loaderNums <= SceneConfig.ANIMATION_LOADER_NUM)
			{
				loader = _waitingArr.pop();
				_loadingList[loader.id] = _waitingList[loader.id]
				_waitingList[loader.id] = null;
				delete _waitingList[loader.id];
				loaderNums++;
				loader.addEventListener(Event.COMPLETE, onLoadCompete);
				loader.addEventListener(ErrorEvent.ERROR, onLoadError);
				_ht.push(loader.load, null, SceneConfig.AVATARPART_LOAD_DELAY);
			}
		}

		private static function onLoadError(event:ErrorEvent):void
		{
			disposeLoader(_loadingList[(event.target as TRslLoader).id]);
		}

		private static function disposeLoader(loaderObj:Object):void
		{
			try
			{
				var loader:TRslLoader = loaderObj.loader as TRslLoader;
				loader.removeEventListener(Event.COMPLETE, onLoadCompete);
				loader.removeEventListener(ErrorEvent.ERROR, onLoadError);
				var needs:Array = loaderObj.needs;
				if (needs && needs.length != 0)
				{
					needs.forEach(function(item:int, index:int, arr:Array):void
					{
						_needList[item].ap = null;
						_needList[item].loader = null;
						_needList[item] = null;
						delete _needList[item];
					});
				}
				if (_loadingList[loader.id])
				{
					_loadingList[loader.id] = null;
					delete _loadingList[loader.id];
					_ht.removeHandler(loader.load);
					loaderNums--;
				}
				else
				{
					_waitingList[loader.id] = null;
					delete _waitingList[loader.id];
					ArrayUtil.removeValueFromArray(_waitingArr, loader);
				}
				loader.dispose();
			}
			catch (e:Error)
			{
			}
			finally
			{
				loadNext();
			}
		}

		private static function onLoadCompete(event:Event):void
		{
			var loader:TRslLoader = event.target as TRslLoader;
			var aps:AnimationSource = addAnimationSourceCache(loader);
			try
			{
				if (aps)
				{
					var needs:Array = _loadingList[loader.id].needs;
					var need:int;
					var needObj:Object;
					while (needs.length != 0)
					{
						need = needs.pop();
						needObj = _needList[need];
						Animation(needObj.ap).source = aps;
						needObj.ap = null;
						needObj.loader = null;
						_needList[need] = null;
						delete _needList[need];
					}
				}
			}
			catch (error:Error)
			{
			}
			finally
			{
				disposeLoader(_loadingList[loader.id]);
			}
		}

		private static function addAnimationSourceCache(rsl:TRslLoader):AnimationSource
		{
			var aps:AnimationSource = null;
			try
			{
				aps = new AnimationSource(rsl.id);
				var info:XML = new XML(rsl.getInstance("Info"));
				var frames:XMLList = info["frames"].elements("frame");
				for each (var frame:XML in frames)
				{
					var __id:String = frame.@id;
					var offsetX:int = parseInt(frame.@offset_x);
					var offsetY:int = parseInt(frame.@offset_y);
					var bitmapData:BitmapData = rsl.getInstance(__id);
					aps.add(parseInt(__id), new TPBitmap(bitmapData, offsetX, offsetY));
				}
				SceneCache.AnimationSourceCache[rsl.id] = aps;
			}
			catch (e:Error)
			{
				log.error("动画资源错误! url:" + rsl.id);
				aps = null;
			}
			return aps;
		}

		public static function removeWaitingAnimationById(id:int):Boolean
		{
			var apObj:Object = _needList[id];
			if (apObj)
			{
				var loaderObj:Object = apObj.loader;
				var needs:Array = loaderObj.needs;
				ArrayUtil.removeValueFromArray(needs, id);
				apObj.ap = null;
				apObj.loader = null;
				_needList[id] = null;
				delete _needList[id];
				if (needs.length == 0)
				{
//					disposeLoader(loaderObj);
				}
				return true;
			}
			return false;
		}
	}
}
