package modules.main.business.battle.model.queue
{
	import flash.geom.Point;
	
	import common.GameInstance;
	import common.flytext.ValueEffects;
	
	import fanshymy.controller.util.PlayerUtil;
	import fanshymy.controller.util.RoleManage;
	import fanshymy.proxy.GameConst;
	import fanshymy.proxy.battles.item.BloodEffect;
	import fanshymy.proxy.battles.item.FightingText;
	import fanshymy.proxy.battles.item.SkillEffect;
	import fanshymy.proxy.battles.item.SkillText;
	import fanshymy.proxy.battles.vo.AddObjectVO;
	import fanshymy.view.role.MapObject;
	
	import flashx.textLayout.tlf_internal;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.GroupOper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.TweenOper;
	import ghostcat.operation.WaitOper;
	
	import modules.main.business.battle.model.vo.RoundInfo;
	import modules.main.business.battle.view.components.element.BattleCharacter;
	import modules.main.business.skill.model.SkillData;
	
	import tpm.magic.entity.TargetObject;
	
	/**
	 * 远程技能伤害动作 
	 * @author yannengxiong
	 * 
	 */	
	public class SkillActionQueue implements IActionQueue
	{
		private var roundInfo:RoundInfo;
		private var _queue:Queue;
		private var castPlayer:BattleCharacter;
		private var targetPlayerArr:Array;

		public function SkillActionQueue(roundInfo:RoundInfo)
		{
			this.roundInfo = roundInfo;
			_queue = new Queue();
			sortQueue();
		}

		public function get queue():Queue
		{
			return _queue;
		}

		public function sortQueue():void
		{
			castPlayer = GameInstance.battleScene.getElement(roundInfo.castId);
			var length:int = roundInfo.targetArr.length;
			for each (var id:int in roundInfo.targetArr)
			{
				var targetPlayer:BattleCharacter =  GameInstance.battleScene.getElement(roundInfo.castId);
				targetPlayerArr.push(targetPlayer);
			}
			
			var targetObj :BattleCharacter;
			var listQueue :Array = [];
			//一起执行，不分先后的  
			var groupList :Array = [];
			var skillData:SkillData;
			
			//增加释放技能效果
			groupList.push(new SkillEffect(this.fireObj));
			groupList.push(new SkillText(this.fireObj.parent,this.attackVO.skillID));
			groupList.push(new FunctionOper(this.fireObj.animation.playAttack));
			groupList.push(new FunctionOper(PlayerUtil.I.playSkillMusic));
			listQueue.push(new GroupOper(groupList));
			
			//释放技能时等人物播放完攻击动作再播放伤害效果
			listQueue.push(new WaitOper(castPlayer.animation.checkIsPlayEnd));
			
			//受伤动作
			groupList = [];
			var length:int = targetPlayerArr.length;
			var isAddHurtMusic :Boolean = false;
			for(var i :int = 0; i < length; i++)
			{
				targetObj = targetPlayerArr[i] as BattleCharacter;
				var damage :int = roundInfo.damageArr[i];
				var targetObject:TargetObject = new TargetObject(targetID, null, damage, nflag);
				if(damage > 0)
				{
					//受伤
					if(targetObj.hurtFlag & ValueEffects.Decrease)
					{
						groupList.push(new FunctionOper(targetObj.animation.playHurt));
					}
					//抵挡
					if(targetObj.hurtFlag & ValueEffects.Defend)
					{
						groupList.push(new FightingText(targetObj,FightingText.RESIS));
					}
					//暴击
					if(targetObj.hurtFlag & ValueEffects.Double)
					{
						groupList.push(new FightingText(targetObj,FightingText.CRUCIAL));
					}
					groupList.push(new BloodEffect(targetObj,damage));
					groupList.push(new FunctionOper(targetObj.subHP,[damage]));
					
					if(!isAddHurtMusic)  //还没增加受伤音乐
					{
						groupList.push(new FunctionOper(PlayerUtil.I.playHurtMusic));
						isAddHurtMusic = true;
					}
				}else   //没伤害且是闪避
				{
					groupList.push(new FightingText(targetObj,FightingText.JINK));
					var dx :int = targetObj.addObjVO.roleType == AddObjectVO.TYPE_HERO ? -30 : 30;
					groupList.push(new TweenOper(targetObj,10 * GameConst.SPEED,
						{x :targetObj.x + dx}));
					
				}
			}
			listQueue.push(new GroupOper(groupList));
			
			//显示完闪避和做了闪避动作再回复原位
			if(this.attackVO.isJink)  
			{
				listQueue.push(new TweenOper(targetObj,20 * GameConst.SPEED,
					{x :targetObj.x}));
			}
			
			//反击
			if(targetObj.hurtFlag & ValueEffects.CounterAttack)
			{
				groupList = [];
				groupList.push(new FunctionOper(targetObj.animation.playAttack));
				groupList.push(new FightingText(targetObj,FightingText.BACK_ATTACK));
				listQueue.push(new GroupOper(groupList));
				if(this.attackVO.backAttackDamage > 0)
				{
					groupList = [];
					groupList.push(new FunctionOper(this.fireObj.animation.playHurt));
					groupList.push(new BloodEffect(this.fireObj,this.attackVO.backAttackDamage));
					listQueue.push(new GroupOper(groupList));
				}
			}
			
			queue = new Queue(listQueue);
			queue.execute();
			queue.addEventListener(OperationEvent.OPERATION_COMPLETE,queueCompleteHandler);
		}
	}
}