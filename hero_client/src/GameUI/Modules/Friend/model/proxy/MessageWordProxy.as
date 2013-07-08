//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.model.proxy {
    import flash.utils.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Friend.command.*;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import GameUI.Modules.Friend.view.mediator.*;

    public class MessageWordProxy extends Proxy {

        public static const NAME:String = "MessageWordProxy";

        protected var _unReadMsgs:Array;
        protected var _messageDic:Dictionary;
        protected var _sendMsg:Dictionary;
        protected var _msgDic:Dictionary;

        public function MessageWordProxy(_arg1:String=null, _arg2:Object=null){
            _msgDic = new Dictionary();
            _unReadMsgs = [];
            _messageDic = new Dictionary();
            _sendMsg = new Dictionary();
            super(NAME, _arg2);
        }
        public function getSendMsgToFriend(_arg1:int):Array{
            return (_sendMsg[_arg1]);
        }
        public function getMsgs(_arg1:uint):Array{
            if (_arg1 == 0){
                return (null);
            };
            if (this._msgDic[_arg1] == null){
                this._msgDic[_arg1] = [];
            };
            return ((this._msgDic[_arg1] as Array));
        }
        protected function popUnReadMsgId():uint{
            if (this._unReadMsgs.length == 0){
                return (0);
            };
            return (this._unReadMsgs.shift());
        }
        public function popMsgId():uint{
            var _local1:uint = this.popUnReadMsgId();
            if (_local1 != 0){
                if (this._messageDic[_local1] != null){
                    delete this._messageDic[_local1];
                };
                if (this._unReadMsgs.length == 0){
                    facade.sendNotification(FriendCommandList.READED_MESSAGE);
                };
                return (_local1);
            };
            return (null);
        }
        public function pushMsg(_arg1:MessageStruct):void{
            if (this._msgDic[_arg1.sendId] == null){
                this._msgDic[_arg1.sendId] = [];
            };
            this._msgDic[_arg1.sendId].push(_arg1);
            var _local2:FriendInfoStruct = new FriendInfoStruct();
            _local2.roleName = _arg1.sendPersonName;
            _local2.frendId = _arg1.sendId;
            _local2.isOnline = ((_arg1.isOnline == 1)) ? true : false;
            facade.sendNotification(FriendCommandList.ADD_TEMP_FRIEND, _local2);
            if (_arg1.isleave){
                this._messageDic[_arg1.sendId] = _arg1.sendPersonName;
            };
            var _local3:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local4:FriendChatMediator = (facade.retrieveMediator(FriendChatMediator.NAME) as FriendChatMediator);
            if (_local4.SearchChatWindow(_arg1.sendId, false) != null){
                sendNotification(FriendCommandList.ADD_MSG_CHAT, _arg1.sendId);
            } else {
                this.addUnReadMsgId(_arg1.sendId);
                facade.sendNotification(FriendCommandList.FRIEND_MESSAGE, {
                    sendId:_arg1.sendId,
                    sendName:_arg1.sendPersonName
                });
                facade.sendNotification(FriendCommandList.ADD_MSG_CHAT, _arg1.sendId);
            };
        }
        public function addUnReadMsgId(_arg1:uint):void{
            if (this._unReadMsgs.indexOf(_arg1) == -1){
                this._unReadMsgs.push(_arg1);
            };
        }
        public function getHistory(_arg1:int):Array{
            var _local7:ChatInfoStruct;
            var _local8:MessageStruct;
            var _local2:Array = (_sendMsg[_arg1]) ? _sendMsg[_arg1].concat() : [];
            var _local3:Array = (_msgDic[_arg1]) ? _msgDic[_arg1].concat() : [];
            _local2.sortOn("timeT", Array.NUMERIC);
            _local3.sortOn("sendTime", Array.NUMERIC);
            var _local4:Array = [];
            var _local5:int;
            var _local6:int;
            var _local9:int = (_local2.length + _local3.length);
            while ((_local5 + _local6) < _local9) {
                _local7 = _local2[_local5];
                _local8 = _local3[_local6];
                if (((_local7) && (_local8))){
                    if (_local7.timeT < _local8.sendTime){
                        _local4.push(_local7);
                        _local5++;
                    } else {
                        _local4.push(_local8);
                        _local6++;
                    };
                } else {
                    if (((_local7) && (!(_local8)))){
                        _local4.push(_local7);
                        _local5++;
                    } else {
                        if (((!(_local7)) && (_local8))){
                            _local4.push(_local8);
                            _local6++;
                        };
                    };
                };
            };
            return (_local4);
        }
        public function pushSendMsg(_arg1:ChatInfoStruct):void{
            if (_sendMsg[_arg1.friendId] == null){
                _sendMsg[_arg1.friendId] = [];
            };
            _sendMsg[_arg1.friendId].push(_arg1);
        }

    }
}//package GameUI.Modules.Friend.model.proxy 
