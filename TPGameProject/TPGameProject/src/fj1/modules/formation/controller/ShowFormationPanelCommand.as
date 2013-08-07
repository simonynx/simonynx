package fj1.modules.formation.controller
{
	import fj1.common.MutexManager;
	import fj1.common.staticdata.WindowMutexName;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.WindowPair;
	import fj1.modules.card.view.components.CardBagPanel;
	import fj1.modules.formation.view.components.FormationPanel;

	import tempest.common.mvc.base.Command;
	import tempest.ui.events.TWindowEvent;

	public class ShowFormationPanelCommand extends Command
	{
		override public function getHandle():Function
		{
			return this.showFormationPanel;
		}

		private function showFormationPanel(flag:int = -1):void
		{
			switch (flag)
			{
				case 0:
					TWindowManager.instance.removePopupByName(FormationPanel.NAME);
					TWindowManager.instance.removePopupByName(CardBagPanel.NAME);
					break;
				case 1:
					MutexManager.instance.windowMutex.showPair(WindowMutexName.FORMATION_GROUP, FormationPanel.NAME, CardBagPanel.NAME);
					break;
				default:
					if (MutexManager.instance.windowMutex.name == WindowMutexName.FORMATION_GROUP)
					{
						WindowPair.instance.closeAll();
					}
					else
					{
						MutexManager.instance.windowMutex.showPair(WindowMutexName.FORMATION_GROUP, FormationPanel.NAME, CardBagPanel.NAME);
					}
					break;
			}
		}
	}
}
