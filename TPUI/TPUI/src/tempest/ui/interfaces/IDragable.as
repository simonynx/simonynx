package tempest.ui.interfaces
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;

	public interface IDragable extends IMouseOperator, IEventDispatcher
	{
		function isEmpty():Boolean;
		function get pickUpEnable():Boolean;
		function get data():Object;
		function get dropBackAreaArray():Array; //拖放放下后，会自动回到原处的范围，范围内不会触发DragEvent.DROP_OUT事件
		function get dropOutTarget():InteractiveObject;
		function get place():int;
		function set place(value:int):void;
		function set bePickedUp(value:Boolean):void;
		function get bePickedUp():Boolean;
		function set setMouseSkinHandler(value:Function):void
		function get setMouseSkinHandler():Function
	}
}
