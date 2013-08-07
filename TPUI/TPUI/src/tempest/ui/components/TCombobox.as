package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import mx.core.IFactory;

	import tempest.ui.components.textFields.TText;
	import tempest.ui.effects.MenuEffect;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TComboboxEvent;

	[Event(name = "select", type = "flash.events.Event")]
	[Event(name = "itemRenderCreate", type = "tempest.ui.events.ListEvent")]
	public class TCombobox extends TComponent
	{
		protected var _btn_dropDown:TButton;
		private var _selectedItemHolder:DisplayObject;
		protected var _menu:TListMenu;
		private var _selectedIndex:int = -1;
		public static const DERECT_DOWN:int = MenuEffect.DERECT_DOWN;
		public static const DERECT_UP:int = MenuEffect.DERECT_UP;

		/**
		 *
		 * @param constraints 相对布局方式
		 * @param proxy 对应Combobox选中项的资源，可以包括下拉按钮或不包括
		 * @param selectedItemFactory 选中项的渲染类，data属性用来设置选中项的值，类参数和TListItemRender相同
		 * 如果选中项内容和下拉项相同，则可以设置和itemRenderClass相同的值
		 * 如果并不需要再Combobox收起时自动设置值，而是手动设置，该项可以为null
		 * @param listProxy 下拉列表背景proxy，null则不使用背景
		 * @param itemRenderClass 下拉列表项渲染类
		 * @param itemSkinClass 下拉列表项资源类
		 * @param nameProperty 如果itemRenderClass派生于TTextListItemRender，此参数可以设置数据源项中用于显示文本的属性名称
		 *
		 */
		public function TCombobox(constraints:Object = null, proxy:* = null, selectedItemFactory:* = null, listProxy:* = null, itemRenderClass:* = null, itemSkinClass:Class = null, nameProperty:String =
			"label")
		{
			super(constraints, proxy);
			if (_proxy.hasOwnProperty("btn_dropDown"))
			{
				_btn_dropDown = new TButton(null, _proxy.btn_dropDown);
				_btn_dropDown.addEventListener(MouseEvent.CLICK, onDropClick);
			}
			initSelectedItemHolder(selectedItemFactory);
			_menu = new TListMenu(this, this, listProxy, itemRenderClass, itemSkinClass, nameProperty);
			_menu.xOffset = 0;
			_menu.yOffsetDown = this.height;
			_menu.notAutoHideTargetArray = _btn_dropDown ? [_selectedItemHolder, _btn_dropDown] : [_selectedItemHolder];
			_menu.addEventListener(Event.SELECT, onItemSelect);
			_menu.list.addEventListener(ListEvent.ITEM_RENDER_CREATE, onRenderCreate);
			_menu.minItemWidth = _selectedItemHolder.width;
			setSelectedContent(null);
		}

		/**
		 * 将控件中的下拉菜单关联一个窗口
		 * 监听 TWindowEvent.MOVE_TO_TOP事件，以将下拉菜单随窗口置顶而置顶
		 * @param window
		 *
		 */
		public function attachToWindow(window:DisplayObject):void
		{
			_menu.attachToWindow(window);
		}

		private function onRenderCreate(event:ListEvent):void
		{
			dispatchEvent(event.clone());
		}

		private function initSelectedItemHolder(selectedItemFactory:* = null):void
		{
			if (selectedItemFactory is IFactory)
			{
				_selectedItemHolder = IFactory(selectedItemFactory).newInstance();
			}
			else
			{
				var holderProxy:*;
				if (_proxy.hasOwnProperty("selectedItem"))
					holderProxy = _proxy.selectedItem;
				else
					holderProxy = _proxy;
				if (selectedItemFactory is Class)
				{
					_selectedItemHolder = new selectedItemFactory(holderProxy, null);
				}
				else if (holderProxy is SimpleButton)
				{
					_selectedItemHolder = new TButton(null, holderProxy);
				}
				else if (holderProxy is TextField)
				{
					_selectedItemHolder = new TText(null, holderProxy, "", TextFieldAutoSize.CENTER);
				}
				else
				{
					_selectedItemHolder = holderProxy;
				}
			}

			_selectedItemHolder.addEventListener(MouseEvent.CLICK, onDropClick);
		}

		/**
		 * 选中一项时触发
		 *
		 */
		protected function setSelectedContent(selectedItem:Object):void
		{
			//获取选中值
			var value:Object;
			if (!selectedItem || selectedItem is String)
			{
				value = selectedItem;
			}
			else
			{
				if (_menu.nameProperty && selectedItem.hasOwnProperty(_menu.nameProperty))
					value = selectedItem[_menu.nameProperty];
				else
				{
					var render:TSimpleTextListItemRender = this._menu.list.getItemRender(_menu.list.selectedIndex) as TSimpleTextListItemRender;
					if (render)
					{
						value = render.text.text;
					}
					else
					{
						value = selectedItem;
					}
				}
			}
			//根据不同的_selectedItemHolder类型赋值
			if (_selectedItemHolder is TButton)
			{
				(_selectedItemHolder as TButton).text = value ? value as String : "";
			}
			else if (_selectedItemHolder is TText)
			{
				(_selectedItemHolder as TText).text = value ? value as String : "";
			}
			else
			{
				if (_selectedItemHolder is TComponent)
				{
					TComponent(_selectedItemHolder).data = selectedItem;
				}
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			this._menu.list.addItem(item);
		}

		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			this._menu.list.addItemAt(item, index);
		}

		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeItem(item:Object):void
		{
			this._menu.list.removeItem(item);
		}

		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeItemAt(index:int):void
		{
			this._menu.list.removeItemAt(index);
		}

		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			this._menu.list.removeAll();
		}

		/**
		 * 展开列表
		 *
		 */
		public function expend():void
		{
			if (items.length == 0 && !_menu.showing)
			{
				_menu.width = _selectedItemHolder.width;
			}
			this._menu.expend();
		}

		/**
		 * 收起列表
		 *
		 */
		public function dispend():void
		{
			this._menu.dispend();
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		protected function onDropClick(event:MouseEvent):void
		{
			this.addEventListener(TComboboxEvent.MENU_DROP_DOWN, onDefaultDropClick, false, -50);
			dispatchEvent(new TComboboxEvent(TComboboxEvent.MENU_DROP_DOWN, false, true));
		}

		private function onDefaultDropClick(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (event.isDefaultPrevented())
			{
				return;
			}

			if (items.length == 0 && !_menu.showing)
			{
				_menu.width = _selectedItemHolder.width;
			}
			_menu.play();
		}

		protected function onItemSelect(event:Event):void
		{
			_selectedIndex = this._menu.list.selectedIndex;
			this.addEventListener(Event.SELECT, onDefaultSelected, false, -50);
			dispatchEvent(new Event(Event.SELECT, false, true));
		}

		private function onDefaultSelected(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (event.isDefaultPrevented())
			{
				return;
			}
			setSelectedContent(_menu.list.selectedItem);
		}

		protected function onListClick(event:MouseEvent):void
		{
			_menu.play();
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function get menu():TListMenu
		{
			return _menu;
		}

		/**
		 * 选中项索引
		 * @param value
		 *
		 */
		public function set selectedIndex(value:int):void
		{
//			this._menu.list.selectedIndex = value;
			if (this._menu.list.items.length <= value)
			{
				value = -1;
			}
			_selectedIndex = value;
			this._menu.list.selectedIndex = value;
			if (_selectedIndex < 0)
			{
				setSelectedContent(null);
			}
			else
			{
				setSelectedContent(this._menu.list.items[value]);
			}
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
//			return this._menu.list.selectedIndex;
		}

		/**
		 * 选中项
		 * @param value
		 *
		 */
		public function set selectedItem(value:Object):void
		{
//			this._menu.list.selectedItem = value;
			_selectedIndex = this._menu.list.items.indexOf(value);
			if (_selectedIndex < 0)
			{
				setSelectedContent(null);
			}
			else
			{
				setSelectedContent(value);
			}
		}

		public function get selectedItem():Object
		{
			return this._menu.list.items[_selectedIndex];
//			return this._menu.list.selectedItem;
		}

		public function set items(value:Array):void
		{
			this._menu.items = value;
		}

		public function get items():Array
		{
			return this._menu.items;
		}

		public function set dataProvider(value:IList):void
		{
			this._menu.list.dataProvider = value;
		}

		/**
		 * 获取选中项容器
		 * @return
		 *
		 */
		public function get selectedItemHolder():DisplayObject
		{
			return _selectedItemHolder;
		}

		public function set direct(value:int):void
		{
			_menu.direct = value;
		}

		public function get direct():int
		{
			return _menu.direct;
		}

		public function get btn_dropDown():TButton
		{
			return _btn_dropDown;
		}
	}
}
