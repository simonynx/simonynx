package fj1.common.helper
{
	import fj1.common.res.lan.LanguageManager;

	public class TimerStringHelp
	{
		/**
		 * 将秒数转换为_天_时_分_秒
		 * @param msecond
		 *
		 */
		public static function parseSecond(scends:Number):String
		{
			var d:int = scends / 86400;
			var h:int = (scends / 3600) % 24;
			var m:int = (scends / 60) % 60; //分
			var s:int = scends % 60; //秒
			return (d > 0 ? toNumStr(d) + LanguageManager.translate(100704, "天") : "")
				+ (h > 0 ? toNumStr(h) + LanguageManager.translate(100701, "時") : "")
				+ (m > 0 ? toNumStr(m) + LanguageManager.translate(100702, "分") : "")
				+ (s > 0 ? toNumStr(s) + LanguageManager.translate(100703, "秒") : "")
			//			return (((d < 10) ? "0" : "") + (h + "天")) + (((h < 10) ? "0" : "") + (h + "时")) + (((m < 10) ? "0" : "") + (m + "分")) + (((s < 10) ? "0" : "") + (s + "秒"));
		}

		/**
		 * 将秒数转换为_：_：
		 * @param msecond
		 *
		 */
		public static function parseSecond3(scends:Number):String
		{
			var h:int = scends / 3600;
			var m:int = scends / 60 - h * 60; //分
			var s:int = scends % 60; //秒
			return (((h < 10) ? "0" : "") + (h + ":")) + (((m < 10) ? "0" : "") + (m + ":")) + (((s < 10) ? "0" : "") + s.toString());
		}

		/**
		 * 将秒数转换为_分_秒
		 * @param msecond
		 *
		 */
		public static function parseSecond2(second:Number):String
		{
			var s:int = second % 60; //秒
			var m:int = second / 60; //分
			if (m > 0 && s > 0)
			{
				return m + LanguageManager.translate(100702, "分") + s + LanguageManager.translate(100703, "秒");
			}
			else if (m > 0)
			{
				return m + LanguageManager.translate(100705, "分鐘");
			}
			else
			{
				return s + LanguageManager.translate(100703, "秒");
			}
		}

		/**
		 *  XX:分XX:秒
		 * @param milsecond
		 * @return
		 *
		 */
		public static function parseSecond4(milsecond:Number):String
		{
			var ms:int = milsecond % 60000; //秒
			var m:int = milsecond / 60000; //分
			if (m > 0 && ms > 0)
			{
				return m + LanguageManager.translate(100702, "分") + (ms / 1000).toFixed(1) + LanguageManager.translate(100703, "秒");
			}
			else if (m > 0)
			{
				return m + LanguageManager.translate(100705, "分鐘");
			}
			else
			{
				return (ms / 1000).toFixed(1) + LanguageManager.translate(100703, "秒");
			}
		}

		/**
		 * 将秒数转换为_天_时_分_秒
		 * @param msecond
		 *
		 */
		public static function parseSecond5(scends:Number):String
		{
			var h:int = scends / 3600;
			var m:int = (scends / 60) % 60; //分
			var s:int = scends % 60; //秒
//			return (d > 0 ? toNumStr(d) + "天" : "") + (h > 0 ? toNumStr(h) + "時" : "");
			return (((h < 10) ? "0" : "") + (h + LanguageManager.translate(100701, "時"))) + (((m < 10) ? "0" : "") + (m + LanguageManager.translate(100702, "分")));
		}

		/**
		 * 获取表示时间的字符串，只保留最大的时间单位
		 * @param scends
		 * @return
		 *
		 */
		public static function parseSecond6(scends:int):String
		{
			var d:int = Math.ceil(scends / 86400);
			if (d > 1)
			{
				return d + LanguageManager.translate(100704, "天");
			}
			var h:int = Math.ceil(scends / 3600);
			if (h > 1)
			{
				return h + LanguageManager.translate(100701, "時");
			}
			var m:int = Math.ceil(scends / 60);
			if (m > 1)
			{
				return m + LanguageManager.translate(100702, "分");
			}
			return scends + LanguageManager.translate(100703, "秒");
		}

		private static function toNumStr(value:int, minLen:int = 2):String
		{
			var str:String = "";
			for (var i:int = 0; i < minLen - 1; ++i)
			{
				if (value < (minLen - 1 - i) * 10)
				{
					str += "0";
				}
				else
				{
					break;
				}
			}
			return str + value.toString();
		}
	}
}
