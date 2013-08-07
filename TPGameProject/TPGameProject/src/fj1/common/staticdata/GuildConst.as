package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;

	public class GuildConst
	{
		/**
		 * 公會等級限制
		 */
		public static const CREATE_GUILD_LEVEL:int = 30;
		/**
		 * 公會創建消耗的金錢
		 */
		public static const CREATE_GUILD_MONEY:int = 30000;
		/**
		 *  会长
		 */
		public static const JOB_CHAIRMAN:int = 1;
		/**
		 * 副会长
		 */
		public static const JOB_VICECHAIRMAN:int = 2;
		/**
		 * 官员1
		 */
		public static const JOB_OFFICIAL1:int = 3;
		/**
		 * 官员2
		 */
		public static const JOB_OFFICIAL2:int = 4;
		/**
		 * 官员3
		 */
		public static const JOB_OFFICIAL3:int = 5;
		/**
		 * 官员4
		 */
		public static const JOB_OFFICIAL4:int = 6;
		/**
		 * 会员
		 */
		public static const JOB_ASSOCIATOR:int = 0;

		/**
		 * 公会描述最大长度
		 */		
		public static const MAX_DESC_LEN:int = 200;

		/**
		 * 公会
		 */
		public static function get guildStr():String
		{
			return LanguageManager.translate(12004, "公会");
		}

		/**
		 * 公会名称
		 */
		public static function get guildNameStr():String
		{
			return LanguageManager.translate(1518, "{0}名称", guildStr);
		}

		/**
		 * 公告
		 */
		public static function get guildNoticeStr():String
		{
			return LanguageManager.translate(12006, "公告");
		}

		/**
		 * 会长
		 */
		public static function get chairmanStr():String
		{
			return LanguageManager.translate(1501, "会长");
		}

		/**
		 * 副会长
		 */
		public static function get vicechairmanStr():String
		{
			return LanguageManager.translate(1502, "副会长");
		}

		public static function getPost(value:int):String
		{
			switch (value)
			{
				case JOB_CHAIRMAN:
					return chairmanStr;
					break;
				case JOB_VICECHAIRMAN:
					return vicechairmanStr;
					break;
				case JOB_ASSOCIATOR:
					return LanguageManager.translate(1504, "会员");
					break;
				case JOB_OFFICIAL1:
					return LanguageManager.translate(1503, "官员");
					break;
				case JOB_OFFICIAL2:
					return LanguageManager.translate(1519, "官员2");
					break;
				case JOB_OFFICIAL3:
					return LanguageManager.translate(1520, "官员3");
					break;
				case JOB_OFFICIAL4:
					return LanguageManager.translate(1521, "官员4");
					break;
			}
			return LanguageManager.translate(100004, "未知");
		}
	}
}


