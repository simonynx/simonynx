package fj1.common.data.dataobject.items
{
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.item.vo.ItemTemplate;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.TAlertEvent;

	public class FixItemData extends ItemData
	{
		public function FixItemData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean = true)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		override public function copy():ICopyable
		{
			var item:FixItemData = new FixItemData(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}

		protected override function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			if (!super.checkUseCondition(onReqSendSuccess))
			{
				return false;
			}
			TAlertHelper.showDialog(48, "确定要修理全部装备吗？", true, TAlert.OK | TAlert.CANCEL, onEnsure);
			return false;
		}

		private function onEnsure(event:TAlertEvent):void
		{
			if (event.flag == TAlert.OK)
			{
				autoUse();
			}
		}

		/**
		 *自动使用
		 *
		 */
		public function autoUse():void
		{
			useObjNotCheckUseEnsure();
		}
	}
}
