package tempest.manager
{
	import flash.events.*;
	import tempest.common.handler.HandlerThread;
	import tempest.common.handler.helper.HandlerHelper;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class HandlerManager
	{
		private static const log:ILogger = TLog.getLogger(HandlerManager);
		private static var _defaultHandlerThread:HandlerThread = new HandlerThread(new Array(), true);
		private static var _handlerThreadArr:Array = [_defaultHandlerThread];

		public function HandlerManager()
		{
			throw(new Event("HandlerManager 不能实例化"));
		}

		public static function getHandlerThreadsNum():int
		{
			return (_handlerThreadArr.length);
		}

		public static function getHandlersNum():int
		{
			var _local2:HandlerThread;
			var _local1:Number = 0;
			for each (_local2 in _handlerThreadArr)
			{
				_local1 = (_local1 + _local2.getHandlersNum());
			}
			return (_local1);
		}

		public static function creatNewHandlerThread(handlerArr:Array = null, isQueue:Boolean = true):HandlerThread
		{
			var $handlerArr:Array = handlerArr;
			var $isQueue:Boolean = isQueue;
			var ht:* = (_handlerThreadArr[_handlerThreadArr.length] = new HandlerThread($handlerArr, $isQueue));
			try
			{
				log.debug(("creatNewHandlerThread::_handlerThreadArr.length:" + getHandlerThreadsNum()));
			}
			catch (e:Error)
			{
			}
			return (ht);
		}

		public static function push(handler:Function, parameters:Array = null, delay:Number = 0, doNext:Boolean = true, autoRun:Boolean = true, shift:Boolean = false, handlerThread:HandlerThread = null):HandlerThread
		{
			var $handlerThread:HandlerThread;
			if (handlerThread != null)
			{
				$handlerThread = handlerThread;
				if (!hasHandlerThread($handlerThread))
				{
					_handlerThreadArr.push($handlerThread);
					log.debug(("push::_handlerThreadArr.length:" + getHandlerThreadsNum()));
				}
			}
			else
			{
				$handlerThread = _defaultHandlerThread;
			}
			$handlerThread.push(handler, parameters, delay, doNext, autoRun, shift);
			return ($handlerThread);
		}

		public static function execute(handler:Function, parameters:Array = null):*
		{
			return (HandlerHelper.execute(handler, parameters));
		}

		public static function getDefaultHandlerThread():HandlerThread
		{
			return (_defaultHandlerThread);
		}

		public static function removeAllHandlerThreads():void
		{
			removeAllHandlers();
			_handlerThreadArr = [];
			log.debug("removeAllHandlerThreads::_handlerThreadArr.length:0");
		}

		public static function removeAllHandlers():void
		{
			var $handlerThread:HandlerThread;
			for each ($handlerThread in _handlerThreadArr)
			{
				$handlerThread.removeAllHandlers();
			}
		}

		public static function removeHandlerThread(handlerThread:HandlerThread):void
		{
			var $handlerThread:HandlerThread;
			if (!handlerThread)
			{
				return;
			}
			for each ($handlerThread in _handlerThreadArr)
			{
				if ($handlerThread == handlerThread)
				{
					$handlerThread.removeAllHandlers();
					_handlerThreadArr.splice(_handlerThreadArr.indexOf($handlerThread), 1);
					log.debug(("removeHandlerThread::_handlerThreadArr.length:" + getHandlerThreadsNum()));
					break;
				}
			}
		}

		public static function removeHandler(handler:Function):void
		{
			var $handlerThread:HandlerThread;
			if (handler == null)
			{
				return;
			}
			for each ($handlerThread in _handlerThreadArr)
			{
				$handlerThread.removeHandler(handler);
			}
		}

		public static function hasHandlerThread(_arg1:HandlerThread):Boolean
		{
			return (!((_handlerThreadArr.indexOf(_arg1) == -1)));
		}

		public static function hasHandler(handler:Function):Boolean
		{
			var $handlerThread:HandlerThread;
			for each ($handlerThread in _handlerThreadArr)
			{
				if ($handlerThread.hasHandler(handler))
				{
					return (true);
				}
			}
			return (false);
		}
	}
}
