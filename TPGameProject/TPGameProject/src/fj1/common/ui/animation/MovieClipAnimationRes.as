package fj1.common.ui.animation
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import tempest.engine.graphics.moivce.BitmapFrameInfo;
	import tempest.engine.tools.BitmapCacher;

	/**
	 * 普通影片剪辑类的资源
	 * @author linxun
	 *
	 */
	public class MovieClipAnimationRes implements IBitmapAnimationRes
	{
		private var _mc_base:*;
		private var _imgBuffer:Vector.<BitmapFrameInfo>;

		public function MovieClipAnimationRes(res:*)
		{
			_mc_base = res;
		}

		public function get totalFrames():int
		{
			return _mc_base.totalFrames;
		}

		public function getBitmapData(frame:int):BitmapFrameInfo
		{
			if (!_imgBuffer)
			{
				_imgBuffer = BitmapCacher.cacheBitmapMovie(_mc_base, true, 0xcccccc);
			}
			return _imgBuffer[frame - 1];
		}

		public function get filters():Array
		{
			return _mc_base.filters;
		}
	}
}
