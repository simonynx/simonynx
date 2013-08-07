package fj1.modules.friend.view.components
{
	import assets.UIResourceLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import flash.events.MouseEvent;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TTabController;

	public dynamic class FriendPanel extends BaseWindow
	{
		public var tabController:TTabController;
		public var friendList:FriendListPanel; //好友单列表
		public var blackList:BlackListPanel; //黑名单列表
		public var enemyList:EnemyListPanel;
		public var btn_friendAdd:TButton;
		public var btn_friendDel:TButton;
		public static const NAME:String = "FriendPanel";

		public function FriendPanel(_proxy:*)
		{
			super({verticalCenter: 0, right: 205}, _proxy, NAME);
			friendList = new FriendListPanel(_proxy.mc_friendList);
			blackList = new BlackListPanel(_proxy.mc_blackList);
			enemyList = new EnemyListPanel(_proxy.mc_enemyList);
			tabController = new TTabController();
			tabController.addTab(_proxy.mc_tabFriend, LanguageManager.translate(9009, "好友列表"), [friendList]);
			tabController.addTab(_proxy.mc_tabEnemy, LanguageManager.translate(9012, "仇人列表"), [enemyList]);
			tabController.addTab(_proxy.mc_tabBlack, LanguageManager.translate(9005, "黑名单"), [blackList]);
			btn_friendAdd = new TButton(null, _proxy.btn0, LanguageManager.translate(9002, "添加好友"));
			btn_friendDel = new TButton(null, _proxy.btn1, LanguageManager.translate(100016, "删除"));
		}
	}
}
