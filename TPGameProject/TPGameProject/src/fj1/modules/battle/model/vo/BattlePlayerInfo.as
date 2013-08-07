package fj1.modules.battle.model.vo
{

	public class BattlePlayerInfo
	{
		public var id:int;
		public var camp:int;
		public var logicX:int;
		public var logicY:int;
		public var name:String;
		public var modelId:int;

		public function BattlePlayerInfo(id:int, camp:int, logicX:int, logicY:int, name:String, modelId:int)
		{
			this.id = id;
			this.camp = camp;
			this.logicX = logicX;
			this.logicY = logicY;
			this.name = name;
			this.modelId = modelId;
		}
	}
}
