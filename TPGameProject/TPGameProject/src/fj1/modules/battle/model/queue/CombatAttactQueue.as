package fj1.modules.battle.model.queue
{
	import flash.geom.Point;
	
	import fj1.common.GameInstance;
	import fj1.common.flytext.FlyTextHelper;
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.model.actions.CombatAttactOper;
	import fj1.modules.battle.model.actions.WalkOper;
	import fj1.modules.battle.model.vo.RoundInfo;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	import fj1.modules.skill.model.SpellHelper;
	
	import ghostcat.operation.IOper;
	
	import tempest.engine.staticdata.Direction;
	import tempest.engine.staticdata.Status;
	
	import tpm.magic.entity.TargetObject;

	/**
	 * 近战行动队列
	 * @author linxun
	 *
	 */
	public class CombatAttactQueue extends ActionQueue
	{
		private static const INTERVAL:int = 45; // 间距

		public function CombatAttactQueue(roundInfo:RoundInfo)
		{
			super(roundInfo);
		}

		override protected function addChildren():void
		{
			var castPlayer:BattleCharacter = GameInstance.battleScene.getElement(roundInfo.castId) as BattleCharacter;
			var targetPlayerVec:Vector.<BattleCharacter> = new Vector.<BattleCharacter>();
			for each (var id:int in roundInfo.targetArr)
			{
				var targetPlayer:BattleCharacter = GameInstance.battleScene.getElement(id) as BattleCharacter;
				targetPlayerVec.push(targetPlayer);
			}

			var queueSrc:Array = [];

			var initPos:Point = new Point(castPlayer.x, castPlayer.y); //记录初始位置

			//走向目标Oper
			queueSrc.push(new WalkOper(castPlayer, getTargetPoint(targetPlayerVec[0]), castPlayer.camp == BattleConst.LEFT ? Direction.EAST : Direction.WEST));

			//攻击动作Oper
			var attackOper:CombatAttactOper = new CombatAttactOper(castPlayer, function(castPlayer:BattleCharacter):void
			{
				//在攻击关键帧上播放伤害飘字
				addHurtOper(targetPlayerVec);
				addFlyText(targetPlayerVec);
			});
			queueSrc.push(attackOper);

			//走回原位Oper
			queueSrc.push(new WalkOper(castPlayer, initPos, castPlayer.camp == BattleConst.LEFT ? Direction.EAST : Direction.WEST, onWalkBackArrived));
			this.children = queueSrc;
		}

		private function onWalkBackArrived(caster:BattleCharacter):void
		{
			caster.playTo(Status.STAND, caster.camp == BattleConst.LEFT ? Direction.EAST : Direction.WEST);
		}

		private function getTargetPoint(targetPlayer:BattleCharacter):Point
		{
			var dx:int = (targetPlayer.camp == BattleConst.RIGHT) ? -INTERVAL : INTERVAL;
			return new Point(targetPlayer.x + dx, targetPlayer.y);
		}

		/**
		 * 添加受击动作
		 * @param targetPlayerVec
		 *
		 */
		private function addHurtOper(targetPlayerVec:Vector.<BattleCharacter>):void
		{
			var hurtOpers:Array = [];
			for (var i:int = 0; i < targetPlayerVec.length; i++)
			{
				hurtOpers = hurtOpers.concat(SpellHelper.getHurtResponseActions(roundInfo.hurtFlagArr[i], targetPlayerVec[i]));
			}

			for each (var opers:IOper in hurtOpers)
			{
				opers.execute();
			}
		}

		/**
		 * 添加飘字
		 * @param targetPlayerVec
		 *
		 */
		private function addFlyText(targetPlayerVec:Vector.<BattleCharacter>):void
		{
			var hurtTexts:Vector.<TargetObject> = new Vector.<TargetObject>();
			for (var i:int = 0; i < targetPlayerVec.length; i++)
			{
				var damage:int = roundInfo.damageArr[i];
				var hurtFlag:int = roundInfo.hurtFlagArr[i];
				var targetObject:TargetObject = new TargetObject(targetPlayerVec[i].guid, null, damage, hurtFlag);
				hurtTexts.push(targetObject);
			}
			FlyTextHelper.addBattleFlyText(hurtTexts, false, false, false);
		}
	}
}
