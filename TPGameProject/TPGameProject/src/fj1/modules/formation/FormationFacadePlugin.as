package fj1.modules.formation
{
	import fj1.modules.formation.controller.FormationFacadeStartupCommand;
	import fj1.modules.formation.model.FormationModel;
	import fj1.modules.formation.service.FormationService;
	import fj1.modules.formation.signal.FormationSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class FormationFacadePlugin extends TFacadePlugin
	{
		public function FormationFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(FormationSignal);
			inject.mapSingleton(FormationService);
			inject.mapSingleton(FormationModel);
			commandMap.map([this.startupSignal], FormationFacadeStartupCommand);
		}
	}
}
