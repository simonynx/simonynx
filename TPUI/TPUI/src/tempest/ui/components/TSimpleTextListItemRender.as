package tempest.ui.components
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class TSimpleTextListItemRender extends TListItemRender
	{
		public var text:TextField;
		protected var _nameProperty:String = "label";

		public function TSimpleTextListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			if (text == null)
			{
				if (_proxy && _proxy.hasOwnProperty("text"))
				{
					text = _proxy.text;
				}
				else
				{
					text = new TextField();
					text.autoSize = TextFieldAutoSize.LEFT;
				}
			}
			text.mouseEnabled = false;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (value is String)
			{
				text.text = String(data);
			}
			else if (_nameProperty)
			{
				text.text = data == null ? "" : data[_nameProperty];
			}
		}
	}
}
