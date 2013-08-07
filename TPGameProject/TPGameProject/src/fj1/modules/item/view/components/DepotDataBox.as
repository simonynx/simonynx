package fj1.modules.item.view.components
{
	import assets.UISkinLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.items.ExpendItemData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.interfaces.IStoredObject;
	import fj1.common.data.interfaces.IUseable;
	import fj1.common.helper.ItemOperateHelper;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.MenuOperationType;
	import fj1.common.staticdata.ToolTipName;
	import fj1.common.ui.MenuDataItem;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.BagItemManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.view.components.level2.ExpendDialog;
	import fj1.modules.item.view.components.level2.SplitDialog;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.TToolTipManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TImage;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TListMenu;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.components.tips.TSimpleToolTip;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.effects.CDEffect;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.events.MenuEffectEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TWindowEvent;
	import tempest.ui.interfaces.ISlotData;

	public class DepotDataBox extends BaseDataBox
	{
		private var _depotView:HeroDepotPanel;
		private var _closed:Boolean;

		public function DepotDataBox(_proxy:* = null, dragBackAreaArray:Array = null)
		{
			super(_proxy, dragBackAreaArray);
			this.dragImage.addEventListener(DragEvent.DROP_DOWN, onItemDropDown);
			this.dragImage.place = DragImagePlaces.HERO_DEPOT;
			this.dragImage.dragAccpetPlaces = [DragImagePlaces.HERO_DEPOT, DragImagePlaces.BAG, DragImagePlaces.AWORD_DEPOT];
			this.dragImage.fetchEnable = true; //可以被提取(抛出FetchEvent事件)
			this.dragImage.addEventListener(FetchEvent.FETCH, onFetch);
		}

		private function get depotView():HeroDepotPanel
		{
			if (!_depotView)
			{
				var _parent:DisplayObject = this.parent;
				while (_parent)
				{
					if (_parent is HeroDepotPanel)
					{
						_depotView = _parent as HeroDepotPanel;
						break;
					}
					_parent = _parent.parent;
				}
			}
			return _depotView;
		}

		private function onFetch(event:FetchEvent):void
		{
			switch (event.fetchType)
			{
				case FetchType.DEPOT:
					//放入背包
					var itemData:ItemData = ItemData(this.data);
					if (itemData)
					{
						var targetSlot:int = SlotItemManager.instance.getFristEmptySlot(ItemConst.CONTAINER_BACKPACK);
						if (targetSlot < 0)
						{
							MessageManager.instance.addHintById_client(29, "背包已满");
						}
						else
						{
							ItemOperateHelper.moveItem(itemData, targetSlot);
//							GameClient.sendItemMove(itemData.guId, itemData.slot, targetSlot);
						}
					}
					FetchHelper.instance.keepFetching(); //保持提取状态
					break;
				case FetchType.PACK:
//					itemData = ItemData(this.data);
//					if (!itemData)
//						return;
//					var packMaker:PackHolderData = FetchHelper.instance.parms as PackHolderData;
//					packMaker.pack(itemData);
					break;
			}
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if (enabled)
			{
				this.removeFilters();
			}
			else
			{
				this.setFilter(UIStyle.disableFilter);
			}
		}

		/**
		 * 构造菜单(派生类可以扩展)
		 * @param event
		 *
		 */
		override protected function buildMenu():Array
		{
			super.buildMenu();
			var itemData:ItemData = data as ItemData;
			if (!itemData)
				return [];
//			if (itemData is EquipmentData)
//			{
//				return [MenuOperationType.PICK_UP,
//					MenuOperationType.SEND_TO_CHAT];
//			}
//			else
//			{
			if (itemData.num > 1)
				return [MenuOperationType.PICK_UP,
					MenuOperationType.SEND_TO_CHAT];
			else
				return [MenuOperationType.PICK_UP,
					MenuOperationType.SEND_TO_CHAT];
//			}
		}

		/**
		 * 弹出菜单点击 (派生类可以扩展)
		 * @param event
		 *
		 */
		override protected function onMenuSelect(event:Event):void
		{
			super.onMenuSelect(event);
			if (!data)
			{
				return;
			}
			var menu:TListMenu = TListMenu(event.currentTarget);
			switch ((menu.list.selectedItem as MenuDataItem).operateType)
			{
				case MenuOperationType.SEND_TO_CHAT:
					(data as IStoredObject).sendToChat();
					break;
				case MenuOperationType.PICK_UP:
					_dragImage.pickUp();
					break;
			}
		}

		private function onSplitPanelClose(event:Event):void
		{
			with (event.currentTarget)
			{
				removeEventListener(event.type, arguments.callee);
				removeEventListener("split", onSplitCommit);
			}
		}

		/**
		 * 物品放下操作
		 * @param event
		 *
		 */
		private function onItemDropDown(event:DragEvent):void
		{
			var imageFrom:TDragableImage = event.dragFromImage as TDragableImage;
			var imageTarget:TDragableImage = event.dragImageTarget as TDragableImage;
			var indexTarget:int = depotView.getRenderIndex(imageTarget);
			switch (imageFrom.place)
			{
				case DragImagePlaces.HERO_DEPOT: //移动
					var indexFrom:int = ISlotData(DragManager.dragingData).slot & 0x000000FF;
					//;
					if (indexFrom == indexTarget)
						return;
					ItemOperateHelper.moveItem(ItemData(DragManager.dragingData), ItemConst.CONTAINER_DEPOT << 8 | indexTarget);
//					GameClient.sendItemMove(DataObject(DragManager.dragingData).guId, ISlotData(DragManager.dragingData).slot, ItemConst.CONTAINER_DEPOT << 8 | indexTarget);
					break;
				case DragImagePlaces.BAG: //从背包中取出
					var item:ItemData = ItemData(DragManager.dragingData);
					if (item.itemTemplate.is_can_store)
					{
						ItemOperateHelper.moveItem(item, ItemConst.CONTAINER_DEPOT << 8 | indexTarget);
//						GameClient.sendItemMove(item.guId, item.slot, ItemConst.CONTAINER_DEPOT << 8 | indexTarget);
					}
					else
					{
						MessageManager.instance.addHintById_client(30, "该物品不能存储");
					}
					break;
			}
		}

		override protected function onClick(event:MouseEvent):void
		{
			if (_closed)
			{
				//尝试获取开启背包物品
				var expendItemdata:ExpendItemData = BagItemManager.instance.getFirstItemByType(ItemConst.TYPE_ITEM_DRUG, ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT) as ExpendItemData;
				if (expendItemdata)
				{
					expendItemdata.useObj();
				}
				else
				{
					TWindowManager.instance.showPopup2(null, ExpendDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT, null)
				}
				return;
			}
			super.onClick(event);
		}
		private var mc_lock1:DisplayObject = RslManager.getInstance(UISkinLib.bagLock);

		public function set closed(value:Boolean):void
		{
			_closed = value;
			if (_closed)
			{
				this.addChild(mc_lock1);
				this.buttonMode = true;
				this.useHandCursor = true;
			}
			else
			{
				this.buttonMode = false;
				this.useHandCursor = false;
				if (mc_lock1.parent)
					mc_lock1.parent.removeChild(mc_lock1);
			}
		}
	}
}
