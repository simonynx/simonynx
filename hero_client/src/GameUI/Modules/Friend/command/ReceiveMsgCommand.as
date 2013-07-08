//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Modules.Chat.Data.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Friend.view.mediator.*;
    import GameUI.Modules.Friend.model.proxy.*;

    public class ReceiveMsgCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local2:MessageWordProxy;
            var _local3:ChatReceiveMsg;
            var _local4:Array;
            var _local5:MessageStruct;
            var _local6:Object;
            var _local7:String;
            var _local8:Date;
            var _local10:FriendInfoStruct;
            var _local9:ChatReceiveMsg = (_arg1.getBody() as ChatReceiveMsg);
            if ((((((_local9.type == ChatData.CHAT_TYPE_FRIEND)) || ((_local9.type == 2110)))) || ((_local9.type == FriendActionList.SYSTEM_MSG)))){
                _local2 = (facade.retrieveProxy(MessageWordProxy.NAME) as MessageWordProxy);
                _local3 = _local9;
                _local4 = (_local3.talkObj as Array);
                _local5 = new MessageStruct();
                _local5.isOnline = 0;
                _local5.face = _local3.faceId;
                _local5.isFriend = 0;
                _local5.sendId = _local3.sendId;
                _local5.action = _local3.type;
                _local5.sendPersonName = _local4.shift();
                _local5.receivePersonName = _local4.shift();
                _local5.sendTime = Number(_local4.shift());
                _local5.msg = _local4.shift();
                _local5.style = _local4.shift();
                _local5.feel = _local4.shift();
                _local6 = (facade.retrieveMediator(FriendManagerMediator.NAME) as FriendManagerMediator).searchFriend(FriendConstData.FriendList, 0, 0, _local5.sendPersonName);
                if (_local5.action != FriendActionList.SYSTEM_MSG){
                    if (_local6){
                        _local5.isFriend = 1;
                    };
                };
                if (_local5.action != FriendActionList.CHAT_FLAG){
                    _local7 = String(_local5.sendTime);
                    _local8 = new Date(_local7.substr(0, 4), Number(_local7.substr(4, 2)), Number(_local7.substr(6, 2)), Number(_local7.substr(8, 2)), Number(_local7.substr(10, 2)), Number(_local7.substr(12, 2)));
                    _local5.sendTime = _local8.time;
                };
                _local10 = FriendConstData.searchFriend(FriendConstData.BlackFriendList, _local5.sendId);
                if (((_local10) && ((_local10.type == FriendType.TYPE_BLACK)))){
                    return;
                };
                switch (_local5.action){
                    case FriendActionList.SYSTEM_MSG:
                        _local5.face = 99;
                        _local2.pushMsg(_local5);
                        break;
                    case FriendActionList.LEAVE_WORD:
                        _local5.isleave = true;
                        _local2.pushMsg(_local5);
                        break;
                    case FriendActionList.CHAT_FLAG:
                        _local2.pushMsg(_local5);
                        break;
                };
            };
        }

    }
}//package GameUI.Modules.Friend.command 
