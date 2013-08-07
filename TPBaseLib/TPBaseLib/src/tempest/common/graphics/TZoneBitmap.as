package tempest.common.graphics
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.osflash.signals.natives.base.SignalSprite;
	import tempest.common.handler.HandlerThread;
	import tempest.common.logging.*;
	import tempest.core.IDisposable;
	import tempest.utils.Fun;

	/**
	 * 切片图
	 * @author wushangkun
	 */
	public class TZoneBitmap extends SignalSprite implements IDisposable
	{
		private static const log:ILogger = TLog.getLogger(TZoneBitmap, TLog.LEVEL_INFO);
		private var _clip:Rectangle = new Rectangle();
		private var _current:Rectangle = new Rectangle();
		private var _last:Rectangle = new Rectangle();
		private var _actualWidth:Number;
		private var _actualHeight:Number;
		private var _zoneWidth:Number;
		private var _zoneHeight:Number;
		private var _zone_pre_x:int = 1;
		private var _zone_pre_y:int = 1;
		private var _fillZones:Object = {};
		private var _loadDelay:Number = 100;
		private var _loadThread:HandlerThread = new HandlerThread();
		private var _empty:Boolean = true;
		private var _pathFunc:Function = null;
		private var _thumbUrl:String = null;
		private var _id:String = "";
		private var _type:String = "";

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
		public function TZoneBitmap(actualWidth:Number = 0, actualHeight:Number = 0, zoneWidth:Number = 200, zoneHeight:Number = 200, pre_x:int = 1, pre_y:int = 1, loadDelay:int = 100, type:String = "jpg")
		{
			super();
			this._actualWidth = actualWidth;
			this._actualHeight = actualHeight;
			this._zoneWidth = zoneWidth;
			this._zoneHeight = zoneHeight;
			this._zone_pre_x = pre_x;
			this._zone_pre_y = pre_y;
			this._loadDelay = loadDelay;
			this.tabChildren = this.tabEnabled = this.mouseChildren = this.mouseEnabled = false;
		}

		public function get actualWidth():Number
		{
			return _actualWidth;
		}

		public function get actualHeight():Number
		{
			return _actualHeight;
		}

		/**
		 * 获取/设置可视区域
		 * @return
		 */
		public function get clip():Rectangle
		{
			return _clip;
		}

		public function set clip(value:Rectangle):void
		{
			if (value && !_clip.equals(value))
			{
				_clip.x = value.x;
				_clip.y = value.y;
				_clip.width = value.width;
				_clip.height = value.height;
				this.draw();
			}
		}

		/**
		 * 设置真实尺寸
		 * @param w
		 * @param h
		 */
		public function setActualSize(w:Number, h:Number):void
		{
			this._actualWidth = w;
			this._actualHeight = h;
			this.draw();
		}

		private function draw():void
		{
			if (_actualWidth <= 0 || _actualHeight <= 0)
				return;
			var cx:int = (_clip.left + _clip.width * 0.5) / _zoneWidth;
			var cy:int = (_clip.top + _clip.height * 0.5) / _zoneHeight;
			//计算加载的开始点和结束点
			_current.left = Math.max(Math.ceil(_clip.left / _zoneWidth) - 1 - _zone_pre_x, 0)
			_current.top = Math.max(Math.ceil(_clip.top / _zoneHeight) - 1 - _zone_pre_y, 0);
			_current.right = Math.min(Math.ceil(_clip.right / _zoneWidth) - 1 + _zone_pre_x, Math.ceil(_actualWidth / _zoneWidth) - 1);
			_current.bottom = Math.min(Math.ceil(_clip.bottom / _zoneHeight) - 1 + _zone_pre_y, Math.ceil(_actualHeight / _zoneHeight) - 1);
			//判断是否变化
			if (_current.isEmpty() || _current.equals(_last))
			{
				return;
			}
			var _lastIsEmpty:Boolean = _last.isEmpty();
			var xx:int;
			var yy:int;
			var key:String;
			//计算隐藏的部分
//			if (!_lastIsEmpty)
//			{
//				for (i = _last.left; i <= _last.right; i++) //行
//				{
//					for (j = _last.top; j <= _last.bottom; j++) //列
//					{
//						if (!_current.contains(i, j)) //减少
//						{
//						}
//					}
//				}
//			}
			//计算新增的部分
			var adds:Array = [];
			for (xx = _current.left; xx <= _current.right; xx++) //行
			{
				for (yy = _current.top; yy <= _current.bottom; yy++) //列
				{
					if (_lastIsEmpty || !_last.contains(xx, yy))
					{
						//增加
						key = yy + "_" + xx;
						if (_fillZones.hasOwnProperty(key))
						{
							continue;
						}
						adds.push({key: key, d: (xx - cx) * (xx - cx) + (yy - cy) * (yy - cy), x: xx, y: yy});
					}
				}
			}
			addBMPs(adds);
			//保存当前记录
			_last.left = _current.left;
			_last.top = _current.top;
			_last.right = _current.right;
			_last.bottom = _current.bottom;
		}

		private function addBMPs(bmps:Array):void
		{
			if (_pathFunc == null)
			{
				_last.setEmpty();
				return;
			}
			bmps.sortOn("d", Array.NUMERIC);
			var l:int = bmps.length;
			for (var i:int = 0; i != l; i++)
			{
				var bitmap:TBitmap = new TBitmap();
				var u:String = _pathFunc(_id, bmps[i].key + "." + _type);
				_loadThread.push(bitmap.load, [u], _loadDelay, true, true);
				bitmap.x = bmps[i].x * _zoneWidth;
				bitmap.y = bmps[i].y * _zoneHeight;
				this.addChild(bitmap);
				_fillZones[bmps[i].key] = true;
				log.debug("加载切片 key:" + u);
			}
		}

		public function load(pathFun:Function, id:String, thumbUrl:String = null, type:String = "jpg", w:Number = 0, h:Number = 0, gc:Boolean = false):void
		{
			if (pathFun == null || (_id == id && _type == type))
			{
				return;
			}
			this.unload(gc);
			_pathFunc = pathFun;
			_thumbUrl = thumbUrl;
			_id = id;
			_type = type;
			if (w != 0)
				this._actualWidth = w;
			if (h != 0)
				this._actualHeight = h;
			_empty = false;
			this.draw();
		}

		public function unload(gc:Boolean = false):void
		{
			if (_empty)
				return;
			_pathFunc = null;
			_thumbUrl = null
			_id = "";
			_last = new Rectangle();
			_loadThread.removeAllHandlers();
			_fillZones = {};
			Fun.removeAllChildren(this, true, true, true);
			_empty = true;
			if (gc)
				Fun.gc();
		}

		public function dispose():void
		{
			this.unload();
		}
	}
}
