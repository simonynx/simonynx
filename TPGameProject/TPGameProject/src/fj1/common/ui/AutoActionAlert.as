package fj1.common.ui
{
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.staticdata.HintConst;

	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TWindowEvent;
	import tempest.utils.StringUtil;

	public class AutoActionAlert extends TAlert
	{
		private var _autoAction:String;
		private var _delay:int;
		private var _timer:TimerData;
		private var _pureText:String;
		private var _pattern:String;

		public function AutoActionAlert(text:String, title:String, flags:uint = 4, closeHandler:Function = null, autoAction:String = "none", delay:int = 0, pattern:String = "", defaultButtonFlag:uint =
			4)
		{
			_pureText = text;
			_autoAction = autoAction;
			_pattern = pattern;
			_delay = delay;
			_timer = TimerManager.createNormalTimer(1000, 0, updateHandler);
			super(getFullText(), title, flags, closeHandler, defaultButtonFlag, "");
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			if (_timer.running)
			{
				_timer.stop();
			}
		}

		private function updateHandler():void
		{
			if (_delay == _timer.currentCount)
			{
				_timer.stop();
				onComplete();
			}
			super.text = getFullText();
		}

		private function getFullText():String
		{
			var txt:String = StringFormatHelper.format(_pattern, _pureText);
			return txt.replace("{delay}", _delay - _timer.currentCount);
		}

		private function onComplete():void
		{
			switch (_autoAction)
			{
				case HintConst.SCRIPTHINT_ACTION_OK:
					closeWindow();
					if (_closeHandler != null)
						dispatchEvent(new TAlertEvent(DataEvent.DATA, int(btn_left.data)));
					break;
				case HintConst.SCRIPTHINT_ACTION_CANCEL:
					closeWindow();
					if (_closeHandler != null)
						dispatchEvent(new TAlertEvent(DataEvent.DATA, int(btn_right.data)));
					break;
			}
		}

		public static function Show(content:String, title:String = "", modal:Boolean = true, flags:uint = OK, closeHandler:Function = null, autoAction:String = "none", delay:int = 0, pattern:String = "", defaultButtonFlag:uint =
			OK):TAlert
		{
			var alert:AutoActionAlert = new AutoActionAlert(content, title, flags, closeHandler, autoAction, delay, pattern, defaultButtonFlag);
			TAlert.showAlert(null, alert, modal);
			return alert;
		}
	}
}
