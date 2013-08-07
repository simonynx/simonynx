package fj1.common.staticdata
{

	public class SpellTargetType
	{
		/**
		 * 自身
		 */
		public static const SpellTargetType_Self:int = 1;
		/**
		 * 友方目标
		 */
		public static const SpellTargetType_Friend:int = 2;
		/**
		 * 敌方目标
		 */
		public static const SpellTargetType_Enemy:int = 3;
		/**
		 * 自身或友方目标
		 */
		public static const SpellTargetType_SelfOrFriend:int = 4;
		/**
		 * 友方或敌方目标
		 */
		public static const SpellTargetType_FriendOrEnemy:int = 5;
		/**
		 * 非掩码地面
		 */
		public static const SpellTargetType_EARN:int = 6;
		/**
		 *组队的队友
		 */
		public static const SpellTargetType_TeamMember:int = 7;
		/**
		 * 非人类目标
		 */
		public static const SpellTargetType_NPC:int = 8;
	}
}
