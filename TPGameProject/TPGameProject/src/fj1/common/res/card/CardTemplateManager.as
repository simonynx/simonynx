package fj1.common.res.card
{
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.card.vo.CardLevelTemplate;
	import fj1.common.res.card.vo.CardStarLevelTemplate;
	import fj1.common.res.card.vo.CardTemplate;

	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class CardTemplateManager
	{
		private static const log:ILogger = TLog.getLogger(CardTemplateManager);

		private static var _cardTemplates:Dictionary;
		private static var _cardLeveTemplates:Dictionary;
		private static var _cardStarLeveTemplates:Dictionary;

		public static function loadTemplate(data:*):void
		{
			_cardTemplates = ResManagerHelper.getDictionary(CardTemplate, data, "id");
		}

		public static function loadLevelTemplate(data:*):void
		{
			_cardLeveTemplates = ResManagerHelper.getDictionary(CardLevelTemplate, data, "id");
		}

		public static function loadStarLevelTemplate(data:*):void
		{
			_cardStarLeveTemplates = ResManagerHelper.getDictionary(CardStarLevelTemplate, data, "id");
		}

		public static function getTemplate(id:int):CardTemplate
		{
			if (!_cardTemplates.hasOwnProperty(id))
			{
				log.error("getTemplate 模板数据中找不到CardTemplate.id：" + id);
			}
			return _cardTemplates[id];
		}

		public static function getLevelTemplate(level:int):CardLevelTemplate
		{
			if (!_cardLeveTemplates.hasOwnProperty(level))
			{
				log.error("getLevelTemplate 模板数据中找不到CardLevelTemplate.id：" + level);
			}
			return _cardLeveTemplates[level];
		}

		public static function getStarLevelTemplate(level:int):CardStarLevelTemplate
		{
			if (!_cardStarLeveTemplates.hasOwnProperty(level))
			{
				log.error("getStarLevelTemplate 模板数据中找不到CardStarLevelTemplate.id：" + level);
			}
			return _cardStarLeveTemplates[level];
		}

	}
}
