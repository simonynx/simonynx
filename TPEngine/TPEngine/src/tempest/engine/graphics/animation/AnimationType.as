package tempest.engine.graphics.animation
{

	/**
	 * 动画类型
	 * @author wushangkun
	 */
	public class AnimationType
	{
		/**
		 * 播放一次
		 * @default
		 */
		public static const Once:int = 0;
		/**
		 * 播放一次并销毁
		 * @default
		 */
		public static const OnceTODispose:int = 1;
		/**
		 * 循环播放
		 * @default
		 */
		public static const Loop:int = 2;
	}
}
