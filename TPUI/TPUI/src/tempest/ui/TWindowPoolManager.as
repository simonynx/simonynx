package tempest.ui
{
	import flash.utils.Dictionary;

	public class TWindowPoolManager
	{
		private var poolDic:Dictionary;
		//
		private static var _instance:TWindowPoolManager = null;
		
		public static function get instance():TWindowPoolManager
		{
			if (_instance == null)
				new TWindowPoolManager();
			return _instance;
		}
		
		public function TWindowPoolManager()
		{
			if(_instance!= null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
			
			poolDic = new Dictionary();
		}
		
		public function addPool(pool:TWindowPool):void
		{
			poolDic[pool.name] = pool;
		}
		
		public function getPool(name:String):TWindowPool
		{
			return poolDic[name];
		}
	}
}