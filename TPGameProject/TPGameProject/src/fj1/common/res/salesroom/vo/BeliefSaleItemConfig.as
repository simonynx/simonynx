package fj1.common.res.salesroom.vo
{

	public class BeliefSaleItemConfig
	{
		public var id:int;
		/**
		 * 大类型
		 */
		public var trade_type:int;
		/**
		 * 子类型
		 */
		public var trade_subtype:int;
		/**
		 * 出售价格
		 */
		public var sale_price:int;
		/**
		 *交易税率
		 */
		public var tax_rate:Number;
		/**
		 *单组数量
		 */
		public var stack:int = 1;
		/**
		 *保存时间
		 */
		public var sale_time_secs:int;

		public function BeliefSaleItemConfig()
		{
		}

		/**
		 *税后收益  向上取整
		 * @return
		 *
		 */
		public function afterRate(num:int):int
		{
			return Math.ceil((1 - tax_rate * 0.01) * sale_price * num);
		}
	}
}
