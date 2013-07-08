//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Skill {
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import OopsEngine.Scene.StrategyElement.Person.*;

    public class GameSkillMode {

        public static function TargetState(_arg1:SkillInfo):int{
            var _local2:* = 1;
            if (_arg1.SkillType == SkillInfo.EFF_TARGET_CORPSE_IN_TEAM){
                _local2 = 2;
            };
            if (_arg1.SkillType == SkillInfo.EFF_TARGET_SINGLE_TARGET){
                _local2 = 3;
            };
            return (_local2);
        }
        public static function IsShowSkillName(_arg1:int):Boolean{
            if (_arg1 != 0){
                return (true);
            };
            return (false);
        }
        public static function IsToSelfSkill(_arg1:SkillInfo):Boolean{
            if ((((_arg1.attributesEx & SkillInfo.ATTRIBUTESEX_CAN_NULL_CAST)) && (!((_arg1.SkillType == SkillInfo.EFF_TARGET_ALL_ENEMY_IN_AREA))))){
                return (true);
            };
            if ((((_arg1.SkillType == SkillInfo.EFF_TARGET_SELF)) || ((_arg1.SkillType == SkillInfo.EFF_TARGET_FRIEND_IN_TEAM)))){
                return (true);
            };
            return (false);
        }
        public static function IsDoctorSkill(_arg1:SkillInfo, _arg2:GameElementAnimal, _arg3:GameElementAnimal):Boolean{
            if ((((_arg1.TypeID == 6015)) || ((_arg1.TypeID == 8003)))){
                if (_arg2 == _arg3){
                    return (true);
                };
                if (((!((_arg2.Role.UsingPetAnimal == null))) && ((_arg2.Role.UsingPetAnimal == _arg3)))){
                    return (true);
                };
                return (false);
            };
            if ((((_arg1.effect_1 == SkillInfo.SPELL_EFFECT_INSTANT_HEAL)) || ((_arg1.effect_1 == SkillInfo.SPELL_EFFECT_TEAM_HEAL)))){
                return (true);
            };
            if ((((_arg1.effect_2 == SkillInfo.SPELL_EFFECT_INSTANT_HEAL)) || ((_arg1.effect_2 == SkillInfo.SPELL_EFFECT_TEAM_HEAL)))){
                return (true);
            };
            if (_arg1.effect_1 == SkillInfo.SPELL_EFFECT_HEAL_OR_HURT){
                if ((_arg3 is GameElementPlayer)){
                    if (_arg3 == _arg2){
                        return (true);
                    };
                    if (((!((_arg3.Role.idTeam == 0))) && ((_arg3.Role.idTeam == _arg2.Role.idTeam)))){
                        return (true);
                    };
                };
            };
            return (false);
        }
        public static function IsPetBuffSkill(_arg1:int):Boolean{
            if (_arg1 != 12){
                return (false);
            };
            return (true);
        }
        public static function IsTargetSelfSkill(_arg1:SkillInfo):Boolean{
            if ((((_arg1.SkillType == SkillInfo.EFF_TARGET_SELF)) || ((_arg1.SkillType == SkillInfo.EFF_TARGET_FRIEND_IN_TEAM)))){
                return (true);
            };
            return (false);
        }
        public static function IsShowRect(_arg1:int):Boolean{
            if (_arg1 == SkillInfo.EFF_TARGET_ALL_ENEMY_IN_AREA){
                return (true);
            };
            return (false);
        }
        public static function IsRushSkill(_arg1:SkillInfo):Boolean{
            if (_arg1.TypeID == 1201){
                return (true);
            };
            return (false);
        }
        public static function IsSaveSkill(_arg1:SkillInfo):Boolean{
            if (_arg1.SkillType == SkillInfo.EFF_TARGET_CORPSE_IN_TEAM){
                return (true);
            };
            return (false);
        }
        public static function IsNoChangeDir(_arg1:int):Boolean{
            return (true);
        }
        public static function isBuffSkill(_arg1:SkillInfo):Boolean{
            if ((((_arg1.Type == SkillInfo.ATTRIBUTES_PURE_BUFF)) || ((_arg1.Type == SkillInfo.ATTRIBUTES_VISUAL_AURA_POSITIVE)))){
                return (true);
            };
            return (false);
        }
        public static function IsCommon(_arg1:int):Boolean{
            if (_arg1 == 0){
                return (true);
            };
            return (false);
        }
        public static function IsGrabSkill(_arg1:SkillInfo):Boolean{
            if (_arg1.TypeID == 9002){
                return (true);
            };
            return (false);
        }
        public static function IsNoTarget(_arg1:int):Boolean{
            if (_arg1 == SkillInfo.SPELL_CATEGORY_RANGESPELL){
                return (true);
            };
            return (false);
        }

    }
}//package OopsEngine.Skill 
