package fj1.common.flytext
{
	import fj1.common.GameInstance;
	import fj1.common.res.lan.LanguageManager;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import tempest.common.staticdata.Colors;
	
	import tpm.magic.entity.TargetObject;

	public class FlyTextHelper
	{
		//////////////////
		private static var _statusFlag:int = 200;
//		private static var _normalList:Array = SkillDataManager.normalList;
		private static var _onIsOnlyShowChange:ISignal;
		private static var _isOnlyShow:Boolean;

		public static function get onIsOnlyShowChange():ISignal
		{
			return _onIsOnlyShowChange ||= new Signal();
		}

		public static function set isOnlyShow(value:Boolean):void
		{
			_isOnlyShow = value;
			onIsOnlyShowChange.dispatch();
		}

		public static function get isOnlyShow():Boolean
		{
			return _isOnlyShow;
		}

		/**
		 *添加战斗飞行文字
		 * 伤害 暴击 闪避 未命中
		 */
		public static function addBattleFlyText(hurts:Vector.<TargetObject>, isNormalSpell:Boolean, isHeroDamage:Boolean = false, isMainCharPet:Boolean = false):void
		{
			for each (var targetObject:TargetObject in hurts)
			{
				if (targetObject)
				{
					if (isOnlyShow)
					{
						if (targetObject.guid != 0 && (isHeroDamage || targetObject.guid == GameInstance.mainChar.id) || isMainCharPet) //如果只显示玩家战斗信息
						{
							showDamage(targetObject, isNormalSpell, isMainCharPet);
						}
					}
					else
					{
						showDamage(targetObject, isNormalSpell, isMainCharPet);
					}
				}
			}
		}

		/**
		 *添加受击文字对象
		 * @param item
		 * @param spellID
		 *
		 */
		private static function showDamage(item:TargetObject, isNormalSpell:Boolean, isMainCharPet:Boolean = false):void
		{
			var mutiTypeArr:Array = damgeMutiType(item.flag);
			var target:BattleCharacter = target = GameInstance.battleScene.getElement(item.guid) as BattleCharacter;
			if (target == null)
			{
				return;
			}
			for each (var flag:int in mutiTypeArr)
			{
				var flytext:FlyableText = null;
				flytext = createFlytableText(flag, item.damage.toString());
				if (flytext)
				{
					if (flytext.content.length > 0)
					{
						target.showFlyText(setBattleText(flag, flytext, false/*target.isMainChar*/, isNormalSpell, isMainCharPet));
					}
				}
			}
			if (item.miss_damage > 0)
			{
				var missFlytext:FlyableText = createFlytableText(ValueEffects.Miss_Damage, item.miss_damage.toString());
				target.showFlyText(setBattleText(ValueEffects.Miss_Damage, missFlytext, false/*target.isMainChar*/, isNormalSpell));
			}
			if (target)
			{
				FlyTextTagger.instance.addToShow(target);
			}
		}

		/**
		 *添加状态飞行文字
		 * 生命值  魔法值  信仰值
		 * @param hurts
		 *
		 */
		public static function addStatusFlyText(character:BattleCharacter, type:int, value:int):void
		{
			var isMainChar:Boolean = /*character.isMainChar*/false;
			if (!isOnlyShow || isMainChar)
			{
				var statusFlytext:FlyableText = createFlytableText((type + _statusFlag), value.toString());
				if (statusFlytext)
				{
					var isDecrase:Boolean = Boolean(value < 0);
					character.showFlyText(setPropertyText((type + _statusFlag), statusFlytext, isMainChar, isDecrase));
					FlyTextTagger.instance.addToShow(character);
				}
			}
		}

		/**
		 *添加属性文字提示
		 * @param type
		 *
		 */
		public static function addPropertyFlyText(char:BattleCharacter, type:int, value:int = 0):void
		{
			var proerptyFlyText:FlyableText = createFlytableText(type, value.toString());
			if (proerptyFlyText)
			{
				var isDecrase:Boolean = Boolean(value < 0);
				char.showFlyText(setPropertyText(type, proerptyFlyText, true, isDecrase));
				FlyTextTagger.instance.addToShow(char);
			}
		}

		/**
		 *添加使用技能显示技能名称
		 * @param caster
		 * @param name
		 *
		 */
		public static function addSpellNameFlyText(caster:BattleCharacter, name:String):void
		{
			if (name.length == 0)
			{
				return;
			}
			var spellFlyText:FlyableText = createFlytableText(ValueEffects.Spell_Name, name);
			if (spellFlyText)
			{
				caster.showFlyText(setPropertyText(ValueEffects.Spell_Name, spellFlyText));
				FlyTextTagger.instance.addToShow(caster);
			}
		}

		/**
		 *创建漂浮文字
		 * @param flag
		 * @param value
		 * @return
		 *
		 */
		private static function createFlytableText(flag:int, value:String):FlyableText
		{
			var content:String = "";
			var orien:int = 1;
			switch (flag)
			{
				////////////////////////伤害数字/////////////////////////
				case ValueEffects.None:
					content = LanguageManager.translate(6001, "未命中");
					orien = 3;
					break;
				case ValueEffects.Decrease: //普通伤害
					if (getValueChar(value, true) == "0")
					{
						return null;
					}
					content = getValueChar(value);
					orien = 1;
					break;
				case ValueEffects.Double:
					content = LanguageManager.translate(6002, "暴 击") + getValueChar(value);
					orien = 1;
					break;
				case ValueEffects.Increase: //生命值增加
				case ValueEffects.MultiIncrease: //加倍治疗
					if (getValueChar(value, true) == "0")
					{
						return null;
					}
					content = LanguageManager.translate(6003, "生 命") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.Failure:
					content = LanguageManager.translate(6001, "未命中");
					orien = 3;
					break;
				case ValueEffects.Death:
					content = LanguageManager.translate(6005, "死 亡");
					orien = 3;
					break;
				case ValueEffects.SpellEffectFlag_BeatBack:
					content = LanguageManager.translate(6006, "击 退");
					orien = 4;
					break;
				case ValueEffects.Miss_Damage:
					content = LanguageManager.translate(81023, "吸收") + getValueChar(value, false, false);
					orien = 4;
					break;
					break;
				//////////////////技能效果状态//////////////////////////
				case ValueEffects.STATUS_EFFECT_TYPE:
					content = LanguageManager.translate(6007, "状态增益");
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_HP:
					content = LanguageManager.translate(6003, "生 命") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_MP:
					content = LanguageManager.translate(6004, "魔 法") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_BELIEF:
					content = LanguageManager.translate(6008, "信仰力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EEFECT_TYPE_EXP:
					content = LanguageManager.translate(6009, "经验") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EEFECT_TYPE_ATTACK_POINT:
					content = LanguageManager.translate(6010, "攻") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_DEFANSE_POINT:
					content = LanguageManager.translate(6011, "防") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_BODY_POINT:
					content = LanguageManager.translate(6012, "体") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_DELICTY_POINT:
					content = LanguageManager.translate(6013, "敏") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_SPELL:
					content = LanguageManager.translate(6014, "获得技能") + value;
					orien = 4;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_REWARD:
					content = LanguageManager.translate(6015, "声 望") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_GODPOWER:
					content = LanguageManager.translate(6026, "神 力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_HPMAX:
					content = LanguageManager.translate(6025, "生命上限") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_MANAMAX:
					content = LanguageManager.translate(6024, "魔法上限") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_ATTACK:
					content = LanguageManager.translate(6023, "攻击力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_DEFINSE:
					content = LanguageManager.translate(6022, "防御力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_BROKEN:
					content = LanguageManager.translate(6021, "破甲") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_DELICACY:
					content = LanguageManager.translate(3050, "灵巧") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_HEYMAKER:
					content = LanguageManager.translate(3049, "暴击") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_WHITE_MAGIC:
					content = LanguageManager.translate(3025, "白魔法力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_BLACK_MAGIC:
					content = LanguageManager.translate(3026, "黑魔法力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_BLUE_MAGIC:
					content = LanguageManager.translate(3027, "青魔法力") + getValueChar(value, false, true);
					orien = 4;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_RED_MAGIC:
					content = LanguageManager.translate(3028, "血魔法力") + getValueChar(value, false, true);
					orien = 4;
					break;
				///////////////////角色状态文字//////////////////////
				case ValueEffects.STATE_BEGIN_FIGHT:
					content = LanguageManager.translate(6016, "进入战斗");
					orien = 1;
					break;
				case ValueEffects.STATE_EXIT_FIGHT:
					content = LanguageManager.translate(6017, "退出战斗");
					orien = 1;
					break;
				////////////////////技能名字/////////////
				case ValueEffects.Spell_Name:
					content = value;
					orien = 3;
					break;
			}
			if (content.length == 0)
			{
				return null;
			}
			return FlyableText.createFlyableText(orien, content);
		}

		/**
		 *返回格式化数值
		 * @param value
		 * @param isZero
		 * @return
		 *
		 */
		private static function getValueChar(value:String, isZero:Boolean = false, isPlus:Boolean = false):String
		{
			if (value != "0")
			{
				if (int(value) > 0)
				{
					return ((isPlus) ? "+" : "") + value;
				}
				else
				{
					return value;
				}
			}
			else
			{
				return ((isZero) ? "0" : "");
			}
		}

		/**
		 *取出上伤害字段的复合类型
		 * @param mutiFlag
		 * @return
		 *
		 */
		private static function damgeMutiType(mutiFlag:uint):Array
		{
			var arr:Array = [];
			if ((mutiFlag & ValueEffects.None)) //无伤害
			{
				arr.push(ValueEffects.Failure);
			}
			if ((mutiFlag & ValueEffects.Double)) //暴击
			{
				arr.push(ValueEffects.Double);
			}
			if ((mutiFlag & ValueEffects.Decrease)) // 普通伤害
			{
				arr.push(ValueEffects.Decrease);
			}
			if ((mutiFlag & ValueEffects.Failure)) // 丢未命中
			{
				arr.push(ValueEffects.Failure);
			}
			if ((mutiFlag & ValueEffects.MultiIncrease)) // 加倍治疗
			{
				arr.push(ValueEffects.MultiIncrease);
			}
			if ((mutiFlag & ValueEffects.Increase)) //生命值增加
			{
				arr.push(ValueEffects.Increase);
			}
			//死亡
//			if ((mutiFlag & ValueEffects.Death))
//				arr.push(ValueEffects.Death);
//			if ((mutiFlag & ValueEffects.MultipleDamage)) //多重伤害
//			{
//				arr.push(ValueEffects.MultipleDamage);
//			}
			if ((mutiFlag & ValueEffects.SpellEffectFlag_BeatBack)) //击退
			{
				arr.push(ValueEffects.SpellEffectFlag_BeatBack);
			}
			return arr;
		}

		/**
		 *根据战斗状态设置文字颜色
		 * @param flag
		 * @return
		 *
		 */
		private static function setBattleText(flag:int, flyText:FlyableText, isMainChar:Boolean, isNormalSpell:Boolean, isMainCharPet:Boolean = false):FlyableText
		{
			if (isMainCharPet) //主角召唤兽技能
			{
				flyText.bodyColor = Colors.Cyan; //深蓝色
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.MultiIncrease) //加倍治疗
			{
				flyText.bodyColor = Colors.Green;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.Increase) //加血
			{
				flyText.bodyColor = Colors.Green;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (isMainChar) //自身
			{
				flyText.bodyColor = Colors.Red; //如果是自己红色
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (isNormalSpell) //如果是普通攻击白色
			{
				flyText.bodyColor = Colors.White;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.Decrease) //如果是减血
			{
				flyText.bodyColor = Colors.Yellow;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.Failure || flag & ValueEffects.None) //未命中
			{
				flyText.bodyColor = Colors.Yellow;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.MultipleDamage) //多重伤害
			{
				flyText.bodyColor = Colors.Yellow;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.SpellEffectFlag_BeatBack) //击退
			{
				flyText.bodyColor = Colors.Yellow;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			else if (flag & ValueEffects.Miss_Damage) //伤害吸收
			{
				flyText.bodyColor = Colors.Yellow;
				flyText.bodySize = FlyableText.TEXT_SIZE_20;
			}
			if (flag & ValueEffects.Double) //暴击  （放大字体）
			{
				if (flyText.bodyColor == 0)
				{
					flyText.bodyColor = Colors.Yellow;
				}
				flyText.bodySize = FlyableText.TEXT_SIZE_32;
			}
			return flyText;
		}

		/**
		 *根据问题内容类型设置文字颜色
		 * @param flag
		 * @param flyText
		 * @return
		 *
		 */
		private static function setPropertyText(flag:int, flyText:FlyableText, isMainChar:Boolean = false, isDecrase:Boolean = false):FlyableText
		{
			switch (flag)
			{
				case ValueEffects.STATUS_EFFECT_TYPE_HP: //（生命恢复）加血
					if (isDecrase)
					{
						if (isMainChar)
						{
							flyText.bodyColor = Colors.Red;
						}
						else
						{
							flyText.bodyColor = Colors.Yellow;
						}
					}
					else
					{
						flyText.bodyColor = Colors.Green;
					}
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_MP: //加蓝			 
					flyText.bodyColor = Colors.QulityBlue;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATUS_EEFECT_TYPE_EXP: //加经验
					flyText.bodyColor = Colors.Green;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_BELIEF: //加信仰力
					flyText.bodyColor = Colors.QulityPurple;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATE_BEGIN_FIGHT:
				case ValueEffects.STATE_EXIT_FIGHT: //进入退出战斗
					flyText.bodyColor = Colors.Orange;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATUS_EEFECT_TYPE_ATTACK_POINT: //加属性攻击
				case ValueEffects.STATUS_EFFECT_TYPE_DEFANSE_POINT: //加属性防击
				case ValueEffects.STATUS_EFFECT_TYPE_BODY_POINT: //加属性体击
				case ValueEffects.STATUS_EFFECT_TYPE_DELICTY_POINT: //加属性敏击
				case ValueEffects.STATUE_EFFECT_TYPE_HPMAX:
				case ValueEffects.STATUE_EFFECT_TYPE_MANAMAX:
				case ValueEffects.STATUE_EFFECT_TYPE_ATTACK:
				case ValueEffects.STATUE_EFFECT_TYPE_DEFINSE:
				case ValueEffects.STATUE_EFFECT_TYPE_BROKEN:
				case ValueEffects.STATUE_EFFECT_TYPE_DELICACY:
				case ValueEffects.STATUE_EFFECT_TYPE_HEYMAKER:
				case ValueEffects.STATUE_EFFECT_TYPE_WHITE_MAGIC:
				case ValueEffects.STATUE_EFFECT_TYPE_BLACK_MAGIC:
				case ValueEffects.STATUE_EFFECT_TYPE_BLUE_MAGIC:
				case ValueEffects.STATUE_EFFECT_TYPE_RED_MAGIC:
					flyText.bodyColor = Colors.Yellow;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATUS_EFFECT_TYPE_SPELL: //获得技能
					flyText.bodyColor = Colors.QulityPurple;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.STATUE_EFFECT_TYPE_GODPOWER: //获得神力
					flyText.bodyColor = Colors.Yellow;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
				case ValueEffects.Spell_Name: //技能名称
					flyText.bodyColor = Colors.Magenta;
					flyText.bodySize = FlyableText.TEXT_SIZE_20;
					break;
			}
			return flyText;
		}
	}
}
