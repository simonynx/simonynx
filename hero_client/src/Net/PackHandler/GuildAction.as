//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import OopsEngine.Role.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.Unity.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;

    public class GuildAction extends GameAction {

        private static var _instance:GuildAction;
        private static var fbNoticeId:uint = 0;

        public static function getInstance():GuildAction{
            if (!_instance){
                _instance = new (GuildAction)();
            };
            return (_instance);
        }

        private function disbandResult(_arg1:NetPacket):void{
            facade.sendNotification(EventList.CLOSEUNITYVIEW);
        }
        private function response(_arg1:NetPacket):void{
            var _local2:int;
            var _local3:Boolean;
            var _local4:GuildPlayerInfo;
            var _local5:int;
            var _local6:String;
            var _local7:int;
            var _local8:Boolean;
            var _local9:String;
            var _local10:NewInfoTipVo;
            var _local11:int;
            var _local12:String;
            var _local13:int;
            var _local14:GuildPlayerInfo;
            var _local15:uint;
            var _local16:GuildEventInfo;
            var _local17:Array;
            var _local18:int;
            var _local19:String;
            var _local20:String;
            var _local21:int;
            var _local22:uint;
            var _local23:uint;
            var _local24:uint;
            var _local25:uint;
            var _local26:*;
            _local2 = _arg1.readUnsignedInt();
            switch (_local2){
                case 1:
                    _local3 = ((_arg1.readUnsignedInt() == 1)) ? true : false;
                    _local4 = new GuildPlayerInfo();
                    _local4.PlayerId = _arg1.readUnsignedInt();
                    _local5 = _arg1.readUnsignedInt();
                    _local6 = _arg1.ReadString();
                    _local4.NickName = _arg1.ReadString();
                    _local4.DutyID = _arg1.readUnsignedInt();
                    _local4.DutyLevel = _arg1.readUnsignedInt();
                    _local4.DutyName = _arg1.ReadString();
                    _local4.Level = _arg1.readUnsignedInt();
                    _local4.IsOnline = ((_arg1.readUnsignedInt() == 1)) ? true : false;
                    _local4.LastLoginTime = _arg1.ReadString();
                    _local4.Job = _arg1.readUnsignedInt();
                    UnityConstData.allMenberList.push(_local4);
                    if (_local4.PlayerId == GameCommonData.Player.Role.Id){
                        MessageTip.show(LanguageMgr.GetTranslation("你加入了公会"));
                        GameCommonData.Player.Role.unityId = _local5;
                        GuildSend.getMemberList(GameCommonData.Player.Role.unityId);
                        facade.sendNotification(EventList.CLOSEUNITYVIEW);
                        facade.sendNotification(EventList.SHOWUNITYVIEW);
                        facade.sendNotification(EventList.UPDATE_TARGET_TIMES, {1:0});
                    } else {
                        MessageTip.show((_local4.NickName + LanguageMgr.GetTranslation("加入了公会")));
                        ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", (_local4.NickName + LanguageMgr.GetTranslation("加入了公会")));
                    };
                    UnityConstData.myGuildInfo = null;
                    GuildSend.getMyGuildInfo();
                    GuildSend.GetGuildAuras();
                    GuildSend.getDutyList();
                    GuildSend.GetGuildEventsList();
                    GuildSend.GuildGB_GetApplyList();
                    facade.sendNotification(UnityEvent.UPDATE_MEMBER, _local4);
                    break;
                case 2:
                    GameCommonData.Player.Role.unityId = 0;
                    UnityConstData.allMenberList = [];
                    UnityConstData.GuildEventList = [];
                    UnityConstData.ApplyDataList = [];
                    UnityConstData.GuildBattle_ApplyTargetGuildID = 0;
                    facade.sendNotification(EventList.CLOSEUNITYVIEW);
                    MessageTip.popup(LanguageMgr.GetTranslation("公会解散成功"));
                    if (GameCommonData.GuildBattle_IsStarting){
                        facade.sendNotification(UnityEvent.GUILDGB_OVER);
                    };
                    GameCommonData.Player.Role.GuildName = "";
                    GameCommonData.Player.setGuildName(GameCommonData.Player.Role.GuildName);
                    GameCommonData.Player.hideGuildName();
                    break;
                case 3:
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readBoolean();
                    _local9 = _arg1.ReadString();
                    if (_local7 == GameCommonData.Player.Role.Id){
                        if (_local8){
                            MessageTip.show(LanguageMgr.GetTranslation("你被踢除出公会"));
                            ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", LanguageMgr.GetTranslation("你被踢除出公会"));
                        } else {
                            MessageTip.show(LanguageMgr.GetTranslation("你退出了公会"));
                            ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", LanguageMgr.GetTranslation("你退出了公会"));
                        };
                        GameCommonData.Player.Role.unityId = 0;
                        UnityConstData.allMenberList = [];
                        UnityConstData.GuildEventList = [];
                        UnityConstData.ApplyDataList = [];
                        UnityConstData.GuildBattle_ApplyTargetGuildID = 0;
                        GameCommonData.Player.Role.GuildName = "";
                        GameCommonData.Player.setGuildName(GameCommonData.Player.Role.GuildName);
                        GameCommonData.Player.hideGuildName();
                        if (GameCommonData.GuildBattle_IsStarting){
                            facade.sendNotification(UnityEvent.GUILDGB_OVER);
                        };
                        facade.sendNotification(EventList.CLOSEUNITYVIEW);
                    } else {
                        if (_local8){
                            MessageTip.show((_local9 + LanguageMgr.GetTranslation("被踢除出公会")));
                            ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", (_local9 + LanguageMgr.GetTranslation("被踢除出公会")));
                        } else {
                            MessageTip.show((_local9 + LanguageMgr.GetTranslation("退出了公会")));
                            ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", (_local9 + LanguageMgr.GetTranslation("退出了公会")));
                        };
                        _local21 = 0;
                        while (_local21 < UnityConstData.allMenberList.length) {
                            if (_local7 == UnityConstData.allMenberList[_local21].PlayerId){
                                UnityConstData.allMenberList.splice(_local21, 1);
                                break;
                            };
                            _local21++;
                        };
                        UnityConstData.myGuildInfo.Count--;
                        facade.sendNotification(UnityEvent.UPDATE_MEMBER);
                    };
                    break;
                case 4:
                    _local5 = _arg1.readUnsignedInt();
                    _local6 = _arg1.ReadString();
                    _local10 = new NewInfoTipVo();
                    _local10.title = ((("【" + _local6) + "】") + LanguageMgr.GetTranslation("邀请你加入公会"));
                    _local10.type = NewInfoTipType.TYPE_GUILDINVITE;
                    _local10.data = {
                        guildId:_local5,
                        guildName:_local6
                    };
                    _local10.addTime = TimeManager.Instance.Now().time;
                    sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local10);
                    break;
                case 5:
                    break;
                case 6:
                    UnityConstData.myGuildInfo.Level = _arg1.readUnsignedInt();
                    UnityConstData.myGuildInfo.BuildValue = _arg1.readUnsignedInt();
                    UnityConstData.myGuildInfo.MaxCount = UnityConstData.MaxMemberCntDic[UnityConstData.myGuildInfo.Level];
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", ((LanguageMgr.GetTranslation("公会等级升至") + UnityConstData.myGuildInfo.Level) + LanguageMgr.GetTranslation("级")));
                    facade.sendNotification(UnityEvent.UPDATE_MYGUILDINFO);
                    break;
                case 7:
                    _local2 = _arg1.readUnsignedInt();
                    switch (_local2){
                        case 1:
                            MessageTip.show(LanguageMgr.GetTranslation("二级职位最多5人"));
                            break;
                        case 2:
                            MessageTip.show(LanguageMgr.GetTranslation("你暂时被公会禁言"));
                            break;
                    };
                    break;
                case 8:
                    _local7 = _arg1.readUnsignedInt();
                    _local11 = _arg1.readUnsignedInt();
                    _local12 = _arg1.ReadString();
                    _local13 = _arg1.readUnsignedInt();
                    _local9 = "";
                    _local21 = 0;
                    while (_local21 < UnityConstData.allMenberList.length) {
                        if (_local7 == UnityConstData.allMenberList[_local21].PlayerId){
                            (UnityConstData.allMenberList[_local21] as GuildPlayerInfo).DutyLevel = _local11;
                            (UnityConstData.allMenberList[_local21] as GuildPlayerInfo).DutyName = _local12;
                            _local14 = (UnityConstData.allMenberList[_local21] as GuildPlayerInfo);
                            _local9 = _local14.NickName;
                            if (_local11 == 1){
                                ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", (((UnityConstData.myGuildInfo.ChairmanName + LanguageMgr.GetTranslation("将公会转让给")) + _local14.NickName) + "！"));
                                UnityConstData.myGuildInfo.ChairmanName = _local14.NickName;
                            };
                            break;
                        };
                        _local21++;
                    };
                    if (_local7 == GameCommonData.Player.Role.Id){
                        GameCommonData.Player.Role.GuildDutyLevel = _local11;
                        GameCommonData.Player.Role.GuildDutyName = _local12;
                        MessageTip.show((LanguageMgr.GetTranslation("你的职位调整为") + _local12));
                        ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", ("你的职位调整为" + _local12));
                    } else {
                        if (_local9 != ""){
                            MessageTip.show(((_local9 + LanguageMgr.GetTranslation("x的职位调整为y")) + _local12));
                            ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", ((_local9 + LanguageMgr.GetTranslation("x的职位调整为y")) + _local12));
                        };
                    };
                    facade.sendNotification(UnityEvent.UPDATE_MEMBER, _local14);
                    break;
                case 9:
                    _local7 = _arg1.readUnsignedInt();
                    _local15 = _arg1.readUnsignedInt();
                    UnityConstData.myGuildInfo.BuildValue = (UnityConstData.myGuildInfo.BuildValue + _local15);
                    facade.sendNotification(UnityEvent.UPDATE_MYGUILDINFO);
                    _local21 = 0;
                    while (_local21 < UnityConstData.allMenberList.length) {
                        if (_local7 == UnityConstData.allMenberList[_local21].PlayerId){
                            UnityConstData.allMenberList[_local21].BuildValue = (UnityConstData.allMenberList[_local21].BuildValue + _local15);
                            UnityConstData.allMenberList[_local21].BuildValue_Today = (UnityConstData.allMenberList[_local21].BuildValue_Today + _local15);
                            _local14 = (UnityConstData.allMenberList[_local21] as GuildPlayerInfo);
                            break;
                        };
                        _local21++;
                    };
                    facade.sendNotification(RoleEvents.UPDATE_ROLEOFFER);
                    facade.sendNotification(UnityEvent.UPDATE_MEMBER, _local14);
                    break;
                case 10:
                    _local16 = new GuildEventInfo();
                    _local16.ID = _arg1.readUnsignedInt();
                    _local16.GuildID = GameCommonData.Player.Role.unityId;
                    _local16.Date = _arg1.ReadString();
                    _local16.Type = _arg1.readUnsignedInt();
                    _local16.Des = _arg1.ReadString();
                    _local17 = UnityConstData.GuildEventList;
                    UnityConstData.GuildEventList.unshift(_local16);
                    if (UnityConstData.GuildEventList.length > 20){
                        UnityConstData.GuildEventList.splice(20, (UnityConstData.GuildEventList.length - 20));
                    };
                    facade.sendNotification(UnityEvent.UPDATE_GUILDEVENTINFO);
                    break;
                case 11:
                    UnityConstData.GuildFB_CrossMode = _arg1.readUnsignedInt();
                    break;
                case 12:
                    _local18 = _arg1.readUnsignedByte();
                    if (_local18 == 0){
                        _local22 = _arg1.readUnsignedInt();
                        _local23 = _arg1.readUnsignedInt();
                        UnityConstData.myGuildInfo.BuildValue = _local23;
                        if (GameCommonData.GuildSkillsList[_local22]){
                            GameCommonData.GuildSkillsList[_local22].isLearn = true;
                        };
                        facade.sendNotification(UnityEvent.UPDATE_MYGUILDINFO);
                        facade.sendNotification(UnityEvent.UPDATE_GUILDSKILL);
                    } else {
                        if (_local18 == 1){
                            MessageTip.popup(LanguageMgr.GetTranslation("建设值不够"));
                        } else {
                            if (_local18 == 2){
                                MessageTip.popup(LanguageMgr.GetTranslation("公会等级不够"));
                            } else {
                                if (_local18 == 3){
                                    MessageTip.popup(LanguageMgr.GetTranslation("其他原因错误"));
                                };
                            };
                        };
                    };
                    break;
                case 13:
                    _local18 = _arg1.readUnsignedByte();
                    if (_local18 == 0){
                        _local24 = _arg1.readUnsignedInt();
                        _local25 = _arg1.readUnsignedInt();
                        _local23 = _arg1.readUnsignedInt();
                        UnityConstData.myGuildInfo.BuildValue = _local23;
                        _local26 = {};
                        _local26.idUser = GameCommonData.Player.Role.Id;
                        _local26.magicid = _local24;
                        _local26.privateTotalCdTime = (_local25 * 1000);
                        _local26.privateCdTime = _local26.privateTotalCdTime;
                        _local26.startCdTime = TimeManager.Instance.Now().time;
                        UnityConstData.CurrentGuildSkillCDList[int((_local24 / 100))] = _local26;
                        if ((((_local26.privateCdTime > 0)) && (((_local26.privateTotalCdTime - _local26.privateCdTime) >= 0)))){
                            sendNotification(EventList.RECEIVE_CD_GUILDSKILL, _local26);
                        };
                        facade.sendNotification(UnityEvent.UPDATE_MYGUILDINFO);
                        facade.sendNotification(UnityEvent.UPDATE_GUILDSKILL);
                    } else {
                        if (_local18 == 1){
                            MessageTip.popup(LanguageMgr.GetTranslation("公会技能还在冷却"));
                        } else {
                            if (_local18 == 2){
                                MessageTip.popup(LanguageMgr.GetTranslation("建设值不够"));
                            } else {
                                if (_local18 == 3){
                                    MessageTip.popup(LanguageMgr.GetTranslation("其他原因错误"));
                                };
                            };
                        };
                    };
                    break;
                case 14:
                    _local19 = _arg1.ReadString();
                    GameCommonData.Player.Role.GuildName = (UnityConstData.myGuildInfo.GuildName = _local19);
                    GameCommonData.Player.setGuildName(GameCommonData.Player.Role.GuildName);
                    for (_local20 in GameCommonData.SameSecnePlayerList) {
                        if (((((GameCommonData.SameSecnePlayerList[_local20]) && ((GameCommonData.SameSecnePlayerList[_local20].Role.Type == GameRole.TYPE_PLAYER)))) && ((GameCommonData.SameSecnePlayerList[_local20].Role.unityId == GameCommonData.Player.Role.unityId)))){
                            GameCommonData.SameSecnePlayerList[_local20].Role.GuildName = _local19;
                            GameCommonData.SameSecnePlayerList[_local20].setGuildName(_local19);
                        };
                    };
                    facade.sendNotification(UnityEvent.GETINFO);
                    break;
                case 15:
                    guildBattleResponse(_arg1);
                    break;
            };
        }
        private function updateGuildOnlineState(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Boolean = _arg1.readBoolean();
            var _local4:GuildPlayerInfo = UnityConstData.getGuildPlayerInfoById(_local2);
            if (_local4){
                _local4.IsOnline = _local3;
                facade.sendNotification(UnityEvent.UPDATE_MEMBER, _local4);
            };
        }
        private function guildBattleResponse(_arg1:NetPacket):void{
            var _local3:GuildInfo;
            var _local4:int;
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:Object;
            var _local10:Array;
            var _local11:int;
            var _local2:int = _arg1.readUnsignedInt();
            switch (_local2){
                case 1:
                    MessageTip.show(LanguageMgr.GetTranslation("公会挑战申请超时"));
                    UnityConstData.GuildBattle_ApplyTargetGuildID = 0;
                    break;
                case 2:
                    MessageTip.show(LanguageMgr.GetTranslation("公会挑战等待超时"));
                    break;
                case 3:
                    _local3 = new GuildInfo();
                    _local3.GuildId = _arg1.readUnsignedInt();
                    _local3.GuildName = _arg1.ReadString();
                    _local3.ChairmanName = _arg1.ReadString();
                    _local3.Level = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_ApplyList.push(_local3);
                    facade.sendNotification(UnityEvent.UPDATE_GUILDGBAPPLYLIST);
                    break;
                case 4:
                    _local4 = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_ApplyTargetGuildID = _local4;
                    facade.sendNotification(UnityEvent.UPDATEUNITYDATA, [UnityConstData.allUnityList, 1]);
                    break;
                case 5:
                    MessageTip.show(LanguageMgr.GetTranslation("公会挑战被拒绝了"));
                    UnityConstData.GuildBattle_ApplyTargetGuildID = 0;
                    facade.sendNotification(UnityEvent.UPDATEUNITYDATA, [UnityConstData.allUnityList, 1]);
                    break;
                case 6:
                    _local4 = _arg1.readUnsignedInt();
                    _local11 = 0;
                    while (_local11 < UnityConstData.GuildBattle_ApplyList.length) {
                        if (UnityConstData.GuildBattle_ApplyList[_local11].GuildId == _local4){
                            UnityConstData.GuildBattle_ApplyList.splice(_local11, 1);
                            break;
                        };
                        _local11++;
                    };
                    _local5 = UnityConstData.GuildBattle_ApplyList;
                    facade.sendNotification(UnityEvent.UPDATE_GUILDGBAPPLYLIST);
                    break;
                case 7:
                    UnityConstData.GuildBattle_StartTime = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_TargetGuildID = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_TargetGuildName = _arg1.ReadString();
                    facade.sendNotification(UnityEvent.GUILDGB_START);
                    UnityConstData.GuildBattle_ApplyList = [];
                    facade.sendNotification(UnityEvent.UPDATE_GUILDGBAPPLYLIST);
                    break;
                case 8:
                case 10:
                    _local6 = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_SelfKillCnt = _local6;
                    _local7 = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_EnemyKillCnt = _local7;
                    _local8 = _arg1.readUnsignedInt();
                    _local10 = [];
                    _local11 = 0;
                    while (_local11 < _local8) {
                        _local9 = {
                            playerId:_arg1.readUnsignedInt(),
                            nickName:_arg1.ReadString(),
                            killCnt:_arg1.readUnsignedInt(),
                            EdKillCnt:_arg1.readUnsignedInt()
                        };
                        _local10.push(_local9);
                        _local11++;
                    };
                    UnityConstData.GuildBattle_PlayerInfoRankList = _local10;
                    if (_local2 == 10){
                        MessageTip.popup(LanguageMgr.GetTranslation("公会挑战结束"));
                        facade.sendNotification(UnityEvent.GUILDGB_OVER);
                        UnityConstData.GuildBattle_ApplyTargetGuildID = 0;
                    };
                    break;
                case 9:
                    UnityConstData.GuildBattle_MyKillCnt = _arg1.readUnsignedInt();
                    UnityConstData.GuildBattle_MyEdKillCnt = _arg1.readUnsignedInt();
                    break;
            };
        }
        private function openGuildFBHandler(_arg1:NetPacket):void{
            var _local2:String;
            UnityConstData.GuildFBOpenTime = _arg1.readUnsignedInt();
            UnityConstData.GuildFB_Line = _arg1.readByte();
            if (fbNoticeId > 0){
                clearInterval(fbNoticeId);
            };
            if (UnityConstData.GuildFB_Line > 0){
                fbNoticeId = setInterval(startFBNotice, 60000);
                _local2 = LanguageMgr.GetTranslation("公会副本在x线开", UnityConstData.GuildFB_Line);
                MessageTip.popup(_local2);
                MessageTip.show(_local2);
                startFBNotice();
            };
            facade.sendNotification(UnityEvent.UPDATE_GUILDFBVIEW);
        }
        private function inviteResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            MessageTip.show(_arg1.ReadString());
        }
        private function guildBattleResult(_arg1:NetPacket):void{
            var _local3:GuildInfo;
            var _local6:String;
            UnityConstData.GuildBattle_ApplyTargetGuildID = _arg1.readUnsignedInt();
            var _local2:int = _arg1.readUnsignedInt();
            var _local4:Array = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local3 = new GuildInfo();
                _local3.GuildId = _arg1.readUnsignedInt();
                _local3.GuildName = _arg1.ReadString();
                _local3.ChairmanName = _arg1.ReadString();
                _local3.Level = _arg1.readUnsignedInt();
                _local4.push(_local3);
                _local5++;
            };
            UnityConstData.GuildBattle_ApplyList = _local4;
            facade.sendNotification(UnityEvent.UPDATE_GUILDGBAPPLYLIST);
            UnityConstData.GuildBattle_TargetGuildID = _arg1.readUnsignedInt();
            if (UnityConstData.GuildBattle_TargetGuildID > 0){
                _local6 = _arg1.ReadString();
                UnityConstData.GuildBattle_TargetGuildName = _local6;
                UnityConstData.GuildBattle_StartTime = _arg1.readUnsignedInt();
                if (UnityConstData.GuildBattle_StartTime > 0){
                    facade.sendNotification(UnityEvent.GUILDGB_START);
                };
            };
        }
        private function getDutyList(_arg1:NetPacket):void{
            var _local4:GuildDutyInfo;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:Array = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local4 = new GuildDutyInfo();
                _local4.DutyID = _arg1.readUnsignedInt();
                _local4.GuildID = _arg1.readUnsignedInt();
                _local4.DutyName = _arg1.ReadString();
                _local4.Right = _arg1.readUnsignedInt();
                _local4.Level = _arg1.readUnsignedInt();
                _local3.push(_local4);
                _local5++;
            };
            UnityConstData.DutyList = _local3;
        }
        private function ApplyResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            switch (_local3){
                case 0:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("公会不存在了"),
                        color:0xFFFF00
                    });
                    break;
                case 1:
                    MessageTip.popup(LanguageMgr.GetTranslation("已经申请过了"));
                    break;
                case 2:
                    MessageTip.popup(LanguageMgr.GetTranslation("申请成功"));
                    break;
                case 3:
                    MessageTip.popup(LanguageMgr.GetTranslation("该公会不开放申请"));
                    break;
                case 4:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("公会人数已满"),
                        color:0xFFFF00
                    });
                    break;
            };
        }
        private function getMemberList(_arg1:NetPacket):void{
            var _local4:GuildPlayerInfo;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:Array = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local4 = new GuildPlayerInfo();
                _local4.PlayerId = _arg1.readUnsignedInt();
                _local4.DutyID = _arg1.readUnsignedInt();
                _local4.DutyName = _arg1.ReadString();
                _local4.NickName = _arg1.ReadString();
                _local4.Permissions = _arg1.readUnsignedInt();
                _local4.DutyLevel = _arg1.readUnsignedInt();
                _local4.IsOnline = ((_arg1.readUnsignedInt() == 0)) ? false : true;
                _local4.LastLoginTime = _arg1.ReadString();
                _local4.Level = _arg1.readUnsignedInt();
                _local4.Sex = _arg1.readUnsignedInt();
                _local4.BuildValue = _arg1.readUnsignedInt();
                _local4.BuildValue_Today = _arg1.readUnsignedInt();
                _local4.Job = _arg1.readUnsignedInt();
                _local4.BanChatFlag = _arg1.readUnsignedInt();
                _local3.push(_local4);
                _local5++;
            };
            UnityConstData.allMenberList = _local3;
            facade.sendNotification(UnityEvent.GETMENBERLIST, _local3);
        }
        private function applyRecallPass(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int;
            while (_local3 < UnityConstData.ApplyDataList.length) {
                if (UnityConstData.ApplyDataList[_local3].PlayerId == _local2){
                    UnityConstData.ApplyDataList.splice(_local3, 1);
                    break;
                };
                _local3++;
            };
            facade.sendNotification(UnityEvent.DELETE_APPLY, _local2);
        }
        private function applyRecallRefuse(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int;
            while (_local3 < UnityConstData.ApplyDataList.length) {
                if (UnityConstData.ApplyDataList[_local3].PlayerId == _local2){
                    UnityConstData.ApplyDataList.splice(_local3, 1);
                    break;
                };
                _local3++;
            };
            facade.sendNotification(UnityEvent.DELETE_APPLY, _local2);
        }
        private function createGuildResult(_arg1:NetPacket):void{
            var _local5:int;
            var _local2:String = _arg1.ReadString();
            var _local3:Boolean = _arg1.readBoolean();
            if (_local3){
                trace("create guild success");
                _local5 = _arg1.readUnsignedInt();
                GameCommonData.Player.Role.unityId = _local5;
                UnityConstData.myGuildInfo = null;
                sendNotification(EventList.CLOSEUNITYVIEW);
                sendNotification(EventList.SHOWUNITYVIEW);
                GuildSend.getMyGuildInfo();
                GuildSend.getDutyList();
            } else {
                trace("create guild faild");
                _arg1.readUnsignedInt();
            };
            var _local4:String = _arg1.ReadString();
            MessageTip.popup(_local4);
            MessageTip.show(_local4);
            facade.sendNotification(UnityEvent.CREATEUNITY);
        }
        private function startFBNotice():void{
            if ((((UnityConstData.GuildFB_Line == 0)) || ((GameCommonData.Player.Role.unityId == 0)))){
                if (fbNoticeId > 0){
                    clearInterval(fbNoticeId);
                };
                return;
            };
            var _local1:String = LanguageMgr.GetTranslation("公会副本在x线开", UnityConstData.GuildFB_Line);
            _local1 = (_local1 + LanguageMgr.GetTranslation("点击<2_进入副本_2_17>"));
            var _local2:ChatReceiveMsg = new ChatReceiveMsg();
            _local2.talkObj = new Array(5);
            _local2.type = ChatData.CHAT_TYPE_UNITY;
            _local2.color = 2412592;
            _local2.content = _local1;
            _local2.talkObj[3] = _local1;
            _local2.talkObj[4] = int(_local2.color).toString(16);
            facade.sendNotification(CommandList.RECEIVECOMMAND, _local2);
        }
        private function getMyGuildInfo(_arg1:NetPacket):void{
            var _local3:GuildInfo;
            var _local4:String;
            var _local5:int;
            var _local6:uint;
            var _local7:int;
            var _local8:int;
            var _local9:uint;
            var _local10:uint;
            var _local11:uint;
            var _local12:Object;
            if ((((GameCommonData.Scene == null)) || ((GameCommonData.Scene.IsSceneLoaded == false)))){
                return;
            };
            var _local2:Boolean = ((_arg1.readUnsignedInt() == 0)) ? false : true;
            if (_local2){
                _local3 = new GuildInfo();
                _local3.ReadFromNetPacket(_arg1);
                UnityConstData.myGuildInfo = _local3;
                GameCommonData.Player.Role.GuildName = _local3.GuildName;
                GameCommonData.Player.setGuildName(_local3.GuildName);
                if (SharedManager.getInstance().showGuildName){
                    GameCommonData.Player.showGuildName();
                } else {
                    GameCommonData.Player.hideGuildName();
                };
                GameCommonData.Player.Role.unityId = _local3.GuildId;
                UnityConstData.GuildFBOpenTime = _arg1.readUnsignedInt();
                UnityConstData.GuildFB_CrossMode = _arg1.readByte();
                UnityConstData.GuildFB_Line = _arg1.readByte();
                GameCommonData.Player.Role.GuildDutyID = _arg1.readUnsignedInt();
                GameCommonData.Player.Role.GuildDutyLevel = _arg1.readUnsignedInt();
                GameCommonData.Player.Role.GuildPermissions = _arg1.readUnsignedInt();
                GameCommonData.Player.Role.GuildDutyName = _arg1.ReadString();
                GameCommonData.Player.Role.GuildBuildValue = _arg1.readUnsignedInt();
                GameCommonData.Player.Role.GuildBanChatFlag = _arg1.readUnsignedInt();
                facade.sendNotification(UnityEvent.GETINFO);
                facade.sendNotification(EventList.HASUINTY);
                for (_local4 in GameCommonData.GuildSkillsList) {
                    GameCommonData.GuildSkillsList[_local4].isLearn = false;
                };
                UnityConstData.CurrentGuildSkillCDList = new Dictionary();
                _local5 = _arg1.readUnsignedInt();
                if (_local5 > 0){
                    _local7 = 0;
                    while (_local7 < _local5) {
                        _local6 = _arg1.readUnsignedInt();
                        GameCommonData.GuildSkillsList[_local6].isLearn = true;
                        _local7++;
                    };
                    _local8 = _arg1.readUnsignedInt();
                    _local7 = 0;
                    while (_local7 < _local8) {
                        _local12 = {};
                        _local12.idUser = GameCommonData.Player.Role.Id;
                        _local12.magicid = _arg1.readUnsignedInt();
                        _local12.privateTotalCdTime = (_arg1.readUnsignedInt() * 1000);
                        _local12.privateCdTime = (_arg1.readUnsignedInt() * 1000);
                        _local12.startCdTime = ((TimeManager.Instance.Now().time + _local12.privateCdTime) - _local12.privateTotalCdTime);
                        UnityConstData.CurrentGuildSkillCDList[int((_local12.magicid / 100))] = _local12;
                        if ((((_local12.privateCdTime > 0)) && (((_local12.privateTotalCdTime - _local12.privateCdTime) >= 0)))){
                            sendNotification(EventList.RECEIVE_CD_GUILDSKILL, _local12);
                        };
                        _local7++;
                    };
                };
            };
            UnityConstData.IsLoadMyGuildInfo = true;
            if (UnityConstData.GuildFBOpened > 0){
                fbNoticeId = setInterval(startFBNotice, 180000);
                startFBNotice();
            };
            if (TaskCommonData.IsLoadedQuestlog){
                TaskCommonData.SetGuildQuestReward();
            };
        }
        private function newApplyHandler(_arg1:NetPacket):void{
            var _local2:GuildPlayerInfo;
            _local2 = new GuildPlayerInfo();
            _local2.PlayerId = _arg1.readUnsignedInt();
            _local2.Level = _arg1.readUnsignedInt();
            _local2.NickName = _arg1.ReadString();
            _local2.Job = _arg1.readUnsignedInt();
            _local2.Sex = _arg1.readUnsignedInt();
            UnityConstData.ApplyDataList.push(_local2);
            facade.sendNotification(UnityEvent.UPDATEAPPLYDATA, UnityConstData.ApplyDataList);
            if (GameCommonData.Player.Role.GuildDutyLevel <= 3){
                facade.sendNotification(EventList.UNITYBTNRAY, true);
            };
        }
        private function banchatResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:GuildPlayerInfo = UnityConstData.getGuildPlayerInfoById(_local2);
            if (_local4){
                _local4.BanChatFlag = _local3;
                if (_local3 == 0){
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", (_local4.NickName + LanguageMgr.GetTranslation("被解禁")));
                } else {
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, "", (_local4.NickName + LanguageMgr.GetTranslation("被禁言")));
                };
            };
            if (_local2 == GameCommonData.Player.Role.Id){
                GameCommonData.Player.Role.GuildBanChatFlag = _local3;
            };
            sendNotification(UnityEvent.UPDATE_MEMBER);
        }
        private function kickOutResult(_arg1:NetPacket):void{
            var _local2:Boolean = _arg1.readBoolean();
            var _local3:String = _arg1.ReadString();
            if (_local3 != ""){
                MessageTip.show(_local3);
            };
        }
        private function searchGuildList(_arg1:NetPacket):void{
            var _local4:GuildInfo;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:Array = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local4 = new GuildInfo();
                _local4.ReadFromNetPacket(_arg1);
                _local3.push(_local4);
                _local5++;
            };
            facade.sendNotification(UnityEvent.UPDATEUNITYDATA, [_local3, 1]);
        }
        public function updatePlacard(_arg1:NetPacket):void{
            var _local2:String = _arg1.ReadString();
            var _local3:Boolean = _arg1.readBoolean();
            if (_local3){
                UnityConstData.myGuildInfo.Placard = _local2;
                facade.sendNotification(UnityEvent.UPDATE_MYGUILDINFO);
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_GUILD_CREATE:
                    createGuildResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_MEMBER_LIST:
                    getMemberList(_arg1);
                    break;
                case Protocol.SMSG_GUILD_SEARCH_RESULT:
                    searchGuildList(_arg1);
                    break;
                case Protocol.SMSG_GUILD_MYGUILD:
                    getMyGuildInfo(_arg1);
                    break;
                case Protocol.SMSG_GUILD_DISBAND:
                    disbandResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_RESPONSE:
                    response(_arg1);
                    break;
                case Protocol.SMSG_GUILD_TRYIN:
                    ApplyResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_APPLY_LIST:
                    applyList(_arg1);
                    break;
                case Protocol.SMSG_GUILD_TRYIN_PASS:
                    applyRecallPass(_arg1);
                    break;
                case Protocol.SMSG_GUILD_TRYIN_REFUSE:
                    applyRecallRefuse(_arg1);
                    break;
                case Protocol.SMSG_GUILD_DUTY_LIST:
                    getDutyList(_arg1);
                    break;
                case Protocol.SMSG_GUILD_UPDATE_DUTY:
                    updateDutyResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_INVITE:
                    inviteResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_OUT_MEMBER:
                    kickOutResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_UPDATE_PLACARD:
                    updatePlacard(_arg1);
                    break;
                case Protocol.SMSG_GUILD_CHANGE_CHAIRMAN:
                    ChangeLeaderResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_RICH_OFFER:
                    RichOfferResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_APPLY_OPEN:
                    setApplyModeResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_EVENT_LIST:
                    getGuildEventsList(_arg1);
                    break;
                case Protocol.SMSG_GUILD_CHAT_RESPONSE:
                    banchatResult(_arg1);
                    break;
                case Protocol.SMSG_GUILD_NEW_APPLYER:
                    newApplyHandler(_arg1);
                    break;
                case Protocol.SMSG_GUILD_ONLINE_STATE:
                    updateGuildOnlineState(_arg1);
                    break;
                case Protocol.SMSG_GUILD_MEMBER_UPDATE:
                    udataPlayerLevelUp(_arg1);
                    break;
                case Protocol.SMSG_GUILD_INSTANCE_START:
                    openGuildFBHandler(_arg1);
                    break;
                case Protocol.SMSG_EFFECT_CONTROL:
                    effectHandler(_arg1);
                    break;
                case Protocol.SMSG_GUILD_CHALLENGE:
                    guildBattleResult(_arg1);
                    break;
            };
        }
        private function applyList(_arg1:NetPacket):void{
            var _local3:GuildPlayerInfo;
            var _local2:int = _arg1.readUnsignedInt();
            var _local4:Array = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local3 = new GuildPlayerInfo();
                _local3.PlayerId = _arg1.readUnsignedInt();
                _local3.Level = _arg1.readUnsignedInt();
                _local3.NickName = _arg1.ReadString();
                _local3.Job = _arg1.readUnsignedInt();
                _local3.Sex = _arg1.readUnsignedInt();
                _local4.push(_local3);
                _local5++;
            };
            if ((((_local4.length > 0)) && ((GameCommonData.Player.Role.GuildDutyLevel <= 3)))){
                facade.sendNotification(EventList.UNITYBTNRAY, true);
            };
            UnityConstData.ApplyDataList = _local4;
            facade.sendNotification(UnityEvent.UPDATEAPPLYDATA);
        }
        private function getGuildEventsList(_arg1:NetPacket):void{
            var _local4:GuildEventInfo;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Array = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local4 = new GuildEventInfo();
                _local4.ID = _arg1.readUnsignedInt();
                _local4.GuildID = _arg1.readUnsignedInt();
                _local4.Date = _arg1.ReadString();
                _local4.Type = _arg1.readUnsignedInt();
                _local4.Des = _arg1.ReadString();
                _local3.push(_local4);
                _local5++;
            };
            UnityConstData.GuildEventList = _local3;
            facade.sendNotification(UnityEvent.UPDATE_GUILDEVENTINFO);
        }
        private function ChangeLeaderResult(_arg1:NetPacket):void{
            var _local2:String = _arg1.ReadString();
            MessageTip.show(_local2);
            MessageTip.popup(_local2);
        }
        private function effectHandler(_arg1:NetPacket):void{
            var treeNpc:* = null;
            var idx:* = null;
            var intervalId:* = 0;
            var npk:* = _arg1;
            var start:* = npk.readBoolean();
            var result:* = npk.readUnsignedInt();
            if (start){
                switch (result){
                    case 1:
                        SpeciallyEffectController.getInstance().showChallengedSuccess();
                        SpeciallyEffectController.getInstance().showRainEffect();
                        for (idx in GameCommonData.SameSecnePlayerList) {
                            if ((GameCommonData.SameSecnePlayerList[idx] is GameElementNPC)){
                                if (GameCommonData.SameSecnePlayerList[idx].Role.MonsterTypeID == 1181){
                                    treeNpc = GameCommonData.SameSecnePlayerList[idx];
                                    treeNpc.SetMissionPrompt(3);
                                    break;
                                };
                            };
                        };
                        break;
                    case 2:
                        SpeciallyEffectController.getInstance().showChallengedFail();
                        break;
                    case 3:
                        SpeciallyEffectController.getInstance().showFireEffect();
                        setTimeout(function ():void{
                            SpeciallyEffectController.getInstance().screen_shake(0.4, 80);
                        }, 200);
                        intervalId = setInterval(function ():void{
                            SpeciallyEffectController.getInstance().showFireEffect();
                            setTimeout(function ():void{
                                SpeciallyEffectController.getInstance().screen_shake(0.4, 80);
                            }, 200);
                        }, 1800);
                        setTimeout(function ():void{
                            clearInterval(intervalId);
                        }, 7200);
                        break;
                };
            } else {
                SpeciallyEffectController.getInstance().hideRainEffect();
            };
        }
        private function setApplyModeResult(_arg1:NetPacket):void{
            var _local2:Boolean = _arg1.readBoolean();
            MessageTip.show(_arg1.ReadString());
            UnityConstData.myGuildInfo.IsApply = _local2;
            sendNotification(UnityEvent.GUILD_UPDATE_APPLAYMODE, _local2);
        }
        private function updateDutyResult(_arg1:NetPacket):void{
            var _local6:int;
            var _local2:Boolean = _arg1.readBoolean();
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:int = _arg1.readUnsignedInt();
            var _local5:String = _arg1.ReadString();
            _local6 = 0;
            while (_local6 < UnityConstData.DutyList.length) {
                if (UnityConstData.DutyList[_local6].DutyID == _local3){
                    UnityConstData.DutyList[_local6].DutyName = _local5;
                    UnityConstData.DutyList[_local6].Level = _local4;
                };
                _local6++;
            };
            _local6 = 0;
            while (_local6 < UnityConstData.allMenberList.length) {
                if (UnityConstData.allMenberList[_local6].DutyLevel == _local4){
                    UnityConstData.allMenberList[_local6].DutyName = _local5;
                };
                _local6++;
            };
            sendNotification(UnityEvent.UPDATE_MEMBER);
        }
        private function RichOfferResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            MessageTip.popup(LanguageMgr.GetTranslation("获得x点贡献值", _local4));
            switch (_local2){
                case OfferType.OFFER_GUILD:
                    GameCommonData.Player.Role.GuildBuildValue = _local3;
                    TaskCommonData.SetGuildQuestReward();
                    break;
                case OfferType.OFFER_WARRIOR:
                case OfferType.OFFER_MAGE:
                case OfferType.OFFER_PRIEST:
                case OfferType.OFFER_ROGUE:
                case OfferType.OFFER_HUNTER:
                    GameCommonData.Player.Role.OfferValue[(_local2 - 1)] = _local3;
                    break;
            };
            sendNotification(RoleEvents.UPDATE_ROLEOFFER);
            sendNotification(UnityEvent.OFFERITEM_COMPLETE);
        }
        private function udataPlayerLevelUp(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:GuildPlayerInfo = UnityConstData.getGuildPlayerInfoById(_local2);
            if (_local4){
                _local4.Level = _local3;
                facade.sendNotification(UnityEvent.UPDATE_MEMBER, _local4);
            };
        }

    }
}//package Net.PackHandler 
