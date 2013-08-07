package fj1.common.res.hint
{
	import fj1.common.GameInstance;
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hint.vo.BaseHintConfig;
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.staticdata.HintConst;
	import fj1.manager.MessageManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.HtmlUtil;
	import tempest.utils.RegexUtil;
	import tempest.utils.StringUtil;

	/**
	 * 加载提示配置
	 * @author linxun
	 *
	 */
	[Event(name = "hintShow", type = "fj1.modules.chat.events.HintEvent")]
	public class HintResManager extends EventDispatcher
	{
		private static const instanceArr:Array = [];
		private static const log:ILogger = TLog.getLogger(HintResManager);
		private var _type:int;
		private var hintPatternDic:Dictionary = new Dictionary();

		public function HintResManager(type:int)
		{
			_type = type;
			super(this);
		}

		public static function getInstance(type:int):HintResManager
		{
			var instance:HintResManager = instanceArr[type];
			if (instance == null)
			{
				instance = new HintResManager(type);
				instanceArr[type] = instance;
			}
			return instance;
		}

		public function load(data:*):Boolean
		{
			var hintList:XMLList = ResManagerHelper.getXmlList(data);
			if (hintList)
			{
				for each (var hint:XML in hintList)
				{
					var id:int = parseInt(hint.@id);
					var place:int = parseInt(hint.@place);
					var configItem:BaseHintConfig = HintConfigFactory.create(hint, _type);
					if (configItem)
					{
						if (hintPatternDic.hasOwnProperty(id))
						{
							log.error("type=" + getTypeName(_type) + ", HintId = " + id + " 配置重复");
						}
						else
						{
							hintPatternDic[id] = configItem;
						}
					}
				}
				return true;
			}
			return false;
		}

		/**
		 * 获取提示配置
		 * @param id
		 * @return
		 *
		 */
		public function getHintConfig(id:int):BaseHintConfig
		{
			var cfg:BaseHintConfig = hintPatternDic[id] as BaseHintConfig;
			if (!cfg)
			{
				log.error("找不到type=" + getTypeName(_type) + ", HintId = " + id + " 对应的提示配置");
				MessageManager.instance.addErrorHint("找不到type=" + getTypeName(_type) + ", HintId = " + id + " 对应的提示配置", HintConst.HINT_PLACE_SYSTEM_HINT);
				return null;
			}
			return cfg;
		}

		public static function getTypeName(type:int):String
		{
			switch (type)
			{
				case HintConst.CONFIG_CLIENT:
					return "CLIENT";
					break;
				case HintConst.CONFIG_SERVER:
					return "SERVER";
					break;
				case HintConst.CONFIG_SERVER_SCRIPT:
					return "SERVER_SCRIPT";
					break;
				default:
					return "";
					break;
			}
		}
	}
}
