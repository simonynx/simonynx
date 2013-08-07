package tempest.common.mvc.base
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.ISignal;
	import org.swiftsuspenders.Injector;
	import tempest.common.logging.*;
	import tempest.common.mvc.TFacade;

	public class Mediator
	{
		private static const log:ILogger = TLog.getLogger(Mediator);
		private var _facade:TFacade;
		private var _viewComponet:*;
		private var _inject:Injector;
		private var _listens:Dictionary = new Dictionary(true);

		public function Mediator()
		{
		}

		internal function setFacade(facade:TFacade):void
		{
			_facade = facade;
		}

		public function get facade():TFacade
		{
			return _facade;
		}

		public function get inject():Injector
		{
			return _inject;
		}

		internal function setInject(value:Injector):void
		{
			_inject = value;
		}

		internal function setViewComponet(value:*):void
		{
			if (_viewComponet)
			{
				IEventDispatcher(_viewComponet).removeEventListener(Event.ADDED_TO_STAGE, onPreRegister);
				IEventDispatcher(_viewComponet).removeEventListener(Event.REMOVED_FROM_STAGE, onPreRemove);
			}
			_viewComponet = value;
			if (_viewComponet)
			{
				IEventDispatcher(_viewComponet).addEventListener(Event.ADDED_TO_STAGE, onPreRegister, false, 0, true);
				IEventDispatcher(_viewComponet).addEventListener(Event.REMOVED_FROM_STAGE, onPreRemove, false, 0, true);
				if (_viewComponet.stage)
				{
					this.onPreRegister(null);
				}
			}
		}

		public function addSignal(signal:ISignal, listener:Function, priority:int = 0, once:Boolean = false):void
		{
			if (_listens[signal])
			{
				log.error("addSignal Error! mediator:{0} signal:{1} listener:{2}", getQualifiedClassName(this), getQualifiedClassName(signal), getQualifiedClassName(listener));
			}
			if (priority != 0 && signal is IPrioritySignal)
			{
				if (once)
				{
					IPrioritySignal(signal).addOnceWithPriority(listener, priority);
				}
				else
				{
					IPrioritySignal(signal).addWithPriority(listener, priority);
				}
			}
			else
			{
				if (once)
				{
					signal.addOnce(listener);
				}
				else
				{
					signal.add(listener);
				}
			}
			_listens[signal] = listener;
		}

		public function removeSignal(signal:ISignal):void
		{
			if (signal)
			{
				var listener:Function = _listens[signal];
				if (listener != null)
				{
					signal.remove(listener);
					_listens[signal] = null;
					delete _listens[signal];
				}
			}
		}

		public function hasSignal(signal:ISignal):Function
		{
			return _listens[signal];
		}

		public function get viewComponet():*
		{
			return _viewComponet;
		}

		internal function onPreRegister(e:Event):void
		{
			onRegister();
		}

		internal function onPreRemove(e:Event):void
		{
			var obj:Object;
			for (obj in _listens)
			{
				removeSignal(ISignal(obj));
			}
			onRemove();
		}

		public function onRegister():void
		{
		}

		public function onRemove():void
		{
		}
	}
}
