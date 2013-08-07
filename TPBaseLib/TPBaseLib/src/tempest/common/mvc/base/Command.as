package tempest.common.mvc.base
{
	import org.swiftsuspenders.Injector;
	import tempest.common.mvc.TFacade;

	public class Command
	{
		private var _facade:TFacade;
		private var _inject:Injector;

		public function get commandMap():CommandMap
		{
			return _facade.commandMap;
		}

		public function get inject():Injector
		{
			return _inject;
		}

		internal function setInject(value:Injector):void
		{
			_inject = value;
		}

		public function get facade():TFacade
		{
			return _facade;
		}

		internal function setFacade(facade:TFacade):void
		{
			_facade = facade;
		}

		public function get mediatorMap():MediatorMap
		{
			return _facade.mediatorMap;
		}

		public function execute():void
		{
		}

		public function getHandle():Function
		{
			return execute;
		}
	}
}
