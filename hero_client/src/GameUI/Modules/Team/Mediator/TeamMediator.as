//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.PackHandler.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Team.UI.*;
    import GameUI.Modules.Team.Command.*;
    import GameUI.*;

    public class TeamMediator extends Mediator {

        public static const TEAMDEFAULTPOS:Point = new Point(450, 58);
        public static const TEAMITEM_STARTPOS:Point = new Point(15, 86);
        public static const TEAMREQLITEM_STARTPOS:Point = new Point(219, 86);
        public static const NAME:String = "TeamMediator";

        private var teamDataProxy:TeamDataProxy;
        private var inviteDataArr:Array;
        private var teamPanel:HFrame = null;
        private var notiData:Object;
        private var teamModelManager:TeamModelManager = null;
        private var inviteData:Object;
        private var joinPlayerName:String = "";
        private var dataProxy:DataProxy;

        public function TeamMediator(){
            notiData = new Object();
            inviteDataArr = new Array();
            inviteData = new Object();
            super(NAME);
        }
        private function __btnSelectPageHandler(_arg1:MouseEvent):void{
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            if (_arg1.currentTarget.name.split("_")[1] == 0){
                update(0);
                team.teamtextmm.gotoAndStop(1);
            } else {
                if (_arg1.currentTarget.name.split("_")[1] == 1){
                    update(1);
                    team.teamtextmm.gotoAndStop(2);
                };
            };
        }
        private function __selectAutoJointModeHandler(_arg1:Event):void{
            if (GameCommonData.Player.Role.idTeam > 0){
                if (!GameCommonData.Player.Role.isTeamLeader){
                    MessageTip.show(LanguageMgr.GetTranslation("队长才能设置该项"));
                    return;
                };
            };
            teamModelManager.autoJoinTeamBtn.selected = !(teamModelManager.autoJoinTeamBtn.selected);
            if (GameCommonData.Player.Role.idTeam > 0){
                teamDataProxy.autoAllowApplyTeamMode = teamModelManager.autoJoinTeamBtn.selected;
                TeamSend.AutoApplySetting(teamDataProxy.autoAllowApplyTeamMode);
            } else {
                teamDataProxy.autoJoinMode = teamModelManager.autoJoinTeamBtn.selected;
            };
        }
        private function applyAccept(_arg1:int):void{
            var _local2:String;
            for (_local2 in teamDataProxy.teamReqList) {
                if (teamDataProxy.teamReqList[_local2].Id == _arg1){
                    teamDataProxy.teamReqList.splice(_local2, 1);
                };
            };
            TeamSend.RecallApply(_arg1, 1);
            sendNotification(TeamEventName.UPDATE_JOINTREQUEST_LIST);
        }
        private function clearData():void{
            var _local1:int;
            var _local2:*;
            while (true) {
                if (teamDataProxy.teamMemItemList.length > 0){
                    _local2 = teamDataProxy.teamMemItemList.pop();
                } else {
                    if (teamDataProxy.teamReqItemList.length > 0){
                        _local2 = teamDataProxy.teamReqItemList.pop();
                    } else {
                        if (teamDataProxy.teamNearHasTeamPlayerItemList.length > 0){
                            _local2 = teamDataProxy.teamNearHasTeamPlayerItemList.pop();
                        } else {
                            if (teamDataProxy.teamNearNoTeamPlayerItemList.length > 0){
                                _local2 = teamDataProxy.teamNearNoTeamPlayerItemList.pop();
                            } else {
                                break;
                            };
                        };
                    };
                };
                _local2.removeEventListener(MouseEvent.CLICK, itemClickHanler);
                _local2.dispose();
                _local2 = null;
            };
            teamDataProxy.teamNearHasTeamPlayerSelected = null;
            teamDataProxy.teamNearNoTeamPlayerSelected = null;
            teamDataProxy.teamMemSelected = null;
            teamDataProxy.teamReqSelected = null;
        }
        private function setNearNoTeamItems():void{
            var _local1:MovieClip;
            var _local2:TeamItem;
            var _local3:int;
            var _local5:FaceItem;
            var _local4:Array = teamDataProxy.teamNearNoTeamPlayerList;
            teamDataProxy.teamNearNoTeamPlayerItemList = [];
            while (_local3 < _local4.length) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TeamItem");
                _local2 = new TeamItem(_local1, _local3, TeamItem.TYPE_NEAR_NOTEAM);
                _local2.name = ("teamNearNoTeamItem_" + _local3);
                _local2.x = TEAMREQLITEM_STARTPOS.x;
                _local2.y = (TEAMREQLITEM_STARTPOS.y + (_local3 * _local1.height));
                _local2.addEventListener(MouseEvent.CLICK, itemClickHanler);
                _local2.info = _local4[_local3];
                teamDataProxy.teamNearNoTeamPlayerItemList.push(_local2);
                team.addChild(_local2);
                _local3++;
            };
        }
        private function updateTeamPlayerInfo():void{
            var _local2:TeamPlayerVo;
            var _local1:int;
            var _local3:Dictionary = new Dictionary();
            while (_local1 < teamDataProxy.teamMemberList.length) {
                _local2 = teamDataProxy.teamMemberList[_local1];
                if (_local2.isLeader){
                    _local3[_local2.Id] = {
                        isCaption:true,
                        id:_local2.Id
                    };
                } else {
                    _local3[_local2.Id] = {
                        isCaption:false,
                        id:_local2.Id
                    };
                };
                _local1++;
            };
            GameCommonData.TeamPlayerListOld = GameCommonData.TeamPlayerList;
            GameCommonData.TeamPlayerList = _local3;
            notiFan();
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            var _local2:String;
            var _local3:String;
            switch (_arg1.currentTarget){
                case teamModelManager.addFriendBtn:
                    if (teamDataProxy.curPage == 0){
                        if (teamDataProxy.teamNearNoTeamPlayerSelected){
                            _local2 = teamDataProxy.teamNearNoTeamPlayerSelected.Name;
                        };
                    } else {
                        if (teamDataProxy.curPage == 1){
                            if (teamDataProxy.teamMemSelected){
                                _local2 = teamDataProxy.teamMemSelected.Name;
                            } else {
                                if (teamDataProxy.teamReqSelected){
                                    _local2 = teamDataProxy.teamReqSelected.Name;
                                };
                            };
                        };
                    };
                    if (((_local2) && (!((_local2 == ""))))){
                        sendNotification(FriendCommandList.ADD_TO_FRIEND, {
                            id:-1,
                            name:_local2
                        });
                    } else {
                        MessageTip.show(LanguageMgr.GetTranslation("组队提示2"));
                    };
                    break;
                case teamModelManager.chatBtn:
                    if (teamDataProxy.curPage == 0){
                        if (teamDataProxy.teamNearHasTeamPlayerSelected){
                            _local2 = teamDataProxy.teamNearHasTeamPlayerSelected.leaderName;
                        } else {
                            if (teamDataProxy.teamNearNoTeamPlayerSelected){
                                _local2 = teamDataProxy.teamNearNoTeamPlayerSelected.Name;
                            };
                        };
                    } else {
                        if (teamDataProxy.curPage == 1){
                            if (teamDataProxy.teamMemSelected){
                                _local2 = teamDataProxy.teamMemSelected.Name;
                            } else {
                                if (teamDataProxy.teamReqSelected){
                                    _local2 = teamDataProxy.teamReqSelected.Name;
                                };
                            };
                        };
                    };
                    if (((_local2) && (!((_local2 == ""))))){
                        if (_local2 != GameCommonData.Player.Role.Name){
                            facade.sendNotification(ChatEvents.QUICKCHAT, _local2);
                        } else {
                            MessageTip.show(LanguageMgr.GetTranslation("组队提示3"));
                        };
                    } else {
                        MessageTip.show(LanguageMgr.GetTranslation("组队提示4"));
                    };
                    break;
                case teamModelManager.giveCaptainBtn:
                    if (teamDataProxy.teamMemSelected == null){
                        MessageTip.show(LanguageMgr.GetTranslation("组队提示5"));
                        return;
                    };
                    facade.sendNotification(EventList.CHANGELEADERTEAMCOMMON, {id:teamDataProxy.teamMemSelected.Id});
                    break;
                case teamModelManager.levelTeamBtn:
                    leaveTeam();
                    break;
                case teamModelManager.acceptJoinBtn:
                    if (teamDataProxy.teamReqSelected){
                        applyAccept(teamDataProxy.teamReqSelected.Id);
                    };
                    break;
                case teamModelManager.refushBtn:
                    TeamSend.RefushAroundTeam();
                    break;
                case teamModelManager.sendInviteBtn:
                    if (teamDataProxy.teamNearNoTeamPlayerSelected){
                        TeamSend.InviteOther(teamDataProxy.teamNearNoTeamPlayerSelected.Id);
                    };
                    break;
                case teamModelManager.sendApplyBtn:
                    if (teamDataProxy.teamNearHasTeamPlayerSelected){
                        TeamSend.ApplyJoin(teamDataProxy.teamNearHasTeamPlayerSelected.teamId);
                    };
                    break;
                case teamModelManager.createTeamBtn:
                    TeamSend.CreateTeam();
                    break;
                case teamModelManager.sendTeamToChatBtn:
                    if (GameCommonData.Player.Role.idTeam == 0){
                        MessageTip.popup(LanguageMgr.GetTranslation("组队提示6"));
                        return;
                    };
                    if (GameCommonData.Player.Role.idTeamLeader != GameCommonData.Player.Role.Id){
                        MessageTip.popup(LanguageMgr.GetTranslation("组队提示7"));
                        return;
                    };
                    if (team.tf_sendtochat.text == ""){
                        MessageTip.popup(LanguageMgr.GetTranslation("组队提示8"));
                        return;
                    };
                    _local3 = "";
                    _local3 = (_local3 + team.tf_sendtochat.text);
                    _local3 = (_local3 + LanguageMgr.GetTranslation("队长发言", GameCommonData.Player.Role.idTeam));
                    ChatData.TeamerChat = _local3;
                    facade.sendNotification(ChatEvents.TEAMER_CHAT);
                    team.tf_sendtochat.text = "";
                    break;
            };
        }
        private function applyRefuse(_arg1:int):void{
            var _local2:String;
            for (_local2 in teamDataProxy.teamReqList) {
                if (teamDataProxy.teamReqList[_local2].Id == _arg1){
                    teamDataProxy.teamReqList.splice(_local2, 1);
                };
            };
            TeamSend.RecallApply(_arg1, 0);
            sendNotification(TeamEventName.UPDATE_JOINTREQUEST_LIST);
        }
        private function removeReqItem():void{
            teamDataProxy.teamReqItemList[(teamDataProxy.teamReqItemList.length - 1)].removeEventListener(MouseEvent.CLICK, itemClickHanler);
            team.removeChild(teamDataProxy.teamReqItemList[(teamDataProxy.teamReqItemList.length - 1)]);
            teamDataProxy.teamReqItemList.pop();
        }
        private function memberInviteSomeone():void{
            var teamId:* = 0;
            teamId = inviteDataArr[0].teamId;
            var leaderName:* = inviteDataArr[0].leaderName;
//            with ({}) {
//                {}.applyInvite = function ():void{
//                    inviteDataArr.shift();
//                    TeamSend.RecallInvite(teamId, 1);
//                    if (inviteDataArr.length > 0){
//                        memberInviteSomeone();
//                    };
//                };
//            };//geoffyan
            var applyInvite:* = function ():void{
                inviteDataArr.shift();
                TeamSend.RecallInvite(teamId, 1);
                if (inviteDataArr.length > 0){
                    memberInviteSomeone();
                };
            };
//            with ({}) {
//                {}.refuseInvite = function ():void{
//                    inviteDataArr.shift();
//                    TeamSend.RecallInvite(teamId, 0);
//                    if (inviteDataArr.length > 0){
//                        memberInviteSomeone();
//                    };
//                };
//            };geoffyan
            var refuseInvite:* = function ():void{
                inviteDataArr.shift();
                TeamSend.RecallInvite(teamId, 0);
                if (inviteDataArr.length > 0){
                    memberInviteSomeone();
                };
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:applyInvite,
                cancel:refuseInvite,
                isShowClose:false,
                info:((("【" + leaderName) + "】") + LanguageMgr.GetTranslation("邀请你入队是否接受")),
                title:LanguageMgr.GetTranslation("提 示"),
                comfirmTxt:LanguageMgr.GetTranslation("接 受"),
                cancelTxt:LanguageMgr.GetTranslation("拒 绝")
            });
        }
        private function leaveTeam():void{
//            with ({}) {
//                {}.comfrimLeave = function ():void{
//                    TeamSend.LeaveTeam();
//                };
//            };//geoffyan
            var comfrimLeave:* = function ():void{
                TeamSend.LeaveTeam();
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:comfrimLeave,
                cancel:new Function(),
                info:LanguageMgr.GetTranslation("退出队伍询问"),
                title:LanguageMgr.GetTranslation("AlertDialog.Info")
            });
        }
        private function addLis():void{
            teamModelManager.addFriendBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.chatBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.refushBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.sendApplyBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.sendInviteBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.acceptJoinBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.giveCaptainBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.levelTeamBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.createTeamBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.autoJoinTeamBtn.addEventListener(MouseEvent.CLICK, __selectAutoJointModeHandler);
            teamModelManager.sendTeamToChatBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function onPanelCloseHandler():void{
            gc();
        }
        private function haveChange(_arg1:Array):Boolean{
            var _local2:int;
            var _local3:Boolean;
            var _local4:Array = teamDataProxy.teamMemberList;
            if (((!((_local4.length == _arg1.length))) || ((_arg1.length == 0)))){
                _local3 = true;
            } else {
                _local2 = 0;
                while (_local2 < _arg1.length) {
                    if (((!((_arg1[_local2].Id == _local4[_local2].Id))) || (!((_arg1[_local2].isLeader == _local4[_local2].isLeader))))){
                        _local3 = true;
                        break;
                    };
                    _local2++;
                };
            };
            return (_local3);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:Object;
            var _local4:TeamNetVo;
            var _local5:Object;
            var _local6:uint;
            var _local7:String;
            var _local8:Boolean;
            var _local9:Boolean;
            var _local10:int;
            var _local11:int;
            var _local12:Array;
            var _local13:FriendInfoStruct;
            var _local14:Object;
            var _local15:TeamPlayerVo;
            var _local16:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.TEAM
                    });
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    teamDataProxy = new TeamDataProxy();
                    facade.registerProxy(teamDataProxy);
                    facade.registerCommand(RefushNearPlayerTeamCommand.NAME, RefushNearPlayerTeamCommand);
                    teamModelManager = new TeamModelManager(team, teamDataProxy);
                    initView();
                    break;
                case EventList.REMOVETEAM:
                    gc();
                    break;
                case EventList.SHOWTEAM:
                    if (GameCommonData.IsInCrossServer){
                        return;
                    };
                    teamPanel.y = ((GameCommonData.GameInstance.ScreenHeight - teamPanel.height) / 2);
                    showTeam();
                    TeamSend.RefushAroundTeam();
                    break;
                case EventList.UPDATETEAM:
                    _local12 = (_arg1.getBody() as Array);
                    teamDataProxy.teamMemSelected = new TeamPlayerVo();
                    teamDataProxy.teamMemberList = _local12;
                    (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(GameCommonData.Player);
                    clearData();
                    update(teamDataProxy.curPage);
                    updateTeamPlayerInfo();
                    _local16 = 0;
                    while (_local16 < teamDataProxy.teamMemberList.length) {
                        _local13 = new FriendInfoStruct();
                        _local13.roleName = teamDataProxy.teamMemberList[_local16].Name;
                        _local13.frendId = teamDataProxy.teamMemberList[_local16].Id;
                        _local13.level = teamDataProxy.teamMemberList[_local16].Level;
                        _local13.isOnline = true;
                        facade.sendNotification(FriendCommandList.ADD_TEMP_FRIEND, _local13);
                        _local16++;
                    };
                    break;
                case TeamEventName.HAVEAPPLY:
                    if (((!(teamDataProxy.inviteIsOpen)) && (GameCommonData.Player.Role.isTeamLeader))){
                        sendNotification(EventList.TEAMBTNRAY);
                    };
                    break;
                case EventList.APPLYTEAM:
                    notiData = _arg1.getBody();
                    TeamSend.ApplyJoin(notiData.teamId);
                    break;
                case EventList.INVITETEAM:
                    notiData = _arg1.getBody();
                    TeamSend.InviteOther(notiData.id);
                    break;
                case TeamEventName.INVITETEAMBYNAME:
                    notiData = _arg1.getBody();
                    sendInviteFromChat();
                    break;
                case EventList.LEAVETEAMCOMMON:
                    leaveTeam();
                    break;
                case EventList.KICKOUTTEAMCOMMON:
                    notiData = _arg1.getBody();
                    kickOutMember(notiData.id);
                    break;
                case EventList.CHANGELEADERTEAMCOMMON:
                    notiData = _arg1.getBody();
                    TeamSend.ChgLeader(notiData.id);
                    break;
                case EventList.SETUPTEAMCOMMON:
                    TeamSend.CreateTeam();
                    break;
                case TeamEventName.MEMBERINVITESOMEONE:
                    _local14 = new Object();
                    _local14["teamId"] = _arg1.getBody()["teamId"];
                    _local14["leaderName"] = _arg1.getBody()["leaderName"];
                    inviteDataArr.push(_local14);
                    if (inviteDataArr.length == 1){
                        memberInviteSomeone();
                    };
                    break;
                case TeamEventName.SUPER_MAKE_TEAM_BY_NAME:
                    _local7 = String(_arg1.getBody());
                    if (_local7){
                    };
                    break;
                case TeamEventName.LEAVE_TEAM_AFTER_CHANGE_LINE:
                    changeLineClearData();
                    break;
                case TeamEventName.APPLY_REFUSE:
                    notiData = _arg1.getBody();
                    applyRefuse(notiData.id);
                    break;
                case TeamEventName.REFUSH_NEARTEAM:
                    if (teamDataProxy.curPage == 0){
                        update(0);
                    };
                    break;
                case TeamEventName.UPDATE_JOINTREQUEST_LIST:
                    update(teamDataProxy.curPage);
                    updateTeamPlayerInfo();
                    break;
                case EventList.DISBANDTEAMCOMMON:
                    disbandTeam();
                    break;
                case TeamEventName.REFUSH_TEAMUI:
                    update(teamDataProxy.curPage);
                    break;
                case TeamEventName.ADD_JOINTREQUEST:
                    _local15 = (_arg1.getBody() as TeamPlayerVo);
                    teamDataProxy.teamReqList.push(_local15);
                    setTimeout(removeJoinRequest, 30000, _local15);
                    sendNotification(TeamEventName.UPDATE_JOINTREQUEST_LIST, teamDataProxy.teamReqList);
                    break;
                case TeamEventName.REMOVE_JOINTREQUEST:
                    removeJoinRequest(_local15);
                    break;
            };
        }
        private function notiFan():void{
            sendNotification(PlayerInfoComList.UPDATE_TEAM);
        }
        private function changeLineClearData():void{
            var _local2:String;
            GameCommonData.Player.Role.idTeam = 0;
            GameCommonData.Player.Role.idTeamLeader = 0;
            GameCommonData.Player.Role.isTeamLeader = false;
            var _local1:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            for (_local2 in _local1.teamMemberList) {
                if (((_local1.teamMemberList[_local2]) && (GameCommonData.SameSecnePlayerList[_local1.teamMemberList[_local2].Id]))){
                    (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(GameCommonData.SameSecnePlayerList[_local1.teamMemberList[_local2].Id]);
                };
            };
            sendNotification(EventList.UPDATETEAM, []);
            _local1.teamMemberList = [];
            _local1.teamReqList = [];
            GameCommonData.Player.SetTeam(false);
            GameCommonData.Player.SetTeamLeader(false);
        }
        private function setReqItems():void{
            var _local1:MovieClip;
            var _local2:TeamItem;
            var _local3:int;
            var _local5:TeamPlayerVo;
            var _local7:FaceItem;
            var _local4:Array = teamDataProxy.teamReqList;
            var _local6:Dictionary = new Dictionary();
            teamDataProxy.teamReqItemList = [];
            while (_local3 < _local4.length) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TeamItem");
                _local2 = new TeamItem(_local1, _local3, TeamItem.TYPE_APPLY);
                _local2.name = ("teamReqItem_" + _local3);
                _local2.x = TEAMREQLITEM_STARTPOS.x;
                _local2.y = (TEAMREQLITEM_STARTPOS.y + (_local3 * _local1.height));
                _local2.addEventListener(MouseEvent.CLICK, itemClickHanler);
                _local5 = _local4[_local3];
                _local2.info = _local5;
                teamDataProxy.teamReqItemList.push(_local2);
                team.addChild(_local2);
                _local3++;
            };
        }
        private function disbandTeam():void{
//            with ({}) {
//                {}.comfrimDisband = function ():void{
//                    TeamSend.DisbandTeam();
//                };
//            };//geoffyan
            var comfrimDisband:* = function ():void{
                TeamSend.DisbandTeam();
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:comfrimDisband,
                cancel:new Function(),
                info:LanguageMgr.GetTranslation("解散队伍询问"),
                title:LanguageMgr.GetTranslation("AlertDialog.Info")
            });
        }
        private function update(_arg1:int):void{
            clearData();
            teamDataProxy.curPage = _arg1;
            if (_arg1 == 0){
                team["mcpage_0"].buttonMode = false;
                team["mcpage_1"].buttonMode = true;
                team["mcpage_0"].gotoAndStop(1);
                team["mcpage_1"].gotoAndStop(2);
                team["textpage_0"].textColor = 16496146;
                team["textpage_1"].textColor = 250597;
                setNearHasTeamItems();
                setNearNoTeamItems();
                teamModelManager.setModel(0);
            } else {
                if (_arg1 == 1){
                    team["mcpage_0"].buttonMode = true;
                    team["mcpage_1"].buttonMode = false;
                    team["mcpage_0"].gotoAndStop(2);
                    team["mcpage_1"].gotoAndStop(1);
                    team["textpage_0"].textColor = 250597;
                    team["textpage_1"].textColor = 16496146;
                    setMyTeamItems();
                    setReqItems();
                    teamModelManager.setModel(1);
                };
            };
            if (GameCommonData.Player.Role.idTeam > 0){
                teamModelManager.autoJoinTeamBtn.selected = teamDataProxy.autoAllowApplyTeamMode;
            } else {
                teamModelManager.autoJoinTeamBtn.selected = teamDataProxy.autoJoinMode;
            };
        }
        private function setNearHasTeamItems():void{
            var _local1:MovieClip;
            var _local2:TeamItemCell;
            var _local3:int;
            var _local5:FaceItem;
            var _local4:Array = teamDataProxy.teamNearHasTeamPlayerList;
            teamDataProxy.teamNearHasTeamPlayerItemList = [];
            while (_local3 < _local4.length) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TeamItem");
                _local2 = new TeamItemCell(_local1, _local3, TeamItem.TYPE_NEAR_HASTEAM);
                _local2.name = ("teamNearHasTeamItem_" + _local3);
                _local2.x = TEAMITEM_STARTPOS.x;
                _local2.y = (TEAMITEM_STARTPOS.y + (_local3 * _local1.height));
                _local2.addEventListener(MouseEvent.CLICK, itemClickHanler);
                _local2.info = _local4[_local3];
                teamDataProxy.teamNearHasTeamPlayerItemList.push(_local2);
                team.addChild(_local2);
                _local3++;
            };
        }
        private function initView():void{
            teamPanel = new HFrame();
            teamPanel.setSize(423, 510);
            team.x = -1;
            team.y = 3;
            teamPanel.addContent(team);
            teamPanel.titleText = LanguageMgr.GetTranslation("组队面板标题");
            teamPanel.centerTitle = true;
            teamPanel.blackGound = false;
            teamPanel.closeCallBack = onPanelCloseHandler;
            teamPanel.x = TEAMDEFAULTPOS.x;
            teamPanel.y = ((GameCommonData.GameInstance.ScreenHeight - teamPanel.height) / 2);
            team["mcpage_0"].buttonMode = false;
            team["mcpage_1"].buttonMode = true;
            team["mcpage_0"].gotoAndStop(1);
            team["mcpage_1"].gotoAndStop(2);
            team["textpage_0"].mouseEnabled = false;
            team["textpage_1"].mouseEnabled = false;
            team["mcpage_0"].addEventListener(MouseEvent.CLICK, __btnSelectPageHandler);
            team["mcpage_1"].addEventListener(MouseEvent.CLICK, __btnSelectPageHandler);
            if (GameCommonData.Player.Role.idTeam > 0){
                if (teamDataProxy.autoAllowApplyTeamMode){
                    teamModelManager.autoJoinTeamBtn.selected = true;
                } else {
                    teamModelManager.autoJoinTeamBtn.selected = false;
                };
            } else {
                if (teamDataProxy.autoJoinMode){
                    teamModelManager.autoJoinTeamBtn.selected = true;
                } else {
                    teamModelManager.autoJoinTeamBtn.selected = false;
                };
            };
            team.teamtextmm.gotoAndStop(1);
            team.tf_sendtochat.maxChars = 33;
        }
        private function gc():void{
            clearData();
            removeLis();
            if (GameCommonData.GameInstance.GameUI.contains(teamPanel)){
                teamPanel.close();
            };
            teamDataProxy.teamMemSelected = new TeamPlayerVo();
            teamDataProxy.teamReqSelected = new TeamPlayerVo();
            joinPlayerName = "";
            dataProxy.TeamIsOpen = false;
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
        }
        private function isFullTeam():Boolean{
            if (((teamDataProxy.teamMemberList) && ((teamDataProxy.teamMemberList.length == 5)))){
                return (true);
            };
            return (false);
        }
        private function removeJoinRequest(_arg1:TeamPlayerVo):void{
            if (teamDataProxy.teamReqList.indexOf(_arg1) != -1){
                teamDataProxy.teamReqList.splice(teamDataProxy.teamReqList.indexOf(_arg1), 1);
                sendNotification(TeamEventName.UPDATE_JOINTREQUEST_LIST, teamDataProxy.teamReqList);
            };
        }
        private function kickOutMember(_arg1:int):void{
            var memberName:* = null;
            var kickOutNet:* = null;
            var playerId:* = _arg1;
            var teamVoTT:* = null;
            for each (teamVoTT in teamDataProxy.teamMemberList) {
                if (teamVoTT.Id == playerId){
                    memberName = teamVoTT.Name;
                    break;
                };
            };
            kickOutNet = function ():void{
                var _local1:String;
                TeamSend.KickOut(playerId);
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:kickOutNet,
                cancel:new Function(),
                isShowClose:false,
                info:LanguageMgr.GetTranslation("踢除成员询问", memberName),
                title:LanguageMgr.GetTranslation("AlertDialog.Info"),
                comfirmTxt:LanguageMgr.GetTranslation("ok"),
                cancelTxt:LanguageMgr.GetTranslation("cancel")
            });
        }
        private function isMemberById(_arg1:int):Boolean{
            var _local3:int;
            var _local2:Boolean;
            while (_local3 < teamDataProxy.teamMemberList.length) {
                if (_arg1 == teamDataProxy.teamMemberList[_local3].id){
                    _local2 = true;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWTEAM, EventList.UPDATETEAM, EventList.ASKTEAMINFO, EventList.REMOVETEAM, TeamEventName.HAVAINVITE, TeamEventName.HAVEAPPLY, EventList.APPLYTEAM, EventList.INVITETEAM, EventList.LEAVETEAMCOMMON, EventList.KICKOUTTEAMCOMMON, EventList.CHANGELEADERTEAMCOMMON, EventList.SETUPTEAMCOMMON, TeamEventName.MEMBERINVITESOMEONE, TeamEventName.SHOWTEAMINFORMATION, TeamEventName.INVITETEAMBYNAME, TeamEventName.SUPER_MAKE_TEAM_BY_NAME, TeamEventName.LEAVE_TEAM_AFTER_CHANGE_LINE, TeamEventName.APPLY_REFUSE, TeamEventName.REFUSH_NEARTEAM, TeamEventName.UPDATE_JOINTREQUEST_LIST, EventList.DISBANDTEAMCOMMON, TeamEventName.REFUSH_TEAMUI, TeamEventName.ADD_JOINTREQUEST, TeamEventName.REMOVE_JOINTREQUEST]);
        }
        private function isMember(_arg1:String):Boolean{
            var _local2:Boolean;
            var _local3:int;
            while (_local3 < teamDataProxy.teamMemberList.length) {
                if (teamDataProxy.teamMemberList[_local3].Name == _arg1){
                    _local2 = true;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        private function setMyTeamItems():void{
            var _local1:MovieClip;
            var _local2:TeamItem;
            var _local3:int;
            var _local5:TeamPlayerVo;
            var _local6:FaceItem;
            var _local4:Array = teamDataProxy.teamMemberList;
            teamDataProxy.teamMemItemList = [];
            while (_local3 < _local4.length) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TeamItem");
                _local2 = new TeamItem(_local1, _local3, TeamItem.TYPE_MEMBER);
                _local2.name = ("teamMemItem_" + _local3);
                _local2.x = TEAMITEM_STARTPOS.x;
                _local2.y = (TEAMITEM_STARTPOS.y + (_local3 * _local1.height));
                _local2.addEventListener(MouseEvent.CLICK, itemClickHanler);
                _local5 = _local4[_local3];
                _local2.info = _local5;
                if (_local5.isLeader){
                    _local2.setLeaderMc(true);
                };
                teamDataProxy.teamMemItemList.push(_local2);
                team.addChild(_local2);
                _local3++;
            };
        }
        private function removeLis():void{
            teamModelManager.addFriendBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.chatBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.refushBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.sendApplyBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.sendInviteBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.acceptJoinBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.giveCaptainBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.levelTeamBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            teamModelManager.autoJoinTeamBtn.removeEventListener(Event.CHANGE, __selectAutoJointModeHandler);
            teamModelManager.sendTeamToChatBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function sendInviteFromChat():void{
            var _local1:String = notiData.name;
            if (((((teamDataProxy.teamMemberList[0]) && (teamDataProxy.teamMemberList[0].id))) && ((teamDataProxy.teamMemberList[0].id == GameCommonData.Player.Role.Id)))){
                if (isMember(_local1)){
                    MessageTip.show(LanguageMgr.GetTranslation("组队提示9"));
                } else {
                    if (isFullTeam()){
                        MessageTip.show(LanguageMgr.GetTranslation("组队提示10"));
                    };
                };
            } else {
                if (teamDataProxy.teamMemberList.length == 0){
                } else {
                    if (isMember(_local1)){
                        MessageTip.show(LanguageMgr.GetTranslation("组队提示9"));
                    } else {
                        if (isFullTeam()){
                            MessageTip.show(LanguageMgr.GetTranslation("组队提示10"));
                        };
                    };
                };
            };
        }
        private function get team():MovieClip{
            return ((viewComponent as MovieClip));
        }
        private function itemClickHanler(_arg1:MouseEvent):void{
            var _local4:int;
            var _local5:Object;
            var _local2:String = _arg1.currentTarget.name.split("_")[0];
            var _local3:int = int(_arg1.currentTarget.name.split("_")[1]);
            _local4 = 0;
            while (_local4 < teamDataProxy.teamMemItemList.length) {
                _local5 = teamDataProxy.teamMemItemList[_local4];
                _local5.item.mcMouseDown.visible = false;
                _local4++;
            };
            _local4 = 0;
            while (_local4 < teamDataProxy.teamReqItemList.length) {
                _local5 = teamDataProxy.teamReqItemList[_local4];
                _local5.item.mcMouseDown.visible = false;
                _local4++;
            };
            _local4 = 0;
            while (_local4 < teamDataProxy.teamNearHasTeamPlayerItemList.length) {
                _local5 = teamDataProxy.teamNearHasTeamPlayerItemList[_local4];
                _local5.item.mcMouseDown.visible = false;
                _local4++;
            };
            _local4 = 0;
            while (_local4 < teamDataProxy.teamNearNoTeamPlayerItemList.length) {
                _local5 = teamDataProxy.teamNearNoTeamPlayerItemList[_local4];
                _local5.item.mcMouseDown.visible = false;
                _local4++;
            };
            teamDataProxy.teamMemSelected = null;
            teamDataProxy.teamReqSelected = null;
            teamDataProxy.teamNearHasTeamPlayerSelected = null;
            teamDataProxy.teamNearNoTeamPlayerSelected = null;
            if (_local2 == "teamMemItem"){
                _arg1.currentTarget.item.mcMouseDown.visible = true;
                teamDataProxy.teamMemSelected = teamDataProxy.teamMemberList[_local3];
            } else {
                if (_local2 == "teamReqItem"){
                    _arg1.currentTarget.item.mcMouseDown.visible = true;
                    teamDataProxy.teamReqSelected = teamDataProxy.teamReqList[_local3];
                } else {
                    if (_local2 == "teamNearHasTeamItem"){
                        _arg1.currentTarget.item.mcMouseDown.visible = true;
                        teamDataProxy.teamNearHasTeamPlayerSelected = teamDataProxy.teamNearHasTeamPlayerList[_local3];
                    } else {
                        if (_local2 == "teamNearNoTeamItem"){
                            _arg1.currentTarget.item.mcMouseDown.visible = true;
                            teamDataProxy.teamNearNoTeamPlayerSelected = teamDataProxy.teamNearNoTeamPlayerList[_local3];
                        };
                    };
                };
            };
        }
        private function showTeam():void{
            GameCommonData.GameInstance.GameUI.addChild(teamPanel);
            addLis();
            team.tf_sendtochat.text = "";
            dataProxy.TeamIsOpen = true;
            if ((((teamDataProxy.teamReqList.length > 0)) || ((GameCommonData.Player.Role.idTeam > 0)))){
                update(1);
                team.teamtextmm.gotoAndStop(2);
            } else {
                update(0);
                team.teamtextmm.gotoAndStop(1);
            };
        }

    }
}//package GameUI.Modules.Team.Mediator 
