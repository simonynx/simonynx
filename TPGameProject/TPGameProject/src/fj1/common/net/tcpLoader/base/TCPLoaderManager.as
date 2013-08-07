package fj1.common.net.tcpLoader.base
{

	import flash.utils.Dictionary;

	public class TCPLoaderManager
	{
		private var loaderArray:Array;

		private static var _instanceDic:Dictionary = new Dictionary();

		public static function getInstance(group:int):TCPLoaderManager
		{
			var manager:TCPLoaderManager = _instanceDic[group];
			if (!manager)
			{
				manager = new TCPLoaderManager();
				_instanceDic[group] = manager;
			}
			return manager;
		}

		public function TCPLoaderManager()
		{
			loaderArray = [];
		}

		public function add(loader:TCPLoader):void
		{
			loaderArray[loader.loaderId] = loader;
		}

		public function get(loaderId:int):TCPLoader
		{
			return TCPLoader(loaderArray[loaderId]);
		}

		public function remove(loaderId:int):void
		{
			loaderArray[loaderId] = null;
		}
	}
}
