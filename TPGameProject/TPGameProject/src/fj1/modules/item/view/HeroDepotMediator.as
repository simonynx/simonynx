package fj1.modules.item.view
{
	import assets.CursorLib;

	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.HeroDepot;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.events.item.SlotItemManagerEvent;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.service.ItemService;
	import fj1.modules.item.view.components.DepotDataBox;
	import fj1.modules.item.view.components.HeroDepotPanel;
	import fj1.modules.item.view.components.level2.DepotMoneyEditDialog;
	import fj1.modules.item.view.components.level2.DepotSetPwdDialog;
	import fj1.modules.scene.signals.SceneSignals;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	import tempest.common.mvc.base.Mediator;
	import tempest.common.time.vo.TimerData;
	import tempest.engine.SceneCharacter;
	import tempest.engine.vo.map.MapTile;
	import tempest.manager.TimerManager;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.collections.TSlotDictionary;
	import tempest.ui.components.IList;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.components.TTabController;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.events.SlotDictionaryEvent;
	import tempest.ui.events.TWindowEvent;
	import tempest.ui.helper.TextFieldHelper;
	import tempest.utils.Geom;
	import tempest.utils.ListenerManager;

	public class HeroDepotMediator extends Mediator
	{
		[Inject]
		public var itemService:ItemService;

		[Inject]
		public var sceneSignals:SceneSignals;

		private var _depotDataList:IList;
		private var _depotDataListPageHelper:TPagedListCollection;
		private var _changeWatcherManager:ChangeWatcherManager;
		private var _listenerMananger:ListenerManager;
		private var _npc:SceneCharacter;
		private var _tabController:TTabController;

		private var _tidyupCDTimer:TimerData;

		public function HeroDepotMediator()
		{
			_changeWatcherManager = new ChangeWatcherManager();
			_listenerMananger = new ListenerManager();
			super();
		}

		private function get heroDepotPanel():HeroDepotPanel
		{
			return this.viewComponet;
		}

		public override function onRegister():void
		{
			if (!_depotDataListPageHelper)
			{
				_depotDataList = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT);
				_depotDataListPageHelper = new TPagedListCollection(_depotDataList, ItemConst.DEPOT_PAGE_SIZE, false);
			}
			//选项卡默认选中第一页
			_tabController = heroDepotPanel.tabController;
			_tabController.addEventListener(Event.CHANGE, onTabChange);
			_tabController.selectedIndex = 0;
			heroDepotPanel.btn_tidyup.addEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel.btn_saveMoney.addEventListener(MouseEvent.CLICK, onBtClick);
			if (HeroDepot.instance.hasPwd)
			{
//				heroDepotPanel._btn_pwd.text = LanguageManager.translate(2040, "修改密码");
			}
			else
			{
//				heroDepotPanel._btn_pwd.text = LanguageManager.translate(29013, "设置密码");
			}
//			heroDepotPanel._btn_pwd.addEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel._btn_getMoney.addEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel._btn_item.addEventListener(MouseEvent.CLICK, onBtClick);
			//提取操作监听
			heroDepotPanel.fetchEnable = true;
			heroDepotPanel.addEventListener(FetchEvent.FETCH, onFetch);
			for (var pageindex:int = 0; pageindex < ItemConst.BAG_ITEM_NUM / ItemConst.BAG_PAGE_SIZE; ++pageindex)
			{
				//在列表上加上拖放掉落监听
				var bagTab:TComponent = heroDepotPanel.bagLists[pageindex] as TComponent;
				bagTab.fetchEnable = true;
				bagTab.addEventListener(FetchEvent.FETCH, onTabFetch);
				//选项卡头加上ROLL_OVER监听
				var tabHead:TRadioButton = _tabController.getTabHead(pageindex);
				tabHead.data = pageindex;
				tabHead.addEventListener(MouseEvent.ROLL_OVER, onTabMouseOver);
			}
//			_changeWatcherManager.bindProperty(heroDepotPanel.lbl_money, "text", HeroDepot.instance, "money");
			_changeWatcherManager.bindSetter(getMoney, HeroDepot.instance, "money");
//			_changeWatcherManager.bindProperty(heroDepotPanel.lbl_emoney, "text", HeroDepot.instance, "magicCristal");
//			_changeWatcherManager.bindSetter(getMagicCrystal, HeroDepot.instance, "magicCristal");
			//监听背包扩容
			SlotItemManager.instance.addEventListener(SlotItemManagerEvent.RESIZE_LIST, onResizeList);
			var slotDic:TSlotDictionary = SlotItemManager.instance.getSlotDic();
			_listenerMananger.addEventListener(slotDic, SlotDictionaryEvent.ADD, onSlotItemAdd);
			_listenerMananger.addEventListener(slotDic, SlotDictionaryEvent.REMOVE, onSlotItemRemove);
			_listenerMananger.addEventListener(slotDic, SlotDictionaryEvent.SLOT_CHANGE, onDicSlotChange);

			//监听距离变动
			_npc = SceneCharacter(heroDepotPanel.data);
			addSignal(sceneSignals.mainCharMove, heroDepotPanel.onLeftTalk);
			updateDataProvider(); //更新数据源
			updateBoxes(); //刷新格子
			setDepotSizeText(SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length);
			//监听仓库整理状态
			addSignal(SlotItemManager.instance.getCDStartSignal(ItemConst.CONTAINER_DEPOT), onTidyupCDStart);
			var lastCD:int = SlotItemManager.instance.getlastCDTime(ItemConst.CONTAINER_DEPOT, getTimer());
			if (lastCD > 0)
			{
				showTidyupCD(lastCD);
			}
		}

		public override function onRemove():void
		{
			_tabController.removeEventListener(Event.CHANGE, onTabChange);
			heroDepotPanel.btn_tidyup.removeEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel.btn_saveMoney.removeEventListener(MouseEvent.CLICK, onBtClick);
			//			heroDepotPanel._btn_pwd.removeEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel._btn_getMoney.removeEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel._btn_item.removeEventListener(MouseEvent.CLICK, onBtClick);
			heroDepotPanel.removeEventListener(FetchEvent.FETCH, onFetch);
			for (var pageindex:int = 0; pageindex < ItemConst.BAG_ITEM_NUM / ItemConst.BAG_PAGE_SIZE; ++pageindex)
			{
				var bagTab:TComponent = heroDepotPanel.bagLists[pageindex] as TComponent;
				bagTab.removeEventListener(FetchEvent.FETCH, onTabFetch);
				var tabHead:TRadioButton = _tabController.getTabHead(pageindex);
				tabHead.removeEventListener(MouseEvent.ROLL_OVER, onTabMouseOver);
			}
			_changeWatcherManager.unWatchAll();
			if (_tabController.selectedIndex >= 0)
			{
				//清空仓库列表和数据源的绑定
				(heroDepotPanel.bagLists[_tabController.selectedIndex] as TFixedList).dataProvider = null;
				_tabController.selectedIndex = -1;
			}
			SlotItemManager.instance.removeEventListener(SlotItemManagerEvent.RESIZE_LIST, onResizeList);
			if (_tidyupCDTimer)
			{
				resetTidyupBtn();
				_tidyupCDTimer.stop();
				_tidyupCDTimer = null;
			}
		}

		//金钱
		public function getMoney(value:int):void
		{
			heroDepotPanel.lbl_money.text = TextFieldHelper.getMoneyFormat(String(value));
		}

		//魔晶
//		public function getMagicCrystal(value:int):void
//		{
//			heroDepotPanel.lbl_emoney.text = NumberTextField.getMoneyFormat(String(value));
//		}
		/**
		 * 刷新格子
		 *
		 */
		private function updateBoxes():void
		{
			if (_tabController.selectedIndex < 0)
			{
				return;
			}
			var curList:TFixedList = heroDepotPanel.bagLists[_tabController.selectedIndex];
			var size:int = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length;
			for (var i:int = 0; i < _depotDataListPageHelper.pageSize; ++i)
			{
				var bagRender:BaseDataListItemRender = BaseDataListItemRender(curList.getItemRender(i));
				DepotDataBox(bagRender.dataBox).closed = heroDepotPanel.getRenderIndex(bagRender) >= size;
			}
		}

		/**
		 * 更新数据源
		 * @param currentCate
		 *
		 */
		private function updateDataProvider():void
		{
			for (var i:String in heroDepotPanel.bagLists)
			{
				if (i != _tabController.selectedIndex.toString())
				{
					//不是当前页的列表，数据源置空
					(heroDepotPanel.bagLists[i] as TFixedList).dataProvider = null;
				}
			}
			_depotDataListPageHelper.currentPage = _tabController.selectedIndex;
			//绑定当前页
			if (_tabController.selectedIndex >= 0)
			{
				(heroDepotPanel.bagLists[_tabController.selectedIndex] as TFixedList).dataProvider = _depotDataListPageHelper.pagedCollection;
			}
		}


		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		private function onFetch(event:FetchEvent):void
		{
			switch (event.fetchType)
			{
				case FetchType.DEPOT:
					FetchHelper.instance.keepFetching();
					break;
			}
		}

		private function onTabChange(event:Event):void
		{
			if (_depotDataList)
			{
				updateDataProvider(); //更新数据源
				updateBoxes(); //刷新格子				
			}
		}

		private function onBtClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case heroDepotPanel.btn_tidyup:
					SlotItemManager.instance.tidyUp(ItemConst.CONTAINER_DEPOT);
					break;
				case heroDepotPanel.btn_saveMoney: //存钱
					TWindowManager.instance.showPopup(heroDepotPanel, new DepotMoneyEditDialog(DepotMoneyEditDialog.TYPE_SAVE_MONEY), true, true).addEventListener(DataEvent.DATA, onMoneySubmit);
					break;
//				case heroDepotPanel._btn_pwd: //修改密码
//					if (HeroDepot.instance.hasPwd)
//					{
//						TWindowManager.instance.showPopup(heroDepotPanel, new DepotModifyPwdDialog(DepotModifyPwdDialog.RePassWord), true, true).addEventListener(DataEvent.DATA, onModifyPwdSubmit);
//					}
//					else
//					{
//						TWindowManager.instance.showPopup(heroDepotPanel, new DepotSetPwdDialog(), true, true).addEventListener(DataEvent.DATA, onSetPwdSubmit);
//					}
//					break;
				case heroDepotPanel._btn_getMoney: //取钱
					TWindowManager.instance.showPopup(heroDepotPanel, new DepotMoneyEditDialog(DepotMoneyEditDialog.TYPE_GET_MONEY), true, true).addEventListener(DataEvent.DATA, onMoneySubmit);
					break;
				case heroDepotPanel._btn_item:
					FetchHelper.instance.begingFetch(FetchType.DEPOT, CursorLib.DEPOT);
					break;
			}
		}

		private function onTabFetch(event:FetchEvent):void
		{
			FetchHelper.instance.keepFetching();
		}

		private function onTabMouseOver(event:MouseEvent):void
		{
			if (DragManager.isDraging())
			{
				//有图片被拾起，换页
				_tabController.selectedIndex = int((event.currentTarget as TRadioButton).data);
				onTabChange(null);
			}
		}

		private function onResizeList(event:SlotItemManagerEvent):void
		{
			var size:int = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length;
			setDepotSizeText(size);
			updateBoxes(); //刷新格子
		}

		/**
		 * 物品变更事件
		 * @param event
		 *
		 */
		private function onSlotItemAdd(event:SlotDictionaryEvent):void
		{
			var item:ItemData = ItemData(event.data);
			if (item.slot < 0)
				return;
			if (SlotItemManager.getSlotType(item.slot) == ItemConst.CONTAINER_DEPOT)
			{
				var size:int = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length;
				setDepotSizeText(size);
			}
		}

		/**
		 * 物品变更事件
		 * @param event
		 *
		 */
		private function onSlotItemRemove(event:SlotDictionaryEvent):void
		{
			var item:ItemData = ItemData(event.data);
			if (item.slot < 0)
				return;
			if (SlotItemManager.getSlotType(item.slot) == ItemConst.CONTAINER_DEPOT)
			{
				var size:int = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length;
				setDepotSizeText(size);
			}
		}

		/**
		 * 物品变更事件
		 * @param event
		 *
		 */
		private function onDicSlotChange(event:SlotDictionaryEvent):void
		{
			var item:ItemData = ItemData(event.data[0]);
			var oldSlot:int = int(event.data[1]);
			var newSlot:int = int(event.data[2]);
			var remove:Boolean = false;
			var add:Boolean = false;
			if (oldSlot >= 0 && SlotItemManager.getSlotType(oldSlot) == ItemConst.CONTAINER_DEPOT)
			{
				remove = true;
			}
			if (newSlot >= 0 && SlotItemManager.getSlotType(newSlot) == ItemConst.CONTAINER_DEPOT)
			{
				add = true;
			}
			if (remove || add && !(remove && add))
			{
				var size:int = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length;
				setDepotSizeText(size);
			}
		}

		private function setDepotSizeText(value:int):void
		{
			heroDepotPanel.lbl_depotSize.text = LanguageManager.translate(50516, "剩余空间{0}/{1}", SlotItemManager.instance.getEmptyCellNum(ItemConst.CONTAINER_DEPOT), value);
		}

		private function onModifyPwdSubmit(event:DataEvent):void
		{
			itemService.sendDepotPwdModify(String(event.data[0]), String(event.data[1]));
		}

		private function onSetPwdSubmit(event:DataEvent):void
		{
			itemService.sendDepotPwdModify("", String(event.data));
		}

		private function onMoneySubmit(event:DataEvent):void
		{
			var dialog:DepotMoneyEditDialog = DepotMoneyEditDialog(event.currentTarget);
			switch (dialog.type)
			{
				case DepotMoneyEditDialog.TYPE_GET_MONEY:
					itemService.sendDepotMoneyGet(int(event.data[0]), int(event.data[1]));
					break;
				case DepotMoneyEditDialog.TYPE_SAVE_MONEY:
					itemService.sendDepotMoneySave(int(event.data[0]), int(event.data[1]));
					break;
			}
		}

		/**
		 * 整理CD中触发
		 * @param event
		 *
		 */
		private function onTidyupCD():void
		{
			if (heroDepotPanel.btn_tidyup.enabled)
			{
				heroDepotPanel.btn_tidyup.enabled = false;
			}
			heroDepotPanel.btn_tidyup.text = LanguageManager.translate(29012, "整理") + "(" + (_tidyupCDTimer.timer.repeatCount - _tidyupCDTimer.timer.currentCount) + ")";
		}

		/**
		 * 整理CD结束触发
		 * @param event
		 *
		 */
		private function onTidyupCDComplete():void
		{
			_tidyupCDTimer = null;
			resetTidyupBtn();
		}

		/**
		 * 整理CD开始触发
		 *
		 */
		private function onTidyupCDStart():void
		{
			var lastCD:int = SlotItemManager.instance.getlastCDTime(ItemConst.CONTAINER_DEPOT, getTimer());
			if (lastCD > 0)
			{
				showTidyupCD(lastCD);
			}
		}

		private function showTidyupCD(lastCD:int):void
		{
			if (int(lastCD / 1000) <= 0)
			{
				return;
			}
			if (heroDepotPanel.btn_tidyup.enabled)
			{
				heroDepotPanel.btn_tidyup.enabled = false;
			}
			_tidyupCDTimer = TimerManager.createNormalTimer(1000, lastCD / 1000, onTidyupCD, null, onTidyupCDComplete, null);
			heroDepotPanel.btn_tidyup.text = LanguageManager.translate(29012, "整理") + "(" + int(lastCD / 1000) + ")";
		}

		private function resetTidyupBtn():void
		{
			heroDepotPanel.btn_tidyup.enabled = true;
			heroDepotPanel.btn_tidyup.text = LanguageManager.translate(29012, "整理");
		}

	}
}
