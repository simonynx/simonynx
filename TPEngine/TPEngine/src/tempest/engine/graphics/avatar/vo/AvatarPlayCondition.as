package tempest.engine.graphics.avatar.vo
{
	import tempest.engine.staticdata.Status;

	/**
	 * 播放条件
	 * @author wushangkun
	 */
	public class AvatarPlayCondition
	{
		private static var defauleAPC:AvatarPlayCondition = new AvatarPlayCondition();
		private static var apcs:Array = [new AvatarPlayCondition(true), new AvatarPlayCondition(true, true)];
		/**
		 * 从第一帧开始不放
		 * @default
		 */
		public var playAtBegin:Boolean;
		/**
		 * 停留在最后一帧
		 * @default
		 */
		public var stayAtEnd:Boolean;
		/**
		 * 直接显示最后一帧
		 * @default
		 */
		public var showEnd:Boolean;

		/**
		 *
		 * @param playAtBegin 从第一帧开始不放
		 * @param stayAtEnd 停留在最后一帧
		 * @param showEnd 直接显示最后一帧
		 */
		public function AvatarPlayCondition(playAtBegin:Boolean = false, stayAtEnd:Boolean = false, showEnd:Boolean = false)
		{
			this.playAtBegin = playAtBegin;
			this.stayAtEnd = stayAtEnd;
			this.showEnd = showEnd;
		}

		public static function getDefaultAvatarPlayCondition(status:int):AvatarPlayCondition
		{
			switch (status)
			{
				case Status.STAND:
				case Status.ATTACK:
				case Status.INJURE:
					return apcs[0];
				case Status.DEAD:
				case Status.MUSE:
					return apcs[1];
				case Status.WALK:
				default:
					return defauleAPC;
			}
		}

		public function clone():AvatarPlayCondition
		{
			return new AvatarPlayCondition(this.playAtBegin, this.stayAtEnd, this.showEnd);
		}
	}
}
