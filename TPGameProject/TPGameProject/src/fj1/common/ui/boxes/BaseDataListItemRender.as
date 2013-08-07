package fj1.common.ui.boxes
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.DataChangeEvent;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;

	[Event(name = "dataChange", type = "tempest.ui.components.events.ListItemDataChangeEvent")]
	public class BaseDataListItemRender extends TListItemRender
	{
		protected var _dataBox:BaseDataBox;

		public function BaseDataListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			setGoodsBoxData(data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			createBox();
			_dataBox.addEventListener(DragEvent.DROP_DOWN, onDropDown);
			_dataBox.addEventListener(Event.SELECT, onMenuSelect);
		}

		private function onMenuSelect(event:Event):void
		{
			this.unSelect();
		}
		private var _justDropDown:Boolean = false;

		private function onDropDown(event:DragEvent):void
		{
			_justDropDown = true;
		}

		protected function createBox():void
		{
			_dataBox = new BaseDataBox(_proxy);
		}

		override public function get data():Object
		{
			return super.data;
		}

		override protected function onClick(event:MouseEvent):void
		{
			if (!_selectable)
				return;
			if (!_selected)
			{
				if (_justDropDown)
				{
					_justDropDown = false;
					this.unSelect();
				}
				else
				{
					super.onClick(event);
				}
			}
		}

		/**
		 * 列表设置 data
		 * @param value
		 *
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			setGoodsBoxData(value);
			if (!data)
			{
				this.unSelect();
			}
		}

		protected function setGoodsBoxData(value:Object):void
		{
			_dataBox.data = value;
		}

		public function get dataBox():BaseDataBox
		{
			return _dataBox;
		}

		public function get dragImage():TDragableImage
		{
			return _dataBox.dragImage;
		}

		override protected function implementSize(width:Number, height:Number):void
		{
			_dataBox.setSize(width, height);
		}

//		override public function setSize(w:Number, h:Number):void
//		{
//			super.setSize(w, h);
//			
//		}
	}
}
