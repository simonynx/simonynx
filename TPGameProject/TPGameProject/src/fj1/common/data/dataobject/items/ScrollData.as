package fj1.common.data.dataobject.items
{
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.item.view.components.level2.ScrollPanelDialog;

	import tempest.ui.events.TWindowEvent;

	public class ScrollData extends ItemData
	{
		public function ScrollData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		private var dialog:ScrollPanelDialog;

		protected override function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			if(!super.checkUseCondition(onReqSendSuccess))
			{
				return false;
			}
			dialog = ScrollPanelDialog(TWindowManager.instance.showPopup2(null, ScrollPanelDialog.NAME, true, false, TWindowManager.MODEL_USE_OLD, null, this, itemTemplate.id));
//			this.locked = true; //锁定自身，不允许被操作
			dialog.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			return false;
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			this.useObjNotCheckUseEnsure();
			dialog.removeEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
		}

		override public function copy():ICopyable
		{
			var item:ScrollData = new ScrollData(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}
	}
}
