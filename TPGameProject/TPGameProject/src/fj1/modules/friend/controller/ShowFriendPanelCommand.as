package fj1.modules.friend.controller
{
	import fj1.common.MutexManager;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.friend.view.components.FriendPanel;

	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TWindow;

	public class ShowFriendPanelCommand extends Command
	{
		override public function getHandle():Function
		{
			return this.showFriendPanel;
		}

		private function showFriendPanel(flag:int = -1):void
		{
			switch (flag)
			{
				case 0:
					TWindowManager.instance.removePopupByName(FriendPanel.NAME);
					break;
				case 1:
					TWindowManager.instance.showPopup2(null, FriendPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, null, null, function(wnd:TWindow):void
					{
						MutexManager.instance.windowMutex.setWindow(wnd);
					});
					break;
				default:
					TWindowManager.instance.showPopup2(null, FriendPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD, null, null, null, function(wnd:TWindow):void
					{
						MutexManager.instance.windowMutex.setWindow(wnd);
					});
					break;
			}
		}
	}
}
