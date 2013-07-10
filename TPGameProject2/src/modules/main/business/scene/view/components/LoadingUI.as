package modules.main.business.scene.view.components
{
	import modules.main.common.ui.ProgressBar;

	import tempest.ui.components.TComponent;
	import tempest.ui.components.TLayoutContainer;

	public class LoadingUI extends TLayoutContainer
	{
		private var _progressBar:ProgressBar;

		public function LoadingUI()
		{
			super({left: 0, right: 0, top: 0, bottom: 0});
		}

		override protected function addChildren():void
		{
			_progressBar = new ProgressBar({horizontalCenter: 0, bottom: 60});
			this.addChild(_progressBar);
		}

		/**
		 * 更新进度条
		 * @param tip
		 * @param value
		 */
		public function updateLoading(value:Number):void
		{
			if (value >= 0)
			{
				_progressBar.setProgress(value);
			}
		}
	}
}
