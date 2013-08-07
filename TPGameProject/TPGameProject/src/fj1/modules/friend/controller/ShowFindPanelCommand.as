package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.friend.view.components.FindPanel;
	import tempest.common.mvc.base.Command;

	/**
	 * ...
	 * @author ...
	 */
	public class ShowFindPanelCommand extends Command
	{
		override public function getHandle():Function
		{
			return this.showSelectPanel;
		}

		private function showSelectPanel(flag:int = -1):void
		{
			switch (flag)
			{
				case 0:
					TWindowManager.instance.removePopupByName(FindPanel.NAME);
					break;
				case 1:
					TWindowManager.instance.showPopup2(null, FindPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD);
					break;
				default:
					TWindowManager.instance.showPopup2(null, FindPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
					break;
			}
		}
	}
}
