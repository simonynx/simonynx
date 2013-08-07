package tempest.engine.vo.move
{
	import flash.geom.Point;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.engine.tools.move.PathCutter;

	public class MoveData
	{
		private static const log:ILogger = TLog.getLogger(MoveData);

		public var walk_speed:Number = 135;
		public var walk_lastTime:uint = 0;
		public var walk_pathArr:Array = null;
		public var walk_standDis:int = 0;
		public var walk_pathCutter:PathCutter;

		private static var _count:int = 0;
		private var _id:int;

		public function MoveData()
		{
			_id = _count++;
		}

		public function set walk_targetP(value:Point):void
		{
			_walk_targetP = value ? value.clone() : null;
		}

		public function get walk_targetP():Point
		{
			return _walk_targetP ? _walk_targetP.clone() : null;
		}
		private var _walk_targetP:Point = null;

		public var walk_callBack:MoveCallBack = null;
		public var walk_fixP:Point = null;

		/**
		 * 清理移动数据
		 */
		public function clear():void
		{
			this.walk_pathArr = null;
			this.walk_targetP = null;
			this.walk_fixP = null;
			this.walk_lastTime = 0;
			this.walk_standDis = 0;
			if (this.walk_pathCutter)
			{
				this.walk_pathCutter.clear();
			}
			this.walk_callBack = null;
		}

		/**
		 * 是否目标点未变化
		 * @param targetP
		 * @param standDis
		 * @param speed
		 * @return
		 */
		public function isChanged(targetP:Point, standDis:int, speed:Number):Boolean
		{
			if (this.walk_pathArr == null || this.walk_pathArr.length == 0 || this.walk_targetP == null)
			{
				return true;
			}
			if (walk_standDis != standDis)
			{
				return true;
			}
			if (speed >= 0 && speed != walk_speed)
			{
				return true;
			}
//			if (!this.walk_targetP.equals(targetP))
//			{
//				return true;
//			}
			return (this.walk_targetP.x >> 0) != (targetP.x >> 0) || (this.walk_targetP.y >> 0) != (targetP.y >> 0);
		}
	}
}

