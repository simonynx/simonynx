package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;

	/**
	 * 职业
	 * @author wushangkun
	 */
	public final class Profession
	{
		public static const None:int = 0; //无
		/**
		 * 角斗士
		 */
		public static const Gladiator:int = 1;
		/**
		 * 暗法师
		 */
		public static const DarkMage:int = 2;
		/**
		 * 月神使
		 */
		public static const Luna:int = 3;
		/**
		 * 复仇者
		 */
		public static const Avenger:int = 4;
		/**
		 *全职业
		 */
		public static const ALL_PROFESSION:int = 5;
		/**
		 * 男
		 */
		public static const SEX_BOY:int = 1;
		/**
		 * 女
		 */
		public static const SEX_GIRL:int = 2;

		/**
		 * 根据职业ID获取职业名
		 * @param cclass
		 * @return
		 */
		public static function getName(profession:int):String
		{
			switch (profession)
			{
				case Gladiator:
					return LanguageManager.translate(15000, "角斗士");
				case DarkMage:
					return LanguageManager.translate(15001, "暗法师");
				case Luna:
					return LanguageManager.translate(15002, "月神使");
				case Avenger:
					return LanguageManager.translate(15003, "魅舞者");
				case ALL_PROFESSION:
					return LanguageManager.translate(15012, "全职业");
				default:
					return LanguageManager.translate(100004, "未知");
			}
		}

		/**
		 * 根据职业ID获取职业名
		 * @param cclass
		 * @return
		 */
		public static function getNameCondition(profession:int):String
		{
			switch (profession)
			{
				case Gladiator:
					return LanguageManager.translate(15000, "角斗士");
				case DarkMage:
					return LanguageManager.translate(15001, "暗法师");
				case Luna:
					return LanguageManager.translate(15002, "月神使");
				case Avenger:
					return LanguageManager.translate(15003, "魅舞者");
				default:
					return LanguageManager.translate(15004, "无限制");
			}
		}

		/**
		 * 根据职业id获取相应的魔法类型
		 * @param profession
		 * @return
		 *
		 */
		public static function getMagicName(profession:int):String
		{
			switch (profession)
			{
				case Gladiator:
					return LanguageManager.translate(15006, "白魔法攻击类型");
				case DarkMage:
					return LanguageManager.translate(15007, "黑魔法攻击类型");
				case Luna:
					return LanguageManager.translate(15008, "青魔法攻击类型");
				case Avenger:
					return LanguageManager.translate(15009, "血魔法攻击类型");
				default:
					return LanguageManager.translate(15004, "无限制");
			}
		}
	}
}
