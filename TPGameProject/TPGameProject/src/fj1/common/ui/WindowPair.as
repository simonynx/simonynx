package fj1.common.ui
{
	import com.gskinner.motion.GTweener;

	import fj1.common.GameInstance;

	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;

	public class WindowPair
	{
		private static var _instance:WindowPair;

		public static function get instance():WindowPair
		{
			return _instance ||= new WindowPair();
		}

		private var _nameLeft:String;
		private var _wndLeft:TWindow;

		private var _nameRight:String;
		private var _wndRight:TWindow;

		public function WindowPair()
		{
			super();
		}

		private var _loadingNum:int = 0;

		public function setPair(nameLeft:String, nameRight:String, parmsL:Object = null, dataParmsL:Object = null, parmsR:Object = null, dataParmsR:Object = null, onAllComplete:Function = null):void
		{
			if (_loadingNum != 0)
			{
				return;
			}

			if (_nameRight == nameLeft)
			{
				setRight(nameRight, parmsR, dataParmsR, onAllComplete);
				setLeft(nameLeft, parmsL, dataParmsL, onAllComplete);
			}
			else
			{
				setLeft(nameLeft, parmsL, dataParmsL, onAllComplete);
				setRight(nameRight, parmsR, dataParmsR, onAllComplete);
			}

			if (_loadingNum <= 0)
			{
				_onAllComplete();
				if (onAllComplete != null)
				{
					onAllComplete(_wndLeft, _wndRight);
				}
			}
		}

		public function closeAll():void
		{
			if (_loadingNum != 0)
			{
				return;
			}
			if (_wndLeft)
			{
				_wndLeft.removeEventListener(TWindowEvent.WINDOW_CLOSE, onLeftWndClose);
				_wndLeft.closeWindow();
				_wndLeft = null;
				_nameLeft = null;
			}
			if (_wndRight)
			{
				_wndRight.removeEventListener(TWindowEvent.WINDOW_CLOSE, onRightWndClose);
				_wndRight.closeWindow();
				_wndRight = null;
				_nameRight = null;
			}
		}

		private function setLeft(nameLeft:String, parmsL:Object = null, dataParmsL:Object = null, onAllComplete:Function = null):void
		{
			if (_nameLeft != nameLeft)
			{
				if (_wndLeft)
				{
					_wndLeft.removeEventListener(TWindowEvent.WINDOW_CLOSE, onLeftWndClose);
					_wndLeft.closeWindow();
					_wndLeft = null;
				}
				_nameLeft = nameLeft;
				var windowL:TWindow = TWindowManager.instance.getWindow(_nameLeft);
				if (windowL)
				{
					_wndLeft = TWindowManager.instance.showPopup2(null, _nameLeft, false, false, TWindowManager.MODEL_USE_OLD, null, parmsL, dataParmsL) as TWindow;
					_wndLeft.x = (GameInstance.app.width - _wndLeft.width) * 0.5;
				}
				else
				{
					++_loadingNum;
					TWindowManager.instance.showPopup2(null, _nameLeft, false, false, TWindowManager.MODEL_USE_OLD, null, parmsL, dataParmsL, function(wndL:TWindow):void
					{
						--_loadingNum;
						_wndLeft = wndL;
						if (_loadingNum <= 0)
						{
							_onAllComplete();
							if (onAllComplete != null)
							{
								onAllComplete(_wndLeft, _wndRight);
							}
						}
					});
				}
			}
		}

		private function setRight(nameRight:String, parmsR:Object = null, dataParmsR:Object = null, onAllComplete:Function = null):void
		{
			if (_nameRight != nameRight)
			{
				if (_wndRight)
				{
					_wndRight.removeEventListener(TWindowEvent.WINDOW_CLOSE, onRightWndClose);
					_wndRight.closeWindow();
					_wndRight = null;
				}
				_nameRight = nameRight;
				var windowR:TWindow = TWindowManager.instance.getWindow(_nameRight);
				if (windowR)
				{
					_wndRight = TWindowManager.instance.showPopup2(null, _nameRight, false, false, TWindowManager.MODEL_USE_OLD, null, parmsR, dataParmsR) as TWindow;
					_wndRight.x = (GameInstance.app.width - _wndRight.width) * 0.5;
				}
				else
				{
					++_loadingNum;
					TWindowManager.instance.showPopup2(null, _nameRight, false, false, TWindowManager.MODEL_USE_OLD, null, parmsR, dataParmsR, function(wndR:TWindow):void
					{
						--_loadingNum;
						_wndRight = wndR;
						if (_loadingNum <= 0)
						{
							_onAllComplete();
							if (onAllComplete != null)
							{
								onAllComplete(_wndLeft, _wndRight);
							}
						}
					});
				}
			}
		}

		private function _onAllComplete():void
		{
			_wndLeft.addEventListener(TWindowEvent.WINDOW_CLOSE, onLeftWndClose);
			_wndRight.addEventListener(TWindowEvent.WINDOW_CLOSE, onRightWndClose);
			centerLayout();
		}

		private function centerLayout():void
		{
			if (_wndLeft && _wndRight)
			{
				var leftX:Number = (GameInstance.app.width - _wndLeft.width - _wndRight.width) * 0.5;
				_wndLeft.constraints = {verticalCenter: 0, horizontalCenter: -_wndRight.width * 0.5};
				_wndRight.constraints = {verticalCenter: 0, horizontalCenter: _wndLeft.width * 0.5};
				GTweener.to(_wndLeft, 0.3, {x: leftX});
				GTweener.to(_wndRight, 0.3, {x: leftX + _wndLeft.width});
			}
			else if (_wndLeft)
			{
				GTweener.to(_wndLeft, 0.3, {x: (GameInstance.app.width - _wndLeft.width) * 0.5});
			}
			else if (_wndRight)
			{
				GTweener.to(_wndRight, 0.3, {x: (GameInstance.app.width - _wndRight.width) * 0.5});
			}
		}

		private function onLeftWndClose(e:TWindowEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			GTweener.removeTweens(_wndLeft);
			_nameLeft = null;
			_wndLeft = null;
			centerLayout();
		}

		private function onRightWndClose(e:TWindowEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			GTweener.removeTweens(_wndRight);
			_nameRight = null;
			_wndRight = null;
			centerLayout();
		}
	}
}
