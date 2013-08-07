package fj1.modules.skill.magic
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	import fj1.common.GameInstance;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	
	import ghostcat.operation.Oper;
	
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.animation.AnimationType;
	import tempest.utils.Geom;
	import tempest.utils.Random;
	
	import tpm.magic.MagicEngine;
	import tpm.magic.entity.MagicInfo;
	import tpm.magic.entity.TargetObject;

	public class ParticleEffectOper extends Oper
	{
		private var nMuti:int;
		private var magicInfo:MagicInfo;
		private var caster:BattleCharacter;
		private var  hurts:Vector.<TargetObject>;
		
		public function ParticleEffectOper(caster:BattleCharacter, magicInfo:MagicInfo, hurts:Vector.<TargetObject>, nMuti:int)
		{
			super();
			this.hurts = hurts;
			this.caster = caster; 
			this.nMuti = nMuti;
			this.magicInfo = magicInfo;
		}
		
		override public function execute():void
		{
			var renderPoint:Point = new Point(caster.x, caster.y - MagicEngine.body_offset);
			var effect_id:int = magicInfo.magic_effectid;
			var tempSpeed:int = magicInfo.effect_movespeed;
			var finishNum:int = 0;
			for each(var target:TargetObject in hurts)
			{
				var targetPoint:Point = target.position.clone();
				targetPoint.y -= MagicEngine.body_offset;
				var distance:Number= Geom.getDistance(renderPoint, targetPoint);
				var duration:Number = NaN;
				if (tempSpeed > 0)
				{
					duration = (distance / tempSpeed);
				}
				else
				{
					duration = (distance / 1000);
				}
				var rotation:Number = Geom.GetRotation(renderPoint, targetPoint);
				var ani:Animation = Animation.createAnimation(effect_id, renderPoint.x, renderPoint.y);
				if (!MagicEngine.blendModeEnable)
				{
					ani.blendMode = BlendMode.NORMAL;
				}
				ani.type = AnimationType.Loop;
				if (magicInfo.is_rotation != 0)
				{
					if (magicInfo.is_rotation_action != 0)
					{
						ani.rotation = rotation;
					}
					else if (magicInfo.render_rotation != 0) //不指向运动方向,使用指定朝向并有随机值
					{
						ani.rotation = magicInfo.render_rotation + ((magicInfo.render_rondom_rotation != 0) ? Random.range(-magicInfo.render_rondom_rotation, magicInfo.render_rondom_rotation) :
						0);
					}
				}
				GameInstance.battleScene.addEffect(ani);
				GTweener.to(ani, duration, {x: targetPoint.x, y: targetPoint.y}, {onComplete: function(gt:GTween):void
				{
					finishNum ++;
					if(finishNum == hurts.length)
						result();
					Animation.disposeAnimation(gt.target as Animation);
				}});
			}
		}
	}
}