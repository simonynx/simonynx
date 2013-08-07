package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;

	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.ui.BaseDialog;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataBox;

	import flash.events.MouseEvent;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.UIStyle;
	import tempest.ui.events.TWindowEvent;

	public class ItemUseDialog extends BaseDialog
	{
		private var _dataBox:BaseDataBox;
		private var _type:int;
		public static var NAME:String = "ItemUseDialog";

		public function ItemUseDialog()
		{
			super(TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_EXPEND_DIALOG), NAME);
			_dataBox = new BaseDataBox(_proxy.mc_item);
			_dataBox.dragImage.pickUpEnable = false;
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			_proxy.txt_waring.text = "重置神佑技能冷却时间";
			setMsg("使用后你的神佑技能冷却时间将被重置");
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function setMsg2(value:String):void
		{
			_proxy.txt_waring.text = value;
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			var itemData:ItemData = ItemData(event.data);
			_dataBox.data = itemData;
			if (itemData.num)
			{
				_dataBox.filters = null;
			}
			else
			{
				_dataBox.filters = [UIStyle.disableFilter];
			}
		}

		private static var _showingDialog:ItemUseDialog;

		/**
		 *
		 * @param msg1
		 * @param msg2
		 * @param itemData
		 * @param modal
		 * @param ensureHandler
		 * @param cancelHandler
		 * @return
		 *
		 */
		public static function show(msg1:String, msg2:String, itemData:ItemData, modal:Boolean = false, ensureHandler:Function = null, cancelHandler:Function = null):ItemUseDialog
		{
			if (_showingDialog)
			{
				_showingDialog.removeEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
				_showingDialog.closeWindow();
			}
			_showingDialog = new ItemUseDialog();
			_showingDialog.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			_showingDialog.data = itemData;
			_showingDialog.setMsg(msg1);
			_showingDialog.setMsg2(msg2);
			if (ensureHandler != null)
			{
				_showingDialog.btn_submit.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
				{
					ensureHandler(itemData);
				});
			}
			if (cancelHandler != null)
			{
				_showingDialog.btn_cancel.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
				{
					cancelHandler(itemData);
				});
			}

			return ItemUseDialog(TWindowManager.instance.showPopup(null, _showingDialog, modal, modal, null, itemData));
		}

		private static function onWindowClose(event:TWindowEvent):void
		{
			_showingDialog = null;
		}
	}
}
