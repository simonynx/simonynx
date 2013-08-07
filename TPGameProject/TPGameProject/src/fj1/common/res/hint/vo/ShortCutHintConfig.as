package fj1.common.res.hint.vo
{
	import fj1.common.staticdata.HintConst;

	public class ShortCutHintConfig extends BaseHintConfig
	{
		private var _btnText:String;
		private var _titleText:String;
		private var _level:int;
		private var _maxLevel:int;

		public function get btnText():String
		{
			return _btnText;
		}

		public function get titleText():String
		{
			return _titleText;
		}

		public function get level():int
		{
			return _level;
		}

		public function get maxLevel():int
		{
			return _maxLevel;
		}

		public function ShortCutHintConfig(id:int, content:String, btnText:String, lanID:int = 0, titleText:String = "", level:int = 0, maxLevel:int = 0, configtype:int = 0)
		{
			super(HintConst.TYPE_SHORT_CUT_HINT, id, content, lanID, 0, 0, 0, null, configtype);
			_btnText = btnText;
			_titleText = titleText;
			_level = level;
			_maxLevel = maxLevel;
		}
	}
}
