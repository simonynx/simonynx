package fj1.common.data.interfaces
{
	import fj1.common.data.dataobject.cd.CDState;

	import flash.events.IEventDispatcher;

	public interface ICDable extends IEventDispatcher
	{
		function get templateId():int;
		function get groupId():int;
		function get cdState():CDState;
		function get cdVisible():Boolean;
		function set cdVisible(value:Boolean):void;
	}
}
