package modules.main.business.bag.controller
{

	import modules.main.common.TWindowManager;
	import modules.main.constants.WindowName;

	import tempest.common.mvc.base.Command;

	public class BagStartupCommand extends Command
	{
		public function BagStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
			TWindowManager.instance.showPopup2(null, WindowName.BAG_VIEW);
		}
	}
}
