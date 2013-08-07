package fj1.common.ui.effects
{
	import fj1.common.staticdata.Profession;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import tempest.utils.Fun;

	public class ProfessionSwitchEffect
	{
		private var _target:MovieClip;
		private var _currentFrame:int;
		private var _targetFrame:int;
		private var _timer:Timer;

		public function ProfessionSwitchEffect(target:MovieClip)
		{
			Fun.stopMC(target);
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_target = target;
		}

		private function onTimer(event:TimerEvent):void
		{
			if (_currentFrame == _targetFrame)
			{
				_timer.stop();
			}
			else
			{
				if (_currentFrame < _targetFrame)
				{
					_currentFrame++;
				}
				else if (_currentFrame > _targetFrame)
				{
					_currentFrame--;
				}
				_target.gotoAndStop(_currentFrame);
			}
		}

		public function switchProfession(profession:int):void
		{
			switch (profession)
			{
				case Profession.Gladiator: //角斗士
					goToFrame(1);
					break;
				case Profession.DarkMage: //暗法师
					goToFrame(6);
					break;
				case Profession.Luna: //月神使
					goToFrame(11);
					break;
				case Profession.Avenger: //复仇者
					goToFrame(16);
					break;
			}
		}

		private function goToFrame(frame:int):void
		{
			if (!_timer.running)
			{
				_timer.start();
			}
			_targetFrame = frame;
		}
	}
}
