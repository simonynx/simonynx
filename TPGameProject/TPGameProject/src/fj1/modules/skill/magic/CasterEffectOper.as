package fj1.modules.skill.magic
{
	import flash.geom.Point;
	
	import fj1.common.flytext.FlyTextHelper;
	import fj1.common.res.skill.vo.SkillInfo;
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	import fj1.modules.skill.model.SpellHelper;
	
	import ghostcat.operation.Oper;
	
	import tempest.engine.staticdata.Direction;
	
	import tpm.magic.MagicEngine;
	import tpm.magic.entity.MagicInfo;
	import tpm.magic.util.DelayHandler;
	
	public class CasterEffectOper extends Oper
	{
		private var skillInfo:SkillInfo;
		private var magicInfo:MagicInfo;
		private var caster:BattleCharacter;
		
		public function CasterEffectOper(caster:BattleCharacter, magicInfo:MagicInfo, skillInfo:SkillInfo)
		{
			super();
			this.caster = caster;
			this.skillInfo = skillInfo;
			this.magicInfo = magicInfo;
		}
		
		override public function execute():void
		{
			var onEffectFrame:Function = function():void
			{
				FlyTextHelper.addSpellNameFlyText(caster, skillInfo.fly_text); 
			}
			var dir:int = (caster.camp == BattleConst.LEFT) ? Direction.EAST : Direction.WEST;
			DelayHandler.delayGtweenExcute([magicInfo.attack_action, dir, null, onEffectFrame], magicInfo.caster_delay, caster.playTo);
			var renderPoint:Point = new Point(caster.x, caster.y /*- MagicEngine.body_offset*/);
			SpellHelper.casterEffect(caster, magicInfo, renderPoint, function():void
			{
				result();
			});
		}
	}
}