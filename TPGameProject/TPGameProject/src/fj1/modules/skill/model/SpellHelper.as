package fj1.modules.skill.model
{
	import com.gskinner.motion.GTweener;
	
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	import fj1.common.GameInstance;
	import fj1.common.flytext.ValueEffects;
	import fj1.modules.battle.model.actions.CriticalStrikeOper;
	import fj1.modules.battle.model.actions.DefendOper;
	import fj1.modules.battle.model.actions.DodgeOper;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	
	import ghostcat.operation.FunctionOper;
	
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.staticdata.Status;
	import tempest.utils.Geom;
	
	import tpm.magic.MagicEngine;
	import tpm.magic.entity.MagicInfo;
	import tpm.magic.entity.TargetObject;
	import tpm.spell.enum.SpecialEffectType;

	public class SpellHelper
	{
		/**
		 * 前层效果
		 */
		public static const FG_EFFECT:int = 0x1 << 0;
		/**
		 *后层效果
		 */
		public static const BG_EFFECT:int = 0x1 << 1;
		/**
		 * 是否添加到角色
		 */
		public static const FOLLOW_EFFECT:int = 0x1 << 2;
		/**
		 *释放效果
		 */
		public static const CASTER_EFFECT:String = "caster_effect";
		/**
		 *碰撞效果
		 */
		public static const HIT_EFFECT:String = "hit_effect";
		/**
		 *受击效果
		 */
		public static const HURT_EFFECT:String = "hurt_effect";

		
		/**
		 *施法效果
		 * @param caster
		 * @param magicInfo
		 * @param effectPoint
		 */
		public static function casterEffect(caster:BattleCharacter, magicInfo:MagicInfo, renderPoint:Point, casterEffectComplete:Function = null):void
		{
			if (magicInfo)
			{
				var effectNum:int = 0;
				var finishCount:int = 0;//效果完成数
				var effectID:int = NaN;
				var rotation:Number = 0;
				var onComplete:Function = function(ani:Animation):void
				{
					caster.removeEffect(ani.id);
					finishCount++;
					if(finishCount == 	effectNum)
					{
						if(casterEffectComplete != null)
							casterEffectComplete();
					}
				}
				for (var i:int = 1; i <= 5; i++)
				{
					effectID = magicInfo[CASTER_EFFECT + i];
					if (effectID != 0)
					{
						effectNum ++;
						if(!Animation.animations[effectID])
							effectNum--;
						addEffect(effectID, caster, renderPoint, rotation, true, onComplete);
					}
					else
					{
						break;
					}
				}
			}
		}

		/**
		 *受击效果
		 * @param renerPoint
		 * @param hurts
		 * @param magicInfo
		 *
		 */
		public static function hurtEffectFuc(/*renerPoint:Point,*/ hurts:Vector.<TargetObject>, magicInfo:MagicInfo, hurtEffectComplete:Function = null):void
		{
			var finishCount:int = 0;//效果完成数
			var targetObject:TargetObject = null;
			var effectIdArr:Array = [];
			var characterArr:Array = [];
			for (var i:int = 1; i <= 2; i++)
			{
				var effectId:int = magicInfo[HURT_EFFECT + i];
				if(effectId!=0)
					effectIdArr.push(effectId);
			}
			var length:int = effectIdArr.length;
			var onComplete:Function = function(ani:Animation):void
			{
				for each(var item:BattleCharacter in characterArr)
				{
					character.removeEffect(ani.id);
				}
				finishCount++;
				if(finishCount == 	length)
				{
					if(hurtEffectComplete != null)
						hurtEffectComplete();
				}
			}
			for each (targetObject in hurts)
			{
				var character:BattleCharacter = GameInstance.battleScene.getElement(targetObject.guid) as BattleCharacter;
				if (character)
				{
					if (magicInfo)
					{
						var effectID:int = NaN;
						var rotation:Number = 0;
						for (var j:int = 0; j <= length; j++)
						{
							effectID = effectIdArr[j];
							if(!Animation.animations[effectID])
								effectIdArr.splice(j, 1);
							var targetPoint:Point = new Point(character.x, character.y);
							addEffect(effectID, character, targetPoint, rotation, true, onComplete);
						}
					}
					characterArr.push(character);
					addSpecialActionClient(targetObject);
				}
			}
		}

		/**
		 *添加碰撞光效
		 * @param magicPoint  魔法点
		 *
		 */
		public static function hitFuc(magicInfo:MagicInfo, targetObject:TargetObject, targetPoint:Point, hitEffectComplete:Function = null):void
		{
			if (magicInfo == null)
			{
				return;
			}
			var effectNum:int = 0;
			var finishCount:int = 0;//效果完成数
			var effectID:int=NaN;
			var character:BattleCharacter=null;
			if (targetObject && targetObject.guid != 0)
				character = GameInstance.battleScene.getElement(targetObject.guid) as BattleCharacter;
			var onComplete:Function = function(ani:Animation):void
			{
				character.removeEffect(ani.id);
				finishCount++;
				if(finishCount == 	effectNum)
				{
					if(hitEffectComplete != null)
						hitEffectComplete();
				}
			}
			for (var i:int=1; i <= 2; i++)
			{
				effectID=magicInfo[SpellHelper.HIT_EFFECT + i];
				if (effectID != 0)
				{
					effectNum++;
					if(!Animation.animations[effectID])
						effectNum--;
					addEffect(effectID, character, targetPoint, 0, true, onComplete);
				}
				else
					break;
			}
		}
		
		/**
		 *客户端添加特殊表现效果
		 * @param target
		 * @param specialEffectType
		 * @param backPoint
		 *
		 */
		public static function addSpecialActionClient(targetObject:TargetObject):void
		{
			var target:BattleCharacter = GameInstance.battleScene.getElement(targetObject.guid) as BattleCharacter;
			//击飞
			if (targetObject.flag & SpecialEffectType.BeKnock)
			{
				if (targetObject.casterPoint && target)
				{
					var targetPos:Point = new Point(target.x, target.y);
					var ang:Number = Geom.getTwoPointRadian(targetObject.casterPoint, targetPos) + Math.PI;
					var backX:int = target.x + SpecialEffectType.BeKnock_Distance * Math.cos(ang);
					var backY:int = target.y + SpecialEffectType.BeKnock_Distance * Math.sin(ang);
					GTweener.to(target, 0.1, {pixel_x: backX, pixel_y: backY});
				}
			}
			if ((targetObject.flag & 0x02)) //播放受击动作
			{
				if (target.getStatus() != Status.DEAD)
				{
					target.playTo(Status.INJURE);
				}
			}
		}

		/**
		 *给角色或着场景添加光效
		 * @param effectID  添加光效ID
		 * @param sceneCharacter 添加光效的对象
		 * @param effectPoint  添加光效点
		 * @param rotation   添加光效偏移
		 *
		 */
		public static function addEffect(effectID:int, sceneCharacter:BattleCharacter, effectPoint:Point, rotation:Number, isOffset:Boolean = true, onComplete:Function = null):void
		{
			if (effectID != 0)
			{
				var isLand:Boolean = false;
				var flag:int = NaN;
				flag = effectID % 10;
				isLand = Boolean(flag & FG_EFFECT);
				var ani:Animation = Animation.createAnimation(effectID);
				ani.onComplete = onComplete;
				if (!MagicEngine.blendModeEnable)
				{
					ani.blendMode = BlendMode.NORMAL;
				}
				if (rotation != 0)
				{
					ani.rotation = rotation;
				}
				if ((flag & FOLLOW_EFFECT) && sceneCharacter)
				{
					sceneCharacter.addEffect(ani, !isLand, false, true, false);
				}
				else if (effectPoint)
				{
					ani.move(effectPoint.x, ((isOffset) ? (effectPoint.y - MagicEngine.body_offset) : effectPoint.y));
					MagicEngine.container.addEffect(ani, isLand);
				}
			}
		}
		
		/**
		 * 获取被攻击后表现动作 
		 * @param hurtFlag
		 * @param target
		 * @return 
		 * 
		 */		
		public static function getHurtResponseActions(hurtFlag:int, target:BattleCharacter):Array
		{
			var groupList:Array = []
			if (hurtFlag & ValueEffects.Decrease)
			{
				groupList.push(new FunctionOper());
			}
			//抵挡
			if (hurtFlag & ValueEffects.Defend)
			{
				groupList.push(new DefendOper());
			}
			//暴击
			if (hurtFlag & ValueEffects.Double)
			{
				groupList.push(new CriticalStrikeOper());
			}
			//闪避
			if (hurtFlag & ValueEffects.Dodge)
			{
				groupList.push(new DodgeOper(target));
			}
			
			if (hurtFlag & ValueEffects.Increase)
			{
				groupList.push(new DodgeOper(target));
			}
			return groupList;
		}

	}
}
