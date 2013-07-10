package modules.main.business.battle.model.vo
{
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.Queue;
	
	import modules.main.business.battle.model.entity.BattlePlayer;
	import modules.main.business.battle.model.queue.IActionQueue;
	import modules.main.business.battle.model.queue.NormalActionQueue;
	import modules.main.business.battle.model.queue.SkillActionQueue;
	
	public class BattleInfo
	{
		public var id:int;
		public var mapId:int; //地图ID
		public var name:String; //名字
		public var expReward:int; //经验奖励
		public var itemReward:int; //物品奖励
		public var moneyReward:int; //金币奖励
		private var _justiceForce:Array = []; //我方
		private var _hostileForce:Array = []; //敌方
		public static const ACTION_NORMAL:int = 1; //普通攻击动作序列
		public static const ACTION_SKILL:int = 2; //技能攻击动作序列
		public var roundInfoArr:Vector.<RoundInfo> = new Vector.<RoundInfo>(); //回合资源
		
		public function BattleInfo()
		{
		}
		
		public function get hostileForce():Array
		{
			return _hostileForce;
		}

		public function get justiceForce():Array
		{
			return _justiceForce;
		}
		/**
		 * 增加角色（未完） 
		 * @param id
		 * 
		 */
		public function addRoles(bp:BattlePlayer):void
		{
			_justiceForce.push();
			_hostileForce.push();
		}

		public function execute():void
		{
			var length:int = roundInfoArr.length;
			if( length == 0)
				return;
			var arr:Array = [];	
//			arr.push(new FunctionOper(addRolesIntoScene));
			for(var i:int; i < length; i ++)
			{
				var roundInfo:RoundInfo = roundInfoArr[i];
				var actionQueue:IActionQueue = getActionByType(roundInfo);
				arr.push(actionQueue.queue)
			}
			var queue:Queue = new Queue(arr);
			queue.execute();	
		}

		public function getActionByType(roundInfo:RoundInfo):IActionQueue
		{
			switch(roundInfo.actionType)
			{
				case ACTION_NORMAL:
					return new NormalActionQueue(roundInfo);
				case ACTION_SKILL:
					return new SkillActionQueue(roundInfo);	
			}
			return null;
		}

		private function addRolesIntoScene():void
		{

		}
		
	}
}