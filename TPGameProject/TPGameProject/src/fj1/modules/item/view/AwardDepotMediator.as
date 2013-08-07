package fj1.modules.item.view
{
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.view.components.AwardDepotPanel;
	import fj1.modules.item.view.components.AwardDepotDataBox;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TTabController;
	import tempest.ui.events.TAlertEvent;

	public class AwardDepotMediator extends Mediator
	{
		[Inject]
		public var awordDepotPanel:AwardDepotPanel;

		private var _depotDataListPageHelper:TPagedListCollection;
		private var _changeWatcherManager:ChangeWatcherManager;

		public function AwardDepotMediator()
		{
			_changeWatcherManager = new ChangeWatcherManager();
			super();
		}

		public override function onRegister():void
		{
			var depotDataList:TArrayCollection = TArrayCollection(SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_AWORD_DEPOT));
//			if (!_depotDataListPageHelper)
//			{
//				_depotDataListPageHelper = new TPagedListCollection(depotDataList, ItemConst.AWORD_DEPOT_PAGE_SIZE, false);
//			}
			//选项卡默认选中第一页
//			awordDepotPanel.tabController.addEventListener(Event.CHANGE, onTabChange);
//			awordDepotPanel.tabController.selectedIndex = 0;
//			updateDataProvider(); //更新数据源
//			updateBoxes();
//			addSignal(awordDepotPanel.tidyUp, onTidyUp);
			awordDepotPanel.list.dataProvider = depotDataList;
			addSignal(awordDepotPanel.removeAll, onRemoveAll); //全部删除
			addSignal(awordDepotPanel.moveAllToBag, onMoveAllToBag); //全部移到个人背包
			addSignal(awordDepotPanel.moveAllToDepot, onMoveAllToDepot); //全部移到个人仓库
		}

		public override function onRemove():void
		{
			awordDepotPanel.list.dataProvider = null;
//			awordDepotPanel.tabController.removeEventListener(Event.CHANGE, onTabChange);
		}

//		private function onTabChange(event:Event):void
//		{
//			if (awordDepotPanel.parent)
//			{
//				updateDataProvider(); //更新数据源
//				updateBoxes();
//			}
//		}

//		/**
//		 * 更新数据源
//		 * @param currentCate
//		 *
//		 */
//		private function updateDataProvider():void
//		{
//			var tabController:TTabController = awordDepotPanel.tabController;
//			for (var i:String in awordDepotPanel.bagLists)
//			{
//				if (i != tabController.selectedIndex.toString())
//				{
//					//不是当前页的列表，数据源置空
//					(awordDepotPanel.bagLists[i] as TFixedList).dataProvider = null;
//				}
//			}
//			_depotDataListPageHelper.currentPage = tabController.selectedIndex;
//			//绑定当前页
//			if (tabController.selectedIndex >= 0)
//			{
//				(awordDepotPanel.bagLists[tabController.selectedIndex] as TFixedList).dataProvider = _depotDataListPageHelper.pagedCollection;
//			}
//		}

//		/**
//		 * 刷新格子
//		 *
//		 */
//		private function updateBoxes():void
//		{
//			var curList:TFixedList = awordDepotPanel.bagLists[awordDepotPanel.tabController.selectedIndex];
//			var size:int = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_AWORD_DEPOT).length;
//			for (var i:int = 0; i < _depotDataListPageHelper.pageSize; ++i)
//			{
//				var bagRender:BaseDataListItemRender = BaseDataListItemRender(curList.getItemRender(i));
//				AwardDepotDataBox(bagRender.dataBox).visible = awordDepotPanel.getRenderIndex(bagRender) < size;
//			}
//		}

//		private function onTidyUp(event:MouseEvent):void
//		{
//			SlotItemManager.instance.tidyUp(ItemConst.CONTAINER_AWORD_DEPOT);
//		}

		private function onRemoveAll(event:MouseEvent):void
		{
			TAlertHelper.showDialog(57, "你确定要清空奖励仓库内所有奖品？", false, TAlert.OK | TAlert.CANCEL, onCleanEnsure);
		}

		private function onCleanEnsure(event:TAlertEvent):void
		{
			if (event.flag == TAlert.OK)
			{
				GameClient.sendAwordDepotRemoveAll();
			}
		}

		private function onMoveAllToBag(event:MouseEvent):void
		{
			GameClient.sendAwordMoveAllToBag();
		}

		private function onMoveAllToDepot(event:MouseEvent):void
		{
			GameClient.sendAwordMoveAllToDepot();
		}
	}
}
