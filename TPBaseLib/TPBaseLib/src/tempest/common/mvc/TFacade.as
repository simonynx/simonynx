package tempest.common.mvc
{
	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.PrioritySignal;
	import org.swiftsuspenders.Injector;

	import tempest.common.mvc.base.CommandMap;
	import tempest.common.mvc.base.MediatorMap;
	import tempest.common.mvc.interfaces.ITFacadePlugin;

	public class TFacade
	{
		private var _startupSignal:IPrioritySignal;
		private var _shutdownSignal:IPrioritySignal;
		private var _commandMap:CommandMap;
		private var _mediatorMap:MediatorMap;
		private var _inject:Injector;

		private var _plugins:Vector.<ITFacadePlugin>;

		public function TFacade()
		{
		}

		public function get inject():Injector
		{
			return _inject ||= new Injector();
		}

		public function get shutdownSignal():IPrioritySignal
		{
			return _shutdownSignal ||= new PrioritySignal();
		}

		public function get startupSignal():IPrioritySignal
		{
			return _startupSignal ||= new PrioritySignal();
		}

		public function startup():void
		{
			this.startupSignal.dispatch();
			for each (var plugin:ITFacadePlugin in _plugins)
			{
				plugin.startupSignal.dispatch();
			}
		}

		public function showdown():void
		{
//			if (_startupSignal)
//			{
//				_startupSignal.removeAll();
//				_startupSignal = null;
//			}
			if (_shutdownSignal)
			{
				_shutdownSignal.dispatch();
//				_shutdownSignal.removeAll();
//				_shutdownSignal = null;
			}
			if (_commandMap)
			{
				_commandMap.unmapAll();
				_commandMap = null;
			}
			if (_mediatorMap)
			{
				_mediatorMap.unmapAll();
				_mediatorMap = null;
			}
//			_inject = null;
		}

		public function get commandMap():CommandMap
		{
			return _commandMap ||= new CommandMap(this);
		}

		public function get mediatorMap():MediatorMap
		{
			return _mediatorMap ||= new MediatorMap(this);
		}

		public function addPlugin(plugin:ITFacadePlugin):void
		{
			if (!_plugins)
			{
				_plugins = new Vector.<ITFacadePlugin>();
			}
			_plugins.push(plugin);
			plugin.setup(this);
		}
	}
}
