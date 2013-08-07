package fj1.common.data.factories
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.res.card.CardTemplateManager;
	import fj1.common.res.card.vo.CardTemplate;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.engine.SceneCharacter;

	public class CardFactory
	{
		private static const log:ILogger = TLog.getLogger(ItemDataFactory);

		/**
		 *
		 * @param guid
		 * @param props 索引-属性 列表
		 * @param templateProperty 模板Id对应的属性名
		 * @param objClass 类
		 * @param updateProps 是否在创建后更新对象所有属性
		 * @param packet
		 * @param cdEnabled
		 * @return
		 *
		 */
		public static function create(ownerId:int, guid:int, props:Array, updateProps:Boolean = true, sc:SceneCharacter = null):Card
		{
			if (!props || props.length == 0)
			{
				log.error("创建物品失败！属性列表长度为0");
				return null;
			}
			var templateId:int = ObjectCreateHelper.getTemplateId(props, "template", Card); //从props中获取模板Id
			var obj:Card = createByID(ownerId, guid, templateId, sc) //创建对象
			if (updateProps) //更新属性
			{
				ObjectCreateHelper.updateObj(obj, props);
			}
			return obj;
		}

		public static function createByID(ownerId:int, guid:int, templateId:int, sc:SceneCharacter):Card
		{
			var template:CardTemplate = CardTemplateManager.getTemplate(templateId);
			return new Card(ownerId, guid, template, sc);
		}

	}
}
