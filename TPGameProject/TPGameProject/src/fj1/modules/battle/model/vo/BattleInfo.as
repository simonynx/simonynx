package fj1.modules.battle.model.vo
{
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.model.queue.IAction;
	import fj1.modules.battle.model.queue.NormalActionQueue;
	import fj1.modules.battle.view.components.element.BattleCharacter;

	import ghostcat.operation.Queue;

	public class BattleInfo
	{
		public var id:int;
		public var mapId:int; //地图ID
		public var name:String; //名字
		public var expReward:int; //经验奖励
		public var itemReward:int; //物品奖励
		public var moneyReward:int; //金币奖励
		public var playerInfoArr:Vector.<BattlePlayerInfo> = new Vector.<BattlePlayerInfo>(); //武将信息
		private var _justiceForce:Array = []; //我方
		private var _hostileForce:Array = []; //敌方
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

		private function addRolesIntoScene():void
		{

		}

	}
}
