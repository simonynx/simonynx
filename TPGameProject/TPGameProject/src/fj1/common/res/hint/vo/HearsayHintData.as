package fj1.common.res.hint.vo
{

	public class HearsayHintData extends HintData
	{
		public var itemParams:Array;
		public var hearsayTeamID:int;

		public function HearsayHintData(hintConfig:BaseHintConfig, params:Array)
		{
			super(hintConfig, params);
			itemParams = [];
			hearsayTeamID = 0;
		}
	}
}


