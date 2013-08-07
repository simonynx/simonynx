package tempest.engine.graphics.avatar.vo
{

	public class AvatarInfo
	{
		public static const defaultFrames:Array = [
			new AvatarFrame(2, 800, 1, 5),
			new AvatarFrame(6, 100, 5, 5),
			new AvatarFrame(6, 130, 3, 5),
			new AvatarFrame(2, 120, 1, 5),
			new AvatarFrame(3, 150, 2, 2),
			new AvatarFrame(1, 1000, 0, 5),
			];
		public var id:String = "0";
		public var frames:Array;

		public function AvatarInfo()
		{
		}

		/**
		 * 获取默认行为
		 * @param status
		 * @return
		 */
		public static function getFrame(status:int):AvatarFrame
		{
			if (status >= defaultFrames.length)
				return defaultFrames[0];
			else
				return defaultFrames[status];
		}
	}
}
