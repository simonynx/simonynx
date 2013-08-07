package fj1.modules.sound.comtroller
{
	import fj1.modules.sound.signals.SoundSignal;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Command;

	public class SoundFacadeStartupCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(SoundFacadeStartupCommand);
		[Inject]
		public var signal:SoundSignal;

		public override function execute():void
		{
			log.info("音效配置模块启动");
			//注册命令
			commandMap.map([signal.setBackGroundSound], SetBackSoundCommand);
			commandMap.map([signal.setGameSound], SetGameSoundCommand);
			commandMap.map([signal.addGameSound], AddGameSoundCommand);
			commandMap.map([signal.addBackGroundSound], AddBackSoundCommand);
		}
	}
}
