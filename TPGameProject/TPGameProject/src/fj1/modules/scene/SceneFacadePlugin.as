package fj1.modules.scene
{
	import fj1.common.GameInstance;
	import fj1.modules.scene.controller.SceneFacadeStartupCommand;
	import fj1.modules.scene.model.SceneModel;
	import fj1.modules.scene.net.SceneService;
	import fj1.modules.scene.signals.SceneLoadingUISignals;
	import fj1.modules.scene.signals.SceneSignals;

	import tempest.common.mvc.base.TFacadePlugin;

	public class SceneFacadePlugin extends TFacadePlugin
	{
		public function SceneFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapValue(SceneSignals, GameInstance.signal.sceneSignals);
			inject.mapSingleton(SceneLoadingUISignals);
			inject.mapSingleton(SceneModel);
			inject.mapSingleton(SceneService);

			commandMap.map([this.startupSignal], SceneFacadeStartupCommand);
		}
	}
}
