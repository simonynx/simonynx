//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;

    public class ChatSend {

        public static function SendChat(_arg1:ChatInfoStruct):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_MSG;
            _local2.m_sendpacket.writeUnsignedInt(_arg1.type);
            _local2.m_sendpacket.WriteString(_arg1.content);
            _local2.m_sendpacket.WriteString(_arg1.item);
            _local2.m_sendpacket.writeUnsignedInt(_arg1.color);
            if (_arg1.type == 2019){
                _local2.m_sendpacket.writeUnsignedInt(_arg1.friendId);
            } else {
                if (_arg1.type == 2001){
                    _local2.m_sendpacket.WriteString(_arg1.targetName);
                };
            };
            _local2.SendPacket();
        }
        private static function privateChatToOther(_arg1:ChatInfoStruct):void{
            var _local2:ChatReceiveMsg = new ChatReceiveMsg();
            _local2.talkObj = [];
            _local2.type = _arg1.type;
            var _local3:int = GameConfigData.CurrentServerId;
            var _local4:String = ChgLineData.getNameByIndex(_local3);
            _local2.sendId = GameCommonData.Player.Role.Id;
            _local2.talkObj[0] = GameCommonData.Player.Role.Name;
            var _local5:uint = GameCommonData.Player.Role.Sex;
            _local2.talkObj[1] = _arg1.targetName;
            _local2.talkObj[2] = 0;
            var _local6:String = _arg1.content;
            _local2.talkObj[4] = _arg1.item;
            _local2.color = _arg1.color;
            _local2.talkObj[3] = ((("<3_你对_2><0_[" + _local2.talkObj[1]) + "]_2><3_说_2><3_：_2>") + _local6);
        }

    }
}//package Net.RequestSend 
