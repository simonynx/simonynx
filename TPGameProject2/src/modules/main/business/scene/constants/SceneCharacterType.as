package modules.main.business.scene.constants
{

	/**
	 * 角色类型
	 * @author wushangkun
	 */
	public final class SceneCharacterType
	{
		/**
		 * 玩家
		 * @default
		 */
		public static const PLAYER:int = 1;
		/**
		 * 怪物
		 * @default
		 */
		public static const MONSTER:int = 2;
		/**
		 * NPC
		 * @default
		 */
		public static const NPC:int = 4;
		/**
		 * 传送点
		 * @default
		 */
		public static const TRANSPORT:int = 8;
		/**
		 * 魔法阵
		 * @default
		 */
		public static const MAGICWARD:int = 16;
		/**
		 *宠物
		 */
		public static const PET:int = 32;
		/**
		 * 掉落物品
		 * @default
		 */
		public static const DROP_ITEM:int = 64;
		/**
		 *采集物品
		 */
		public static const COLLECT_ITEM:int = 128;

		/**
		 * 获取鼠标层次优先级
		 * @param type
		 * @return
		 */
		public static function getPriority(type:int):int
		{
			switch (type)
			{
				case NPC:
					return 100;
				case MAGICWARD:
					return 99;
				case DROP_ITEM:
					return 98;
				default:
					return 0;
			}
		}
	}
}
