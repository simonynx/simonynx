package tempest.ui.collections
{
	import com.adobe.utils.ArrayUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	import tempest.ui.components.IList;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	
	public class TArrayList extends EventDispatcher implements IList
	{
		protected var _source:Array;
		
		protected var _enableEvents:Boolean;
		
		public function TArrayList(source:Array)
		{
			disableEvents();
			this.source = source;
			enableEvents();
			
			super();
		}
		
		public function getItemAt(index:int, prefetch:int = 0):Object
		{
			if (index < 0 || index >= length)
			{
				throw new RangeError("collections outOfBounds: " + index.toString());
			}
			
			return source[index];
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			if (index < 0 || index >= length) 
			{
				throw new RangeError("collections outOfBounds: " + index.toString());
			}
			
			var oldItem:Object = source[index];
			source[index] = item;
			stopTrackUpdates(oldItem);
			startTrackUpdates(item);
			
			//dispatch the appropriate events 
			if (_enableEvents)
			{
				var hasCollectionListener:Boolean = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
				var hasPropertyListener:Boolean = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
				var updateInfo:PropertyChangeEvent; 
				
				if (hasCollectionListener || hasPropertyListener)
				{
					updateInfo = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
					updateInfo.kind = PropertyChangeEventKind.UPDATE;
					updateInfo.oldValue = oldItem;
					updateInfo.newValue = item;
					updateInfo.property = index;
				}
				
				if (hasCollectionListener)
				{
					var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
					event.kind = CollectionEventKind.REPLACE;
					event.location = index;
					event.items.push(updateInfo);
					dispatchEvent(event);
				}
				
				if (hasPropertyListener)
				{
					dispatchEvent(updateInfo);
				}
			}
			return oldItem;    
		}
		
		/**
		 *  Return the index of the item if it is in the list such that
		 *  getItemAt(index) == item.  
		 *  Note that in this implementation the search is linear and is therefore 
		 *  O(n).
		 * 
		 *  @param item the item to find
		 *  @return the index of the item, -1 if the item is not in the list.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getItemIndex(item:Object):int
		{
			return source.indexOf(item);// ArrayUtil.getItemIndex(item, source);
		}
		/**
		 *  Add the specified item to the end of the list.
		 *  Equivalent to addItemAt(item, length);
		 * 
		 *  @param item the item to add
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		
		public function addItem(item:Object):void
		{
			addItemAt(item, length);
		}
		
		/**
		 *  Add the item at the specified index.  
		 *  Any item that was after this index is moved out by one.  
		 * 
		 *  @param item the item to place at the index
		 *  @param index the index at which to place the item
		 *  @throws RangeError if index is less than 0 or greater than the length
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function addItemAt(item:Object, index:int):void
		{
			if (index < 0 || index > length) 
			{
				throw new RangeError("collections outOfBounds: " + index.toString());
			}
			
			source.splice(index, 0, item);
			
			startTrackUpdates(item);
			internalDispatchEvent(CollectionEventKind.ADD, item, index);
		}
		
		/**
		 *  @copy mx.collections.ListCollectionView#addAll()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function addAll(addList:Array):void
		{
			addAllAt(addList, length);
		}
		
		/**
		 *  @copy mx.collections.ListCollectionView#addAllAt()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function addAllAt(addList:Array, index:int):void
		{
			var length:int = addList.length;
			for (var i:int = 0; i < length; i++)
			{
				this.addItemAt(addList.getItemAt(i), i+index);
			}
		}
		
		/**
		 *  Removes the specified item from this list, should it exist.
		 *
		 *  @param  item Object reference to the item that should be removed.
		 *  @return Boolean indicating if the item was removed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function removeItem(item:Object):Boolean
		{
			var index:int = getItemIndex(item);
			var result:Boolean = index >= 0;
			if (result)
				removeItemAt(index);
			
			return result;
		}
		
		/**
		 *  Remove the item at the specified index and return it.  
		 *  Any items that were after this index are now one index earlier.
		 *
		 *  @param index The index from which to remove the item.
		 *  @return The item that was removed.
		 *  @throws RangeError if index &lt; 0 or index &gt;= length.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function removeItemAt(index:int):Object
		{
			if (index < 0 || index >= length)
			{
				throw new RangeError("collections outOfBounds: " + index.toString());
			}
			
			var removed:Object = source.splice(index, 1)[0];
			stopTrackUpdates(removed);
			internalDispatchEvent(CollectionEventKind.REMOVE, removed, index);
			return removed;
		}
		
		/** 
		 *  Remove all items from the list.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function removeAll():void
		{
			if (length > 0)
			{
				var len:int = length;
				for (var i:int = 0; i < len; i++)
				{
					stopTrackUpdates(source[i]);
				}
				
				source.splice(0, length);
				internalDispatchEvent(CollectionEventKind.RESET);
			}    
		}
		
		/** 
		 *  If the item is an IEventDispatcher watch it for updates.  
		 *  This is called by addItemAt and when the source is initially
		 *  assigned.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function startTrackUpdates(item:Object):void
		{
			if (item && (item is IEventDispatcher))
			{
				IEventDispatcher(item).addEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					itemUpdateHandler, false, 0, true);
			}
		}
		
		/**
		 *  Notify the view that an item has been updated.  
		 *  This is useful if the contents of the view do not implement 
		 *  <code>IEventDispatcher</code>.  
		 *  If a property is specified the view may be able to optimize its 
		 *  notification mechanism.
		 *  Otherwise it may choose to simply refresh the whole view.
		 *
		 *  @param item The item within the view that was updated.
		 *
		 *  @param property A String, QName, or int
		 *  specifying the property that was updated.
		 *
		 *  @param oldValue The old value of that property.
		 *  (If property was null, this can be the old value of the item.)
		 *
		 *  @param newValue The new value of that property.
		 *  (If property was null, there's no need to specify this
		 *  as the item is assumed to be the new value.)
		 *
		 *  @see mx.events.CollectionEvent
		 *  @see mx.core.IPropertyChangeNotifier
		 *  @see mx.events.PropertyChangeEvent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function itemUpdated(item:Object, property:Object = null, 
									oldValue:Object = null, 
									newValue:Object = null):void
		{
			var event:PropertyChangeEvent =
				new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
			
			event.kind = PropertyChangeEventKind.UPDATE;
			event.source = item;
			event.property = property;
			event.oldValue = oldValue;
			event.newValue = newValue;
			
			itemUpdateHandler(event);        
		}    
		
		/**
		 *  Return an Array that is populated in the same order as the IList
		 *  implementation.  
		 * 
		 *  @throws ItemPendingError if the data is not yet completely loaded
		 *  from a remote location
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */ 
		public function toArray():Array
		{
			return source.concat();
		}
		
		/**
		 *  Dispatches a collection event with the specified information.
		 *
		 *  @param kind String indicates what the kind property of the event should be
		 *  @param item Object reference to the item that was added or removed
		 *  @param location int indicating where in the source the item was added.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function internalDispatchEvent(kind:String, item:Object = null, location:int = -1):void
		{
			if (_enableEvents)
			{
				if (hasEventListener(CollectionEvent.COLLECTION_CHANGE))
				{
					var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
					event.kind = kind;
					event.items.push(item);
					event.location = location;
					dispatchEvent(event);
				}
				
				// now dispatch a complementary PropertyChangeEvent
				if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE) && 
					(kind == CollectionEventKind.ADD || kind == CollectionEventKind.REMOVE))
				{
					var objEvent:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
					objEvent.property = location;
					if (kind == CollectionEventKind.ADD)
						objEvent.newValue = item;
					else
						objEvent.oldValue = item;
					dispatchEvent(objEvent);
				}
			}
		}
		
		/** 
		 *  If the item is an IEventDispatcher stop watching it for updates.
		 *  This is called by removeItemAt, removeAll, and before a new
		 *  source is assigned.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function stopTrackUpdates(item:Object):void
		{
			if (item && item is IEventDispatcher)
			{
				IEventDispatcher(item).removeEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					itemUpdateHandler);    
			}
		}
		
		/**
		 *  Called whenever any of the contained items in the list fire an
		 *  ObjectChange event.  
		 *  Wraps it in a CollectionEventKind.UPDATE.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */    
		protected function itemUpdateHandler(event:PropertyChangeEvent):void
		{
			internalDispatchEvent(CollectionEventKind.UPDATE, event);
			// need to dispatch object event now
			if (_enableEvents && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				var objEvent:PropertyChangeEvent = PropertyChangeEvent(event.clone());
				var index:uint = getItemIndex(event.target);
				objEvent.property = index.toString() + "." + event.property;
				dispatchEvent(objEvent);
			}
		}
		
		public function get source():Array
		{
			return _source;
		}
		
		public function set source(value:Array):void
		{
			var i:int;
			
			//移除旧的监听
			if (_source && _source.length)
			{
				for (i = 0; i < _source.length; i++)
				{
					stopTrackUpdates(_source[i]);
				}
			}
			
			//
			_source  = value ? value : [];
			
			for (i = 0; i < _source.length; i++)
			{
				startTrackUpdates(_source[i]);
			}
			
			if(_enableEvents)
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				event.kind = CollectionEventKind.RESET;
				dispatchEvent(event);
			}
		}
		
		public function get length():int
		{
			if (source)
				return source.length;
			else
				return 0;
		}
		
		public function enableEvents():void
		{
			_enableEvents = true;
		}
		
		public function disableEvents():void
		{
			_enableEvents = false;
		}
	}
}