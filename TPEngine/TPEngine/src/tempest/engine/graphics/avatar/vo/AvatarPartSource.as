package tempest.engine.graphics.avatar.vo
{
	import flash.geom.Rectangle;
	import tempest.common.logging.*;
	import tempest.core.IDisposable;
	import tempest.engine.graphics.TPBitmap;
	import tempest.engine.staticdata.Status;

	public class AvatarPartSource implements IDisposable
	{
		private static const log:ILogger = TLog.getLogger(AvatarPartSource);
		public static const DEFAULT_WIDTH:Number = 350; //默认宽度
		public static const DEFAULT_HEIGHT:Number = 350; //默认高度
		private var bitmaps:Object = {};
		private var _key:String;
		private var _width:Number;
		private var _height:Number;
		private var _head_offset:Number;
		private var _center_offset:Number;
		private var _body_offset:Number;
		private var _refNum:int = 0;
		private var _rect:Rectangle;

		public function get rect():Rectangle
		{
			return _rect ||= new Rectangle();
		}

		public function get refNum():int
		{
			return _refNum;
		}

		public function get key():String
		{
			return _key;
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}

		public function get head_offset():Number
		{
			return _head_offset;
		}

		public function get center_offset():Number
		{
			return _center_offset;
		}

		public function get body_offset():Number
		{
			return _body_offset;
		}

		/**
		 *
		 * @param key ket
		 * @param w width
		 * @param h height
		 * @param ho head_offset
		 * @param co center_offset
		 * @param bo body_offset
		 */
		public function AvatarPartSource(key:String, w:Number = NaN, h:Number = NaN, ho:Number = NaN, co:Number = NaN, bo:Number = NaN)
		{
			_key = key;
			_width = isNaN(w) ? DEFAULT_WIDTH : w;
			_height = isNaN(h) ? DEFAULT_HEIGHT : h;
			_head_offset = ho;
			_center_offset = co;
			_body_offset = bo;
		}

		public function add(id:String, bm:TPBitmap):TPBitmap
		{
			if (bm)
			{
				bitmaps[id] = bm;
				var rect:Rectangle = bm.getRect();
				if (_rect == null || _rect.isEmpty())
				{
					_rect = rect.clone();
				}
				else
				{
					if (rect.left < _rect.left)
					{
						_rect.left = rect.left;
					}
					if (rect.right > _rect.right)
					{
						_rect.right = rect.right;
					}
					if (rect.top < _rect.top)
					{
						_rect.top = rect.top;
					}
					if (rect.bottom > _rect.bottom)
					{
						_rect.bottom = rect.bottom;
					}
				}
			}
			return bm;
		}

		public function get(status:int, dir:int, frame:int):TPBitmap
		{
			var $dir:int = dir;
			if (status == Status.DEAD)
			{
				if (dir % 2 == 0)
				{
					$dir = dir + 1;
				}
			}
			var key:String = status + "-" + $dir + "-" + frame;
			var bitmap:TPBitmap = bitmaps[key];
			if (bitmap == null && $dir > 4)
			{
				var key2:String = status + "-" + (8 - $dir) + "-" + frame;
				bitmap = bitmaps[key2];
				if (bitmap)
				{
					bitmap = this.add(key, bitmap.getYMI(_width));
				}
			}
			if (bitmap == null)
			{
				log.warn("error key or source error?key:{0} path:{1}", key, _key);
			}
			return bitmap;
		}

		private function needYMI(dir:int):Boolean
		{
			return dir > 4;
		}

		public function allocate():AvatarPartSource
		{
			_refNum++;
			return this;
		}

		public function release():void
		{
			_refNum--;
		}

		public function dispose():void
		{
			var bitmap:TPBitmap;
			for each (bitmap in bitmaps)
			{
				bitmap.dispose();
			}
		}
	}
}
