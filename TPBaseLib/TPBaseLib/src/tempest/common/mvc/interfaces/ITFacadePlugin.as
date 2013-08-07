package tempest.common.mvc.interfaces
{
	import org.osflash.signals.ISignal;

	import tempest.common.mvc.TFacade;

	public interface ITFacadePlugin
	{
		function setup(facade:TFacade):void;
		function get startupSignal():ISignal;
	}
}
