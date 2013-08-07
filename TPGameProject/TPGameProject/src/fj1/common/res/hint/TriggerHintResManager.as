package fj1.common.res.hint
{
	import fj1.common.GameInstance;
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hint.vo.TriggerHintConfig;
	import fj1.common.res.hint.vo.TriggerHintData;
	import flash.utils.ByteArray;
	import tempest.utils.StringUtil;
	import tempest.utils.XMLAnalyser;

	public class TriggerHintResManager
	{
		private static var _configArray:Array;

		public static function load(data:*):Boolean
		{
			_configArray = [];
			return ResManagerHelper.mapArryList(_configArray, TriggerHintConfig, data);
		}

		public static function resolve(filter:Function, ... params):Array
		{
			var configList:Array = _configArray.filter(filter);
			var dataList:Array = [];
			for each (var config:TriggerHintConfig in configList)
			{
				var configData:TriggerHintData = new TriggerHintData(config, StringFormatHelper.format.apply(null, [config.pattern].concat(params)));
				dataList.push(configData);
			}
			return dataList;
		}
	}
}
