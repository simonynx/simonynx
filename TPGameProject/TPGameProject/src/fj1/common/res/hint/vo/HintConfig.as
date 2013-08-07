package fj1.common.res.hint.vo
{
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.HintConst;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.staticdata.Colors;
	import tempest.utils.HtmlUtil;

	public class HintConfig extends BaseHintConfig
	{
		private static const log:ILogger = TLog.getLogger(HintConfig);
		public var place:int;
		public var chatChannel:int;
		public var type2:int;

		public function HintConfig(id:int, pattern:String, place:int, lanID:int = 0, chatChannel:int = 5, type2:int = 0, delay:int = 0, size:int = 0, color:int = 0, font:String = null, configtype:int =
			0)
		{
//			switch (place)
//			{
//				case HintConst.HINT_PLACE_CHAT:
//				case HintConst.HINT_PLACE_SYSTEM_HINT:
//					dispatchNow = false;
//					break;
//			}
			super(HintConst.TYPE_HINT, id, pattern, lanID, delay, size, color, font, configtype);
			this.place = place;
			this.chatChannel = chatChannel;
			this.type2 = type2;
			if (place & HintConst.HINT_PLACE_CHAT && chatChannel == 0)
			{
				this.chatChannel = ChatConst.CHANNEL_INFO;
				//错误配置
				log.error("提示配置错误！聊天频道不能为0！configtype = " + HintConst.getConfigType(configtype) + ", id = " + id + " place = " + place + ", 已自动改为 5");
			}
			if (place & HintConst.HINT_PLACE_CHAT && chatChannel == ChatConst.CHANNEL_HEARSAY)
			{
				_pattern = StringFormatHelper.getHTMLStr2(this.pattern);
			}
		}
	}
}
