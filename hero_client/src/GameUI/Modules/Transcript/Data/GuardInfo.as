//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Transcript.Data {
    import flash.utils.*;
    import Manager.*;

    public class GuardInfo {

        private static const sGuardianExpAddtionStage:Array = [3, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 1, 2, 2, 3, 3, 3, 1, 2, 2, 3, 3];

        public static var selfGuardInfo:GuardInfo;
        public static var GuardRewardOne:Array = [50200078, 50200080, 50200082, 50200084, 50200086, 50200088, 50200090, 50200092, 50200094, 50200096];
        public static var GuardRewardTwo:Array = [50200079, 50200081, 50200083, 50200085, 50200087, 50200089, 50200091, 50200093, 50200095, 50200097];
        public static var dic:Dictionary;

        public var level:int;
        public var sex:int;
        public var layer:int;
        public var playerName:String;
        public var guradTime:uint;
        public var faceId:int;
        public var playerId:int;

        public static function leftTime():String{
            var _local3:int;
            var _local5:String;
            var _local6:int;
            var _local7:int;
            var _local1:int = TimeManager.Instance.ServerData().getHours();
            var _local2:int = TimeManager.Instance.ServerData().getMinutes();
            var _local4 = 3;
            if (_local2 == 0){
                _local2 = 1;
            };
            while (_local3 < _local4) {
                if ((((_local1 >= (7 + (_local3 * 6)))) && ((_local1 < (8 + (_local3 * 6)))))){
                    _local6 = 0;
                    _local7 = (60 - _local2);
                } else {
                    if ((((_local1 >= (8 + (_local3 * 6)))) && ((_local1 < (10 + (_local3 * 6)))))){
                        _local6 = ((9 + (_local3 * 6)) - _local1);
                        _local7 = (60 - _local2);
                    } else {
                        if ((((_local1 >= (10 + (_local3 * 6)))) && ((_local1 < (13 + (_local3 * 6)))))){
                            _local6 = ((12 + (_local3 * 6)) - _local1);
                            _local7 = (60 - _local2);
                        };
                    };
                };
                _local3++;
            };
            if (_local7 < 10){
                _local5 = ((((("0" + _local6) + LanguageMgr.GetTranslation("小时")) + "0") + _local7) + LanguageMgr.GetTranslation("分"));
            } else {
                _local5 = (((("0" + _local6) + LanguageMgr.GetTranslation("小时")) + _local7) + LanguageMgr.GetTranslation("分"));
            };
            return (_local5);
        }
        public static function getExp():int{
            var _local1:int = TimeManager.Instance.ServerData().getHours();
            return (sGuardianExpAddtionStage[_local1]);
        }
        public static function inWhatSection():int{
            var _local7:int;
            var _local1 = 1;
            var _local2 = 2;
            var _local3 = 3;
            var _local4 = 4;
            var _local5 = 5;
            var _local6:int = TimeManager.Instance.ServerData().getHours();
            var _local8 = 3;
            if ((((_local6 >= 21)) && ((_local6 < 22)))){
                return (_local4);
            };
            while (_local7 < _local8) {
                if ((((_local6 >= (7 + (_local7 * 6)))) && ((_local6 < (8 + (_local7 * 6)))))){
                    return (_local1);
                };
                if ((((_local6 >= (8 + (_local7 * 6)))) && ((_local6 < (10 + (_local7 * 6)))))){
                    return (_local2);
                };
                if ((((_local6 >= (10 + (_local7 * 6)))) && ((_local6 < (13 + (_local7 * 6)))))){
                    return (_local3);
                };
                _local7++;
            };
            if ((((_local6 >= 1)) && ((_local6 < 7)))){
                return (_local5);
            };
            return (0);
        }

    }
}//package GameUI.Modules.Transcript.Data 
