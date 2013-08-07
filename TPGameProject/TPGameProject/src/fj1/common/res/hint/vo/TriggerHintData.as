package fj1.common.res.hint.vo
{

	public class TriggerHintData
	{
		private var _config:TriggerHintConfig;
		public var content:String;

		public function TriggerHintData(config:TriggerHintConfig, content:String)
		{
			this._config = config;
			this.content = content;
		}

		public function get config():TriggerHintConfig
		{
			return _config;
		}
	}
}
