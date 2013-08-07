package tempest.ui.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IMouseOperator
	{
		function get priority():int
		function get type():int
		function cancelOperate():void
	}
}