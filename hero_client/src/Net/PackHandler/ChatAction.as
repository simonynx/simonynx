//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;

    public class ChatAction extends GameAction {

        private static var _instance:ChatAction;

        public function ChatAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():ChatAction{
            if (!_instance){
                _instance = new (ChatAction)();
            };
            return (_instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            if (GameCommonData.Player == null){
                return;
            };
            switch (_arg1.opcode){
                case Protocol.SMSG_MSG:
                    processChat(_arg1);
                    break;
                case Protocol.SMSG_NOTIFICATION:
                    notification(_arg1);
                    break;
            };
        }
        private function faceFilter(_arg1:String):String{
            var _local5:int;
            var _local2:RegExp = /(\\\d{3})/g;
            var _local3:Array = _arg1.split(_local2);
            if (_local3.length == 0){
                return (_arg1);
            };
            var _local4:int;
            var _local6:int;
            while (_local4 < _local3.length) {
                if (((_local2.test(_local3[_local4])) && ((int(int(_local3[_local4].slice(1, 4))) <= ChatData.FACE_NUM)))){
                    if (_local6 >= 5){
                        _local3[_local4] = "";
                        continue;
                    };
                    _local6++;
                };
                _local4++;
            };
            _arg1 = _local3.join("");
            return (_arg1);
        }
        private function notification(_arg1:NetPacket):void{
            ChatData.Notification(_arg1.ReadString());
        }
        private function processChat(_arg1:NetPacket):void{
            var _local5:uint;
            var _local6:uint;
            var _local8:Array;
            var _local10:String;
            var _local12:uint;
            var _local2:ChatReceiveMsg = new ChatReceiveMsg();
            _local2.talkObj = new Array(5);
            _local2.type = _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:String = ChgLineData.getNameByIndex(_local3).substr(0, 1);
            _local2.sendId = _arg1.readUnsignedInt();
            if (_local2.sendId < 268435456){
                _local2.titleColorIndex = _arg1.readUnsignedInt();
                _local2.titleStr = _arg1.ReadString();
                _local2.vip = _arg1.readUnsignedInt();
            };
            _local2.talkObj[0] = _arg1.ReadString();
            if (_local2.sendId < 268435456){
                _local5 = _arg1.readUnsignedInt();
            };
            if (_local2.type == ChatData.CHAT_TYPE_FRIEND){
                _local2.talkObj[1] = GameCommonData.Player.Role.Name;
            } else {
                _local2.talkObj[1] = "ALLUSER";
            };
            _local2.talkObj[2] = "";
            var _local7:String = _arg1.ReadString();
            if (_local2.sendId < 268435456){
                _local2.talkObj[4] = _arg1.ReadString();
                _local8 = _local2.talkObj[4].split("_");
                if (_local8.length > 7){
                    _local2.talkObj[4] = "";
                    _local12 = 0;
                    (_local12 == 0);
                    while (_local12 < (_local8.length - 1)) {
                        if (_local12 < 7){
                            if (_local12 < 6){
                                _local2.talkObj[4] = (_local2.talkObj[4] + (String(_local8[_local12]) + "_"));
                            } else {
                                _local2.talkObj[4] = (_local2.talkObj[4] + (String(_local8[_local12]) + ">"));
                            };
                        } else {
                            _local2.talkObj[2] = (_local2.talkObj[2] + (String(_local8[_local12]) + "_"));
                        };
                        _local12++;
                    };
                    _local2.talkObj[2] = (_local2.talkObj[2] + String(_local8[_local12]));
                };
            };
            _local2.color = _arg1.readUnsignedInt();
            _local7 = faceFilter(_local7);
            _local2.content = _local7;
            var _local9 = (("[" + _local2.talkObj[0]) + "]");
            if (_local2.sendId == GameCommonData.Player.Role.Id){
                _local9 = LanguageMgr.GetTranslation("你");
            };
            if (_local5 == 1){
                _local10 = "<3_♀_2>";
            } else {
                if (_local5 == 0){
                    _local10 = "<3_♂_9>";
                };
            };
            if (_local2.titleStr != ""){
                _local10 = (_local10 + (((("<3_★" + _local2.titleStr) + "★_") + String(uint((10 + _local2.titleColorIndex)))) + ">"));
            };
            var _local11 = "";
            if (_local2.vip == 1){
                _local11 = "<0_[VIP]_10>";
            } else {
                if (_local2.vip == 2){
                    _local11 = "<0_[VIP]_11>";
                } else {
                    if (_local2.vip == 3){
                        _local11 = "<0_[VIP]_12>";
                    };
                };
            };
            switch (_local2.type){
                case ChatData.CHAT_TYPE_FRIEND:
                    _local2.faceId = _arg1.readUnsignedInt();
                    _local2.timeT = _arg1.readUnsignedInt();
                    _local2.talkObj[2] = (_local2.timeT * 1000);
                    _local2.talkObj[3] = _local7;
                    _local2.talkObj[4] = int(_local2.color).toString(16);
                    break;
                case ChatData.CHAT_TYPE_WORLD:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[3] = ((((((((("<3_[" + _local4) + "]_4>") + _local10) + _local11) + "[") + _local9) + "]") + "<3_：_4>") + _local7);
                    } else {
                        _local2.talkObj[3] = (((((((("<3_[" + _local4) + "]_4>") + _local10) + _local11) + "<0_") + _local9) + "_4><3_：_4>") + _local7);
                    };
                    break;
                case ChatData.CHAT_TYPE_LEO:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[3] = ((((((((("<3_[" + _local4) + "]_5>") + _local10) + _local11) + "[") + _local9) + "]") + "<3_：_5>") + _local7);
                    } else {
                        _local2.talkObj[3] = (((((((("<3_[" + _local4) + "]_5>") + _local10) + _local11) + "<0_") + _local9) + "_5><3_：_5>") + _local7);
                    };
                    break;
                case ChatData.CHAT_TYPE_NEAR:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[3] = ((((((_local10 + _local11) + "[") + _local9) + "]") + "<3_：_0>") + _local7);
                    } else {
                        _local2.talkObj[3] = (((((_local10 + _local11) + "<0_") + _local9) + "_0><3_：_0>") + _local7);
                    };
                    break;
                case ChatData.CHAT_TYPE_TEAM:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[3] = ((((((_local10 + _local11) + "[") + _local9) + "]") + "<3_：_1>") + _local7);
                    } else {
                        _local2.talkObj[3] = (((((_local10 + _local11) + "<0_") + _local9) + "_1><3_：_1>") + _local7);
                    };
                    break;
                case ChatData.CHAT_TYPE_FACTION:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[3] = ((((((_local10 + _local11) + "[") + _local9) + "]") + "<3_：_6>") + _local7);
                    } else {
                        _local2.talkObj[3] = (((((_local10 + _local11) + "<0_") + _local9) + "_6><3_：_6>") + _local7);
                    };
                    break;
                case ChatData.CHAT_TYPE_UNITY:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[3] = ((((((((("<3_[" + _local4) + "]_3>") + _local10) + _local11) + "[") + _local9) + "]") + "<3_：_3>") + _local7);
                    } else {
                        _local2.talkObj[3] = (((((((("<3_[" + _local4) + "]_3>") + _local10) + _local11) + "<0_") + _local9) + "_3><3_：_3>") + _local7);
                    };
                    break;
                case ChatData.CHAT_TYPE_PRIVATE:
                    if (_local2.sendId == GameCommonData.Player.Role.Id){
                        _local2.talkObj[1] = _arg1.ReadString();
                        if (_local2.type == ChatData.CHAT_TYPE_PRIVATE){
                            _local6 = _arg1.readUnsignedInt();
                        };
                        _local2.talkObj[3] = (((((((((((("<3_[" + _local4) + "]_2>") + _local10) + _local11) + "<3_") + LanguageMgr.GetTranslation("你对")) + "_2><0_[") + _local2.talkObj[1]) + "]_2><3_") + LanguageMgr.GetTranslation("说")) + "_2><3_：_2>") + _local7);
                        _local2.sendId = _local6;
                        facade.sendNotification(ChatEvents.ADDTOCONTACTLIST, {name:_local2.talkObj[1]});
                    } else {
                        _local2.talkObj[3] = (((((((((("<3_[" + _local4) + "]_2>") + _local10) + _local11) + "<0_[") + _local2.talkObj[0]) + "]_2><3_") + LanguageMgr.GetTranslation("对你说")) + "_2><3_：_2>") + _local7);
                    };
                    break;
            };
            facade.sendNotification(CommandList.RECEIVECOMMAND, _local2);
            facade.sendNotification(CommandList.FRIEND_CHAT_MESSAGE, _local2);
        }

    }
}//package Net.PackHandler 
