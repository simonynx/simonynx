package fj1.modules.sound.comtroller
{
	import fj1.common.staticdata.SoundType;
	import tempest.common.mvc.base.Command;
	import tempest.manager.AudioManager;
	import tpe.manager.FilePathManager;

	public class AddBackSoundCommand extends Command
	{
		public override function getHandle():Function
		{
			return this.addSound;
		}

		/**
		 *添加背景音乐
		 * @param soundID
		 * @param type
		 *
		 */
		public function addSound(soundName:String):void
		{
			if (soundName.length > 0)
			{
				var type:int = SoundType.backgoroundAudio;
				var soundPath:String = SoundType.getPath(type);
				var volume:Number = SoundType.getDefaultVolume(type);
				var loop:int = SoundType.getLoop(type);
				AudioManager.playSound(FilePathManager.getPath(soundPath + soundName), type, volume, loop);
			}
		}
	}
}
