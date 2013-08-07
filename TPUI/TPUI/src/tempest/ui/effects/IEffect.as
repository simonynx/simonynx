package tempest.ui.effects
{
	import flash.events.IEventDispatcher;

	import tempest.ui.events.EffectEvent;

	[Event(name = "end", type = "tempest.ui.events.EffectEvent")]
	public interface IEffect extends IEventDispatcher
	{
		function play():void
		function stop():void
//		function pause():void
		function dispose():void
		function reset():void
		function cancel():void
		function get playing():Boolean;
	}
}
