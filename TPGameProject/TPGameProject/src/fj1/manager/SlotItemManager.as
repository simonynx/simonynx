package fj1.manager
{
	import com.adobe.utils.ArrayUtil;

	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.data.interfaces.IDataObject;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.events.item.SlotItemManagerEvent;
	import fj1.common.helper.SortHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.baseConfig.BaseConfigManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.salesroom.SalesroomConfigManager;
	import fj1.common.res.salesroom.vo.SaleItemConfig;
	import fj1.common.staticdata.BaseConfigKeys;
	import fj1.common.staticdata.HintConst;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.SalesroomConst;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.collections.Sort;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.collections.TSlotDictionary;
	import tempest.ui.components.IList;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.SlotDictionaryEvent;
	import tempest.ui.events.SlotEvent;

	/**
	 * 总物品管理
	 * 背包，仓库，身上的装备都用独立的TArrayCollection，并注册到_itemDic中
	 * 类中封装一些常用的物品集合操作函数
	 * @author linxun
	 *
	 */
	public class SlotItemManager extends EventDispatcher
	{
		private static const log:ILogger = TLog.getLogger(SlotItemManager);
		private static var _instance:SlotItemManager = null;
		private var _itemDic:TSlotDictionary;
		private static var _sortCondition:Array = ["cmpId", "quality", "request_userlev", "id"];
		private var _tidyUpTimeArray:Array; //整理时间记录
		private var _tidyUpCDStartSignals:Array; //整理CD开始事件

		//signals
		public function SlotItemManager()
		{
			if (_instance != null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
			_tidyUpTimeArray = [];
			_tidyUpCDStartSignals = [];
			_itemDic = new TSlotDictionary();
			_itemDic.addSlotCollection(ItemConst.CONTAINER_BACKPACK, new TArrayCollection());
			_itemDic.addSlotCollection(ItemConst.CONTAINER_CARD, new TArrayCollection(new Array(ItemConst.CARD_POS_NUM)));
			_itemDic.addSlotCollection(ItemConst.CONTAINER_DEPOT, new TArrayCollection(new Array(ItemConst.DEPOT_INIT_SIZE)));
		}

		public static function get instance():SlotItemManager
		{
			if (_instance == null)
				new SlotItemManager();
			return _instance;
		}

		/**
		 *
		 * @param containerType
		 * @param list
		 *
		 */
		public function addSlotCollection(containerType:int, list:IList):void
		{
			_itemDic.addSlotCollection(containerType, list);
		}

		/**
		 * 通过guId获得某类型容器中物品对象
		 * @param guId
		 * @return
		 *
		 */
		public function getItem(guId:uint):IDataObject
		{
			return _itemDic[guId] as IDataObject;
		}

		/**
		 * 获取空格数
		 * @return
		 *
		 */
		public function getEmptyCellNum(type:int):int
		{
			var container:IList = _itemDic.getSlotCollection(type);
			var num:int = 0;
			for (var i:int = 0; i < container.length; i++)
			{
				if (!container[i])
				{
					++num;
				}
			}
			return num;
		}

		/**
		 * 获取某类型容器格子列表
		 * @param type
		 * @return
		 *
		 */
		public function getSlotList(type:int):IList
		{
			return _itemDic.getSlotCollection(type);
		}

		/**
		 *
		 * @param type
		 * @param index
		 * @return
		 *
		 */
		public function getItemByGuid(type:int, guid:uint):IDataObject
		{
			var collection:IList = _itemDic.getSlotCollection(type);
			var len:int = collection.length;
			for (var i:int = 0; i < len; ++i)
			{
				var dataObj:IDataObject = collection.getItemAt(i) as IDataObject;
				if (dataObj && dataObj.guId == guid)
				{
					return dataObj;
				}
			}
			return null;
		}

		/**
		 * 通过索引获得某类型容器中物品对象
		 * @param type 容器类型
		 * @param index 索引（下标）
		 * @return
		 *
		 */
		public function getItemByIndex(type:int, index:int):IDataObject
		{
			var list:IList = _itemDic.getSlotCollection(type);
			if (!list)
			{
				return null;
			}
			if (index >= list.length)
			{
				return null;
			}
			return list.getItemAt(index) as IDataObject;
		}

		/**
		 *
		 * @param guid
		 * @param dataObject
		 *
		 */
		public function setItem(guid:uint, dataObject:IDataObject):void
		{
			if (!dataObject)
				delete _itemDic[guid];
			else
				_itemDic[guid] = dataObject;
		}

		/**
		 *
		 * @param slot
		 *
		 */
		public function getItemBySlot(slot:int):IDataObject
		{
			return _itemDic.getSlotItem2(slot) as IDataObject;
		}

		/**
		 * 尝试整理容器 生成移动包发送服务器
		 * @param type
		 *
		 */
		public function tidyUp(type:int):void
		{
			var nowTime:int = getTimer()
			if (inTidyupCD(type, nowTime))
			{
				MessageManager.instance.addHintById_client(63, "整理冷却中");
				return;
			}
			var slotColloection:TArrayCollection = TArrayCollection(_itemDic.getSlotCollection(type));
			if (!checkLock(slotColloection)) //检查是否有物品被锁定 
			{
				return;
			}
			var collectionCopy:TArrayCollection = new TArrayCollection(copyDataArray(slotColloection.toArray())); //复制副本
			var posChangeList:Array = [];
			//合并
			posChangeList = posChangeList.concat(combineItem(collectionCopy));
			//排序
			var sortChangeList:Array = sortDataList(collectionCopy, slotColloection.toArray(), type);
			posChangeList = posChangeList.concat(sortChangeList);
			//发送整理请求
//			for each (var parmItem:Array in posChangeList)
//			{
//				GameClient.sendItemMove(parmItem[0] as uint, parmItem[1] as uint, parmItem[2] as uint);
//			}
			if (posChangeList.length > 0)
			{
				GameClient.sendTidyup(type, posChangeList);
				_tidyUpTimeArray[type] = nowTime;
				getCDStartSignal(type).dispatch();
			}
		}

		public function getCDStartSignal(type:int):ISignal
		{
			var signal:ISignal = _tidyUpCDStartSignals[type];
			if (!signal)
			{
				signal = new Signal();
				_tidyUpCDStartSignals[type] = signal;
			}
			return signal;
		}

		public function getlastCDTime(type:int, nowTime:int):int
		{
			if (!_tidyUpTimeArray[type])
			{
				return 0;
			}
			var lastTime:int = parseInt(BaseConfigManager.getConfig(BaseConfigKeys.ITEM_TIDYUP_CD)) - (nowTime - _tidyUpTimeArray[type]);
			return lastTime > 0 ? lastTime : 0;
		}

		/**
		 * 检查指定分类是否在整理CD中
		 * @param type
		 * @param nowTime
		 * @return
		 *
		 */
		private function inTidyupCD(type:int, nowTime:int):Boolean
		{
			if (!_tidyUpTimeArray[type])
			{
				return false;
			}
			return nowTime - _tidyUpTimeArray[type] < parseInt(BaseConfigManager.getConfig(BaseConfigKeys.ITEM_TIDYUP_CD));
		}

		/**
		 * 更新背包数据
		 * @param containerType
		 * @param resultArray
		 *
		 */
		public function update(type:int, resultArray:Array):void
		{
			var slotColloection:TArrayCollection = TArrayCollection(_itemDic.getSlotCollection(type));
			var collectionCopy:Array = slotColloection.toArray();
			var collectionCopyDic:Dictionary = new Dictionary();
			//清空容器数据, 并将对应物品存入Dictionary方便访问
			var itemData:ISlotItem;
			for each (itemData in collectionCopy)
			{
				if (itemData)
				{
					slotColloection[itemData.guId] = null;
					collectionCopyDic[itemData.guId] = itemData;
				}
			}
			//设置新的数据到容器
			for each (var result:Object in resultArray)
			{
				itemData = collectionCopyDic[result.guid];
				if (itemData)
				{
					itemData.slot = result.pos;
					itemData.num = result.stackCnt;
					slotColloection[itemData.guId] = itemData;
				}
			}
		}

		/**
		 * 检查是否有物品被锁定
		 * @param collection
		 * @return
		 *
		 */
		private function checkLock(collection:TArrayCollection):Boolean
		{
			var itemData:ISlotItem;
			for each (itemData in collection)
			{
				if (!itemData)
					continue;
				if (itemData.locked)
				{
					MessageManager.instance.addHintById_client(35, "物品被锁定，无法整理背包"); //物品被锁定，无法整理背包
					return false;
				}
			}
			return true;
		}

		/**
		 * 合并
		 * @return
		 *
		 */
		private function combineItem(collectionCopy:TArrayCollection):Array
		{
			var posChangeList:Array = [];
			for (var i:int = 0; i < collectionCopy.length; ++i)
			{
				var item:ISlotItem = collectionCopy.getItemAt(i) as ISlotItem;
				if (!item)
				{
					continue;
				}
				for (var targetIndex:int = i + 1; targetIndex < collectionCopy.length; ++targetIndex)
				{
					var targetItem:ISlotItem = collectionCopy.getItemAt(targetIndex) as ISlotItem;
					if (item.canCombine(targetItem))
					{
						//找到可以合并的物品, 执行合并
						if (targetItem.num + item.num > item.max_stack)
						{
							targetItem.num -= targetItem.max_stack - item.num;
							item.num = targetItem.max_stack;
							posChangeList.push([targetItem.guId, targetItem.slot, item.slot]); //记录移动
							break; //已经满，结束当前合并
						}
						else
						{
							item.num += targetItem.num;
							posChangeList.push([targetItem.guId, targetItem.slot, item.slot]); //记录移动
							collectionCopy.setItemAt(null, targetIndex);
						}
					}
				}
			}
			return posChangeList;
		}

		/**
		 * 排序
		 * @return
		 *
		 */
		private function sortDataList(collectionCopy:TArrayCollection, collection:Array, collectionType:int):Array
		{
			SortHelper.spSort(collectionCopy, cmpHandler);
			var posChangeList:Array = [];
			//组包
			for (var i:int = 0; i < collectionCopy.length; ++i)
			{
				var sortedData:ISlotItem = collectionCopy[i] as ISlotItem;
				if (!sortedData)
					continue;
				if (!collection[i] || sortedData.guId != (collection[i] as ISlotItem).guId)
				{
					for (var j:int = i + 1; j < collection.length; j++)
					{
						var swapTarget:ISlotItem = collection[j] as ISlotItem;
						if (!swapTarget)
							continue;
						if (sortedData.guId == (swapTarget as ISlotItem).guId)
						{
							posChangeList.push([swapTarget.guId, j | (collectionType << 8), i | (collectionType << 8)]);
							//互换
							var swapData:ISlotItem = collection[i];
							collection[i] = swapTarget;
							collection[j] = swapData;
							break;
						}
					}
				}
			}
			return posChangeList;
		}

		/**
		 * objRight > objLeft 时返回1
		 * @param objLeft
		 * @param objRight
		 * @param fields
		 * @return
		 *
		 */
		public static function cmpHandler(objLeft:ISlotItem, objRight:ISlotItem, fields:Array = null):int
		{
			if (!objLeft && !objRight)
				return 0;
			else if (!objRight)
				return -1;
			else if (!objLeft)
				return 1;
			for each (var propName:String in _sortCondition)
			{
				var decent:Boolean = false;
				var valueLeft:int;
				var valueRight:int;
				if (propName == "id")
				{
					decent = true; //Id使用小到大排列
				}
				valueLeft = objLeft.getCmpValue(propName);
				valueRight = objRight.getCmpValue(propName);
				if (valueLeft > valueRight)
					return decent ? 1 : -1;
				if (valueLeft < valueRight)
					return decent ? -1 : 1;
				else
				{
					continue;
				}
			}
			return 0;
		}

		/**
		 * 添加物品
		 * @param equip
		 *
		 */
		public function Add(item:ISlotItem):void
		{
			_itemDic[item.guId] = item;
		}

		/**
		 * 查找第一个相同templateId的物品
		 * @param templateId
		 * @return
		 *
		 */
		public function getFirstItemByTemplateId(typeId:int, templateId:int):ISlotItem
		{
			var list:TArrayCollection = TArrayCollection(_itemDic.getSlotCollection(typeId));
			for each (var item:ISlotItem in list)
			{
				if (item && item.templateId == templateId)
					return item;
			}
			return null;
		}

		/**
		 * 查找templateId的物品的列表
		 * @param templateId
		 * @return
		 *
		 */
		public function getItemListByTemplateId(typeId:int, templateId:int):Array
		{
			var list:TArrayCollection = TArrayCollection(_itemDic.getSlotCollection(typeId));
			var ret:Array = [];
			for each (var item:ISlotItem in list)
			{
				if (item && item.templateId == templateId)
				{
					ret.push(item);
				}
			}
			return ret;
		}

		/**
		 * 获取第一个空位slot
		 * @param typeId
		 * @return
		 *
		 */
		public function getFristEmptySlot(typeId:int):int
		{
			var list:TArrayCollection = TArrayCollection(_itemDic.getSlotCollection(typeId));
			for (var i:int = 0; i < list.length; i++)
			{
				var element:ISlotItem = ISlotItem(list[i]);
				if (element == null)
				{
					return TSlotDictionary.makeSlot(typeId, i);
				}
			}
			return -1;
		}

		/**
		 * 重设大小
		 * @param newSize
		 *
		 */
		public function resetSize(typeId:int, newSize:int):void
		{
			var container:TArrayCollection = TArrayCollection(_itemDic.getSlotCollection(typeId));
			var newSrc:Array = new Array(newSize);
			var oldSrc:Array = container.source;
			for (var i:int = 0; i < oldSrc.length; i++)
			{
				newSrc[i] = oldSrc[i];
			}
			container.source = newSrc;
			dispatchEvent(new SlotItemManagerEvent(SlotItemManagerEvent.RESIZE_LIST, [typeId, container.length]));
		}

		/**
		 * 查询容器中指定类型的物品列表
		 * @param containerType 容器类型
		 * @param type 物品类型
		 * @param subType 物品子类型
		 * @return 物品列表
		 *
		 */
		public function getItemListByType(containerType:int, type:int, subType:int = -1):Array
		{
			var bagItemlist:TArrayCollection = TArrayCollection(getSlotList(containerType));
			var ret:Array = [];
			var item:ISlotItem;
			for each (item in bagItemlist)
			{
				if (item && item.type == type && (subType == -1 || item.subtype == subType))
				{
					ret.push(item);
				}
			}
			return ret;
		}

		/**
		 * 查询容器中指定类型的物品列表, 获取其中第一个返回
		 * @param containerType 容器类型
		 * @param type 物品类型
		 * @param subType 物品子类型
		 * @return
		 *
		 */
		public function getFirstItemByType(containerType:int, type:int, subType:int = -1):ISlotItem
		{
			var itemDataArray:Array = getItemListByType(containerType, type, subType);
			if (!itemDataArray || itemDataArray.length == 0)
			{
				return null;
			}
			return itemDataArray[0] as ISlotItem;
		}

		/**
		 *
		 * @param dataArray
		 * @return
		 *
		 */
		public static function copyDataArray(dataArray:Array):Array
		{
			var ret:Array = [];
			for each (var data:ICopyable in dataArray)
			{
				if (data)
					ret.push(data.copy());
				else
					ret.push(null);
			}
			return ret;
		}

		public function getSlotDic():TSlotDictionary
		{
			return _itemDic;
		}

		public static function getSlotType(slot:int):int
		{
			return TSlotDictionary.getSlotType(slot);
		}
	}
}
