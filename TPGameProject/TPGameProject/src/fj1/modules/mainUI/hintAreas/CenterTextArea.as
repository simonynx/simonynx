package fj1.modules.mainUI.hintAreas
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import fj1.common.GameInstance;
	import tempest.ui.components.textFields.TText;

	public class CenterTextArea extends TText
	{
		public function CenterTextArea()
		{
			super({horizontalCenter: 0, verticalCenter: -100});
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_format.size = 18;
			_format.color = 0xFFFF00;
		}

		public function show(text:String):void
		{
			this.text = text;
			if (!this.parent)
			{
				GameInstance.ui.mainUI.messageContainer.addChild(this);
			}
			this.alpha = 1;
			GTweener.removeTweens(this);
			GTweener.to(this, 5, {alpha: 0}).onComplete = onComplete;
		}

		private function onComplete(gTween:GTween):void
		{
			this.parent.removeChild(this);
		}

		public function hide():void
		{
			onComplete(null);
		}
	}
}
