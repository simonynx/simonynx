package assets
{
	import tempest.common.rsl.RslManager;
	import fj1.common.res.ResPaths;
	import fj1.common.res.lan.LanguageManager;

	import flash.display.DisplayObject;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.rsl.TRslManager;

	/**
	 * 窗口标题资源配置
	 * @author linxun
	 *
	 */
	public class WindowTitleLib
	{
		private static var log:ILogger = TLog.getLogger(WindowTitleLib);
		private static var defaultTitle:String = "msgTitle1";
		private static var _configArray:Array = [
			{title: LanguageManager.translate(1001, "武器店"), link: "shopTitle5"},
			{title: LanguageManager.translate(1002, "防具店"), link: "shopTitle1"},
			{title: LanguageManager.translate(1003, "药店"), link: "shopTitle6"},
			{title: LanguageManager.translate(1004, "技能书店"), link: "shopTitle2"},
			{title: LanguageManager.translate(1005, "饰品店"), link: "shopTitle4"},
			{title: LanguageManager.translate(1006, "杂货店"), link: "shopTitle7"},
			{title: LanguageManager.translate(1007, "声望兑换商店"), link: "shopTitle3"},
			{title: LanguageManager.translate(1008, "召唤兽商店"), link: "shopTitle8"},
			{title: LanguageManager.translate(1009, "系统信息"), link: "msgTitle1"},
			{title: LanguageManager.translate(1010, "好友消息"), link: "title_friend"},
			{title: LanguageManager.translate(1011, "组队消息"), link: "title_team"},
			{title: LanguageManager.translate(1012, "交易消息"), link: "title_trade"},
			{title: LanguageManager.translate(1013, "VIP远程商店"), link: "shopTitle9"},
			{title: LanguageManager.translate(1057, "公会消息"), link: "title_guild"},
			{title: LanguageManager.translate(1056, "神力觉醒"), link: "title_godPowAwake"},
			{title: LanguageManager.translate(1058, "契灵回复"), link: "title_qilingHP"},
			{title: LanguageManager.translate(1059, "小提示"), link: "little_title"}
			];

		public static function getTitleClass(title:String):Class
		{
			for each (var config:Object in _configArray)
			{
				if (config.title == title)
				{
					return RslManager.getDefinition(config.link) as Class;
				}
			}
			log.error("找不到标题资源：" + title);
			return RslManager.getDefinition(defaultTitle) as Class;
		}
	}
}
