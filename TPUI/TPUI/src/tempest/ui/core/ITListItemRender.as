package tempest.ui.core
{
	import flash.events.IEventDispatcher;

	public interface ITListItemRender extends IEventDispatcher
	{
		function get selectable():Boolean;
		function set selectable(value:Boolean):void;
		function setSelect():void;
		function set selected(value:Boolean):void
		function get selected():Boolean
		function get index():int
		function set index(value:int):void
		function unSelect():void
		function set data(value:Object):void
		function get data():Object
	}
}
