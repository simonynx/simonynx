package tempest.engine.vo
{
	import tempest.utils.Fun;

	public class FunctionData
	{
		/**
		 *当前时间
		 */
		private var _currentTime:Number = NaN;
		/**
		 *间隔时间
		 */
		private var _interval:Number = NaN;
		/**
		 *执行次数
		 */
		private var _times:int = NaN;
		/**
		 *当前次数
		 */
		private var _currentTimes:int = NaN;
		/**
		 *轮训的函数
		 */
		private var _fuc:Function = null;
		/**
		 *参数
		 */
		public var _parms:Array = null;
		/**
		 *是否执行完毕
		 */
		public var idDead:Boolean = false;
		/**
		 *是否立即执行
		 */
		public var excuteNow:Boolean = true;
		/**
		 *是否已释放
		 */
		private var _disposed:Boolean = false;

		/**
		 * 统一执行函数
		 * @param fuc   需要执行的函数
		 * @param interval  执行间隔  0 （表示每一帧执行）
		 * @param times  执行次数  -1（表示永久执行）
		 *
		 */
		public function FunctionData(fuc:Function, parms:Array, interval:Number, times:int, excuteNow:Boolean = true)
		{
			_parms = parms;
			_currentTime = 0;
			_currentTimes = 0;
			_interval = interval;
			_times = times;
			_fuc = fuc;
			this.excuteNow = excuteNow;
			if (this.excuteNow)
			{
				if (_times != -1)
				{
					_currentTimes++;
				}
				if (_times == 1)
				{
					idDead = true;
				}
				_fuc.apply(null, this._parms);
			}
		}

		/**
		 *清除累加时间
		 *
		 */
		public function resetStep():void
		{
			_currentTime = 0;
		}

		/**
		 *重置
		 *
		 */
		public function reset():void
		{
			resetStep();
			_currentTimes = 0;
			idDead = false;
		}

		/**
		 *重队列中删除
		 *
		 */
		public function kill():void
		{
			idDead = true;
		}

		/**
		 *步进
		 * @param pastTime
		 *
		 */
		public function onStep(pastTime:Number):void
		{
			if (idDead || _disposed)
			{
				return;
			}
			if (_interval <= 0)
			{
				idDead = true;
			}
			_currentTime += pastTime;
			if (_currentTime >= _interval)
			{
				_currentTime = 0;
				if (_fuc != null)
				{
					if (_times != -1)
					{
						_currentTimes++;
					}
					if (_currentTimes <= _times || _times == -1)
					{
						_fuc.apply(null, this._parms);
					}
					else
					{
						idDead = true;
					}
				}
			}
		}

		/**
		 *移除
		 *
		 */
		public function dispose():void
		{
			_disposed = true;
			_parms = null;
			_fuc = null;
		}
	}
}
