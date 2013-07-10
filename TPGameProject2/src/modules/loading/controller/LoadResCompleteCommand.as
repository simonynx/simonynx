package modules.loading.controller
{
	import modules.main.MainFacade;

	import tempest.common.mvc.base.Command;

	public class LoadResCompleteCommand extends Command
	{
		public function LoadResCompleteCommand()
		{
			super();
		}

		override public function execute():void
		{
			initUIRes();
			this.facade.showdown();
			MainFacade.instance.startup();
		}

		private function initUIRes():void
		{

		}
	}
}
