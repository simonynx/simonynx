package fj1.common.helper
{
	import com.adobe.utils.ArrayUtil;
	import fj1.common.ui.MenuDataItem;
	import fj1.common.ui.TDefaultListMenu2;
	import fj1.common.ui.pools.MenuPool;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import tempest.ui.components.TListMenu;
	import tempest.ui.components.TWindow;

	public class MenuHelper
	{
		/**
		 * 显示中的菜单列表
		 */
		private static var _showingMenuArray:Array = [];

		public static function show(container:DisplayObject, shower:DisplayObject, parentWindow:TWindow, items:Array, data:Object, selectHandler:Function):TListMenu
		{
			if (!items || items.length == 0)
			{
				return null;
			}
			var menu:TListMenu = findShowingMenu(shower);
			if (menu)
			{
				//在当前shower上已经找到菜单，将菜单关闭
				menu.dispend();
				return null;
			}
			menu = TListMenu(MenuPool.instance.createObj(TDefaultListMenu2, container, shower));
			menu.list.autoAdjustSize = true;
			menu.list.verticalGap = -2;
			menu.xOffset = 4;
			menu.yOffset = 4;
			menu.attachToWindow(parentWindow);
			var onSelect:Function = function(event:Event):void
			{
				selectHandler(event);
			}
			menu.addEventListener(Event.SELECT, onSelect);
			menu.addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void
			{
				var menu:TDefaultListMenu2 = TDefaultListMenu2(event.currentTarget);
				menu.items = [];
				menu.removeEventListener(Event.SELECT, onSelect);
				menu.removeEventListener(Event.REMOVED_FROM_STAGE, arguments.callee);
				ArrayUtil.removeValueFromArray(_showingMenuArray, menu);
				MenuPool.instance.disposeObj(menu);
			});
			var listItems:Array = [];
			for each (var type:int in items)
			{
				listItems.push(new MenuDataItem(type));
			}
			menu.items = listItems;
			menu.data = data;
			menu.play();
			_showingMenuArray.push(menu);
			return menu;
		}

		private static function findShowingMenu(shower:DisplayObject):TListMenu
		{
			for each (var menu:TListMenu in _showingMenuArray)
			{
				if (menu.shower == shower)
				{
					return menu;
				}
			}
			return null;
		}
	}
}
