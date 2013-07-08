//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import Manager.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Unity.Data.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Hint.Events.*;

    public class ReceiveChatCommand extends SimpleCommand {

        private function getLeoMsg(_arg1:ChatReceiveMsg):Object{
            var _local2:Object = new Object();
            _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("喇叭")) + "]_5>") + addSelfName(_arg1));
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            pushMsg(_local2, _arg1.type);
            var _local3:Object = new Object();
            _local3.info = addSelfName(_arg1);
            _local3.dfColor = _arg1.color;
            return (_local3);
        }
        private function getUnityMsg(_arg1:ChatReceiveMsg):void{
            if (UnityConstData.IsLoadMyGuildInfo == false){
                return;
            };
            var _local2:Object = new Object();
            if (GameCommonData.Player.Role.unityId == 0){
                _local2.info = (("<3_" + LanguageMgr.GetTranslation("聊天提示3")) + "_3>");
            } else {
                _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("公会")) + "]_3>") + addSelfName(_arg1));
            };
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            pushMsg(_local2, _arg1.type);
        }
        private function testIsFilter(_arg1:int, _arg2:Object):Boolean{
            var _local3:*;
            for (_local3 in _arg2) {
                if ((_local3 is int)){
                    if ((((_local3 == _arg1)) && (!(_arg2[_local3])))){
                        return (true);
                    };
                } else {
                    if ((((ChatData[_local3] == _arg1)) && (!(_arg2[_local3])))){
                        return (true);
                    };
                };
            };
            return (false);
        }
        private function getWorldMsg(_arg1:ChatReceiveMsg):void{
            var _local2:Object = new Object();
            _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("世界")) + "]_4>") + addSelfName(_arg1));
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            var _local3:FriendInfoStruct = FriendConstData.searchFriend(FriendConstData.BlackFriendList, _arg1.sendId);
            if (((((_local3) && ((_local3.type == FriendType.TYPE_BLACK)))) && ((_arg1.talkObj[0] == _local3.roleName)))){
                return;
            };
            pushMsg(_local2, _arg1.type);
        }
        private function getFaction(_arg1:ChatReceiveMsg):void{
            var _local2:Object = new Object();
            if (MapManager.IsInFormation() == false){
                _local2.info = (("<3_" + LanguageMgr.GetTranslation("聊天提示5")) + "_6>");
            } else {
                if (GameCommonData.IsInCrossServer){
                    _local2.info = (("<3_" + LanguageMgr.GetTranslation("聊天提示8")) + "_6>");
                } else {
                    _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("阵营")) + "]_6>") + addSelfName(_arg1));
                };
            };
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            pushMsg(_local2, _arg1.type);
        }
        private function pushMsg(_arg1:Object, _arg2:int):void{
            ChatData.AllMsg.push(_arg1);
            if (ChatData.AllMsg.length > ChatData.MAX_AMOUNT_MSG){
                ChatData.AllMsg.shift();
            };
            if (ChatData.CurShowContent == 0){
                facade.sendNotification(ChatEvents.SHOWMSGINFO, ChatData.AllMsg);
            };
            getShowMsg(_arg2, _arg1);
        }
        private function getMapMsg(_arg1:Object):void{
            var _local2:Object = new Object();
            _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("附近")) + "]_0>") + addSelfName(_arg1));
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            pushMsg(_local2, _arg1.type);
        }
        private function getTeamMsg(_arg1:ChatReceiveMsg):void{
            var _local2:Object = new Object();
            if (GameCommonData.Player.Role.idTeam == 0){
                _local2.info = (("<3_" + LanguageMgr.GetTranslation("聊天提示2")) + "_1>");
            } else {
                _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("队伍")) + "]_1>") + addSelfName(_arg1));
            };
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            pushMsg(_local2, _arg1.type);
        }
        private function pushCleanMsg(_arg1:Array):Array{
            var _local2:Object;
            var _local3:uint;
            var _local4:int;
            switch (ChatData.CurAreaPos){
                case 0:
                    _local3 = 6;
                    break;
                case 1:
                    _local3 = 10;
                    break;
                case 2:
                    _local3 = 12;
                    break;
            };
            while (_local4 < _local3) {
                _local2 = new Object();
                _local2.info = "\t\t\t\t\t\t\t\t\t\t\t\t";
                _local2.dfColor = 0xFFFFFF;
                _arg1.push(_local2);
                _local4++;
            };
            return (_arg1);
        }
        private function clearMsg():void{
            switch (ChatData.CurShowContent){
                case 0:
                    pushCleanMsg(ChatData.AllMsg);
                    ChatData.AllMsg = new Array();
                    facade.sendNotification(ChatEvents.CLEAR_MSG_CUR_CHANNEL);
                    facade.sendNotification(ChatEvents.CHANGEMSGAREA);
                    break;
                case 1:
                    pushCleanMsg(ChatData.UnityMsg);
                    ChatData.UnityMsg = new Array();
                    facade.sendNotification(ChatEvents.CLEAR_MSG_CUR_CHANNEL);
                    facade.sendNotification(ChatEvents.CHANGEMSGAREA);
                    break;
                case 2:
                    pushCleanMsg(ChatData.Set1Msg);
                    ChatData.Set1Msg = new Array();
                    facade.sendNotification(ChatEvents.CLEAR_MSG_CUR_CHANNEL);
                    facade.sendNotification(ChatEvents.CHANGEMSGAREA);
                    break;
                case 3:
                    pushCleanMsg(ChatData.Set2Msg);
                    ChatData.Set2Msg = new Array();
                    facade.sendNotification(ChatEvents.CLEAR_MSG_CUR_CHANNEL);
                    facade.sendNotification(ChatEvents.CHANGEMSGAREA);
                    break;
                case 4:
                    pushCleanMsg(ChatData.NearMsg);
                    ChatData.NearMsg = new Array();
                    facade.sendNotification(ChatEvents.CLEAR_MSG_CUR_CHANNEL);
                    facade.sendNotification(ChatEvents.CHANGEMSGAREA);
                    break;
                case 5:
                    pushCleanMsg(ChatData.FactionMsg);
                    ChatData.FactionMsg = new Array();
                    facade.sendNotification(ChatEvents.CLEAR_MSG_CUR_CHANNEL);
                    facade.sendNotification(ChatEvents.CHANGEMSGAREA);
                    break;
            };
        }
        override public function execute(_arg1:INotification):void{
            var _local3:int;
            var _local2:ChatReceiveMsg = (_arg1.getBody() as ChatReceiveMsg);
            if (_local2 == null){
                clearMsg();
                return;
            };
            if (_local2.type == ChatData.CHAT_TYPE_STSTEM){
                _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("系统")) + "]_7>") + _local2.htmlText);
                _local2.dfColor = 0xFFFF00;
                if (_local2.sendId == 0){
                    pushMsg(_local2, ChatData.CHAT_TYPE_STS);
                    return;
                };
            };
            if (_local2.type == ChatData.CHAT_TYPE_POST){
                _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("公告")) + "]：_7>") + _local2.info);
                _local2.dfColor = 0xFF0000;
                pushMsg(_local2, 2035);
                return;
            };
            if (_local2.type == ChatData.CHAT_TYPE_TIPS){
                _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("提示")) + "]：_2>") + _local2.info);
                _local2.dfColor = 42577;
                pushMsg(_local2, ChatData.CHAT_TYPE_TIPS);
                return;
            };
            while (_local3 < ChatData.FilterList.length) {
                if (ChatData.FilterList[_local3] == _local2.talkObj[0]){
                    return;
                };
                _local3++;
            };
            if ((_local2 is ChatReceiveMsg)){
                dealChatInfo(_local2);
                return;
            };
        }
        private function getDefaultMsg(_arg1:Object):void{
            var _local2:Object = new Object();
            _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("系统")) + "]_5>") + _arg1.talkObj[3]);
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            pushMsg(_local2, _arg1.type);
        }
        private function addSelfName(_arg1:Object):String{
            var _local2:Array;
            var _local3 = "";
            if (_arg1.talkObj){
                _local2 = _arg1.talkObj;
                if (_local2[3]){
                    _local3 = _local2[3];
                };
            };
            return (_local3);
        }
        private function dealChatInfo(_arg1:ChatReceiveMsg):void{
            var _local2:Object;
            var _local3:String;
            switch (_arg1.type){
                case ChatData.CHAT_TYPE_WORLD:
                    getWorldMsg(_arg1);
                    break;
                case ChatData.CHAT_TYPE_UNITY:
                    getUnityMsg(_arg1);
                    break;
                case ChatData.CHAT_TYPE_TEAM:
                    getTeamMsg(_arg1);
                    break;
                case ChatData.CHAT_TYPE_FACTION:
                    getFaction(_arg1);
                    break;
                case ChatData.CHAT_TYPE_PRIVATE:
                    getPrivateMsg(_arg1);
                    break;
                case ChatData.CHAT_TYPE_LEO:
                    _local2 = getLeoMsg(_arg1);
                    facade.sendNotification(ChatEvents.RECEIVELEOMSG, _local2);
                    break;
                case ChatData.CHAT_TYPE_NEAR:
                    if (GameCommonData.Player.Role.Id == _arg1.sendId){
                        getMapMsg(_arg1);
                        facade.sendNotification(ScreenMessageEvent.SHOW_DIALOGUE, _arg1);
                        return;
                    };
                    if (GameCommonData.SameSecnePlayerList[_arg1.sendId] == null){
                        return;
                    };
                    _local3 = GameCommonData.SameSecnePlayerList[_arg1.sendId].Role.Type;
                    if ((((_local3 == GameRole.TYPE_PLAYER)) || ((_local3 == GameRole.TYPE_OWNER)))){
                        getMapMsg(_arg1);
                    } else {
                        if ((((_local3 == GameRole.TYPE_ENEMY)) || ((_local3 == GameRole.TYPE_PET)))){
                        };
                    };
                    facade.sendNotification(ScreenMessageEvent.SHOW_DIALOGUE, _arg1);
                    break;
                case ChatData.CHAT_TYPE_FRIEND:
                    break;
                default:
                    getDefaultMsg(_arg1);
            };
        }
        private function getPrivateMsg(_arg1:ChatReceiveMsg):void{
            var _local2:Object = new Object();
            _local2.info = ((("<3_[" + LanguageMgr.GetTranslation("私聊")) + "]_2>") + _arg1.talkObj[3]);
            _local2.dfColor = _arg1.color;
            _local2.sendId = _arg1.sendId;
            var _local3:FriendInfoStruct = FriendConstData.searchFriend(FriendConstData.BlackFriendList, _arg1.sendId);
            if (((((_local3) && ((_local3.type == FriendType.TYPE_BLACK)))) && ((_arg1.talkObj[0] == _local3.roleName)))){
                return;
            };
            pushMsg(_local2, _arg1.type);
        }
        private function getShowMsg(_arg1:int, _arg2:Object):void{
            if (_arg1 == ChatData.CHAT_TYPE_STS){
                switch (ChatData.CurShowContent){
                    case 1:
                        ChatData.Set3ChannelList["CHAT_TYPE_STS"] = true;
                        break;
                    case 2:
                        ChatData.Set1ChannelList["CHAT_TYPE_STS"] = true;
                        break;
                    case 3:
                        ChatData.Set2ChannelList["CHAT_TYPE_STS"] = true;
                        break;
                    case 4:
                        ChatData.Set4ChannelList["CHAT_TYPE_STS"] = true;
                        break;
                    case 5:
                        ChatData.Set5ChannelList["CHAT_TYPE_STS"] = true;
                        break;
                };
            };
            if (!testIsFilter(_arg1, ChatData.Set3ChannelList)){
                ChatData.UnityMsg.push(_arg2);
                if (ChatData.UnityMsg.length > ChatData.MAX_AMOUNT_MSG){
                    ChatData.UnityMsg.shift();
                };
                if (ChatData.CurShowContent == 1){
                    facade.sendNotification(ChatEvents.SHOWMSGINFO, ChatData.UnityMsg);
                };
            };
            if (!testIsFilter(_arg1, ChatData.Set1ChannelList)){
                ChatData.Set1Msg.push(_arg2);
                if (ChatData.Set1Msg.length > ChatData.MAX_AMOUNT_MSG){
                    ChatData.Set1Msg.shift();
                };
                if (ChatData.CurShowContent == 2){
                    facade.sendNotification(ChatEvents.SHOWMSGINFO, ChatData.Set1Msg);
                };
            };
            if (!testIsFilter(_arg1, ChatData.Set2ChannelList)){
                ChatData.Set2Msg.push(_arg2);
                if (ChatData.Set2Msg.length > ChatData.MAX_AMOUNT_MSG){
                    ChatData.Set2Msg.shift();
                };
                if (ChatData.CurShowContent == 3){
                    facade.sendNotification(ChatEvents.SHOWMSGINFO, ChatData.Set2Msg);
                };
            };
            if (!testIsFilter(_arg1, ChatData.Set4ChannelList)){
                ChatData.NearMsg.push(_arg2);
                if (ChatData.NearMsg.length > ChatData.MAX_AMOUNT_MSG){
                    ChatData.NearMsg.shift();
                };
                if (ChatData.CurShowContent == 4){
                    facade.sendNotification(ChatEvents.SHOWMSGINFO, ChatData.NearMsg);
                };
            };
            if (!testIsFilter(_arg1, ChatData.Set5ChannelList)){
                ChatData.FactionMsg.push(_arg2);
                if (ChatData.FactionMsg.length > ChatData.MAX_AMOUNT_MSG){
                    ChatData.FactionMsg.shift();
                };
                if (ChatData.CurShowContent == 5){
                    facade.sendNotification(ChatEvents.SHOWMSGINFO, ChatData.FactionMsg);
                };
            };
            if (_arg1 == ChatData.CHAT_TYPE_STS){
                ChatData.Set1ChannelList["CHAT_TYPE_STS"] = false;
                ChatData.Set2ChannelList["CHAT_TYPE_STS"] = false;
                ChatData.Set3ChannelList["CHAT_TYPE_STS"] = false;
                ChatData.Set4ChannelList["CHAT_TYPE_STS"] = false;
                ChatData.Set5ChannelList["CHAT_TYPE_STS"] = false;
            };
        }

    }
}//package GameUI.Modules.Chat.Command 
