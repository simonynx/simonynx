package modules.main.business.battle.model.vo
{
	public class RoundInfo
	{
		public var id:int;
		public var castId:int;
		public var targetArr:Array =[];
		public var damageArr:Array =[];
		public var skillId:int;
		public var isSkill:Boolean;
		public var statusType:int; //状态类型
		public var actionType:int; //动作类型

		public function RoundInfo()
		{
		}
	}
}