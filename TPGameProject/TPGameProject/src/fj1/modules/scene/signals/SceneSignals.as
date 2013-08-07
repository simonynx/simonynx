package fj1.modules.scene.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	import tempest.engine.SceneCharacter;

	public class SceneSignals extends SignalSet
	{
		public function SceneSignals()
		{
			super();
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get reloadScene():ISignal
		{
			return getSignal("reloadScene", Signal);
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

		/**
		 * 移除角色时触发
		 * @return
		 *
		 */
		public function get removeCharacter():ISignal
		{
			return getSignal("removeCharacter", Signal, int);
		}

		/**
		 * 添加角色时触发
		 * @return
		 *
		 */
		public function get addCharacter():ISignal
		{
			return getSignal("addCharacter", Signal, SceneCharacter);
		}

		/**
		 * 场景角色移动触发
		 * @return
		 *
		 */
		public function get mainCharMove():ISignal
		{
			return getSignal("mainCharMove", Signal);
		}
	}
}
