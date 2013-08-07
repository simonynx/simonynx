package fj1.modules.item.controller
{
	import fj1.common.ui.TWindowManager;
	import fj1.modules.item.view.components.HeroBagPanel;

	import tempest.common.mvc.base.Command;

	public class ShowHeroBagCommand extends Command
	{
		public function ShowHeroBagCommand()
		{
			super();
		}

		override public function getHandle():Function
		{
			return show;
		}

		private function show(manageType:int, validatePos:Boolean = false):void
		{
			var panel:HeroBagPanel = HeroBagPanel(TWindowManager.instance.showPopup2(null, HeroBagPanel.NAME, false, false, manageType));
			if (validatePos)
			{
				panel.invalidatePositionNow();
			}
		}
	}
}
