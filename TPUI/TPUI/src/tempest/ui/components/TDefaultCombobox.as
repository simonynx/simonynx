package tempest.ui.components
{
	import tempest.ui.UIStyle;

	/**
	 * 快捷使用的Combobox，使用默认的资源和居中的下拉文本布局
	 * @author linxun
	 *
	 */
	public class TDefaultCombobox extends TCombobox
	{
		public function TDefaultCombobox(constraints:Object = null, _proxy:* = null, selectedItemFactory:* = null, listProxy:* = null, itemRenderClass:Class = null, itemSkinClass:Class = null, nameProperty:String = "label")
		{
			if (!listProxy)
				listProxy = UIStyle.tipBkSkin;
			if (!itemSkinClass)
				itemSkinClass = UIStyle.listItemSkin;
			if (!itemRenderClass)
				itemRenderClass = MenuListItemRender;
			super(constraints, _proxy, selectedItemFactory, listProxy, itemRenderClass, itemSkinClass, nameProperty);
		}
	}
}
