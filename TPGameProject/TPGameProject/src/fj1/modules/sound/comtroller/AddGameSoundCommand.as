package fj1.modules.sound.comtroller
{
	import fj1.common.res.sound.SoundManager;
	import fj1.common.res.sound.vo.SoundEntity;
	import fj1.common.staticdata.SoundType;
	import tempest.common.mvc.base.Command;
	import tempest.manager.AudioManager;
	import tpe.manager.FilePathManager;

	public class AddGameSoundCommand extends Command
	{
		public override function getHandle():Function
		{
			return this.addSound;
		}

		/**
		 *添加普通音效
		 * @param soundID
		 * @param type
		 *
		 */
		public function addSound(soundid:int):void
		{
			var soundEntity:SoundEntity = SoundManager.instrance.getSoundEntity(soundid);
			if (soundEntity)
			{
				var type:int = soundEntity.type;
				var soundPath:String = SoundType.getPath(type);
				var volume:Number = SoundType.getDefaultVolume(type);
				var loop:int = SoundType.getLoop(type);
				AudioManager.playSound(FilePathManager.getPath(soundPath + soundEntity.filename), type, volume, loop);
			}
			else
			{
				CONFIG::debugging
				{
//					throw new Error("不存在音效配置ID：" + soundid);
				}
			}
		}
	}
}
