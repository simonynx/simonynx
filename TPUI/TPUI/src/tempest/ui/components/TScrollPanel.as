package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import tempest.ui.UIStyle;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.events.TScrollPanelEvent;

	public class TScrollPanel extends TPanel
	{
		protected var _useScrollBar:Boolean;
		protected var _scrollBarProxy:*;
		protected var _scrollBar:TScrollBar;
		protected var _offset:Number = 0;
		protected var _maximun:Number = 0;
		protected var _contentPanel:TAutoSizeComponent;
//		protected var _outterPanel:DisplayObjectContainer;
		protected var _defaultLineSize:int = 10;

		public function TScrollPanel(constraints:Object = null, _proxy:* = null, useScrollBar:Boolean = false, scrollBarProxy:* = null)
		{
			_useScrollBar = useScrollBar;
			_scrollBarProxy = scrollBarProxy;
			super(constraints, _proxy);
			if (_proxy)
				this.graphics.drawRect(0, 0, _proxy.width, _proxy.height);
		}

		override protected function addChildren():void
		{
			super.addChildren();
//			_outterPanel = new Sprite();
//			(_outterPanel as Sprite).graphics.drawRect(0, 0, this.width, this.height);
//			this.addChild(_outterPanel);
			createScrollBar();
			contentPanel = new TAutoSizeComponent(null, _proxy, false);
			initScrollBar();
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function createScrollBar():void
		{
			if (_useScrollBar)
			{
				_scrollBar = new TScrollBar(null, _scrollBarProxy ? _scrollBarProxy : new UIStyle.scrollBar(), TScrollBar.VERTICAL, scorllHandler);
				_scrollBar.autoHide = true;
				_scrollBar.addEventListener(TComponentEvent.SHOW, onScorllBarShow);
				_scrollBar.addEventListener(TComponentEvent.HIDE, onScorllBarHide);
			}
		}

		private function initScrollBar():void
		{
			if (_useScrollBar)
			{
				_scrollBar.pageSize = this.height;
				_scrollBar.height = this.height;
				_scrollBar.lineSize = _defaultLineSize;
				if (!_scrollBarProxy)
				{
					_scrollBar.x = this.width - _scrollBar.width;
					_scrollBar.y = 0;
					this.addChild(_scrollBar);
				}
			}
		}

		/**
		 * 移动滚动条到顶层
		 *
		 */
		protected function moveScrollBarToTop():void
		{
			_scrollBar.parent.setChildIndex(_scrollBar, _scrollBar.parent.numChildren - 1);
		}

		/**
		 * 滚动条显示隐藏事件
		 * @param event
		 *
		 */
		private function onScorllBarShow(event:Event):void
		{
			dispatchEvent(new TScrollPanelEvent(TScrollPanelEvent.SCORLLBAR_SHOW));
		}

		private function onScorllBarHide(event:Event):void
		{
			dispatchEvent(new TScrollPanelEvent(TScrollPanelEvent.SCORLLBAR_HIDE));
		}

		/**
		 * 设置滚动区域
		 * @param value
		 *
		 */
		public function set contentPanel(value:DisplayObjectContainer):void
		{
			if (!(value is TAutoSizeComponent)) //在外面包一层TAutoSizeConponent，防止scrollRect相互冲突
			{
				var _contaner:TAutoSizeComponent = new TAutoSizeComponent();
				_contaner.addChild(value);
				value = _contaner;
			}
			if (_contentPanel == value)
				return;
			if (_contentPanel)
				_contentPanel.removeEventListener(Event.RESIZE, onContentPanelResize);
			if (!value.parent && value != this)
				this.addChild(value);
			_contentPanel = TAutoSizeComponent(value);
			_contentPanel.scrollRect = new Rectangle(0, 0, this.width, this.height);
			_contentPanel.addEventListener(Event.RESIZE, onContentPanelResize);
			updateMaximun();
		}

		public function get contentPanel():DisplayObjectContainer
		{
			return _contentPanel;
		}

		/**
		 * 添加控件至 contentPanel 中
		 * 被添加的控件的大小变化将触发滚动条验证
		 * @param obj
		 *
		 */
		public function addToContentPanel(obj:DisplayObject):void
		{
			contentPanel.addChild(obj);
		}

		private function onContentPanelResize(event:Event):void
		{
			updateMaximun();
		}

		/**
		 * 更新滚动位置
		 *
		 */
		private function update():void
		{
			var sRect:Rectangle = _contentPanel.scrollRect;
			if (!sRect)
			{
				sRect = new Rectangle(0, offset, this.width, this.height);
			}
			else
			{
				sRect.y = offset;
			}
			_contentPanel.scrollRect = sRect;
		}

		/**
		 * 更新滚动最大值
		 *
		 */
		private function updateMaximun():void
		{
			maximun = Math.max(0, _contentPanel.height - this.height);
			if (_contentPanel.height - _contentPanel.scrollRect.y < this.height)
			{
				var sRect:Rectangle = _contentPanel.scrollRect;
				sRect.y = _contentPanel.height - this.height;
				if (sRect.y < 0)
				{
					sRect.y = 0;
				}
				_contentPanel.scrollRect = sRect;
			}
		}

		private function scorllHandler(event:Event):void
		{
			_offset = _scrollBar.value;
			update();
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			if (_scrollBar)
				offset -= event.delta * _scrollBar.lineSize;
		}

		public function set offset(value:Number):void
		{
			if (_useScrollBar)
			{
				_scrollBar.value = value;
			}
			_offset = Math.max(0, value);
			_offset = Math.min(maximun, _offset);
			update();
		}

		public function get offset():Number
		{
			return _offset;
		}

		public function set maximun(value:Number):void
		{
			if (_useScrollBar)
			{
				_scrollBar.maximum = value;
			}
			_maximun = value;
		}

		public function get maximun():Number
		{
			return _maximun;
		}

		public function set scorllBarProxy(value:*):void
		{
			if (_scrollBar)
			{
				this.removeChild(_scrollBar);
			}
			_scrollBarProxy = value;
			_scrollBar = new TScrollBar(null, _scrollBarProxy, TScrollBar.VERTICAL, scorllHandler);
			_scrollBar.pageSize = this.height;
			_scrollBar.height = this.height;
			_scrollBar.lineSize = _defaultLineSize;
			updateMaximun();
		}

		public function get scrollBar():TScrollBar
		{
			return _scrollBar;
		}

//		override public function invalidateSize(changed:Boolean = false):void
//		{
//			super.invalidateSize();
//
////			this.measureChildren();
//		}

		override protected function implementSize(width:Number, height:Number):void
		{
			_contentPanel.scrollRect = new Rectangle(0, offset, width, height);
			initScrollBar();
			updateMaximun();
			this.setProxySize(this.width, this.height, false);
		}
	}
}
