package tempest.ui.components
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import tempest.ui.UIStyle;

	/**
	 * ...
	 * @author
	 */
	public class TLableProgressBar extends TComponent
	{
		private var _tf2:TextField;
		private var _tf:TextField;
		protected var _value:Number = 0;
		protected var _max:Number = 1;
		protected var _defaultText:String = "";

		public function TLableProgressBar(constraints:Object = null, defaultText:String = "")
		{
			_defaultText = defaultText;
			super(constraints);
			invalidateNow();
		}

		override protected function init():void
		{
			super.init();
			mouseChildren = mouseEnabled = false;
		}

		override protected function addChildren():void
		{
			_height = 18;
			var _tformat:TextFormat = new TextFormat(UIStyle.fontName, 6);
			_tf = new TextField();
			_tf.defaultTextFormat = _tformat;
			_tf.height = _height;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = 0xffffff;
			_tf.text = _defaultText;
			addChild(_tf);
			this._proxy = _tf;
		}

		override protected function draw():void
		{
			super.draw();
			measureChildren();
		}

		public function set maximum(m:Number):void
		{
			_max = m;
			_value = Math.min(_value, _max);
			update();
		}

		public function get maximum():Number
		{
			return _max;
		}

		public function set value(v:Number):void
		{
			_value = Math.min(v, _max);
			update();
		}

		public function get value():Number
		{
			return _value;
		}

		protected function update():void
		{
			_tf.text = int((_value / _max) * 100) + "%";
			invalidate();
		}
	}
}
