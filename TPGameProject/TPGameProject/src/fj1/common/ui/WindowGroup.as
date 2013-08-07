package fj1.common.ui
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;

	public class WindowGroup
	{
		private var _windowArray:Array;

		public function WindowGroup()
		{
			_windowArray = [];
		}

		/**
		 * 打开一个窗口，同时关闭其他的互斥窗口
		 * 相同名称的窗口不会同时存在
		 * @param name 名称
		 * @param modal
		 * @param useCover
		 * @param offset
		 * @param parms
		 * @return
		 *
		 */
		public function showMutexWindow(parentWindow:TWindow, name:String, modal:Boolean = false, useCover:Boolean = false, offset:Point = null, parms:Object = null, dataParams:Object =
			null, manageModel:int = 2 /*TWindowManager.MODEL_USE_OLD*/):TWindow
		{
			var window:TWindow = TWindow(TWindowManager.instance.showPopup2(parentWindow, name, modal, useCover, manageModel, offset, parms, dataParams));
			if (window == null)
				return null;
			window.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			//关闭互斥窗口
			for (var i:int = 0; i < _windowArray.length; i++)
			{
				var element:TWindow = _windowArray[i] as TWindow;
				if (element == window)
				{
					continue;
				}
				element.closeWindow();
			}
			return window;
		}

		/**
		 * 打开一个窗口
		 * 相同名称的窗口可以同时存在
		 * @param name
		 * @param modal
		 * @param useCover
		 * @param offset
		 * @param parms
		 * @return
		 *
		 */
		public function showWindow(parentWindow:TWindow, obj:DisplayObject, modal:Boolean = false, useCover:Boolean = false, offset:Point = null, parms:Object = null):TWindow
		{
			var window:TWindow = TWindow(TWindowManager.instance.showPopup(parentWindow, obj, modal, useCover, offset, parms));
			window.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			_windowArray.push(window);
			return window;
		}

		/**
		 * 查找组中的窗口
		 * @param name 窗口名称（为null时不以窗口名称作为查找条件之一）
		 * @param findHandler 格式为function(TWindow):Boolean 的方法，用于查找
		 * @return
		 *
		 */
		public function find(name:String, findHandler:Function):TWindow
		{
			for (var i:int = 0; i < _windowArray.length; i++)
			{
				var element:TWindow = _windowArray[i] as TWindow;
				if (element.name == name || name == null)
				{
					if (findHandler != null && findHandler(element))
					{
						break;
					}
					else if (findHandler == null)
					{
						break;
					}
				}
			}
			if (i != _windowArray.length)
				return _windowArray[i] as TWindow;
			else
				return null;
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			for (var i:int = 0; i < _windowArray.length; i++)
			{
				if (_windowArray[i] == event.currentTarget)
				{
					_windowArray.splice(i, 1);
					break;
				}
			}
		}
	}
}
