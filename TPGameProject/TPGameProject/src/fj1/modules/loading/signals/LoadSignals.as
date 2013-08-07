package fj1.modules.loading.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class LoadSignals extends SignalSet
	{
		public function LoadSignals()
		{
			super();
		}

		public function get loadRes():ISignal
		{
			return getSignal("loadRes", Signal);
		}

		public function get loadResComplete():ISignal
		{
			return getSignal("loadResComplete", Signal);
		}
	}
}
