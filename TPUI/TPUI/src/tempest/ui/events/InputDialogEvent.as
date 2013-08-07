package tempest.ui.events
{
	import flash.events.Event;

	public class InputDialogEvent extends Event
	{
		private var _flag:int;
		private var _inputData:*;

		public static const INPUT:String = "input";

		public function InputDialogEvent(type:String, flag:int, inputData:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_flag = flag;
			_inputData = inputData;
			super(type, bubbles, cancelable);
		}

		public function get flag():int
		{
			return _flag;
		}

		public function get inputData():*
		{
			return _inputData;
		}

		override public function clone():Event
		{
			return new InputDialogEvent(type, _flag, _inputData, bubbles, cancelable);
		}
	}
}
