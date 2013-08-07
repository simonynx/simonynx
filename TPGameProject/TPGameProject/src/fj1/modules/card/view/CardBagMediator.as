package fj1.modules.card.view
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.WindowPair;
	import fj1.manager.SlotItemManager;
	import fj1.modules.card.constants.CardBagConst;
	import fj1.modules.card.signals.CardBagSignals;
	import fj1.modules.card.view.components.CardBagItemRender;
	import fj1.modules.card.view.components.CardBagPanel;
	import fj1.modules.card.view.components.CardInfoPanel;
	import fj1.modules.formation.view.components.FormationPanel;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.collections.Sort;
	import tempest.ui.collections.SortField;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.ListEvent;
	import tempest.utils.ListenerManager;

	public class CardBagMediator extends Mediator
	{
		[Inject]
		public var cardBag:CardBagPanel;

		[Inject]
		public var cardBagSignals:CardBagSignals;

		private var _listenerManager:ListenerManager;

		private var _cardWatcherMgr:ChangeWatcherManager;

		private var _filteredCollection:TArrayCollection;

		public function CardBagMediator()
		{
			super();
			_listenerManager = new ListenerManager();
			_cardWatcherMgr = new ChangeWatcherManager();
			_filteredCollection = new TArrayCollection();
		}

		public override function onRegister():void
		{
			_listenerManager.addEventListener(cardBag.list, ListEvent.ITEM_RENDER_CREATE, onRenderCreate);

			cardBag.list.dataProvider = _filteredCollection;

			_listenerManager.addEventListener(cardBag.tbtn_close, MouseEvent.CLICK, onCloseClick);

			_listenerManager.addEventListener(cardBag.rbtn_typeAll, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_attack, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_defence, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_cure, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_balance, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_typeOther, Event.CHANGE, onFilterChange);

			_listenerManager.addEventListener(cardBag.rbtn_qualityAll, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_qualityWhite, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_qualityGreen, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_qualityBlue, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_qualityPurple, Event.CHANGE, onFilterChange);
			_listenerManager.addEventListener(cardBag.rbtn_qualityOringe, Event.CHANGE, onFilterChange);

			_listenerManager.addEventListener(cardBag.rbtn_sortAttack, Event.CHANGE, onSortChange);
			_listenerManager.addEventListener(cardBag.rbtn_sortLife, Event.CHANGE, onSortChange);

			_listenerManager.addSignal(cardBagSignals.changeViewModel, onChangeViewModel);

			/////////////////////////////////////////////////////////////////

			//设置数据源
			_filteredCollection.list = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_CARD);
			_filteredCollection.filterFunction = filterHandler;

			cardBag.rbtn_typeAll.select(); //默认分类选择
			cardBag.rbtn_qualityAll.select();

			//初始化窗口显示模式
			initViewModel();
		}

		public override function onRemove():void
		{
			cardBag.list.dataProvider = null;
			_listenerManager.removeAll();
		}

		private function onCloseClick(event:MouseEvent):void
		{
			TWindowManager.instance.removePopupByName(CardInfoPanel.NAME); //关闭武将背包时，同时关闭武将信息界面
		}

		private function initViewModel():void
		{
			if (TWindowManager.instance.findPopup(FormationPanel.NAME))
			{
				onChangeViewModel(CardBagConst.VIEW_MODEL_PICK);
			}
			else
			{
				onChangeViewModel(CardBagConst.VIEW_MODEL_DEFAULT);
			}
		}

		private function onRenderCreate(event:ListEvent):void
		{
			var render:CardBagItemRender = event.itemRender as CardBagItemRender;
			render.addEventListener(DragEvent.PICK_UP, onItemRenderPickup);
			render.addEventListener(MouseEvent.CLICK, onCardSelect);
		}

		private function filterHandler(card:Card):Boolean
		{
			if (!card)
			{
				return false;
			}

			var type:int = cardBag.typeGroup.selectedButton ? cardBag.typeGroup.selectedButton.data as int : -1;
			if (type != -1 && card.type != type)
			{
				return false;
			}

			var quality:int = cardBag.qualityGroup.selectedButton ? cardBag.qualityGroup.selectedButton.data as int : -1;
			if (quality != -1 && card.quality != quality)
			{
				return false;
			}

			return true;
		}

		/**
		 * 改变筛选条件触发
		 * @param event
		 *
		 */
		private function onFilterChange(event:Event):void
		{
			_filteredCollection.refresh();
		}

		/**
		 * 改变排序条件触发
		 * @param event
		 *
		 */
		private function onSortChange(event:Event):void
		{
			var sort:Sort = new Sort();
			sort.fields = [new SortField("guId")];
			if (cardBag.sortGroup.selectedButton)
			{
				sort.fields.push(new SortField(cardBag.sortGroup.selectedButton.data as String));
			}
			_filteredCollection.sort = sort;
			_filteredCollection.refresh();
		}

		/**
		 * 武将被选中触发
		 * @param event
		 *
		 */
		private function onCardSelect(event:Event):void
		{
			if (cardBag.viewModel == CardBagConst.VIEW_MODEL_PICK) //拾起模式下禁用查看操作
			{
				return;
			}
			var card:Card = cardBag.list.selectedItem as Card;
			if (card)
			{
				WindowPair.instance.setPair(CardBagPanel.NAME, CardInfoPanel.NAME);
				cardBagSignals.cardSelected.dispatch(card);
			}
		}

		/**
		 * 武将拾起触发
		 * @param event
		 *
		 */
		private function onItemRenderPickup(event:DragEvent):void
		{
			if (cardBag.viewModel == CardBagConst.VIEW_MODEL_DEFAULT) //默认模式下禁用拾起操作
			{
				event.preventDefault();
			}
		}

		/**
		 * 改变界面模式触发
		 * @param model
		 *
		 */
		private function onChangeViewModel(model:int):void
		{
			cardBag.viewModel = model;
		}
	}
}
