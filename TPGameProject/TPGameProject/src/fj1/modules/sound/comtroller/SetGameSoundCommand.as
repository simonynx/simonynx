package fj1.modules.sound.comtroller
{
	import fj1.common.staticdata.SoundType;
	import fj1.modules.sound.model.SoundConfigModel;
	import tempest.common.audio.SoundThread;
	import tempest.common.mvc.base.Command;
	import tempest.manager.AudioManager;

	public class SetGameSoundCommand extends Command
	{
		[Inject]
		public var model:SoundConfigModel;

		public override function getHandle():Function
		{
			return this.setGameSound;
		}

		/**
		 *设置其他音效 （游戏音效，界面音效，场景音效）
		 * @param isClam
		 *
		 */
		private function setGameSound():void
		{
			var isClam:Boolean = model.gameSoundStatus;
			var _spellSoundThread:SoundThread;
			var _menuAudio:SoundThread;
			var _walkAutio:SoundThread;
			var _sceneSoundThread:SoundThread;
			_spellSoundThread = AudioManager.getSoundThread(SoundType.uiAudio);
			_menuAudio = AudioManager.getSoundThread(SoundType.specialAudio);
			_walkAutio = AudioManager.getSoundThread(SoundType.itemAutio);
			_sceneSoundThread = AudioManager.getSoundThread(SoundType.spellAudio);
			if (_spellSoundThread)
			{
				if (isClam)
				{
					_spellSoundThread.isClam = true;
				}
				else
				{
					_spellSoundThread.isClam = false;
				}
			}
			if (_menuAudio)
			{
				if (isClam)
				{
					_menuAudio.isClam = true;
				}
				else
				{
					_menuAudio.isClam = false;
				}
			}
			if (_walkAutio)
			{
				if (isClam)
				{
					_walkAutio.isClam = true;
				}
				else
				{
					_walkAutio.isClam = false;
				}
			}
			if (_sceneSoundThread)
			{
				if (isClam)
				{
					_sceneSoundThread.isClam = true;
				}
				else
				{
					_sceneSoundThread.isClam = false;
				}
			}
		}
	}
}
