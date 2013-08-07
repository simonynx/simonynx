package tempest.ui.components
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFieldAutoSize;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TText;

	/**
	 * 使用居中文本的ItemRender，经常用于菜单列表项
	 * @author linxun
	 *
	 */
	public class MenuListItemRender extends TTextListItemRender
	{
		public function MenuListItemRender(proxy:* = null, data:Object = null)
		{
			if (!proxy)
			{
				proxy = UIStyle.listItemSkin;
			}
			super(proxy, data);
		}

		override protected function addChildren():void
		{
//			super.addChildren();
			if (_proxy && _proxy.hasOwnProperty("text") && _proxy.text != null)
			{
				_text = new TText(null, _proxy.text, "", TextFieldAutoSize.CENTER);
			}
			else
			{
				_text = new TText(null, null, "", TextFieldAutoSize.CENTER);
				_text.format = txtFormat;
				_text.editable = false;
				_text.selectable = false;
				this.addChild(_text);
			}
			_text.editable = false;
			_text.selectable = false;
			this.measureChildren();
		}
	}
}
