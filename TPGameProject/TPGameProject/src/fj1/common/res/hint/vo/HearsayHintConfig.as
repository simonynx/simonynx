package fj1.common.res.hint.vo
{

	public class HearsayHintConfig extends HintConfig
	{
		public var trackLink:String;
		public var trackLinkName:String;

		public function HearsayHintConfig(id:int, pattern:String, place:int, lanID:int = 0, chatChannel:int = 5, type2:int = 0, trackLink:String = "", trackLinkName:String = "", configtype:int = 0)
		{
			super(id, pattern, place, lanID, chatChannel, type2, 0, 0, 0, null, configtype);
			this.trackLink = trackLink;
			this.trackLinkName = trackLinkName;
		}
	}
}
