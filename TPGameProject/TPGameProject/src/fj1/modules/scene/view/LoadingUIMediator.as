package fj1.modules.scene.view
{
	import fj1.modules.scene.signals.SceneLoadingUISignals;
	import fj1.modules.scene.view.components.LoadingUI;

	import org.osflash.signals.Signal;

	import tempest.common.mvc.base.Mediator;

	public class LoadingUIMediator extends Mediator
	{
		[Inject]
		public var loadingUI:LoadingUI;

		[Inject]
		public var signals:SceneLoadingUISignals;

		public function LoadingUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(signals.loadProgress, onLoadProgress);
		}

		private function onLoadProgress(percent:Number):void
		{
			loadingUI.updateLoading(percent);
		}
	}
}
