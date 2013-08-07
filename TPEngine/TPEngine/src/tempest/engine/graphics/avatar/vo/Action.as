package tempest.engine.graphics.avatar.vo
{

	public class Action
	{
		public static const defaultAction:Array = [
			[2, 800, 1, 5],
			[6, 100, 5, 5],
			[6, 130, 3, 5],
			[2, 120, 1, 5],
			[3, 150, 2, 2],
			[1, 1000, 0, 5]];
		public var total:int;
		public var interval:int;
		public var effect:int;
		public var faceCount:int;

		public function Action(total:int, interval:int, effect:int, faceCount:int):void
		{
			this.total = total;
			this.interval = interval;
			this.effect = effect;
			this.faceCount = faceCount;
		}

		/**
		 * 获取默认行为
		 * @param status
		 * @return
		 */
		public static function getDefaultAction(status:uint):Action
		{
			if (status >= defaultAction.length)
				return new Action(defaultAction[0][0], defaultAction[0][1], defaultAction[0][2], defaultAction[0][3]);
			else
				return new Action(defaultAction[status][0], defaultAction[status][1], defaultAction[status][2], defaultAction[status][3]);
		}
	}
}
