package fj1.modules.item.view.components
{
	import assets.ResLib;
	import assets.UISkinLib;

	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.items.ExpendItemData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.interfaces.IStoredObject;
	import fj1.common.data.interfaces.IUseable;
	import fj1.common.helper.ItemOperateHelper;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.salesroom.SalesroomConfigManager;
	import fj1.common.res.salesroom.vo.BeliefSaleItemConfig;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.staticdata.MenuOperationType;
	import fj1.common.ui.MenuDataItem;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.manager.BagItemManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.service.ItemService;
	import fj1.modules.item.view.components.level2.ExpendDialog;
	import fj1.modules.item.view.components.level2.SplitDialog;
	import fj1.modules.main.MainFacade;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TListMenu;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TWindowEvent;
	import tempest.ui.interfaces.ISlotData;

	/**
	 * Entity容器，支持Tip，弹出菜单，拖放，和冷却效果遮罩等
	 * @author linxun
	 *
	 */
	public class BagDataBox extends BaseDataBox
	{
		private var _bagView:HeroBagPanel;
		private var _inFilterState:Boolean;
		private var _closed:Boolean;

		public function BagDataBox(_proxy:* = null, dragBackAreaArray:Array = null)
		{
			super(_proxy, dragBackAreaArray);
			this.dragImage.addEventListener(DragEvent.DROP_OUT, onDropOut);
			this.dragImage.addEventListener(DragEvent.DROP_DOWN, onItemDropDown);
			this.dragImage.place = DragImagePlaces.BAG;
			this.dragImage.dragAccpetPlaces = [DragImagePlaces.EQUIPMENT, DragImagePlaces.BAG, DragImagePlaces.HERO_DEPOT, DragImagePlaces.NPC_SHOP, DragImagePlaces.AWORD_DEPOT];
			this.dragImage.fetchEnable = true; //可以被提取(抛出FetchEvent事件)
			this.dragImage.addEventListener(FetchEvent.FETCH, onFetch);
			this.dragImage.addEventListener(DragEvent.PICK_UP, onPickUp);
			this.useDoubleClick = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}

		private function onPickUp(event:DragEvent):void
		{
//			var itemData:ItemData = this.data as ItemData;
//			if (itemData.playerBinded)
//			{
//				if (TWindowManager.instance.findPopup(MailTabPanel.NAME) && GameInstance.ui.mailTabPanel.tabController.selectedIndex == 1)
//				{
//					event.preventDefault();
//				}
//			}
		}

		private function get bagView():HeroBagPanel
		{
			if (!_bagView)
			{
				var _parent:DisplayObject = this.parent;
				while (_parent)
				{
					if (_parent is HeroBagPanel)
					{
						_bagView = _parent as HeroBagPanel;
						break;
					}
					_parent = _parent.parent;
				}
			}
			return _bagView;
		}

		private function onFetch(event:FetchEvent):void
		{
//			var npcShop:NPCShop;
			var itemData:ItemData = this.data as ItemData;
			switch (event.fetchType)
			{
//				case FetchType.SELL:
//					npcShop = FetchHelper.instance.parms as NPCShop;
//					if (itemData)
//					{
//						npcShop.sell(itemData);
//					}
//					break;
//				case FetchType.FIX:
//					npcShop = FetchHelper.instance.parms as NPCShop;
//					var equipData:EquipmentData = itemData as EquipmentData;
//					if (equipData)
//					{
//						equipData.fix(npcShop.getOpenNpcId());
//					}
//					break;
				case FetchType.DEPOT:
					//放入仓库
					if (itemData)
					{
						var targetSlot:int = SlotItemManager.instance.getFristEmptySlot(ItemConst.CONTAINER_DEPOT);
						if (targetSlot < 0)
						{
							MessageManager.instance.addHintById_client(28, "仓库已满");
						}
						else
						{
							if (itemData.itemTemplate.is_can_store)
							{
								ItemOperateHelper.moveItem(itemData, targetSlot);
							}
							else
							{
								MessageManager.instance.addHintById_client(30, "该物品不能存储");
							}
//							GameClient.sendItemMove(itemData.guId, itemData.slot, targetSlot);
						}
					}
					break;
				case FetchType.PACK:
//					if (!itemData)
//					{
//						return;
//					}
//					if (itemData.playerBinded)
//					{
//						TAlertHelper.showAlert(32, "无法打包绑定物品");
//						return;
//					}
//					if (!itemData.itemTemplate.is_can_trade)
//					{
//						TAlertHelper.showAlert(33, "无法打包不可交易物品");
//						return;
//					}
//					var packMaker:PackHolderData = FetchHelper.instance.parms as PackHolderData;
//					packMaker.pack(itemData);
					break;
//				case FetchType.ACCESSORY:
//					if (itemData)
//					{
//						if (!itemData.playerBinded)
//							GameInstance.model.mail.addItemList2(itemData);
//					}
//					break;
//				case FetchType.IDENTIFIER:
//					//装备鉴定
//					GameInstance.signal.equipIdentify.identify.dispatch(itemData, ItemData(event.params));
//					break;
				case FetchType.UINTE:
//					var equipmentData:EquipmentData = this.data as EquipmentData;
//					if (equipmentData)
//					{
//						GameInstance.signal.equipMasteryView.uniteEquipment.dispatch(equipmentData);
//					}
//					else
//					{
					MessageManager.instance.addHint(LanguageManager.translate(23028, "该物品无法进行分解"));
//					}
					break;
			}
			FetchHelper.instance.keepFetching(); //保持提取状态
		}

		/**
		 *
		 * @param value
		 *
		 */
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
			var arr:Array = [];
			var itemData:ItemData = data as ItemData;
			if (!itemData)
				return [];
//			if (itemData is EquipmentData)
//			{
//				if (itemData.itemTemplate.isCollectUtil) //采集道具
//				{
//					arr = [MenuOperationType.PICK_UP,
//						MenuOperationType.DISCARD,
//						MenuOperationType.SEND_TO_CHAT];
//				}
//				else
//				{
//					arr = [MenuOperationType.EQUIP];
//					if (!EquipmentData(itemData).equipmentTemplate.isFashionCloth) //时装不可强化
//					{
//						arr.push(MenuOperationType.LEVELUP);
//					}
//					arr = arr.concat([MenuOperationType.PICK_UP,
//						MenuOperationType.DISCARD,
//						MenuOperationType.SEND_TO_CHAT]);
//				}
//			}
//			else
//			{
			if (itemData.num > 1)
			{
				arr = (itemData.itemTemplate.can_be_use ? [MenuOperationType.USE] : []);
				if (itemData.canMutiUse)
				{
					arr.push(MenuOperationType.MUTIUSE);
				}
				arr = arr.concat([MenuOperationType.PICK_UP,
					MenuOperationType.SPLIT,
					MenuOperationType.DISCARD,
					MenuOperationType.SEND_TO_CHAT]);
			}
			else
			{
				arr = (itemData.itemTemplate.can_be_use ? [MenuOperationType.USE] : []).concat([MenuOperationType.PICK_UP,
					MenuOperationType.DISCARD,
					MenuOperationType.SEND_TO_CHAT]);
			}
//			}
			return arr;
		}

		/**
		 * 弹出菜单点击 (派生类可以扩展)
		 * @param event
		 *
		 */
		override protected function onMenuSelect(event:Event):void
		{
			super.onMenuSelect(event);
			var menu:TListMenu = TListMenu(event.currentTarget);
			if (!data)
			{
				return;
			}
			switch ((menu.list.selectedItem as MenuDataItem).operateType)
			{
				case MenuOperationType.USE:
					(data as IUseable).useObj();
					break;
				case MenuOperationType.DISCARD:
					(data as IStoredObject).discardObj();
					break;
				case MenuOperationType.EQUIP:
					(data as IUseable).useObj();
					break;
				case MenuOperationType.SEND_TO_CHAT:
					(data as IStoredObject).sendToChat();
					break;
				case MenuOperationType.PICK_UP:
					_dragImage.pickUp();
					break;
				case MenuOperationType.SPLIT:
					if ((data as ItemData).validDate)
					{
						MessageManager.instance.addHintById_client(65, "不能拆分");
						return;
					}
					var spanel:SplitDialog = SplitDialog(TWindowManager.instance.showPopup2(TWindowManager.getParentWindow(this), SplitDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD));
					spanel.setSplitData(ItemData(data));
					spanel.addEventListener("split", onSplitCommit);
					spanel.data = data;
					spanel.addEventListener(TWindowEvent.WINDOW_CLOSE, onSplitPanelClose);
					break;
//				case MenuOperationType.LEVELUP:
//					TWindowManager.instance.showPopup2(null, EquipSmithyPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, null, 1);
//					break;
//				case MenuOperationType.MUTIUSE:
//					TWindowManager.instance.removePopupByName(MutiUseItemPanel.NAME);
//					TWindowManager.instance.showPopup2(null, MutiUseItemPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, null, data);
//					break;
			}
		}

		private function onSplitCommit(event:DataEvent):void
		{
			var itemData:ItemData = ItemData(event.currentTarget.data);
			var splitnum:int = int(event.data);
			if (splitnum <= 0 || splitnum >= itemData.num)
			{
				return;
			}
			var itemService:ItemService = MainFacade.instance.inject.getInstance(ItemService) as ItemService;

			itemService.sendItemSplit(itemData.guId, itemData.slot, -1, splitnum);
		}

		private function onSplitPanelClose(event:Event):void
		{
			with (event.currentTarget)
			{
				removeEventListener(event.type, arguments.callee);
				removeEventListener("split", onSplitCommit);
			}
		}

		private function onDropOut(event:DragEvent):void
		{
			var sObj:IStoredObject = DragManager.dragingData as IStoredObject;
			if (sObj)
				sObj.discardObj();
		}

		/**
		 * 双击使用
		 * @param event
		 *
		 */
		private function onDoubleClick(event:Event):void
		{
			if (dragImage.fetchEnable && FetchHelper.instance.isFetching)
			{
				return;
			}
			var itemData:ItemData = data as ItemData;
			if (itemData)
			{
				if (!itemData.itemTemplate.can_be_use)
				{
					MessageManager.instance.addHintById_client(34, "该物品无法双击使用");
					return;
				}
			}
//			if (TWindowManager.instance.findPopup(ResetEquipmentPanel.NAME))
//			{
//				GameInstance.signal.resetEquipment.equipmentJudge.dispatch(itemData);
//				return;
//			}
			//NPC商店打开或仓库打开时，屏蔽双击
//			if (TWindowManager.instance.findPopup(NPCShopPanel.NAME) || TWindowManager.instance.findPopup(HeroDepotPanel.NAME))
//				return;
//			var salesroomPanel:SalesRoomUI = TWindowManager.instance.findPopup(SalesRoomUI.NAME) as SalesRoomUI;
//			if (salesroomPanel && salesroomPanel.tabController.selectedIndex == SalesRoomUI.MY_SALE_PANEL_INDEX)
//				return;
//			var mallPanel:MallPanel = TWindowManager.instance.findPopup(MallPanel.NAME) as MallPanel;
//			if (mallPanel && mallPanel.mallBeliefPanel.tabController.selectedIndex == MallConst.CATEGORY_SALE)
//				return;
			if (data)
			{
				if (data is IUseable)
				{
					(data as IUseable).useObj();
				}
			}
		}

		/**
		 * 物品放下操作
		 * @param event
		 *
		 */
		private function onItemDropDown(event:DragEvent):void
		{
			//格子被关闭
			if (_closed)
			{
				return;
			}
			var imageFrom:TDragableImage = event.dragFromImage as TDragableImage;
			var imageTarget:TDragableImage = event.dragImageTarget as TDragableImage;
			var indexTarget:int = bagView.getRenderIndex(imageTarget);
			switch (imageFrom.place)
			{
//				case DragImagePlaces.EQUIPMENT:
//					(imageFrom.data as EquipmentData).unEquip(ItemConst.CONTAINER_BACKPACK << 8 | indexTarget); //如果是装备，卸下
//					break;
				case DragImagePlaces.BAG: //移动
					if (!_inFilterState)
					{
						var indexFrom:int = ISlotData(DragManager.dragingData).slot & 0x000000FF;
						if (indexFrom == indexTarget)
							return;
						ItemOperateHelper.moveItem(ItemData(DragManager.dragingData), ItemConst.CONTAINER_BACKPACK << 8 | indexTarget);
					}
					else //筛选状态下禁用移动, 但可以合并
					{
						if (DragManager.dragingData == this.data)
						{
							return;
						}
						var itemDraging:ItemData = ItemData(DragManager.dragingData);
						var item:ItemData = ItemData(this.data);
						if (item.canCombine(itemDraging))
						{
							ItemOperateHelper.moveItem(itemDraging, item.slot);
						}
					}
					break;
				case DragImagePlaces.HERO_DEPOT: //仓库取出
					var itemTarget:ItemData = imageTarget.data as ItemData;
					if (itemTarget && !itemTarget.itemTemplate.is_can_store)
					{
						MessageManager.instance.addHintById_client(30, "该物品不能存储");
						return;
					}
					ItemOperateHelper.moveItem(ItemData(DragManager.dragingData), ItemConst.CONTAINER_BACKPACK << 8 | indexTarget);
					break;
				case DragImagePlaces.AWORD_DEPOT: //仓库取出
					ItemOperateHelper.moveItem(ItemData(DragManager.dragingData), ItemConst.CONTAINER_BACKPACK << 8 | indexTarget);
					break;
			}
		}

		/**
		 * 更新格子状态，（开启，未开启，筛选）
		 * @param value
		 *
		 */
		public function updateState(value:Boolean):void
		{
			_inFilterState = value;
			if (_inFilterState)
			{
				//筛选状态下
				closed = false;
				if (this.data && !this.visible)
				{
					this.visible = true;
				}
				else if (!this.data && this.visible)
				{
					this.visible = false;
				}
			}
			else
			{
				//普通状态下
				if (!this.visible)
				{
					this.visible = true;
				}
				var bagSize:int = BagItemManager.instance.getBagSize();
				closed = bagView.getRenderIndex(this) >= bagSize;
			}
		}
		/**
		 * 格子开启状态效果
		 * @param value
		 *
		 */
		private var mc_lock1:DisplayObject = RslManager.getInstance(UISkinLib.bagLock);

		/**
		 * 格子开启状态（true为未开启）
		 * @param value
		 *
		 */
		private function set closed(value:Boolean):void
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

		override protected function onClick(event:MouseEvent):void
		{
			var itemData:ItemData = data as ItemData;
			if (itemData)
			{
//				if (TWindowManager.instance.findPopup(MailTabPanel.NAME) && GameInstance.ui.mailTabPanel.tabController.selectedIndex == 1)
//				{
//					if (!itemData.playerBinded)
//					{
//						var beliefConfig:BeliefSaleItemConfig = SalesroomConfigManager.getBeliefSaleItemConfig(itemData.templateId);
//						if (beliefConfig != null)
//						{
//							MessageManager.instance.addHintById_client(2307, "信仰罐无法邮寄");
//							return;
//						}
//						GameInstance.model.mail.addItemList2(itemData);
//						GameInstance.signal.mail.setMailTitle.dispatch(itemData); //设置邮件标题
//					}
//					else
//						MessageManager.instance.addHintById_client(44, "绑定物品无法放入");
//					return;
//				}
			}
			if (!checkClick())
			{
				return;
			}
			//处理背包格子点击的额外逻辑
			if (processClick(event))
			{
				return;
			}
			//显示菜单
			showMenu();
//			super.onClick(event);
		}

		/**
		 * 处理背包格子点击的额外逻辑
		 * @param event
		 * @return
		 *
		 */
		protected function processClick(event:MouseEvent):Boolean
		{
			if (_closed)
			{
				//尝试获取开启背包物品
				var expendItemdata:ExpendItemData = BagItemManager.instance.getFirstItemByType(ItemConst.TYPE_ITEM_DRUG, ItemConst.SUB_TYPE_DRUG_EXPEND_BAG) as ExpendItemData;
				if (expendItemdata)
				{
					expendItemdata.useObj();
				}
				else
				{
					TWindowManager.instance.showPopup2(null, ExpendDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, ItemConst.SUB_TYPE_DRUG_EXPEND_BAG, null)
				}
				return true;
			}
			if (!data)
			{
				return true;
			}
//			if (event.ctrlKey)
//			{
//				var npcShopPanel:NPCShopPanel = TWindowManager.instance.findPopup(NPCShopPanel.NAME) as NPCShopPanel;
//				if (npcShopPanel)
//				{
//					npcShopPanel.shop.sell(this.data as ItemData);
//					return true;
//				}
//			}
//			GameInstance.signal.item.bagItemClick.dispatch(this.data as ItemData);
//			var salesroomPanel:SalesRoomUI = TWindowManager.instance.findPopup(SalesRoomUI.NAME) as SalesRoomUI;
//			if (salesroomPanel && salesroomPanel.tabController.selectedIndex == SalesRoomUI.MY_SALE_PANEL_INDEX)
//			{
//				GameInstance.signal.salesroomView.putSale.dispatch(this.data as ItemData); //放置拍卖品
//				return true;
//			}
//			if (GameInstance.signal.item.bagItemClick.numListeners > 0)
//			{
//				return true;
//			}
			return false;
		}

		override public function set data(value:Object):void
		{
//			var oldEquip:EquipmentData = this.data as EquipmentData;
//			if (oldEquip)
//			{
//				oldEquip.identifySuccessSignal.remove(lightingEffect)
//			}
			super.data = value;
			//筛选状态下，数据变更时检查显示隐藏
			if (_inFilterState)
			{
				if (this.data && !this.visible)
				{
					this.visible = true;
				}
				else if (!this.data && this.visible)
				{
					this.visible = false;
				}
			}
			//监听鉴定成功事件，添加光效
//			var equip:EquipmentData = this.data as EquipmentData;
//			if (equip)
//			{
//				if (!equip.identify)
//					equip.identifySuccessSignal.add(lightingEffect);
//			}
		}

		private function lightingEffect():void
		{
			this.addEventListener(Event.ENTER_FRAME, delayAddEffect);
		}
		private var _count:int = 0;

		private function delayAddEffect(e:Event):void
		{
//			_count++;
//			if (_count == 10)
//			{
//				_count = 0;
//				this.removeEventListener(Event.ENTER_FRAME, delayAddEffect);
//				var _identifySuccEffect:MovieClip = TRslManager.getInstance(ResLib.UI_EFFECT_SCENE_JIANDING_BUTTON);
//				_identifySuccEffect.blendMode = BlendMode.ADD;
//				var pos:Point = new Point((this.width - _identifySuccEffect.width) / 2, (this.height - _identifySuccEffect.height) / 2);
//				pos = bagView.globalToLocal(this.localToGlobal(pos));
//				_identifySuccEffect.x = pos.x;
//				_identifySuccEffect.y = pos.y;
////				bagView.addChild(_identifySuccEffect);
//				SpecialEffectManager.addEffetToProxy(bagView, _identifySuccEffect, 1);
//			}
		}
	}
}
