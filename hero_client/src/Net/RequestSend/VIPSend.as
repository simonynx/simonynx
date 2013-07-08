//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class VIPSend {

        public static function sendRequest():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_VIPLIST;
            _local1.SendPacket();
        }

    }
}//package Net.RequestSend 
