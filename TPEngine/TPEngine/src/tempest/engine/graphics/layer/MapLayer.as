package tempest.engine.graphics.layer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.core.IDisposable;
	import tempest.engine.SceneRender;
	import tempest.engine.TScene;
	import tempest.engine.core.IRunable;
	import tempest.engine.vo.config.SceneConfig;
	import tempest.utils.Fun;
	import tempest.utils.ListenerManager;
	
	import tpe.manager.FilePathManager;
	
	/**
	 * 切片图
	 * @author wushangkun
	 */
	public class MapLayer extends Sprite implements IDisposable, IRunable
	{
		private static const log:ILogger = TLog.getLogger(MapLayer, TLog.LEVEL_INFO);
		/**
		 * 地图图片加载
		 * @default
		 */
		private static var _updateTime:int = 0;
		private var _scene:TScene;
		private var _current:Rectangle = new Rectangle();
		private var _last:Rectangle = new Rectangle();
		private var _zone_x_max:int = 0;
		private var _zone_y_max:int = 0;
		private var _loader:BulkLoader = new BulkLoader("mapLayer");
		private var _map:Bitmap;	//整张地图
		private var _pointDic:Dictionary;//切片坐标数组
		private var _mapData:BitmapData;
		private var _listenerManager:ListenerManager;
		/**
		 * 切片图
		 * @param actualWidth 实际宽
		 * @param actualHeight 实际高
		 * @param zoneWidth 切片宽
		 * @param zoneHeight 切片高
		 * @param pathBuilder
		 * @param pre_x
		 * @param pre_y
		 * @param loadDelay
		 */
		public function MapLayer(scene:TScene)
		{
			this._scene = scene;
			_listenerManager = new ListenerManager();
			this.tabChildren = this.tabEnabled = this.mouseChildren = this.mouseEnabled = false;
		}
		
		public function reset():void
		{
			//重新设置地图大小并加到舞台
			_mapData = new BitmapData(_scene.mapConfig.width, _scene.mapConfig.height, true, 0x00ffffff);
			_map = new Bitmap(_mapData);
			_map.width = _scene.mapConfig.width;
			_map.height = _scene.mapConfig.height;
			this.addChild(_map);
			_zone_x_max = Math.max(((this._scene.mapConfig.width / SceneConfig.ZONE_WIDTH) >> 0) - 1, 0);
			_zone_y_max = Math.max(((this._scene.mapConfig.height / SceneConfig.ZONE_HEIGHT) >> 0) - 1, 0);
		}
		
		public function run(diff:int):void
		{
			if (SceneRender.nowTime - _updateTime < SceneConfig.MAP_UPDATE_DELAY)
				return;
			_updateTime = SceneRender.nowTime;
			//取可视区域
			var clip:Rectangle = this._scene.sceneCamera.rect;
			//中心x
			var cx:int = (clip.left + clip.width * 0.5) / SceneConfig.ZONE_WIDTH;
			//中心Y
			var cy:int = (clip.top + clip.height * 0.5) / SceneConfig.ZONE_HEIGHT;
			//计算加载的开始点和结束点
			_current.left = Math.max((clip.left / SceneConfig.ZONE_WIDTH - SceneConfig.ZONE_PRE_X) >> 0, 0)
			_current.top = Math.max((clip.top / SceneConfig.ZONE_HEIGHT - SceneConfig.ZONE_PRE_Y) >> 0, 0);
			_current.right = Math.min((clip.right / SceneConfig.ZONE_WIDTH + SceneConfig.ZONE_PRE_X) >> 0, _zone_x_max);
			_current.bottom = Math.min((clip.bottom / SceneConfig.ZONE_HEIGHT + SceneConfig.ZONE_PRE_Y) >> 0, _zone_y_max);
			//判断是否变化
			if (_current.isEmpty() || _current.equals(_last))
			{
				return;
			}
			var _lastIsEmpty:Boolean = _last.isEmpty();
			var xx:int;
			var yy:int;
			var key:String;
			var item:LoadingItem;
			//计算隐藏的部分
			if (!_lastIsEmpty)
			{
				for (xx = _last.left; xx <= _last.right; xx++) //行
				{
					for (yy = _last.top; yy <= _last.bottom; yy++) //列
					{
						if (!_current.contains(xx, yy)) //减少
						{
							key = yy + "_" + xx;
							item = _loader.get(key);
							if (item && !item._isLoading)
							{
								item._priority = -((cx - xx) * (cx - xx) + (cy - yy) * (cy - yy))*100;
							}
						}
					}
				}
			}
			//计算新增的部分
			for (xx = _current.left; xx <= _current.right; xx++) //行
			{
				for (yy = _current.top; yy <= _current.bottom; yy++) //列
				{
					if (_lastIsEmpty || !_last.contains(xx, yy)) //增加
					{
						key = yy + "_" + xx;
						item = _loader.get(key);
						if (item)
						{
							if( !item._isLoading)
							{
								item._priority = -((cx - xx) * (cx - xx) + (cy - yy) * (cy - yy))*100;
							}
							continue;
						}
						//添加到加载
						item = _loader.add(FilePathManager.getPath("scene/" + _scene.resId + "/maps", key + ".jpg"), {id:key});
						_listenerManager.addEventListener(item, Event.COMPLETE, loaderHandler);
						_pointDic[item] = {x: xx * SceneConfig.ZONE_WIDTH, y: yy * SceneConfig.ZONE_HEIGHT};
						item._priority = -((cx - xx) * (cx - xx) + (cy - yy) * (cy - yy))*100;
						_loader.sortItemsByPriority();
						_loader.start();
					}
				}
			}
			//排序加载
			_loader.sortItemsByPriority();
			//保存当前记录
			_last.left = _current.left;
			_last.top = _current.top;
			_last.right = _current.right;
			_last.bottom = _current.bottom;
		}
		
		/**
		 * 默认监听回调
		 * @param e
		 */
		private function loaderHandler(evt:Event):void
		{
			var item:LoadingItem = evt.target as LoadingItem;
			var bp:Bitmap = item.content as Bitmap;
			var destPoint:Point = new Point(_pointDic[item].x, _pointDic[item].y);
			if(_map.bitmapData)
				_map.bitmapData.copyPixels(bp.bitmapData, new Rectangle(0, 0, SceneConfig.ZONE_WIDTH, SceneConfig.ZONE_HEIGHT), destPoint);
		}
		
		public function dispose():void
		{
			_updateTime = 0;
			_listenerManager.removeAll();
			_loader.removeAll();
			_last = new Rectangle();
			_pointDic = new Dictionary();
			if(_map && _map.bitmapData)
				_map.bitmapData.dispose();
			Fun.removeAllChildren(this, true, true, true);
		}
	}
}
import tempest.common.logging.ILogger;
import tempest.common.logging.TLog;