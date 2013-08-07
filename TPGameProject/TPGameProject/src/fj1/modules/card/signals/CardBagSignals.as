package fj1.modules.card.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class CardBagSignals extends SignalSet
	{
		public function get changeViewModel():ISignal
		{
			return getSignal("changeViewModel", Signal);
		}

		public function get cardSelected():ISignal
		{
			return getSignal("cardSelected", Signal);
		}
	}
}
