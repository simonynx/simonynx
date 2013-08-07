package fj1.common.res.item.vo
{

	public class EquipSlotTemplate
	{
		public var id:int; //槽位(1~5)
		public var open_succ_rate:int; //开启成功率（万分比）
		public var expend_item_id:int; //开启消耗道具ID
		public var expend_item_count:int; //开启消耗道具数量
		public var expend_money:int; //开启消耗金币数量

		public function EquipSlotTemplate()
		{
		}
	}
}
