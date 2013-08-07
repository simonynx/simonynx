package fj1.modules.formation.signal
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class FormationSignal extends SignalSet
	{
		public function FormationSignal()
		{
			super();
		}

		/**
		 * 显示阵型面板
		 * @return
		 *
		 */
		public function get showFormationPanel():ISignal
		{
			return getSignal("showFormationPanel", Signal);
		}
	}
}
