package modules.main.common
{
	import com.adobe.utils.ArrayUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.PopupManager;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;

	public class TWindowManager
	{
		private static const log:ILogger = TLog.getLogger(TWindowManager);
		private static var _instance:TWindowManager = null;
		public static const MODEL_REMOVE_AND_ADD:int = 1;
		public static const MODEL_USE_OLD:int = 2;
		public static const MODEL_REMOVE_OR_ADD:int = 3;
		public static const NAME_SINGLE_DIALOG:String = "singleDialog";
		private var _window_name_map:Dictionary = new Dictionary();
		private var _window_id_map:Dictionary = new Dictionary();
		private var _showingWindowList:Array = [];

		public function TWindowManager()
		{
			_instance = this;
			PopupManager.coverChangeSignal.add(onCoverChange);
		}

		public static function get instance():TWindowManager
		{
			if (_instance == null)
				new TWindowManager();
			return _instance;
		}

		private function onCoverChange(hasCover:Boolean):void
		{
			var dispObject:* = null;
			var window:TWindow = null;
			for each (dispObject in _showingWindowList)
			{
				window = (dispObject as TWindow);
				if (window)
				{
					window.stopDraging();
				}
			}
		}

		/**
		 * 获取顶层窗口
		 * @return
		 *
		 */
		public function getTopPopupWindow():TWindow
		{
			if (getPopupNum())
			{
				var popupLayer:DisplayObjectContainer = PopupManager.instance.popupLayer;
				for (var i:int = popupLayer.numChildren - 1; i >= 0; --i)
				{
					var child:TWindow = popupLayer.getChildAt(i) as TWindow;
					if (child)
					{
						return child;
					}
				}
			}
			return null;
		}

		/**
		 * 关闭符合关闭条件的窗口
		 * @param findHandler
		 *
		 */
		public function bulkCloseWindow(findHandler:Function):void
		{
			var window:TWindow;
			var listCopy:Array = _showingWindowList.slice();
			for each (window in listCopy)
			{
				if (findHandler(window))
				{
					window.closeWindow();
				}
			}
		}

		/**
		 * 获取弹出窗口数
		 * @return
		 *
		 */
		public function getPopupNum():int
		{
			return _showingWindowList.length;
		}

		/**
		 * 使用name删除窗口
		 * @param name
		 *
		 */
		public function removePopupByName(name:String):void
		{
			var obj:DisplayObject = findPopup(name);
			if (obj)
			{
				remove(obj);
			}
		}

		private function remove(obj:DisplayObject):void
		{
			var tWindow:TWindow = obj as TWindow;
			if (tWindow)
			{
				tWindow.closeWindow();
			}
			else
			{
				onClose(null);
			}
		}

		private function onClose(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			ArrayUtil.removeValueFromArray(_showingWindowList, event.currentTarget);
		}

		/**
		 * 删除所有窗口
		 * @param obj
		 *
		 */
		public function removeAllPopup():void
		{
			var wndListCopy:Array = _showingWindowList.slice();
			for each (var wnd:TWindow in wndListCopy)
			{
				wnd.closeWindow();
			}
//			PopupManager.instance.removeAllPopup();
			_showingWindowList = [];
		}

		/**
		 * 获取显示中的窗口
		 * @param name
		 * @return
		 *
		 */
		public function findPopup(name:String):DisplayObject
		{
			for (var i:int = 0; i < _showingWindowList.length; ++i)
			{
				var obj:DisplayObject = _showingWindowList[i] as DisplayObject;
				if (obj.name == name)
				{
					return obj;
				}
			}
			return null;
		}

		/**
		 * 获取当前显示窗口列表的副本
		 * @return
		 *
		 */
		public function get showingWindowList():Array
		{
			return _showingWindowList.slice();
		}

		/**
		 * 注册弹出窗口
		 * @param name
		 * @param window
		 *
		 */
		public function registerWindow(name:String, window:TWindow):TWindow
		{
			if (!_window_name_map.hasOwnProperty(name))
			{
				_window_name_map[name] = window;
				if (window.hasOwnProperty("windowId"))
				{
					_window_id_map[window["windowId"]] = window;
				}
				window.dispatchEvent(new TWindowEvent(TWindowEvent.REGISTER));
			}
			else
			{
				log.error("重复注册弹窗！！！window.name = " + window.name);
			}
			return window;
		}

		/**
		 * 注册弹出窗口
		 * @param name
		 * @param window
		 *
		 */
		public function registerWindow2(window:TWindow):TWindow
		{
			if (window.name)
			{
				if (!_window_name_map.hasOwnProperty(window.name))
				{
					_window_name_map[window.name] = window;
					if (window.hasOwnProperty("windowId"))
					{
						_window_id_map[window["windowId"]] = window;
					}
					window.dispatchEvent(new TWindowEvent(TWindowEvent.REGISTER));
				}
				else
				{
					log.error("重复注册弹窗！！！window.name = " + window.name);
				}
			}
			else
			{
				log.error("无效的窗口名称window.name = " + window.name);
			}
			return window;
		}

		/**
		 *保存所有有窗口id（windowId）的窗口
		 * @return
		 *
		 */
		public function get windowsIdMap():Dictionary
		{
			return _window_id_map;
		}

		/**
		 * 获得注册的窗口实例
		 * @param name
		 * @return
		 *
		 */
		public function getWindow(name:String):TWindow
		{
			return TWindow(_window_name_map[name]);
		}

		/**
		 * 通过窗口id获取窗口
		 * @param id
		 * @return
		 *
		 */
		public function getWindowById(id:int):TWindow
		{
			return TWindow(_window_id_map[id]);
		}

		/**
		 * 显示一个窗口
		 *
		 * @param obj	窗口实例
		 * @param modal	是否是模态窗口
		 * @param center	居中模式（CenterMode）
		 */
		public function showPopup(parentWindow:TWindow, obj:DisplayObject, modal:Boolean = true, useCover:Boolean = false, offest:Point = null, parms:Object = null, dataParms:Object = null):DisplayObject
		{
			//已打开的窗体不做处理
			if (obj.parent)
			{
				return obj;
			}
			_showingWindowList.push(obj);
			if (obj is TWindow)
				obj.addEventListener(TWindowEvent.WINDOW_CLOSE, onClose);
			if (dataParms)
			{
				setWindowData(obj, dataParms);
			}
			PopupManager.instance.showPopup2(parentWindow, obj, modal, useCover, offest);
			obj.dispatchEvent(new TWindowEvent(TWindowEvent.WINDOW_SHOW, parms));
			return obj;
		}

		/**
		 *
		 * @param name 窗口名
		 * @param windowClass	窗口类
		 * @param modal	是否是模态窗口
		 * @param useCover 是否使用背景遮罩
		 * @param managerModel 管理类型（MODEL_REMOVE_OLD：删除旧的窗口；MODEL_USE_OLD：使用旧的窗口，不创建新窗口）
		 * @param offest
		 * @param parms 参数（通过WINDOW_SHOW事件的data携带参数）
		 * @param dataParms 参数2（给TWindow.data赋值）
		 * @return
		 *
		 */
		public function showPopup2(parentWindow:TWindow, name:String, modal:Boolean = false, useCover:Boolean = false, managerModel:int = MODEL_USE_OLD, offset:Point = null, parms:Object = null, dataParms:Object =
			null):DisplayObject
		{
			var needCreate:Boolean = true;
			var wnd:TWindow;
			switch (managerModel)
			{
				case MODEL_USE_OLD:
					var obj:DisplayObject = findPopup(name);
					if (obj)
					{
						wnd = obj as TWindow;
						if (wnd && wnd.effect && wnd.effect.closeEffect.playing) //当前窗口正在关闭，打开窗口
						{
							wnd.effect.playOpenEffect();
						}
						if (dataParms)
						{
							setWindowData(obj, dataParms);
						}
						obj.dispatchEvent(new TWindowEvent(TWindowEvent.WINDOW_SHOW, parms)); //重复打开窗口时，同样抛出WINDOW_SHOW事件
						obj.parent.setChildIndex(obj, obj.parent.numChildren - 1); //窗口置顶
						if (obj is TWindow)
						{
							obj.dispatchEvent(new TWindowEvent(TWindowEvent.MOVE_TO_TOP));
						}
						return obj;
					}
					break;
				case MODEL_REMOVE_AND_ADD:
					for (var i:int = 0; i < _showingWindowList.length; ++i)
					{
						var obj2:DisplayObject = _showingWindowList[i] as DisplayObject;
						if (obj2.name == name)
						{
							remove(obj2);
						}
					}
					break;
				case MODEL_REMOVE_OR_ADD:
					var obj3:DisplayObject = findPopup(name);
					if (obj3)
					{
						needCreate = false;
						wnd = obj3 as TWindow;
						if (wnd && wnd.effect && wnd.effect.closeEffect.playing) //当前窗口正在关闭，打开窗口
						{
							wnd.effect.playOpenEffect();
							setWindowData(obj3, dataParms);
							obj3.dispatchEvent(new TWindowEvent(TWindowEvent.WINDOW_SHOW, parms));
						}
						else
						{
							remove(obj3);
						}
						return null;
					}
					break;
				default:
					break;
			}
			if (needCreate)
			{
				var newV:DisplayObject = _window_name_map[name] as DisplayObject; // new windowClass();
				if (!newV)
				{
					throw new Error("弹出窗口 " + name + "未注册");
				}
				this.showPopup(parentWindow, newV, modal, useCover, offset, parms, dataParms);
				return newV;
			}
			return null;
		}

		private function setWindowData(disObj:DisplayObject, data:Object):void
		{
			var window:TWindow = disObj as TWindow;
			if (window)
			{
				window.data = data;
			}
		}

		public static function getParentWindow(obj:DisplayObject):TWindow
		{
			var parent:DisplayObjectContainer = obj.parent;
			while (parent)
			{
				if (parent is TWindow)
				{
					return TWindow(parent);
				}
				parent = parent.parent;
			}
			return null;
		}
	}
}
