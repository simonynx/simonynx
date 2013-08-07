package fj1.modules.friend.view.components
{
	import assets.UIResourceLib;
	import fj1.modules.friend.view.components.renders.FriendListItemRender;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;

	public class FriendListPanel extends TComponent
	{
		public var friendList:TList;

		public function FriendListPanel(_proxy:* = null)
		{
			super(null, _proxy);
			friendList = new TList(null, _proxy.mc_list, _proxy.scroll, FriendListItemRender, RslManager.getDefinition(UIResourceLib.friendListItem));
		}
	}
}
