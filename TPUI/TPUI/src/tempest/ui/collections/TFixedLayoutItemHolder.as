package tempest.ui.collections
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.core.IFactory;
	import mx.events.PropertyChangeEvent;

	import tempest.ui.components.IList;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.core.ITListItemRender;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.DataChangeEvent;
	import tempest.ui.events.ListEvent;

	public class TFixedLayoutItemHolder extends EventDispatcher
	{
		protected var _itemRenderArray:Array;
		protected var _items:Array;
		protected var _itemRenderClass:*;
		protected var _selectedIndex:int = -1;
		protected var _itemName:String;
		protected var _disableDropDownChange:Boolean;
		private var _collection:IList;
		private var _selectable:Boolean = true;
		protected var _itemProxyContainerArray:Array;

		public function TFixedLayoutItemHolder(itemProxyContainer:DisplayObjectContainer, listItemRenderClass:* = null, itemName:String = null, items:Array = null, disableDropDownChange:Boolean = true, itemRenderCreateHandler:Function =
			null)
		{
			_itemName = itemName;
			_disableDropDownChange = disableDropDownChange;
			_items = items ? items /*.slice()*/ : [];
			_itemRenderClass = listItemRenderClass;
			if (itemRenderCreateHandler != null)
				this.addEventListener(ListEvent.ITEM_RENDER_CREATE, itemRenderCreateHandler);
			super(this);
			addItemListProxy(itemProxyContainer);
			reflash();
		}

		private function updateList():void
		{
			for (var i:int = 0; i < _itemRenderArray.length; i++)
			{
				var itemRender:ITListItemRender = ITListItemRender(_itemRenderArray[i]);
				itemRender.removeEventListener(Event.SELECT, onSelect);
				itemRender.selected = (_selectedIndex == i);
				itemRender.addEventListener(Event.SELECT, onSelect);
			}
		}

		public function addItemListProxy(itemProxyContainer:DisplayObjectContainer):void
		{
			if (!_itemRenderArray)
				_itemRenderArray = [];

			var oldItemIndex:int = _itemRenderArray.length;
			var itemIndex:int = oldItemIndex;
			var srcIndex:int = 0;
			while (true)
			{
				var listItem:ITListItemRender;
				if (_itemName)
				{
					//使用名称方式获取资源
					if (!itemProxyContainer.hasOwnProperty(_itemName + srcIndex.toString()) || itemProxyContainer[_itemName + srcIndex.toString()] == null)
					{
						break;
					}
					listItem = createRender(_itemRenderClass, itemProxyContainer[_itemName + srcIndex.toString()]);
				}
				else
				{
					//使用子集方式获取资源
					if (srcIndex >= itemProxyContainer.numChildren)
					{
						break;
					}
					listItem = createRender(_itemRenderClass, itemProxyContainer.getChildAt(srcIndex));
				}

				listItem.selectable = _selectable;
				listItem.index = itemIndex;
				_itemRenderArray.push(listItem);

				++itemIndex;
				++srcIndex;
			}
		}

		public function reflash():void
		{
			reflashPart(0, _itemRenderArray.length - 1);
		}

		private function reflashPart(start:int, end:int):void
		{
			for (var i:int = start; i <= end; i++)
			{
				var element:ITListItemRender = _itemRenderArray[i] as ITListItemRender;
				element.data = _items[i];
			}
		}

		private function createRender(_itemRenderClass:*, renderProxy:*):ITListItemRender
		{
			var listItem:ITListItemRender;
			if (_itemRenderClass is IFactory)
			{
				if (_itemRenderClass is IProxyFactory)
				{
					IProxyFactory(_itemRenderClass).proxy = renderProxy;
				}
				listItem = IFactory(_itemRenderClass).newInstance();
			}
			else
			{
				listItem = new _itemRenderClass(renderProxy, null);
			}
			if (!_disableDropDownChange)
			{
				listItem.addEventListener(DataChangeEvent.DRAG_DATA_CHANGE, onDragDataChange);
			}
			listItem.addEventListener(Event.SELECT, onSelect);
			listItem.addEventListener("unSelect", onUnSelect);

			dispatchEvent(new ListEvent(ListEvent.ITEM_RENDER_CREATE, listItem));
			return listItem;
		}

		public function setItemAt(value:* = null, index:int = 0):void
		{
			if (index >= _itemRenderArray.length)
			{
				throw new Error("Index out of range Error");
			}
			(_itemRenderArray[index] as ITListItemRender).data = value;
			_items[index] = value;
		}

		public function getItemRender(index:int):ITListItemRender
		{
			return _itemRenderArray[index] as ITListItemRender;
		}

		public function getItemRenderByData(data:Object):ITListItemRender
		{
			for each (var render:ITListItemRender in _itemRenderArray)
			{
				if (render.data == data)
				{
					return render;
				}
			}
			return null;
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		protected function onDragDataChange(event:DataChangeEvent):void
		{
			_items[(event.currentTarget as ITListItemRender).index] = event.newData;
		}

		protected function onSelect(event:Event):void
		{
			for (var i:int = 0; i < _itemRenderArray.length; i++)
			{
				if (_itemRenderArray[i] == event.currentTarget)
				{
					this.selectedIndex = i;
				}
			}

//			dispatchEvent(new Event(Event.SELECT));
		}

		protected function onUnSelect(event:Event):void
		{
			selectedIndex = -1;
			dispatchEvent(new Event(Event.SELECT));
		}

		protected function collectionChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.REPLACE:
					this.setItemAt((event.items[0] as PropertyChangeEvent).newValue, event.location);
					break;
				case CollectionEventKind.REFRESH:
					this.items = _collection ? _collection.toArray() : null;
					break;
				case CollectionEventKind.UPDATE:
//					this.setItemAt((event.items[0] as PropertyChangeEvent).target, event.location);
					this._items[event.location] = (event.items[0] as PropertyChangeEvent).target;
					break;
				case CollectionEventKind.RESET:
					this.items = _collection ? _collection.toArray() : null;
					break;
				case CollectionEventKind.ADD:
					for (var j:int = _items.length < _itemRenderArray.length ? _items.length - 1 : _itemRenderArray.length - 2; j >= event.location; j--)
					{
						this.setItemAt(items[j], j + 1);
					}
					this.setItemAt(event.items[0], event.location);
					break;
				case CollectionEventKind.REMOVE:
					this.setItemAt(null, event.location);
					for (var i:int = event.location; i < _items.length - 1; i++)
					{
						this.setItemAt(items[i + 1], i);
					}
					this.setItemAt(null, i);
					break;
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set selectedIndex(value:int):void
		{
			if (value >= 0 && value < _itemRenderArray.length)
			{
				_selectedIndex = value;
//				if (selectedItem == null)
//					_selectedIndex = -1;
			}
			else
			{
				_selectedIndex = -1;
			}
			updateList();
			dispatchEvent(new Event(Event.SELECT));
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			selectedIndex = index;
		}

		public function get selectedItem():Object
		{
			if (_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}

		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			var newItems:Array = value ? value /*.slice()*/ : [];
			//如果不足长度，补足
			while (newItems.length < _items.length)
			{
				newItems.push(null);
			}
			_items = newItems;
			reflash();
		}

		public function get items():Array
		{
			return _items;
		}

		public function set dataProvider(value:IList):void
		{
			if (_collection == value)
			{
				return;
			}

			if (_collection)
			{
				_collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			_collection = value;
			this.items = _collection ? _collection.toArray() : null;
			if (_collection)
			{
				_collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
		}

		public function get length():int
		{
			return _itemRenderArray.length;
		}

		public function get dataProvider():IList
		{
			return _collection;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			for (var i:int = 0; i < _itemRenderArray.length; i++)
			{
				var element:ITListItemRender = _itemRenderArray[i] as ITListItemRender;
				element.selectable = value;
			}
		}

		public function get itemRenders():Array
		{
			return _itemRenderArray;
		}

		/**
		 * 枚举所有itemRender并执行callBack回调
		 * 格式：function(render:ITListItemRender):void{}
		 * @param callBack
		 *
		 */
		public function foreach(callBack:Function):void
		{
			for (var i:int = 0; i < _itemRenderArray.length; i++)
			{
				var element:ITListItemRender = _itemRenderArray[i] as ITListItemRender;
				callBack(element);
			}
		}
	}
}
