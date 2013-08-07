package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import tempest.ui.UIStyle;
	import tempest.ui.effects.MenuEffect;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.ListEvent;

	[Event(name = "select", type = "tempest.ui.events.DataEvent")]
	[Event(name = "itemRenderCreate", type = "tempest.ui.events.ListEvent")]
	public class TListMenu extends TMenuContainer
	{
		private var _list:TList;
		private var _nameProperty:String;
		protected var _padingX:Number = 8;
		protected var _padingY:Number = 8;
		protected var _itemRenderClass:*;
		protected var _itemRenderSkin:Class;

		/**
		 *
		 * @param posTarget 菜单显示位置的参考控件, 为null则使用鼠标位置
		 * @param shower 菜单附属控件，附属控件关闭后菜单消失
		 * @param proxy
		 * @param itemRenderClass
		 * @param itemRenderSkin
		 * @param nameProperty 列表项用来显示为文本的字段，必须是get访问器(itemRender 为null时有效)
		 *
		 */
		public function TListMenu(posTarget:DisplayObject = null, shower:DisplayObject = null, proxy:* = null, itemRenderClass:* = null, itemRenderSkin:Class = null, nameProperty:String = "name")
		{
			_nameProperty = nameProperty;
			_itemRenderClass = itemRenderClass;
			if (!_itemRenderClass)
				_itemRenderClass = TTextListItemRender;
			_itemRenderSkin = itemRenderSkin;
			super(null, proxy, posTarget /*设置为以鼠标位置为参考*/, true, null, false, MenuEffect.DERECT_DOWN, shower);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_list = new TList(null, null, null, _itemRenderClass, _itemRenderSkin, [], false);
			_list.x = _padingX;
			_list.y = _padingY;
			_list.addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
			_list.addEventListener(Event.SELECT, onItemSelected);
			this.addChild(_list);
			this._menuEffect.delay = 5;
		}

		public function set minItemWidth(value:Number):void
		{
			_list.minItemWidth = value - _padingX;
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			var defaultRender:TTextListItemRender = event.data as TTextListItemRender;
			if (defaultRender)
				defaultRender.nameProperty = _nameProperty;
			event.itemRender.addEventListener(MouseEvent.CLICK, onItemRenderClick);
			this.dispatchEvent(event.clone());
		}

		private function onItemRenderClick(event:MouseEvent):void
		{
			this.play();
		}

		private function onItemSelected(event:Event):void
		{
			this.dispatchEvent(new Event(Event.SELECT));
//			if (_list.selectedItem == null)
//				return;
			//清空选中
//			_list.selectedIndex = -1;
		}

		override public function play():void
		{
			_list.removeEventListener(Event.SELECT, onItemSelected);
			_list.selectedIndex = -1;
			_list.addEventListener(Event.SELECT, onItemSelected);
			super.play();
		}

		public function set items(value:Array):void
		{
			if (!value)
				return;
			_list.items = value;
			_list.invalidateNow();
		}

		override public function measureChildren(proxyAsBackGround:Boolean = true, setSize:Boolean = true):Point
		{
			super.measureChildren();
			setProxySize(width + _padingX, height + _padingY);
			return new Point(width, height);
		}

		public function get items():Array
		{
			return _list.items;
		}

		public function get list():TList
		{
			return _list;
		}

		public function get selectedItem():Object
		{
			return _list.selectedItem;
		}

		public function set padingX(value:Number):void
		{
			_padingX = value;
			_list.x = _padingX;
		}

		public function set padingY(value:Number):void
		{
			_padingY = value;
			_list.y = _padingY;
		}

		public function get nameProperty():String
		{
			return _nameProperty;
		}
	}
}
