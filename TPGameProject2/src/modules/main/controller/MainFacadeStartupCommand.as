package modules.main.controller
{
	import common.GameInstance;

	import modules.main.business.bag.controller.BagStartupCommand;
	import modules.main.business.bag.signals.BagSignals;
	import modules.main.business.bag.view.BagView;
	import modules.main.business.scene.controller.SceneStartupCommand;
	import modules.main.business.scene.signals.SceneSignals;
	import modules.main.common.TWindowManager;

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
			PopupManager.instance.register(null, GameInstance.app.uiContainer);

			registerWindow();
		}

		private function registerWindow():void
		{
			TWindowManager.instance.registerWindow2(new BagView());
		}

	}
}
