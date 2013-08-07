package fj1.common.staticdata
{
	import tempest.utils.RegexUtil;

	public class RegexConst
	{
		public static const NameRegExp:RegExp = new RegExp("[" + RegexUtil.Number + RegexUtil.Letter + RegexUtil.Chinese + RegexUtil.Korean + "·]+");
		public static const NameRegExp2:RegExp = new RegExp("[^" + RegexUtil.Number + RegexUtil.Letter + RegexUtil.Chinese + RegexUtil.Korean + "·]+");
		public static const NameRegExp3:RegExp = new RegExp("[^\\s" + RegexUtil.Number + RegexUtil.Letter + RegexUtil.Chinese + RegexUtil.Korean + "·]+");

		public static function nameTest(str:String):Boolean
		{
			if (str.match(NameRegExp2))
				return true;
			else
				return false;
		}

		public static function nameTestSpace(str:String):Boolean
		{
			if (str.match(NameRegExp3))
				return true;
			else
				return false;
		}

		public static function Unable(str:String):Boolean
		{
			return false;
		}
	}
}
