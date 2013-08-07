package tempest.ui.components.tips
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.interfaces.IToolTipClient;

	public class TSimpleToolTip extends TToolTip
	{
		protected var _text:TText;
		protected var _delayShow:Number;
		protected var _usehtml:Boolean;
		protected var _maxTipWidth:Number;
		protected var _xAlign:Number = 2;
		protected var _yAlign:Number = 2;
		public static const NAME:String = "TSimpleToolTip";

		public function TSimpleToolTip(_proxy:* = null, mouseFollow:Boolean = false, yOffset:Number = 0, xOffset:Number = 0, delayShow:Number = 0, usehtml:Boolean = false, maxTipWidth:Number = 0)
		{
			_delayShow = delayShow;
			_usehtml = usehtml;
			_maxTipWidth = maxTipWidth;
			if (_maxTipWidth <= 0)
				_maxTipWidth = UIStyle.DEFAULT_TIP_MAX_WIDTH;
			super(_proxy, mouseFollow, yOffset);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_text = new TText(null, null, "", TextFieldAutoSize.LEFT);
			var txtFormat:TextFormat = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.DEFAULT_TIP);
			txtFormat.leading = 2;
			_text.format = txtFormat;
			_text.filters = [UIStyle.textBoundFilter]
			_text.multiline = true;
			_text.editable = false;
			_text.html = _usehtml;
			_text.toolTip = null;
			_text.x = _xAlign;
			_text.y = _yAlign;
			this.addChild(_text);
		}

		public function set xAlign(value:Number):void
		{
			_xAlign = value;
			_text.x = value;
		}

		public function set yAlign(value:Number):void
		{
			_yAlign = value;
			_text.y = _yAlign;
		}

		override public function set data(value:Object):void
		{
			_text.multiline = true;
			_text.wordWrap = true;
			_text.width = _maxTipWidth;
			_text.text = "";
			var str:String = value as String;
			if (str)
			{
				_text.text = str;
			}
			else
			{
				var toolTipShower:IToolTipClient = value as IToolTipClient;
				if (toolTipShower)
				{
					_text.text = toolTipShower.getTipString();
				}
			}
			if (_text.numLines <= 1)
			{
				_text.multiline = false;
				_text.wordWrap = false;
			}
			this.measureChildren();
		}

		public function set html(value:Boolean):void
		{
			_text.html = value;
		}

		override public function measureChildren(proxyAsBackGround:Boolean = false, setSize:Boolean = true):Point
		{
			this.setProxySize(_text.width + 2 * _xAlign, _text.height + 2 * _yAlign);
			var ret:Point = super.measureChildren(proxyAsBackGround, setSize);
			return ret;
		}

		override public function get data():Object
		{
			return _text.text;
		}

		public function get tText():TText
		{
			return _text;
		}
	}
}
