package fj1.modules.formation.view
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.data.dataobject.CardConst;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.card.constants.CardBagConst;
	import fj1.modules.card.signals.CardBagSignals;
	import fj1.modules.card.view.components.CardBagPanel;
	import fj1.modules.formation.model.FormationModel;
	import fj1.modules.formation.service.FormationService;
	import fj1.modules.formation.signal.FormationSignal;
	import fj1.modules.formation.view.components.FormationDragView;
	import fj1.modules.formation.view.components.FormationListItemRender;
	import fj1.modules.formation.view.components.FormationPanel;
	import flash.events.MouseEvent;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.ListEvent;
	import tempest.utils.ListenerManager;

	public class FormationPanelMediator extends Mediator
	{
		[Inject]
		public var view:FormationPanel;
		[Inject]
		public var model:FormationModel;
		[Inject]
		public var signal:FormationSignal;
		[Inject]
		public var service:FormationService;
		[Inject]
		public var cardBagSignals:CardBagSignals;
		private var _listenerManager:ListenerManager;

		public function FormationPanelMediator()
		{
			super();
			_listenerManager = new ListenerManager();
		}

		override public function onRegister():void
		{
			view.formationList.dataProvider = model.formationListArr;
			view.formationList.foreach(function(render:TListItemRender):void
			{
				_listenerManager.addEventListener(render, DragEvent.DROP_DOWN, onDropDown);
				_listenerManager.addEventListener(render, MouseEvent.DOUBLE_CLICK, onDoubleClick);
			});
			cardBagSignals.changeViewModel.dispatch(CardBagConst.VIEW_MODEL_PICK);
			_listenerManager.addEventListener(view.tbtn_close, MouseEvent.CLICK, onCloseClick);
		}

		/**
		 * 双击使用
		 * @param event
		 *
		 */
		private function onDoubleClick(event:MouseEvent):void
		{
			var itemRender:FormationListItemRender = event.currentTarget as FormationListItemRender;
			model.changeCardState(itemRender.data as Card, CardConst.REST);
			model.clearCard(itemRender.index);
		}

		/**
		 * 放下
		 * @param event
		 *
		 */
		private function onDropDown(event:DragEvent):void
		{
			var itemRender:FormationListItemRender = event.currentTarget as FormationListItemRender;
			switch (event.dragFrom.place)
			{
				case DragImagePlaces.FORMATION:
					var formationDragView:FormationDragView = event.dragFrom as FormationDragView;
					model.changePos(event.dragFrom.data as Card, itemRender.index, FormationListItemRender(formationDragView.parent).index);
					break;
				case DragImagePlaces.CARD_BAG:
					model.changeCardByBag(event.dragFrom.data as Card, itemRender.index);
					break;
			}
		}

		override public function onRemove():void
		{
			view.formationList.dataProvider = null;
			_listenerManager.removeAll();
			cardBagSignals.changeViewModel.dispatch(CardBagConst.VIEW_MODEL_DEFAULT);
		}

		private function onCloseClick(event:MouseEvent):void
		{
			TWindowManager.instance.removePopupByName(CardBagPanel.NAME); //关闭布阵界面时，同时关闭武将背包
		}
	}
}
