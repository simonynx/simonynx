package fj1.manager
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.events.HintEvent;
	import fj1.common.events.item.SlotItemManagerEvent;
	import fj1.common.helper.IconFlyEffectHelper;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.hint.HintResManager;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.HintConst;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemSpecailConst;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.item.events.ItemEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	import tempest.common.logging.*;
	import tempest.ui.collections.Sort;
	import tempest.ui.collections.SortField;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.collections.TSlotDictionary;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TComponent;
	import tempest.ui.events.SlotDictionaryEvent;
	import tempest.ui.events.TAlertEvent;

	[Event(name = "add", type = "fj1.modules.item.events.ItemEvent")]
	[Event(name = "remove", type = "fj1.modules.item.events.ItemEvent")]
	[Event(name = "update", type = "fj1.modules.item.events.ItemEvent")]
	[Event(name = "resizeBag", type = "fj1.modules.item.events.ItemEvent")]
	public class BagItemManager extends EventDispatcher
	{
		private static var log:ILogger = TLog.getLogger(BagItemManager);
		private static var _instance:BagItemManager = null;
		private var _slotManager:SlotItemManager;
		private var _filtedItemList:TArrayCollection;
		private var _filterType:int;

		public static function get instance():BagItemManager
		{
			if (_instance == null)
				new BagItemManager();
			return _instance;
		}

		public function BagItemManager()
		{
			super(this);
			if (_instance != null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
			_slotManager = SlotItemManager.instance;
			//监听集合事件用于统计数量
			var slotDic:TSlotDictionary = _slotManager.getSlotDic();
			slotDic.addEventListener(SlotDictionaryEvent.ADD, onDicAdd);
			slotDic.addEventListener(SlotDictionaryEvent.REMOVE, onDicRemove);
			slotDic.addEventListener(SlotDictionaryEvent.SLOT_CHANGE, onDicSlotChange);
			//监听玩家背包数变化
			GameInstance.mainCharData.addEventListener("bagSizeChange", onBagSizeChange);
			//物品个数统计
			ItemNumCounterManager.instance;
			SlotItemManager.instance.addEventListener(SlotItemManagerEvent.RESIZE_LIST, onResize);
			//
			MessageManager.instance.addEventListener(HintEvent.HINT_SHOW, onItemHintShow);
			this.addEventListener(ItemEvent.ADD, onItemAdd);
			this.addEventListener(ItemEvent.REMOVE, onItemRemove);
		}

		/**
		 * 播放物品掉落效果
		 * @param event
		 *
		 */
		private function onItemHintShow(event:HintEvent):void
		{
//			if (event.hintType == HintConst.CONFIG_SERVER)
//			{
//				switch (event.id)
//				{
//					case HintConst.ID_ADD_ITEM: //添加物品处理
//						//播放物品获得效果
//						var itemData:ItemData = SlotItemManager.instance.getFirstItemByTemplateId(ItemConst.CONTAINER_BACKPACK, int(event.params[1]));
//						var target:TComponent = GameInstance.ui.mainUI.controllPanel.mainMenu.btn_showBag;
//						var bagBtnPos:Point = target.localToGlobal(new Point(0, 0));
//						IconFlyEffectHelper.play(itemData, target, 20, new Point(bagBtnPos.x - 40, bagBtnPos.y - 150), 20, 20, 0);
//						if (!itemData)
//						{
//							log.error("添加背包物品提示错误，背包中找不到template = " + int(event.params[1]) + "对应的物品");
//							return;
//						}
//						itemData.playGetSound(); //播放获得音效
//						testHint(itemData); //检查提示
//						//检查是否需要将药品设置到快捷栏上
//						checkSetToShortCut(itemData);
//						GameInstance.signal.item.itemAdd.dispatch(itemData);
//						break;
//					case HintConst.ID_REMOVE_ITEM:
//						GameInstance.signal.item.itemRemove.dispatch(int(event.params[1]));
//						break;
//					case HintConst.ID_PET_FULL: //宠物栏满处理
//						ShortCutHintManager.show(ShortCutHintConst.ID_PET_FULL, 2112, itemData, function(obj:Object):void
//						{
//							GameInstance.signal.pet.open.dispatch();
//						});
//						break;
//				}
//			}
		}

		/**
		 * 检查是否需要将药品设置到快捷栏上
		 * @param itemData
		 *
		 */
		private function checkSetToShortCut(itemData:ItemData):void
		{
			//红药或蓝药
//			if (itemData.type == ItemConst.TYPE_ITEM_DRUG && (itemData.itemTemplate.subtype == ItemConst.SUB_TYPE_DRUG_RED || itemData.itemTemplate.subtype == ItemConst.SUB_TYPE_DRUG_BLUE))
//			{
//				if (itemData.isBigDrug)
//				{
//					//是大药
//					var existShortCutDrug:ItemData = findBigDrugInShortCutBar(itemData.itemTemplate.subtype);
//					if (!existShortCutDrug)
//					{
//						var index1:int = ShortCutManager.instance.getFirstEmptyIndex(10);
//						if (index1 >= 0)
//						{
//							ShortCutHelper.setShortCut(index1, itemData);
//						}
//					}
//				}
//				else if (GameInstance.model.task.ableTaskList.hasOwnProperty(ItemConst.TASK_ID_SET_DRUG))
//				{
//					//需要设置药品的任务
//					var taskData:TaskData = GameInstance.model.task.getTaskData(ItemConst.TASK_ID_SET_DRUG);
//					if (taskData && taskData.type == TaskType.MAINLINE_TASK)
//					{
//						//找到第一个可设置的快捷栏位置
//						var startIndex:int = itemData.itemTemplate.subtype == ItemConst.SUB_TYPE_DRUG_RED ? 10 : 11;
//						var index:int = ShortCutManager.instance.getFirstEmptyIndex(startIndex);
//						if (index != -1)
//						{
//							ShortCutHelper.setShortCut(index, itemData);
//						}
//					}
//				}
//			}
		}

//		private static function findBigDrugInShortCutBar(subType:int):ItemData
//		{
//			var shortCutList:TArrayCollection = ShortCutManager.instance.shortCutItemList;
//			for each (var shortCutData:ShortCutData in shortCutList)
//			{
//				if (shortCutData && shortCutData.dataObject is ItemData)
//				{
//					var itemData:ItemData = ItemData(shortCutData.dataObject);
//					if (itemData.isBigDrug && itemData.itemTemplate.subtype == subType)
//					{
//						return itemData;
//					}
//				}
//			}
//			return null;
//		}
		/**
		 * 物品获得提示
		 * @param itemData
		 *
		 */
		public static function testHint(itemData:ItemData):void
		{
//			switch (itemData.type)
//			{
//				case ItemConst.TYPE_EQUIP: //装备获取提示
//					var equip:EquipmentData = itemData as EquipmentData;
//					if (equip)
//					{
//						if (!equip.canUse)
//						{
//							return;
//						}
//						var onUseRequestSuccess:Function = function(equipDt:EquipmentData):void
//						{
//							MessageManager.instance.addHintById_client(66, "自动穿戴%s成功", equipDt.name);
//						}
//						var bodyEquip:EquipmentData = SlotItemManager.instance.getFirstItemByType(ItemConst.CONTAINER_EQUIP, ItemConst.TYPE_EQUIP, equip.equipmentTemplate.subtype) as EquipmentData;
//						if (bodyEquip == null)
//						{
//							equip.useObj(onUseRequestSuccess);
//						}
//						else if (bodyEquip && EquipmentData.valuaCompare(bodyEquip, equip) >= 0)
//						{
//							return;
//						}
//						else
//						{
//							ShortCutHintManager.show(-1, 2101, equip, function(obj:Object):void
//							{
//								equip.useObj();
//							}, equip.name);
//						}
//					}
//					break;
//				case ItemConst.TYPE_ITEM_SPELLBOOK: //获取到技能书时提示
//					var skillInfo:SkillInfo = SkillTemplateManager.instrance.getSkillInfoByConsumeItemId(itemData.itemTemplate.templateId);
//					var skillData:SkillData = SkillDataManager.instance.getSkillData(skillInfo.templateId);
//					if (skillData && skillData.status == SkillData.CANLEARNED)
//					{
//						ShortCutHintManager.show(-1, 2109, itemData, function(obj:Object):void
//						{
//							TWindowManager.instance.showPopup2(null, SkillPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, null, skillData);
//						}, itemData.name);
//					}
//					break;
//				case ItemConst.TYPE_ITEM_EGG: //获取宠物蛋提示
//					ShortCutHintManager.show(-1, 2110, itemData, function(obj:Object):void
//					{
//						itemData.useObj();
//					}, itemData.name);
//					break;
//				case ItemConst.TYPE_ITEM_HORSE: //获取骑宠蛋提示
//					ShortCutHintManager.show(-1, 2111, itemData, function(obj:Object):void
//					{
//						itemData.useObj();
//					}, itemData.name);
//					break;
//				case ItemConst.TYPE_VIP: //获取VIP卡提示
//					switch (itemData.templateId)
//					{
//						case ItemSpecailConst.ITEM_TEMPLATE_VIP_1:
//							if (!VipDataManager.instance.getSurportData(VIPConst.VIP_LEVEL_1).enabled)
//							{
//								ShortCutHintManager.show(-1, 2117, itemData, function(obj:Object):void
//								{
//									itemData.useObj();
//								}, itemData.name);
//							}
//							break;
//						case ItemSpecailConst.ITEM_TEMPLATE_VIP_2:
//							if (!VipDataManager.instance.getSurportData(VIPConst.VIP_LEVEL_2).enabled)
//							{
//								ShortCutHintManager.show(-1, 2122, itemData, function(obj:Object):void
//								{
//									itemData.useObj();
//								}, itemData.name);
//							}
//							break;
//						case ItemSpecailConst.ITEM_TEMPLATE_VIP_3:
//							if (!VipDataManager.instance.getSurportData(VIPConst.VIP_LEVEL_3).enabled)
//							{
//								ShortCutHintManager.show(-1, 2123, itemData, function(obj:Object):void
//								{
//									itemData.useObj();
//								}, itemData.name);
//							}
//							break;
//						case ItemSpecailConst.ITEM_TEMPLATE_VIP_SPEACIAL:
//							if (itemData.templateId == ItemSpecailConst.ITEM_TEMPLATE_VIP_SPEACIAL
//								&& !VipDataManager.instance.getSurportData(VIPConst.VIP_LEVEL_SPECIAL).enabled)
//							{
//								ShortCutHintManager.show(-1, 2124, itemData, function(obj:Object):void
//								{
//									itemData.useObj();
//								}, itemData.name);
//							}
//							break;
//					}
//					break;
//				case ItemConst.TYPE_ITEM_PET:
//					ShortCutHintManager.show(-1, 2125, itemData, function(obj:Object):void
//					{
//						if (GameInstance.mainCharData.petIsOpen)
//							GameInstance.signal.pet.open.dispatch(0, PetPanel.FEED_PANEL_INDEX);
//						else
//							FunctionDescriptionPanel.show(FunDesManager.getInfoByModule(FunctionSwitchManager.PETSWITCH));
//					}, itemData.name);
//					break;
//				default:
//					if (itemData.templateId == ItemSpecailConst.ITEM__EXP_5_TIMES || itemData.templateId == ItemSpecailConst.ITEM_EXP_2_TIMES)
//					{
//						ShortCutHintManager.show(-1, 2126, itemData, function(obj:Object):void
//						{
//							itemData.useObj();
//						}, itemData.name)
//					}
//					break;
//			}
		}

		private function onResize(event:SlotItemManagerEvent):void
		{
			var type:int = int(event.data[0]);
			if (type == ItemConst.CONTAINER_BACKPACK)
			{
				dispatchEvent(new ItemEvent(ItemEvent.RESIZE_BAG, event.data[1], -1));
			}
		}

		private function onBagSizeChange(event:Event):void
		{
			_slotManager.resetSize(ItemConst.CONTAINER_BACKPACK, GameInstance.mainCharData.bagSize);
		}

		public function getBagSize():int
		{
			return _slotManager.getSlotList(ItemConst.CONTAINER_BACKPACK).length;
		}

		/*************************将Slot集合的事件转换为背包集合的增删改事件****************************/
		/**
		 *
		 * @param event
		 *
		 */
		private function onDicAdd(event:SlotDictionaryEvent):void
		{
			var item:ISlotItem = ISlotItem(event.data);
			if (item.slot < 0)
				return;
			if (SlotItemManager.getSlotType(item.slot) == ItemConst.CONTAINER_BACKPACK)
			{
				//slot标示是在背包中的话，抛出事件
				item.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onItemPropertyChange);
				processAdd(item as ItemData, item.slot);
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onDicRemove(event:SlotDictionaryEvent):void
		{
			var item:ISlotItem = ISlotItem(event.data);
			if (SlotItemManager.getSlotType(item.slot) == ItemConst.CONTAINER_BACKPACK)
			{
				//slot标示是在背包中的话，抛出事件
				item.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onItemPropertyChange);
				processRemove(item as ItemData, item.slot);
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onItemPropertyChange(event:PropertyChangeEvent):void
		{
			switch (event.kind)
			{
				case PropertyChangeEventKind.UPDATE:
					this.dispatchEvent(new ItemEvent(ItemEvent.UPDATE, event, -1));
					break;
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onDicSlotChange(event:SlotDictionaryEvent):void
		{
			var item:ISlotItem = ISlotItem(event.data[0]);
			var oldSlot:int = int(event.data[1]);
			var newSlot:int = int(event.data[2]);
			var remove:Boolean = false;
			var add:Boolean = false;
			if (oldSlot >= 0 && SlotItemManager.getSlotType(oldSlot) == ItemConst.CONTAINER_BACKPACK)
			{
				remove = true;
			}
			if (newSlot >= 0 && SlotItemManager.getSlotType(newSlot) == ItemConst.CONTAINER_BACKPACK)
			{
				add = true;
			}
			if (remove && add)
			{
				processMove(item as ItemData, oldSlot, newSlot);
			}
			else if (remove)
			{
				item.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onItemPropertyChange);
				processRemove(item as ItemData, oldSlot);
			}
			else if (add)
			{
				item.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onItemPropertyChange);
				processAdd(item as ItemData, newSlot);
			}
		}

		/**
		 * 抛出ItemEvent.MOVE事件并更新筛选容器
		 * @param item
		 * @param oldSlot
		 * @param newSlot
		 *
		 */
		private function processMove(item:ItemData, oldSlot:int, newSlot:int):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.MOVE, [item, oldSlot, newSlot], -1));
			if (_filtedItemList) //同时变更筛选列表
			{
//				sortFiltedItem();
				_filtedItemList.refresh(); //重新排序
			}
		}

		/**
		 * 抛出ItemEvent.REMOVE事件并更新筛选容器
		 * @param item
		 *
		 */
		private function processRemove(item:ItemData, slot:int):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.REMOVE, item, TSlotDictionary.getPos(slot)));
			if (_filtedItemList && filterHandler(item)) //同时变更筛选列表
			{
				_filtedItemList.refresh(); //重新排序
				_filtedItemList.removeItem(item);
			}
		}

		private function processAdd(item:ItemData, slot:int):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.ADD, item, TSlotDictionary.getPos(slot)));
			if (_filtedItemList && filterHandler(item)) //同时变更筛选列表
			{
				_filtedItemList.refresh(); //重新排序
				_filtedItemList.addItem(item);
			}
		}

		/**
		 * 根据分类type（见ItemConst.FILTER_TYPE_XXX）执行筛选
		 * @param type
		 * @return
		 *
		 */
		public function processFilter(type:int):TArrayCollection
		{
			if (_filterType == type)
			{
				return _filtedItemList;
			}
			_filterType = type;
			if (type == ItemConst.FILTER_TYPE_NONE)
			{
				_filtedItemList = null;
			}
			else
			{
				_filtedItemList = new TArrayCollection();
				var bagItemList:TArrayCollection = getBagItemList();
				for (var i:int = 0; i < bagItemList.length; ++i)
				{
					var item:ItemData = bagItemList.getItemAt(i) as ItemData;
					if (filterHandler(item))
					{
						_filtedItemList.addItem(item);
					}
				}
				sortFiltedItem();
			}
			return _filtedItemList;
		}

		private function sortFiltedItem():void
		{
			if (!_filtedItemList.sort)
			{
				var sort:Sort = new Sort();
				sort.fields = [new SortField("slot")];
				_filtedItemList.sort = sort;
			}
			_filtedItemList.refresh();
		}

		private function filterHandler(item:ItemData):Boolean
		{
			if (item && item.itemTemplate.sortId == _filterType)
			{
				return true;
			}
			return false;
		}

		/**
		 * 释放筛选数据
		 *
		 */
		public function cleanFilter():void
		{
			_filterType = ItemConst.FILTER_TYPE_NONE;
			_filtedItemList = null;
		}

		/**
		 * 获取背包物品列表
		 * @return
		 *
		 */
		public function getBagItemList():TArrayCollection
		{
			return TArrayCollection(_slotManager.getSlotList(ItemConst.CONTAINER_BACKPACK));
		}

		/**
		 * 查询背包中指定类型的物品列表
		 * @param type 物品类型
		 * @param subType 物品子类型
		 * @return 物品列表
		 *
		 */
		public function getItemList(type:int, subType:int = -1):Array
		{
			return _slotManager.getItemListByType(ItemConst.CONTAINER_BACKPACK, type, subType);
		}

		/**
		 * 查询容器中指定类型的物品列表, 获取其中第一个返回
		 * @param type 物品类型
		 * @param subType 物品子类型
		 * @return
		 *
		 */
		public function getFirstItemByType(type:int, subType:int = -1):ItemData
		{
			return _slotManager.getFirstItemByType(ItemConst.CONTAINER_BACKPACK, type, subType) as ItemData;
		}

		/**
		 * 获取背包中指定templateId的第一个物品
		 * @param itemId
		 * @return
		 *
		 */
		public function getFirstItemByTemplateId(templateId:int):ItemData
		{
			return _slotManager.getFirstItemByTemplateId(ItemConst.CONTAINER_BACKPACK, templateId) as ItemData;
		}

		/**
		 * 获取背包中指定templateId的列表
		 * @param itemId
		 * @return
		 *
		 */
		public function getItemListByTemplateId(templateId:int):Array
		{
			return _slotManager.getItemListByTemplateId(ItemConst.CONTAINER_BACKPACK, templateId);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getEmptyCellNum():int
		{
			return SlotItemManager.instance.getEmptyCellNum(ItemConst.CONTAINER_BACKPACK);
		}

		/**
		 * 通过guId获得某类型容器中物品对象
		 * @param guid
		 * @return
		 *
		 */
		public function getItem(guid:int):ItemData
		{
			return SlotItemManager.instance.getItem(guid) as ItemData;
		}

		/**
		 * 筛选后列表
		 * @return
		 *
		 */
		public function get filtedItemList():TArrayCollection
		{
			return _filtedItemList;
		}

		/*******************************************物品变更事件处理**********************************************/
//		private var _godProtectItemBox:FloatItemBox;
		/**
		 * 物品添加
		 * @param event
		 *
		 */
		private function onItemAdd(event:ItemEvent):void
		{
//			var itemData:ItemData = ItemData(event.data);
//			if (itemData.templateId == ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT)
//			{
//				//神佑物品处理
//				if (!_godProtectItemBox)
//				{
//					_godProtectItemBox = new FloatItemBox(TRslManager.getInstance(UISkinLib.itemMoveBoxSkin), null, {right: 250, bottom: 180});
//					_godProtectItemBox.pickUpEnabled = false;
//					_godProtectItemBox.data = ItemData(event.data);
//					GameInstance.ui.mainUI.addChild(_godProtectItemBox);
//				}
//				var shortCutData:ShortCutData = ShortCutManager.instance.getFirstShortCutByTemplateId(ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT);
//				if (!shortCutData)
//				{
//					var index:int = ShortCutManager.instance.getFirstEmptyIndex(9);
//					ShortCutHelper.setShortCut(index, ItemData(event.data));
//				}
//			}
//			//背包快满检查
//			var bagEmptyCellNum:int = getEmptyCellNum();
//			if (bagEmptyCellNum == 0)
//			{
//				ShortCutHintManager.show(ShortCutHintConst.ID_BAG_LOW, 2120, null, onBagFullAlertEnsure);
//			}
//			else if (bagEmptyCellNum < ItemConst.ITEM_NUM_ALERT_LIMIT)
//			{
//				ShortCutHintManager.show(ShortCutHintConst.ID_BAG_LOW, 2119, null, onBagFullAlertEnsure);
//			}
		}

		private function onBagFullAlertEnsure(data:Object):void
		{
			_slotManager.tidyUp(ItemConst.CONTAINER_BACKPACK);
		}

		/**
		 * 物品移除
		 * @param event
		 *
		 */
		private function onItemRemove(event:ItemEvent):void
		{
//			if (ItemData(event.data).templateId == ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT)
//			{
//				//神佑物品处理
//				if (_godProtectItemBox && _godProtectItemBox.parent)
//				{
//					GameInstance.ui.mainUI.removeChild(_godProtectItemBox);
//					_godProtectItemBox = null;
//				}
//				var shortCutData:ShortCutData = ShortCutManager.instance.getFirstShortCutByTemplateId(ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT);
//				if (shortCutData)
//				{
//					ShortCutHelper.setShortCut(shortCutData.slot, null);
//				}
//			}
		}
	}
}
