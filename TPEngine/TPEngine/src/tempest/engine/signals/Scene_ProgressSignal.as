package tempest.engine.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;
	
	public class Scene_ProgressSignal extends SignalSet
	{
		private var _smallMapLoaded:ISignal;
		public function Scene_ProgressSignal()
		{
			super();
		}
		public function get smallMapLoaded():ISignal
		{
			return _smallMapLoaded ||= getSignal("smallMapLoaded",Signal);
		}
	}
}