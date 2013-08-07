package fj1.common.data.dataobject.cd
{
	import flash.utils.Dictionary;

	public class CDGroup
	{
		private var _groupId:int = 0;
		private var _cdTime:Number = 0;
		private var _cdStateList:Dictionary;
		private var _type:int;
		private var _priority:int;

		public function CDGroup(groupId:int, commonCDTime:int, type:int, priority:int = 2)
		{
			_groupId = groupId;
			_cdTime = commonCDTime;
			_type = type;
			_priority = priority;
			_cdStateList = new Dictionary();
		}

		/**
		 * 初始化，注册CD
		 * @param id
		 *
		 */
		public function setCDState(cdState:CDState):void
		{
			if (_type != cdState.cdGroupType)
			{
				//检查冷却类型
				throw new Error("在同冷却组中，公共冷却类型必须相同！" + _type + "- "+ cdState.cdGroupType);
			}
			_cdStateList[cdState.templateId] = cdState;
		}

		/**
		 * 获得冷却状态
		 * @param id
		 * @return
		 *
		 */
		public function getCDState(templateId:int):CDState
		{
			return _cdStateList[templateId] as CDState;
		}

		/**
		 * 开始公共CD
		 * @param id
		 *
		 */
		public function startCommonCD(templateId:int):void
		{
			for (var _templateId:Object in _cdStateList)
			{
				if (_templateId != templateId)
				{
					(_cdStateList[_templateId] as CDState).startCD(_cdTime, _priority, false);
				}
			}
		}

		/**
		 * 停止全部CD
		 *
		 */
		public function stopCD(priority:int):void
		{
			for each (var cdState:CDState in _cdStateList)
			{
				cdState.stopCD(priority, false); //不抛事件，避免重复startCD
			}
		}

		/**
		 *  开始冷却，可以设置剩余时间
		 * @param cdTime
		 *
		 */
		public function startCD(lastTime:int):void
		{
			startCD2(lastTime, _cdTime);
		}

		/**
		 *
		 * @param lastTime
		 * @param totalTime
		 *
		 */
		public function startCD2(lastTime:int, totalTime:int):void
		{
			for each (var cdState:CDState in _cdStateList)
			{
				cdState.startCD2(lastTime, totalTime, _priority, false); //不抛事件，避免重复startCD
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get groupId():int
		{
			return _groupId;
		}

		public function set cdTime(value:Number):void
		{
			_cdTime = value;
		}

		public function get cdTime():Number
		{
			return _cdTime;
		}

		public function get type():int
		{
			return _type;
		}
	}
}
