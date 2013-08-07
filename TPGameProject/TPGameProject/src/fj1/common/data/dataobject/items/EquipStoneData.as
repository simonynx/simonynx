package fj1.common.data.dataobject.items
{
	import fj1.common.data.dataobject.items.toolTipShowers.EquipStoneToolTipShower;
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.res.item.vo.EquipStoneTemplate;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.modules.equipment.constants.EquipConst;

	public class EquipStoneData extends ItemData
	{
		public function EquipStoneData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(ownerId, guId, info, num, cdEnabled);
			_toolTipShower = new EquipStoneToolTipShower(this);
		}

		public function get equipStoneTemplate():EquipStoneTemplate
		{
			return EquipStoneTemplate(itemTemplate);
		}

		override public function copy():ICopyable
		{
			var item:EquipStoneData = new EquipStoneData(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}
	}
}


