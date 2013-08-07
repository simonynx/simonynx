package fj1.modules.sound.comtroller
{
	import fj1.common.staticdata.SoundType;
	import fj1.modules.sound.model.SoundConfigModel;
	import tempest.common.audio.SoundThread;
	import tempest.common.mvc.base.Command;
	import tempest.manager.AudioManager;

	public class SetBackSoundCommand extends Command
	{
		[Inject]
		public var model:SoundConfigModel;

		public override function getHandle():Function
		{
			return this.setBackGroundSound;
		}

		/**
		 *设置背景音效
		 * @param isClam
		 *
		 */
		private function setBackGroundSound():void
		{
			var isClam:Boolean = model.backGroundSoundStatus;
			var _backGroundSoundThread:SoundThread;
			_backGroundSoundThread = AudioManager.getSoundThread(SoundType.backgoroundAudio);
			if (_backGroundSoundThread)
			{
				if (isClam)
				{
					_backGroundSoundThread.isClam = true;
				}
				else
				{
					_backGroundSoundThread.isClam = false;
				}
			}
		}
	}
}
