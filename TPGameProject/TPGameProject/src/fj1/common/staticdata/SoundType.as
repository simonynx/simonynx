package fj1.common.staticdata
{

	public class SoundType
	{
		/**
		 * 背景音效
		 */
		public static const backgoroundAudio:int = 0;
		/**
		 * 技能音效
		 */
		public static const spellAudio:int = 1;
		/**
		 * 界面音效
		 */
		public static const uiAudio:int = 2;
		/**
		 * 特殊音效
		 */
		public static const specialAudio:int = 3;
		/**
		 * 物品音效
		 */
		public static const itemAutio:int = 4;

		/**
		 *根据游戏声音线程返回默认音量
		 * @param soundType
		 * @return
		 *
		 */
		public static function getDefaultVolume(soundType:int = SoundType.uiAudio):Number
		{
			switch (soundType)
			{
				case backgoroundAudio:
					return 0.8;
					break;
				case spellAudio:
					return 0.6;
					break;
				case uiAudio:
					return 0.6;
					break;
				case specialAudio:
					return 0.8;
					break;
				case itemAutio:
					return 0.6;
					break;
			}
			return 0.6;
		}

		/**
		 *获取默认声音播放次数
		 * @param soundType
		 * @return
		 *
		 */
		public static function getLoop(soundType:int = SoundType.uiAudio):int
		{
			switch (soundType)
			{
				case SoundType.backgoroundAudio: //背景音效
					return 0;
					break;
				case SoundType.spellAudio:
				case SoundType.uiAudio:
				case SoundType.specialAudio:
				case SoundType.itemAutio:
					return 1;
					break;
			}
			return 1;
		}

		/**
		 *获取音效文件目录
		 * @param soundType
		 * @return
		 *
		 */
		public static function getPath(soundType:int = SoundType.uiAudio):String
		{
			switch (soundType)
			{
				case SoundType.backgoroundAudio: //背景音效
					return "audio/music/";
					break;
				case SoundType.spellAudio:
				case SoundType.uiAudio:
				case SoundType.specialAudio:
				case SoundType.itemAutio:
					return "audio/sound/";
					break;
			}
			return "";
		}
	}
}
