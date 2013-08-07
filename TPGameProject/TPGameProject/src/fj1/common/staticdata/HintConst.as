package fj1.common.staticdata
{

	public class HintConst
	{
		/************************字符串替换类型*************************/
		public static const FORMAT_INT:int = 1; //
		public static const FORMAT_STR:int = 2;
		/************************提示配置类型*************************/
		public static const CONFIG_CLIENT:int = 1; //客户端提示
		public static const CONFIG_SERVER:int = 2; //服务器提示
		public static const CONFIG_SERVER_SCRIPT:int = 3; //服务器脚本提示
		/************************服务器提示类型*************************/
		public static const STR:int = 1;
		public static const STRID:int = 2;
		public static const FORMAT:int = 3;
		public static const SCRIPT_STRID:int = 4;
		public static const STRID_CONFIRM:int = 5; //弹出确认框请求
		public static const FORMAT_CONFIRM:int = 6; //弹出确认框请求（带格式）
		public static const FORMAT_HEARSAY:int = 7; //传言
		public static const FORMAT_TEAM:int = 8; //传言组队
		/************************提示类型******************************/
		public static const TYPE_HINT:int = 1;
		public static const TYPE_HINT_TAG:String = "hint";
		public static const TYPE_ALERT:int = 2;
		public static const TYPE_ALERT_TAG:String = "alert";
		public static const TYPE_DIALOG:int = 3;
		public static const TYPE_DIALOG_TAG:String = "dialog";
		public static const TYPE_SHORT_CUT_HINT:int = 4;
		public static const TYPE_SHORT_CUT_HINT_TAG:String = "shortcut";
		public static const TYPE_SCRIPT_ALERT:int = 5;
		public static const TYPE_SCRIPT_ALERT_TAG:String = "scriptAlert";
		/************************消息提示类型******************************/
		public static const MSG_TYPE_TEAM:int = 0; //组队
		/**
		 * 系统公告（顶部滚动文字）
		 */
		public static const HINT_PLACE_BULLETIN:int = 1;
		/**
		 * 系统消息（右下角提示）
		 */
		public static const HINT_PLACE_SYSTEM_HINT:int = 2;
		/**
		 * 聊天消息
		 */
		public static const HINT_PLACE_CHAT:int = 4;
		/**
		 * 滚动提示（屏幕中央纵向滚动）
		 */
		public static const HINT_PLACE_SCROLL_HINT:int = 8;
		/**
		 * 弹出提示框
		 */
		public static const HINT_PLACE_ALERT:int = 32;
		/**
		 * 防沉迷提示
		 */
		public static const HINT_PLACE_GUARDWALLOW:int = 64;
		/**
		 * 滚动提示（屏幕偏右纵向滚动）
		 */
		public static const HINT_PLACE_SCROLL_HINT2:int = 128;
		/**
		 * 图片滚动提示（屏幕底部纵向滚动）
		 */
		public static const HINT_PLACE_BOTTOM:int = 256;
		/**
		 *任务接取滚动提示（屏幕底部纵向滚动）
		 */
		public static const HINT_PLACE_BOTTOM2:int = 1024;
		/**
		 * 滚动提示（屏幕偏下纵向滚动）
		 */
		public static const HINT_PLACE_SCROLL_HINT3:int = 512;
		/**
		 *脚本中上部提示
		 */
		public static const HINT_SCRPT_TOPCENTER:int = 2048;
		/**
		 * 测试
		 */
		public static const TEST:int = 123;
		/************************需要额外处理的特殊提示类型***************************/
		public static const ID_ADD_ITEM:int = 8; //添加物品
		public static const ID_REMOVE_ITEM:int = 25; //删除物品
		public static const ID_PET_FULL:int = 800; //宠物栏满处理
		public static const ID_HERO_AWAKE:int = 510; //英雄格魔纹已觉醒
		public static const ID_HALF_GOD_AWAKE:int = 511; //半神格魔纹已觉醒
		public static const ID_GOD_AWAKE:int = 512; //神格魔纹已觉醒
		public static const ID_PET_TRAMING_NOTICE:int = 2004; //宠物驯养提醒
		public static const ID_EXP_ADD:int = 565; //经验增加--飘字
		public static const NOTICE_ID_GUARDWALLOW_1:int = 1023; //防沉迷通知类型1
		public static const NOTICE_ID_GUARDWALLOW_2:int = 1024; //防沉迷通知类型2
		public static const NOTICE_ID_GUARDWALLOW_3:int = 1025; //防沉迷通知类型3
		/************************其他***************************/
		/**************通知位置类型**************/
		public static const NOTICE_TYPE_1:int = 0; //通知类型1
		public static const NOTICE_TYPE_2:int = 1; //通知类型2
		/**************通知互斥类型**************/
		public static const NOTICE_MUTEX_NONE:int = -1;
		public static const NOTICE_MUTEX_GUARDWALLOW:int = 1;
		/**************脚本对话框自动执行类型**************/
		public static const SCRIPTHINT_ACTION_NONE:String = "none";
		public static const SCRIPTHINT_ACTION_OK:String = "ok";
		public static const SCRIPTHINT_ACTION_CANCEL:String = "cancel";
		/**************下方滚动提示类型********************/
		public static const HINT_TYPE2_NOTICE:int = 0;
		public static const HINT_TYPE2_WARNING:int = 1;
		public static const HINT_TYPE2_ERROR:int = 2;

		public static function getConfigType(value:int):String
		{
			switch (value)
			{
				case CONFIG_CLIENT:
					return "CONFIG_CLIENT";
				case CONFIG_SERVER:
					return "CONFIG_SERVER";
				case CONFIG_SERVER_SCRIPT:
					return "CONFIG_SERVER_SCRIPT";
				default:
					return "DEFAULT";
			}
		}
	}
}


