package tempest.ui.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import tempest.ui.TPUGlobals;
	import tempest.ui.UIStyle;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.events.TComponentEvent;

	[Event(name = "change", type = "flash.events.Event")]
	public class TScrollBar extends TComponent
	{
		protected const DELAY_TIME:int = 500;
		protected const REPEAT_TIME:int = 100;
		protected const UP:String = "up";
		protected const DOWN:String = "down";
		//protected var _autoHide:Boolean = false;
		protected var _upButton:TButton;
		protected var _downButton:TButton;
		protected var _scrollSlider:TScrollSlider;
		protected var _orientation:String;
		protected var _lineSize:int = 1;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		protected var _shouldRepeat:Boolean = false;
		protected var _defaultHandler:Function;
		protected var _autoHideScorllBar:Boolean = false;
		private var _lenthFix:Number = 2;
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";

		/**
		 * Constructor
		 * @param orientation Whether this is a vertical or horizontal slider.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function TScrollBar(constraints:Object = null, _proxy:* = null, orientation:String = TScrollBar.VERTICAL, defaultHandler:Function = null)
		{
			super(constraints, _proxy);
			_orientation = orientation;
			_defaultHandler = defaultHandler;
			if (_defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
//			addEventListener("resize", onResize);
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			if (_proxy)
			{
				_scrollSlider = new TScrollSlider(null, _proxy, _orientation, onChange);
				_upButton = new TButton(null, _proxy.btn_up);
				_downButton = new TButton(null, _proxy.btn_down);
			}
			if (!_scrollSlider || !_upButton || !_downButton)
			{
				throw new Error("Proxy Error");
			}
			if (!_scrollSlider)
			{
				_scrollSlider = new TScrollSlider(null, null, _orientation, onChange);
				this.addChild(_scrollSlider);
			}
//			if(!_upButton)
//			{
//				_upButton = new TButton(null);
//				_upButton.setSize(10, 10);
//				var upArrow:Shape = new Shape();
//				if(_orientation == TSlider.VERTICAL)
//				{
//					upArrow.graphics.beginFill(UIStyle.DROPSHADOW, 0.5);
//					upArrow.graphics.moveTo(5, 3);
//					upArrow.graphics.lineTo(7, 6);
//					upArrow.graphics.lineTo(3, 6);
//					upArrow.graphics.endFill();
//				}
//				else
//				{
//					upArrow.graphics.beginFill(UIStyle.DROPSHADOW, 0.5);
//					upArrow.graphics.moveTo(3, 5);
//					upArrow.graphics.lineTo(6, 7);
//					upArrow.graphics.lineTo(6, 3);
//					upArrow.graphics.endFill();
//				}
//				
//				_upButton.addChild(upArrow);
//				this.addChild(_upButton);
//			}
//			
//			if(!_downButton)
//			{
//				_downButton = new TButton(null);
//				_downButton.setSize(10, 10);
//				var downArrow:Shape = new Shape();
//				
//				if(_orientation == TSlider.VERTICAL)
//				{
//					downArrow.graphics.beginFill(UIStyle.DROPSHADOW, 0.5);
//					downArrow.graphics.moveTo(5, 7);
//					downArrow.graphics.lineTo(7, 4);
//					downArrow.graphics.lineTo(3, 4);
//					downArrow.graphics.endFill();
//				}
//				else
//				{
//					downArrow.graphics.beginFill(UIStyle.DROPSHADOW, 0.5);
//					downArrow.graphics.moveTo(7, 5);
//					downArrow.graphics.lineTo(4, 7);
//					downArrow.graphics.lineTo(4, 3);
//					downArrow.graphics.endFill();
//				}
//				
//				_downButton.addChild(downArrow);
//				this.addChild(downArrow);
//			}
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
		}

		/**
		 * Initializes the component.
		 */
		protected override function init():void
		{
			super.init();
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			if (_autoHideScorllBar)
			{
				if (max <= min)
					this.visible = false;
				else
					this.visible = true;
			}
			else
			{
				this.visible = true;
			}
			_scrollSlider.setSliderParams(min, max, value);
		}

//		/**
//		 * Sets the percentage of the size of the thumb button.
//		 */
//		public function setThumbPercent(value:Number):void
//		{
//			_scrollSlider.setThumbPercent(value);
//		}
		/**
		 * Draws the visual ui of the component.
		 */
		override protected function draw():void
		{
			super.draw();
//			if(_orientation == TSlider.VERTICAL)
//			{
//				_scrollSlider.x = 0;
//				_scrollSlider.y = 10;
//				_scrollSlider.width = 10;
//				_scrollSlider.height = _height - 20;
//				_downButton.x = 0;
//				_downButton.y = _height - 10;
//			}
//			else
//			{
//				_scrollSlider.x = 10;
//				_scrollSlider.y = 0;
//				_scrollSlider.width = _width - 20;
//				_scrollSlider.height = 10;
//				_downButton.x = _width - 10;
//				_downButton.y = 0;
//			}
//			
			//_scrollSlider.draw();
//			if(_autoHide)
//			{
//				visible = _scrollSlider.thumbPercent < 1.0;
//			}
//			else
//			{
//				visible = true;
//			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
//		/**
//		 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
//		 */
//		public function set autoHide(value:Boolean):void
//		{
//			_autoHide = value;
//			invalidate();
//		}
//		public function get autoHide():Boolean
//		{
//			return _autoHide;
//		}
		/**
		 * Sets / gets the current value of this scroll bar.
		 */
		public function set value(v:Number):void
		{
			_scrollSlider.value = v;
		}

		public function get value():Number
		{
			return _scrollSlider.value;
		}

		/**
		 * Sets / gets the minimum value of this scroll bar.
		 */
		public function set minimum(v:Number):void
		{
			_scrollSlider.minimum = v;
		}

		public function get minimum():Number
		{
			return _scrollSlider.minimum;
		}

		/**
		 * Sets / gets the maximum value of this scroll bar.
		 */
		public function set maximum(v:Number):void
		{
			_scrollSlider.maximum = v;
			if (_autoHideScorllBar)
			{
				if (_scrollSlider.maximum == _scrollSlider.minimum)
				{
					this.visible = false;
				}
				else
				{
					this.visible = true;
				}
			}
			else
			{
				this.visible = true;
			}
		}

		public function get autoHide():Boolean
		{
			return _autoHideScorllBar;
		}

		public function set autoHide(value:Boolean):void
		{
			_autoHideScorllBar = value;
		}

		public function get maximum():Number
		{
			return _scrollSlider.maximum;
		}

		/**
		 * Sets / gets the amount the value will change when up or down buttons are pressed.
		 */
		public function set lineSize(value:int):void
		{
			_scrollSlider.lineSize = value;
			_lineSize = value;
		}

		public function get lineSize():int
		{
			return _lineSize;
		}

		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_scrollSlider.pageSize = value;
			invalidate();
		}

		public function get pageSize():int
		{
			return _scrollSlider.pageSize;
		}

		public function set siliderTip(value:TToolTip):void
		{
			_scrollSlider.siliderTip = value;
		}

		public function get siliderTip():TToolTip
		{
			return _scrollSlider.siliderTip;
		}

		public function set siliderTipString(value:String):void
		{
			_scrollSlider.siliderTipString = value;
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			TPUGlobals.app.signals.mouseUp.add(onMouseGoUp);
		}

		protected function goUp():void
		{
			_scrollSlider.value -= _lineSize;
//			if(_orientation == TScrollBar.HORIZONTAL)
//			{
//				_scrollSlider.value -= _lineSize;
//			}
//			else
//			{
//				_scrollSlider.value += _lineSize;
//			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			TPUGlobals.app.signals.mouseUp.add(onMouseGoUp);
		}

		protected function goDown():void
		{
			_scrollSlider.value += _lineSize;
//			if(_orientation == TScrollBar.HORIZONTAL)
//			{
//				_scrollSlider.value += _lineSize;
//			}
//			else
//			{
//				_scrollSlider.value -= _lineSize;
//			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}

		protected function onChange(event:Event):void
		{
			dispatchEvent(event);
		}

		protected function onDelayComplete(event:TimerEvent):void
		{
			if (_shouldRepeat)
			{
				_repeatTimer.start();
			}
		}

		protected function onRepeat(event:TimerEvent):void
		{
			if (_direction == UP)
			{
				goUp();
			}
			else
			{
				goDown();
			}
		}

		override protected function implementSize(width:Number, height:Number):void
		{
			if (_orientation == TSlider.VERTICAL)
			{
				_scrollSlider.slidHeight = this.height - _downButton.height - _upButton.height + _lenthFix;
				_downButton.y = this.height - _downButton.height;
			}
			else
			{
				_scrollSlider.slidWidth = this.width - _downButton.width - _upButton.width + _lenthFix;
				_downButton.x = this.width - _downButton.width;
			}
		}

		//重载invalidateSize，避免默认的修改到proxy的宽高
//		override public function invalidateSize(changed:Boolean = false):void
//		{
//			if (hasEventListener("resize"))
//			{
//				this.dispatchEvent(new Event("resize"));
//			}
//		}

//		private function onResize(event:Event):void
//		{
//
//		}
	}
}
