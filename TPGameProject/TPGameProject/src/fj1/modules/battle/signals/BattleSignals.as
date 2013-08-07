package fj1.modules.battle.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class BattleSignals extends SignalSet
	{
		public static const BATTLE_START:String = "battleStart";
		public static const BATTLE_END:String = "battleEnd";

		public function BattleSignals()
		{
			super();
		}

		public function get battleStart():ISignal
		{
			return getSignal("battleStart", Signal);
		}

		public function get battleEnd():ISignal
		{
			return getSignal("battleEnd", Signal);
		}
		
		public function get quitBattle():ISignal
		{
			return getSignal("quitBattle", Signal);
		}

	}
}
