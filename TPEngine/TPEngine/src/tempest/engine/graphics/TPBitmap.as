package tempest.engine.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import tempest.core.IDisposable;

	public class TPBitmap implements IDisposable
	{
		public var bitmapData:BitmapData;
		public var offset_x:int;
		public var offset_y:int;

		public function TPBitmap(bitmapData:BitmapData = null, offsetX:int = 0, offsetY:int = 0):void
		{
			this.bitmapData = bitmapData;
			this.offset_x = offsetX;
			this.offset_y = offsetY;
		}

		/**
		 * 获取Y轴镜像
		 * @param w 图像原始宽
		 * @return 返回Y轴镜像
		 */
		public function getYMI(w:int):TPBitmap
		{
			var bd:BitmapData = new BitmapData(this.bitmapData.width, this.bitmapData.height, this.bitmapData.transparent, 0x0);
			bd.draw(this.bitmapData, new Matrix(-1, 0, 0, 1, bd.width));
			return new TPBitmap(bd, w - offset_x - bd.width, offset_y);
		}

		public function draw(bd:BitmapData):void
		{
			bd.draw(bitmapData, new Matrix(1, 0, 0, 1, offset_x, offset_y));
		}

		public function drawYMI(bd:BitmapData):void
		{
			bd.draw(bitmapData, new Matrix(-1, 0, 0, 1, bd.width - offset_x, offset_y));
		}

		public function updateBM(bm:Bitmap, rpX:int = 0, rpY:int = 0):void
		{
			if (bm.bitmapData == this.bitmapData)
			{
				return;
			}
			bm.x = offset_x - rpX;
			bm.y = offset_y - rpY;
			bm.bitmapData = this.bitmapData;
		}

		public function getRect():Rectangle
		{
			return new Rectangle(offset_x, offset_y, bitmapData.width, bitmapData.height);
		}

		public function dispose():void
		{
			if (this.bitmapData)
			{
				this.bitmapData.dispose();
				this.bitmapData = null;
			}
		}
	}
}
