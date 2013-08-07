package fj1.modules.card.view
{
	import fj1.common.data.dataobject.Card;
	import fj1.modules.card.constants.CardType;
	import fj1.modules.card.signals.CardBagSignals;
	import fj1.modules.card.view.components.CardInfoPanel;

	import tempest.common.mvc.base.Mediator;

	public class CardInfoPanelMediator extends Mediator
	{
		[Inject]
		public var infoPanel:CardInfoPanel;

		[Inject]
		public var cardBagSignals:CardBagSignals;

		public function CardInfoPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(cardBagSignals.cardSelected, onCardSelected);

			var card:Card = infoPanel.data as Card;

			updateView(card);
		}

		override public function onRemove():void
		{
			infoPanel.data = null;
		}

		private function updateView(card:Card):void
		{
			if (card)
			{
				infoPanel.lbl_type.text = CardType.getString(card.type);
				infoPanel.lbl_name.text = card.name;
				infoPanel.lbl_level.text = card.level.toString();

				infoPanel.mc_star.visible = true;
				infoPanel.mc_star.gotoAndStop(card.starLevel);
				//				infoPanel.lbl_cost.text = card.cardStarLevelTemplate.need_point.toString();
				infoPanel.lbl_attack.text = card.attack.toString();
				infoPanel.lbl_life.text = card.healthMax.toString();

				infoPanel.avatar = card.createAvatar();
			}
			else
			{
				infoPanel.lbl_type.text = "";
				infoPanel.lbl_name.text = "";
				infoPanel.lbl_level.text = "";

				infoPanel.mc_star.visible = false;
				infoPanel.lbl_cost.text = "";
				infoPanel.lbl_attack.text = "";
				infoPanel.lbl_life.text = "";

				infoPanel.avatar = null;
			}
		}

		private function onCardSelected(card:Card):void
		{
			infoPanel.data = card;
			updateView(card);
		}
	}
}
