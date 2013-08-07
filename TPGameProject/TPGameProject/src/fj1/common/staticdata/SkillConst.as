package fj1.common.staticdata
{
	import flash.geom.Point;

	public class SkillConst
	{
		/**
		 * 单体
		 */
		public static var AREA_TYPE_SINGE:int=1;
		/**
		 *群攻
		 */
		public static var AREA_TYPE_MUTI:int=2;
		/**
		 *原点
		 */
		public static var ZERO_POINT:Point=new Point(0, 0);
		/////////////个位
		/**
		 *null
		 */
		public static var SPECIAL_TYPE_NULL:int=0;
		/**
		 * 冲锋
		 */
		public static var SPECIAL_TYPE_ASSAULT:int=1;
		/**
		 * 瞬移
		 */
		public static var SPECIAL_TYPE_BLINKMOVE:int=2;
		/**
		 * 特殊伤害结算
		 */
		public static var SPECIAL_TYPE_SPECIDEMAGE:int=3;
		/**
		 *目标为友方治疗目标为敌方
		 */
		public static var SPECIAL_TYPE_TARGETDAMAGECURE:int=4;
		/**
		 * 暴怒连打
		 */
		public static var SPECIAL_TYPE_HAYMARKBEAT:int=5;
		/**
		 *设置蓄力状态
		 */
		public static var SPECIAL_TYPE_ANGER_STATUS:int=6;
		/**
		 *设置技能点数连击的技能
		 */
		public static var SPECIAL_TYPE_SEQ_ATK:int=7;
		/**
		 *穿越障碍
		 */
		public static var SPECAIL_CROSS_BLOCK:int=8;
		///////////////十位
		/**
		 *特殊神力伤害技能结算
		 */
		public static var SPECIAL_TYPE_SPECIGODDEAMGE:int=1;
		////////////////////技能类型/////////
		/**
		  *普通攻击
		  */
		public static const SPELL_NORMAL:int=0;
		/**
		 *职业技能
		 */
		public static const SPELL_PROFRESSION:int=1;
		/**
		 *公会技能
		 */
		public static const SPELL_GUILD:int=2;
		/**
		 * 采集技能
		 */
		public static const SPELL_COLLECT:int=3;
		/**
		 *跳跃技能
		 */
		public static const SPELL_JUMP:int=5;
		////////////////////////////////技能学习状态
		/**
		 * 尚未习得
		 */
		public static const UNLEARNED:int=0;
		/**
		 * 可学习
		 */
		public static const CANLEARNED:int=1;
		/**
		 * 已学习
		 */
		public static const LEARNED:int=2;
		/**
		 * 可升级
		 */
		public static const CANUPGRADE:int=3;
		////////////////////////////////技能品质/////////
		/**
		 *近战单攻
		 */
		public static const SHORT_SINGLE:int=1;
		/**
		 * 远程单攻
		 */
		public static const RANGE_SINGLE:int=2;
		/**
		 * 近战群攻
		 */
		public static const SHORT_AREA:int=3;
		/**
		 * 远程群攻
		 */
		public static const RANGE_AREA:int=4;

	}

}
