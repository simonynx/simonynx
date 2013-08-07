package fj1.common.res.monster.vo
{

//	import fj1.common.res.status.StatusTemplateManager;
//	import fj1.common.res.status.vo.StatusInfo;

	public class CollectTemplate
	{
		public var id:int;
		/**
		 * 采集技能
		 */
		public var spell_id:int;
		/**
		 * 技能等级
		 */
		public var spell_level:int;
		/**
		 * 工具ID
		 */
		public var tool_id:int;
		/**
		 *状态ID
		 */
		private var _status_id:int;

//		public var statusInfo:StatusInfo = null;

		public function CollectTemplate()
		{
		}

		public function get status_id():int
		{
			return _status_id;
		}

		public function set status_id(value:int):void
		{
			_status_id = value;
//			statusInfo = StatusTemplateManager.instance.getStatusInfo(_status_id);
//			if (statusInfo == null)
//			{
//				throw new Error("不存在的状态ID：" + _status_id);
//			}
		}

		/**
		 *采集用时
		 * @return
		 *
		 */
		public function totalTime():int
		{
//			return statusInfo.total_time;
			return -1;
		}
	}
}
