package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;

	public class MoneyType
	{
		public static const UNKONWN:int = -1;
		/**
		 * 魔晶
		 */
		public static const MAGIC_CRYSTAL:int = 0;
		/**
		 * 魔石
		 */
		public static const MAGIC_STONE:int = 1; //魔石
		/**
		 * 积分
		 */
		public static const INTEGRATE:int = 2; //积分
		/**
		 * 金币
		 */
		public static const MONEY:int = 3; //金币
		/**
		 * 功勋
		 */
		public static const GONGXUN:int = 4; //功勋


		public static function getName(type:int):String
		{
			switch (type)
			{
				case MAGIC_CRYSTAL:
					return LanguageManager.translate(100003, "魔晶");
				case MAGIC_STONE:
					return LanguageManager.translate(100005, "魔石");
				case INTEGRATE:
					return LanguageManager.translate(100006, "积分");
				case MONEY:
					return LanguageManager.translate(100002, "金币");
				case GONGXUN:
					return LanguageManager.translate(100190, "功勋");
				default:
					throw new Error("无效的金钱类型: " + type);
			}
		}

		public static function getTipStr(type:int):String
		{
			switch (type)
			{
				case MAGIC_CRYSTAL:
					return LanguageManager.translate(22000, "魔晶\n龙曜大陆购买一些珍贵物品所用的货币，可以通过充值获得");
				case MAGIC_STONE:
					return LanguageManager.translate(22001, "魔石\n龙曜大陆购买一些珍贵物品所用的货币，可以在游戏中获得");
				case INTEGRATE:
					return LanguageManager.translate(22002, "积分\n消费魔晶时返送的积分，可以用来兑换一些独一无二的物品");
				case MONEY:
					return LanguageManager.translate(22003, "金币\n龙曜大陆的基本货币");
				case GONGXUN:
					return LanguageManager.translate(22005, "功勋\n功勋功勋功勋功勋功勋功勋");
				default:
					throw new Error("无效的金钱类型: " + type);
			}
		}

		/**
		 * 货币类型是否是无效类型
		 * @param type
		 * @return
		 *
		 */
		public static function isUnkownType(type:int):Boolean
		{
			switch (type)
			{
				case MAGIC_CRYSTAL:
				case MAGIC_STONE:
				case INTEGRATE:
				case MONEY:
				case GONGXUN:
					return false;
				default:
					return true;
			}
		}
	}
}
