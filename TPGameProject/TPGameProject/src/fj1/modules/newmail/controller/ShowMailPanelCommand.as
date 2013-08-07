package fj1.modules.newmail.controller
{
	import fj1.common.ui.TWindowManager;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailTabPanel;
	import tempest.common.mvc.base.Command;

	public class ShowMailPanelCommand extends Command
	{
		[Inject]
		public var signal:MailSignal;

		override public function getHandle():Function
		{
			return this.showMailPanel;
		}

		private function showMailPanel(flag:int = -1):void
		{
			switch (flag)
			{
				case 0:
					TWindowManager.instance.removePopupByName(MailTabPanel.NAME);
					break;
				case 1:
					TWindowManager.instance.showPopup2(null, MailTabPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD);
					break;
				default:
					TWindowManager.instance.showPopup2(null, MailTabPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
					signal.changeMailIcon.dispatch(1);
					break;
			}
		}
	}
}
