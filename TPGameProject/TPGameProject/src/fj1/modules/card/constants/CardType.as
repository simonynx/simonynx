package fj1.modules.card.constants
{
	import fj1.common.res.lan.LanguageManager;

	public class CardType
	{
		public static const ATTACK:int = 1;
		public static const DEFENCE:int = 2;
		public static const CURE:int = 3;
		public static const BALANCE:int = 4;
		public static const OHTER:int = 5;

		public static function getString(type:int):String
		{
			switch (type)
			{
				case ATTACK:
					return LanguageManager.translate(-1, "攻击");
				case DEFENCE:
					return LanguageManager.translate(-1, "防御");
				case CURE:
					return LanguageManager.translate(-1, "治疗");
				case BALANCE:
					return LanguageManager.translate(-1, "平衡");
				case OHTER:
					return LanguageManager.translate(-1, "其他");
				default:
					return LanguageManager.translate(-1, "未知");
			}
		}
	}
}
