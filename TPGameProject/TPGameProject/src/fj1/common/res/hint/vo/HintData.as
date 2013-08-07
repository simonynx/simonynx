package fj1.common.res.hint.vo
{
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.staticdata.HintConst;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.HtmlUtil;

	/**
	 * 提示数据对象 （可派生扩展）
	 * @author linxun
	 *
	 */
	public class HintData
	{
		private static const log:ILogger = TLog.getLogger(HintConfig);

		private var _hintConfig:BaseHintConfig;
		public var params:Array;
		public var prefix:String = "";
		private var _content:String;

		public function HintData(hintConfig:BaseHintConfig, params:Array)
		{
			_hintConfig = hintConfig;
			this.params = params;
		}

		public function get hintConfig():BaseHintConfig
		{
			return _hintConfig;
		}

		public function get type():int
		{
			return hintConfig.type;
		}

		public function get content():String
		{
			if (!_content)
			{
				_content = getDefaultContent();
			}
			return _content;
		}

		private function getDefaultContent():String
		{
			return prefix + StringFormatHelper.format2.apply(null, [_hintConfig.pattern].concat(params));
		}

	}
}
