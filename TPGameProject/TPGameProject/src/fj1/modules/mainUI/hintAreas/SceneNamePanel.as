package fj1.modules.mainUI.hintAreas
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import tempest.ui.components.TComponent;

	public class SceneNamePanel extends TComponent
	{
		private var _textField:TextField;
		private var _left:Number;
		private var _delayFrames:Number = 42;

//		private var _text:TText;

		public function SceneNamePanel(constraints:Object = null, proxy:* = null)
		{
			super(constraints, proxy);
			this.visible = false;
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_textField = _proxy.textField;
			_left = _textField.x;
			_textField.autoSize = TextFieldAutoSize.CENTER;
//			_text = new TText({horizontalCenter: 0}, _textField);
//			_text.autoSizeType = TextFieldAutoSize.CENTER;
			this.addChild(_textField);
		}

		public function hide():void
		{
			this.visible = false;
		}

		public function setText2(str:String):void
		{
			this.visible = true;
			setText(str);
			var thisRef:SceneNamePanel = this;
			GTweener.to(null, _delayFrames, null, {useFrames: true, onComplete: function(gTween:GTween):void
			{
				thisRef.visible = false;
			}});
		}

		public function setText(str:String):void
		{
			_textField.text = str;
			this.width = _left * 2 + _textField.width;
			_textField.x = _left;
			invalidatePosition();
		}
	}
}
