package tempest.ui.components.ttree
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import tempest.ui.components.TTextListItemRender;
	import tempest.ui.events.DataEvent;

	public class TreeUnExpendRender extends TTextListItemRender
	{
		public function TreeUnExpendRender(_proxy:* = null, data:Object = null)
		{
			super(_proxy, data);
			nameProperty = "data";
		}

		override protected function onClick(event:MouseEvent):void
		{
			super.onClick(event);
//			dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, this.data));
		}
	}
}
