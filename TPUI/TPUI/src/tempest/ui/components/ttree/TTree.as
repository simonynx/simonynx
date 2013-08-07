package tempest.ui.components.ttree
{
	import flash.events.Event;
	import flash.geom.Rectangle;

	import mx.core.IFactory;
	import mx.events.PropertyChangeEvent;

	import tempest.ui.components.TAutoSizeComponent;
	import tempest.ui.components.TExpendableList;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TScrollPanel;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TComponentEvent;

	[Event(name = "data_select", type = "tempest.ui.events.DataEvent")]
	public class TTree extends TScrollPanel
	{
		private var _nodeData:TreeModel;
		private var _list:TList;
		private var _itemRenderFactory:IFactory;
		private var _selectedItem:Object;

		/**
		 * 由嵌套的TList组成的树形
		 * @param constraints
		 * @param _proxy
		 * @param itemRender
		 * @param proxyFactoryArray
		 * @param data
		 * @param scrollBarProxy
		 *
		 */
		public function TTree(constraints:Object = null, _proxy:* = null, itemRenderFactory:TreeItemRenderFactory = null, data:TreeModel = null, scrollBarProxy:* = null)
		{
			_itemRenderFactory = itemRenderFactory;
			super(constraints, _proxy, true, scrollBarProxy);
			if (data)
			{
				this.data = data;
			}

			this.addEventListener(DataEvent.DATA_SELECT, onThisSelect);
		}

		private function onThisSelect(event:DataEvent):void
		{
			_selectedItem = event.data;
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			var itemRender:TTreeItemRender = event.data as TTreeItemRender;
			itemRender.addEventListener("CleanSelect", onCleanSelect);
			itemRender.addEventListener("CleanSelectAll", onCleanSelectAll);
			itemRender.addEventListener("SelectNextList", onSelectNextList);
		}

		private function onSelectNextList(event:Event):void
		{
			var len:int = _list.items.length;
			for (var i:int = 0; i < len; i++)
			{
				var render:TTreeItemRender = TTreeItemRender(_list.getItemRender(i));
				if (event.currentTarget == render) //找到抛事件的render，尝试选中在其之后的render列表中的第一项
				{
					if (i < len)
					{
						for (var j:int = i + 1; j < len; ++j)
						{
							var nextRender:TTreeItemRender = TTreeItemRender(_list.getItemRender(j));
							if (nextRender.currentRender is TreeExpendRender && TreeExpendRender(nextRender.currentRender).list.items.length > 0)
							{
								nextRender.selectFirst();
//								var firstRender:TTreeItemRender = TTreeItemRender(TreeExpendRender(nextRender.currentRender).list.getItemRender(0));
								return;
							}
						}
					}
					dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, null));
				}
			}
		}

		private function onCleanSelect(event:Event):void
		{
			for (var i:int = 0; i < _list.items.length; i++)
			{
				var element:TTreeItemRender = _list.getItemRender(i) as TTreeItemRender;
				if (element && event.target != element.getList())
				{
					element.cleanSelect();
				}
			}
		}

		private function onCleanSelectAll(event:Event):void
		{
			for (var i:int = 0; i < _list.items.length; i++)
			{
				var element:TTreeItemRender = _list.getItemRender(i) as TTreeItemRender;
				if (element)
					element.cleanSelect();
			}
		}


		override public function set scrollRect(value:Rectangle):void
		{
			super.scrollRect = value;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			_nodeData = data as TreeModel;
			if (!_list)
			{
				_list = new TExpendableList(null, null, null, _itemRenderFactory, null, []);
				_list.fixedWidth = _proxy.width - _scrollBar.width;
				_list.addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
				_list.addEventListener(DataEvent.DATA_SELECT, onDataSelect);
				_list.addEventListener(Event.SELECT, onListItemSelect);
				_list.addEventListener(TComponentEvent.INVALIDATE_COMPLETE, onInvalidateComplete);
				this.contentPanel = _list;
			}
			_list.data = _nodeData;
			if (_list.dataProvider)
			{
				_list.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onListChange);
			}
			_list.dataProvider = _nodeData ? _nodeData.childList : null;
			_list.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onListChange); //子项列表数据变化
			_list.invalidateNow();
		}

		private var collectionChanged:Boolean = false;

		private function onInvalidateComplete(event:TComponentEvent):void
		{
			if (!collectionChanged)
			{
				return;
			}
			collectionChanged = false;
			if (_selectedItem)
			{
				this.addEventListener(Event.ENTER_FRAME, onDelayCheckSelect);
			}
		}

		private function onDelayCheckSelect(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			var len:int = _list.items.length;
			for (var i:int = 0; i < len; ++i)
			{
				var treeRender:TTreeItemRender = TTreeItemRender(_list.getItemRender(i));
				if (treeRender.listSelected)
				{
					return;
				}
			}

			if (len > 0)
			{
				var firstRender:TTreeItemRender = TTreeItemRender(_list.getItemRender(0));
				if (firstRender.currentRender is TreeExpendRender)
				{
					firstRender.selectFirst();
				}
			}
		}

		private function onListChange(e:CollectionEvent):void
		{
			switch (e.kind)
			{
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.ADD:
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
				case CollectionEventKind.REPLACE:
					collectionChanged = true;
					break;
			}
		}

		/**
		 * 列表项选中（列表项的子列表选中不会触发）
		 * @param event
		 *
		 */
		private function onListItemSelect(event:Event):void
		{
			dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, _list.selectedItem));
		}

		private function onDataSelect(event:DataEvent):void
		{
			event.stopPropagation();
			dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, event.data));
		}

		public function get list():TExpendableList
		{
			return _list as TExpendableList;
		}
	}
}
