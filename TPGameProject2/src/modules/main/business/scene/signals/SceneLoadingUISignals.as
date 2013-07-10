package modules.main.business.scene.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	import tempest.common.SignalSetEx;

	public class SceneLoadingUISignals extends SignalSet
	{
		public function SceneLoadingUISignals()
		{
			super();
		}

		public function get loadProgress():ISignal
		{
			return getSignal("loadProgress", Signal);
		}

		public function get show():ISignal
		{
			return getSignal("show", Signal);
		}
	}
}
