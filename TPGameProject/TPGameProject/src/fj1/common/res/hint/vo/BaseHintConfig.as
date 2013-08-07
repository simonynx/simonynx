package fj1.common.res.hint.vo
{
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.HintConst;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class BaseHintConfig
	{
		private static const log:ILogger = TLog.getLogger(BaseHintConfig);
		private var _type:int;
		private var _id:int;
		protected var _pattern:String;
		private var _lanID:int;
		///添加配置属性
		private var _delay:Number;
		private var _size:int;
		private var _color:int;
		private var _font:String;
		private var _configtype:int;

		/**
		 *停留时间
		 * @return
		 *
		 */
		public function get delay():Number
		{
			return _delay;
		}

		/**
		 *字体大小
		 * @return
		 *
		 */
		public function get size():int
		{
			return _size;
		}

		/**
		 * 字体颜色
		 * @return
		 *
		 */
		public function get color():int
		{
			return _color;
		}

		/**
		 * 字体
		 * @return
		 *
		 */
		public function get font():String
		{
			return _font;
		}

		/**
		 *语言id
		 * @return
		 *
		 */
		public function get lanID():int
		{
			return _lanID;
		}

		/**
		 *显示类型，显示区域
		 * @return
		 *
		 */
		public function get type():int
		{
			return _type;
		}

		public function get id():int
		{
			return _id;
		}

		public function get pattern():String
		{
			return _pattern;
		}

		public function BaseHintConfig(type:int, id:int, pattern:String, lanID:int = 0, delay:int = 0, size:int = 0, color:int = 0, font:String = null, configtype:int = 0)
		{
			_type = type;
			_id = id;
			_lanID = lanID;
			_delay = delay;
			_size = size;
			_color = color;
			_font = font;
			_configtype = configtype;
			if (_lanID != 0)
			{
				pattern = LanguageManager.translate(_lanID);
				if (!pattern)
				{
					switch (_configtype)
					{
						case HintConst.CONFIG_CLIENT:
							log.error("配置hints_client.xml有误，无效的 languageId = " + _lanID + " hintId = " + id);
							break;
						case HintConst.CONFIG_SERVER:
							log.error("配置hints_server.xml有误，无效的 languageId = " + _lanID + " hintId = " + id);
							break;
						case HintConst.CONFIG_SERVER_SCRIPT:
							log.error("配置hints_script.xml有误，无效的 languageId = " + _lanID + " hintId = " + id);
							break;
						default:
							log.error("BaseHintConfig 构造失败，无效的 languageId = " + _lanID + " hintId = " + id);
							break;
					}
				}
			}
			if (pattern)
			{
				_pattern = pattern.replace("\\n", "\n");
			}
		}
	}
}
