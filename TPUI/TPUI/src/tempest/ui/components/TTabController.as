package tempest.ui.components
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.events.TabControllerEvent;


	[Event(name = "change", type = "tempest.ui.events.TabControllerEvent")]
	[Event(name = "tabDispose", type = "tempest.ui.events.TabControllerEvent")]
	[Event(name = "tabInit", type = "tempest.ui.events.TabControllerEvent")]
	public class TTabController extends BaseTabController //extends TComponent
	{
		public function TTabController()
		{
			super();
		}

		/**
		 *
		 * @param head 选项卡头，需要对应radioButton格式的资源
		 * @param headText 选项卡头文本
		 * @param containers 选项卡对应的容器
		 * @param model 选项卡头帧数类型
		 * @return
		 *
		 */
		public function addTab(head:MovieClip, headText:String, containers:Array, model:int = MovieClipResModel.MODEL_FRAME_4):TRadioButton
		{
			var radioBt:TRadioButton = new TRadioButton(_tabGroup, null, head, headText, model);
			return addTabInternal(radioBt, containers);
		}
	}
}
