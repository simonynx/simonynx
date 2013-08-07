package tempest.engine.graphics.avatar
{

	public class AvatarPartType
	{
		public static const CLOTH:int = 1;
		public static const WEAPON:int = 2;
		public static const MOUNT:int = 4;
		public static const WING:int = 8;

		/**
		 * 获取部件深度
		 * @param type
		 * @return
		 */
		public static function getDepth(type:int, dir:int = -1):int
		{
			switch (type)
			{
				case WEAPON:
					return 2;
				case MOUNT:
					return -2;
				case WING:
					return (dir > 1 && dir < 7) ? -1 : 1;
				case CLOTH:
				default:
					return 0;
			}
		}
	}
}
