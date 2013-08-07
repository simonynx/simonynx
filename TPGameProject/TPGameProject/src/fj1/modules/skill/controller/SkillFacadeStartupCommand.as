package fj1.modules.skill.controller
{
	import fj1.modules.skill.signals.SkillSignals;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Command;

	public class SkillFacadeStartupCommand extends Command
	{
		[Inject]
		public var skillSignals:SkillSignals;
		
		private static const log:ILogger=TLog.getLogger(SkillFacadeStartupCommand);

		public override function execute():void
		{
			log.info("技能模块启动");
		}
	}
}
