package tempest.ui.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import tempest.ui.components.IList;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.SlotDictionaryEvent;
	import tempest.ui.events.SlotEvent;
	import tempest.ui.interfaces.ISlotData;

	/**
	 * ISlotData字典，可以任意增删改
	 * 同时维护以ISlotData.slot为索引的slotCollection
	 * @author linxun
	 *
	 */
	public class TSlotDictionary extends Proxy implements IEventDispatcher
	{
//		private var _slotCollection:IList;
		private var _dic:Dictionary;
		private var _eventDispatcher:EventDispatcher;
		/***************************************************************************/
		private var _slotCollectionDataList:Array = [];

		//[{name:listname, offset:0, list:slotCollection},{}]
		/**
		 *
		 * @param slotCollectionDataList 多个以slot为索引的容器
		 * 格式：[{name:listname, offset:0, list:slotCollection}]
		 * 参数含义和addSlotCollection方法相同
		 * @param weakKeys
		 *
		 */
		public function TSlotDictionary(slotCollectionDataList:Array = null, weakKeys:Boolean = false)
		{
			super();
			_eventDispatcher = new EventDispatcher(this);
			_dic = new Dictionary(weakKeys);
			if (slotCollectionDataList)
			{
				for each (var sData:Object in slotCollectionDataList)
				{
					addSlotCollection(sData.containerType, sData.list);
				}
			}
		}

		/**
		 * 添加一个由slot索引的列表，由该类维护其增删改
		 * @param name 列表名称（用于获取列表并绑定）
		 * @param containerType 列表类型
		 * @param slotCollection slot为索引的列表数据，必须定长
		 *
		 */
		public function addSlotCollection(containerType:int, list:IList):void
		{
			_slotCollectionDataList.push(new SlotListData(containerType, list));
		}

		/**
		 * 获取slot类型,并返回对应集合数据
		 * @param slot
		 * @return
		 *
		 */
		private function getCollctionData(slot:int):SlotListData
		{
			var type:int = getSlotType(slot);
			for each (var slotListData:SlotListData in _slotCollectionDataList)
			{
				if (slotListData.containerType == type)
				{
					//找到slot对应的集合
					return slotListData;
				}
			}
			throw new Error("slotType:" + type + " 不是合法的集合类型");
		}

		/**
		 * 获取格子对应集合类型
		 * @param slot
		 * @return
		 *
		 */
		public static function getSlotType(slot:int):int
		{
			return slot >> 16 & 0xFFFF;
		}

		/**
		 * 根据slot获得以0开头的pos
		 * @param slot
		 * @return
		 *
		 */
		public static function getPos(slot:int):int
		{
			return slot & 0xFFFF;
		}

		/**
		 * 构造slot
		 * @param type
		 * @param pos
		 * @return
		 *
		 */
		public static function makeSlot(type:int, pos:int):int
		{
			return type << 16 | pos;
		}

		/**
		 * 将slot对应根据slot的类型,设置到对应slotCollection中
		 * @param slot 在ISlotData中存储的slot值
		 * @param value ISlotData
		 *
		 */
		private function setSlotData(slot:int, value:ISlotData):void
		{
			getCollctionData(slot).list[getPos(slot)] = value;
		}


		override flash_proxy function setProperty(name:*, value:*):void
		{
			if (_dic.hasOwnProperty(name))
			{
				if (value == null)
				{
					delete this[name];
					return;
				}

				//修改
				var newData:ISlotData = value as ISlotData;
				var oldData:ISlotData = _dic[name] as ISlotData;
				if (oldData)
				{
					if (newData == oldData && newData.slot == oldData.slot)
						return;
					if (oldData.slot >= 0)
						setSlotData(oldData.slot, null);
				}
				setSlotData(newData.slot, newData);
				if (newData == oldData)
				{
					//数据相同，只是更换slot
					dispatchEvent(new SlotDictionaryEvent(SlotDictionaryEvent.SLOT_CHANGE, [newData, oldData.slot, newData.slot]));
				}
				else
				{
					//数据不同，删除旧的添加新的
					dispatchEvent(new SlotDictionaryEvent(SlotDictionaryEvent.REMOVE, oldData));
					dispatchEvent(new SlotDictionaryEvent(SlotDictionaryEvent.ADD, newData));
				}
			}
			else
			{
				//添加
				var data:ISlotData = value as ISlotData;
				if (data)
				{
					data.addEventListener(SlotEvent.SLOT_CHANGE, onSlotChange);
					data.addEventListener(SlotEvent.SLOT_REMOVE, onSlotRemove);
					if (data.slot >= 0)
						setSlotData(data.slot, data);
					dispatchEvent(new SlotDictionaryEvent(SlotDictionaryEvent.ADD, data));
				}
			}
			_dic[name] = value;
		}

		override flash_proxy function getProperty(name:*):*
		{
			return _dic[name];
		}

		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var oldData:ISlotData = _dic[name] as ISlotData;
			if (!oldData)
				throw new Error("找不到该物品guid:" + name);
			oldData.removeEventListener(SlotEvent.SLOT_CHANGE, onSlotChange);
			oldData.removeEventListener(SlotEvent.SLOT_REMOVE, onSlotRemove);
			setSlotData(oldData.slot, null);
			var ret:Boolean = delete _dic[name];
			dispatchEvent(new SlotDictionaryEvent(SlotDictionaryEvent.REMOVE, oldData));
			return ret;
		}

		private function onCollectionChange(event:CollectionEvent):void
		{
			if (event.kind == CollectionEventKind.REFRESH)
			{
				var collection:IList = event.currentTarget as IList;
				//列表排序后刷新触发, 重新设置slot
				for (var i:int = 0; i < collection.length; ++i)
				{
					var sData:ISlotData = collection[i] as ISlotData;
					if (sData.slot != i)
					{
						sData.removeEventListener(SlotEvent.SLOT_CHANGE, onSlotChange);
						sData.removeEventListener(SlotEvent.SLOT_REMOVE, onSlotRemove);
						sData.slot = i;
						sData.addEventListener(SlotEvent.SLOT_CHANGE, onSlotChange);
						sData.addEventListener(SlotEvent.SLOT_REMOVE, onSlotRemove);
					}
				}
			}
		}

		private function onSlotChange(event:SlotEvent):void
		{
			var oldSlot:int = event.oldData as int;
			var newSlot:int = event.newData as int;
			if (oldSlot >= 0)
			{
				var oldSlotData:ISlotData = getSlotItem(oldSlot); //找出一个slot和oldSlot相同的物品，顶替原来的位置
				setSlotData(oldSlot, oldSlotData);
			}
			setSlotData(newSlot, event.currentTarget as ISlotData);
			dispatchEvent(new SlotDictionaryEvent(SlotDictionaryEvent.SLOT_CHANGE, [event.currentTarget, oldSlot, newSlot]));
		}

		private function onSlotRemove(event:SlotEvent):void
		{
			var guid:uint = event.oldData as uint;
			delete this[guid];
		}

		private function getSlotItem(slot:int):ISlotData
		{
			for each (var slotData:ISlotData in _dic)
			{
				if (slotData.slot == slot)
					return slotData;
			}
			return null;
		}

		public function getSlotItem2(slot:int):ISlotData
		{
			return getCollctionData(slot).list[getPos(slot)];
		}

		/**
		 * 仅用于遍历查找，不能直接修改引用内容
		 * @return
		 *
		 */
		public function get dic():Dictionary
		{
			return _dic;
		}

		public function getSlotCollection(type:int):IList
		{
			for each (var sListData:SlotListData in _slotCollectionDataList)
			{
				if (sListData.containerType == type)
					return sListData.list;
			}
			throw new Error("slotType:" + type + " 不是合法的集合类型");
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}
/***************************************************************************/
import tempest.ui.components.IList;

class SlotListData
{
	public var containerType:int;
	public var list:IList;

	public function SlotListData(containerType:int, list:IList)
	{
		this.containerType = containerType;
		this.list = list;
	}

	public function get max():int
	{
		return list.length - 1;
	}
}
