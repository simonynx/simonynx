package fj1.common.ui.pools
{
	import flash.display.DisplayObject;
	
	import tempest.common.pool.Pool;
	import tempest.ui.components.TListMenu;
	import tempest.ui.components.TWindow;
	
	public class MenuPool extends Pool
	{
		private static var _instance:MenuPool;
		
		public static function get instance():MenuPool
		{
			if(!_instance)
			{
				new MenuPool();
			}
			return _instance;
		}
		
		public function MenuPool()
		{
			super("MenuPool");
			
			if(_instance)
			{
				throw new Error("MenuPool is Sington");
			}
			
			_instance = this;
		}
	}
}