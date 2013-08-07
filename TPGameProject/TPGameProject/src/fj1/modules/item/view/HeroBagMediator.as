package fj1.modules.item.view
{
	import assets.CursorLib;

	import com.gskinner.motion.GTweener;

	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.HeroDepot;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.MoneyType;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.BagItemManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.events.ItemEvent;
	import fj1.modules.item.signals.ItemSignal;
	import fj1.modules.item.view.components.BagDataBox;
	import fj1.modules.item.view.components.HeroBagPanel;
	import fj1.modules.item.view.components.HeroDepotPanel;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import tempest.common.mvc.base.Mediator;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.UIStyle;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.components.IList;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.components.TTabController;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.helper.TextFieldHelper;
	import tempest.utils.ListenerManager;

	public class HeroBagMediator extends Mediator
	{
		[Inject]
		public var itemSignals:ItemSignal;

		private var _bagDataList:IList;
		private var _changeWatcherManager:ChangeWatcherManager;
		private var _listenerMananger:ListenerManager;
		private var _bagItemManager:BagItemManager;
		private var _tabController:TTabController;
		private var _tidyupCDTimer:TimerData;

		public function HeroBagMediator()
		{
			super();
			_changeWatcherManager = new ChangeWatcherManager();
			_listenerMananger = new ListenerManager();
			_bagDataList = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_BACKPACK);
			_bagItemManager = BagItemManager.instance;
		}

		private function onFetch(event:FetchEvent):void
		{
			FetchHelper.instance.keepFetching();
		}

		private function get heroBagPanel():HeroBagPanel
		{
			return this.viewComponet;
		}

		public override function onRegister():void
		{
			/*窗口打开效果测试*/
//			if (TWindowManager.instance.findPopup(HeroDetailPanel.NAME))
//			{
//				var tWin:TWindow = TWindowManager.instance.findPopup(HeroDetailPanel.NAME) as TWindow;
//				WindowTweenManager.LeftAndRight(tWin, heroBagPanel);
//			}
//			GameInstance.signal.sound.addGameSound.dispatch(19);
			if (!heroBagPanel.bagDataListPageHelper)
			{
				heroBagPanel.bagDataListPageHelper = new TPagedListCollection(_bagDataList, ItemConst.BAG_PAGE_SIZE, false);
			}
			//选项卡默认选中第一页
			_tabController = heroBagPanel.tabController;
			_tabController.addEventListener(Event.CHANGE, onTabChange);
			_tabController.selectedIndex = 0;
			heroBagPanel.tbtn_tidyup.addEventListener(MouseEvent.CLICK, onTidyUpClick);
//			heroBagPanel.tbtn_openShop.addEventListener(MouseEvent.CLICK, onOpenShopClick);
//			heroBagPanel.btn_far_shop.addEventListener(MouseEvent.CLICK, onFarShopClick);
//			heroBagPanel.btn_far_storage.addEventListener(MouseEvent.CLICK, onFarStorageClick);
			_changeWatcherManager.bindSetter(setBtnState, GameInstance.mainCharData, "vip");
			for (var pageindex:int = 0; pageindex < ItemConst.BAG_ITEM_NUM / ItemConst.BAG_PAGE_SIZE; ++pageindex)
			{
				//在列表上加上拖放掉落监听
				var bagTab:TComponent = heroBagPanel._bagLists[pageindex] as TComponent;
				bagTab.dragAccpetPlaces = [DragImagePlaces.NPC_SHOP, DragImagePlaces.BAG];
				bagTab.addEventListener(DragEvent.DROP_DOWN, onTabDropDown);
				bagTab.fetchEnable = true;
				bagTab.addEventListener(FetchEvent.FETCH, onTabFetch);
				//选项卡头加上ROLL_OVER监听
				var tabHead:TRadioButton = _tabController.getTabHead(pageindex);
				tabHead.data = pageindex;
				tabHead.addEventListener(MouseEvent.ROLL_OVER, onTabMouseOver);
			}
			_changeWatcherManager.bindSetter(bindSetMagicCrystal, GameInstance.mainCharData, "magicCrystal");
//			_changeWatcherManager.bindSetter(getMagicStone, GameInstance.mainCharData, "magicStone");
			_changeWatcherManager.bindSetter(bindSetMoney, GameInstance.mainCharData, "money");
			_changeWatcherManager.bindProperty(heroBagPanel.tlbl_intergrate, "text", GameInstance.mainCharData, "integrate");
			//监听背包扩容
			_bagItemManager.addEventListener(ItemEvent.RESIZE_BAG, onResizeBag);
			//提取操作监听
			heroBagPanel.fetchEnable = true;
			heroBagPanel.addEventListener(FetchEvent.FETCH, onFetch);
			heroBagPanel.tlbl_money.fetchEnable = true;
//			heroBagPanel.tlbl_money.addEventListener(FetchEvent.FETCH, onFetchMoney);
			heroBagPanel.tlbl_magicCrystal.fetchEnable = true;
//			heroBagPanel.tlbl_magicCrystal.addEventListener(FetchEvent.FETCH, onFetchMagicCrystal);
//			heroBagPanel.tlbl_magicStone.fetchEnable = true;
//			heroBagPanel.tlbl_magicStone.addEventListener(FetchEvent.FETCH, onFetchMagicStone);
			heroBagPanel.tlbl_intergrate.fetchEnable = true;
			heroBagPanel.tlbl_intergrate.addEventListener(FetchEvent.FETCH, onFetchIntergrate);
			//切换分类操作监听
			heroBagPanel.rbt_cate0.select();
			heroBagPanel.rbt_cate0.addEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate1.addEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate2.addEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate3.addEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate4.addEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate5.addEventListener(Event.CHANGE, onCateChange);
			//刷新格子状态
			var currentCate:int = int(heroBagPanel.group.selectedButton.data);
			updateDataProvider(currentCate); //更新数据源
			updateTabHeads(currentCate); //刷新选项卡
			updateBoxes(currentCate); //刷新格子
			//监听商品面板
//			var len:int = heroBagPanel.saleList.itemRenders.length;
//			for (var i:int = 0; i < len; ++i)
//			{
//				addSignal(SingleSaleItemRender(heroBagPanel.saleList.getItemRender(i)).clickSignal, onSaleItemClick);
//			}
//			_listenerMananger.addEventListener(MallModel.instance, DataEvent.DATA, onCategoryChange);
//			_listenerMananger.addEventListener(BagItemManager.instance, ItemEvent.ADD, onItemAdd);
//			_listenerMananger.addEventListener(BagItemManager.instance, ItemEvent.REMOVE, onItemRemove);
//			addSignal(GameInstance.signal.mall.updateCategory, onCategoryUpdate);
//			//查询热销商品
//			GameInstance.signal.mall.queryCategory.dispatch(MallConst.CATEGORY_HOT);
			//监听背包整理状态
			addSignal(SlotItemManager.instance.getCDStartSignal(ItemConst.CONTAINER_BACKPACK), onTidyupCDStart);
			var lastCD:int = SlotItemManager.instance.getlastCDTime(ItemConst.CONTAINER_BACKPACK, getTimer());
			if (lastCD > 0)
			{
				showTidyupCD(lastCD);
			}
			setBagSizeText(GameInstance.mainCharData.bagSize);
			//
			addSignal(itemSignals.changeBagTabTo, onChangeBagTabTo);
		}

		public override function onRemove():void
		{
//			GameInstance.signal.sound.addGameSound.dispatch(19);
			_tabController.removeEventListener(Event.CHANGE, onTabChange);
			heroBagPanel.tbtn_tidyup.removeEventListener(MouseEvent.CLICK, onTidyUpClick);
//			heroBagPanel.tbtn_openShop.removeEventListener(MouseEvent.CLICK, onOpenShopClick);
//			heroBagPanel.btn_far_shop.removeEventListener(MouseEvent.CLICK, onFarShopClick);
//			heroBagPanel.btn_far_storage.removeEventListener(MouseEvent.CLICK, onFarStorageClick);
			for (var pageindex:int = 0; pageindex < ItemConst.BAG_ITEM_NUM / ItemConst.BAG_PAGE_SIZE; ++pageindex)
			{
				var bagTab:TComponent = heroBagPanel._bagLists[pageindex] as TComponent;
				bagTab.removeEventListener(FetchEvent.FETCH, onTabFetch);
				var tabHead:TRadioButton = _tabController.getTabHead(pageindex);
				tabHead.removeEventListener(MouseEvent.ROLL_OVER, onTabMouseOver);
			}
			_bagItemManager.removeEventListener(ItemEvent.RESIZE_BAG, onResizeBag);
			_changeWatcherManager.unWatchAll();
			if (_tabController.selectedIndex >= 0)
			{
				//清空背包列表和数据源的绑定
				(heroBagPanel._bagLists[_tabController.selectedIndex] as TFixedList).dataProvider = null;
				_tabController.selectedIndex = -1;
			}
			heroBagPanel.removeEventListener(FetchEvent.FETCH, onFetch);
//			heroBagPanel.tlbl_money.removeEventListener(FetchEvent.FETCH, onFetchMoney);
//			heroBagPanel.tlbl_magicCrystal.removeEventListener(FetchEvent.FETCH, onFetchMagicCrystal);
//			heroBagPanel.tlbl_magicStone.removeEventListener(FetchEvent.FETCH, onFetchMagicStone);
//			heroBagPanel.tlbl_intergrate.removeEventListener(FetchEvent.FETCH, onFetchIntergrate);
			heroBagPanel.rbt_cate0.removeEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate1.removeEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate2.removeEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate3.removeEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate4.removeEventListener(Event.CHANGE, onCateChange);
			heroBagPanel.rbt_cate5.removeEventListener(Event.CHANGE, onCateChange);
			if (BagItemManager.instance.filtedItemList)
			{
				BagItemManager.instance.filtedItemList.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onFiltedListChange);
			}
			_bagItemManager.cleanFilter(); //释放筛选列表
			_listenerMananger
			//整理CD处理
			if (_tidyupCDTimer)
			{
				resetTidyupBtn();
				_tidyupCDTimer.stop();
				_tidyupCDTimer = null;
			}
		}
		static public const FAR_STORAGE:int = 7; //远程仓库
		static public const FAR_SHOP:int = 8; //远程商店

