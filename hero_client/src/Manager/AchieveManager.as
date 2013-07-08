//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.Achieve.Data.*;

    public class AchieveManager {

        private static var _instance:AchieveManager;

        public static function getInstance():AchieveManager{
            if (_instance == null){
                _instance = new (AchieveManager)();
            };
            return (_instance);
        }

        public function getIsCompleteCntByType(_arg1:int=-1, _arg2:int=-1):int{
            var _local4:AchieveInfo;
            var _local3:int;
            for each (_local4 in GameCommonData.AchieveDic) {
                if (((((!((_arg1 == -1))) && ((_local4.MainClass == _arg1)))) || ((_arg1 == -1)))){
                    if (((((!((_arg2 == -1))) && ((_local4.SubClass == _arg2)))) || ((_arg2 == -1)))){
                        if (_local4.IsComplete){
                            _local3++;
                        };
                    };
                };
            };
            return (_local3);
        }
        public function getTotalPoint(_arg1:int=-1):int{
            var _local3:String;
            var _local2:int;
            for (_local3 in GameCommonData.AchieveDic) {
                if (GameCommonData.AchieveDic[_local3]){
                    if ((((_arg1 > -1)) && (!((GameCommonData.AchieveDic[_local3].MainClass == _arg1))))){
                    } else {
                        _local2 = (_local2 + GameCommonData.AchieveDic[_local3].AchievePoint);
                    };
                };
            };
            return (_local2);
        }
        public function getAchieveListByMainType(_arg1:int):Array{
            var _local2:Array = AchieveConstData.AchieveClassArr[_arg1];
            var _local3:Array = [];
            var _local4:int;
            while (_local4 < _local2.length) {
                _local3 = _local3.concat(AchieveConstData.AchieveClassArr[_arg1][_local4]);
                _local4++;
            };
            return (_local3);
        }
        public function AnalyzeXml_Title(_arg1:XML):void{
            var _local2:XML;
            var _local3:TitleInfo;
            for each (_local2 in _arg1.record) {
                _local3 = new TitleInfo();
                _local3.Id = _local2.@Id;
                _local3.Name = _local2.@Name;
                _local3.Type = _local2.@type;
                GameCommonData.TitleDic[_local3.Id] = _local3;
            };
        }
        public function setPlayerTitle(_arg1:int, _arg2:GameElementAnimal):void{
            var _local3:TitleInfo = GameCommonData.TitleDic[_arg1];
            if (_local3){
                _arg2.Role.Title = _local3.Name;
                _arg2.SetTitle(_arg2.Role.Title);
            };
        }
        public function AnalyzeXml_Achieve(_arg1:XML):void{
            var _local3:XML;
            var _local4:AchieveInfo;
            var _local5:int;
            var _local2:int;
            while (_local2 < LanguageMgr.AchieveMainClassDef.length) {
                AchieveConstData.AchieveClassArr[_local2] = [];
                _local5 = 0;
                while (_local5 < LanguageMgr.AchieveSubClassDef.length) {
                    AchieveConstData.AchieveClassArr[_local2][_local5] = [];
                    _local5++;
                };
                _local2++;
            };
            for each (_local3 in _arg1.record) {
                _local4 = new AchieveInfo();
                _local4.Id = _local3.@ID;
                _local4.MainClass = ((int(_local3.@position) / 10000) - 1);
                _local4.SubClass = (((int(_local3.@position) % 10000) / 100) - 1);
                _local4.Des = String(_local3.@describe);
                _local4.Name = String(_local3.@name);
                _local4.TitleId = int(_local3.@index);
                _local4.AchievePoint = int(_local3.@grade);
                _local4.TargetProgress = int(_local3.@progress);
                _local4.SortId = (int(_local3.@position) % 100);
                if ((((_local4.MainClass >= 0)) && ((_local4.SubClass >= 0)))){
                    GameCommonData.AchieveDic[_local4.Id] = _local4;
                    if (((AchieveConstData.AchieveClassArr[_local4.MainClass]) && (AchieveConstData.AchieveClassArr[_local4.MainClass][_local4.SubClass]))){
                        AchieveConstData.AchieveClassArr[_local4.MainClass][_local4.SubClass].push(_local4);
                    };
                };
            };
        }
        public function getTotalRecPoint(_arg1:int=-1):int{
            var _local3:String;
            var _local2:int;
            for (_local3 in GameCommonData.AchieveDic) {
                if (((GameCommonData.AchieveDic[_local3]) && ((GameCommonData.AchieveDic[_local3].CompleteTime > 0)))){
                    if ((((_arg1 > -1)) && (!((GameCommonData.AchieveDic[_local3].MainClass == _arg1))))){
                    } else {
                        _local2 = (_local2 + GameCommonData.AchieveDic[_local3].AchievePoint);
                    };
                };
            };
            return (_local2);
        }

    }
}//package Manager 
