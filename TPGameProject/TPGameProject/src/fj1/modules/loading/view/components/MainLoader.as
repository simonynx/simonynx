package fj1.modules.loading.view.components
{
	import assets.EmbedRes;

	import tempest.ui.components.TComponent;
	import tempest.ui.components.TProgressBar;

	public class MainLoader extends TComponent
	{
		private var _progressbar1:TProgressBar;
		private var _progressbar2:TProgressBar;
		private var _title:String = "";

		public function MainLoader()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, new (EmbedRes.mainLoader)());
		}

		override protected function addChildren():void
		{
			_progressbar1 = new TProgressBar(null, _proxy.progressbar1, 0, 100, false, false, text1Handler);
			_progressbar2 = new TProgressBar(null, _proxy.progressbar2, 0, 100, false, false, text2Handler);
		}

		public function update(value1:Number, value2:Number):void
		{
			_progressbar1.currentValue = value1 * 100;
			_progressbar2.currentValue = value2 * 100;
		}

		public function setTitle(value:String):void
		{
			_title = value;
			_progressbar2.invalidateNow();
		}

		private function text1Handler(bar:TProgressBar):String
		{
			return Math.min(bar.currentValue >> 0, 100) + "%";
		}

		private function text2Handler(bar:TProgressBar):String
		{
			return _title + " " + Math.min(bar.currentValue >> 0, 100) + "%";
		}
	}
}
