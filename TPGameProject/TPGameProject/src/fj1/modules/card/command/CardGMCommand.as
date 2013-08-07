package fj1.modules.card.command
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.res.card.vo.CardTemplate;
	import fj1.common.staticdata.ItemConst;
	import fj1.manager.SlotItemManager;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.collections.TSlotDictionary;

	public class CardGMCommand
	{
		private static const log:ILogger = TLog.getLogger(CardGMCommand);

		private static var _count:int;

		public static function exec(tokens:Array):void
		{
			var type:String = tokens[0];
			switch (type)
			{
				case "add":
					var cardTemplate:CardTemplate = new CardTemplate();
					cardTemplate.id = 1;
					cardTemplate.face_ico = 5202 + _count;
					cardTemplate.model_id = 130025 + _count;
					var card:Card = new Card(0, _count, cardTemplate, null);
					card.slot = TSlotDictionary.makeSlot(ItemConst.CONTAINER_CARD, _count);
					card.num = 1;
					card.name = "name";
					SlotItemManager.instance.Add(card);

					++_count
					break;
				default:
					log.warn("CardGMCommand 无效的type: " + type);
					break;
			}
		}
	}
}
