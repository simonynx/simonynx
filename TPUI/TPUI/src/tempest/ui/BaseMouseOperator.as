package tempest.ui
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import tempest.ui.interfaces.IMouseOperator;

	public class BaseMouseOperator extends EventDispatcher implements IMouseOperator
	{
		private var _priority:int;
		private var _type:int;

		public function BaseMouseOperator(type:int, priority:int)
		{
			_type = type;
			_priority = priority;

		}

		public function setOperate(params:Object):Boolean
		{
			return MouseStateHolder.instance.setOperater(this, params);
		}

		public function cancelOperate():void
		{
			MouseStateHolder.instance.cleanOperater();
		}

		public function get priority():int
		{
			return _priority;
		}

		public function get type():int
		{
			return _type;
		}
	}
}
