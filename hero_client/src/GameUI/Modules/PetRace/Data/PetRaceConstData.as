//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PetRace.Data {
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.RoleProperty.Datas.*;

    public class PetRaceConstData {

        public static const PF_REDEPLOY_MOVE_TO_GROUP1:uint = 1;
        public static const PF_REDEPLOY_MOVE_TO_GROUP2:uint = 2;
        public static const PF_REDEPLOY_MOVE_TO_GROUP3:uint = 3;
        public static const PF_REDEPLOY_UNDO_PET:uint = 0;

        public static var txt_score:String = "---";
        public static var labelArr1:Array = ["第1名", "第2名", "第3名", "第4-10名", "第11-20名", "第21-30名"];
        public static var labelArr2:Array = ["冠军", "亚军", "4强", "8强", "16强"];
        public static var outFormation:uint = 0;
        public static var simpleReportDic:Dictionary = new Dictionary();
        public static var seasonIdQuery:uint = 0;
        public static var raceStatus:uint;
        public static var currStageId:uint = 0;
        public static var seasonList:Dictionary = new Dictionary();
        public static var allLastReportList:Dictionary = new Dictionary();
        public static var CURR_REPORT_PAGE:uint = 0;
        public static var randomFormation:Boolean = false;
        public static var yearSeasonList:Array = [];
        public static var TOTAL_TEAM_NUM:uint = 1;
        public static var raceLoseList:Array = ["*的宠物没有参加比赛", "*体力不支倒下了", "*倒在地下，回天无力", "*不甘心地倒下了", "*感觉脑袋一黑，倒在地上不省人事了", "*口吐白沫倒下了"];
        public static var resultList:Array = [];
        public static var allTeamList:Array = [[]];
        public static var CURR_TEAM_PAGE:uint = 0;
        public static var txt_ranking:String = "---";
        public static var defensePlayerName:String;
        public static var hasSignUp:Boolean = false;
        public static var allReportList:Dictionary = new Dictionary();
        public static var petList1:Array = [[], [], []];
        public static var petList2:Array = [[], [], []];
        public static var petList3:Array = [[], [], []];
        public static var yearList:Array = [];
        public static var winnerList:Array = [[], [], [], [], []];
        public static var attackPlayerName:String;
        public static var myRanking1:String = "---";
        public static var teamName:String = "---";
        public static var txt_win:String = "---";
        public static var targetRacingInfo:PetRacingInfo = new PetRacingInfo();
        public static var hasRequest:Boolean = false;
        public static var selectWaitFlag:Boolean = false;
        public static var myRanking2:String = "---";
        public static var sideReportList1:Dictionary = new Dictionary();
        public static var sideReportList2:Dictionary = new Dictionary();
        public static var selfRacingInfo:PetRacingInfo = new PetRacingInfo();
        public static var teamChangeList:Array = [];
        public static var currSeasonId:uint = 0;
        public static var teamChangeFlagList:Array = [];
        public static var canDefyTeamList:Array = [];
        public static var TOTAL_REPORT_NUM:uint = 1;
        public static var formationList:Array = [[1, 0, 0], [0, 1, 0], [0, 1, 1], [1, 0, 1]];
        public static var delayTime:uint = 2000;
        public static var raceTimes:uint = 0;

        public static function getDefInfo():PetRacingInfo{
            if (selfRacingInfo.MasterName == attackPlayerName){
                return (targetRacingInfo);
            };
            return (selfRacingInfo);
        }
        public static function updateTeamChanges(_arg1:Array, _arg2:uint, _arg3:uint):void{
            teamChangeList = [];
            teamChangeFlagList = [];
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:Array = getTeamPetList(_arg2, _arg3);
            _local5 = 0;
            while (_local5 < _arg1.length) {
                _local6 = 0;
                while (_local6 < _local7.length) {
                    if (_arg1[_local5].ItemGUID == _local7[_local6].ItemGUID){
                        break;
                    };
                    _local6++;
                };
                if (_local6 == _local7.length){
                    teamChangeList.push(_arg1[_local5].ItemGUID);
                    teamChangeFlagList.push(true);
                };
                _local5++;
            };
            _local5 = 0;
            while (_local5 < _local7.length) {
                _local6 = 0;
                while (_local6 < _arg1.length) {
                    if (_local7[_local5].ItemGUID == _arg1[_local6].ItemGUID){
                        break;
                    };
                    _local6++;
                };
                if (_local6 == _arg1.length){
                    teamChangeList.push(_local7[_local5].PetInfo.petguid);
                    teamChangeFlagList.push(false);
                };
                _local5++;
            };
        }
        public static function getTeamPetList(_arg1:uint, _arg2:uint):Array{
            if (_arg1 == 0){
                return (petList1[_arg2]);
            };
            if (_arg1 == 1){
                return (petList2[_arg2]);
            };
            return (petList3[_arg2]);
        }
        public static function getFormationValue(_arg1:Array):uint{
            var _local2:uint = (((_arg1[0][0] * 1) + (_arg1[0][1] * 2)) + (_arg1[0][2] * 4));
            var _local3:uint = (((_arg1[1][0] * 1) + (_arg1[1][1] * 2)) + (_arg1[1][2] * 4));
            var _local4:uint = (((_arg1[2][0] * 1) + (_arg1[2][1] * 2)) + (_arg1[2][2] * 4));
            var _local5:uint = (((_arg1[3][0] * 1) + (_arg1[3][1] * 2)) + (_arg1[3][2] * 4));
            var _local6:uint = (((_local2 + (_local3 << 8)) + (_local4 << 16)) + (_local5 << 24));
            return (_local6);
        }
        public static function resetStatus():void{
            if (PetRaceConstData.raceStatus == 0){
                PetRaceConstData.myRanking1 = "---";
                PetRaceConstData.myRanking2 = "---";
                PetRaceConstData.allReportList[currSeasonId] = [];
                PetRaceConstData.allLastReportList[currSeasonId] = [];
                PetRaceConstData.winnerList = [[], [], [], [], []];
            };
        }
        public static function parseFormation(_arg1:uint):void{
            var _local2:uint = (_arg1 & 0xFF);
            var _local3:uint = ((_arg1 & 0xFF00) >> 8);
            var _local4:uint = ((_arg1 & 0xFF0000) >> 16);
            var _local5:uint = ((_arg1 & 4278190080) >> 24);
            formationList[0] = [(_local2 & 1), ((_local2 >> 1) & 1), ((_local2 >> 2) & 1)];
            formationList[1] = [(_local3 & 1), ((_local3 >> 1) & 1), ((_local3 >> 2) & 1)];
            formationList[2] = [(_local4 & 1), ((_local4 >> 1) & 1), ((_local4 >> 2) & 1)];
            formationList[3] = [(_local5 & 1), ((_local5 >> 1) & 1), ((_local5 >> 2) & 1)];
        }
        public static function getTotalRankingStr(_arg1:uint):String{
            var _local2 = "";
            if (_arg1 == 1){
                _local2 = LanguageMgr.GetTranslation("冠军");
            } else {
                if (_arg1 == 2){
                    _local2 = LanguageMgr.GetTranslation("亚军");
                } else {
                    if (_arg1 <= 4){
                        _local2 = LanguageMgr.GetTranslation("四强");
                    } else {
                        if (_arg1 <= 8){
                            _local2 = LanguageMgr.GetTranslation("八强");
                        } else {
                            _local2 = LanguageMgr.GetTranslation("十六强");
                        };
                    };
                };
            };
            return (_local2);
        }
        public static function getPetList(_arg1:uint):Array{
            if (_arg1 == 0){
                return (petList1);
            };
            if (_arg1 == 1){
                return (petList2);
            };
            return (petList3);
        }
        public static function clearPetList(_arg1:uint):void{
            if (_arg1 == 0){
                petList1 = [[], [], []];
            } else {
                if (_arg1 == 1){
                    petList2 = [[], [], []];
                } else {
                    petList3 = [[], [], []];
                };
            };
        }
        public static function findPetInFormationById(_arg1:uint):InventoryItemInfo{
            var _local2:InventoryItemInfo;
            var _local6:Array;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            _local3 = 0;
            while (_local3 < 3) {
                _local4 = 0;
                while (_local4 < 3) {
                    _local6 = getTeamPetList(_local3, _local4);
                    _local5 = 0;
                    while (_local5 < _local6.length) {
                        if (_local6[_local5].ItemGUID == _arg1){
                            return (_local6[_local5]);
                        };
                        _local5++;
                    };
                    _local4++;
                };
                _local3++;
            };
            return (null);
        }
        public static function getAllPetList():Array{
            var _local3:InventoryItemInfo;
            var _local1:Array = [];
            var _local2:uint;
            _local2 = 0;
            while (_local2 < BagData.AllItems[0].length) {
                _local3 = BagData.AllItems[0][_local2];
                if (((_local3) && ((((_local3.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_local3.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))){
                    _local1.push(_local3);
                };
                _local2++;
            };
            _local2 = ItemConst.EQUIPMENT_SLOT_PET0;
            while (_local2 <= ItemConst.EQUIPMENT_SLOT_PET_END) {
                if (RolePropDatas.ItemList[_local2]){
                    _local1.push(RolePropDatas.ItemList[_local2]);
                };
                _local2++;
            };
            return (_local1);
        }
        public static function removeOnePet(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:Array = getTeamPetList(_arg1, _arg2);
            var _local5:uint;
            _local5 = 0;
            while (_local5 < _local4.length) {
                if (_local4[_local5].PetInfo.petguid == _arg3){
                    _local4.splice(_local5, 1);
                    break;
                };
                _local5++;
            };
        }
        public static function findPetById(_arg1:uint):InventoryItemInfo{
            var _local2:InventoryItemInfo;
            var _local3:uint;
            _local3 = 0;
            while (_local3 < BagData.AllItems[0].length) {
                _local2 = BagData.AllItems[0][_local3];
                if (((_local2) && ((((_local2.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_local2.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))){
                    if (_local2.ItemGUID == _arg1){
                        return (_local2);
                    };
                };
                _local3++;
            };
            _local3 = ItemConst.EQUIPMENT_SLOT_PET0;
            while (_local3 <= ItemConst.EQUIPMENT_SLOT_PET_END) {
                _local2 = RolePropDatas.ItemList[_local3];
                if (((_local2) && ((_local2.ItemGUID == _arg1)))){
                    return (_local2);
                };
                _local3++;
            };
            return (null);
        }
        public static function clearTeamPetList(_arg1:uint, _arg2:uint):void{
            if (_arg1 == 0){
                petList1[_arg2] = [];
            } else {
                if (_arg1 == 1){
                    petList2[_arg2] = [];
                } else {
                    petList3[_arg2] = [];
                };
            };
        }
        public static function getAttInfo():PetRacingInfo{
            if (selfRacingInfo.MasterName == attackPlayerName){
                return (selfRacingInfo);
            };
            return (targetRacingInfo);
        }
        public static function getCanDefyTeamById(_arg1:int):PetRacePlayerInfo{
            var _local2:int;
            while (_local2 < canDefyTeamList.length) {
                if (_arg1 == canDefyTeamList[_local2].PlayerId){
                    return (canDefyTeamList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public static function getNameByReportId(_arg1:uint, _arg2:uint):String{
            var _local4:uint;
            var _local5:PetReportRef;
            var _local6:uint;
            var _local7:PetReportInfo;
            var _local3 = "";
            for each (_local4 in yearSeasonList) {
                _local5 = simpleReportDic[String(_local4)];
                if (_local5){
                    _local6 = 0;
                    _local6 = 0;
                    while (_local6 < _local5.list.length) {
                        _local7 = (_local5.list[_local6] as PetReportInfo);
                        if (_local7.ReportId == _arg1){
                            if (_arg2 == 0){
                                return (_local7.AttackName);
                            };
                            return (_local7.DefenseName);
                        };
                        _local6++;
                    };
                };
            };
            return (_local3);
        }
        public static function addOnePet(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):void{
            var _local5:InventoryItemInfo = PetRaceConstData.findPetById(_arg3);
            if (_local5){
                _local5.PetInfo.petguid = _arg4;
                getTeamPetList(_arg1, _arg2).push(_local5);
            };
        }

    }
}//package GameUI.Modules.PetRace.Data 
