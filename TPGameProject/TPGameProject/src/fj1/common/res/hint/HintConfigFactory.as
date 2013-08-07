package fj1.common.res.hint
{
	import fj1.common.res.hint.vo.BaseHintConfig;
	import fj1.common.res.hint.vo.HearsayHintConfig;
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.res.hint.vo.ScriptHintConfig;
	import fj1.common.res.hint.vo.ShortCutHintConfig;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.HintConst;

	public class HintConfigFactory
	{
		public static function create(xml:XML, configtype:int = 0):BaseHintConfig
		{
			var name:String = xml.name();
			if (!name)
			{
				return null;
			}
			switch (name)
			{
				case HintConst.TYPE_HINT_TAG:
					var place:int = parseInt(xml.@place);
					var chatChannel:int = parseInt(xml.@chatChannel);
					if (place & HintConst.HINT_PLACE_CHAT && chatChannel == ChatConst.CHANNEL_HEARSAY)
					{
						return new HearsayHintConfig(parseInt(xml.@id), String(xml.valueOf()), place, parseInt(xml.@lanID), chatChannel, parseInt(xml.@type), String(xml.@trackLink), String(xml.@trackLinkName), configtype);
					}
					else
					{
						return new HintConfig(parseInt(xml.@id), String(xml.valueOf()), place, parseInt(xml.@lanID), chatChannel, parseInt(xml.@type), parseFloat(xml.@delay), parseInt(xml.@size), parseInt(xml.
							@color), String(xml.@font), configtype);
					}
				case HintConst.TYPE_ALERT_TAG:
					return new BaseHintConfig(HintConst.TYPE_ALERT, parseInt(xml.@id), String(xml.valueOf()), parseInt(xml.@lanID), 0, 0, 0, null, configtype);
				case HintConst.TYPE_DIALOG_TAG:
					return new BaseHintConfig(HintConst.TYPE_DIALOG, parseInt(xml.@id), String(xml.valueOf()), parseInt(xml.@lanID), 0, 0, 0, null, configtype);
				case HintConst.TYPE_SHORT_CUT_HINT_TAG:
					return new ShortCutHintConfig(parseInt(xml.@id), String(xml.valueOf()), String(xml.@buttonText), parseInt(xml.@lanID), String(xml.@title), parseInt(xml.@level), 0, configtype);
				case HintConst.TYPE_SCRIPT_ALERT_TAG:
					return new ScriptHintConfig(parseInt(xml.@id), String(xml.valueOf()), String(xml.@autoAction), parseInt(xml.@lanID), parseInt(xml.@delay), String(xml.@pattern), configtype);
				default:
					throw new Error("无效的配置标签：" + name);
			}
		}
	}
}
