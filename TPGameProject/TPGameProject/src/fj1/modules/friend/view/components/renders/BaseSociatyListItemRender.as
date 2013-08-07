package fj1.modules.friend.view.components.renders
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tempest.ui.UIStyle;
	import tempest.ui.components.MenuListItemRender;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TWindow;

	public class BaseSociatyListItemRender extends TListItemRender
	{
		public static var whiteFormat:TextFormat = new TextFormat(UIStyle.fontName, null, 0x00FF00);
		public static var grayFormat:TextFormat = new TextFormat(UIStyle.fontName, null, 0x999999);

		public function BaseSociatyListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			this.useDoubleClick = true;
		}

		protected function setTextFormat(tf:TextField, format:TextFormat):void
		{
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
		}

	}
}
