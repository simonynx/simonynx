package modules.main.business.scene.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class SceneSignals extends SignalSet
	{
		public function SceneSignals()
		{
			super();
		}

		/**
		 * 切换场景
		 * @return
		 *
		 */
		public function get switchScene():ISignal
		{
			return getSignal("switchScene", Signal);
		}

		/**
		 * 切换场景结束
		 * @return
		 *
		 */
		public function get switchSceneComplete():ISignal
		{
			return getSignal("switchSceneComplete", Signal);
		}
	}
}
