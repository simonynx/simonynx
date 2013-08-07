package tempest.ui.components
{
	import flash.display.DisplayObject;

	import tempest.ui.UIStyle;

	public class TDefaultListMenu extends TListMenu
	{
		/**
		 *
		 * @param posTarget 菜单显示位置的参考控件, 为null则使用鼠标位置
		 * @param shower 菜单附属控件，附属控件关闭后菜单消失
		 * @param proxy
		 * @param itemRenderClass
		 * @param itemRenderSkin
		 * @param nameProperty
		 *
		 */
		public function TDefaultListMenu(posTarget:DisplayObject = null, shower:DisplayObject = null, proxy:* = null, itemRenderClass:Class = null, itemRenderSkin:Class = null, nameProperty:String = "name")
		{
			if (!proxy)
				proxy = UIStyle.menuBkSkin;
			if (!itemRenderSkin)
				itemRenderSkin = UIStyle.listItemSkin;
			if (!itemRenderClass)
				itemRenderClass = MenuListItemRender;
			super(posTarget, shower, proxy, itemRenderClass, itemRenderSkin, nameProperty);
		}
	}
}
