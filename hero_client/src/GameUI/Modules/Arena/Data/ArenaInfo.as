//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Arena.Data {
    import flash.utils.*;

    public class ArenaInfo {

        public static var SelfArenaInfo:ArenaInfo = new (ArenaInfo)();
;
        public static var KillOrBeKillList:Dictionary = new Dictionary();
        public static var winTeam:int;

        public var killThisCount:int;
        public var level:int;
        public var name:String;
        public var todayCount:int;
        public var count:int;
        public var isActive:Boolean;
        public var killCount:int;
        public var winCount:int;
        public var sociaty:String;
        public var lianxuKill:int;
        public var beKilledCount:int;
        public var totalCount:int;
        public var team:int;
        public var totalKillCount:int;
        public var exp:int;
        private var _job:String = "无";

        public function set jobName(_arg1:int):void{
            if (_arg1 == 0){
                _job = "";
            } else {
                if (_arg1 == 1){
                    _job = LanguageMgr.GetTranslation("职业1");
                } else {
                    if (_arg1 == 2){
                        _job = LanguageMgr.GetTranslation("职业2");
                    } else {
                        if (_arg1 == 3){
                            _job = LanguageMgr.GetTranslation("职业3");
                        } else {
                            if (_arg1 == 4){
                                _job = LanguageMgr.GetTranslation("职业4");
                            } else {
                                if (_arg1 == 5){
                                    _job = LanguageMgr.GetTranslation("职业5");
                                };
                            };
                        };
                    };
                };
            };
        }
        public function get job():String{
            if (_job == "无"){
                _job = LanguageMgr.GetTranslation("无");
            };
            return (_job);
        }

    }
}//package GameUI.Modules.Arena.Data 
