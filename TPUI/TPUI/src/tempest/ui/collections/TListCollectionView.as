package tempest.ui.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.events.PropertyChangeEvent;
	import tempest.ui.components.IList;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.ListEvent;

	public class TListCollectionView extends Proxy implements IEventDispatcher, IList
	{
		protected var _list:IList;
		protected var _localItems:Array;
		private var _filterFunction:Function;
		/**
		 *  @private
		 *  Internal event dispatcher.
		 */
		private var eventDispatcher:EventDispatcher;
		/**
		 *  @private
		 *  Used internally for managing disableAutoUpdate and enableAutoUpdate
		 *  calls.  disableAutoUpdate increments the counter, enable decrements.
		 *  When the counter reaches 0 handlePendingUpdates is called.
		 */
		private var autoUpdateCounter:int;
		/**
		 *  @private
		 *  Any update events that occured while autoUpdateCounter > 0
		 *  are stored here.
		 *  This may be null when there are no updates.
		 */
		private var pendingUpdates:Array;
		/**
		 *  When the view is sorted or filtered the <code>localIndex</code> property
		 *  contains an array of items in the sorted or filtered (ordered, reduced)
		 *  view, in the sorted order.
		 *  The ListCollectionView class uses this property to access the items in
		 *  the view.
		 *  The <code>localIndex</code> property should never contain anything
		 *  that is not in the source, but may not have everything in the source.
		 *  This property is <code>null</code> when there is no sort.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var localIndex:Array;
		/**
		 *  @private
		 *  Storage for the sort property.
		 */
		private var _sort:Sort;

		[Bindable("sortChanged")]
		/**
		 *  @inheritDoc
		 *
		 *  @see #refresh()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get sort():Sort
		{
			return _sort;
		}

		/**
		 *  @private
		 */
		public function set sort(s:Sort):void
		{
			_sort = s;
			dispatchEvent(new Event("sortChanged"));
		}

		public function TListCollectionView(list:IList = null)
		{
			super();
			eventDispatcher = new EventDispatcher(this);
			this.list = list;
		}

		public function addItem(item:Object):void
		{
			addItemAt(item, length);
		}

		public function addItemAt(item:Object, index:int):void
		{
			if (index < 0 || !list || index > length)
			{
				throw new RangeError("collections outOfBounds " + index);
			}
			var listIndex:int = index;
			//if we're sorted addItemAt is meaningless, just add to the end
			if (localIndex && sort)
			{
				listIndex = list.length;
			}
			else if (localIndex && filterFunction != null)
			{
				// if end of filtered list, put at end of source list
				if (listIndex == localIndex.length)
					listIndex = list.length;
				// if somewhere in filtered list, find it and insert before it
				// or at beginning
				else
					listIndex = list.getItemIndex(localIndex[index]);
			}
			list.addItemAt(item, listIndex);
		}

		public function get length():int
		{
			if (localIndex)
			{
				return localIndex.length;
			}
			else if (list)
			{
				return list.length;
			}
			else
			{
				return 0;
			}
		}

		public function getItemAt(index:int, prefetch:int = 0):Object
		{
			if (index < 0 || index >= length)
			{
				throw new RangeError("collections outOfBounds: " + index);
			}
			if (localIndex)
			{
				return localIndex[index];
			}
			else if (list)
			{
				return list.getItemAt(index, prefetch);
			}
			return null;
		}

		public function getItemIndex(item:Object):int
		{
			var i:int;
			if (localIndex && sort)
			{
				var startIndex:int = sort.findItem(localIndex, item, Sort.FIRST_INDEX_MODE);
				if (startIndex == -1)
					return -1;
				var endIndex:int = sort.findItem(localIndex, item, Sort.LAST_INDEX_MODE);
				for (i = startIndex; i <= endIndex; i++)
				{
					if (localIndex[i] == item)
						return i;
				}
				return -1;
			}
			else if (localIndex && filterFunction != null)
			{
				var len:int = localIndex.length;
				for (i = 0; i < len; i++)
				{
					if (localIndex[i] == item)
						return i;
				}
				return -1;
			}
			// fallback
			return list.getItemIndex(item);
		}

		/**
		 * 删除某项
		 * @param item
		 * @return
		 *
		 */
		public function removeItem(item:Object):int
		{
			var index:int = getItemIndex(item);
			if (index >= 0)
			{
				removeItemAt(index);
			}
			return index;
		}

		public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void
		{
			list.itemUpdated(item, property, oldValue, newValue);
		}

		public function removeAll():void
		{
			var len:int = length;
			if (len > 0)
			{
				if (localIndex)
				{
					for (var i:int = len - 1; i >= 0; i--)
					{
						removeItemAt(i);
					}
				}
				else
				{
					list.removeAll();
				}
			}
		}

		public function removeItemAt(index:int):Object
		{
			if (index < 0 || index >= length)
			{
				throw new RangeError("collections outOfBounds: " + index);
			}
			var listIndex:int = index;
			if (localIndex)
			{
				var oldItem:Object = localIndex[index];
				listIndex = list.getItemIndex(oldItem);
			}
			return list.removeItemAt(listIndex);
		}

		public function setItemAt(item:Object, index:int):Object
		{
			if (index < 0 || !list || index >= length)
			{
				throw new RangeError("collections outOfBounds: " + index);
			}
			var listIndex:int = index;
			if (localIndex)
			{
				if (index > localIndex.length)
				{
					listIndex = list.length;
				}
				else
				{
					var oldItem:Object = localIndex[index];
					listIndex = list.getItemIndex(oldItem);
				}
			}
			return list.setItemAt(item, listIndex);
		}

		public function toArray():Array
		{
			var ret:Array;
			if (localIndex)
			{
				ret = localIndex.concat();
			}
			else
			{
				ret = list.toArray();
			}
			return ret;
		}

		override flash_proxy function setProperty(name:*, value:*):void
		{
			var index:int = -1;
			var n:Number = parseInt(String(name));
			if (!isNaN(n))
				index = int(n);
			setItemAt(value, index);
		}

		override flash_proxy function getProperty(name:*):*
		{
			var index:int = -1;
			var n:Number = parseInt(String(name));
			if (!isNaN(n))
				index = int(n);
			return getItemAt(index);
		}

		override flash_proxy function nextNameIndex(index:int):int
		{
			if (index < this.length)
				return index + 1;
			else
				return 0;
		}

		override flash_proxy function nextValue(index:int):*
		{
			return getItemAt(index - 1);
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}

		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}

		/**
		 * @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function refresh():Boolean
		{
			return internalRefresh(true);
		}

		private function internalRefresh(dispatch:Boolean):Boolean
		{
//			if (sort || filterFunction != null)
//			{
//				
//			}
//			if (dispatch)
//			{
//				var refreshEvent:CollectionEvent =
//					new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
//				refreshEvent.kind = CollectionEventKind.REFRESH;
//				dispatchEvent(refreshEvent);
//			}
//			return true;
			if (sort || filterFunction != null)
			{
				try
				{
					populateLocalIndex();
				}
				catch (pending:Error)
				{
					return false;
				}
				if (filterFunction != null)
				{
					var tmp:Array = [];
					var len:int = localIndex.length;
					for (var i:int = 0; i < len; i++)
					{
						var item:Object = localIndex[i];
						if (filterFunction(item))
						{
							tmp.push(item);
						}
					}
					localIndex = tmp;
				}
				if (sort)
				{
					sort.sort(localIndex);
					dispatch = true;
				}
			}
			else if (localIndex)
			{
				localIndex = null;
			}
			pendingUpdates = null;
			if (dispatch)
			{
				var refreshEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				refreshEvent.kind = CollectionEventKind.REFRESH;
				dispatchEvent(refreshEvent);
			}
			return true;
		}
		/**
		 *  @private
		 *  Flag that indicates whether a RESET type of collectionChange
		 *  event should be emitted when reset() is called.
		 */
		internal var dispatchResetEvent:Boolean = true;

		private function reset():void
		{
			internalRefresh(false);
			if (dispatchResetEvent)
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				event.kind = CollectionEventKind.RESET;
				dispatchEvent(event);
			}
		}

		/**
		 *  Find the item specified using the Sort find mode constants.
		 *  If there is no sort assigned throw an error.
		 *
		 *  @param values the values object that can be passed into Sort.findItem
		 *  @param mode the mode to pass to Sort.findItem (see Sort)
		 *  @param insertIndex true if it should find the insertion point
		 *  @return the index where the item is located, -1 if not found
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		internal function findItem(values:Object, mode:String, insertIndex:Boolean = false):int
		{
			if (!sort || !localIndex)
			{
				throw new Error("collections Error: itemNotFound");
			}
			if (localIndex.length == 0)
			{
				return insertIndex ? 0 : -1;
			}
			return sort.findItem(localIndex, values, mode, insertIndex);
		}

		/**
		 * Copy all of the data from the source list into the local index.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function populateLocalIndex():void
		{
			if (list)
			{
				localIndex = list.toArray();
			}
			else
			{
				localIndex = [];
			}
		}

		/**
		 * @private
		 */
		private function getFilteredItemIndex(item:Object):int
		{
			//loc is wrong 
			//the intent of this function is to find where this new item 
			//should be in the filtered list, by looking at the main list 
			//for it's neighbor that is also in this filtered list 
			//and trying to insert item after that neighbor in the insert locao filtered list 
			//1st get the position in the original list 
			var loc:int = list.getItemIndex(item);
			//if it's 0 then item must be also the first in the filtered list 
			if (loc == 0)
				return 0;
			// scan backwards for an item that also in the filtered list 
			for (var i:int = loc - 1; i >= 0; i--)
			{
				var prevItem:Object = list.getItemAt(i);
				if (filterFunction(prevItem))
				{
					var len:int = localIndex.length;
					// get the index of the item in the filtered set 
					//for (var j:int = 0; j < len; j++) 
					for (var j:int = 0; j < len; j++)
					{
						if (localIndex[j] == prevItem)
							return j + 1;
					}
				}
			}
			//turns out that there are no neighbors of item in the filtered 
			//list, so item is the 1st item 
			return 0;
		}

		private function addItemsToView(items:Array, sourceLocation:int, dispatch:Boolean = true):int
		{
			var addedItems:Array = localIndex ? [] : items;
			var addLocation:int = sourceLocation;
			var firstOne:Boolean = true;
			if (localIndex)
			{
				var loc:int = sourceLocation;
				for (var i:int = 0; i < items.length; i++)
				{
					var item:Object = items[i];
					if (filterFunction == null || filterFunction(item))
					{
						if (sort)
						{
							loc = findItem(item, Sort.ANY_INDEX_MODE, true);
							if (firstOne)
							{
								addLocation = loc;
								firstOne = false;
							}
						}
						else
						{
							loc = getFilteredItemIndex(item);
							if (firstOne)
							{
								addLocation = loc;
								firstOne = false;
							}
						}
						if (sort && sort.unique && sort.compareFunction(item, localIndex[loc]) == 0)
						{
							// We cause all adds to fail here, not just the one.
							throw new Error("collections Error: incorrectAddition");
						}
						localIndex.splice(loc++, 0, item);
						addedItems.push(item);
					}
					else
						addLocation = -1;
				}
			}
			if (localIndex && addedItems.length > 1)
			{
				addLocation = -1;
			}
			if (dispatch && addedItems.length > 0)
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				event.kind = CollectionEventKind.ADD;
				event.location = addLocation;
				event.items = addedItems;
				dispatchEvent(event);
			}
			return addLocation;
		}

		/**
		 *  Take the item and remove it from the view.  If we don't have a sort
		 *  use the sourceLocation.  Dispatch the CollectionEvent with kind REMOVE
		 *  if dispatch is true.
		 *
		 *  @param items the items to remove from the view
		 *  @param sourceLocation the location within the list where the item was removed
		 *  @param dispatch true if the view should dispatch a corresponding
		 *                 CollectionEvent with kind REMOVE (default is true)
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function removeItemsFromView(items:Array, sourceLocation:int, dispatch:Boolean = true):void
		{
			var removedItems:Array = localIndex ? [] : items;
			var removeLocation:int = sourceLocation;
			if (localIndex)
			{
				for (var i:int = 0; i < items.length; i++)
				{
					var item:Object = items[i];
					var loc:int = getItemIndex(item);
					if (loc > -1)
					{
						localIndex.splice(loc, 1);
						removedItems.push(item);
						removeLocation = loc;
					}
				}
			}
			if (dispatch && removedItems.length > 0)
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				event.kind = CollectionEventKind.REMOVE;
				event.location = (!localIndex || removedItems.length == 1) ? removeLocation : -1;
				event.items = removedItems;
				dispatchEvent(event);
			}
		}

		/**
		 * Items is an array of PropertyChangeEvents so replace the oldValues with the new
		 * newValues.  Start at the location specified and move forward, it's unlikely
		 * that the length of items is > 1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function replaceItemsInView(items:Array, location:int, dispatch:Boolean = true):void
		{
			if (localIndex)
			{
				var len:int = items.length;
				var oldItems:Array = [];
				var newItems:Array = [];
				for (var i:int = 0; i < len; i++)
				{
					var propertyEvent:PropertyChangeEvent = items[i];
					oldItems.push(propertyEvent.oldValue);
					newItems.push(propertyEvent.newValue);
				}
				removeItemsFromView(oldItems, location, dispatch);
				addItemsToView(newItems, location, dispatch);
			}
			else
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				event.kind = CollectionEventKind.REPLACE;
				event.location = location;
				event.items = items;
				dispatchEvent(event);
			}
		}

		/**
		 * Remove the old value from the view and replace it with the value
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function moveItemInView(item:Object, dispatch:Boolean = true, updateEventItems:Array = null):void
		{
			if (localIndex)
			{
				//we're guaranteed that removeItemsFromView isn't going
				//to work here because the item has probably
				//already been updated so getItemIndex is going to fail
				//so we'll just do a linear search and find it if it's here
				var removeLocation:int = -1;
				for (var i:int = 0; i < localIndex.length; i++)
				{
					if (localIndex[i] == item)
					{
						removeLocation = i;
						break;
					}
				}
				if (removeLocation > -1)
				{
					localIndex.splice(removeLocation, 1);
				}
				var addLocation:int = addItemsToView([item], removeLocation, false);
				if (dispatch)
				{
					var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
					event.items.push(item);
					if (updateEventItems && addLocation == removeLocation && addLocation > -1)
					{
						updateEventItems.push(item);
						return;
					}
					if (addLocation > -1 && removeLocation > -1)
					{
						event.kind = CollectionEventKind.MOVE;
						event.location = addLocation;
						event.oldLocation = removeLocation;
					}
					else if (addLocation > -1)
					{
						event.kind = CollectionEventKind.ADD;
						event.location = addLocation;
					}
					else if (removeLocation > -1)
					{
						event.kind = CollectionEventKind.REMOVE;
						event.location = removeLocation;
					}
					else
					{
						dispatch = false;
					}
					if (dispatch)
					{
						dispatchEvent(event);
					}
				}
			}
		}

		/**
		 * Given a set of PropertyChangeEvents go through and update the view.
		 * This is currently not optimized.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function handlePropertyChangeEvents(events:Array):void
		{
			var eventItems:Array = events;
			if (sort || filterFunction != null)
			{
				//go through the events and find all the individual objects
				//that have been updated
				//then for each one determine whether we should move it or
				//just fire an update event
				var updatedItems:Array = [];
				var updateEntry:Object;
				var i:int;
				for (i = 0; i < events.length; i++)
				{
					var updateInfo:PropertyChangeEvent = events[i];
					var item:Object;
					var defaultMove:Boolean;
					if (updateInfo.target)
					{
						item = updateInfo.target;
						//if the target != source that means the update
						//happened to some subprop of the item in the collection
						//if we have a custom comparator this will affect
						//the sort so for now say we should move but
						//maybe we could optimize further
						defaultMove = updateInfo.target != updateInfo.source;
					}
					else
					{
						item = updateInfo.source;
						defaultMove = false;
					}
					//see if the item is already in the list
					var j:int = 0;
					for (; j < updatedItems.length; j++)
					{
						if (updatedItems[j].item == item)
						{
							// even if it is, if a different property changed, track that too.
							var events:Array = updatedItems[j].events;
							var l:int = events.length;
							for (var k:int = 0; k < l; k++)
							{
								if (events[k].property != updateInfo.property)
								{
									events.push(updateInfo);
									break;
								}
									// we could also merge events for changes to the same
									// property but that's hopefully low probability
									// and leads to questions of event order.
							}
							break;
						}
					}
					if (j < updatedItems.length)
					{
						updateEntry = updatedItems[j];
					}
					else
					{
						updateEntry = {item: item, move: defaultMove, events: [updateInfo]};
						updatedItems.push(updateEntry);
					}
					//if we've already set replace don't unset it
					//if there's a filterFunction need to go through replace
					//if there's no property specified for the sort we'll need
					//to assume we have to replace
					//if there is a property see if it affects the sort
					updateEntry.move = updateEntry.move || filterFunction || !updateInfo.property || (sort && sort.propertyAffectsSort(String(updateInfo.property)));
				}
				// go through the items and move and send move events for ones that moved
				// and build the list of remaining items we need to send UPDATE events for
				eventItems = [];
				for (i = 0; i < updatedItems.length; i++)
				{
					updateEntry = updatedItems[i];
					if (updateEntry.move)
					{
						moveItemInView(updateEntry.item, updateEntry.item, eventItems);
					}
					else
					{
						eventItems.push(updateEntry.item);
					}
				}
				// now go through the updated items and add all events for all 
				// properties that changed in that item (except for those items
				// we moved
				var temp:Array = [];
				for (var ctr:int = 0; ctr < eventItems.length; ctr++)
					for (var ctr1:int = 0; ctr1 < updatedItems.length; ctr1++)
						if (eventItems[ctr] == updatedItems[ctr1].item)
						{
							temp = temp.concat(updatedItems[ctr1].events);
						}
				eventItems = temp;
			}
			if (eventItems.length > 0)
			{
				var updateEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				updateEvent.kind = CollectionEventKind.UPDATE;
				updateEvent.items = eventItems;
				dispatchEvent(updateEvent);
			}
		}

		/**
		 * The view is a listener of CollectionEvents on its underlying IList
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function listChangeHandler(event:CollectionEvent):void
		{
			if (autoUpdateCounter > 0)
			{
				if (!pendingUpdates)
				{
					pendingUpdates = [];
				}
				pendingUpdates.push(event);
			}
			else
			{
				switch (event.kind)
				{
					case CollectionEventKind.ADD:
						addItemsToView(event.items, event.location);
						break;
					case CollectionEventKind.RESET:
						reset();
						break;
					case CollectionEventKind.REMOVE:
						removeItemsFromView(event.items, event.location);
						break;
					case CollectionEventKind.REPLACE:
						replaceItemsInView(event.items, event.location);
						break;
					case CollectionEventKind.UPDATE:
						handlePropertyChangeEvents(event.items);
						break;
					default:
						dispatchEvent(event);
				} // switch
			}
		}

		/**
		 *  @private
		 */
		public function set list(value:IList):void
		{
			if (_list != value)
			{
				var oldHasItems:Boolean;
				var newHasItems:Boolean;
				if (_list)
				{
					_list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler);
					oldHasItems = _list.length > 0;
				}
				_list = value;
				if (_list)
				{
					// weak listeners to collections and dataproviders
					_list.addEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler, false, 0, true);
					newHasItems = _list.length > 0;
				}
				if (oldHasItems || newHasItems)
					reset();
				dispatchEvent(new Event("listChange"));
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			}
		}

		/**
		 *  The IList that this collection view wraps.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get list():IList
		{
			return _list;
		}

		/**
		 *  @inheritDoc
		 *
		 *  @see #refresh()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get filterFunction():Function
		{
			return _filterFunction;
		}

		/**
		 *  @private
		 */
		public function set filterFunction(f:Function):void
		{
			_filterFunction = f;
			dispatchEvent(new Event("filterFunctionChanged"));
		}
	}
}
