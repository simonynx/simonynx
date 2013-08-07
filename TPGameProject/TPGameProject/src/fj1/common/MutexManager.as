package fj1.common
{
	import ghostcat.ui.layout.AbsoluteLayout;

	public class MutexManager
	{
		private static var _instance:MutexManager;

		public static function get instance():MutexManager
		{
			return _instance ||= new MutexManager();
		}

		private var _windowMutex:WindowMutex;

		public function MutexManager()
		{
			if (_instance)
			{
				throw new Error("HandlerGroupManager 只能存在一个实例");
			}
		}
		
		public function get windowMutex():WindowMutex
		{
			return _windowMutex ||= new WindowMutex();
		}
	}
}