//		//远程仓库
//		private function onFarStorageClick(event:MouseEvent):void
//		{
//			if (!GameInstance.mainCharData.isVIP)
//				return;
//			if (!VipUtil.checkVIPPriority(VIPConst.ID_VIP_REMOTE_DEPOT))
//			{
//				MessageManager.instance.addHintById_client(3204, "您當日的遠程倉庫次數已經用完");
//				return;
//			}
//			if (TWindowManager.instance.findPopup(HeroDepotPanel.NAME))
//				TWindowManager.instance.removePopupByName(HeroDepotPanel.NAME);
//			else
//				GameClient.sendRemoteOperation(FAR_STORAGE);
//		}

//		//远程商店
//		private function onFarShopClick(event:MouseEvent):void
//		{
//			if (!GameInstance.mainCharData.isVIP)
//				return;
//			if (!VipUtil.checkVIPPriority(VIPConst.ID_VIP_REMOTE_SHOP))
//			{
//				MessageManager.instance.addHintById_client(3203, "您當日的遠程商店次數已經用完");
//				return;
//			}
//			if (TWindowManager.instance.findPopup(NPCShopPanel.NAME))
//				TWindowManager.instance.removePopupByName(NPCShopPanel.NAME);
//			else
//				GameClient.sendRemoteOperation(FAR_SHOP);
//		}

		private function setBtnState(value:int):void
		{
			if (value > 0)
			{
				heroBagPanel.btn_far_storage.filters = null;
				heroBagPanel.btn_far_shop.filters = null;
			}
			else
			{
				heroBagPanel.btn_far_storage.filters = [UIStyle.disableFilter];
				heroBagPanel.btn_far_shop.filters = [UIStyle.disableFilter];
				heroBagPanel.btn_far_storage.toolTipString = LanguageManager.translate(9306, "VIP独享");
				heroBagPanel.btn_far_shop.toolTipString = LanguageManager.translate(9306, "VIP独享");
			}
		}

		private function onItemAdd(event:ItemEvent):void
		{
			setBagSizeText(BagItemManager.instance.getBagSize());
		}

		private function onItemRemove(event:ItemEvent):void
		{
			setBagSizeText(BagItemManager.instance.getBagSize());
		}

		private function setBagSizeText(value:int):void
		{
			heroBagPanel.lbl_bagSize.text = LanguageManager.translate(50516, "剩余空间{0}/{1}", BagItemManager.instance.getEmptyCellNum(), value);
		}

		//金钱
		public function bindSetMoney(value:int):void
		{
			heroBagPanel.tlbl_money.text = TextFieldHelper.getMoneyFormat(String(value));
		}

		//魔晶
		public function bindSetMagicCrystal(value:int):void
		{
			heroBagPanel.tlbl_magicCrystal.text = TextFieldHelper.getMoneyFormat(String(value));
		}

