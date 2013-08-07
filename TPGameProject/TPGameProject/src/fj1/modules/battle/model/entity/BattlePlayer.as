package fj1.modules.battle.model.entity
{
	import fj1.modules.battle.view.components.element.BattleCharacter;

	public class BattlePlayer
	{
		private var _guid:int;

		public var camp:int;
		public var logicX:int;
		public var logicY:int;

		[Bindable]
		public var name:String;
		[Bindable]
		public var nameColor:uint;
		[Bindable]
		public var hp:int;
		[Bindable]
		public var maxHp:int;

		public var modelId:int;

		public function BattlePlayer(guid:int)
		{
			_guid = guid;
			nameColor = 0x000000; //默认名字颜色
		}

		public function get guid():int
		{
			return _guid;
		}


	}
}
