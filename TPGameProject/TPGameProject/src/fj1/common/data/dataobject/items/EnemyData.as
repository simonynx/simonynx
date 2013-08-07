package fj1.common.data.dataobject.items
{
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.manager.MessageManager;

	public class EnemyData extends ItemData
	{
		public function EnemyData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		override protected function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			MessageManager.instance.addHint(LanguageManager.translate(50483, "该物品不能直接使用，请指定仇人后使用"));
			return false;
		}

		override public function copy():ICopyable
		{
			var item:EnemyData = new EnemyData(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}
	}
}
