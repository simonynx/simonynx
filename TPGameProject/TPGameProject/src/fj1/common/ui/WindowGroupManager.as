package fj1.common.ui
{
	import flash.utils.Dictionary;

	public class WindowGroupManager
	{
		private static var _instance:WindowGroupManager = null;
		
		private var _windowGruopDic:Dictionary;
		
		public function WindowGroupManager()
		{
			if (_instance != null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
			
			_windowGruopDic = new Dictionary();
		}
		
		public static function get instance():WindowGroupManager
		{
			if (_instance == null)
				new WindowGroupManager();
			return _instance;
		}
		
		/**
		 * 获取或创建WindowGroup 
		 * @param groupId
		 * @return 
		 * 
		 */		
		public function getGroup(groupId:int):WindowGroup
		{
			var group:WindowGroup = _windowGruopDic[groupId];
			if(!group)
			{
				group = new WindowGroup();
				_windowGruopDic[groupId] = group;
			}
			return group;
		}
	}
}