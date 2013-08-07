package tempest.engine.signals
{
	import flash.events.MouseEvent;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.vo.map.MapTile;

	public class SceneSignal extends SignalSet
	{
		private var _interactive:ISignal;
		private var _progress:Scene_ProgressSignal;
		private var _status:ISignal;
		private var _walk:ISignal;

		public function SceneSignal()
		{
			super();
		}

		public function get interactive():ISignal
		{
			return _interactive ||= getSignal("interactive", Signal, MouseEvent, BaseElement);
		}

		public function get progress():Scene_ProgressSignal
		{
			return _progress ||= new Scene_ProgressSignal();
		}

		public function get status():ISignal
		{
			return _status ||= getSignal("status", Signal);
		}

		public function get walk():ISignal
		{
			return _walk ||= getSignal("walk", Signal, String, SceneCharacter, MapTile, Array);
		}
	}
}
