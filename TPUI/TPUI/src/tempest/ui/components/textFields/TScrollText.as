package tempest.ui.components.textFields
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import tempest.ui.components.TComponent;

	public class TScrollText extends TComponent
	{
		private var _textField:TextField;
		private var _textFieldTestLen:TextField; //用于获得文本长度
		protected var _padding:Number;
		private var _timer:Timer;
		private var _speed:Number = 1;

		public function TScrollText(constraints:Object = null, _proxy:* = null)
		{
			if (_proxy == null)
				_proxy = this;
			super(constraints, _proxy);
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;

			this.addChild(_textField);

			_textFieldTestLen = new TextField();
			_textFieldTestLen.autoSize = TextFieldAutoSize.LEFT;
			_textFieldTestLen.mouseEnabled = false;
//			this.addEventListener(Event.RESIZE, onResize);
			_timer = new Timer(1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		private function onTimer(event:TimerEvent):void
		{
			var oldx:Number = _textField.scrollRect.x;
			_textField.scrollRect = new Rectangle(oldx + _speed, 0, this.width - _padding * 2, this.height);

			if (_textField.scrollRect.x >= _textField.textWidth)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				_timer.stop();
			}
		}

		public function setText(text:String):void
		{
			_textField.x = _padding;
			_textField.y = _padding;
			GTweener.removeTweens(this);
			//获得文本长度
			_textFieldTestLen.text = text;
			var textWidth:Number = _textFieldTestLen.width;
			//
			_textField.text = text;
			_textField.scrollRect = new Rectangle(-this.width + _padding * 2, 0, this.width - _padding * 2, this.height);

			_timer.start();
		}

		public function set defaultTextFormat(value:TextFormat):void
		{
			_textField.defaultTextFormat = value;
			_textFieldTestLen.defaultTextFormat = value;
		}

		public function set textFilters(value:Array):void
		{
			_textField.filters = value;
			_textFieldTestLen.filters = value;
		}
	}
}
