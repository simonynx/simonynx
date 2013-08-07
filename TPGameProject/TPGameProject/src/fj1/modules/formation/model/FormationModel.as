package fj1.modules.formation.model
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.data.dataobject.CardConst;
	import fj1.common.data.factories.CardFactory;
	import fj1.common.res.card.vo.CardTemplate;
	import tempest.ui.collections.TArrayCollection;

	public class FormationModel
	{
		[Bianble]
		public var formationListArr:TArrayCollection;

		public function FormationModel()
		{
			formationListArr = new TArrayCollection(new Array(6));
		}

		/**
		 * 改变武将位置
		 * @param card 武将卡
		 * @param int 位置
		 * @param int 原先位置
		 *
		 */
		public function changePos(card:Card, pos:int, currentPos:int):void
		{
			var obj:Card;
			if (!formationListArr[pos])
			{
				formationListArr[pos] = card;
				clearCard(currentPos);
			}
			else
			{
				obj = formationListArr[pos];
				clearCard(pos);
				formationListArr[pos] = card;
				clearCard(currentPos);
				formationListArr[currentPos] = obj;
			}
		}

		/**
		 * 从武将背包拖武将到阵型上
		 * @param card 武将卡
		 * @param pos 位置
		 *
		 */
		public function changeCardByBag(card:Card, pos:int):void
		{
			if (card.state == CardConst.FIGHT)
			{
				trace("该武将已出战");
				return;
			}
			var _card:Card = formationListArr[pos];
			if (_card)
			{
				changeCardState(_card, CardConst.REST);
				clearCard(pos);
				formationListArr[pos] = card;
			}
			else
				formationListArr[pos] = card;
			changeCardState(card, CardConst.FIGHT);
		}

		/**
		 * 改变武将出战状态
		 * @param card
		 * @param state
		 *
		 */
		public function changeCardState(card:Card, state:int):void
		{
			if (card.state != state)
				card.state = state
		}

		/**
		 * 清空指定位置的武将
		 * @param pos
		 *
		 */
		public function clearCard(pos:int):void
		{
			if (formationListArr[pos])
				formationListArr[pos] = null;
		}
	}
}
