package tempest.ui
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import mx.core.IFactory;

	import tempest.common.pool.Pool;
	import tempest.core.IPoolClient;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;
	import tempest.ui.events.TWindowPoolEvent;

	[Event(name = "window_show", type = "tempest.ui.events")]
	[Event(name = "window_close", type = "tempest.ui.events")]
	public class TWindowPool extends EventDispatcher
	{
		private var _name:String;
		private var _pool:Pool;
		private var _windowClass:Class

		public function TWindowPool(name:String, windowClass:Class)
		{
			super(this);
			_pool = new Pool(name);
			_windowClass = windowClass;
		}

		public function get name():String
		{
			return _pool.name;
		}

		public function showWindow(modal:Boolean = false, useCover:Boolean = false, offset:Point = null, params:Object = null):TWindow
		{
			var tWindow:TWindow = _pool.createObj(_windowClass) as TWindow;
			tWindow.addEventListener(TWindowEvent.WINDOW_CLOSE, onClose);
			PopupManager.instance.showPopup2(null, tWindow, modal, useCover, offset);
			tWindow.dispatchEvent(new TWindowEvent(TWindowEvent.WINDOW_SHOW, params));
			dispatchEvent(new TWindowPoolEvent(TWindowPoolEvent.WINDOW_SHOW, tWindow));
			return tWindow;
		}

		public function closeWindow(tWindow:TWindow):void
		{
			tWindow.closeWindow();
		}

		private function onClose(event:TWindowEvent):void
		{
			_pool.disposeObj(IPoolClient(event.currentTarget));
			dispatchEvent(new TWindowPoolEvent(TWindowPoolEvent.WINDOW_CLOSE, TWindow(event.currentTarget)));
		}
	}
}
