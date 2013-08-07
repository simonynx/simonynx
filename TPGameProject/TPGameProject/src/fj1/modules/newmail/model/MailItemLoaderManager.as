package fj1.modules.newmail.model
{
	import fj1.common.net.tcpLoader.DBItemDataLoader;

	public class MailItemLoaderManager
	{
		private static var _loaderArray:Object = {};

		public static function add(managerId:String, loader:DBItemDataLoader):void
		{
			_loaderArray[managerId] = loader;
		}

		public static function get(managerId:String):DBItemDataLoader
		{
			return _loaderArray[managerId] as DBItemDataLoader;
		}
	}
}
