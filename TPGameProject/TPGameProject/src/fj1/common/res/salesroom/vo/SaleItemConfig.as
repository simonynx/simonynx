package fj1.common.res.salesroom.vo
{

	public class SaleItemConfig
	{
		public var templateid:int;
		public var type:int;
		public var subtype:int;

		public function SaleItemConfig()
		{
		}

		public function get canSell():Boolean
		{
			return type != 0 || subtype != 0;
		}
	}
}
