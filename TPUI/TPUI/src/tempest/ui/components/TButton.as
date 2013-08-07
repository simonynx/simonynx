package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flashx.textLayout.formats.TextAlign;
	import org.osflash.signals.Signal;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.UIStyle;
	import tempest.utils.Geom;

	/**
	 * ...
	 * @author XXXXX
	 */
	public class TButton extends TComponent
	{
		private const log:ILogger = TLog.getLogger(TButton);
		protected var _bt:SimpleButton;
		private var _text:String;
		private var _upStateLabel:TextField;
		private var _downStateLabel:TextField;
		private var _overStateLabel:TextField;
		private var _clickHandler:Function;
		private var _textEnabled:Boolean;
		private var _pressTrigger:Boolean;
		private var _proxyEnabled:Boolean = true;
		public static const STATE_UP:int = 1 << 0;
		public static const STATE_DOWN:int = 1 << 1;
		public static const STATE_OVER:int = 1 << 2;

		public function TButton(constraints:Object = null, _proxy:SimpleButton = null, text:String = null, clickHandler:Function = null)
		{
			_text = text;
			_clickHandler = clickHandler;
			super(constraints, _proxy);
			invalidateNow();
		}

		override protected function addChildren():void
		{
			super.addChildren();
			if (_proxy)
			{
				_bt = _proxy as SimpleButton;
				checkLabels();
			}
			else
			{
				throw new Error("TButton._proxy is null");
			}
			this.addChild(_bt);
			if (_clickHandler != null)
			{
				this.addEventListener(MouseEvent.CLICK, _clickHandler, false, 0, true);
			}
			this.draw();
		}

		/**
		 * 验证label是否已获取，如果未获取则获取
		 *
		 */
		private function checkLabels():void
		{
			if (text && !_upStateLabel)
			{
				_upStateLabel = getTextField(_bt.upState);
				_downStateLabel = getTextField(_bt.downState);
				_overStateLabel = getTextField(_bt.overState);
			}
		}

		private function getTextField(state:DisplayObject):TextField
		{
			if (!(state is Sprite))
			{
				return null;
			}
			var sp:Sprite = state as Sprite;
			if (sp.numChildren < 2)
			{
				return null;
			}
			return sp.getChildAt(1) as TextField
		}

		/**
		 * 设置某个按钮状态的文本
		 * @param states STATE_UP | STATE_DOWN | STATE_OVER
		 * @param childIndex 文本在该状态中的子级索引
		 * @param str
		 *
		 */
		public function setStateText(states:int, childIndex:int, str:String):void
		{
			var textField:TextField;
			if (states & STATE_UP)
			{
				textField = (_bt.upState as Sprite).getChildAt(childIndex) as TextField;
				textField.text = str;
			}
			if (states & STATE_DOWN)
			{
				textField = (_bt.downState as Sprite).getChildAt(childIndex) as TextField;
				textField.text = str;
			}
			if (states & STATE_OVER)
			{
				textField = (_bt.overState as Sprite).getChildAt(childIndex) as TextField;
				textField.text = str;
			}
		}

		override protected function draw():void
		{
			super.draw();
			if (!_text)
			{
				return;
			}
			checkLabels();
			if (_upStateLabel)
			{
				_upStateLabel.text = _text;
				_downStateLabel.text = _text;
				_overStateLabel.text = _text;
			}
			else
			{
				if (_text)
					log.warn("由于不包含文本框资源，TButton 不能设置text, text = " + _text);
			}
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			this.invalidate();
		}

		public function set pressTrigger(value:Boolean):void
		{
			if (_pressTrigger == value)
				return;
			if (_pressTrigger = value)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 100);
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		private var _pressTimer:Timer;
		/**
		 * 是否在等待连续触发状态
		 */
		private var waiting:Boolean = true;
		/**
		 * 加点次数，提速后归0
		 */
		private var addCount:int = 0; //
		/**
		 * 最大提升速度等待次数 （常量）
		 */
		private const maxSpeedUpCount:int = 6;
		private const waitTime:int = 500;
		private const startDelay:int = 150;

		private function onMouseDown(event:MouseEvent):void
		{
//			event.stopImmediatePropagation();
//			this.dispatchEvent(event);
			if (!_pressTimer)
			{
				_pressTimer = new Timer(waitTime);
				_pressTimer.addEventListener(TimerEvent.TIMER, onPressTimer);
				_pressTimer.start();
				addCount = 0;
				waiting = true;
			}
		}

		private function onMouseUp(event:MouseEvent):void
		{
			if (_pressTimer)
			{
				_pressTimer.stop();
				_pressTimer.removeEventListener(TimerEvent.TIMER, onPressTimer);
				_pressTimer = null;
			}
		}

		private function onRollOut(event:MouseEvent):void
		{
			onMouseUp(null);
		}

		private function onPressTimer(event:TimerEvent):void
		{
			if (waiting)
			{
				waiting = false;
				_pressTimer.delay = startDelay;
			}
			++addCount;
			if (addCount >= maxSpeedUpCount)
			{
				addCount = 0;
				if (_pressTimer.delay > 30)
					_pressTimer.delay /= 2;
			}
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, false, false, this.mouseX, this.mouseY, this));
		}

		/**
		 * 设置资源可用状态
		 * 不会影响到该控件上的click事件的触发
		 * @param value
		 *
		 */
		public function set proxyEnabled(value:Boolean):void
		{
			if (_proxyEnabled == value)
			{
				return;
			}
			_proxyEnabled = value;
			_bt.mouseEnabled = value;
			if (value)
			{
				_bt.filters = null;
			}
			else
			{
				_bt.filters = [UIStyle.disableFilter];
			}
		}

		public function get proxyEnabled():Boolean
		{
			return _proxyEnabled;
		}

		override public function set enabled(value:Boolean):void
		{
			if (super.enabled == value)
			{
				return;
			}
			super.enabled = value;
			if (!super.enabled)
			{
				this.setFilter(UIStyle.disableFilter);
				this.mouseEnabled = this.mouseChildren = false;
				onMouseUp(null);
			}
			else
			{
				this.removeFilters();
				this.mouseEnabled = this.mouseChildren = true;
			}
		}
	}
}
