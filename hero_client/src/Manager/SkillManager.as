//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import Net.*;

    public class SkillManager {

        public static const SKILLID_Mediation:int = 11001;

        public static var MySkillTreeOne:Array = [];
        public static var AllSkillList:Array = [[], [], [], [], [], [], [], [], [], [], []];
        public static var MyTotalSkillList:Array = [];
        public static var MySkillListId:Array = [];
        public static var MySkillList:Array = [];
        public static var SkillCurrentPoint:Array = [0, 0, 0];
        public static var MySkillTreeTwo:Array = [];
        public static var AllDefaultSkill:SkillInfo = null;
        public static var UseSkillLock:Boolean;
        public static var MySkillTreeThree:Array = [];
        public static var DefaultSkillList:Dictionary = null;

        public static function setMySkillList():void{
            var _local2:int;
            var _local3:SkillInfo;
            var _local1:int = MySkillListId.length;
            MyTotalSkillList = [];
            while (_local2 < _local1) {
                _local3 = SkillManager.getIdSkillInfo(MySkillListId[_local2]);
                MyTotalSkillList.push(_local3);
                _local2++;
            };
        }
        public static function getMyIdSkillInfo(_arg1:int):SkillInfo{
            var _local3:SkillInfo;
            var _local2:Array = SkillManager.MyTotalSkillList;
            for each (_local3 in _local2) {
                if (_local3.Id == _arg1){
                    return (_local3);
                };
            };
            return (null);
        }
        public static function IsNewSkill(_arg1:int):Boolean{
            if ((_arg1 % 10) == 1){
                return (true);
            };
            return (false);
        }
        public static function getMySkillTree(_arg1:NetPacket):void{
        }
        public static function getIdSkillInfo(_arg1:int):SkillInfo{
            var _local2:Array;
            var _local4:SkillInfo;
            var _local3:int = int((_arg1 / 100000));
            _local2 = SkillManager.AllSkillList[_local3];
            for each (_local4 in _local2) {
                if (_local4.Id == _arg1){
                    return (_local4);
                };
            };
            throw (new Error(("不应该找不到技能" + _arg1)));
        }
        public static function GetAlldefaultSkill():SkillInfo{
            if (AllDefaultSkill == null){
                AllDefaultSkill = new SkillInfo();
                AllDefaultSkill.Distance = 1;
                AllDefaultSkill.SkillMode = SkillInfo.SPELL_CATEGORY_NULL;
                AllDefaultSkill.Name = LanguageMgr.GetTranslation("攻击");
            };
            return (AllDefaultSkill);
        }
        public static function getMySkillInfo(_arg1:int, _arg2:int, _arg3:int, _arg4:int=1):SkillInfo{
            var _local5:Array = SkillManager.MyTotalSkillList;
            var _local6:uint;
            while (_local6 < _local5.length) {
                if (_local5[_local6].JobLevel == _arg2){
                    if (_local5[_local6].Index == _arg3){
                        if (_local5[_local6].Level == _arg4){
                            return (_local5[_local6]);
                        };
                    };
                };
                _local6++;
            };
            return (null);
        }
        public static function getNowPoint():Array{
            var _local1:Array = [];
            var _local2:int = GameCommonData.Player.Role.Level;
            if (_local2 <= 29){
                _local1.push(int(((_local2 - 8) / 2)));
                _local1.push(0);
                _local1.push(0);
            } else {
                if (_local2 <= 69){
                    _local1.push(10);
                    _local1.push(int(((_local2 - 28) / 2)));
                    _local1.push(0);
                } else {
                    if (_local2 <= 100){
                        _local1.push(10);
                        _local1.push(20);
                        _local1.push(int(((_local2 - 68) / 2)));
                    };
                };
            };
            return (_local1);
        }
        public static function getMyList(_arg1:NetPacket):void{
        }
        public static function GetDefaultSkill(_arg1:GameElementAnimal):SkillInfo{
            var _local2:int;
            var _local3:int;
            var _local4:SkillInfo;
            if (DefaultSkillList == null){
                DefaultSkillList = new Dictionary();
                _local2 = 0;
                _local3 = 6;
                while (_local2 < _local3) {
                    _local4 = new SkillInfo();
                    _local4.Id = 0;
                    _local4.description = LanguageMgr.GetTranslation("普通攻击");
                    _local4.SkillMode = SkillInfo.SPELL_CATEGORY_NULL;
                    _local4.Name = LanguageMgr.GetTranslation("普攻");
                    DefaultSkillList[_local2] = _local4;
                    _local2++;
                };
                DefaultSkillList[0].Distance = 2;
                DefaultSkillList[0].Effect = "";
                DefaultSkillList[0].HitEffect = "1H";
                DefaultSkillList[0].SkillMode = SkillInfo.SPELL_CATEGORY_MELEEATTACK;
                DefaultSkillList[1].Distance = 2;
                DefaultSkillList[1].Effect = "";
                DefaultSkillList[1].HitEffect = "1H";
                DefaultSkillList[1].SkillMode = SkillInfo.SPELL_CATEGORY_MELEEATTACK;
                DefaultSkillList[2].HitEffect = "2H";
                DefaultSkillList[2].Effect = "2";
                DefaultSkillList[2].Distance = 7;
                DefaultSkillList[2].SkillMode = SkillInfo.SPELL_CATEGORY_REMOTEATTACK;
                DefaultSkillList[3].HitEffect = "3H";
                DefaultSkillList[3].Effect = "3";
                DefaultSkillList[3].Distance = 7;
                DefaultSkillList[3].SkillMode = SkillInfo.SPELL_CATEGORY_REMOTEATTACK;
                DefaultSkillList[4].Distance = 2;
                DefaultSkillList[4].SkillMode = SkillInfo.SPELL_CATEGORY_MELEEATTACK;
                DefaultSkillList[4].Effect = "";
                DefaultSkillList[4].HitEffect = "4H";
                DefaultSkillList[5].Effect = "5";
                DefaultSkillList[5].HitEffect = "5H";
                DefaultSkillList[5].Distance = 7;
                DefaultSkillList[5].SkillMode = SkillInfo.SPELL_CATEGORY_REMOTEATTACK;
            };
            return (DefaultSkillList[_arg1.Role.CurrentJobID]);
        }
        public static function clearSkillLayer(_arg1:int):void{
            var _local5:int;
            var _local2:Array = SkillManager.MySkillListId;
            var _local3:int = (_local2.length - 1);
            var _local4:int = _local3;
            while (_local4 >= 0) {
                _local5 = (int((_local2[_local4] / 10000)) % 10);
                if (_local5 == _arg1){
                    _local2.splice(_local4, 1);
                };
                _local4--;
            };
        }
        public static function IsfirstNewSkill(_arg1:int):Boolean{
            if ((((((((((_arg1 == 110101)) || ((_arg1 == 210101)))) || ((_arg1 == 310101)))) || ((_arg1 == 410101)))) || ((_arg1 == 510101)))){
                return (true);
            };
            return (false);
        }
        public static function getSkillInfo(_arg1:int, _arg2:int, _arg3:int, _arg4:int=1):SkillInfo{
            var _local5:Array;
            _local5 = SkillManager.AllSkillList[_arg1];
            if (_local5 == null){
                return (null);
            };
            var _local6:uint;
            while (_local6 < _local5.length) {
                if (_local5[_local6].JobLevel == _arg2){
                    if (_local5[_local6].Index == _arg3){
                        if (_local5[_local6].Level == _arg4){
                            return (_local5[_local6]);
                        };
                    };
                };
                _local6++;
            };
            return (null);
        }
        public static function CanDragSkill(_arg1:SkillInfo){
            if (_arg1.Type == SkillInfo.ATTRIBUTES_PASSIVE){
                return (false);
            };
            return (true);
        }
        public static function ClearAllMySkill():void{
            var _local4:int;
            var _local1:Array = SkillManager.MySkillListId;
            var _local2:int = (_local1.length - 1);
            var _local3:int = _local2;
            while (_local3 >= 0) {
                _local4 = int((_local1[_local3] / 100000));
                if (_local4 != 9){
                    _local1.splice(_local3, 1);
                };
                _local3--;
            };
        }

    }
}//package Manager 
