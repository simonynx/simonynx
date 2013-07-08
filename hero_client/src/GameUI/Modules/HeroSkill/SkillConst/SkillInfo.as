//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.HeroSkill.SkillConst {

    public class SkillInfo {

        public static const F_STATE_CHARM:int = 8;
        public static const EFF_TARGET_FRIEND_IN_TEAM:int = 5;
        public static const EFF_TARGET_PET:int = 7;
        public static const SPELL_EFFECT_FEVER_REVENGE:int = 15;
        public static const F_STATE_VERTIGO:int = 1;
        public static const EFF_TARGET_TAPER_FRONT_OF_CASTER:int = 12;
        public static const SPELL_CATEGORY_GOUND_ATTACK_SELF:int = 12;
        public static const SPELL_EFFECT_INSTANT_DAMAGE:int = 1;
        public static const EFF_TARGET_SINGLE_ENEMY:int = 2;
        public static const ATTRIBUTES_PASSIVE:int = 2;
        public static const SPELL_CATEGORY_TREASURES:int = 10;
        public static const SPELL_EFFECT_EFFECT_BUFF:int = 11;
        public static const F_STATE_NULL:int = 0;
        public static const SPELL_CATEGORY_NULL:int = 0;
        public static const SPELL_CATEGORY_RANGESPELL:int = 6;
        public static const TARGET_SUCK:String = "target_suck";
        public static const F_STATE_SHIELDS:int = 0x0100;
        public static const SPELL_EFFECT_DISPEL:int = 5;
        public static const SPELL_CATEGORY_GOUND_ATTACK_TARGET:int = 13;
        public static const ATTRIBUTEEX_PASSIVE_ADD_LVMULTIPIE:int = 16;
        public static const SPELL_CATEGORY_REPEATATTACK:int = 8;
        public static const TARGET_DEAD:String = "target_dead";
        public static const EFF_TARGET_ENEMY_AROUND_CASTER:int = 10;
        public static const TARGET_RESIST:String = "target_resist";
        public static const ATTRIBUTES_PURE_BUFF:int = 4;
        public static const SPELL_EFFECT_ENERGIZE:int = 13;
        public static const TARGET_REBOUND:String = "target_rebound";
        public static const EFF_TARGET_ALL_ENEMY_IN_AREA:int = 8;
        public static const ATTRIBUTEEX_PASSIVE_ADD_PERCENTAGE:int = 8;
        public static const SPELL_CATEGORY_TEAMSPELL:int = 5;
        public static const ATTRIBUTESEX_NULL:int = 0;
        public static const SPELL_COST_ITEM_CATERGORY:int = 16;
        public static const SPELL_COST_BLOOD_PERCENTAGE:int = 4;
        public static const SPELL_EFFECT_PURE_DEBUFF:int = 10;
        public static const EFF_TARGET_ENEMY_IN_TEAM:int = 6;
        public static const SPELL_CATEGORY_MOVEATONCE:int = 7;
        public static const TARGET_HP:String = "target_hp";
        public static const SPELL_EFFECT_BEHEADKILL:int = 12;
        public static const EFF_TARGET_SINGLE_TARGET:int = 4;
        public static const ATTRIBUTES_VISUAL_AURA_POSITIVE:int = 8;
        public static const EFF_TARGET_SINGLE_FRIEND:int = 3;
        public static const SPELL_EFFECT_SLAUGHTER_SHOOT:int = 14;
        public static const F_STATE_FREEZE:int = 16;
        public static const SPELL_CATEGORY_BUFFORDOT:int = 3;
        public static const EFF_TARGET_MULTIPLE_SINGLE_ENEMY:int = 15;
        public static const SPELL_EFFECT_APPLY_AREA_AURA:int = 7;
        public static const SPELL_CATEGORY_CLEAR_FORBID:int = 11;
        public static const SPELL_COST_BLOOD_VALUE:int = 2;
        public static const SPELL_CATEGORY_HEAL:int = 2;
        public static const TARGET_ERUPTIVE_HP:String = "target_eruptive_hp";
        public static const F_STAET_FROZEN:int = 128;
        public static const TARGET_ABSORB:String = "target_absorb";
        public static const SPELL_COST_ITEM_VALUE:int = 8;
        public static const F_STATE_HUNTERSTAMP:int = 32;
        public static const SPELL_EFFECT_ADD_EXTRA_ATTACKS:int = 2;
        public static const SPELL_EFFECT_APPLY_AURA:int = 6;
        public static const SPELL_CATEGORY_MELEEATTACK:int = 1;
        public static const SPELL_EFFECT_TEAM_HEAL:int = 4;
        public static const TARGET_EVASION:String = "target_evasion";
        public static const EFF_TARGET_ENEMY_AROUND_TARGET:int = 9;
        public static const EFF_TARGET_BEHEAD_TARGET:int = 13;
        public static const SPELL_EFFECT_NULL:int = 1;
        public static const SPELL_CATEGORY_REMOTEATTACK:int = 4;
        public static const EFF_TARGET_SELF:int = 1;
        public static const ATTRIBUTES_VISUAL_AURA_NEGATIVE:int = 16;
        public static const SPELL_EFFECT_HEAL_OR_HURT:int = 9;
        public static const F_STATE_ASTHENIA:int = 2;
        public static const ATTRIBUTEEX_PASSIVE_ADD_VALUE:int = 4;
        public static const SPELL_COST_MANA_VALUE:int = 0;
        public static const SPELL_EFFECT_INSTANT_HEAL:int = 3;
        public static const F_STATE_FASTING:int = 64;
        public static const SPELL_CATEGORY_REPEATATTACK_MELEE:int = 9;
        public static const EFF_TARGET_AROUND_CASTER:int = 11;
        public static const EFF_TARGET_CORPSE_IN_TEAM:int = 14;
        public static const SPELL_EFFECT_MANA_BURN:int = 8;
        public static const TARGET_IMMUNE:String = "target_immune";
        public static const ATTRIBUTESEX_CAN_NULL_CAST:int = 1;
        public static const ATTRIBUTESEX_NON_BASEDAMAGE:int = 2;
        public static const SPELL_COST_MANA_PERCENTAGE:int = 1;
        public static const F_STATE_SLEEP:int = 4;

        public var effectTargetA_1:int;
        public var effectTargetA_2:int;
        public var effect_1:int;
        public var effect_2:int;
        public var SkillType:int;
        public var Distance:int;
        public var Job:int;
        public var MaxLevel:int;
        public var Name:String = "未知";
        public var Effect:String;
        public var IsTop:Boolean;
        public var effectTargetB_2:int;
        public var Index:int;
        public var Id:int;
        public var isLearn:Boolean;
        public var IsOne:Boolean;
        public var PreSkillId:int;
        public var effectTargetB_1:int;
        public var buffId:int;
        public var Type:int;
        public var SkillArea:int = 4;
        public var effectBasePoint_1:int;
        public var effectBasePoint_2:int;
        public var HitEffect:String;
        public var CoolTime:int;
        public var JobLevel:int;
        public var AutomatismUseTime:Number = 0;
        public var Level:int;
        public var NeedLevel:int;
        public var attributesEx:int;
        public var SkillMode:int;
        public var TypeID:int;
        public var isAuto:Boolean;
        public var description:String = "无";

        public function setSkillType():void{
            TypeID = int((Id / 100));
            Index = (TypeID % 100);
            JobLevel = (int((Id / 10000)) % 10);
            if (effectTargetA_1 != 0){
                SkillType = effectTargetA_1;
            } else {
                if (effectTargetA_2 != 0){
                    SkillType = effectTargetA_2;
                } else {
                    if (effectTargetB_1 != 0){
                        SkillType = effectTargetB_1;
                    } else {
                        if (effectTargetB_2 != 0){
                            SkillType = effectTargetB_2;
                        };
                    };
                };
            };
        }

    }
}//package GameUI.Modules.HeroSkill.SkillConst 
