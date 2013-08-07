package tempest.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;

	public class ListenerManager
	{
		private var eventListenerDic:Dictionary;
		private var signalListenerDic:Dictionary;

		public function ListenerManager()
		{
			eventListenerDic = new Dictionary();
			signalListenerDic = new Dictionary();
		}

		public function addEventListener(eventDispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);

			var listenerArray:Array = eventListenerDic[eventDispatcher];
			if (!listenerArray)
			{
				eventListenerDic[eventDispatcher] = [new EventListenerData(eventDispatcher, type, listener, useCapture)];
			}
			else
			{
				listenerArray.push(new EventListenerData(eventDispatcher, type, listener, useCapture));
			}
		}

		public function removeAllEventListener():void
		{
			for each (var listenerArray:Array in eventListenerDic)
			{
				for each (var listenerData:EventListenerData in listenerArray)
				{
					listenerData.eventDispatcher.removeEventListener(listenerData.type, listenerData.listener, listenerData.useCapture);
				}
			}
		}

		public function addSignal(signal:ISignal, handler:Function):void
		{
			signal.add(handler);

			var listenerArray:Array = signalListenerDic[signal];
			if (!listenerArray)
			{
				signalListenerDic[signal] = [new SignalListenerData(signal, handler)];
			}
			else
			{
				listenerArray.push(new SignalListenerData(signal, handler));
			}
		}

		public function removeSignal(signal:ISignal):void
		{
			for each (var listenerArray:Array in signalListenerDic)
			{
				for each (var signalData:SignalListenerData in listenerArray)
				{
					if (signal == signalData.signal)
					{
						signalData.signal.remove(signalData.listener);
						break;
					}
				}
			}
		}

		public function removeAllSignalListener():void
		{
			for each (var listenerArray:Array in signalListenerDic)
			{
				for each (var signalData:SignalListenerData in listenerArray)
				{
					signalData.signal.remove(signalData.listener);
				}
			}
		}

		public function removeAll():void
		{
			removeAllEventListener();
			removeAllSignalListener();
		}

	}
}
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.osflash.signals.ISignal;

class EventListenerData
{
	public var eventDispatcher:IEventDispatcher;
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;

	public function EventListenerData(eventDispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean)
	{
		this.eventDispatcher = eventDispatcher;
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
	}
}

class SignalListenerData
{
	public var signal:ISignal;
	public var listener:Function;

	public function SignalListenerData(signal:ISignal, listener:Function)
	{
		this.signal = signal;
		this.listener = listener;
	}
}
