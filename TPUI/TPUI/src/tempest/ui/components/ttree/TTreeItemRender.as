package tempest.ui.components.ttree
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import mx.events.PropertyChangeEvent;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.components.TExpendableListItemRender;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.ListEvent;

	public class TTreeItemRender extends TListItemRender
	{
		protected var _itemFactory:TreeUnExpendRenderFactory;
		protected var _expendItemFactory:TreeUnExpendRenderFactory;
		protected var _itemRender:TListItemRender;
		protected var _expendItemRender:TExpendableListItemRender;
		protected var _currentRender:TListItemRender;

		public function TTreeItemRender(itemFactory:TreeUnExpendRenderFactory, expendItemFactory:TreeUnExpendRenderFactory)
		{
			_itemFactory = itemFactory;
			_expendItemFactory = expendItemFactory;
			super(null, data);
			this.invalidateNow(); //马上invalidate，防止滚动时候出现invalidate事件抛出。
		}

		override protected function onClick(event:MouseEvent):void
		{

		}

		public function cleanSelect():void
		{
			if (_currentRender is TreeExpendRender)
			{
				TreeExpendRender(_currentRender).cleanSelect();
			}
		}

		private var isTreeModelData:Boolean = true;

		override public function set data(value:Object):void
		{
			if (_currentRender)
			{
				this.removeChild(_currentRender);
				_currentRender = null;
			}
			var nodeData:TreeModel;
			if (value is TreeModel)
			{
				nodeData = value as TreeModel;
				isTreeModelData = true;
			}
			else
			{
				nodeData = new TreeModel(value, null);
				isTreeModelData = false;
			}

			super.data = nodeData;

			if (nodeData && (nodeData.hasChild() || nodeData.expendMode == TreeModel.EXPEND_FIXED))
			{
				if (!_expendItemRender)
				{
					_expendItemRender = _expendItemFactory.newInstance();
					_expendItemRender.addEventListener(Event.SELECT, onListRenderSelect);
//					_expendItemRender.addEventListener(DataEvent.DATA_SELECT, onSelect);
					_expendItemRender.addEventListener(Event.RESIZE, onDispendResize);
				}
				_currentRender = _expendItemRender;
			}
			else
			{
				if (!_itemRender)
				{
					_itemRender = _itemFactory.newInstance();
					_itemRender.addEventListener(Event.SELECT, onListRenderSelect);
//					_itemRender.addEventListener(DataEvent.DATA_SELECT, onSelect);
				}
				_currentRender = _itemRender;
			}
			_currentRender.data = data;
			this.addChild(_currentRender);
			measureWidth();
//			this.measureChildren();
		}

		override public function get data():Object
		{
			if (isTreeModelData)
			{
				return _data;
			}
			else
			{
				return _data ? TreeModel(_data).data : null;
			}
		}

		private function onDispendResize(event:Event):void
		{
			//此处如果使用measureChildren设置宽高，将会将子级缩放
//			this._height = this.measureChildren(true, false).y;
			measureWidth();
			this.dispatchEvent(new Event(Event.RESIZE));
		}

//		private function onSelect(event:DataEvent):void
//		{
//			dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, event.data));
////			this.selected = true;
//			this.setSelect();
//		}

		/**
		 * 捕获_itemRender和_expendItemRender抛出的SELECT事件，再次抛出，以让外层List可以设置选中
		 * @param event
		 *
		 */
		private function onListRenderSelect(event:Event):void
		{
			this.dispatchEvent(new Event(Event.SELECT));
		}

		override public function set selected(value:Boolean):void
		{
			if (super.selected == value)
			{
				return;
			}
			super.selected = value;
			if (_currentRender)
			{
				_currentRender.selected = value;
			}
		}

		override public function get height():Number
		{
			if (!_currentRender)
				return super.height;
			else
				return _currentRender.height;
		}

		override public function set width(value:Number):void
		{
			super.width = value;
		}

		public function expend():void
		{
			var expendRender:TreeExpendRender = _currentRender as TreeExpendRender;
			if (!expendRender)
				return;
			expendRender.expend();
		}

		public function dispend():void
		{
			var expendRender:TreeExpendRender = _currentRender as TreeExpendRender;
			if (!expendRender)
				return;
			expendRender.dispend();
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			if (_currentRender)
			{
				if (_currentRender is TreeUnExpendRender)
					TreeUnExpendRender(_currentRender).width = width;
				else if (_currentRender is TreeExpendRender)
					TreeExpendRender(_currentRender).width = width;
			}
//			super.invalidateSize();
		}

		public function getList():TList
		{
			if (_currentRender is TreeExpendRender)
			{
				return TreeExpendRender(_currentRender).list;
			}
			return null;
		}

		public function selectFirst():void
		{
			if (_currentRender)
			{
				if (_currentRender is TreeExpendRender)
				{
					var expendRender:TreeExpendRender = TreeExpendRender(_currentRender);
					expendRender.list.selectedIndex = 0;
				}
			}
		}

		public function get listSelected():Boolean
		{
			if (_currentRender)
			{
				if (_currentRender is TreeExpendRender)
				{
					var expendRender:TreeExpendRender = TreeExpendRender(_currentRender);
					if (expendRender.list.selectedIndex != -1)
					{
						return true;
					}
				}
			}
			return false;
		}

		public function get currentRender():TListItemRender
		{
			return _currentRender;
		}

	}
}
