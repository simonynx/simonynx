package tempest.ui.components.tips
{
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.interfaces.IToolTipClient;

	public class TAutoWidthToolTip extends TToolTip
	{
		private var _text:TText;
		private var _usehtml:Boolean;
		protected var _xAlign:Number = 2;
		protected var _yAlign:Number = 2;

		public function TAutoWidthToolTip(_proxy:* = null, mouseFollow:Boolean = false, yOffset:Number = 4, xOffset:Number = 0, usehtml:Boolean = false)
		{
			_usehtml = usehtml;
			super(_proxy, mouseFollow, yOffset, xOffset);
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

		override public function measureChildren(proxyAsBackGround:Boolean = false, setSize:Boolean = true):Point
		{
			this.setProxySize(_text.width + 2 * _xAlign, _text.height + 2 * _yAlign);
			var ret:Point = super.measureChildren(proxyAsBackGround, setSize);
			return ret;
		}

		override public function set data(value:Object):void
		{
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

			this.measureChildren();
		}
	}
}
