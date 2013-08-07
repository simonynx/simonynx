package fj1.common.res.item.vo
{
	import fj1.common.data.dataobject.items.EquipmentData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.res.item.ItemTemplateManager;

	public class LuckBoxAwardData
	{
		public var id:int;
		public var item_count:int;
		public var dynamicprovalue:int;
		public var appear_rate:int; //累加概率
		public var purAppearRate:int; //原始配置出现概率
		public var iscan_reappear:Boolean;
		public var tempDisabled:Boolean = false;
		public var packs_template_id:int;

		private var _itemData:ItemData;
		private var _item_template_id:int;

		public function LuckBoxAwardData()
		{
		}

		public function get item_template_id():int
		{
			return _item_template_id;
		}

		public function set item_template_id(value:int):void
		{
			_item_template_id = value;
		}

		public function get itemData():ItemData
		{
			if (!_itemData && _item_template_id > 0)
			{
				_itemData = ItemDataFactory.createByID(0, 0, _item_template_id, null, item_count);
				var equipData:EquipmentData = _itemData as EquipmentData;
				if (equipData)
				{
					equipData.strengthenLevel = dynamicprovalue;
				}
			}
			return _itemData;
		}
	}
}
