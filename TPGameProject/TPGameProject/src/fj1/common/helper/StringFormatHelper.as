package fj1.common.helper
{
	import fj1.common.staticdata.ColorConst;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.HtmlUtil;

	public class StringFormatHelper
	{
		private static const reg:RegExp = /\[.*?\]/g;
		private static const reg2:RegExp = /\{.*?\}/g;
		private static const log:ILogger = TLog.getLogger(StringFormatHelper);

//		/**
//		 * [name,size,color,bold,italic]  内容，大小，颜色，加粗，倾斜  //大小和颜色必须设置
//		 * 颜色字符串{red,green,yellow,blue,white}
//		 * @return
//		 *
//		 */
//		public static function getHTMLStr(str:String):String
//		{
//			var str:String = str.replace(reg, function replaceHandler():String
//			{
//				var arr:Array = arguments[0].replace("[", "").toString().replace("]", "").split(",");
//				var name:String = arr[0];
//				name = HtmlUtil.tag("font", [{key: "size", value: arr[1]}, {key: "color", value: TrackHelper.getHtmlColorByStr(arr[2])}], name);
//				if (int(arr[4]) > 0)
//				{
//					name = HtmlUtil.italic(name);
//				}
//				if (int(arr[3]) > 0)
//				{
//					name = HtmlUtil.bold(name);
//				}
//				return name;
//			});
//			return str;
//		}

		/**
		 * {content,color,bold,italic}  内容，颜色，加粗，倾斜  //颜色必须设置
		 * 颜色字符串{red,green,yellow,blue,white}
		 * @return
		 *
		 */
		public static function getHTMLStr2(str:String):String
		{
			var reg:RegExp = /\{.*?\}/g;
			var str:String = str.replace(reg, function replaceHandler():String
			{
				var arr:Array = arguments[0].replace("{", "").toString().replace("}", "").split(",");
				var name:String = arr[0];
				name = HtmlUtil.tag("font", [{key: "color", value: ColorConst.getHtmlColorByStr(arr[1])}], name);
				if (int(arr[2]) > 0)
				{
					name = HtmlUtil.italic(name);
				}
				if (int(arr[3]) > 0)
				{
					name = HtmlUtil.bold(name);
				}
				return name;
			});
			return str;
		}

		public static function format(format:String, ... params):String
		{
			return format.replace(/%([0-9]+?)([dusi])/g, function():String
			{
				var index:int = parseInt(arguments[1]);
				var flag:String = String(arguments[2]);
				var ret:String;
//				if (flag == "i") //替换物品名称
//				{
//					var templateId:int = parseInt(params[index]);
//					if (templateId)
//					{
//						var template:ItemTemplate = ItemTemplateManager.instance.get(templateId);
//						if (template)
//						{
//							ret = template.name;
//						}
//					}
//				}
//				else
//				{
				ret = params[index];
//				}
				return ret;
			});
		}

		public static function format2(format:String, ... params):String
		{
			if (params && params.length > 0)
			{
				return String(StringFormatHelper.format.apply(null, [format].concat(params))).replace(/\\n/g, "\n");
			}
			else
			{
				return format.replace(/\\n/g, "\n");
			}
		}
	}
}
