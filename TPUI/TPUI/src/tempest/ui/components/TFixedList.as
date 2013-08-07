package tempest.ui.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.core.IFactory;
	import mx.events.PropertyChangeEvent;

	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.collections.TFixedLayoutItemHolder;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.core.ITListItemRender;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.DataChangeEvent;
	import tempest.ui.events.ListEvent;

	[Event(name = "select", type = "flash.events.Event")]
	[Event(name = "pickUp", type = "tempest.ui.events.DragEvent")]
	[Event(name = "dropDown", type = "tempest.ui.events.DragEvent")]
	[Event(name = "dropOut", type = "tempest.ui.events.DragEvent")]
	[Event(name = "dragDataChange", type = "tempest.ui.events.DataChangeEvent")]
	[Event(name = "itemRenderCreate", type = "tempest.ui.events.ListEvent")]
	public class TFixedList extends TComponent
	{
		private var _fixLayoutList:TFixedLayoutItemHolder;

		public function TFixedList(constraints:Object = null, proxy:* = null, listItemRenderClass:* = null, itemName:String = null, items:Array = null, disableDropDownChange:Boolean = true, itemRenderCreateHandler:Function = null)
		{
			_fixLayoutList = new TFixedLayoutItemHolder(DisplayObjectContainer(proxy), listItemRenderClass,
				itemName, items, disableDropDownChange, itemRenderCreateHandler);
			_fixLayoutList.addEventListener(Event.SELECT, onSelect);
			super(constraints, proxy);
		}

		private function onSelect(event:Event):void
		{
			this.dispatchEvent(new Event(Event.SELECT));
		}

		public function setItemAt(value:* = null, index:int = 0):void
		{
			_fixLayoutList.setItemAt(value, index);
		}

		public function getItemRender(index:int):ITListItemRender
		{
			return _fixLayoutList.getItemRender(index);
		}

		public function getItemRenderByData(data:Object):ITListItemRender
		{
			return _fixLayoutList.getItemRenderByData(data);
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set selectedIndex(value:int):void
		{
			_fixLayoutList.selectedIndex = value;
		}

		public function get selectedIndex():int
		{
			return _fixLayoutList.selectedIndex;
		}

		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			_fixLayoutList.selectedItem = item;
		}

		public function get selectedItem():Object
		{
			return _fixLayoutList.selectedItem;
		}

		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			_fixLayoutList.items = value;
		}

		public function get items():Array
		{
			return _fixLayoutList.items;
		}

		public function set dataProvider(value:IList):void
		{
			_fixLayoutList.dataProvider = value;
		}

		public function get dataProvider():IList
		{
			return _fixLayoutList.dataProvider;
		}

		public function get length():int
		{
			return _fixLayoutList.length;
		}

		public function set selectable(value:Boolean):void
		{
			_fixLayoutList.selectable = value;
		}

		public function get itemRenders():Array
		{
			return _fixLayoutList.itemRenders;
		}

		/**
		 * 枚举所有itemRender并执行callBack回调
		 * 格式：function(render:ITListItemRender):void{}
		 * @param callBack
		 *
		 */
		public function foreach(callBack:Function):void
		{
			_fixLayoutList.foreach(callBack);
		}

	}
}


