package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;
	import tempest.common.staticdata.Colors;

	/**
	 *
	 * @author linxun
	 */
	public class ChatConst
	{
		public static const MAX_INPUT_LEN:int = 60;
		public static const MAX_LINE_PRIVATE:int = 50;
		public static const MAX_LINE_CHAT:int = 50;
		public static const MAX_LINE_HINT:int = 50;
		public static const MAX_HORN_INPUT:int = 60; //号角最大输入字符
		public static const MAX_LINE_HORN:int = 1;
		public static const HORN_MSG_KEEP_TIME:int = 10000; //号角持续显示时间
		public static const CHANNEL_STATE_DEFAULT:int = 0;
		public static const CHANNEL_STATE_DISABLE:int = 1;
		public static const CHANNEL_WORLD_LEVEL_REQ:int = 10; //世界频道聊天所需等级
		public static const HORN_EFECT_TIME:int = 10; //高级号角持续时间

		/**
		 *
		 */
		public function ChatConst()
		{
		}
		/**
		 * GM指令类型（用ChatTools发送此频道消息无效果）
		 *
		 * @default
		 */
		public static const CHANNEL_GM:int = 1;
		/**
		 * 周围
		 * @default
		 */
		public static const CHANNEL_ROUND:int = 2;
		/**
		 * 队伍
		 * @default
		 */
		public static const CHANNEL_TEAM:int = 3;
		/**
		 * 公会
		 * @default
		 */
		public static const CHANNEL_GUILD:int = 4;
		/**
		 * 信息
		 * @default
		 */
		public static const CHANNEL_INFO:int = 5;
		/**
		 * 公告
		 * @default
		 */
		public static const CHANNEL_NOTICE:int = 6;
		/**
		 * 密聊
		 * @default
		 */
		public static const CHANNEL_PRIVATE:int = 7;
		/**
		 * 号角
		 * @default
		 */
		public static const CHANNEL_HORN:int = 8;
		/**
		 *高级号角
		 */
		public static const CHANNEL_SUPERHORN:int = 13;
		/**
		 * 综合
		 * @default
		 */
		public static const CHANNEL_ALL:int = 9;
		/**
		 * 世界
		 * @default
		 */
		public static const CHANNEL_WORLD:int = 10;
		/**
		 * 传言频道
		 * @default
		 */
		public static const CHANNEL_HEARSAY:int = 11;
		/**
		 * 交互频道
		 * @default
		 */
		public static const CHANNEL_MUTUAL:int = 12;
		/**
		 * 战场频道
		 */
		public static const CHANNEL_BATTLELAND:int = 16;
		public static const LINK_TYPE_ITEM:int = 0;
		public static const LINK_TYPE_POS:int = 1;
		public static const LINK_PREFIX_ITEM:String = "item";
		public static const LINK_PREFIX_POS:String = "pos";
		public static const LINK_PREFIX_NAME:String = "name";
		public static const LINK_PREFIX_MUTUAL:String = "mutual";
		public static const MUTUAL_TYPE_MAGIC_WARD:String = "magicward";
		public static const MUTUAL_TYPE_ENEMY:String = "enemy";
		public static const LINK_PREFIX_GUILDTRSPORT:String = "guid_transport";
		public static const LINK_PREFIX_OPEN_PANEL:String = "openPanel";
		public static const LINK_PREFIX_PASSID:String = "transportID";
		public static const LINK_PREFIX_WALKTO:String = "walkTo";
		public static const LINK_PREFIX_APPLYING:String = "applying";
		public static const channelConfig:Array
			= [{id: CHANNEL_ALL, shortCut: null, color: "", cd: -1, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_WORLD, shortCut: "/Z", color: ColorConst.getHtmlColor(Colors.Yellow), cd: 8, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_ROUND, shortCut: "/D", color: ColorConst.getHtmlColor(Colors.White), cd: 3, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_TEAM, shortCut: "/T", color: ColorConst.getHtmlColor(Colors.DodgeBlue), cd: 0, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_GUILD, shortCut: "/B", color: ColorConst.getHtmlColor(Colors.Green), cd: 3, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_INFO, shortCut: null, color: ColorConst.getHtmlColor(Colors.Red), cd: -1, itemSendable: false, dirtyWordCheck: false},
			{id: CHANNEL_NOTICE, shortCut: null, color: ColorConst.getHtmlColor(Colors.Red), color2: Colors.Red, cd: -1, itemSendable: false, dirtyWordCheck: false},
			{id: CHANNEL_PRIVATE, shortCut: "/M", color: ColorConst.getHtmlColor(Colors.Magenta), cd: 0, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_HORN, shortCut: null, color: ColorConst.getHtmlColor(Colors.Yellow), cd: 3, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_HEARSAY, shortCut: null, color: ColorConst.getHtmlColor(Colors.LightBlue), cd: -1, itemSendable: false, dirtyWordCheck: false},
			{id: CHANNEL_MUTUAL, shortCut: null, color: ColorConst.getHtmlColor(Colors.Cyan), cd: -1, itemSendable: false, dirtyWordCheck: false},
			{id: CHANNEL_SUPERHORN, shortCut: null, color: ColorConst.getHtmlColor(Colors.Yellow), cd: 3, itemSendable: true, dirtyWordCheck: true},
			{id: CHANNEL_BATTLELAND, shortCut: "/W", color: ColorConst.getHtmlColor(Colors.Yellow), cd: 8, itemSendable: true, dirtyWordCheck: false}
			];

//			= [{id: CHANNEL_ALL, shortCut: null, color: "", cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_WORLD, shortCut: "/Z", color: ColorConst.getHtmlColor(Colors.Yellow), cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_ROUND, shortCut: "/D", color: ColorConst.getHtmlColor(Colors.White), cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_TEAM, shortCut: "/T", color: ColorConst.getHtmlColor(Colors.DodgeBlue), cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_GUILD, shortCut: "/B", color: ColorConst.getHtmlColor(Colors.Green), cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_INFO, shortCut: null, color: ColorConst.getHtmlColor(Colors.Red), cd: -1, itemSendable: false, dirtyWordCheck: false},
//				{id: CHANNEL_NOTICE, shortCut: null, color: ColorConst.getHtmlColor(Colors.Red), color2: Colors.Red, cd: -1, itemSendable: false, dirtyWordCheck: false},
//				{id: CHANNEL_PRIVATE, shortCut: "/M", color: ColorConst.getHtmlColor(Colors.Magenta), cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_HORN, shortCut: "/H", color: ColorConst.getHtmlColor(Colors.Yellow), cd: -1, itemSendable: true, dirtyWordCheck: true},
//				{id: CHANNEL_HEARSAY, shortCut: null, color: ColorConst.getHtmlColor(Colors.Yellow), cd: -1, itemSendable: false, dirtyWordCheck: false},
//				{id: CHANNEL_MUTUAL, shortCut: null, color: ColorConst.getHtmlColor(Colors.Cyan), cd: -1, itemSendable: false, dirtyWordCheck: false}
//			];
		public static function getNameColor():String
		{
			return ColorConst.getHtmlColor(Colors.Cyan);
		}

		public static function getChannelName(channelId:int):String
		{
			switch (channelId)
			{
				case CHANNEL_ALL:
					return LanguageManager.translate(12000, "综合");
				case CHANNEL_WORLD:
					return LanguageManager.translate(12001, "世界");
				case CHANNEL_ROUND:
					return LanguageManager.translate(12002, "附近");
				case CHANNEL_TEAM:
					return LanguageManager.translate(12003, "队伍");
				case CHANNEL_GUILD:
					return LanguageManager.translate(12004, "公会");
				case CHANNEL_INFO:
					return LanguageManager.translate(12005, "龙曜");
				case CHANNEL_NOTICE:
					return LanguageManager.translate(12006, "公告");
				case CHANNEL_PRIVATE:
					return LanguageManager.translate(12007, "密聊");
				case CHANNEL_HORN:
					return LanguageManager.translate(12008, "号角");
				case CHANNEL_HEARSAY:
					return LanguageManager.translate(12009, "传言");
				case CHANNEL_MUTUAL:
					return LanguageManager.translate(12010, "交互");
				case CHANNEL_SUPERHORN:
					return LanguageManager.translate(12021, "高级號角");
				case CHANNEL_BATTLELAND:
					return LanguageManager.translate(12024, "戰場");
				default:
					throw new Error("无效的channelId：" + channelId);
					break;
			}
		}

		public static function getColorString(channelId:int):String
		{
			for each (var config:Object in channelConfig)
			{
				if (config.id == channelId)
				{
					return config.color;
				}
			}
			throw new Error("无效的channelId：" + channelId);
		}

		public static function getChannelIdByShortCutStr(shortCut:String):int
		{
			for each (var config:Object in channelConfig)
			{
				if (!config.shortCut)
					continue;
				if (config.shortCut.toLowerCase() == shortCut.toLowerCase())
				{
					return config.id;
				}
			}
			return -1;
		}

		public static function getChannelCD(channelId:int):int
		{
			for each (var config:Object in channelConfig)
			{
				if (config.id == channelId)
				{
					return config.cd;
				}
			}
			throw new Error("无效的channelId：" + channelId);
		}

		public static function channelItemSendable(channelId:int):int
		{
			for each (var config:Object in channelConfig)
			{
				if (config.id == channelId)
				{
					return config.itemSendable;
				}
			}
			throw new Error("无效的channelId：" + channelId);
		}

		public static function channelDirtyWordCheckNeeded(channelId:int):int
		{
			for each (var config:Object in channelConfig)
			{
				if (config.id == channelId)
				{
					return config.dirtyWordCheck;
				}
			}
			throw new Error("无效的channelId：" + channelId);
		}

		public static function getShortCutStrByChannelId(channelId:int):String
		{
			for each (var config:Object in channelConfig)
			{
				if (config.id == channelId)
				{
					var shortCut:String = config.shortCut;
					if (!shortCut)
						return "";
					else
						return shortCut;
				}
			}
			return "";
		}
	}
}


