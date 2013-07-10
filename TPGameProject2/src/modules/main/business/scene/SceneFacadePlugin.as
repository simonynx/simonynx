package modules.main.business.scene
{
	import modules.main.business.scene.controller.SceneStartupCommand;
	import modules.main.business.scene.model.SceneModel;
	import modules.main.business.scene.signals.SceneLoadingUISignals;
	import modules.main.business.scene.signals.SceneSignals;

	import tempest.common.mvc.base.TFacadePlugin;

	public class SceneFacadePlugin extends TFacadePlugin
	{
		public function SceneFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(SceneSignals);
			inject.mapSingleton(SceneLoadingUISignals);
			inject.mapSingleton(SceneModel);

			commandMap.map([this.startupSignal], SceneStartupCommand);
		}
	}
}
