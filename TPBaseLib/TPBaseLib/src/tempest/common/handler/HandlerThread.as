package tempest.common.handler
{
	import tempest.common.handler.helper.HandlerHelper;
	import tempest.common.handler.vo.HandlerData;
	import tempest.manager.TimerManager;

	public class HandlerThread
	{
		private var _handlerDataArr:Array
		private var _handlerDataReadyArr:Array
		private var _isRunning:Boolean
		private var _canRun:Boolean
		private var _isQueue:Boolean
		private var _next:HandlerData

		public function HandlerThread(handlerDataArr:Array = null, isQueue:Boolean = true)
		{
			this._handlerDataArr = ((handlerDataArr) || ([]));
			this._handlerDataReadyArr = [];
			this._isQueue = isQueue;
			this._isRunning = false;
			this._canRun = true;
			this._next = null;
		}

		public function get isRunning():Boolean
		{
			return (this._isRunning);
		}

		public function getHandlersNum():int
		{
			return (this._handlerDataArr.length);
		}

		public function push(handler:Function, parameters:Array = null, delay:Number = 0, doNext:Boolean = true, autoRun:Boolean = true, shift:Boolean = false):HandlerData
		{
			var handlerData:HandlerData = new HandlerData(handler, parameters, delay, doNext);
			if (shift)
			{
				this._handlerDataArr.unshift(handlerData);
			}
			else
			{
				this._handlerDataArr.push(handlerData);
			}
			if (((((this._canRun) && (autoRun))) && (!(this._isRunning))))
			{
				this.executeNext();
			}
			return (handlerData);
		}

		public function removeAllHandlers():void
		{
			this._handlerDataArr.length = 0;
			this._handlerDataReadyArr.length = 0;
			this._isRunning = false;
		}

		public function removeHandler(_arg1:Function):void
		{
			var _local2:HandlerData;
			if (_arg1 == null)
			{
				return;
			}
			var _local3:int = this._handlerDataArr.length;
			while (_local3-- > 0)
			{
				_local2 = this._handlerDataArr[_local3];
				if (_local2.handler == _arg1)
				{
					this._handlerDataArr.splice(_local3, 1);
				}
			}
			_local3 = this._handlerDataReadyArr.length;
			while (_local3-- > 0)
			{
				_local2 = this._handlerDataReadyArr[_local3];
				if (_local2.handler == _arg1)
				{
					this._handlerDataReadyArr.splice(_local3, 1);
				}
			}
			if ((((this._handlerDataArr.length == 0)) && ((this._handlerDataReadyArr.length == 0))))
			{
				this._isRunning = false;
			}
		}

		public function hasHandler(_arg1:Function):Boolean
		{
			var _local2:HandlerData;
			for each (_local2 in this._handlerDataArr)
			{
				if (_local2.handler == _arg1)
				{
					return (true);
				}
			}
			for each (_local2 in this._handlerDataReadyArr)
			{
				if (_local2.handler == _arg1)
				{
					return (true);
				}
			}
			return (false);
		}

		public function strongStart():void
		{
			this._canRun = true;
			this._isRunning = false;
			this.executeNext();
		}

		public function start():void
		{
			this._canRun = true;
			if (!this._isRunning)
			{
				this.executeNext();
			}
		}

		public function stop():void
		{
			this._canRun = false;
		}

		private function setNotRunning():void
		{
			this._isRunning = false;
		}

		private function executeNext():void
		{
			if (!this._canRun)
			{
				this._isRunning = false;
				return;
			}
			if (this._handlerDataArr.length == 0)
			{
				this._isRunning = false;
				return;
			}
			this._isRunning = true;
			this._next = ((this._isQueue) ? this._handlerDataArr.shift() : this._handlerDataArr.pop() as HandlerData);
			if (this._next)
			{
				if (this._next.delay > 0)
				{
					var newHandler:* = function():void
					{
						if (removeReadyHD(_next))
						{
							HandlerHelper.execute(_next.handler, _next.parameters);
						}
						if (_next.doNext)
						{
							executeNext();
						}
						else
						{
							setNotRunning();
						}
					};
					this.addReadyHD(this._next);
					TimerManager.createNormalTimer(this._next.delay, 1, newHandler);
				}
				else
				{
					HandlerHelper.execute(this._next.handler, this._next.parameters);
					if (this._next.doNext)
					{
						this.executeNext();
					}
					else
					{
						this.setNotRunning();
					}
				}
			}
			else
			{
				this.executeNext();
			}
		}

		private function addReadyHD(_arg1:HandlerData):void
		{
			if (this._handlerDataReadyArr.indexOf(_arg1) != -1)
			{
				return;
			}
			this._handlerDataReadyArr.push(_arg1);
		}

		private function removeReadyHD(_arg1:HandlerData):Boolean
		{
			var _local2:int = this._handlerDataReadyArr.indexOf(_arg1);
			if (_local2 != -1)
			{
				this._handlerDataReadyArr.splice(_local2, 1);
				return (true);
			}
			return (false);
		}
	}
}
