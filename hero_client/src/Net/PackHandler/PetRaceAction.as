//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.PetRace.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.NewGuide.Command.*;

    public class PetRaceAction extends GameAction {

        private static const SPF_INFOS_RANK_LIST:uint = 5;
        private static const SPF_INFOS_HISTORY_REPORTS:uint = 15;
        private static const SPF_INFOS_SEASON_HISTORY_RANGE:uint = 17;
        private static const SPF_INFOS_FINAL_DUEL_LIST:uint = 9;
        private static const SPFO_CHANGE_TEAM_NAME:uint = 3;
        private static const SPFO_REDEPLOY_FORMATION:uint = 7;
        private static const SPF_INFOS_TOTAL_RANK_LIST:uint = 7;
        private static const SPFO_FORMATION_SETTING:uint = 5;
        private static const SPFO_CHALLENGE:uint = 9;
        private static const SPF_INFOS_SIMPLE_REPORT_CONTENT:uint = 11;
        private static const SPF_INFOS_CUR_STAGE:uint = 13;
        private static const RaceResultObj:Object = {
            0:"挑战成功，等待具体战报",
            1:"淘汰赛结束后才能开始挑战",
            2:"目标不存在",
            3:"今日挑战次数已满",
            4:"刚刚战斗完,请休息一会再打",
            5:"目标队伍正在挑战中",
            6:"排名相差太远,请重新打开页面刷新"
        };
        private static const SPF_INFOS_CHALLENGE_LIST:uint = 3;
        private static const SPFO_APPLY:uint = 1;
        private static const SPF_INFOS_SELFTEAM:uint = 1;

        private static var _instance:PetRaceAction;

        public function PetRaceAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():PetRaceAction{
            if (!_instance){
                _instance = new (PetRaceAction)();
            };
            return (_instance);
        }

        private function ChallengeResult(_arg1:NetPacket):void{
            var _local3:uint;
            var _local2:uint = _arg1.readByte();
            if (_local2 == 4){
                if (PetRacingBattle.IsRacing()){
                    MessageTip.popup(LanguageMgr.GetTranslation("已方队伍正在挑战当中"));
                } else {
                    MessageTip.popup(LanguageMgr.RaceResultObj[String(_local2)]);
                };
            } else {
                MessageTip.popup(LanguageMgr.RaceResultObj[String(_local2)]);
                if (_local2 == 6){
                    PetRaceSend.GetCanDefyList();
                };
            };
            if (_local2 == 0){
                _local3 = _arg1.readUnsignedInt();
                PetRaceConstData.raceTimes = _local3;
                facade.sendNotification(PetRaceEvent.UPDATE_PETRACE_TIMES);
            };
        }
        public function formationConfigChange(_arg1:NetPacket):void{
            PetRaceConstData.parseFormation(_arg1.readUnsignedInt());
            facade.sendNotification(PetRaceEvent.UPDATE_FORMATION_CONFIG);
            PetRaceConstData.randomFormation = _arg1.readBoolean();
            facade.sendNotification(PetRaceEvent.UPDATE_RANDOM_CONFIG);
            MessageTip.popup(LanguageMgr.GetTranslation("阵型配置成功"));
        }
        private function GetHistroySeason(_arg1:NetPacket):void{
            var _local4:uint;
            var _local5:String;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            _local3 = 0;
            while (_local3 < _local2) {
                _local4 = _arg1.readUnsignedInt();
                _local5 = String(_local4).substr(0, 4);
                if (PetRaceConstData.yearList.indexOf(_local5) == -1){
                    PetRaceConstData.yearList.push(_local5);
                };
                if (PetRaceConstData.seasonList[_local5] == null){
                    PetRaceConstData.seasonList[_local5] = new Array();
                };
                PetRaceConstData.seasonList[_local5].push(String(_local4).substr(4, 2));
                PetRaceConstData.yearSeasonList.push(_local4);
                if (_local3 == (_local2 - 1)){
                    PetRaceConstData.currSeasonId = _local4;
                };
                _local3++;
            };
        }
        private function PetBattleDetail(_arg1:NetPacket):void{
            var _local4:uint;
            if (BagData.hasGetItemProto == false){
                return;
            };
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            if (_local3 == GameCommonData.Player.Role.Id){
                PetRaceConstData.selfRacingInfo.ReadFromPacket(_arg1, _local3);
                _local4 = _arg1.readUnsignedInt();
                PetRaceConstData.targetRacingInfo.ReadFromPacket(_arg1, _local4);
                PetRaceConstData.attackPlayerName = PetRaceConstData.selfRacingInfo.MasterName;
                PetRaceConstData.defensePlayerName = PetRaceConstData.targetRacingInfo.MasterName;
            } else {
                PetRaceConstData.targetRacingInfo.ReadFromPacket(_arg1, _local3);
                _local4 = _arg1.readUnsignedInt();
                PetRaceConstData.selfRacingInfo.ReadFromPacket(_arg1, _local4);
                PetRaceConstData.defensePlayerName = PetRaceConstData.selfRacingInfo.MasterName;
                PetRaceConstData.attackPlayerName = PetRaceConstData.targetRacingInfo.MasterName;
            };
            PetRacingBattle.ReadFromPacket(_arg1);
            PetRacingBattle.startPetRacing();
            if (PetRaceConstData.raceStatus == 0){
                if (_local3 == GameCommonData.Player.Role.Id){
                    facade.sendNotification(PetRaceEvent.UPDATE_CHALLENGGE, {
                        type:1,
                        leftInfo:PetRaceConstData.selfRacingInfo,
                        rightInfo:PetRaceConstData.targetRacingInfo
                    });
                } else {
                    MessageTip.popup(LanguageMgr.GetTranslation("有人挑战你宠物"));
                    if (!(facade.retrieveProxy(DataProxy.NAME) as DataProxy).PetRaceIsOpen){
                        facade.sendNotification(PetRaceEvent.SHOW_PETRACE_FLASH);
                    } else {
                        facade.sendNotification(PetRaceEvent.UPDATE_CHALLENGGE, {type:0});
                    };
                };
            } else {
                if (PetRaceConstData.raceStatus == 2){
                    MessageTip.popup(LanguageMgr.GetTranslation("淘汰赛开打"));
                    if (!(facade.retrieveProxy(DataProxy.NAME) as DataProxy).PetRaceIsOpen){
                        facade.sendNotification(PetRaceEvent.SHOW_PETRACE_FLASH);
                    } else {
                        facade.sendNotification(PetRaceEvent.UPDATE_CHALLENGGE, {type:0});
                    };
                };
            };
        }
        public function getCanDefyTeamList(_arg1:NetPacket):void{
            var _local4:PetRacePlayerInfo;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            PetRaceConstData.canDefyTeamList = [];
            _local3 = 0;
            while (_local3 < _local2) {
                _local4 = new PetRacePlayerInfo();
                _local4.PlayerId = _arg1.readUnsignedInt();
                _local4.MasterName = _arg1.ReadString();
                _local4.TeamName = _arg1.ReadString();
                _local4.Ranking = _arg1.readUnsignedInt();
                _local4.WinRate = _arg1.readUnsignedInt();
                _local4.Score = _arg1.readInt();
                PetRaceConstData.canDefyTeamList.push(_local4);
                _local3++;
            };
            if (_local2 > 0){
                facade.sendNotification(PetRaceEvent.UPDATE_MEMBER_CANDEFY, PetRaceConstData.canDefyTeamList);
            };
        }
        private function UpdatePetRaceDeploy(_arg1:NetPacket):void{
            var _local5:uint;
            var _local6:Boolean;
            var _local7:uint;
            var _local8:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            while (_local5 < _local4) {
                _local6 = _arg1.readBoolean();
                _local7 = 0;
                if (_local6){
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readUnsignedInt();
                    PetRaceConstData.addOnePet(_local2, _local3, _local7, _local8);
                } else {
                    _local8 = _arg1.readUnsignedInt();
                    PetRaceConstData.removeOnePet(_local2, _local3, _local8);
                };
                _local5++;
            };
            facade.sendNotification(PetRaceEvent.UPDATE_PETRACE_DEPLOY, {
                dstFormation:_local2,
                dstTeam:_local3
            });
            MessageTip.popup(LanguageMgr.GetTranslation("队伍调配成功"));
            PetRaceConstData.selectWaitFlag = false;
        }
        private function getLastRankingList(_arg1:NetPacket):void{
            var _local6:PetRacePlayerInfo;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            PetRaceConstData.seasonIdQuery = _local2;
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local3 == 0){
                PetRaceConstData.allReportList[_local2] = [];
            } else {
                PetRaceConstData.allLastReportList[_local2] = [];
            };
            var _local5:uint;
            _local5 = 0;
            while (_local5 < _local4) {
                _local6 = new PetRacePlayerInfo();
                _local6.PlayerId = _arg1.readUnsignedInt();
                _local6.MasterName = _arg1.ReadString();
                _local6.Ranking = _arg1.readUnsignedInt();
                _local6.Score = _arg1.readUnsignedInt();
                if ((((_local2 == PetRaceConstData.currSeasonId)) && ((_local6.PlayerId == GameCommonData.Player.Role.Id)))){
                    if (_local3 == 0){
                        PetRaceConstData.myRanking1 = LanguageMgr.GetTranslation("第x名", _local6.Ranking);
                    } else {
                        PetRaceConstData.myRanking2 = PetRaceConstData.getTotalRankingStr(_local6.Ranking);
                    };
                };
                if (_local3 == 0){
                    PetRaceConstData.allReportList[_local2][_local5] = _local6;
                } else {
                    PetRaceConstData.allLastReportList[_local2][_local5] = _local6;
                };
                _local5++;
            };
            facade.sendNotification(PetRaceEvent.REFRESH_LAST_RANKING, _local3);
        }
        private function UpdatePetReDeploy(_arg1:NetPacket):void{
            var _local7:uint;
            var _local8:Array;
            var _local9:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:uint = _arg1.readUnsignedInt();
            var _local6:Boolean = _arg1.readBoolean();
            if (_local6){
                if (_local5 == 0){
                    PetRaceConstData.removeOnePet(_local2, _local3, _local4);
                    facade.sendNotification(PetRaceEvent.UPDATE_PETRACE_DEPLOY, {
                        dstFormation:_local2,
                        dstTeam:_local3
                    });
                } else {
                    _local7 = 0;
                    _local8 = PetRaceConstData.getTeamPetList(_local2, _local3);
                    _local7 = 0;
                    while (_local7 < _local8.length) {
                        if (_local8[_local7].PetInfo.petguid == _local4){
                            _local9 = _local8[_local7].ItemGUID;
                            break;
                        };
                        _local7++;
                    };
                    PetRaceConstData.addOnePet(_local2, (_local5 - 1), _local9, _local4);
                    facade.sendNotification(PetRaceEvent.UPDATE_PETRACE_DEPLOY, {
                        dstFormation:_local2,
                        dstTeam:(_local5 - 1)
                    });
                    PetRaceConstData.removeOnePet(_local2, _local3, _local4);
                    facade.sendNotification(PetRaceEvent.UPDATE_PETRACE_DEPLOY, {
                        dstFormation:_local2,
                        dstTeam:_local3
                    });
                };
            };
            PetRaceConstData.selectWaitFlag = false;
        }
        public function updateTeamName(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readByte();
            if (_local2 == 1){
                MessageTip.popup(LanguageMgr.GetTranslation("比赛不允许改名"));
            } else {
                if (_local2 == 0){
                    MessageTip.popup(LanguageMgr.GetTranslation("改名成功"));
                    PetRaceConstData.teamName = _arg1.ReadString();
                    facade.sendNotification(PetRaceEvent.RENAME_PET_TEAM);
                };
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local2:uint;
            var _local3:uint;
            var _local4:PetReportRef;
            var _local5:String;
            switch (_arg1.opcode){
                case Protocol.SMSG_PET_FIGHT_LIST_INFO:
                    _local2 = _arg1.readByte();
                    switch (_local2){
                        case SPF_INFOS_SELFTEAM:
                            updateTeamInfo(_arg1);
                            facade.sendNotification(Guide_PetRaceCommand.NAME, 4);
                            break;
                        case SPF_INFOS_CHALLENGE_LIST:
                            getCanDefyTeamList(_arg1);
                            break;
                        case SPF_INFOS_RANK_LIST:
                            getRankingList(_arg1);
                            break;
                        case SPF_INFOS_TOTAL_RANK_LIST:
                            getLastRankingList(_arg1);
                            break;
                        case SPF_INFOS_FINAL_DUEL_LIST:
                            getFinalDualList(_arg1);
                            break;
                        case SPF_INFOS_SIMPLE_REPORT_CONTENT:
                            getSimpleReport(_arg1);
                            break;
                        case SPF_INFOS_CUR_STAGE:
                            PetRaceConstData.raceStatus = _arg1.readUnsignedInt();
                            PetRaceConstData.resetStatus();
                            break;
                        case SPF_INFOS_HISTORY_REPORTS:
                            break;
                        case SPF_INFOS_SEASON_HISTORY_RANGE:
                            GetHistroySeason(_arg1);
                            break;
                    };
                    break;
                case Protocol.SMSG_PET_FIGHT_OPERATE_RESULT:
                    _local2 = _arg1.readByte();
                    switch (_local2){
                        case SPFO_APPLY:
                            signUpResult(_arg1);
                            break;
                        case SPFO_CHANGE_TEAM_NAME:
                            updateTeamName(_arg1);
                            break;
                        case SPFO_FORMATION_SETTING:
                            formationConfigChange(_arg1);
                            break;
                        case SPFO_REDEPLOY_FORMATION:
                            UpdatePetReDeploy(_arg1);
                            break;
                        case SPFO_CHALLENGE:
                            ChallengeResult(_arg1);
                            break;
                    };
                    break;
                case Protocol.SMSG_PET_FIGHT_DEPLOY_RESULT:
                    UpdatePetRaceDeploy(_arg1);
                    break;
                case Protocol.SMSG_PET_BATTLE_DETAIL:
                    PetBattleDetail(_arg1);
                    break;
                case Protocol.SMSG_SIMPLE_PET_BATTLEFIELD_REPORT:
                    _local3 = _arg1.readUnsignedInt();
                    if (_local3 > PetRaceConstData.currSeasonId){
                        PetRaceConstData.currSeasonId = _local3;
                    };
                    PetRaceConstData.seasonIdQuery = _local3;
                    _local5 = String(_local3);
                    if (PetRaceConstData.simpleReportDic[_local5]){
                        _local4 = PetRaceConstData.simpleReportDic[_local5];
                    } else {
                        _local4 = new PetReportRef();
                        PetRaceConstData.simpleReportDic[_local5] = _local4;
                    };
                    _local4.ReadFromPacket(_arg1, _local3);
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.UPDATE_RACE_REPORT);
                    break;
            };
        }
        private function updateTeamInfo(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local11:InventoryItemInfo;
            PetRaceConstData.raceStatus = _arg1.readUnsignedInt();
            PetRaceConstData.hasSignUp = _arg1.readBoolean();
            if (PetRaceConstData.hasSignUp){
                _local2 = _arg1.ReadString();
                PetRaceConstData.txt_win = (String(_arg1.readUnsignedInt()) + "%");
                PetRaceConstData.raceTimes = _arg1.readUnsignedInt();
                PetRaceConstData.txt_score = String(_arg1.readInt());
                PetRaceConstData.txt_ranking = String(_arg1.readUnsignedInt());
                PetRaceConstData.randomFormation = _arg1.readBoolean();
                _local3 = _arg1.readUnsignedInt();
                PetRaceConstData.parseFormation(_local3);
                _local4 = 0;
                _local5 = 0;
                _local6 = 0;
                _local7 = 0;
                _local4 = 0;
                while (_local4 < 3) {
                    _local5 = 0;
                    while (_local5 < 3) {
                        _local8 = _arg1.readUnsignedInt();
                        _local7 = 0;
                        _local6 = 0;
                        while (_local6 < _local8) {
                            _local9 = _arg1.readUnsignedInt();
                            _local10 = _arg1.readUnsignedInt();
                            _local11 = PetRaceConstData.findPetById(_local9);
                            if (_local11){
                                _local11.PetInfo.petguid = _local10;
                                PetRaceConstData.getPetList(_local4)[_local5][_local7] = _local11;
                                _local7++;
                            };
                            _local6++;
                        };
                        _local5++;
                    };
                    _local4++;
                };
                PetRaceConstData.teamName = _local2;
            };
            facade.sendNotification(PetRaceEvent.UPDATE_TEAM_INFO);
            PetRaceConstData.resetStatus();
        }
        public function signUpResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readByte();
            PetRaceConstData.hasSignUp = ((_local2)==0) ? true : false;
            if (_local2 == 0){
                facade.sendNotification(PetRaceEvent.SIGNUP_SUCESS);
                PetRaceSend.GetPetRaceRankingInfo(0);
            } else {
                if (_local2 == 1){
                    MessageTip.popup(LanguageMgr.GetTranslation("报名时间未到"));
                } else {
                    if (_local2 == 2){
                        MessageTip.popup(LanguageMgr.GetTranslation("等级不够"));
                    } else {
                        if (_local2 == 3){
                            MessageTip.popup(LanguageMgr.GetTranslation("其他原因无法报名"));
                        };
                    };
                };
            };
        }
        private function getFinalDualList(_arg1:NetPacket):void{
            var _local5:uint;
            var _local6:String;
            var _local7:uint;
            var _local8:String;
            var _local9:PetRacePlayerInfo;
            var _local10:PetRacePlayerInfo;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            PetRaceConstData.winnerList[(4 - _local2)] = [];
            var _local4:uint;
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = _arg1.readUnsignedInt();
                _local6 = "";
                if (_local5 != 4294967295){
                    _local9 = new PetRacePlayerInfo();
                    _local9.Face = _arg1.readUnsignedInt();
                    _local9.MasterName = _arg1.ReadString();
                    PetRaceConstData.winnerList[(4 - _local2)][(_local4 * 2)] = _local9;
                } else {
                    PetRaceConstData.winnerList[(4 - _local2)][(_local4 * 2)] = null;
                };
                if (_local2 == 4){
                    break;
                };
                _local7 = _arg1.readUnsignedInt();
                _local8 = "";
                if (_local7 != 4294967295){
                    _local10 = new PetRacePlayerInfo();
                    _local10.Face = _arg1.readUnsignedInt();
                    _local10.MasterName = _arg1.ReadString();
                    PetRaceConstData.winnerList[(4 - _local2)][((_local4 * 2) + 1)] = _local10;
                } else {
                    PetRaceConstData.winnerList[(4 - _local2)][((_local4 * 2) + 1)] = null;
                };
                _local4++;
            };
            facade.sendNotification(PetRaceEvent.REFRESH_WINNER_LIST);
        }
        public function renameResult(_arg1:NetPacket):void{
            var _local2:String = LanguageMgr.GetTranslation("新名字");
            UIFacade.GetInstance().sendNotification(PetRaceEvent.RENAME_PET_TEAM, _local2);
        }
        private function getSimpleReport(_arg1:NetPacket):void{
            var _local2:uint;
            var _local3:uint;
            if (BagData.hasGetItemProto == false){
                return;
            };
            var _local4:PetRacingInfo = new PetRacingInfo();
            var _local5:PetRacingInfo = new PetRacingInfo();
            _local4.reportId = (_local5.reportId = _arg1.readUnsignedInt());
            _local4.playerId = _arg1.readUnsignedInt();
            _local4.Face = _arg1.readUnsignedInt();
            _local4.Level = _arg1.readUnsignedInt();
            _local5.playerId = _arg1.readUnsignedInt();
            _local5.Face = _arg1.readUnsignedInt();
            _local5.Level = _arg1.readUnsignedInt();
            _local4.WinnerId = (_local5.WinnerId = _arg1.readUnsignedInt());
            _local4.MasterName = PetRaceConstData.getNameByReportId(_local4.reportId, 0);
            _local5.MasterName = PetRaceConstData.getNameByReportId(_local5.reportId, 1);
            _local4.resetValue();
            _local5.resetValue();
            var _local6:uint;
            var _local7:uint;
            _local6 = 0;
            while (_local6 < 3) {
                _local4.Winners[_local6] = (_local5.Winners[_local6] = _arg1.readUnsignedInt());
                _local7 = 0;
                while (_local7 < 2) {
                    if (_local7 == 0){
                        _local4.ReadReportFromPacket(_arg1, _local6);
                    } else {
                        _local5.ReadReportFromPacket(_arg1, _local6);
                    };
                    _local7++;
                };
                _local6++;
            };
            PetRaceConstData.sideReportList1[_local4.reportId] = _local4;
            PetRaceConstData.sideReportList2[_local5.reportId] = _local5;
            PetRacingBattle.startPetReport(PetRaceConstData.sideReportList1[_local4.reportId], PetRaceConstData.sideReportList2[_local5.reportId]);
            facade.sendNotification(PetRaceEvent.UPDATE_CHALLENGGE, {
                type:1,
                leftInfo:PetRaceConstData.sideReportList1[_local4.reportId],
                rightInfo:PetRaceConstData.sideReportList2[_local5.reportId]
            });
        }
        private function getRankingList(_arg1:NetPacket):void{
            var _local6:PetRacePlayerInfo;
            PetRaceConstData.TOTAL_TEAM_NUM = _arg1.readUnsignedInt();
            trace("队伍数", PetRaceConstData.TOTAL_TEAM_NUM);
            var _local2:uint = _arg1.readUnsignedInt();
            PetRaceConstData.CURR_TEAM_PAGE = _local2;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint;
            if (!PetRaceConstData.allTeamList[_local2]){
                PetRaceConstData.allTeamList[_local2] = [];
            };
            var _local5:Array = [];
            _local4 = 0;
            while (_local4 < _local3) {
                _local6 = new PetRacePlayerInfo();
                _local6.PlayerId = _arg1.readUnsignedInt();
                _local6.MasterName = _arg1.ReadString();
                _local6.TeamName = _arg1.ReadString();
                _local6.Ranking = _arg1.readUnsignedInt();
                _local6.WinRate = _arg1.readUnsignedInt();
                _local6.Score = _arg1.readInt();
                PetRaceConstData.allTeamList[_local2][_local4] = _local6;
                _local4++;
            };
            if (_local3 > 0){
                facade.sendNotification(PetRaceEvent.UPDATE_PETRACE_MEMBER, PetRaceConstData.allTeamList[_local2]);
            };
        }

    }
}//package Net.PackHandler 
