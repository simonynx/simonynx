package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;

	public class MenuOperationType
	{
		public function MenuOperationType()
		{
		}
		public static const USE:int = 0;
		public static const DISCARD:int = 1;
		public static const EQUIP:int = 2;
		public static const SEND_TO_CHAT:int = 3;
		public static const PICK_UP:int = 4;
		public static const SPLIT:int = 5;
		public static const UPEQUIP:int = 6;
		public static const LEVELUP:int = 7; //装备升级
		public static const MUTIUSE:int = 8; //批量使用
		public static const CHAT:int = 100;
		public static const VIEW_INFO:int = 101;
		public static const MAKE_FRIEND:int = 102;
		public static const TRADE:int = 103;
		public static const TEAM:int = 104;
		public static const DEL:int = 200;
		public static const ADD_TO_MAIN_PET:int = 201;
		public static const ADD_TO_DEPUTE_PET:int = 202;
		public static const SEND_MAIL:int = 203;
		public static const COPY_NAME:int = 204;
		public static const INVITE:int = 301;
		public static const MOVETO_BLACK:int = 302;
		public static const MAKE_OVER:int = 303;
		public static const DISMISS_TEAM:int = 304;
		public static const LEAVE_TEAM:int = 305;
		public static const KICK_OUT_TEAM:int = 306;
		public static const APPLICATION_TEAM:int = 307;
		public static const AUTO_WALK:int = 308;
		public static const FLY_TO:int = 309;
		public static const ENEMY:int = 310;
		public static const VIEW_MAP:int = 311; //查看地图
		/**
		 * 解除合体
		 */
		public static const REMOVE_UNIT:int = 400;
		/**
		 * 合体
		 */
		public static const PET_UNIT:int = 401;
		public static const PET_BATTLE:int = 402;
		public static const CANCEL_BATTLE:int = 403;
		public static const PET_BONG:int = 404;
		//公会菜单项
		public static const VIEW_INFO2:int = 501;
		public static const MAKE_FRIEND2:int = 502;
		public static const CHAT2:int = 503;
		public static const GUILD_SET_POS:int = 504;
		public static const GUILD_KICKOUT:int = 505;
		public static const GUILD_CHAIRMAN_CHG:int = 506;
		public static const TEAM2:int = 507;
		public static const VIEW_POS:int = 508; //查看位置
		//考古
		public static const KAOGU:int = 601;
		public static const VIEW_AWARD:int = 602;
		public static const COMPLETE_ARCHAEOLOGY:int = 603; //46010;
		public static const CANCEL_ARCHAEOLOGY:int = 604; //46062;
		public static const HIDE_ARCHAEOLOGY:int = 605; //46063;
		public static const HIDE_FOREVER:int = 606;
		public static const CONTINUE_ARCHAEOLOGY:int = 607;
		//更换头像
		public static const CHANGEHEAD:int = 701;

		public static function getOperationTypeName(type:int):String
		{
			switch (type)
			{
				case USE:
					return LanguageManager.translate(14000, "使用");
				case DISCARD:
					return LanguageManager.translate(14001, "销毁");
				case EQUIP:
					return LanguageManager.translate(14002, "装备");
				case SEND_TO_CHAT:
					return LanguageManager.translate(14003, "发送到聊天框");
				case PICK_UP:
					return LanguageManager.translate(14004, "移动");
				case UPEQUIP:
					return LanguageManager.translate(14005, "卸下");
				case SPLIT:
					return LanguageManager.translate(14006, "拆分");
				case CHAT:
					return LanguageManager.translate(14007, "私聊");
				case VIEW_INFO:
					return LanguageManager.translate(14008, "查看");
				case MAKE_FRIEND:
					return LanguageManager.translate(14009, "交友");
				case TRADE:
					return LanguageManager.translate(14010, "交易");
				case TEAM:
					return LanguageManager.translate(14011, "组队");
				case ADD_TO_MAIN_PET:
					return LanguageManager.translate(14012, "添加到主宠");
				case ADD_TO_DEPUTE_PET:
					return LanguageManager.translate(14013, "添加到副宠");
				case DEL:
					return LanguageManager.translate(100016, "删除");
				case INVITE:
					return LanguageManager.translate(14015, "{0}邀请", GuildConst.guildStr);
				case MOVETO_BLACK:
					return LanguageManager.translate(14016, "移至黑名单");
				case MAKE_OVER:
					return LanguageManager.translate(14017, "转让队长");
				case DISMISS_TEAM:
					return LanguageManager.translate(14018, "解散队伍");
				case LEAVE_TEAM:
					return LanguageManager.translate(14019, "离开队伍");
				case KICK_OUT_TEAM:
					return LanguageManager.translate(14020, "请离队伍");
				case APPLICATION_TEAM:
					return LanguageManager.translate(14021, "申请入队");
				case AUTO_WALK:
					return LanguageManager.translate(14022, "自动寻路");
				case FLY_TO:
					return LanguageManager.translate(14023, "快速到达");
				case REMOVE_UNIT:
					return LanguageManager.translate(14024, "解除合体");
				case PET_UNIT:
					return LanguageManager.translate(14025, "合体");
				case CANCEL_BATTLE:
					return LanguageManager.translate(14026, "取消出战");
				case PET_BATTLE:
					return LanguageManager.translate(14027, "出战");
				case VIEW_INFO2:
					return LanguageManager.translate(14029, "查看信息");
				case MAKE_FRIEND2:
					return LanguageManager.translate(9112, "加为好友");
				case CHAT2:
					return LanguageManager.translate(14030, "发起私聊");
				case GUILD_SET_POS:
					return LanguageManager.translate(14031, "任命职位");
				case GUILD_KICKOUT:
					return LanguageManager.translate(14032, "逐出{0}", GuildConst.guildStr);
				case GUILD_CHAIRMAN_CHG:
					return LanguageManager.translate(14033, "会长转移");
				case TEAM2:
					return LanguageManager.translate(14034, "邀请组队");
				case SEND_MAIL:
					return LanguageManager.translate(100052, "发送邮件");
				case COPY_NAME:
					return LanguageManager.translate(100053, "复制名字");
				case LEVELUP:
					return LanguageManager.translate(23018, "装备升级");
				case MUTIUSE:
					return LanguageManager.translate(100127, "批量使用");
				case VIEW_POS:
					return LanguageManager.translate(14035, "查看位置");
				case KAOGU:
					return LanguageManager.translate(46001, "寻宝");
				case COMPLETE_ARCHAEOLOGY:
					return LanguageManager.translate(46010, "立即完成");
				case CANCEL_ARCHAEOLOGY:
					return LanguageManager.translate(46062, "取消挖宝");
				case HIDE_ARCHAEOLOGY:
					return LanguageManager.translate(46063, "暂时隐藏");
				case HIDE_FOREVER:
					return LanguageManager.translate(46064, "本次游戏隐藏");
				case CONTINUE_ARCHAEOLOGY:
					return LanguageManager.translate(46069, "继续挖宝");
				case VIEW_AWARD:
					return LanguageManager.translate(46002, "查看奖励");
				case ENEMY:
					return LanguageManager.translate(50534, "视为仇人");
					break;
				case CHANGEHEAD:
					return LanguageManager.translate(81088, "更换头像");
					break;
				case VIEW_MAP:
					return LanguageManager.translate(81106, "查看地图");
					break;
				default:
					return "";
			}
		}
	}
}
