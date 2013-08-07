package tempest.ui.components
{
	import flash.display.DisplayObject;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.UIConst;
	import tempest.ui.components.BaseTabController;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TRadioButton;

	[Event(name = "change", type = "tempest.ui.events.TabControllerEvent")]
	[Event(name = "tabDispose", type = "tempest.ui.events.TabControllerEvent")]
	[Event(name = "tabInit", type = "tempest.ui.events.TabControllerEvent")]
	public class TDynTabController extends BaseTabController //extends TComponent
	{
		private var headContainer:TList;

		public function TDynTabController(headContainerProxy:*)
		{
			headContainer = new TList(null, headContainerProxy, null, TabHeadItemRender);
			headContainer.type = UIConst.HORIZONTAL;
		}

		public function addTab(headClass:Class, headText:String, containers:Array, model:int = MovieClipResModel.MODEL_FRAME_4):TRadioButton
		{
			var radioBt:TRadioButton = new TRadioButton(_tabGroup, null, headClass, headText, model);
			headContainer.addItem(radioBt);
			return addTabInternal(radioBt, containers);
		}

		public function removeTab(index:int):void
		{
			var containers:Array = getTabViews(index);
			for each (var disObj:DisplayObject in containers)
			{
				disObj.visible = false;
			}

			tabList.splice(index, 1);

			headContainer.removeItemAt(index);
		}
	}
}
import tempest.ui.components.TListItemRender;
import tempest.ui.components.TRadioButton;

class TabHeadItemRender extends TListItemRender
{
	public function TabHeadItemRender(proxy:* = null, data:Object = null)
	{
		super(proxy, data);
	}

	override public function set data(value:Object):void
	{
		this.addChild(value as TRadioButton);
		this.measureChildren();
	}
}
