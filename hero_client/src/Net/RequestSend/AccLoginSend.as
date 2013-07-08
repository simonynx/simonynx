//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class AccLoginSend {

        public static function AccLoginCreate(_arg1:String, _arg2:String, _arg3:String):void{
            var _local4:AccNet = GameCommonData.AccNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_LOGIN_ACCSERVER;
            _local4.m_sendpacket.WriteString(_arg1);
            _local4.m_sendpacket.WriteString(_arg2);
            _local4.m_sendpacket.WriteString(_arg3);
            _local4.SendPacket();
        }

    }
}//package Net.RequestSend 
