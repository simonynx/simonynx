package tempest.ui.components.textFields
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import tempest.ui.UIStyle;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TScrollBar;


	public class TTextArea extends TComponent
	{
		protected var scrollBar:TScrollBar;
		private var _textField:TextField;

		protected var _scrollBarProxy:*;
		private var _autoScorll:Boolean = true;
		private var autoPos:Boolean = false;

		public function TTextArea(constraints:Object = null, _proxy:* = null, _scrollBarProxy:* = null)
		{
			this._scrollBarProxy = _scrollBarProxy;
			if (!this._scrollBarProxy)
			{
				autoPos = true;
				this._scrollBarProxy = new UIStyle.scrollBar();
			}
			//TODO:添加在init，addChildren中要用到的初始化

			_textField = _proxy;
			super(constraints, _textField);

			if (autoPos)
			{
				scrollBar.x = width - scrollBar.width - 4;
				scrollBar.y = 4;
				scrollBar.height = height - 8;
				this.addChild(scrollBar);
			}
			else
			{
				scrollBar.height = height;
			}
			scrollBar.autoHide = true;
			//this.pageSize = 2;
		}

		public function get textField():TextField
		{
			return _textField;
		}

		override protected function addChildren():void
		{
			_textField.addEventListener(Event.SCROLL, onTextScorll);
			scrollBar = new TScrollBar(null, _scrollBarProxy, TScrollBar.VERTICAL, onScorllBarScorll);
			this.addEventListener("resize", onResize);

			scrollBar.x = width - scrollBar.width - 4;
			scrollBar.y = 0;
			scrollBar.setSize(scrollBar.width, height);

			this.addChild(scrollBar);
			//			updateScrollbar();

			invalidScrollBar();

			super.addChildren();
		}

		override protected function draw():void
		{
			super.draw();
			updateScrollbar();
			if (_autoScorll && scrollBar.value != scrollBar.maximum)
			{
				scrollBar.value = scrollBar.maximum;
			}
		}

		private function onResize(event:Event):void
		{
			scrollBar.x = width - scrollBar.width - 4;
			scrollBar.y = 0;
			scrollBar.setSize(scrollBar.width, height);
		}
		private var _scrollBarValid:Boolean = true;

		private var _curFTimes:int = 0;
		private static const maxFTimes:int = 2;

		private function invalidScrollBar():void
		{
			if (_scrollBarValid)
			{
				_scrollBarValid = false;
				this.addEventListener(Event.ENTER_FRAME, updateScrollbarDelay);
			}
		}

		/**
		 * Waits one more frame before updating scroll bar.
		 * It seems that numLines and maxScrollV are not valid immediately after changing a TextField's size.
		 */
		private function updateScrollbarDelay(event:Event):void
		{
			++_curFTimes;
			if (_curFTimes >= maxFTimes)
			{
				_scrollBarValid = true;
				_curFTimes = 0;
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				updateScrollbar();
			}
		}

		private function onTextScorll(event:Event):void
		{
			scrollBar.value = textField.scrollV;
		}

		private function onScorllBarScorll(event:Event):void
		{
			removeEventListener(Event.SCROLL, onTextScorll);
			textField.scrollV = Math.round(scrollBar.value);
			addEventListener(Event.SCROLL, onTextScorll);
		}

		public function onMouseWheel(event:MouseEvent):void
		{
			scrollBar.value = textField.scrollV;
		}

//		protected override function onChange(event:Event):void
//		{
////			super.onChange(event);
//			invalidate();
//		}

		protected function updateScrollbar():void
		{
			if (autoPos)
			{
				if (scrollBar.autoHide && textField.maxScrollV <= 1)
				{
					textField.width = this.width;
				}
				else
				{
					textField.width = this.width - scrollBar.width - 6;
				}
			}
//			var percent:Number = visibleLines / text.textField.numLines;
			this.addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				var visibleLines:int = textField.numLines - textField.maxScrollV + 1;
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				scrollBar.setSliderParams(1, textField.maxScrollV, textField.scrollV);
				scrollBar.pageSize = visibleLines;
			});
		}

		public function set pageSize(value:int):void
		{
			scrollBar.pageSize = value;
		}

		public function set text(t:String):void
		{
			_textField.text = t;
			invalidate();
		}

		public function set autoHide(value:Boolean):void
		{
			scrollBar.autoHide = value;
		}

		public function get autoHideScorllBar():Boolean
		{
			return scrollBar.autoHide;
		}

		public function set autoScorll(value:Boolean):void
		{
			_autoScorll = value;
		}
	}
}
