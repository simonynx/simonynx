package fj1.common.res.hint
{
	import fj1.common.res.hint.vo.BaseHintConfig;
	import fj1.common.res.hint.vo.HearsayHintData;
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.HintConst;

	public class HintDataFactory
	{
		public static function create(cfg:BaseHintConfig, params:Array):HintData
		{
			switch (cfg.type)
			{
				case HintConst.TYPE_HINT:
					var hintConfig:HintConfig = HintConfig(cfg);
					if (hintConfig.place & HintConst.HINT_PLACE_CHAT && hintConfig.chatChannel == ChatConst.CHANNEL_HEARSAY)
					{
						return new HearsayHintData(cfg, params);
					}
					else
					{
						return new HintData(cfg, params);
					}
				default:
					return new HintData(cfg, params);
			}
		}
	}
}
