package tempest.common.mvc.base
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;

	import tempest.common.mvc.TFacade;
	import tempest.common.mvc.interfaces.ITFacadePlugin;

	public class TFacadePlugin implements ITFacadePlugin
	{
		private var _facade:TFacade;
		private var _startupSignal:ISignal;

		public function TFacadePlugin()
		{
		}

		public function setup(facade:TFacade):void
		{
			_facade = facade;
			_facade.startupSignal.add(startup);
		}

		public function get inject():Injector
		{
			return _facade.inject;
		}

		public function get commandMap():CommandMap
		{
			return _facade.commandMap;
		}

		public function get mediatorMap():MediatorMap
		{
			return _facade.mediatorMap;
		}

		public function get startupSignal():ISignal
		{
			return _startupSignal ||= new Signal();
		}

		protected function startup():void
		{

		}
	}
}
