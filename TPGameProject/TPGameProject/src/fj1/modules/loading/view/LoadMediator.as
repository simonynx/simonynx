package fj1.modules.loading.view
{
	import fj1.modules.loading.signals.LoadViewSignals;
	import fj1.modules.loading.view.components.MainLoader;

	import org.osflash.signals.Signal;

	import tempest.common.mvc.base.Mediator;

	public class LoadMediator extends Mediator
	{
		[Inject]
		public var loadingView:MainLoader;

		[Inject]
		public var signals:LoadViewSignals;

		public function LoadMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(signals.loadProgress, onLoadProgress);
		}

		private function onLoadProgress(percent1:Number, percent2:Number):void
		{
			loadingView.update(percent1, percent2);
		}
	}
}
