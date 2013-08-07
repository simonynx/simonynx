package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;

	import tempest.common.staticdata.Colors;

	public class ItemQuality
	{
		public static const MIN_QUALITY:int = QUALITY_0;
		public static const QUALITY_0:int = 1;
		public static const QUALITY_1:int = 2;
		public static const QUALITY_2:int = 3;
		public static const QUALITY_3:int = 4;
		public static const QUALITY_4:int = 5;
		public static const QUALITY_5:int = 6;
		public static const MAX_QUALITY:int = QUALITY_5;

		public static function getStyleName(quality:int):String
		{
			switch (quality)
			{
				case QUALITY_0:
					return "name_quality0";
				case QUALITY_1:
					return "name_quality1";
				case QUALITY_2:
					return "name_quality2";
				case QUALITY_3:
					return "name_quality3";
				case QUALITY_4:
					return "name_quality4";
				case QUALITY_5:
					return "name_quality5";
				default:
					return "name_quality0";
			}
		}

		public static function getName(quality:int):String
		{
			switch (quality)
			{
				case QUALITY_0:
					return LanguageManager.translate(2051, "普通");
				case QUALITY_1:
					return LanguageManager.translate(2052, "优秀");
				case QUALITY_2:
					return LanguageManager.translate(2053, "精良");
				case QUALITY_3:
					return LanguageManager.translate(2054, "史诗");
				case QUALITY_4:
					return LanguageManager.translate(2055, "传说");
				case QUALITY_5:
					return LanguageManager.translate(2058, "神器");
				default:
					return LanguageManager.translate(100004, "未知");
			}
		}

		/**
		 * 根据品质获取颜色值
		 * @param quality
		 * @return
		 */
		public static function getColor(quality:int):uint
		{
			switch (quality)
			{
				case QUALITY_0:
					return Colors.White;
				case QUALITY_1:
					return Colors.Green;
				case QUALITY_2:
					return Colors.DodgeBlue;
				case QUALITY_3:
					return Colors.QulityPurple;
				case QUALITY_4:
					return Colors.QulityOringe;
				case QUALITY_5:
					return Colors.QulityRed;
				default:
					return Colors.White;
			}
		}

		/**
		 * 根据品质获取颜色值
		 * @param quality
		 * @return
		 */
		public static function getColorString(quality:int):String
		{
			switch (quality)
			{
				case QUALITY_0:
					return ColorConst.Hex2str(Colors.White);
				case QUALITY_1:
					return ColorConst.Hex2str(Colors.Green);
				case QUALITY_2:
					return ColorConst.Hex2str(Colors.DodgeBlue);
				case QUALITY_3:
					return ColorConst.Hex2str(Colors.QulityPurple);
				case QUALITY_4:
					return ColorConst.Hex2str(Colors.QulityOringe);
				case QUALITY_5:
					return ColorConst.Hex2str(Colors.QulityRed);
				default:
					return ColorConst.Hex2str(Colors.White);
			}
		}

		public static function check(quality:int):Boolean
		{
			return quality >= MIN_QUALITY && quality <= MAX_QUALITY;
		}
	}
}
