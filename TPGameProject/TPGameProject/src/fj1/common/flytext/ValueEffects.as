package fj1.common.flytext
{

	/**
	 *
	 * @author wushangkun
	 */
	public class ValueEffects
	{
		//技能枚举
		/**
		 * 无效
		 * @default
		 */
		public static const Unknown:int = -1;
		/**
		 * 无
		 * @default
		 */
		public static const None:int = 0x00;
		/**
		 * 普通伤害
		 * @default
		 */
		public static const Decrease:int = 0x01;
		/**
		 * 暴击
		 * @default
		 */
		public static const Double:int = 0x02;
		/**
		 * 丢未命中
		 * @default
		 */
		public static const Failure:int = 0x04;
		/**
		 * 普通增加
		 * @default
		 */
		public static const Increase:int = 0x08;
		/**
		 * 加倍治疗
		 * @default
		 */
		public static const MultiIncrease:int = 0x10;
		/**
		 * 死亡
		 * @default
		 */
		public static const Death:int = 0x20;
		/**
		 *多重伤害
		 */
		public static const MultipleDamage:int = 0x40;
		/**
		 *击退
		 */
		public static const SpellEffectFlag_BeatBack:int = 0x80;
		/**
		 *技能名称飘字
		 */
		public static const Spell_Name:int = 0xF0;
		/**
		 *伤害吸收
		 */
		public static const Miss_Damage:int = 0x100;
		/**
		 * 抵挡 
		 */		
		public static const Defend:int = 0x200;
		/**
		 * 反击 
		 */		
		public static const CounterAttack:int = 0x400;
		/**
		 * 闪避 
		 */		
		public static const Dodge:int = 0x800;
		/////////////////////////////////状态提示文字///////////////////////////////////////////////////
		/**
		 * 状态加血
		 */
		public static const STATUS_EFFECT_TYPE:int = 200;
		/**
		 * 状态加血
		 */
		public static const STATUS_EFFECT_TYPE_HP:int = 207;
		/**
		 * 状态加蓝
		 */
		public static const STATUS_EFFECT_TYPE_MP:int = 208;
		/**
		 * 状态加信仰值
		 */
		public static const STATUS_EFFECT_TYPE_BELIEF:int = 209;
		/**
		 *经验增加
		 */
		public static const STATUS_EEFECT_TYPE_EXP:int = 210;
		/**
		 *获得攻击属性
		 */
		public static const STATUS_EEFECT_TYPE_ATTACK_POINT:int = 211;
		/**
		 *获得技能
		 */
		public static const STATUS_EFFECT_TYPE_SPELL:int = 212;
		/**
		 *获得声望
		 */
		public static const STATUS_EFFECT_TYPE_REWARD:int = 213;
		/**
		 * 防
		 */
		public static const STATUS_EFFECT_TYPE_DEFANSE_POINT:int = 214;
		/**
		 * 体
		 */
		public static const STATUS_EFFECT_TYPE_BODY_POINT:int = 215;
		/**
		 * 敏
		 */
		public static const STATUS_EFFECT_TYPE_DELICTY_POINT:int = 216;
		/**
		 * 神力
		 */
		public static const STATUE_EFFECT_TYPE_GODPOWER:int = 217;
		/**
		 *生命上限
		 */
		public static const STATUE_EFFECT_TYPE_HPMAX:int = 218;
		/**
		 *魔法上限
		 */
		public static const STATUE_EFFECT_TYPE_MANAMAX:int = 219;
		/**
		 *攻击力
		 */
		public static const STATUE_EFFECT_TYPE_ATTACK:int = 220;
		/**
		 *防御力
		 */
		public static const STATUE_EFFECT_TYPE_DEFINSE:int = 221;
		/**
		 *破甲
		 */
		public static const STATUE_EFFECT_TYPE_BROKEN:int = 222;
		/**
		 *灵巧
		 */
		public static const STATUE_EFFECT_TYPE_DELICACY:int = 223;
		/**
		 *暴击
		 */
		public static const STATUE_EFFECT_TYPE_HEYMAKER:int = 224;
		/**
		 *白魔法力
		 */
		public static const STATUE_EFFECT_TYPE_WHITE_MAGIC:int = 225;
		/**
		 *黑魔法力
		 */
		public static const STATUE_EFFECT_TYPE_BLACK_MAGIC:int = 226;
		/**
		 *青魔法力
		 */
		public static const STATUE_EFFECT_TYPE_BLUE_MAGIC:int = 227;
		/**
		 *血魔法力
		 */
		public static const STATUE_EFFECT_TYPE_RED_MAGIC:int = 228;
		/////////////////////////////角色状态提示文字////////////////////////////////////
		/**
		 *退出战斗状态
		 */
		public static const STATE_BEGIN_FIGHT:int = 101;
		/**
		 *进入战斗
		 */
		public static const STATE_EXIT_FIGHT:int = 102;
	}
}
