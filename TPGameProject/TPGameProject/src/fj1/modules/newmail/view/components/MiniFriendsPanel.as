package fj1.modules.newmail.view.components
{
	import assets.UIResourceLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import tempest.common.rsl.RslManager;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TList;

	public class MiniFriendsPanel extends BaseWindow
	{
		public static const NAME:String = "MiniFriendsPanel";
		public var btn_sure:TButton;
		public var btn_cancel:TButton;
		public var friendList:TList;

		public function MiniFriendsPanel(_proxy:* = null)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, _proxy, NAME);
		}

		override protected function addChildren():void
		{
			btn_sure = new TButton(null, _proxy.btn_sure, LanguageManager.translate(100008, "确定"));
			btn_cancel = new TButton(null, _proxy.btn_cancel, LanguageManager.translate(100009, "取消"));
			friendList = new TList(null, _proxy.mc_friendBG, _proxy.scroll, MiniFriListItemRender, TRslManager.getDefinition(UIResourceLib.miniFriendListItem));
		}
	}
}
