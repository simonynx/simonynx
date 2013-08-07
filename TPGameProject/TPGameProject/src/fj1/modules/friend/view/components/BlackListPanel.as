package fj1.modules.friend.view.components
{
	import assets.UIResourceLib;
	import fj1.modules.friend.view.components.renders.BlackListItemRender;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;

	public class BlackListPanel extends TComponent
	{
		public var blackList:TList;

		public function BlackListPanel(_proxy:* = null)
		{
			super(null, _proxy);
			blackList = new TList(null, _proxy.mc_list, _proxy.scroll, BlackListItemRender, RslManager.getDefinition(UIResourceLib.blackListItem));
		}
	}
}
