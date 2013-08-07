package fj1.common.signals
{
	import fj1.common.res.npc.vo.NpcRes;
	import flash.geom.Point;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;
	import tempest.engine.SceneCharacter;

	public class MainCharSignal extends SignalSet
	{
		public function get initComplete():ISignal
		{
			return getSignal("initComplete", Signal);
		}
	}
}
