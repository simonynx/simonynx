package fj1.common
{
	import fj1.common.ui.WindowPair;

	import flash.utils.Dictionary;

	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;

	public class WindowMutex extends MutexHandler
	{
		public function setWindow(window:TWindow):void
		{
			this.setOperate(window.name, function():void
			{
				window.closeWindow();
			});
			window.addEventListener(TWindowEvent.WINDOW_CLOSE, function(e:TWindowEvent):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				clean(window.name);
			});
		}

		public function showPair(mutexName:String, nameMain:String, nameRight:String, parmsL:Object = null, dataParmsL:Object = null, parmsR:Object = null, dataParmsR:Object = null):void
		{
			MutexManager.instance.windowMutex.setOperate(mutexName, function():void
			{
				WindowPair.instance.closeAll();
			});
			WindowPair.instance.setPair(nameMain, nameRight, null, null, null, null, function(wndLeft:TWindow, wndRight:TWindow):void
			{
				wndLeft.addEventListener(TWindowEvent.WINDOW_CLOSE, function(e:TWindowEvent):void
				{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					MutexManager.instance.windowMutex.clean(mutexName);
				});
			});
		}
	}
}
