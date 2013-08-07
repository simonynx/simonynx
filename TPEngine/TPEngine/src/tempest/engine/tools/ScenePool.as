package tempest.engine.tools
{
	import tempest.common.pool.Pool;
	import tempest.manager.PoolManager;

	public class ScenePool
	{
		/**
		 *动画对象池
		 */
		public static const animationPool:Pool = PoolManager.creatPool("animationPool", 300);
		/**
		 *普通飞行文字池
		 */
		public static const flyTextPool:Pool = PoolManager.creatPool("flyTextPool", 200);
		/**
		 * avatar部件
		 * @default
		 */
		public static const avatarPartPool:Pool = PoolManager.creatPool("avatarPartPool", 800);
	}
}
