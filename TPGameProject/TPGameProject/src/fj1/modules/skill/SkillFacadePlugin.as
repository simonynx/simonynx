package fj1.modules.skill
{
	import fj1.common.GameInstance;
	import fj1.modules.skill.controller.SkillFacadeStartupCommand;
	import fj1.modules.skill.model.SkillModel;
	import fj1.modules.skill.signals.SkillSignals;
	
	import tempest.common.mvc.base.TFacadePlugin;
	
	import tpm.magic.MagicEngine;
	

	public class SkillFacadePlugin extends TFacadePlugin
	{
		private static var _instance:SkillFacadePlugin;

		public function SkillFacadePlugin()
		{
			super();
			if (_instance)
			{
				throw new Error("SkillFacade is Singleton");
			}
		}

		public static function get instance():SkillFacadePlugin
		{
			return _instance||=new SkillFacadePlugin();
		}

		protected override function startup():void
		{
			inject.mapSingleton(SkillModel);
			inject.mapSingleton(SkillSignals);
			commandMap.map([this.startupSignal], SkillFacadeStartupCommand);
			
		    MagicEngine.initialize(GameInstance.battleScene);
		}
	}
}
