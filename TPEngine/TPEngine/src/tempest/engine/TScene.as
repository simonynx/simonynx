//------------------------------------------------------------------------------
//   QYFZ  
//   Copyright 2011 
//   All rights reserved. 
//------------------------------------------------------------------------------
package tempest.engine
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.core.IDisposable;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.animation.AnimationType;
	import tempest.engine.graphics.layer.EffectLayer;
	import tempest.engine.graphics.layer.ElementLayer;
	import tempest.engine.graphics.layer.InteractiveLayer;
	import tempest.engine.graphics.layer.MapLayer;
	import tempest.engine.graphics.layer.SmallMapLayer;
	import tempest.engine.signals.SceneSignal;
	import tempest.engine.staticdata.Status;
	import tempest.engine.tools.SceneCache;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.tools.loader.MapConfigLoader;
	import tempest.engine.vo.config.MapConfig;
	import tempest.utils.Fun;
	import tempest.utils.Geom;
	
	import tpe.manager.FilePathManager;

	/**
	 * 场景类
	 * @author
	 */
	public class TScene implements IDisposable
	{
		private static const log:ILogger = TLog.getLogger(TScene);
		/************************************变量******************************************/
		////////////////////////////////////////////////////////////
		public var smallMapLayer:SmallMapLayer; //小地图层
		public var mapLayer:MapLayer; //地图层
		public var bgEffectLayer:EffectLayer; //背景效果层
		public var spaceLayer:ElementLayer; //空间层
		public var earthLayer:EffectLayer; //地效层
		public var fgEffectLayer:EffectLayer; //前景效果层
		public var interactiveLayer:InteractiveLayer; //交互层
		public var mapConfig:MapConfig; //地图配置
		public var sceneCamera:SceneCamera; //摄像机
		public var sceneRender:SceneRender; //场景渲染
		public var mouseCharId:int = 20000;
		private var mouseChar:Animation; //鼠标点击地面动画
		[Bindable]
		public var selectedChar:SceneCharacter
		public var mainChar:SceneCharacter;
		public var mouseOnChar:SceneCharacter = null;
		public var id:int = -1;
		public var data:Object = null;
		public var container:Sprite = new Sprite();
		[Bindable]
		public var name:String = "";
		public var resId:int;

		private var _charPluginUpdateTimer:Timer; //用于更新SceneCharacter的plugins的计时器

		/**
		 * 场景类
		 */
		public function TScene()
		{
			this.smallMapLayer = new SmallMapLayer(this);
			container.addChild(smallMapLayer);
			this.mapLayer = new MapLayer(this);
			container.addChild(mapLayer);
			this.bgEffectLayer = new EffectLayer();
			container.addChild(bgEffectLayer);
			this.spaceLayer = new ElementLayer(this);
			container.addChild(spaceLayer);
			this.earthLayer = new EffectLayer();
			container.addChild(earthLayer);
			this.fgEffectLayer = new EffectLayer();
			container.addChild(fgEffectLayer);
			this.interactiveLayer = new InteractiveLayer(this);
			container.addChild(interactiveLayer);
			this.sceneRender = new SceneRender(this);
			this.sceneCamera = new SceneCamera(this.container);

			_charPluginUpdateTimer = new Timer(1000);
			_charPluginUpdateTimer.addEventListener(TimerEvent.TIMER, onCharPluginUpdate);
			_charPluginUpdateTimer.start();
		}

		public function enableInteractive():void
		{
			this.interactiveLayer.enableInteractive();
		}

		public function disableInteractive():void
		{
			this.interactiveLayer.disableInteractive();
		}

		private var _mapConfigLoader:MapConfigLoader;
		private var _onMapConfigLoadComplete:Function;
		private var _smallMapLoader:ImageItem;

		/********************************************场景加载********************************************/
		public function enterScene(name:String, mapId:int, resId:int, onComplete:Function = null, onProgress:Function = null):void
		{
			this.name = name;
			this.id = mapId;
			this.resId = resId;
			var scene:TScene;
			//发出场景切换事件
			this.disableInteractive();
			this.sceneRender.stopRender();
			this.selectedChar = null;
			this.dispose();
			if (_smallMapLoader)
			{
				_smallMapLoader.removeEventListener(Event.COMPLETE, onSmallMapLoadComplete);
			}
			if (_mapConfigLoader && _onMapConfigLoadComplete != null)
			{
				_mapConfigLoader.removeEventListener(Event.COMPLETE, _onMapConfigLoadComplete);
			}
			_mapConfigLoader = SceneConfigMananger.getMapConfigLoader(this.resId);
			if (_mapConfigLoader.isLoaded)
			{
				onMapConfigLoadComplete2(_mapConfigLoader.mapConfig);
				if (onComplete != null)
				{
					onComplete();
				}
			}
			else
			{
				_onMapConfigLoadComplete = function(e:Event):void
				{
					onMapConfigLoadComplete2(MapConfigLoader(e.currentTarget).mapConfig);
					if (onComplete != null)
					{
						onComplete();
					}
				}
				_mapConfigLoader.addEventListener(Event.COMPLETE, _onMapConfigLoadComplete);
			}
			scene = this;
		}

		private function onMapConfigLoadComplete2(mapConfig:MapConfig):void
		{
			this.mapConfig = mapConfig;
			this.mapLayer.reset(); //重置地图层
			loadSmallMap(resId);
			sceneCamera.setBound(mapConfig.width, mapConfig.height);
			interactiveLayer.setActiveArea(mapConfig.width, mapConfig.height);
			if (mainChar)
			{
				mainChar.stopWalk(false);
				sceneCamera.lookAt(mainChar);
				//添加主角到场景
				addCharacter(mainChar);
			}
			sceneRender.startRender(true);
			enableInteractive();
		}

		private function loadSmallMap(resId:int):void
		{
			var path:String = FilePathManager.getPath("scene/" + resId + "/thumb.jpg");
			_smallMapLoader = new ImageItem(new URLRequest(path), BulkLoader.TYPE_IMAGE, "");
			_smallMapLoader.addEventListener(Event.COMPLETE, onSmallMapLoadComplete);
			_smallMapLoader.load();
		}

		private function onSmallMapLoadComplete(e:Event):void
		{
			var bitmap:Bitmap = e.target.content as Bitmap;
			if (bitmap)
			{
				bitmap.width = mapConfig.width;
				bitmap.height = mapConfig.height;
				bitmap.smoothing = true;
				smallMapLayer.addChild(bitmap);
				signal.progress.smallMapLoaded.dispatch(bitmap.bitmapData, mapConfig.thumbScale);
			}
		}

		public function getMouseHit(mouseX:Number, mouseY:Number):BaseElement
		{
			var hitElements:Array = getObjectsUnderPoint(mouseX, mouseY);
			hitElements.sortOn("priority", Array.NUMERIC);
			return hitElements.pop();
		}

		public function getObjectsUnderPoint(mouseX:Number, mouseY:Number):Array
		{
			var element:BaseElement;
			var tempArr:Array = [];
			for each (element in elements)
			{
				if (element.isMouseHit)
				{
					tempArr.push(element);
				}
			}
			return tempArr;
		}
		/**************************************元件操作***********************************/
		/**
		 * 元件列表
		 * @default
		 */
		public var elements:Array = [];

		/**
		 * 添加元件
		 * @param element
		 */
		public function addElement(element:BaseElement):void
		{
			this.removeElementById(element.id, element.type);
			elements.push(element);
			this.spaceLayer.addElement(element);
		}

		/**
		 * 移除元件
		 * @param element
		 */
		public function removeElement(element:BaseElement):void
		{
			if (!(element == null))
			{
				this.spaceLayer.removeElement(element);
				if (element != mainChar)
				{
					element.dispose();
				}
				elements.splice(elements.indexOf(element), 1);
			}
		}

		public function removeElementById(id:int, type:int = -1):void
		{
			this.removeElement(this.getElementById(id, type));
		}

		public function removeElementsByType(type:int):void
		{
			getElementsByType(type).forEach(function(item:BaseElement, index:int, array:Array):void
			{
				removeElement(item);
			});
		}

		public function getElementById(id:int, type:int = -1):BaseElement
		{
			for (var i:int = 0; i != elements.length; i++)
			{
				if (elements[i].id == id && (type == -1 || elements[i].type == type))
					return elements[i];
			}
			return null;
		}

		public function getElementsByType(type:int):Array
		{
			return elements.filter(function(item:BaseElement, index:int, array:Array):Boolean
			{
				return item.usable && item.visible && item.type == (type & item.type);
			});
		}

		public function removeAllElement():void
		{
			while (elements.length != 0)
			{
				this.removeElement(elements[0]);
			}
		}
		//======================角色============================
		public var charList:Array = []; //角色数组
		public var renderCharList:Array = []; //渲染角色数组

		/**
		 * 根据ID获取角色
		 * @param guid
		 * @return
		 */
		public function getCharacterById(id:int):SceneCharacter
		{
			for (var i:int = 0; i != charList.length; i++)
			{
				if (charList[i].id == id)
					return charList[i];
			}
			return null;
		}

		/**
		 * 添加角色到场景
		 * @param gs
		 */
		public function addCharacter(gs:SceneCharacter):void
		{
			this.removeCharacterById(gs.id);
			charList.push(gs);
			this.addElement(gs);
			log.info("Add Character--count:{0}", charList.length);
		}

		/**
		 * 从场景中删除角色
		 * @param gs
		 */
		public function removeCharacter(sc:SceneCharacter):void
		{
			if (sc == null)
				return;
//			MoveHelper.stopMove(sc);
			if (this.selectedChar == sc)
			{
				this.selectedChar.hideSelectEffect();
				this.selectedChar = null;
			}
			charList.splice(charList.indexOf(sc), 1);
			this.removeElement(sc);
			log.info("Remove Character--count:{0}", charList.length);
		}

		/**
		 * 根据ID移出角色
		 * @param guid
		 */
		public function removeCharacterById(id:int):void
		{
			removeCharacter(this.getCharacterById(id));
		}

		/**
		 * 移除指定类型角色
		 * @param type
		 */
		public function removeCharsByType(type:int):void
		{
			getCharsbyType(type).forEach(function(item:SceneCharacter, index:int, array:Array):void
			{
				if (item != mainChar)
					removeCharacter(item);
			});
		}

		/**
		 * 移出所有角色
		 */
		public function removeAllCharacter():void
		{
			while (charList.length != 0)
			{
				this.removeCharacter(charList[0]);
			}
		}

		/**
		 * 根据类型获取角色列表
		 * @param scType
		 * @return
		 */
		public function getCharsbyType(scType:int):Array
		{
			return charList.filter(function(item:SceneCharacter, index:int, array:Array):Boolean
			{
				return item.usable && item.type == (scType & item.type) && item.getStatus() != Status.DEAD;
			});
		}

		//==================================动画=======================================
		/**
		 * 添加场景特效
		 * @param ani 动画
		 * @param fg 是否前景
		 */
		public function addEffect(displayObj:DisplayObject, fg:Boolean = true):void
		{
			if (fg)
			{
				this.fgEffectLayer.addEffect(displayObj);
			}
			else
			{
				this.bgEffectLayer.addEffect(displayObj);
			}
		}

		/**
		 *添加地效
		 * @param displayObj
		 *
		 */
		public function addEarthEffect(displayObj:DisplayObject):void
		{
			if (displayObj)
			{
				this.earthLayer.addChild(displayObj);
			}
		}

		/**
		 * 移除场景特效
		 * @param ani 动画
		 */
		public function removeEffect(ani:Animation):void
		{
			if (ani)
			{
				Animation.disposeAnimation(ani);
			}
		}

		public function showMouseChar(tileP:Point, error:Boolean = false):void
		{
			this.hideMouseChar();
			this.mouseChar = Animation.createAnimation(mouseCharId);
			this.mouseChar.type = AnimationType.Loop;
			if (error)
			{
				this.mouseChar.type = AnimationType.OnceTODispose;
				this.mouseChar.filters = [Geom.getColorFilter([0xff, 0x00, 0x00, 5])];
			}
			var p:Point = SceneUtil.Tile2Pixel(tileP);
			this.mouseChar.move(p.x, p.y);
			this.addEffect(this.mouseChar, false);
		}

		public function hideMouseChar():void
		{
			if (this.mouseChar)
			{
				Animation.disposeAnimation(this.mouseChar);
				this.mouseChar = null;
			}
		}

		/********************************************辅助类****************************************************/
		public function dispose():void
		{
			this.hideMouseChar();
			this.removeAllCharacter();
			this.removeAllElement();
			//清除地表层
			this.mapLayer.dispose();
			this.smallMapLayer.dispose();
			this.bgEffectLayer.dispose(); //背景效果层
			this.spaceLayer.dispose(); //空间层
			this.earthLayer.dispose(); //地效层
			this.fgEffectLayer.dispose(); //前景效果层
			this.optimize();
		}

		/**
		 * 屏幕震动
		 * @param duration 持续时间 单位:秒
		 * @param intensity 强度
		 */
		public function shake(duration:Number = 0.3, intensity:int = 50):void
		{
//			this.sceneCamera.shake(duration, intensity);
		}

		public function resize(w:Number, h:Number):void
		{
			this.sceneCamera.resize(w, h);
		}
		///////////////////////////////////////事件///////////////////////////////////////////////////////////
		private var _signal:SceneSignal = null;

		public function get signal():SceneSignal
		{
			return _signal ||= new SceneSignal();
		}

		///////////////////////////////////////资源管理//////////////////////////////////////////////////////////
		public function optimize():void
		{
			SceneCache.optimize();
			Fun.gc();
		}
		
		/**
		 * 设置场景禁/启用
		 * @param value
		 * 
		 */		
		public function set enabled(value:Boolean):void
		{
			container.mouseEnabled = value;
			container.mouseChildren = value;
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 角色Plugin更新
		 * @param event
		 *
		 */
		private function onCharPluginUpdate(event:TimerEvent):void
		{
			for each (var char:SceneCharacter in charList)
			{
				char.updatePlugin();
			}
		}
	}
}
