package modules.main.business.battle.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class BattleModelSignals extends SignalSet
	{
		public function BattleModelSignals()
		{
			super();
		}

		public function get playerAdd():ISignal
		{
			return getSignal("playerAdd", Signal);
		}

		public function get playerRemove():ISignal
		{
			return getSignal("playerRemove", Signal);
		}
	}
}
