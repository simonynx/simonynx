package modules.loading.controller
{
	import shell.AppUIMananger;

	import shell.AppUINames;

	import tempest.common.mvc.base.Command;

	public class LoadFacadeShutdownCommand extends Command
	{
		public function LoadFacadeShutdownCommand()
		{
			super();
		}

		override public function execute():void
		{
			AppUIMananger.close(AppUINames.MAIN_LOADER);
			AppUIMananger.clean();
		}
	}
}
