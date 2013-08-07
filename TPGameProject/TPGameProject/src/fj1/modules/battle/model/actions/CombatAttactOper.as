package fj1.modules.battle.model.actions
{
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.view.components.element.BattleCharacter;

	import flash.events.Event;

	import ghostcat.operation.Oper;

	import tempest.engine.staticdata.Direction;
	import tempest.engine.staticdata.Status;

	public class CombatAttactOper extends Oper
	{
		private var _castPlayer:BattleCharacter;
		private var _onEffectFrame:Function;

		public function CombatAttactOper(castPlayer:BattleCharacter, onEffectFrame:Function)
		{
			super();
			_castPlayer = castPlayer;
			_onEffectFrame = onEffectFrame;
		}

		override public function execute():void
		{
			_castPlayer.playTo(Status.ATTACK, _castPlayer.camp == BattleConst.LEFT ? Direction.EAST : Direction.WEST, null, onEffectFrame, onActionComplete);
		}

		private function onEffectFrame():void
		{
			_onEffectFrame(_castPlayer);
		}

		private function onActionComplete():void
		{
			_castPlayer.addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				result();
			});
		}
	}
}
