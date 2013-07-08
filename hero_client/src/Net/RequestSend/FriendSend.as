//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class FriendSend {

        public static function deleteFriend(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_DEL_FRIEND;
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.SendPacket();
        }
        public static function getFriendList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_FRIEND_LIST;
            _local1.SendPacket();
        }
        public static function getFriendInfo(_arg1:int, _arg2:uint=0):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_FRIEND_ROLE_PANEL;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function addFriend(_arg1:String, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_ADD_FRIEND;
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.m_sendpacket.WriteString(_arg1);
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