//		//魔石
//		public function getMagicStone(value:int):void
//		{
//			heroBagPanel.tlbl_magicStone.text = TextFieldHelper.getMoneyFormat(String(value));
//		}
		/**
		 * 根据分类刷新选项卡和格子
		 * @param cate
		 *
		 */
		private function updateTabHeads(cate:int):void
		{
			var max:int = ItemConst.BAG_ITEM_NUM / ItemConst.BAG_PAGE_SIZE - 1;
			if (cate == ItemConst.FILTER_TYPE_NONE)
			{
				for (var i:int = 0; i <= max; i++)
				{
					_tabController.setTabUseable(i, true);
				}
			}
			else
			{
				var bagSize:int = BagItemManager.instance.filtedItemList.length;
				var count:int = (bagSize > 0 ? bagSize - 1 : 0) / ItemConst.BAG_PAGE_SIZE;
				for (var j:int = 0; j <= max; j++)
				{
					_tabController.setTabUseable(j, j <= count);
				}
			}
		}

		/**
		 * 根据状态刷新格子
		 *
		 */
		private function updateBoxes(cate:int):void
		{
			if (_tabController.selectedIndex < 0)
			{
				return;
			}
			var curList:TFixedList = heroBagPanel._bagLists[_tabController.selectedIndex];
			var pageSize:int = BagItemManager.instance.getBagSize();
			for (var i:int = 0; i < heroBagPanel.bagDataListPageHelper.pageSize; ++i)
			{
				var bagRender:BaseDataListItemRender = BaseDataListItemRender(curList.getItemRender(i));
				BagDataBox(bagRender.dataBox).updateState(cate != ItemConst.FILTER_TYPE_NONE);
			}
		}

		/**
		 * 更新数据源
		 * @param currentCate
		 *
		 */
		private function updateDataProvider(currentCate:int):void
		{
			if (BagItemManager.instance.filtedItemList)
			{
				BagItemManager.instance.filtedItemList.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onFiltedListChange);
			}
			BagItemManager.instance.processFilter(currentCate);
			if (BagItemManager.instance.filtedItemList)
			{
				heroBagPanel.bagDataListPageHelper.host = BagItemManager.instance.filtedItemList;
				//监听筛选列表刷新，以动态变更选项卡头
				BagItemManager.instance.filtedItemList.addEventListener(CollectionEvent.COLLECTION_CHANGE, onFiltedListChange);
			}
			else
			{
				heroBagPanel.bagDataListPageHelper.host = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_BACKPACK);
			}
			for (var i:String in heroBagPanel._bagLists)
			{
				if (i != _tabController.selectedIndex.toString())
				{
					//不是当前页的列表，数据源置空
					(heroBagPanel._bagLists[i] as TFixedList).dataProvider = null;
				}
			}
			heroBagPanel.bagDataListPageHelper.currentPage = _tabController.selectedIndex;
			//绑定当前页
			if (_tabController.selectedIndex >= 0)
			{
				(heroBagPanel._bagLists[_tabController.selectedIndex] as TFixedList).dataProvider = heroBagPanel.bagDataListPageHelper.pagedCollection;
			}
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		/**
		 * 监听筛选列表刷新，以动态变更选项卡头
		 * @param event
		 *
		 */
		private function onFiltedListChange(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
				case CollectionEventKind.REMOVE:
					var currentCate:int = int(heroBagPanel.group.selectedButton.data);
					updateTabHeads(currentCate);
					if (_tabController.selectedIndex >= 0 && !_tabController.getTabHead(_tabController.selectedIndex).visible)
					{
						//当前选中的选项卡页被隐藏，选中最后一页可用的选项卡
						_tabController.selectedIndex = _tabController.getUseableTabs().length - 1;
						updateDataProvider(currentCate);
					}
					break;
			}
		}

		private function onTabDropDown(event:DragEvent):void
		{
			var imageFrom:TDragableImage = event.dragFromImage as TDragableImage;
			var imageTarget:TDragableImage = event.dragImageTarget as TDragableImage;
//			switch (imageFrom.place)
//			{
//				case DragImagePlaces.NPC_SHOP: //商城购买
//					var shopItemData:NPCShopItemData = NPCShopItemData(DragManager.fromParams);
//					shopItemData.buy(-1);
//					break;
//			}
		}

		private function onTidyUpClick(event:MouseEvent):void
		{
			SlotItemManager.instance.tidyUp(ItemConst.CONTAINER_BACKPACK); //调用整理
		}

