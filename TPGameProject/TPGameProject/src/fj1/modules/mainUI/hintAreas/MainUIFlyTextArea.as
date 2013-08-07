package fj1.modules.mainUI.hintAreas
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.IFactory;
	
	import fj1.common.ui.AutoHideTextField;

	public class MainUIFlyTextArea extends BaseFlyObjectArea
	{
		private static const MOVE_DELAY:Number = 50;
		private static const MOVE_TIME:Number = 0.5;
		private var _textFieldFactory:IFactory;

		public function MainUIFlyTextArea(parent:DisplayObjectContainer, constraints:Object, width:Number, height:Number, maxLen:int, textFieldFactory:IFactory)
		{
			super(parent, constraints, width, height, maxLen);
			_textFieldFactory = textFieldFactory
			moveTime = MainUIFlyTextArea.MOVE_TIME;
			moveDelay = MainUIFlyTextArea.MOVE_DELAY;
		}

		public function addText(value:String):void
		{
			var tf:AutoHideTextField = _textFieldFactory.newInstance();
			tf.text = value;
			tf.autoSize = TextFieldAutoSize.CENTER;
			this.addObject(tf);
		}

	}
}
