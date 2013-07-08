//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Team.Command.*;

    public class TeamAction extends GameAction {

        private static var _instance:TeamAction;

        public function TeamAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():TeamAction{
            if (!_instance){
                _instance = new (TeamAction)();
            };
            return (_instance);
        }

        private function cmd_kickoutResult(_arg1:NetPacket):void{
            var _local3:TeamDataProxy;
            var _local4:String;
            var _local2:int = _arg1.readUnsignedInt();
            if (_local2 == GameCommonData.Player.Role.Id){
                GameCommonData.Player.Role.idTeam = 0;
                GameCommonData.Player.Role.idTeamLeader = 0;
                GameCommonData.Player.Role.isTeamLeader = false;
                _local3 = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
                for (_local4 in _local3.teamMemberList) {
                    if (((_local3.teamMemberList[_local4]) && (GameCommonData.SameSecnePlayerList[_local3.teamMemberList[_local4].Id]))){
                        (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(GameCommonData.SameSecnePlayerList[_local3.teamMemberList[_local4].Id]);
                    };
                };
                _local3.teamMemberList = [];
                _local3.teamReqList = [];
                sendNotification(EventList.UPDATETEAM, _local3.teamMemberList);
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("你被请离了队伍"),
                    color:0xFFFF00
                });
                UIFacade.GetInstance().sendNotification(EventList.HASTEAM, false);
            };
        }
        public function getTeamInfo(_arg1:NetPacket):void{
            var _local5:TeamPlayerVo;
            var _local2:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            var _local3:Boolean = _arg1.readBoolean();
            var _local4:int = _arg1.readUnsignedInt();
            var _local6:Array = [];
            var _local7:int;
            while (_local7 < _local4) {
                _local5 = new TeamPlayerVo();
                _local5.Id = _arg1.readUnsignedInt();
                _local5.Name = _arg1.ReadString();
                _local5.isLeader = _arg1.readBoolean();
                _local5.Level = _arg1.readUnsignedInt();
                _local5.Job = _arg1.readUnsignedInt();
                _local5.Face = _arg1.readUnsignedInt();
                if (_local5.isLeader){
                    GameCommonData.Player.Role.idTeamLeader = _local5.Id;
                };
                _local6.push(_local5);
                if (GameCommonData.SameSecnePlayerList[_local5.Id]){
                    (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(GameCommonData.SameSecnePlayerList[_local5.Id]);
                };
                _local7++;
            };
            if (((_local2.autoJoinMode) && ((GameCommonData.Player.Role.idTeamLeader == GameCommonData.Player.Role.Id)))){
                TeamSend.AutoApplySetting(_local2.autoJoinMode);
            } else {
                _local2.autoAllowApplyTeamMode = _local3;
            };
            sendNotification(EventList.UPDATETEAM, _local6);
        }
        private function cmd_applyJoin(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            var _local4:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            var _local5:TeamPlayerVo = new TeamPlayerVo();
            _local5.Id = _local2;
            _local5.Name = _local3;
            _local5.Level = _arg1.readUnsignedInt();
            _local5.Job = _arg1.readUnsignedInt();
            _local5.Face = _arg1.readUnsignedInt();
            sendNotification(TeamEventName.HAVEAPPLY);
            sendNotification(TeamEventName.ADD_JOINTREQUEST, _local5);
        }
        public function sendApplyResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:(((LanguageMgr.GetTranslation("你加入到队伍x") + "【") + _local3) + "】"),
                color:0xFFFF00
            });
            GameCommonData.Player.Role.idTeam = _local2;
            GameCommonData.Player.Role.idTeamLeader = GameCommonData.Player.Role.Id;
            UIFacade.GetInstance().sendNotification(EventList.HASTEAM, true);
        }
        private function cmd_joinTeamReply(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            switch (_local2){
                case 1:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("队伍人物已经满了，对方无法加入"),
                        color:0xFFFF00
                    });
                    break;
                case 5:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("对方已经离线或者换线"),
                        color:0xFFFF00
                    });
                    break;
                case 6:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("对方已经加入其他队伍"),
                        color:0xFFFF00
                    });
                    break;
            };
        }
        private function cmd_chgLeader(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            GameCommonData.Player.Role.idTeamLeader = _local2;
            var _local4:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            if (_local4.teamMemberList.length == 0){
                return;
            };
            if (_local2 == GameCommonData.Player.Role.Id){
                GameCommonData.Player.Role.isTeamLeader = true;
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("你被变为队长"),
                    color:0xFFFF00
                });
            } else {
                GameCommonData.Player.Role.isTeamLeader = false;
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:((("<font color='#ff0000'>[" + _local3) + "]</font>") + LanguageMgr.GetTranslation("被变为队长")),
                    color:0xFFFF00
                });
            };
            _local4.changeLeader(_local2);
            sendNotification(EventList.UPDATETEAM, _local4.teamMemberList);
        }
        private function cmd_changeAutoInviteSettingResult(_arg1:NetPacket):void{
            var _local2:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            _local2.autoAllowApplyTeamMode = _arg1.readBoolean();
            facade.sendNotification(TeamEventName.REFUSH_TEAMUI);
        }
        public function sendApplyState(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            switch (_local3){
                case 0:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("队伍不在同一线"),
                        color:0xFFFF00
                    });
                    break;
                case 1:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("队伍人数满"),
                        color:0xFFFF00
                    });
                    break;
                case 2:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("已经申请过"),
                        color:0xFFFF00
                    });
                    break;
                case 3:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("申请成功等待批复"),
                        color:0xFFFF00
                    });
                    break;
                case 4:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("对方拒绝了入队的申请"),
                        color:0xFFFF00
                    });
                    break;
            };
        }
        private function cmd_inviteResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            switch (_local2){
                case 0:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("邀请成功等待回应"),
                        color:0xFFFF00
                    });
                    break;
                case 1:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("已经邀请过该玩家了"),
                        color:0xFFFF00
                    });
                    break;
                case 2:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("玩家不在线或不在本线"),
                        color:0xFFFF00
                    });
                    break;
                case 3:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("队伍人数已满"),
                        color:0xFFFF00
                    });
                    break;
                case 4:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("对方已经加入队伍"),
                        color:0xFFFF00
                    });
                    break;
            };
        }
        private function cmd_rejectInvite(_arg1:NetPacket):void{
            var _local2:String = _arg1.ReadString();
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:LanguageMgr.GetTranslation("玩家【x】拒绝了你的邀请", _local2),
                color:0xFFFF00
            });
        }
        private function leaveTeamResult(_arg1:NetPacket):void{
            var _local3:String;
            GameCommonData.Player.Role.idTeam = 0;
            GameCommonData.Player.Role.idTeamLeader = 0;
            GameCommonData.Player.Role.isTeamLeader = false;
            var _local2:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            for (_local3 in _local2.teamMemberList) {
                if (((_local2.teamMemberList[_local3]) && (GameCommonData.SameSecnePlayerList[_local2.teamMemberList[_local3].Id]))){
                    (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(GameCommonData.SameSecnePlayerList[_local2.teamMemberList[_local3].Id]);
                };
            };
            _local2.teamMemberList = [];
            _local2.teamReqList = [];
            sendNotification(EventList.UPDATETEAM, []);
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:LanguageMgr.GetTranslation("你退出了队伍"),
                color:0xFFFF00
            });
            UIFacade.GetInstance().sendNotification(EventList.HASTEAM, false);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_CREATETEAM_RESULT:
                    createTeamResult(_arg1);
                    break;
                case Protocol.SMSG_TEAMINFO:
                    getTeamInfo(_arg1);
                    break;
                case Protocol.SMSG_JOINTEAM_REPLY:
                    sendApplyState(_arg1);
                    break;
                case Protocol.SMSG_JOINTEAM_RESULT:
                    sendApplyResult(_arg1);
                    break;
                case Protocol.SMSG_INRANGETEAM_INFO:
                    refushAroundTeamResult(_arg1);
                    break;
                case Protocol.SMSG_PLAYERTEAMCMD:
                    playerTeamCmd(_arg1);
                    break;
                case Protocol.SMSG_INVITE_JOINTEAM:
                    inviteJoin(_arg1);
                    break;
                case Protocol.SMSG_LEAVETEAM_RESULT:
                    leaveTeamResult(_arg1);
                    break;
                case Protocol.SMSG_TEAM_MEMBERPOS:
                    UpdateMemberPos(_arg1);
                    break;
            };
        }
        private function playerTeamCmd(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            switch (_local2){
                case TeamDataProxy.STEAMCMD_PLAYERLEAVE:
                    cmd_levelTeam(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_NEWLEADERINFO:
                    cmd_chgLeader(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_CHANGELEADER:
                    cmd_chageLeaderResult(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_INVITE:
                    cmd_inviteResult(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_KICKPLAYER:
                    cmd_kickoutResult(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_DISBANDTEAM:
                    cmd_disbandTeamResult(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_REQUEST_JOIN:
                    cmd_applyJoin(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_JOINTEAMREPLY:
                    cmd_joinTeamReply(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_INVITER_REJECT_ENTERTEAM:
                    cmd_rejectInvite(_arg1);
                    break;
                case TeamDataProxy.STEAMCMD_CHANGE_JOINTEAMMODE:
                    cmd_changeAutoInviteSettingResult(_arg1);
                    break;
            };
        }
        public function createTeamResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:LanguageMgr.GetTranslation("你建立了一个队伍"),
                color:0xFFFF00
            });
            GameCommonData.Player.Role.idTeam = _local2;
            GameCommonData.Player.Role.idTeamLeader = GameCommonData.Player.Role.Id;
            GameCommonData.Player.Role.isTeamLeader = true;
            UIFacade.GetInstance().sendNotification(EventList.HASTEAM, true);
        }
        private function UpdateMemberPos(_arg1:NetPacket):void{
            var _local4:uint;
            var _local6:Object;
            var _local7:Object;
            var _local2:uint;
            var _local3:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            var _local5:uint = _arg1.readUnsignedInt();
            if (_local5 == 1){
                _local3.memberPosList = [];
                _local4 = _arg1.readUnsignedInt();
                while (_local2 < _local4) {
                    _local6 = new Object();
                    _local6.playerId = _arg1.readUnsignedInt();
                    _local6.Name = _arg1.ReadString();
                    _local6.GameX = _arg1.readUnsignedShort();
                    _local6.GameY = _arg1.readUnsignedShort();
                    _local3.memberPosList.push(_local6);
                    _local2++;
                };
                facade.sendNotification(EventList.SHOW_TEAM_MEMBER_POS);
            } else {
                _local3.arenaMemberList = [];
                _local4 = _arg1.readUnsignedInt();
                while (_local2 < _local4) {
                    _local7 = new Object();
                    _local7.playerId = _arg1.readUnsignedInt();
                    _local7.Name = _arg1.ReadString();
                    _local7.GameX = _arg1.readUnsignedShort();
                    _local7.GameY = _arg1.readUnsignedShort();
                    _local3.arenaMemberList.push(_local7);
                    _local2++;
                };
                facade.sendNotification(EventList.SHOW_ARENA_MEMBER_POS);
            };
        }
        private function inviteJoin(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            var _local4:String = _arg1.ReadString();
            if (!SharedManager.getInstance().showTI){
                return;
            };
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:((("<font color='#ff0000'>[" + _local4) + "]</font>") + LanguageMgr.GetTranslation("邀请你加入队伍")),
                color:0xFFFF00
            });
            if ((facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).autoJoinMode){
                TeamSend.RecallInvite(_local2, 1);
                return;
            };
            var _local5:NewInfoTipVo = new NewInfoTipVo();
            _local5.title = ((("[" + _local4) + "]") + LanguageMgr.GetTranslation("邀请你入队"));
            _local5.type = NewInfoTipType.TYPE_TEAMINVITE;
            _local5.data = {
                teamId:_local2,
                leaderName:_local4
            };
            _local5.addTime = TimeManager.Instance.Now().time;
            sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local5);
        }
        private function cmd_chageLeaderResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            var _local4:String = _arg1.ReadString();
            GameCommonData.Player.Role.idTeamLeader = _local2;
            var _local5:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            if (_local5.teamMemberList.length == 0){
                return;
            };
            if (_local2 == GameCommonData.Player.Role.Id){
                GameCommonData.Player.Role.isTeamLeader = true;
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("你被提升为队长"),
                    color:0xFFFF00
                });
            } else {
                GameCommonData.Player.Role.isTeamLeader = false;
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:((("<font color='#ff0000'>[" + _local3) + "]</font>") + LanguageMgr.GetTranslation("被提升为队长")),
                    color:0xFFFF00
                });
            };
            _local5.changeLeader(_local2);
            sendNotification(EventList.UPDATETEAM, _local5.teamMemberList);
        }
        private function cmd_levelTeam(_arg1:NetPacket):void{
            var _local5:Array;
            var _local6:TeamPlayerVo;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            var _local4:TeamPlayerVo = _local3.getMemberById(_local2);
            if (_local4){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:((("<font color='#ff0000'>[" + _local4.Name) + "]</font>") + LanguageMgr.GetTranslation("退出了队伍")),
                    color:0xFFFF00
                });
                _local5 = _local3.teamMemberList;
                _local3.teamMemberList = [];
                while (_local5.length > 0) {
                    _local6 = _local5.shift();
                    if (_local6.Id == _local2){
                    } else {
                        _local3.teamMemberList.push(_local6);
                    };
                };
                sendNotification(EventList.UPDATETEAM, _local3.teamMemberList);
            };
        }
        public function refushAroundTeamResult(_arg1:NetPacket):void{
            var _local4:TeamVo;
            var _local5:int;
            var _local2:Dictionary = new Dictionary();
            var _local3:int = _arg1.readUnsignedInt();
            while (_local5 < _local3) {
                _local4 = new TeamVo();
                _local4.teamId = _arg1.readUnsignedInt();
                _local4.Name = _arg1.ReadString();
                _local4.leaderName = _arg1.ReadString();
                _local4.curCnt = _arg1.readUnsignedInt();
                _local4.Face = _arg1.readUnsignedInt();
                _local4.isAutoJoinMode = _arg1.readBoolean();
                _local4.teamLevel = _arg1.readUnsignedInt();
                _local2[_local4.teamId] = _local4;
                _local5++;
            };
            sendNotification(RefushNearPlayerTeamCommand.NAME, _local2);
        }
        private function cmd_disbandTeamResult(_arg1:NetPacket):void{
            var _local3:String;
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:LanguageMgr.GetTranslation("队伍已经被解散"),
                color:0xFFFF00
            });
            GameCommonData.Player.Role.idTeam = 0;
            GameCommonData.Player.Role.idTeamLeader = 0;
            GameCommonData.Player.Role.isTeamLeader = false;
            var _local2:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            for (_local3 in _local2.teamMemberList) {
                if (((_local2.teamMemberList[_local3]) && (GameCommonData.SameSecnePlayerList[_local2.teamMemberList[_local3].Id]))){
                    (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(GameCommonData.SameSecnePlayerList[_local2.teamMemberList[_local3].Id]);
                };
            };
            _local2.teamMemberList = [];
            _local2.teamReqList = [];
            sendNotification(EventList.UPDATETEAM, []);
            GameCommonData.Player.SetTeam(false);
            GameCommonData.Player.SetTeamLeader(false);
        }

    }
}//package Net.PackHandler 
