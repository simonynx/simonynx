package tempest.engine.staticdata
{

	/**
	 * 行为动作
	 * @author wushangkun
	 */
	public final class Status
	{
		/**
		 * 待机
		 * @default
		 */
		public static const STAND:int = 0;
		/**
		 * 行走
		 * @default
		 */
		public static const WALK:int = 1;
		/**
		 * 攻击
		 * @default
		 */
		public static const ATTACK:int = 2;
		/**
		 * 受伤
		 * @default
		 */
		public static const INJURE:int = 3;
		/**
		 * 死亡
		 * @default
		 */
		public static const DEAD:int = 4;
		/**
		 * 冥想
		 * @default
		 */
		public static const MUSE:int = 5;

		/**
		 * 是否只循环一次
		 * @param action
		 * @return
		 */
		public static function isLoopOnce(status:int):Boolean
		{
			return (!((status == STAND) || (status == WALK) /*|| (status == MUSE)*/));
		}
	}
}
