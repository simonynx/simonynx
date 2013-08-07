package fj1.common.ui.animation
{
	import flash.display.BitmapData;

	import tempest.engine.graphics.moivce.BitmapFrameInfo;

	/**
	 * 为BitmapAnimation提供播放动画所需资源
	 * @author linxun
	 *
	 */
	public interface IBitmapAnimationRes
	{
		/**
		 * 总帧数
		 * @return
		 *
		 */
		function get totalFrames():int;
		/**
		 * 获取某帧的动画资源
		 * @param frame 帧
		 * @return
		 *
		 */
		function getBitmapData(frame:int):BitmapFrameInfo;
		/**
		 * 滤镜
		 * @return
		 *
		 */
		function get filters():Array;
	}
}
