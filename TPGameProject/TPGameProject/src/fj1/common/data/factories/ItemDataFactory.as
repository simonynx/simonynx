package fj1.common.data.factories
{
	import fj1.common.data.dataobject.items.EnemyData;
	import fj1.common.data.dataobject.items.EquipStoneData;
	import fj1.common.data.dataobject.items.ExpendItemData;
	import fj1.common.data.dataobject.items.FixItemData;
	import fj1.common.data.dataobject.items.GodProtectItem;
	import fj1.common.data.dataobject.items.IdentifierData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.dataobject.items.PetEggData;
	import fj1.common.data.dataobject.items.ScrollData;
	import fj1.common.data.dataobject.items.VIPCardItem;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.EquipmentTemplate;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemSpecailConst;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.net.vo.TPacketIn;

	public class ItemDataFactory
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
		public static function create(ownerId:int, guid:int, props:Array, updateProps:Boolean = true, packet:TPacketIn = null, cdEnabled:Boolean = false):ItemData
		{
			if (!props || props.length == 0)
			{
				log.error("创建物品失败！属性列表长度为0");
				return null;
			}
			var templateId:int = ObjectCreateHelper.getTemplateId(props, "template", ItemData); //从props中获取模板Id
			var obj:ItemData = createByID(ownerId, guid, templateId, props, 1, packet, cdEnabled) //创建对象
			if (updateProps) //更新属性
			{
				ObjectCreateHelper.updateObj(obj, props);
			}
			return obj;
		}

		/**
		 * 使用模板ID创建物品
		 * @param ownerId
		 * @param guid
		 * @param templateId
		 * @param props
		 * @param num
		 * @param packet
		 * @param cdEnabled
		 * @return
		 *
		 */
		public static function createByID(ownerId:int, guid:int, templateId:int, props:Array = null, num:int = 1, packet:TPacketIn = null, cdEnabled:Boolean = false):ItemData
		{
			var templateInfo:ItemTemplate;
			//其他物品
			templateInfo = ItemTemplateManager.instance.get(templateId); //查询模板
			if (!templateInfo)
			{
				log.error("无效的模板Id: " + templateId);
			}
			return createByTemplate(ownerId, guid, templateInfo, props, num, packet, cdEnabled);
		}

		/**
		 * 使用物品模板创建物品
		 * @param ownerId
		 * @param guid
		 * @param templateInfo
		 * @param props
		 * @param num
		 * @param packet
		 * @param cdEnabled
		 * @return
		 *
		 */
		public static function createByTemplate(ownerId:int, guid:int, templateInfo:ItemTemplate, props:Array = null, num:int = 1, packet:TPacketIn = null, cdEnabled:Boolean = false):ItemData
		{
			if (!templateInfo)
			{
				return null;
			}
			var item:ItemData;
			if (templateInfo is EquipmentTemplate)
			{
//				var equipData:EquipmentData = new EquipmentData(ownerId, guid, templateInfo as EquipmentTemplate, num, cdEnabled);
//				if (guid == 0)
//				{
//					equipData.durability = equipData.equipmentTemplate.max_durability;
//				}
//				item = equipData;
			}
			else
			{
				return item = new ItemData(ownerId, guid, templateInfo, num, cdEnabled);
				;
//				switch (templateInfo.id)
//				{
//					case ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT:
//						item = new GodProtectItem(ownerId, guid, templateInfo, num, cdEnabled);
//						break;
//					case ItemSpecailConst.ITEM_TEMPLATE_ENEMY_TRACE:
//						item = new EnemyData(ownerId, guid, templateInfo, num, cdEnabled);
//						break;
//					default:
//						switch (templateInfo.type)
//						{
//							case ItemConst.TYPE_ITEM_MAGIC_WARD: //魔法阵物品
//								item = new MagicWardData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_ITEM_DRUG:
//								switch (templateInfo.subtype)
//								{
//									case ItemConst.SUB_TYPE_DRUG_FIX: //修理物品
//										item = new FixItemData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									case ItemConst.SUB_TYPE_DRUG_EXPEND_BAG: //背包扩展物品
//									case ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT: //仓库扩展物品
//										item = new ExpendItemData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									case ItemConst.SUB_TYPE_DRUG_MAGICWATER:
//										item = new MagicWaterData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									default:
//										item = new ItemData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//								}
//								break;
//							case ItemConst.TYPE_ITEM_WRAP: //礼包
//								switch (templateInfo.subtype)
//								{
//									case ItemConst.SUB_TYPE_WRAP_LUCKY_BOX: //宝箱
//										item = new LuckyBoxData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									case ItemConst.SUB_TYPE_WRAP_SYSTEM_PACK: //礼包
//										item = new SystemPackData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									case ItemConst.SUB_TYPE_WRAP_PACK_HOLDER: //礼包布
//										item = new PackHolderData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									case ItemConst.SUB_TYPE_WRAP_LOTTERY_TICKET: //彩票
//										item = new LotteryTicketData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//									default:
//										item = new ItemData(ownerId, guid, templateInfo, num, cdEnabled);
//										break;
//								}
//								break;
//							case ItemConst.TYPE_ITEM_EGG:
//								item = new PetEggData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_ITEM_PET_SEAL:
//								item = new PetEggSealData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_ITEM_SPELLBOOK:
//								item = new SpellBookData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_ITEM_HORSE:
//								item = new HorseItemData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_MAIL:
//								item = new ScrollData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_VIP:
//								item = new VIPCardItem(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_ITEM_DRUG:
//								item = new DrugData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_IDENTIFIER:
//								item = new IdentifierData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.SUB_TYPE_DRUG_ERUPT:
//								item = new EruptData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_EQUIP_STONE:
//								item = new EquipStoneData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							case ItemConst.TYPE_HEAD_PROTRAIT:
//								item = new HeadProtraitItemData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//							default:
//								item = new ItemData(ownerId, guid, templateInfo, num, cdEnabled);
//								break;
//						}
//						break;
//				}
			}
			return item;
		}
	}
}
