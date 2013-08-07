package tempest.ui.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import tempest.ui.TPUGlobals;
	import tempest.ui.UIStyle;
	import tempest.ui.components.tips.TToolTip;

	[Event(name = "change", type = "flash.events.Event")]
	/**
	 *
	 * @author 趣游福州
	 */
	public class TSlider extends TComponent
	{
		/**
		 *
		 * @default
		 */
		protected var _handle:TButton;
		/**
		 *
		 * @default
		 */
		protected var _back:MovieClip;
		/**
		 *
		 * @default
		 */
		protected var _sliderArea:MovieClip;
		/**
		 *
		 * @default
		 */
		protected var _backClick:Boolean = true;
		/**
		 *
		 * @default
		 */
		protected var _value:Number = 0;
		/**
		 *
		 * @default
		 */
		protected var _max:Number = 100;
		/**
		 *
		 * @default
		 */
		protected var _min:Number = 0;
		/**
		 *
		 * @default
		 */
		protected var _orientation:String;
		/**
		 *
		 * @default
		 */
		protected var _tick:Number = 0.01;
		/**
		 *
		 * @default
		 */
		protected var _lineSize:Number = 1;
		/**
		 *
		 */
		protected var _dragStep:Number = 0;
		/**
		 *
		 * @default
		 */
		public static const HORIZONTAL:String = "horizontal";
		/**
		 *
		 * @default
		 */
		public static const VERTICAL:String = "vertical";

		/**
		 * Constructor
		 * @param orientation Whether the slider will be horizontal or vertical.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function TSlider(constraints:Object = null, _proxy:* = null, orientation:String = TSlider.HORIZONTAL, defaultHandler:Function = null)
		{
			super(constraints, _proxy);
			_orientation = orientation;
			if (defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
//			if(_orientation == HORIZONTAL)
//			{
//				setSize(100, 10);
//			}
//			else
//			{
//				setSize(10, 100);
//			}
			this.value = this._min;
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			if (_proxy)
			{
				_back = _proxy.mc_bg as MovieClip || new MovieClip(); //用于伸展背景
				_handle = new TButton(null, _proxy.btn_thumb);
				_sliderArea = _proxy.mc_bg2 as MovieClip; //滑动范围以其位置和宽高作参考
				_sliderArea.mouseEnabled = false;
			}
			if (!_back || !_handle || !_sliderArea)
			{
				throw new Error("Proxy Error");
			}
//			if(!_back)
//			{
//				_back = new MovieClip();
//				this.addChild(_back);
//			}
//			if(!_handle)
//			{
//				_handle = new TButton(null);
//				this.addChild(_handle);
//			}
			//_back.filters = [getShadow(2, true)];
			if (_backClick)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//_handle.filters = [getShadow(1)];
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			_handle.buttonMode = true;
			_handle.useHandCursor = true;
			//this.validateNow();
		}

//		/**
//		 * Draws the back of the slider.
//		 */
//		protected function drawBack():void
//		{
//			_back.graphics.clear();
//			_back.graphics.beginFill(UIStyle.BACKGROUND);
//			_back.graphics.drawRect(0, 0, _width, _height);
//			_back.graphics.endFill();
//			
//			
//		}
//		
//		/**
//		 * Draws the handle of the slider.
//		 */
//		protected function drawHandle():void
//		{
//			_handle.graphics.clear();
//			_handle.graphics.beginFill(UIStyle.BUTTON_FACE);
//			if(_orientation == HORIZONTAL)
//			{
//				_handle.graphics.drawRect(1, 1, _height - 2, _height - 2);
//			}
//			else
//			{
//				_handle.graphics.drawRect(1, 1, _width - 2, _width - 2);
//			}
//			_handle.graphics.endFill();
//			positionHandle();
//		}
		/**
		 * Adjusts value to be within minimum and maximum.
		 */
		protected function correctValue():void
		{
			if (_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}

		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if (_orientation == HORIZONTAL)
			{
				range = _sliderArea.width - _handle.width;
				if (_max == _min)
				{
					_handle.x = _sliderArea.x;
				}
				else
				{
					_handle.x = (_value - _min) / (_max - _min) * range + _sliderArea.x;
				}
				_handle.y = _sliderArea.y;
			}
			else
			{
				range = _sliderArea.height - _handle.height;
				if (_max == _min)
				{
					_handle.y = _sliderArea.y;
				}
				else
				{
					_handle.y = (_value - _min) / (_max - _min) * range + _sliderArea.y;
				}
				_handle.x = _sliderArea.x;
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		 * Draws the visual ui of the component.
		 */
		override protected function draw():void
		{
			super.draw();
//			drawBack();
//			drawHandle();
		}

		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onBackClick(event:MouseEvent):void
		{
			if (_orientation == HORIZONTAL)
			{
				_handle.x = mouseX - _handle.width / 2;
				_handle.x = Math.max(_handle.x, _sliderArea.x);
				_handle.x = Math.min(_handle.x, _sliderArea.x + _sliderArea.width - _handle.width);
				_value = (_handle.x - _sliderArea.x) / (_sliderArea.width - _handle.width) * (_max - _min) + _min;
				_handle.y = _sliderArea.y;
			}
			else
			{
				_handle.y = mouseY - _handle.height / 2;
				_handle.y = Math.max(_handle.y, _sliderArea.y);
				_handle.y = Math.min(_handle.y, _sliderArea.y + _sliderArea.height - _handle.height);
				_value = (_handle.y - _sliderArea.y) / (_sliderArea.height - _handle.height) * (_max - _min) + _min;
				_handle.x = _sliderArea.x;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrag(event:MouseEvent):void
		{
			TPUGlobals.app.signals.mouseUp.add(onDrop);
			TPUGlobals.app.signals.mouseMove.add(onSlide);
			if (_orientation == HORIZONTAL)
			{
				_handle.startDrag(false, new Rectangle(_sliderArea.x, _sliderArea.y, _sliderArea.width - _handle.width, 0));
			}
			else
			{
				_handle.startDrag(false, new Rectangle(_sliderArea.x, _sliderArea.y, 0, Math.floor(_sliderArea.height - _handle.height)));
			}
		}

		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			TPUGlobals.app.signals.mouseUp.remove(onDrop);
			TPUGlobals.app.signals.mouseMove.remove(onSlide);
			stopDrag();
		}

		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onSlide(event:MouseEvent):void
		{
			//将sprite位置赋值给_x,_y
//			_handle.move(_handle.$x, _handle.$y);
			var oldValue:Number = _value;
			var oldHandlePos:Point = new Point(_handle.x, _handle.y);
			if (_orientation == HORIZONTAL)
			{
				_value = (_handle.x - _sliderArea.x) / Math.floor(_sliderArea.width - _handle.width) * (_max - _min) + _min;
			}
			else
			{
				_value = (_handle.y - _sliderArea.y) / Math.floor(_sliderArea.height - _handle.height) * (_max - _min) + _min;
			}
			if (_dragStep) //如果有设置滑动步长，根据步长调整value
			{
				if (_value >= _max)
				{
					_value = _max;
				}
				else
				{
					_value = int(_value / _dragStep) * _dragStep;
				}
			}
			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			else
			{
				//根据当前步长计算滑块位置
				if (_orientation == HORIZONTAL)
				{
					_handle.x = oldHandlePos.x;
				}
				else
				{
					_handle.y = oldHandlePos.y;
				}
			}
		}

		protected function onMouseWheel(event:MouseEvent):void
		{
			var oldValue:Number = value;
			value -= event.delta * _lineSize;
			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Sets / gets whether or not a click on the background of the slider will move the handler to that position.
		 */
		public function set backClick(b:Boolean):void
		{
			_backClick = b;
			invalidate();
		}

		/**
		 *
		 * @return
		 */
		public function get backClick():Boolean
		{
			return _backClick;
		}

		/**
		 * Sets / gets the current value of this slider.
		 */
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			positionHandle();
		}

		/**
		 *
		 * @return
		 */
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}

		/**
		 * Gets the value of the slider without rounding it per the tick value.
		 */
		public function get rawValue():Number
		{
			return _value;
		}

		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
		}

		/**
		 *
		 * @return
		 */
		public function get maximum():Number
		{
			return _max;
		}

		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}

		/**
		 *
		 * @return
		 */
		public function get minimum():Number
		{
			return _min;
		}

		/**
		 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number.
		 */
		public function set tick(t:Number):void
		{
			_tick = t;
		}

		/**
		 *
		 * @return
		 */
		public function get tick():Number
		{
			return _tick;
		}

		/**
		 * 滚动步长
		 * @param value
		 *
		 */
		public function set lineSize(value:Number):void
		{
			_lineSize = value;
		}

		/**
		 * 滚动步长
		 * @return
		 */
		public function get lineSize():Number
		{
			return _lineSize;
		}

		/**
		 * 拖动步长
		 * @param value
		 *
		 */
		public function set dragStep(value:Number):void
		{
			_dragStep = value;
		}

		/**
		 * 拖动步长
		 * @return
		 *
		 */
		public function get dragStep():Number
		{
			return _dragStep;
		}

		public function set slidHeight(value:Number):void
		{
			_back.graphics.clear();
//			_sliderArea.graphics.clear();
			var oldBackHeight:Number = _back.height;
			_back.height = value;
			_sliderArea.height += _back.height - oldBackHeight;
			positionHandle();
		}

		public function set slidWidth(value:Number):void
		{
			var oldBackWidth:int = _back.width;
			_back.width = value;
			_sliderArea.width += _back.width - oldBackWidth;
			positionHandle();
		}

		public function set siliderTip(value:TToolTip):void
		{
			if (!_handle.alwaysShowTip)
			{
				_handle.alwaysShowTip = true;
			}
			_handle.toolTip = value; //new TSimpleToolTip(new UIStyle.tipBkSkin(), true, 0);
		}

		public function get siliderTip():TToolTip
		{
			return _handle.toolTip; //new TSimpleToolTip(new UIStyle.tipBkSkin(), true, 0);
		}

		public function set siliderTipString(value:String):void
		{
			_handle.toolTipString = value;
			_handle.toolTip.data = value;
		}

		public function get handle():TButton
		{
			return _handle;
		}
	}
}