//		private function onOpenShopClick(event:MouseEvent):void
//		{
//			TWindowManager.instance.showPopup2(null, MallPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
//		}

		private function onTabChange(event:Event):void
		{
			if (_bagDataList)
			{
				var currentCate:int = int(heroBagPanel.group.selectedButton.data);
				//根据分类筛选
				updateDataProvider(currentCate); //更新数据源
				updateTabHeads(currentCate); //刷新选项卡
				updateBoxes(currentCate); //刷新格子
			}
		}

		/**
		 *  切换分类处理
		 * @param event
		 *
		 */
		private function onCateChange(event:Event):void
		{
			var rbt:TRadioButton = event.currentTarget as TRadioButton;
			if (!rbt.selected)
			{
				return;
			}
			heroBagPanel.bagDataListPageHelper.currentPage = 0;
			_tabController.selectedIndex = 0;
			onTabChange(null);
		}

		private function onTabFetch(event:FetchEvent):void
		{
			FetchHelper.instance.keepFetching();
		}

//		private function onFetchMoney(event:FetchEvent):void
//		{
//			if (FetchHelper.instance.fetchType == FetchType.PACK)
//			{
//				var packMaker:PackHolderData = FetchHelper.instance.parms as PackHolderData;
//				if (GameInstance.mainCharData.money == 0)
//				{
//					MessageManager.instance.addHintById_client(13, "金币为空，无法进行打包"); //金币为空，无法进行打包
//					FetchHelper.instance.keepFetching();
//				}
//				else
//				{
//					(TWindowManager.instance.showPopup2(null, MoneyPackMakerDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, MoneyType.MONEY) as MoneyPackMakerDialog).data = packMaker;
//				}
//			}
//			else
//			{
//				FetchHelper.instance.keepFetching();
//			}
//		}

