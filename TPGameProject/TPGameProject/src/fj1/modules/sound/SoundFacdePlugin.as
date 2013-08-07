package fj1.modules.sound
{
	import fj1.modules.sound.comtroller.SoundFacadeStartupCommand;
	import fj1.modules.sound.model.SoundConfigModel;
	import fj1.modules.sound.signals.SoundSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class SoundFacdePlugin extends TFacadePlugin
	{
		public function SoundFacdePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(SoundSignal);
			inject.mapSingleton(SoundConfigModel);
			commandMap.map([this.startupSignal], SoundFacadeStartupCommand);
		}
	}
}
