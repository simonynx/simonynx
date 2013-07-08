//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.CSBattle.vo.*;
    import Net.RequestSend.*;
    import GameUI.Modules.CSBattle.Data.*;

    public class CSBattleAction extends GameAction {

        private static var _instance:CSBattleAction;

        public static function getInstance():CSBattleAction{
            if (_instance == null){
                _instance = new (CSBattleAction)();
                new CSBattleRewardItemInfo();
            };
            return (_instance);
        }

        private function getSelfInfo(_arg1:NetPacket):void{
            GameCommonData.Player.Role.CsbOffer = _arg1.readUnsignedInt();
            GameCommonData.Player.Role.CsbPoint = _arg1.readUnsignedInt();
        }
        private function teamOperateResulte(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:int;
            var _local5:String;
            var _local6:int;
            var _local7:String;
            var _local8:int;
            var _local9:String;
            var _local10:int;
            var _local11:String;
            var _local12:String;
            var _local13:int;
            var _local14:int;
            var _local2:int = _arg1.readUnsignedByte();
            switch (_local2){
                case 1:
                    _local3 = _arg1.readUnsignedByte();
                    switch (_local3){
                        case 0:
                            _local11 = _arg1.ReadString();
                            _local12 = _arg1.ReadString();
                            MessageTip.popup(LanguageMgr.GetTranslation("邀请成功"));
                            break;
                        case 1:
                            MessageTip.popup(LanguageMgr.GetTranslation("队伍已满无法邀请"));
                            break;
                        case 2:
                            MessageTip.popup(LanguageMgr.GetTranslation("找不到被邀请者"));
                            break;
                        case 3:
                            MessageTip.popup(LanguageMgr.GetTranslation("被邀请者不在线"));
                            break;
                        case 4:
                            MessageTip.popup(LanguageMgr.GetTranslation("被邀请者已经有了战队"));
                            break;
                        case 5:
                            MessageTip.popup(LanguageMgr.GetTranslation("等级不够无法邀请"));
                            break;
                        case 6:
                            MessageTip.popup(LanguageMgr.GetTranslation("邀请太频繁"));
                            break;
                        case 7:
                            MessageTip.popup(LanguageMgr.GetTranslation("队伍正在撮合"));
                            break;
                        case 8:
                            MessageTip.popup(LanguageMgr.GetTranslation("不是队长无法邀请"));
                            break;
                        case 9:
                            MessageTip.popup(LanguageMgr.GetTranslation("其他原因无法邀请"));
                            break;
                        case 10:
                            MessageTip.popup(LanguageMgr.GetTranslation("对方拒绝入队"));
                            break;
                        default:
                            MessageTip.popup(("error" + _local3));
                    };
                    break;
                case 3:
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = _arg1.ReadString();
                    if (_local4 == GameCommonData.Player.Role.Id){
                        GameCommonData.CSBattleMyTeamInfo = null;
                        MessageTip.popup(LanguageMgr.GetTranslation("你被踢出战队"));
                        facade.sendNotification(EventList.CLOSE_CSBPANEL);
                    } else {
                        _local13 = 0;
                        _local14 = GameCommonData.CSBattleMyTeamInfo.MemberArr.length;
                        while (_local13 < _local14) {
                            if (GameCommonData.CSBattleMyTeamInfo.MemberArr[_local13].Guid == _local4){
                                GameCommonData.CSBattleMyTeamInfo.MemberArr.splice(_local13, 1);
                                break;
                            };
                            _local13++;
                        };
                        MessageTip.popup(LanguageMgr.GetTranslation((_local5 + "被踢出战队")));
                        facade.sendNotification(EventList.CSB_UPDATE_MYTEAMINFO);
                    };
                    break;
                case 5:
                    MessageTip.popup(LanguageMgr.GetTranslation("解散战队"));
                    _local13 = 0;
                    _local14 = GameCommonData.CSBattleTeamList.length;
                    while (_local13 < _local14) {
                        if (GameCommonData.CSBattleTeamList[_local13].TeamId == GameCommonData.CSBattleMyTeamInfo.TeamId){
                            GameCommonData.CSBattleTeamList.splice(_local13, 1);
                            break;
                        };
                        _local13++;
                    };
                    GameCommonData.CSBattleMyTeamInfo = null;
                    facade.sendNotification(EventList.CLOSE_CSBPANEL);
                    break;
                case 7:
                    _local6 = _arg1.readUnsignedInt();
                    _local7 = _arg1.ReadString();
                    _local8 = _arg1.readUnsignedInt();
                    _local9 = _arg1.ReadString();
                    if (((GameCommonData.CSBattleMyTeamInfo) && ((GameCommonData.CSBattleMyTeamInfo.LeaderGuid == _local6)))){
                        GameCommonData.CSBattleMyTeamInfo.LeaderGuid = _local8;
                        facade.sendNotification(EventList.CSB_UPDATE_MYTEAMINFO);
                    };
                    break;
                case 9:
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = _arg1.ReadString();
                    if (_local4 == GameCommonData.Player.Role.Id){
                        GameCommonData.CSBattleMyTeamInfo = null;
                        MessageTip.popup(LanguageMgr.GetTranslation("你退出战队"));
                        facade.sendNotification(EventList.CLOSE_CSBPANEL);
                    } else {
                        _local13 = 0;
                        _local14 = GameCommonData.CSBattleMyTeamInfo.MemberArr.length;
                        while (_local13 < _local14) {
                            if (GameCommonData.CSBattleMyTeamInfo.MemberArr[_local13].Guid == _local4){
                                GameCommonData.CSBattleMyTeamInfo.MemberArr.splice(_local13, 1);
                                break;
                            };
                            _local13++;
                        };
                        MessageTip.popup(LanguageMgr.GetTranslation("x退出战队", _local5));
                        facade.sendNotification(EventList.CSB_UPDATE_MYTEAMINFO);
                    };
                    break;
                case 11:
                    if (GameCommonData.CSBattleMyTeamInfo){
                        GameCommonData.CSBattleMyTeamInfo.State = 1;
                        facade.sendNotification(EventList.CSB_UPDATETEAMFIGHTSTATE);
                    };
                    break;
                case 13:
                    GameCommonData.CSBattleMyTeamInfo.State = 0;
                    facade.sendNotification(EventList.CSB_UPDATETEAMFIGHTSTATE);
                    break;
                case 14:
                    facade.sendNotification(EventList.CSB_RECIEVE_ENTERBS_TIP);
                    break;
                case 15:
                    _local10 = _arg1.readUnsignedInt();
                    if (GameCommonData.CSBattleMyTeamInfo){
                        GameCommonData.CSBattleMyTeamInfo.State = _local10;
                        facade.sendNotification(EventList.CSB_UPDATETEAMFIGHTSTATE);
                    };
                    break;
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_CB_CREATE_TEAM_RESULT:
                    createTeamResult(_arg1);
                    break;
                case Protocol.SMSG_CB_TEAM_LIST:
                    teamList(_arg1);
                    break;
                case Protocol.SMSG_CB_SELFTEAM_INFO:
                    getMyTeamInfo(_arg1);
                    break;
                case Protocol.SMSG_CB_TEAM_INVITE:
                    teamInviteResult(_arg1);
                    break;
                case Protocol.SMSG_CB_TEAM_OPERATE_RESULT:
                    teamOperateResulte(_arg1);
                    break;
                case Protocol.SMSG_CB_BATTLE_FINISHED:
                    battleResult(_arg1);
                    break;
                case Protocol.SMSG_CB_REAL_BATTLE_TIMER_NOTICE:
                    timeHandler(_arg1);
                    break;
                case Protocol.SMSG_CB_EXCHANGE_PRIZE_RESULT:
                    exchangeResultHandler(_arg1);
                    break;
                case Protocol.SMSG_CB_PLAYER_REPUTE_INFO:
                    getSelfInfo(_arg1);
                    break;
            };
        }
        private function teamInviteResult(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:String;
            var _local5:int;
            var _local6:String;
            var _local7:int;
            var _local2:int = _arg1.readUnsignedByte();
            switch (_local2){
                case 0:
                    _local3 = _arg1.readUnsignedInt();
                    _local4 = _arg1.ReadString();
                    _local5 = _arg1.readUnsignedInt();
                    _local6 = _arg1.ReadString();
                    facade.sendNotification(EventList.CSB_RECIEVEINVITE, {
                        id:_local3,
                        name:_local4,
                        level:_local5
                    });
                    break;
                case 1:
                    _local7 = _arg1.readUnsignedByte();
                    switch (_local7){
                        case 0:
                            MessageTip.popup(LanguageMgr.GetTranslation("成功加入战队"));
                            CSBattleSend.GetCSBTeamList();
                            CSBattleSend.GetMyTeamInfo();
                            break;
                        case 1:
                            MessageTip.popup(LanguageMgr.GetTranslation("无战队无加入句"));
                            break;
                        case 2:
                            MessageTip.popup(LanguageMgr.GetTranslation("战队状态不对无法加入"));
                            break;
                        case 3:
                            MessageTip.popup(LanguageMgr.GetTranslation("战队人数满无法加入"));
                            break;
                        case 4:
                            MessageTip.popup(LanguageMgr.GetTranslation("对方无响应无加入"));
                            break;
                        case 5:
                            MessageTip.popup(LanguageMgr.GetTranslation("其他错误无法加入战队"));
                            break;
                    };
                    break;
            };
        }
        private function timeHandler(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:Number = _arg1.readUnsignedInt();
            facade.sendNotification(EventList.CSB_TIMEHANDLER, [_local2, _local3]);
        }
        private function battleResult(_arg1:NetPacket):void{
            var _local7:int;
            var _local8:String;
            var _local9:int;
            var _local10:String;
            var _local11:int;
            var _local12:int;
            var _local13:int;
            var _local14:int;
            var _local15:String;
            var _local16:int;
            var _local17:int;
            var _local18:int;
            var _local19:int;
            var _local20:int;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:int = _arg1.readUnsignedInt();
            var _local5:Array = [];
            var _local6:int;
            while (_local6 < _local4) {
                _local7 = _arg1.readUnsignedInt();
                _local8 = _arg1.ReadString();
                _local9 = _arg1.readUnsignedInt();
                _local10 = _arg1.ReadString();
                _local11 = _arg1.readUnsignedInt();
                _local12 = _arg1.readUnsignedInt();
                if (_local12 == 0){
                    _local5.push([_local7, _local9, _local10, "", 0, _local11, _local8]);
                } else {
                    _local13 = 0;
                    while (_local13 < _local12) {
                        _local14 = _arg1.readUnsignedInt();
                        _local15 = _arg1.ReadString();
                        _local16 = _arg1.readUnsignedInt();
                        _local17 = _arg1.readUnsignedInt();
                        _local18 = 0;
                        while (_local18 < _local17) {
                            _local19 = _arg1.readUnsignedInt();
                            _local20 = _arg1.readUnsignedInt();
                            _local18++;
                        };
                        _local5.push([_local7, _local9, _local10, _local15, 0, _local11, _local8]);
                        _local13++;
                    };
                };
                _local6++;
            };
            facade.sendNotification(EventList.CSB_BATTLERESULT, [_local2, _local3, _local5]);
        }
        private function createTeamResult(_arg1:NetPacket):void{
            var _local3:int;
            var _local2:int = _arg1.readUnsignedByte();
            switch (_local2){
                case 0:
                    MessageTip.popup(LanguageMgr.GetTranslation("创建队伍成功"));
                    _local3 = _arg1.readUnsignedInt();
                    break;
                case 2:
                    MessageTip.popup(LanguageMgr.GetTranslation("战队名重复"));
                    break;
                case 4:
                    MessageTip.popup(LanguageMgr.GetTranslation("其它原因"));
                    break;
            };
            CSBattleSend.GetCSBTeamList();
        }
        private function exchangeResultHandler(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:int;
            var _local2:int = _arg1.readUnsignedInt();
            if (_local2 == 0){
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                GameCommonData.Player.Role.CsbPoint = _local4;
                MessageTip.popup("兑换成功");
            } else {
                MessageTip.show(String(_local2));
            };
            facade.sendNotification(EventList.CSB_UPDATE_MYTEAMINFO);
        }
        private function teamList(_arg1:NetPacket):void{
            var _local5:CSBattleTeamInfo;
            var _local6:CSBattlePlayerInfo;
            var _local8:Array;
            var _local9:int;
            GameCommonData.CSBattleTeamList = [];
            var _local2:Boolean = _arg1.readBoolean();
            CSBattleData.CsbIsOpen = _local2;
            if (!_local2){
                facade.sendNotification(EventList.CSB_UPDATE_TEAMLIST);
                return;
            };
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:int;
            var _local7:int;
            while (_local7 < _local3) {
                _local5 = new CSBattleTeamInfo();
                _local5.TeamId = _arg1.readUnsignedInt();
                _local5.Name = _arg1.ReadString();
                _local5.Level = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                _local8 = [];
                _local9 = 0;
                while (_local9 < _local4) {
                    _local6 = new CSBattlePlayerInfo();
                    _local6.Guid = _arg1.readUnsignedInt();
                    _local6.Name = _arg1.ReadString();
                    _local6.Level = _arg1.readUnsignedInt();
                    _local6.Face = _arg1.readUnsignedInt();
                    _local6.Sex = _arg1.readUnsignedInt();
                    _local6.Job = _arg1.readUnsignedInt();
                    _local6.FightPoint = _arg1.readUnsignedInt();
                    _local8.push(_local6);
                    _local9++;
                };
                _local5.MemberArr = _local8;
                GameCommonData.CSBattleTeamList.push(_local5);
                _local7++;
            };
            facade.sendNotification(EventList.CSB_UPDATE_TEAMLIST);
        }
        private function getMyTeamInfo(_arg1:NetPacket):void{
            var _local4:CSBattlePlayerInfo;
            var _local2:int;
            var _local3:CSBattleTeamInfo = new CSBattleTeamInfo();
            var _local5:uint = _arg1.readUnsignedInt();
            CSBattleData.PlatId = int((_local5 / 10000));
            CSBattleData.ServerId = (_local5 % 10000);
            _local3.TeamId = _arg1.readUnsignedInt();
            _local3.Name = _arg1.ReadString();
            _local3.Level = _arg1.readUnsignedInt();
            _local3.State = _arg1.readUnsignedInt();
            _local3.TotlaBattleCnt = _arg1.readUnsignedInt();
            _local3.WinBattleCnt = _arg1.readUnsignedInt();
            _local3.LeaderGuid = _arg1.readUnsignedInt();
            _local2 = _arg1.readUnsignedInt();
            var _local6:Array = [];
            var _local7:int;
            while (_local7 < _local2) {
                _local4 = new CSBattlePlayerInfo();
                _local4.Guid = _arg1.readUnsignedInt();
                _local4.Name = _arg1.ReadString();
                _local4.Level = _arg1.readUnsignedInt();
                _local4.Face = _arg1.readUnsignedInt();
                _local4.Sex = _arg1.readUnsignedInt();
                _local4.Job = _arg1.readUnsignedInt();
                _local4.FightPoint = _arg1.readUnsignedInt();
                _local4.TotlaBattleCnt = _arg1.readUnsignedInt();
                _local4.WinBattleCnt = _arg1.readUnsignedInt();
                _local4.BattleLevel = _arg1.readUnsignedInt();
                _local6.push(_local4);
                _local7++;
            };
            _local3.MemberArr = _local6;
            GameCommonData.CSBattleMyTeamInfo = _local3;
            facade.sendNotification(EventList.CSB_UPDATE_MYTEAMINFO);
        }

    }
}//package Net.PackHandler 
