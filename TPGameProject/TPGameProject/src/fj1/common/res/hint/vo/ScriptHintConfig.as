package fj1.common.res.hint.vo
{
	import fj1.common.staticdata.HintConst;

	public class ScriptHintConfig extends BaseHintConfig
	{
		private var _autoAction:String = "none";
		private var _delay:Number = 0;
		private var _pattern2:String = "";

		public function get autoAction():String
		{
			return _autoAction;
		}

		public override function get delay():Number
		{
			return _delay;
		}

		public function get pattern2():String
		{
			return _pattern2;
		}

		public function ScriptHintConfig(id:int, pattern:String, autoAction:String, lanID:int = 0, delay:int = 0, pattern2:String = "", configtype:int = 0)
		{
			super(HintConst.TYPE_SCRIPT_ALERT, id, pattern, lanID, 0, 0, 0, null, configtype);
			_autoAction = autoAction;
			_delay = delay;
			_pattern2 = pattern2;
		}
	}
}
