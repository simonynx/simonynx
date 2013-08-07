package fj1.common
{
	public class MutexHandler
	{
		private var _name:String;
		private var _handler:Function;

		public function setOperate(name:String, handler:Function):void
		{
			if (_handler != null)
			{
				_handler();
			}
			_name = name;
			_handler = handler;
		}

		public function clean(name:String):void
		{
			if (_name == name)
			{
				_handler = null;
				_name = null;
			}
		}

		public function get name():String
		{
			return _name;
		}
	}
}
