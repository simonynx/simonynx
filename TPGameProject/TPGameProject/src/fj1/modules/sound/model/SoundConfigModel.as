package fj1.modules.sound.model
{
	import fj1.modules.sound.signals.SoundSignal;

	public class SoundConfigModel
	{
		[Inject]
		public var signal:SoundSignal;
		private var _backGroundSoundStatus:Boolean = false;
		private var _gameSoundStatus:Boolean = false;

		public function SoundConfigModel()
		{
//			backGroundSoundStatus = true;
		}

		public function get gameSoundStatus():Boolean
		{
			return _gameSoundStatus;
		}

		public function set gameSoundStatus(value:Boolean):void
		{
			if (_gameSoundStatus != value)
			{
				_gameSoundStatus = value;
			}
			signal.setGameSound.dispatch();
		}

		public function get backGroundSoundStatus():Boolean
		{
			return _backGroundSoundStatus;
		}

		public function set backGroundSoundStatus(value:Boolean):void
		{
			if (_backGroundSoundStatus != value)
			{
				_backGroundSoundStatus = value;
			}
			signal.setBackGroundSound.dispatch();
		}
	}
}
