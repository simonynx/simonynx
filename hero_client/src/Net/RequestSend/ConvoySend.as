//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class ConvoySend {

        public static function ColorChange(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ITEM_SACRIFICE;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }

    }
}//package Net.RequestSend 
