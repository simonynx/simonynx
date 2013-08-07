package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;
	import assets.WindowTitleLib;

	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.ItemNumCounter;
	import fj1.common.data.dataobject.items.ExpendItemData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.BaseDialog;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.manager.BagItemManager;
	import fj1.manager.ItemNumCounterManager;
	import fj1.modules.item.helper.ItemHelper;
	import fj1.modules.item.view.components.HeroBagPanel;
	import fj1.modules.main.MainFacade;
	import fj1.modules.mall.signal.MallSignal;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TWindowEvent;

	public class ExpendDialog extends BaseDialog
	{
		private var _dataBox:BaseDataBox;
		private var _type:int;
		public static var NAME:String = "ExpendDialog";

		public function ExpendDialog()
		{
			super(RslManager.getDefinition(UIResourceLib.UI_GAME_GUI_EXPEND_DIALOG), NAME);
			setTitle(WindowTitleLib.getTitleClass(LanguageManager.translate(1009, "系统信息")));
			_dataBox = new BaseDataBox(_proxy.mc_item);
			_dataBox.dragImage.pickUpEnable = false;
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			_proxy.txt_waring.mouseEnabled = false;
		}

		private function findHandler(template:ItemTemplate):Boolean
		{
			if (template.type == ItemConst.TYPE_ITEM_DRUG && template.subtype == _type)
				return true;
			else
				return false;
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			_type = int(event.data);
			switch (_type)
			{
				case ItemConst.SUB_TYPE_DRUG_EXPEND_BAG:
					setMsg(LanguageManager.translate(29003, "背包扩容需要消耗："));
					_proxy.txt_waring.text = LanguageManager.translate(29002, "使用后你将额外获得10个背包存储格");
					break;
				case ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT:
					setMsg(LanguageManager.translate(29004, "仓库扩容需要消耗："));
					_proxy.txt_waring.text = LanguageManager.translate(29023, "使用后你将额外获得10个仓库存储格");
					break;
				case ItemConst.SUB_TYPE_DRUG_EXPEND_PET:
					setMsg(LanguageManager.translate(29025, "扩充宠物栏需要消耗："));
					_proxy.txt_waring.text = LanguageManager.translate(29026, "使用后你将额外获得5个宠物栏");
					break;
			}
			var item:ItemData = this.data as ItemData;
			if (!item)
			{
				item = ItemDataFactory.createByTemplate(0, 0, getExpendItemTemplate(), null, 0);
				item.needShowNum = false;
			}
			_dataBox.data = item;
			if (item.num)
			{
				_dataBox.filters = null;
			}
			else
			{
				_dataBox.filters = [UIStyle.disableFilter];
			}
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			this.data = null;
		}
		private var _itemTemplates:Array = [];

		private function getExpendItemTemplate():ItemTemplate
		{
			if (!_itemTemplates[_type])
			{
				_itemTemplates[_type] = ItemTemplateManager.instance.find(findHandler);
			}
			return _itemTemplates[_type] as ItemTemplate;
		}

		override protected function onSubmitClick(event:MouseEvent):void
		{
//			super.onSubmitClick(event);
			var expendItem:ItemData = this.data as ExpendItemData;
			if (expendItem)
			{
				expendItem.useObjNotCheckUseEnsure();
			}
			else
			{
				var dialog:TAlert;
				switch (_type)
				{
					case ItemConst.SUB_TYPE_DRUG_EXPEND_BAG:
						dialog = TAlertHelper.showDialog(39, "您的背包中没有虚空之间，请到商城购买", true, TAlert.OK | TAlert.CANCEL, onBuyEnsure);
						break;
					case ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT:
						dialog = TAlertHelper.showDialog(40, "您的背包中没有混沌之间，请到商城购买", true, TAlert.OK | TAlert.CANCEL, onBuyEnsure);
						break;
					case ItemConst.SUB_TYPE_DRUG_EXPEND_PET:
						dialog = TAlertHelper.showDialog(40, "您的背包中没有混沌之间，请到商城购买", true, TAlert.OK | TAlert.CANCEL, onBuyEnsure);
						break;
				}
				dialog.setButtonText(TAlert.OK, LanguageManager.translate(100019, "购买"));
			}
			this.closeWindow();
		}

		private function onBuyEnsure(event:TAlertEvent):void
		{
			if (event.flag == TAlert.OK)
			{
				var mallSignals:MallSignal = MainFacade.instance.inject.getInstance(MallSignal) as MallSignal;
				mallSignals.queryItem.dispatch(getExpendItemTemplate().id);
			}
		}

		override protected function onCancelClick(event:MouseEvent):void
		{
			super.onCancelClick(event);
		}
	}
}
