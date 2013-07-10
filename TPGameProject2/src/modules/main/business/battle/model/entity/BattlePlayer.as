package modules.main.business.battle.model.entity
{
	import flash.geom.Point;

	import modules.main.business.battle.signals.BattlePlayerSignals;

	import org.osflash.signals.ISignal;


	public class BattlePlayer
	{
		private var _signals:BattlePlayerSignals;

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
			_signals = new BattlePlayerSignals();
			nameColor = 0x000000; //默认名字颜色
		}

		public function get signals():BattlePlayerSignals
		{
			return _signals;
		}

		public function get guid():int
		{
			return _guid;
		}


	}
}
