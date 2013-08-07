package fj1.modules.loading.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class LoadViewSignals extends SignalSet
	{
		public function LoadViewSignals()
		{
			super();
		}

		public function get loadProgress():ISignal
		{
			return getSignal("loadProgress", Signal);
		}
	}
}
