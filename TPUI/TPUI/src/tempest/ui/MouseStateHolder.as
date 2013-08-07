package tempest.ui
{	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import tempest.ui.interfaces.IMouseOperator;
	
	/**
	 * 鼠标操作状态管理类
	 * 依照IMouseOperator.priority决定不同操作的优先级
	 * @author linxun
	 * 
	 */	
	public class MouseStateHolder
	{
		private static var _instance:MouseStateHolder;
		
		private var _operater:IMouseOperator;
		private var _data:Object;
		
		
		public static function get instance():MouseStateHolder
		{
			if (_instance == null)
				_instance = new MouseStateHolder();
			return _instance;
		}
		
		public function MouseStateHolder()
		{
			if (_instance)
				throw new Error("该类只能有一个实例");
			_instance = this;
		}
		
		/**
		 * 设置当前鼠标操作 
		 * @param value
		 * @return 是否设置成功
		 * 
		 */		
		public function setOperater(value:IMouseOperator, data:Object):Boolean
		{
			var ret:Boolean = true;
			if(_operater && _operater.type == value.type)
			{
				//相同类型的操作不进行撤销检查
				_operater = value;
				_data = data;
			}
			else
			{
				if(_operater)
				{
					if(_operater.priority <= value.priority)
					{
						_operater.cancelOperate();
						_data = null;
					}
					else
					{
						ret = false;//不允许设置新操作
					}
				}
				if(ret)
				{
					_operater = value;
					_data = data;
				}
			}
			
			return ret;
		}
		
		public function cleanOperater():void
		{
			_operater = null;
			_data = null;
		}
				
		public function get data():Object
		{
			return _data;
		}
		
		public function hasMouseOperator():Boolean
		{
			return _operater ? true : false;
		}
		
		public function get mouseOperator():IMouseOperator
		{
			return _operater;
		}
		
		public function get type():int
		{
			return _operater.type;
		}
	}
}