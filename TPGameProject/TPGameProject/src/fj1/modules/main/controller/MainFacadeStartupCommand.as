package fj1.modules.main.controller
{
	import fj1.common.GameInstance;

	import fj1.modules.bag.controller.BagStartupCommand;
	import fj1.modules.bag.signals.BagSignals;
	import fj1.modules.bag.view.BagView;
	import fj1.modules.scene.controller.SceneFacadeStartupCommand;
	import fj1.modules.scene.signals.SceneSignals;
	import fj1.common.ui.TWindowManager;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.mvc.base.Command;
	import tempest.ui.PopupManager;

	public class MainFacadeStartupCommand extends Command
	{
		public function MainFacadeStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
			PopupManager.instance.register(GameInstance.app.sceneContainer, GameInstance.app.uiContainer);

			registerWindow();
		}

		private function registerWindow():void
		{
			TWindowManager.instance.registerWindow2(new BagView());
		}

	}
}
