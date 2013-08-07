package fj1.common.res.item
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.item.vo.EquipSlotTemplate;
	import fj1.common.res.item.vo.EquipStoneTemplate;
	import fj1.common.res.item.vo.EquipmentTemplate;
	import fj1.common.res.item.vo.ItemEffectTemplate;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.manager.CDManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.XMLAnalyser;

	public class ItemTemplateManager extends EventDispatcher
	{
		private static const log:ILogger = TLog.getLogger(ItemTemplateManager);
		private static var _instance:ItemTemplateManager = null;
		private var _items:Dictionary = new Dictionary();
		private var _equipSlotTemplateDic:Dictionary = new Dictionary(); // 装备插槽模板配置
		private var tempEquipmentsBuf:Dictionary;
		private var _indexContainer:Object;
		private var _itemLoaded:Boolean = false;
		private var _equipLoaded:Boolean = false;

//		private var _equipGemLoaded:Boolean = false;
		public function ItemTemplateManager()
		{
			if (_instance != null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
			_indexContainer = new Object();
		}

		public static function get instance():ItemTemplateManager
		{
			if (_instance == null)
				new ItemTemplateManager();
			return _instance;
		}

		/**
		 *加载物品配置
		 * @param data
		 * @return
		 *
		 */
		public function loadItem(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getArray(ItemTemplate, data);
			if (list)
			{
				for each (var item:ItemTemplate in list)
				{
//					if (item.prototype_ex_id == 0)
//					{
//						
//					}
					_items[item.id] = item;
					if (item.prototype_ex_id != 0)
					{
						//缓存在tempEquipmentsBuf, 到装备模板文件加载后继续初始化
						if (!tempEquipmentsBuf)
							tempEquipmentsBuf = new Dictionary();
						tempEquipmentsBuf[item.prototype_ex_id] = item;
					}
				}
				createIndex("type");
				CDManager.getInstance().initCD(_items);
				_itemLoaded = true;
				dispatchEvent(new Event("itemloaded"));
				return true;
			}
			return false;
		}

		/**
		 *加载装备配置
		 * @param data
		 * @return
		 *
		 */
		public function loadEquipment(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getArray(EquipmentTemplate, data);
			if (list)
			{
				var doList:Function = function(e:Event):void
				{
					if (e)
						e.currentTarget.removeEventListener(e.type, arguments.callee);
					for each (var equipment:EquipmentTemplate in list)
					{
						var item:ItemTemplate = tempEquipmentsBuf[equipment.id] as ItemTemplate;
						if (!item)
						{
							log.error("物品模板中找不到 ItemInfo.prototype_ex_id = quipment.id: " + equipment.id + "的对应项");
						}
						else
						{
							equipment.initByItem(item);
						}
						_items[equipment.id] = equipment;
					}
					_equipLoaded = true;
					dispatchEvent(new Event("equipLoaded"));
				};
				if (_itemLoaded)
				{
					doList(null);
				}
				else
				{
					this.addEventListener("itemloaded", doList);
				}
				return true;
			}
			return false;
		}

		/**
		 * 加载镶嵌孔静态配置
		 * @param data
		 * @return
		 *
		 */
		public function loadGemSlot(data:*):Boolean
		{
			_equipSlotTemplateDic = ResManagerHelper.getDictionary(EquipSlotTemplate, data, "id");
			return _equipSlotTemplateDic != null;
//			return ResManagerHelper.mapDictionaryList(_equipSlotTemplateDic, EquipSlotTemplate, data);
		}

		/**
		 * 加载镶嵌宝石配置
		 * @param data
		 * @return
		 *
		 */
		public function loadEquipGem(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getArray(EquipStoneTemplate, data);
			if (list)
			{
				var doList:Function = function(e:Event):void
				{
					if (e)
						e.currentTarget.removeEventListener(e.type, arguments.callee);
					for each (var stoneT:EquipStoneTemplate in list)
					{
						var item:ItemTemplate = _items[stoneT.id] as ItemTemplate;
						if (!item)
						{
							log.error("物品模板中找不到 ItemInfo.id = EquipStoneTemplate.id: " + stoneT.id + "的对应项");
						}
						else
						{
							stoneT.initByItem(item);
						}
						_items[stoneT.id] = stoneT;
					}
//					_equipGemLoaded = true;
					dispatchEvent(new Event("equipGemLoaded"));
				};
				if (_equipLoaded)
				{
					doList(null);
				}
				else
				{
					this.addEventListener("equipLoaded", doList);
				}
				return true;
			}
			return false;
		}

		/**
		 *加载物品表现配置
		 * @param data
		 * @return
		 *
		 */
		public function loadItemEffect(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getArray(ItemEffectTemplate, data);
			if (list)
			{
//				var doList:Function = function(e:Event):void
//				{
//					if (e)
//						e.currentTarget.removeEventListener(e.type, arguments.callee);
				for each (var effectInfo:ItemEffectTemplate in list)
				{
					var item:ItemTemplate = _items[effectInfo.id] as ItemTemplate;
					if (!item)
					{
						log.error("设置物品Effect模板失败，物品模板中找不到 ItemInfo.entry = " + effectInfo.id + "的对应项");
					}
					else
					{
						item.initByItemEffect(effectInfo);
						item.description = item.description.replace(/\\n/g, "\n");
						item.descriptionExtend = item.descriptionExtend.replace(/\\n/g, "\n");
						item.useeffect_description = item.useeffect_description.replace(/\\n/g, "\n");
						item.useeffect_descriptionExtend = item.useeffect_descriptionExtend.replace(/\\n/g, "\n");
					}
				}
//				};
//				if (_equipGemLoaded)
//				{
//				doList(null);
//				}
//				else
//				{
//					this.addEventListener("equipGemLoaded", doList);
//				}
				return true;
			}
			return false;
		}

		public function find(findHandler:Function):ItemTemplate
		{
			for each (var itemT:ItemTemplate in _items)
			{
				if (findHandler(itemT))
				{
					return itemT;
				}
			}
			return null;
		}

		/**
		 * 查找一组符合条件的物品模板
		 * @param findHandler
		 * @return
		 *
		 */
		public function findArray(findHandler:Function):Array
		{
			var ret:Array = [];
			for each (var itemT:ItemTemplate in _items)
			{
				if (findHandler(itemT))
				{
					ret.push(itemT);
				}
			}
			return ret;
		}

		/**
		 * 根据属性名创建索引
		 * @param propName
		 *
		 */
		public function createIndex(propName:String):void
		{
			var indexDic:Dictionary = new Dictionary();
			for each (var itemT:ItemTemplate in _items)
			{
				var key:Object = itemT[propName];
				var valueList:Array = indexDic[key];
				if (valueList)
					valueList.push(itemT);
				else
					indexDic[key] = [itemT];
			}
			_indexContainer[propName] = indexDic;
		}

		/**
		 *
		 * @param propName
		 * @param value
		 * @return
		 *
		 */
		public function getTemplateList(propName:String, value:Object):Array
		{
			var indexDic:Dictionary = _indexContainer[propName];
			if (!indexDic)
			{
				log.error("未为属性" + propName + "创建索引");
				return null;
			}
			return indexDic[value];
		}

		/**
		 * 获取装备镶嵌孔配置
		 * @param id
		 * @return
		 *
		 */
		public function getEquipSlotTemplate(id:int):EquipSlotTemplate
		{
			var ret:EquipSlotTemplate = _equipSlotTemplateDic[id];
			if (!ret)
			{
				log.error("获取装备镶嵌孔配置失败 id = " + id);
			}
			return ret;
		}

		public function get(id:uint):ItemTemplate
		{
			if (!_items.hasOwnProperty(id))
			{
				log.error("ItemTemplateManager 模板数据中找不到templateId：" + id);
			}
			return _items[id];
		}

		public function get items():Dictionary
		{
			return _items;
		}
	}
}
