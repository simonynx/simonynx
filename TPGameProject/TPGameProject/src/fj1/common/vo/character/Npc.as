package fj1.common.vo.character
{
	import fj1.common.GameConfig;
//	import fj1.common.helper.TaskHelper;
	import fj1.common.res.npc.vo.NpcRes;
//	import fj1.common.res.task.vo.TaskInfo;
	import fj1.manager.AvatarManager;
	import fj1.manager.HeadFaceManager;
//	import fj1.modules.task.model.vo.TaskData;
//	import fj1.modules.task.model.vo.TaskType;
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import tempest.common.handler.HandlerThread;
	import tempest.common.staticdata.Colors;
	import tempest.engine.SceneCharacter;

	public class Npc extends BaseCharacter
	{
		/**
		 *NPC静态模版
		 */
		public var npcRes:NpcRes;
		private var _ht:HandlerThread;
		/**
		 *NPC任务列表
		 */
		public var taskList:Array;

		public function Npc(sc:SceneCharacter, res:NpcRes)
		{
			super(sc);
			this.npcRes = res;
			taskList = [];
			//////////////////////////////
			this._health = 1;
			this._sc.priority = 100;
			init();
		}
		//////////////////////////////////////////////////
		[Bindable]
		public var headIcon:uint;
		public var denotation:DisplayObject = null;
		public var denotationType:int = 0; //头顶添加符号的类型

//		/**
//		 *更新头顶任务标记
//		 *
//		 */
//		public function updateDenotation():void
//		{
//			if (npcRes.taskList.length == 0)
//			{
//				resetDenotation();
//				return;
//			}
//			var taskData:TaskData = null;
//			var taskInfo:TaskInfo = null;
//			for each (taskData in npcRes.taskList)
//			{
//				taskInfo = taskData.taskInfo;
//				var status:int = taskInfo.status;
//				if (status == TaskType.TASK_STATE_RECEIVE_SUCCESS || status == TaskType.TASK_STATE_EXECUTE_FAILD || status == TaskType.TASK_STATE_DELIVE_FAILD) //已接
//				{
//					addDenotation(TaskHelper.getBigImgType(status), 1, taskInfo.id.toString())
//				}
//				else if (status == TaskType.TASK_STATE_EXECUTE_FINISHED) //已完成
//				{
//					addDenotation(TaskHelper.getBigImgType(status), 3, taskInfo.id.toString())
//				}
//				else if (taskInfo.recive_npc_id == sc.id && taskInfo.isCanRecive) //接任务NPC
//				{
//					addDenotation(TaskHelper.getBigImgType(TaskType.TASK_STATE_RECEIVE_FAILD), 2, taskInfo.id.toString())
//				}
//			}
//		}

		/**
		 *在NPC头顶添加符号
		 * @param disObj
		 * @param type
		 *
		 */
		private function addDenotation(disObj:DisplayObject, type:int, name:String):void
		{
			if (denotation && denotation.name == name)
			{
				denotationType = 0;
			}
			if (denotationType < type)
			{
				if (denotation)
				{
					this._sc.removeChild(denotation);
				}
				denotationType = type;
				disObj.name = name;
				denotation = disObj;
				disObj.x = -(disObj.width >> 1);
				disObj.y = _sc.head_offset - disObj.height - 12 /*headlayer高度*/;
				this._sc.addChild(denotation);
			}
		}

		/**
		 *重置符号状态
		 *
		 */
		public function resetDenotation():void
		{
			if (denotation)
			{
				this._sc.removeChild(denotation);
			}
			denotation = null;
			denotationType = 0;
		}

		//////////////////////////////////////
		private function get ht():HandlerThread
		{
			return _ht ||= new HandlerThread();
		}

		private function init():void
		{
			var now:Number = new Date().getTime();
			var begin:Number = this.npcRes.template.begin_datetime;
			if (begin > 0)
			{
				begin = getDateTime(begin);
				if (begin > now) //还没有开始
				{
					this.hide();
					ht.push(show, null, begin - now);
				}
			}
			var end:Number = this.npcRes.template.end_datetime;
			if (end > 0)
			{
				end = getDateTime(end);
				if (end <= now) //已经结束
				{
					this.hide();
				}
				else
				{
					ht.push(hide, null, end - now);
				}
			}
		}

		private function show():void
		{
			this.sc.setVisible(true);
		}

		private function hide():void
		{
			this.sc.setVisible(false);
		}

		private function getDateTime(value:int):Number
		{
			return new Date(2000 + ((value * 0.00000001) >> 0), (((value % 100000000) * 0.000001) >> 0) - 1, ((value % 1000000) * 0.0001) >> 0, ((value % 10000) * 0.01) >> 0, value % 100).getTime()
		}

		override public function dispose():void
		{
			this.npcRes = null;
			if (_ht)
			{
				_ht.removeAllHandlers();
			}
		}
	}
}
