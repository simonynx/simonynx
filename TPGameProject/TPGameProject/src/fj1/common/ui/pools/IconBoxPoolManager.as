package fj1.common.ui.pools
{
	import flash.utils.Dictionary;

	public class IconBoxPoolManager
	{
		private static var _pools:Dictionary = new Dictionary();
		
		public static function registerPool(name:String, pool:IconBoxPool):void
		{
			_pools[name] = pool;
		}
		
		public static function getPool(name:String):IconBoxPool
		{
			return _pools[name];
		}
	}
}