//		private function onFetchMagicCrystal(event:FetchEvent):void
//		{
//			if (FetchHelper.instance.fetchType == FetchType.PACK)
//			{
//				var packMaker:PackHolderData = FetchHelper.instance.parms as PackHolderData;
//				if (GameInstance.mainCharData.magicCrystal == 0)
//				{
//					MessageManager.instance.addHintById_client(14, "魔晶为空，无法进行打包"); //魔晶为空，无法进行打包
//					FetchHelper.instance.keepFetching();
//				}
//				else
//				{
//					(TWindowManager.instance.showPopup2(null, MoneyPackMakerDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, MoneyType.MAGIC_CRYSTAL) as MoneyPackMakerDialog).data = packMaker;
//				}
//			}
//			else
//			{
//				FetchHelper.instance.keepFetching();
//			}
//		}

//		private function onFetchMagicStone(event:FetchEvent):void
//		{
//			if (FetchHelper.instance.fetchType == FetchType.PACK)
//			{
//				MessageManager.instance.addHintById_client(15, "无法进行打包"); //无法进行打包
//			}
//			FetchHelper.instance.keepFetching();
//		}
		private function onFetchIntergrate(event:FetchEvent):void
		{
			if (FetchHelper.instance.fetchType == FetchType.PACK)
			{
				MessageManager.instance.addHintById_client(15, "无法进行打包"); //无法进行打包				
			}
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

		private function onResizeBag(event:ItemEvent):void
		{
			var currentCate:int = int(heroBagPanel.group.selectedButton.data);
			updateBoxes(currentCate); //刷新格子
			setBagSizeText(BagItemManager.instance.getBagSize());
		}

//		/**
//		 * 商品列表点击
//		 * @param saleItemData
//		 *
//		 */
//		private function onSaleItemClick(mallItemData:MallItemData):void
//		{
//			if (mallItemData)
//			{
//				TWindowManager.instance.showPopup2(null, ShopBuyNumDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, [mallItemData, ShopManager.instance.findItemInAllShop(mallItemData.itemData.
//					templateId)]);
//			}
//		}

//		/**
//		 * 商品数据变更
//		 * @param event
//		 *
//		 */
//		private function onCategoryChange(event:DataEvent):void
//		{
//			var type:int = int(event.data);
//			onCategoryUpdate(type);
//		}

//		/**
//		 * 商城数据更新
//		 * @param type
//		 *
//		 */
//		private function onCategoryUpdate(type:int):void
//		{
//			if (type != MallConst.CATEGORY_HOT) //热销物品不显示
//			{
//				return;
//			}
//			var categoryList:TPagedListCollection = MallModel.instance.getCategory(type);
//			heroBagPanel.saleList.dataProvider = categoryList.host;
//		}

		/**
		 * 整理CD中触发
		 * @param event
		 *
		 */
		private function onTidyupCD():void
		{
			if (heroBagPanel.tbtn_tidyup.enabled)
			{
				heroBagPanel.tbtn_tidyup.enabled = false;
			}
			heroBagPanel.tbtn_tidyup.text = LanguageManager.translate(29012, "整理") + "(" + (_tidyupCDTimer.timer.repeatCount - _tidyupCDTimer.timer.currentCount) + ")";
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
			var lastCD:int = SlotItemManager.instance.getlastCDTime(ItemConst.CONTAINER_BACKPACK, getTimer());
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
			if (heroBagPanel.tbtn_tidyup.enabled)
			{
				heroBagPanel.tbtn_tidyup.enabled = false;
			}
			_tidyupCDTimer = TimerManager.createNormalTimer(1000, lastCD / 1000, onTidyupCD, null, onTidyupCDComplete, null);
			heroBagPanel.tbtn_tidyup.text = LanguageManager.translate(29012, "整理") + "(" + int(lastCD / 1000) + ")";
		}

		private function resetTidyupBtn():void
		{
			heroBagPanel.tbtn_tidyup.enabled = true;
			heroBagPanel.tbtn_tidyup.text = LanguageManager.translate(29012, "整理");
		}

		private function onChangeBagTabTo(index:int):void
		{
			if (_bagDataList)
			{
				_tabController.selectedIndex = index;
				var currentCate:int = int(heroBagPanel.group.selectedButton.data);
				//根据分类筛选
				updateDataProvider(currentCate); //更新数据源
				updateTabHeads(currentCate); //刷新选项卡
				updateBoxes(currentCate); //刷新格子
			}
		}
	}
}
