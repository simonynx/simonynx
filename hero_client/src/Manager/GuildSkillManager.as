//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.Modules.HeroSkill.SkillConst.*;

    public class GuildSkillManager {

        private static var _instance:GuildSkillManager;

        public static function getInstance():GuildSkillManager{
            if (_instance == null){
                _instance = new (GuildSkillManager)();
            };
            return (_instance);
        }

        public function analyseGuildSkill(_arg1:XML):void{
            var _local3:int;
            var _local4:int;
            var _local16:XML;
            var _local2:GuildSkillInfo = new GuildSkillInfo();
            var _local5:int;
            var _local6:Array = [];
            var _local7:Array = [];
            var _local8:Array = [];
            var _local9:Array = [];
            var _local10:Array = [];
            var _local11 = "";
            var _local12 = "";
            var _local13:Array = [];
            var _local14:Array = [];
            var _local15 = "";
            for each (_local16 in _arg1.elements()) {
                _local4 = _local16.@Id;
                _local3 = _local16.@max_level;
                _local12 = _local16.@content;
                _local6 = _local16.@need_lv.split(",");
                _local7 = _local16.@need_construct_val.split(",");
                _local8 = _local16.@cost_value.split(",");
                _local9 = _local16.@aura_id.split(",");
                _local10 = _local16.@cd_time.split(",");
                _local11 = _local16.@name;
                _local13 = _local12.split("&")[0].split(",");
                _local14 = _local12.split("&")[1].split(",");
                _local5 = 0;
                while (_local5 < _local3) {
                    _local2 = new GuildSkillInfo();
                    _local2.Id = ((_local4 * 100) + (_local5 + 1));
                    _local2.Level = (_local5 + 1);
                    _local2.TypeID = _local4;
                    _local2.MaxLevel = _local3;
                    _local2.Name = _local11;
                    _local15 = _local16.@discription;
                    _local2.description = _local15.replace(/\*/i, _local13[_local5]).replace(/\*/i, _local14[_local5]);
                    _local2.NeedLevel = _local6[_local5];
                    _local2.NeedOffer = _local7[_local5];
                    _local2.CostOffer = _local8[_local5];
                    _local2.CoolTime = _local10[_local5];
                    _local2.buffId = _local9[_local5];
                    GameCommonData.GuildSkillsList[_local2.Id] = _local2;
                    _local5++;
                };
                _local2 = new GuildSkillInfo();
                _local2.Id = ((_local4 * 100) + 0);
                _local2.Level = 0;
                _local2.TypeID = _local4;
                _local2.MaxLevel = _local3;
                _local2.Name = _local11;
                _local15 = _local16.@discription;
                _local2.description = _local15.replace(/\*/gi, 0);
                _local2.NeedLevel = 0;
                _local2.NeedOffer = 0;
                _local2.CostOffer = 0;
                _local2.CoolTime = 0;
                _local2.buffId = 0;
                GameCommonData.GuildSkillsList[_local2.Id] = _local2;
            };
        }
        public function getNextGuildSkill(_arg1:int):GuildSkillInfo{
            if (GameCommonData.GuildSkillsList[(_arg1 + 1)]){
                return (GameCommonData.GuildSkillsList[(_arg1 + 1)]);
            };
            return (null);
        }
        public function getCurrentSkillByType(_arg1:int):GuildSkillInfo{
            var _local2:String;
            var _local3:GuildSkillInfo;
            var _local4:GuildSkillInfo;
            var _local5:GuildSkillInfo;
            var _local6:int;
            for (_local2 in GameCommonData.GuildSkillsList) {
                _local3 = GameCommonData.GuildSkillsList[_local2];
                if (int((_local3.Id / 100)) == _arg1){
                    if (_local3.Level == 0){
                        _local5 = _local3;
                    };
                    if ((((_local3.Level > _local6)) && (_local3.isLearn))){
                        _local6 = _local3.Level;
                        _local4 = _local3;
                    };
                };
            };
            if (_local4 == null){
                _local4 = _local5;
            };
            return (_local4);
        }

    }
}//package Manager 
