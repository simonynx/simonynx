//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.CSBattle.Data {
    import GameUI.ConstData.*;
    import GameUI.Modules.CSBattle.vo.*;
    import Utils.*;

    public class CSBattleData {

        public static const MinLevel:int = 55;

        public static var CsbRewardItemList:Array = [];
        public static var CsbIsOpen:Boolean = false;
        public static var SelfPlatRankId:int = -1;
        public static var PlatId:int = 0;
        public static var AllPlatRankId:int = -1;
        public static var CsbTeamRankList:Array;
        public static var ServerId:int = 0;

        public static function AnalyzeXml_CsbRewardItem(_arg1:XML):void{
            var _local2:XML;
            var _local3:CSBattleRewardItemInfo;
            CsbRewardItemList = [];
            for each (_local2 in _arg1.record) {
                _local3 = new CSBattleRewardItemInfo();
                _local3.RewardId = _local2.@Id;
                _local3.TemplateID = _local2.@item_id;
                ClassFactory.copyProperties(UIConstData.ItemDic[_local3.TemplateID], _local3);
                _local3.ReqCSBLevel = _local2.@need_repute;
                _local3.ReqPlayerLevel = _local2.@need_player_lv;
                _local3.Count = _local2.@item_count;
                _local3.ReqCSBPoint = _local2.@cost_point;
                _local3.ReqGold = _local2.@cost_gold;
                _local3.ReqMoney = _local2.@cost_cash;
                _local3.SortIdx = _local2.@visible_rank;
                _local3.ReqJob = _local2.@need_career;
                _local3.ReqSex = _local2.@need_gender;
                if (UIConstData.ItemDic[_local3.TemplateID]){
                    CsbRewardItemList.push(_local3);
                };
            };
            CsbRewardItemList = CsbRewardItemList.sortOn("SortIdx", Array.NUMERIC);
        }
        public static function GetRewardItemByRewardid(_arg1:int):CSBattleRewardItemInfo{
            var _local2:int;
            var _local3:int = CsbRewardItemList.length;
            while (_local2 < _local3) {
                if (CsbRewardItemList[_local2].RewardId == _arg1){
                    return (CsbRewardItemList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public static function GetBattleTitle(_arg1:int):String{
            var _local2:int;
            if (_arg1 < 1000){
                _local2 = 9;
            } else {
                if (_arg1 < 1200){
                    _local2 = 8;
                } else {
                    if (_arg1 < 1400){
                        _local2 = 7;
                    } else {
                        if (_arg1 < 1600){
                            _local2 = 6;
                        } else {
                            if (_arg1 < 1800){
                                _local2 = 5;
                            } else {
                                if (_arg1 < 2000){
                                    _local2 = 4;
                                } else {
                                    if (_arg1 < 2200){
                                        _local2 = 3;
                                    } else {
                                        if (_arg1 < 2400){
                                            _local2 = 2;
                                        } else {
                                            if (_arg1 < 2600){
                                                _local2 = 1;
                                            } else {
                                                _local2 = 0;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (LanguageMgr.GetTranslation(("战斗称号" + _local2)));
        }

    }
}//package GameUI.Modules.CSBattle.Data 
