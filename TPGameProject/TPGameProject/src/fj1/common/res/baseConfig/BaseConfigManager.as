package fj1.common.res.baseConfig
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.XMLAnalyser;

	/**
	 * 客户端初始化配置加载和管理类
	 * 配置键的值和含义定义在BaseConfigKeys中
	 * @author linxun
	 *
	 */
	public class BaseConfigManager
	{
		private static var log:ILogger = TLog.getLogger(BaseConfigManager);
		private static var _configArray:Array = [];

		public static function load(data:*):Boolean
		{
//			return ResManagerHelper.mapArryList(_configArray, BaseConfig, data, false, "key");
			_configArray = ResManagerHelper.getArray(BaseConfig, data, "key");
			return _configArray != null;
		}

		public static function getConfig(key:int):String
		{
			var config:BaseConfig = _configArray[key];
			if (!config)
			{
				log.error("未定义的配置编号 key = " + key);
				return "";
			}
			return config.value;
		}

		public static function getIntValue(key:int):int
		{
			return parseInt(getConfig(key));
		}
	}
}

class BaseConfig
{
	public var key:int;
	public var value:String;
}
