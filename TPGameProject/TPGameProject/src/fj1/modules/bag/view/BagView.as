package fj1.modules.bag.view
{
	import assets.UIResourceLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.ResPaths;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.staticdata.WindowName;

	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.components.TWindow;

	public class BagView extends TWindow
	{
		private static const log:ILogger = TLog.getLogger(BagView);

		public function BagView()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getDefinition(UIResourceLib.UI_GAME_GUI_HERO_BAG), WindowName.BAG_VIEW);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			var itemTemplate:ItemTemplate = ItemTemplateManager.instance.get(101);
			var itemData:ItemData = new ItemData(123, 132, itemTemplate, 10, false);
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
