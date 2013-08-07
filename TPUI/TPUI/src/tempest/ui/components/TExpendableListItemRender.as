package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import tempest.ui.effects.MenuEffect;
	import tempest.ui.events.EffectEvent;

	public class TExpendableListItemRender extends TListItemRender
	{
		public var mc_dropDownBt:DisplayObject;
		public var mc_expandContainer:DisplayObjectContainer;
		//-----------------------------------------------
		private var _dropDownBt:DisplayObject; //点击会展开的区域
		private var _headbg:DisplayObject; //头项区域
		protected var _expandContainer:DisplayObjectContainer; //下拉区域
		private var _menuEffect:MenuEffect;
		private var _defaultXOffset:Number = 10;
		private var containerXOffset:Number = _defaultXOffset;
		private var containerYOffset:Number = 0;

		public function TExpendableListItemRender(_proxy:* = null, data:Object = null)
		{
			super(_proxy, data);
		}

		override protected function onClick(event:MouseEvent):void
		{

		}

		override protected function addChildren():void
		{
			super.addChildren();
			//下拉按钮
			if (_proxy && _proxy.hasOwnProperty("btn_dropDown"))
				_dropDownBt = _proxy.btn_dropDown;
			//头部区域背景
			if (_proxy && _proxy.hasOwnProperty("headbg"))
				_headbg = _proxy.headbg;
			//下拉项容器
			if (_proxy && _proxy.hasOwnProperty("expandContainer"))
				_expandContainer = new TAutoSizeComponent(null, _proxy.expandContainer, false);
			else
			{
				_expandContainer = new TAutoSizeComponent();
				this.addChild(_expandContainer);
			}
			if (_expandContainer)
			{
				_expandContainer.x = containerXOffset;
				_expandContainer.y = (_headbg ? _headbg.height : 0) + containerYOffset;
			}
			if (_dropDownBt)
			{
				_dropDownBt.addEventListener(MouseEvent.CLICK, onHeadClick);
			}
			//默认使用下拉效果
			_menuEffect = new MenuEffect(10, _expandContainer, MenuEffect.DERECT_DOWN);
			_menuEffect.addEventListener(Event.CHANGE, onEffectChange);
		}

		/**
		 * 重新设置下拉按钮和头项区域
		 * @param dropDownBt
		 * @param itembg
		 *
		 */
		protected function reInit(dropDownBt:DisplayObject, itembg:DisplayObject):void
		{
			if (_dropDownBt)
			{
//				this.removeChild(_dropDownBt);
				_dropDownBt.removeEventListener(MouseEvent.CLICK, onHeadClick);
			}
			_headbg = itembg;
			_dropDownBt = dropDownBt;
			if (_dropDownBt)
			{
				_expandContainer.x = containerXOffset;
				_expandContainer.y = (_headbg ? _headbg.height : 0) + containerYOffset;
				_dropDownBt.addEventListener(MouseEvent.CLICK, onHeadClick);
//				this.addChild(_dropDownBt);
			}

//			useRawSize()
//			measureChildren(false);
		}

		public function setExpandContainerOffset(x:Number, y:Number):void
		{
			containerXOffset = x;
			containerYOffset = y;
		}

		public function addToExpandContainer(sprite:Sprite):void
		{
			_expandContainer.addChild(sprite);
			sprite.addEventListener(Event.RESIZE, onEpContainerResize);
			setScrollRect();
		}

		/**
		 *  监听下拉框高度变化
		 * @param event
		 *
		 */
		private function onEpContainerResize(event:Event):void
		{
//			this.measureChildren(false);
			setScrollRect();
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		public function get expandContainer():DisplayObject
		{
			return _expandContainer;
		}

		private function setScrollRect():void
		{
			if (_menuEffect)
			{
				if (_menuEffect.playing)
				{
					return;
				}

				if (_menuEffect.hiding)
				{
					_expandContainer.scrollRect = new Rectangle(0, _expandContainer.height, _expandContainer.width, _expandContainer.height);
				}
				else
				{
					_expandContainer.scrollRect = new Rectangle(0, 0, _expandContainer.width, _expandContainer.height);
				}
			}
		}

		protected function onHeadClick(event:MouseEvent):void
		{
			if (_menuEffect)
				_menuEffect.play();
			else
			{
				_expandContainer.visible = !_expandContainer.visible;
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * 展开列表
		 *
		 */
		public function expend():void
		{
			if (_menuEffect)
				_menuEffect.expend();
			else
			{
				_expandContainer.visible = true;
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * 收起列表
		 *
		 */
		public function dispend():void
		{
			if (_menuEffect)
				_menuEffect.dispend();
			else
			{
				_expandContainer.visible = false;
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		protected function onEffectChange(event:Event):void
		{
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get height():Number
		{
			var ret:Number = 0;
			if (!_menuEffect)
			{
				//不使用下拉效果时
				if (_expandContainer.visible)
					ret = super.height + _expandContainer.height;
				else
					ret = super.height;
			}
			else
			{
				ret = super.height + _menuEffect.scrollHeight;
			}
			return ret;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
//			measureChildren();
		}

		override public function set width(value:Number):void
		{
			_expandContainer.width = value - _expandContainer.x;
			super.width = value;
		}

		public function set useEffect(value:Boolean):void
		{
			if (_menuEffect && !value)
			{
				_menuEffect.dispose();
				_menuEffect.removeEventListener(Event.CHANGE, onEffectChange);
				_menuEffect = null;
			}
			else if (!_menuEffect && value)
			{
				_menuEffect = new MenuEffect(10, _expandContainer, MenuEffect.DERECT_DOWN);
				_menuEffect.addEventListener(Event.CHANGE, onEffectChange);
			}
		}
	}
}
