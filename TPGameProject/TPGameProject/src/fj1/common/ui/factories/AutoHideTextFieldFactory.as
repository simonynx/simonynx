package  fj1.common.ui.factories
{
	import fj1.common.ui.AutoHideTextField;

	import flash.events.Event;
	import flash.text.TextFormat;

	import mx.core.IFactory;

	import tempest.common.pool.Pool;
	import tempest.core.IPoolClient;

	public class AutoHideTextFieldFactory implements IFactory
	{
		private var _textFormat:TextFormat;
		private var _tfPool:Pool;

		public function AutoHideTextFieldFactory(textFormat:TextFormat)
		{
			_tfPool = new Pool();
			_textFormat = textFormat;
		}

		public function newInstance():*
		{
			var tf:AutoHideTextField = AutoHideTextField(_tfPool.createObj(AutoHideTextField));
			tf.alpha = 1;
//			tf.x = 0;
			tf.y = 0;
			if (_textFormat)
			{
				tf.defaultTextFormat = _textFormat;
			}
			tf.addEventListener(Event.REMOVED_FROM_STAGE, onTextFieldRemoved);
			return tf;
		}

		private function onTextFieldRemoved(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			_tfPool.disposeObj(IPoolClient(event.currentTarget));
		}
	}
}
