package fj1.common.data.interfaces
{
	import mx.binding.IBindingClient;

	public interface ILockable extends IBindingClient
	{
		function get locked():Boolean;
		function set locked(value:Boolean):void
	}
}
