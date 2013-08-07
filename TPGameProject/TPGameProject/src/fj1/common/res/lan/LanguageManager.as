package fj1.common.res.lan
{
	import fj1.common.res.ResManagerHelper;

	import tempest.common.logging.*;
	import tempest.utils.StringUtil;

	public final class LanguageManager
	{
		private static const log:ILogger = TLog.getLogger(LanguageManager);
		private static var _languageDict:Array = [];
		private static var _languageDict2:Object = {};

		public static function load(data:*):Boolean
		{
			var xmlList:XMLList = ResManagerHelper.getXmlList(data);
			if (xmlList)
			{
				for each (var item:XML in xmlList)
				{
					var id:int = parseInt(item.@id);
					if (_languageDict[id])
					{
						log.error("LanguageID重复！" + id);
						continue;
					}
					_languageDict[id] = String(item.@str).replace(/\\r/g, "\r").replace(/\\n/g, "\n");
				}
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param id
		 * @param defaultStr
		 * @param args
		 * @return
		 *
		 */
		public static function translate(id:int, defaultStr:String = "", ... args):String
		{
			var str:String = _languageDict[id] || defaultStr;
			if (args.length != 0)
				str = StringUtil.format.apply(null, [str].concat(args));
			return str;
		}

		////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 脚本多语言文件
		 * @param data
		 * @return
		 */
		public static function load2(data:*):Boolean
		{
			var xmlList:XMLList = ResManagerHelper.getXmlList(data);
			if (xmlList)
			{
				var src:String;
				var trans:String;
				for each (var item:XML in xmlList)
				{
					src = item.@src;
					trans = item.@trans;
					if (_languageDict2[src])
					{
						log.error("Language2ID重复！" + src);
						continue;
					}
					if (StringUtil.trim(trans))
						_languageDict2[src] = trans;
				}
				return true;
			}
			return false;
		}

		/**
		 * 翻译
		 * @param src 源文本
		 * @param args 参数
		 * @return
		 */
		public static function translate2(src:String, ... args):String
		{
			var $src:String = _languageDict2[src] || src;
			if (args.length != 0)
				$src = StringUtil.format.apply(null, [$src].concat(args));
			return $src;
		}
	}
}
