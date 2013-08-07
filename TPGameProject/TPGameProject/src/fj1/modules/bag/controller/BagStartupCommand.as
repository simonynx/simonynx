package fj1.modules.bag.controller
{
	import fj1.common.ui.TWindowManager;
	import fj1.common.staticdata.WindowName;
	import tempest.common.mvc.base.Command;

	public class BagStartupCommand extends Command
	{
		public function BagStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
//			TWindowManager.instance.showPopup2(null, WindowName.BAG_VIEW);
		}
	}
}
