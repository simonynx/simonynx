package fj1.common
{
	import fj1.modules.login.signals.LoginSignal;
	import fj1.modules.scene.signals.SceneSignals;

	import org.osflash.signals.utilities.SignalSet;

	public class SignalInstance
	{
		private var _sceneSignals:SceneSignals;

		public function SignalInstance()
		{
			super();
		}

		public function get sceneSignals():SceneSignals
		{
			return _sceneSignals ||= new SceneSignals();
		}
	}
}
