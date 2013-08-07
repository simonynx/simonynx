package fj1.common.data.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IChatHistoryHolder extends IEventDispatcher
	{
		function get strHistory():String
		function clean():void
	}
}
