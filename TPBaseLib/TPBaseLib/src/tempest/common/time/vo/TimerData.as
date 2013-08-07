package tempest.common.time.vo
{
	import tempest.core.IDisposable;

	public class TimerData implements IDisposable
	{
		private var _timer:*;
		private var _destoryHandler:Function;
		private var _valid:Boolean = true;

		public function TimerData(timer:*, destoryHandler:Function)
		{
			_timer = timer;
			_destoryHandler = destoryHandler;
		}

		public function get timer():*
		{
			return _timer;
		}

		public function get running():Boolean
		{
			return (_valid) ? _timer.running : false;
		}

		public function get currentCount():int
		{
			return (_valid) ? _timer.currentCount : 0;
		}

		public function get delay():Number
		{
			return (_valid) ? _timer.delay : 0;
		}

		public function set delay(value:Number):void
		{
			if (_valid)
			{
				_timer.delay = value;
			}
		}

		public function get repeatCount():int
		{
			return (_valid) ? _timer.repeatCount : 0;
		}

		public function set repeatCount(value:int):void
		{
			if (_valid)
			{
				_timer.repeatCount = value;
			}
		}

		public function start():void
		{
			if (_valid)
			{
				_timer.start();
			}
		}

		public function reset():void
		{
			if (_valid)
			{
				_timer.reset();
			}
		}

		public function stop():void
		{
			if (_valid)
			{
				_timer.stop();
			}
		}

		public function dispose():void
		{
			if (_valid)
			{
				this.stop();
				if (_destoryHandler != null)
				{
					_destoryHandler();
				}
				_timer = null;
				_destoryHandler = null;
				_valid = false;
			}
		}
	}
}
