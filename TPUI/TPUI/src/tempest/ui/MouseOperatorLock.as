package tempest.ui
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 标记鼠标操作（如拾起放下和提取），一帧中是否进行过一次
	 * @author linxun
	 * 
	 */	
	public class MouseOperatorLock
	{
		//鼠标事件当前帧中触发过一次的标记，一帧后自动重置
		private var _unLockTimer:Timer;
		
		private static var _instance:MouseOperatorLock;
		
		public static function get instance():MouseOperatorLock
		{
			if (_instance == null)
				_instance = new MouseOperatorLock();
			return _instance;
		}
		
		public function MouseOperatorLock()
		{
			if (_instance)
				throw new Error("该类只能有一个实例");
			_instance = this;
			
			_unLockTimer = new Timer(1,1);
		}
		
		public function isLocked():Boolean
		{
			return _unLockTimer.running;
		}
		
		public function lock():void
		{
			_unLockTimer.start();
		}
	}
}