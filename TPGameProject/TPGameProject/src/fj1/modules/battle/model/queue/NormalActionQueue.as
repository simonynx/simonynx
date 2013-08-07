package fj1.modules.battle.model.queue
{
	import flash.geom.Point;
	
	import fj1.common.GameInstance;
	import fj1.common.flytext.FlyTextHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.skill.MagicTemplateMannage;
	import fj1.common.res.skill.SkillTemplateManager;
	import fj1.common.res.skill.vo.SkillInfo;
	import fj1.modules.battle.model.vo.RoundInfo;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	import fj1.modules.skill.magic.CasterEffectOper;
	import fj1.modules.skill.magic.HitEffectOper;
	import fj1.modules.skill.magic.HurtEffectOper;
	import fj1.modules.skill.magic.ParticleEffectOper;
	import fj1.modules.skill.model.SpellHelper;
	
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.FunctionOper;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.engine.staticdata.Status;
	
	import tpm.magic.entity.MagicInfo;
	import tpm.magic.entity.TargetObject;

	public class NormalActionQueue extends ActionQueue
	{
		private static var log:ILogger=TLog.getLogger(NormalActionQueue);
		private var targetPlayerVec:Vector.<BattleCharacter>;
		
		public function NormalActionQueue(roundInfo:RoundInfo)
		{
			super(roundInfo);
		}
		
		override protected function addChildren():void
		{
			var caster:BattleCharacter=GameInstance.battleScene.getElement( roundInfo.castId) as BattleCharacter;
			targetPlayerVec = new Vector.<BattleCharacter>();
			var hurts:Vector.<TargetObject> = new Vector.<TargetObject>();
			for (var i:int =0; i < roundInfo.targetArr.length; i++)
			{
				var targetPlayer:BattleCharacter = GameInstance.battleScene.getElement(roundInfo.targetArr[i]) as BattleCharacter;
				var damage:int = roundInfo.damageArr[i];
				var hurtFlag:int = roundInfo.hurtFlagArr[i];
				var targetPos:Point = new Point(targetPlayer.x, targetPlayer.y);
				var targetObject:TargetObject = new TargetObject(targetPlayer.guid, targetPos, damage, hurtFlag);
				hurts.push(targetObject);
				targetPlayerVec.push(targetPlayer);
			}
			spellUse(roundInfo.skillId, hurts, 1, caster);
		}
		
		/**
		 *
		 * @param spellID
		 * @param hurts
		 * @param nMuti
		 * @param senderID
		 * @param effectPoint
		 *
		 */
		public function spellUse(spellID:int, hurts:Vector.<TargetObject>, nMuti:int, caster:BattleCharacter):void
		{
			var queueSrc:Array = [];
			var magicInfo:MagicInfo=null;
			var skillInfo:SkillInfo=null;
			skillInfo=SkillTemplateManager.instance.getSkillInfo(spellID);
			if (caster == null || caster.getStatus() == Status.DEAD)
				return;
			if (skillInfo == null)
			{
				log.warn("不存在的技能ID：" + spellID);
				return;
			}
//			var skillData:SkillData=MainFacade.instance.inject.getInstance(SkillModel).getSkillData(spellID);
//			skillData.useObj();
			//////////////////////////////////////////////////////////////////////////
			magicInfo=MagicTemplateMannage.instrance.getMagicInfo(skillInfo.magic_id);
			if (magicInfo)
			{
				if(magicInfo[SpellHelper.CASTER_EFFECT + 1] != 0)
					queueSrc.push( new CasterEffectOper(caster, magicInfo, skillInfo));
				if(magicInfo.magic_effectid != 0)
					queueSrc.push(new ParticleEffectOper(caster, magicInfo, hurts, nMuti));
				if(magicInfo[SpellHelper.HIT_EFFECT + 1] != 0)
					queueSrc.push(new HitEffectOper(magicInfo, hurts[0]));
				if(magicInfo[SpellHelper.HURT_EFFECT + 1] != 0)
					queueSrc.push(new HurtEffectOper(hurts, magicInfo));
				queueSrc.push(new FunctionOper(playHurt));
				queueSrc.push(new FunctionOper(FlyTextHelper.addBattleFlyText, [hurts, false]));
				//////////////飘字延迟///////////////
				queueSrc.push(new DelayOper(800));
				this.children = queueSrc;
			}
			else
				log.warn("不存在的魔法ID：" + skillInfo.magic_id);
			//////////////////////////////////////////////////////////////////////////
			var currentMuti:int=nMuti % 100;
			if (currentMuti > 1)
				FlyTextHelper.addSpellNameFlyText(caster, (LanguageManager.translate(6018, "多重伤害") + " ×" + currentMuti));
		}
		
		private function playHurt():void
		{
			for each (var item:BattleCharacter in targetPlayerVec)
			{
				item.playTo(Status.INJURE);
			}
		}
	}
}
