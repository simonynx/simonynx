package fj1.common.ui.animation
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import tempest.engine.graphics.moivce.BitmapFrameInfo;

	/**
	 * 品质效果动画资源
	 * @author linxun
	 *
	 */
	public class QualityAnimationRes implements IBitmapAnimationRes
	{
		private var _mc_base:MovieClip;
		private var _bmDataBuffer:Vector.<BitmapFrameInfo>;
		private var _totalFrames:int;

		public function QualityAnimationRes(mc:MovieClip)
		{
			_mc_base = mc;
			_mc_base.stop();
			//totalFrames
			var mainMC:MovieClip = _mc_base.getChildAt(0) as MovieClip;
			_totalFrames = mainMC ? mainMC.totalFrames : 1;
			_bmDataBuffer = new Vector.<BitmapFrameInfo>(_totalFrames);
		}

		public function get totalFrames():int
		{
			return _totalFrames;
		}

		/**
		 * 将当前帧的四个影片剪辑draw到一张BitmapData上，并缓存
		 * @param frame
		 * @return
		 *
		 */
		public function getBitmapData(frame:int):BitmapFrameInfo
		{
			var fInfo:BitmapFrameInfo = _bmDataBuffer[frame - 1];
			if (!fInfo)
			{
				fInfo = new BitmapFrameInfo();
				var bmData:BitmapData = new BitmapData(_mc_base.width, _mc_base.height, true, 0x00FFFFFF);
				for (var i:int = 0; i < _mc_base.numChildren; ++i)
				{
					var child:DisplayObject = _mc_base.getChildAt(i);
					if (child is MovieClip)
					{
						(child as MovieClip).gotoAndStop(frame);
					}
//					var rect:Rectangle = child.getRect(_mc_base);
					var matrix:Matrix = new Matrix();
					matrix.rotate(child.rotation / 180 * Math.PI);
					matrix.tx = child.x; //rect.left;
					matrix.ty = child.y; //rect.top;
					bmData.draw(child, matrix, null, child.blendMode);
				}
				//
				fInfo.bitmapData = bmData;
				_bmDataBuffer[frame - 1] = fInfo;
			}
			return fInfo;
		}

		public function get filters():Array
		{
			return null;
		}
	}
}
