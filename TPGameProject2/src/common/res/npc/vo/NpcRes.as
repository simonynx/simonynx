package common.res.npc.vo
{
	import common.res.npc.NpcResManager;


	import flash.geom.Point;

	/**
	 * npc资源
	 * 对应fj1_npc_template表
	 * @author wushangkun
	 */
	public class NpcRes
	{
		public var id:int;
		public var mapId:int;
		public var pos_x:int;
		public var pos_y:int;
		public var templateId:int;
		public var orient:int;
		public var serverId:int;
		private var _template:NpcTempl;
		public var taskList:Array;
		private var _position:Point = null;

		public function NpcRes()
		{
			taskList = [];
		}

		public function get template():NpcTempl
		{
			return _template ||= NpcResManager.getNpcTempl(this.templateId);
		}

		public function get position():Point
		{
			return _position ||= new Point(pos_x, pos_y);
		}

//		public function getTaskInfo(taskId:int):TaskInfo
//		{
//			var taskData:TaskData = null;
//			for each (taskData in taskList)
//			{
//				if (taskData.id == taskId)
//				{
//					return taskData.taskInfo;
//				}
//			}
//			return null;
//		}

		public function isValid():Boolean
		{
			var now:Number = new Date().getTime();
			var begin:Number = this.template.begin_datetime;
			if (begin > 0)
			{
				begin = getDateTime(begin);
				if (begin > now) //还没有开始
				{
					return false;
				}
			}
			var end:Number = this.template.end_datetime;
			if (end > 0)
			{
				end = getDateTime(end);
				if (end <= now) //已经结束
				{
					return false;
				}
			}
			return true;
		}

//		public function get isOnCurrentline():Boolean
//		{
//			return (this.serverId == GameConfig.currentLine % 10) || (this.serverId == 0);
//		}

		private function getDateTime(value:int):Number
		{
			return new Date(2000 + ((value * 0.00000001) >> 0), (((value % 100000000) * 0.000001) >> 0) - 1, ((value % 1000000) * 0.0001) >> 0, ((value % 10000) * 0.01) >> 0, value % 100).getTime()
		}
	}
}
