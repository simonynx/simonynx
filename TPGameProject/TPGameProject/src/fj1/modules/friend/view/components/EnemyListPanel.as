package fj1.modules.friend.view.components
{
	import assets.UIResourceLib;
	import fj1.modules.friend.view.components.renders.EnemyListItemRender;
	import fj1.modules.friend.view.components.renders.FriendListItemRender;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;

	public class EnemyListPanel extends TComponent
	{
		public var enemyList:TList;

		public function EnemyListPanel(proxy:* = null)
		{
			super(null, proxy);
			enemyList = new TList(null, _proxy.mc_list, _proxy.scroll, EnemyListItemRender, RslManager.getDefinition(UIResourceLib.enemyListItem));
		}
	}
}
