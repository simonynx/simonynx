package tempest.ui.components.textFields
{
	import com.riaidea.text.RichTextField;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tempest.ui.UIStyle;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TScrollBar;
	import tempest.ui.helper.TextFieldHelper;

	public class TRichTextArea extends TComponent
	{
		private var _rtextField:RichTextField;

		protected var scrollBar:TScrollBar;
		protected var _scrollBarProxy:*;
		private var _autoScorll:Boolean = false;
		private var autoPos:Boolean = false;
		private var added:Boolean = false;

		public function TRichTextArea(constraints:Object = null, rtextField:RichTextField = null, scrollBarProxy:* = null)
		{
			this._scrollBarProxy = scrollBarProxy;

			if (!this._scrollBarProxy)
			{
				autoPos = true;
				this._scrollBarProxy = new UIStyle.scrollBar();
			}
			scrollBar = new TScrollBar(null, this._scrollBarProxy, TScrollBar.VERTICAL, onScorllBarScorll);
			scrollBar.autoHide = true;
			if (!rtextField)
				rtextField = new TRichTextField();
			super(constraints, rtextField);

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
			this._rtextField = rtextField;
			this._rtextField.textfield.addEventListener(Event.CHANGE, onChange);
			this._rtextField.textfield.addEventListener(Event.SCROLL, onTextScorll);
			this.addEventListener(Event.RESIZE, onResize);
		}

		override protected function invalidate():void
		{
			super.invalidate();
		}

		override protected function draw():void
		{
			updateScrollbar();

			this._rtextField.textfield.removeEventListener(Event.SCROLL, onTextScorll);
			_rtextField.textfield.scrollV = Math.round(scrollBar.value);
			this._rtextField.textfield.addEventListener(Event.SCROLL, onTextScorll);
		}

		private function onResize(event:Event):void
		{
			if (autoPos)
			{
				scrollBar.x = width - scrollBar.width - 4;
				scrollBar.y = 4;
				scrollBar.height = height - 8;
			}
			else
			{
				scrollBar.height = height;
			}

			invalidate();
		}

		public override function invalidateSize(changed:Boolean = false):void
		{
			_rtextField.setSize(_width, _height);
			if (autoPos)
			{
				scrollBar.x = width - scrollBar.width - 4;
				scrollBar.y = 4;
				scrollBar.height = height - 8;
			}
			else
			{
				scrollBar.height = height;
			}
			super.invalidateSize();
		}

		private var delayCount:int = 0;

		private function onTextScorll(event:Event):void
		{
			/*************************************************
			 *
			 * 兼容版本 10.3.183.5 延时一帧设置滚动条位置
			 *
			 * ***********************************************/
			if (Capabilities.version.split(" ")[1] == "10,3,183,5" && _rtextField.textfield.filters != null)
			{
				this.addEventListener(Event.ENTER_FRAME, delaySetScrollValue);
			}
			else
			{
				scrollBar.value = _rtextField.textfield.scrollV;
			}
		}

		private function delaySetScrollValue(event:Event):void
		{
			delayCount++;
			if (delayCount == 1)
			{
				delayCount = 0;
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				scrollBar.value = _rtextField.textfield.scrollV;
			}
		}

		private function onScorllBarScorll(event:Event):void
		{
			this._rtextField.textfield.removeEventListener(Event.SCROLL, onTextScorll);
			_rtextField.textfield.scrollV = Math.round(scrollBar.value);
			this._rtextField.textfield.addEventListener(Event.SCROLL, onTextScorll);
		}

		public function onMouseWheel(event:MouseEvent):void
		{
			scrollBar.value = _rtextField.textfield.scrollV;
		}

		protected function onChange(event:Event):void
		{
			invalidate();
		}

		public function append(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{
			_rtextField.append(newText, newSprites, autoWordWrap, format);
			added = true;

			if (Capabilities.version.split(" ")[1] == "10,3,183,5" && _rtextField.textfield.filters != null)
			{
				invalidateNow();
			}
			else
			{
				invalidate();
			}
		}

		public function append2(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{
			TextFieldHelper.append2(_rtextField, newText, newSprites, autoWordWrap, format);
			added = true;

			if (Capabilities.version.split(" ")[1] == "10,3,183,5" && _rtextField.textfield.filters != null)
			{
				invalidateNow();
			}
			else
			{
				invalidate();
			}
		}

		public function replace(startIndex:int, endIndex:int, newText:String, newSprites:Array = null):void
		{
			_rtextField.replace(startIndex, endIndex, newText, newSprites);
			added = true;
			invalidate();
		}

		public function clear():void
		{
			_rtextField.clear();
			invalidate();
		}

		public function reset(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{
			_rtextField.clear();
			append(newText, newSprites, autoWordWrap, format);
			invalidateNow();
		}

		public function setToBottom():void
		{
			scrollBar.value = scrollBar.maximum;
			invalidate();
		}

		public function scrollUp(offset:int):void
		{
			scrollBar.value += offset;
			invalidate();
		}

		public function scrollDown(offset:int):void
		{
			scrollBar.value -= offset;
			invalidate();
		}

		/**********************************************
		 *
		 * 为兼容版本 10.3.183.5的修改，延时1帧再获取maxScrollV
		 *
		 *********************************************/

		private var _updateSbarDelayCount:int = 0;

		protected function updateScrollbar():void
		{
			if (Capabilities.version.split(" ")[1] == "10,3,183,5" && _rtextField.textfield.filters != null)
			{
				_updateSbarDelayCount = 0;
				this.addEventListener(Event.ENTER_FRAME, onDelayUpdateScrollBar);
			}
			else
			{
				//普通版本处理
				_updateScrollbar();
			}
		}

		private function _updateScrollbar():void
		{
			if (autoPos)
			{
				if (scrollBar.autoHide && _rtextField.textfield.maxScrollV <= 1)
					_rtextField.setSize(this.width, this.height);
				else
					_rtextField.setSize(this.width - scrollBar.width - 6, this.height);
			}

			var visibleLines:int = _rtextField.textfield.numLines - _rtextField.textfield.maxScrollV + 1;
			//var percent:Number = visibleLines / text.textField.numLines;
			scrollBar.setSliderParams(1, _rtextField.textfield.maxScrollV, _rtextField.textfield.scrollV);
			scrollBar.pageSize = visibleLines;

			if (added && _autoScorll && scrollBar.value != scrollBar.maximum)
			{
				scrollBar.value = scrollBar.maximum;
				added = false;
			}
		}

		private function onDelayUpdateScrollBar(event:Event):void
		{
			_updateSbarDelayCount++;
			if (_updateSbarDelayCount == 3)
			{
				_updateSbarDelayCount = 0;
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				_updateScrollbar();
				this._rtextField.textfield.removeEventListener(Event.SCROLL, onTextScorll);
				_rtextField.textfield.scrollV = Math.round(scrollBar.value);
				this._rtextField.textfield.addEventListener(Event.SCROLL, onTextScorll);
			}
		}

		public function set pageSize(value:int):void
		{
			scrollBar.pageSize = value;
		}

		public function set autoHide(value:Boolean):void
		{
			scrollBar.autoHide = value;
		}

		public function get autoHide():Boolean
		{
			return scrollBar.autoHide;
		}

		public function set autoScorll(value:Boolean):void
		{
			_autoScorll = value;
		}

		public function get richtextField():RichTextField
		{
			return _rtextField;
		}

		public function get text():String
		{
			return _rtextField.text;
		}
	}
}
