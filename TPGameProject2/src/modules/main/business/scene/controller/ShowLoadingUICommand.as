package modules.main.business.scene.controller
{
	import modules.main.business.scene.view.components.LoadingUI;

	import tempest.common.mvc.base.Command;
	import tempest.ui.PopupManager;

	public class ShowLoadingUICommand extends Command
	{
		[Inject]
		public var loadingUI:LoadingUI;

		public function ShowLoadingUICommand()
		{
			super();
		}

		override public function getHandle():Function
		{
			return show;
		}

		private function show(open:Boolean):void
		{
			if (open)
			{
				PopupManager.instance.showPopup(null, loadingUI, false);
			}
			else
			{
				PopupManager.instance.removePopup(loadingUI);
			}
		}
	}
}
