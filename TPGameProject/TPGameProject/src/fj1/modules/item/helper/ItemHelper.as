package fj1.modules.item.helper
{

	public class ItemHelper
	{
		public function ItemHelper()
		{
		}

		public static function getBagHeadText(index:int):String
		{
			switch (index)
			{
				case 0:
					return "I";
				case 1:
					return "II";
				case 2:
					return "III";
				case 3:
					return "IV";
				case 4:
					return "V";
				default:
					return "";
			}
		}

	}
}
