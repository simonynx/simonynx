package fj1.common.staticdata
{
	import tempest.common.staticdata.Colors;

	public class ColorConst
	{
		public static function str2Hex(value:String):uint
		{
			return parseInt(value.replace("#", "0x"));
		}

		public static function Hex2str(value:uint):String
		{
			return "#" + value.toString(16).substring(2);
		}

		/**
		 *获取HMTL类型颜色
		 * @param colorNum
		 * @return
		 *
		 */
		public static function getHtmlColor(colorNum:uint):String
		{
			if (colorNum > 0)
			{
				return Hex2str(colorNum);
			}
			return "";
		}

		/**
		 *绿色
		 * @return
		 *
		 */
		public static function get green():String
		{
			return getHtmlColor(Colors.Green);
		}

		/**
		 *深蓝
		 * @return
		 *
		 */
		public static function get deepBlue():String
		{
			return getHtmlColor(Colors.deepBlue);
		}

		/**
		 *黄色
		 * @return
		 *
		 */
		public static function get yellow():String
		{
			return getHtmlColor(Colors.Yellow);
		}

		/**
		 *白色
		 * @return
		 *
		 */
		public static function get white():String
		{
			return getHtmlColor(Colors.White);
		}

		/**
		 *浅蓝
		 * @return
		 *
		 */
		public static function get lightBlue():String
		{
			return getHtmlColor(Colors.LightBlue);
		}

		/**
		 *红色
		 * @return
		 *
		 */
		public static function get red():String
		{
			return getHtmlColor(Colors.Red);
		}

		/**
		 *橙色
		 * @return
		 *
		 */
		public static function get orange():String
		{
			return getHtmlColor(Colors.Orange);
		}

		/**
		 *灰色
		 * @return
		 *
		 */
		public static function get gray():String
		{
			return getHtmlColor(Colors.Gray);
		}

		/**
		 *
		 * @param id
		 * @return
		 * 赏金任务名字更具任务难度等级来显示任务名字的颜色
		 */
		public static function getColorById(id:int):String
		{
			switch (id)
			{
				case 0:
				case 1:
					return white;
				case 2:
					return green;
				case 3:
					return lightBlue;
				case 4:
					return getHtmlColor(Colors.Purple);
				case 5:
					return orange;
			}
			return white;
		}

		/**
		 * 根据字符串获取对应的HTML颜色字符串
		 * @param str
		 * @return
		 *
		 */
		public static function getHtmlColorByStr(str:String):String
		{
			switch (str)
			{
				case "red":
					return ColorConst.red;
					break;
				case "green":
					return ColorConst.green;
					break;
				case "white":
					return ColorConst.white;
				case "blue":
					return ColorConst.getHtmlColor(Colors.QulityBlue);
					break;
				case "yellow":
					return ColorConst.yellow;
					break;
				default:
					return str;
			}
		}
	}
}
