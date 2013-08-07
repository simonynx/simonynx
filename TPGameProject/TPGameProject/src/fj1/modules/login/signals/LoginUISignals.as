package fj1.modules.login.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class LoginUISignals extends SignalSet
	{
		public function LoginUISignals()
		{
			super();
		}

		public function get showTipPanel():ISignal
		{
			return getSignal("showTipPanel", Signal);
		}

		public function get showLineSelectPanel():ISignal
		{
			return getSignal("showLineSelectPanel", Signal);
		}

//		public function get showRoleSelectPanel():ISignal
//		{
//			return getSignal("showRoleSelectPanel", Signal);
//		}

		public function get showRoleCreatePanel():ISignal
		{
			return getSignal("showRoleCreatePanel", Signal);
		}

		public function get showP2Panel():ISignal
		{
			return getSignal("showP2Panel", Signal);
		}

		public function get showP2ResetPanel():ISignal
		{
			return getSignal("showP2ResetPanel", Signal);
		}

		public function get showP2SetPanel():ISignal
		{
			return getSignal("showP2SetPanel", Signal);
		}

		public function get showLoginPanel():ISignal
		{
			return getSignal("showLoginPanel", Signal);
		}

	}
}
