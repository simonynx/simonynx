package fj1.common.ui.factories
{
	import fj1.common.ui.AutoCompleteTextField;

	import flash.events.Event;
	import flash.text.TextFormat;

	import mx.core.IFactory;

	import tempest.common.pool.Pool;
	import tempest.core.IPoolClient;

	public class AutoCompleteTextFieldFactory implements IFactory
	{
		private var _completeTime:Number;
		private var _textFormat:TextFormat;
		private var _tfPool:Pool;

		public function AutoCompleteTextFieldFactory(textFormat:TextFormat, completeTime:Number = 3)
		{
			_tfPool = new Pool();
			_textFormat = textFormat ? textFormat : new TextFormat(null, 12, 0x00FF00);
			_completeTime = completeTime;
		}

		public function newInstance():*
		{
			var tf:AutoCompleteTextField = AutoCompleteTextField(_tfPool.createObj(AutoCompleteTextField));
			tf.completeTime = _completeTime;
			tf.alpha = 1;
			tf.x = 0;
			tf.y = 0;
			if (_textFormat)
			{
				tf.defaultTextFormat = _textFormat;
			}
			tf.addEventListener(Event.REMOVED_FROM_STAGE, onTextFieldRemoved);
			return tf;
		}

		public function get completeTime():Number
		{
			return _completeTime;
		}

		private function onTextFieldRemoved(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			_tfPool.disposeObj(IPoolClient(event.currentTarget));
		}
	}
}
