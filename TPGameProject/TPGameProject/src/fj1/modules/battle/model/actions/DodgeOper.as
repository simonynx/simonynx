package fj1.modules.battle.model.actions
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import fj1.common.GameInstance;
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	import fj1.modules.battle.view.components.element.BattleElement;

	import ghostcat.operation.Oper;

	import tpm.magic.entity.TargetObject;

	public class DodgeOper extends Oper
	{
		private var _targetObject:BattleCharacter;

		public function DodgeOper(targetObject:BattleCharacter)
		{
			super();
			this._targetObject = targetObject;
		}

		override public function execute():void
		{
			var dx:int = _targetObject.camp == BattleConst.LEFT ? -15 : 15;
			GTweener.to(_targetObject, .1, {x: _targetObject.x + dx}).onComplete = function(gt:GTween):void
			{
				GTweener.to(_targetObject, .1, {x: _targetObject.x - dx}).onComplete = function(gt:GTween):void
				{
					GTweener.removeTweens(_targetObject);
					result();
				}
			}
		}

		protected override function end(event:* = null):void
		{
			super.end(event);

		}
	}
}
