package fj1.common.ui
{
	import assets.UISkinLib;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.ITLayoutContainer;
	import tempest.ui.components.TButton;
	import tempest.ui.events.TWindowEvent;
	import fj1.common.ui.tips.LoaderTip;

	public class LoaderTipWindow extends BaseWindow implements ITLayoutContainer
	{
		public static const NAME:String = "LoaderTipWindow";

		public function LoaderTipWindow(loaderTip:LoaderTip)
		{
			super(null, loaderTip, NAME);
			loaderTip.addEventListener(Event.RESIZE, onResize);
			loaderTip.mouseEnabled = true;
			_btn_close = new TButton({right: 7, top: 7}, TRslManager.getInstance(UISkinLib.closeBtnSkin), null, onClose);
			this.addChild(_btn_close);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			loaderTip.data = event.data;
			this.measureChildren(false);
			this.invalidateSize();
		}

		override protected function getBg():DisplayObject
		{
			return loaderTip;
		}

		private function onResize(event:Event):void
		{
			this.measureChildren(false);
			this.invalidateSize();
		}

		private function get loaderTip():LoaderTip
		{
			return LoaderTip(_proxy);
		}

		public function set loaderId(value:int):void
		{
			data = value;
		}

		public function get loaderId():int
		{
			return int(data);
		}
	}
}
