package tempest.ui.interfaces
{
	import flash.events.IEventDispatcher;

	public interface ISlotData extends IEventDispatcher
	{
		function get slot():int
		function set slot(value:int):void
	}
}
