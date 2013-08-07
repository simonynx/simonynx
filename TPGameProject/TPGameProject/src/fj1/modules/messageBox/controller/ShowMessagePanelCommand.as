package fj1.modules.messageBox.controller
{
	import fj1.common.ui.TWindowManager;
	import fj1.modules.messageBox.view.components.MessagePanel;

	import tempest.common.mvc.base.Command;

	public class ShowMessagePanelCommand extends Command
	{
		override public function getHandle():Function
		{
			return this.showPanel;
		}

		private function showPanel(flag:int = -1):void
		{
			switch (flag)
			{
				case 0:
					TWindowManager.instance.removePopupByName(MessagePanel.NAME);
					break;
				case 1:
					TWindowManager.instance.showPopup2(null, MessagePanel.NAME, false, false, TWindowManager.MODEL_USE_OLD);
					break;
				default:
					TWindowManager.instance.showPopup2(null, MessagePanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
					break;
			}
		}
	}
}
