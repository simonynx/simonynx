package fj1.modules.item.controller
{
	import fj1.common.staticdata.WindowGroupType;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.WindowGroupManager;
	import fj1.modules.item.view.components.HeroDepotPanel;

	import tempest.common.mvc.base.Command;
	import tempest.engine.SceneCharacter;

	public class ShowHeroDepotCommand extends Command
	{
		public function ShowHeroDepotCommand()
		{
			super();
		}

		override public function getHandle():Function
		{
			return show;
		}

		private function show(npc:SceneCharacter, validatePos:Boolean = false):void
		{
			var penal:HeroDepotPanel = TWindowManager.instance.showPopup2(null, HeroDepotPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, npc) as HeroDepotPanel;
			if (validatePos)
			{
				penal.invalidatePositionNow();
			}
		}
	}
}
