package modules.main.business.bag.view
{
	import common.RslMananger;

	import common.constants.ResPath;
	import common.constants.ResourceLib;

	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;

	import modules.main.constants.WindowName;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.components.TWindow;

	public class BagView extends TWindow
	{
		private static const log:ILogger = TLog.getLogger(BagView);

		public function BagView()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslMananger.getDefinitionByName(ResPath.getUIPath("Resource.swf"), ResourceLib.UI_GAME_GUI_HERO_BAG), WindowName.BAG_VIEW);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			if (!this.root)
			{
				return;
			}
			var params:Object = this.root.loaderInfo.parameters;
			log.info("获取网页参数:");
			for (var key:String in params)
			{
				log.info(key + "=" + params[key]);
			}
		}
	}
}
