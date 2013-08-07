package fj1.modules.sound.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class SoundSignal extends SignalSet
	{
		public function get setBackGroundSound():ISignal
		{
			return getSignal("setBackGroundSound", Signal);
		}

		public function get setGameSound():ISignal
		{
			return getSignal("setGameSound", Signal);
		}

		public function get addGameSound():ISignal
		{
			return getSignal("addSound", Signal, int);
		}

		public function get addBackGroundSound():ISignal
		{
			return getSignal("addBackGroundSound", Signal, String);
		}
	}
}
