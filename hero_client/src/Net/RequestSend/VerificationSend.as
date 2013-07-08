//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class VerificationSend {

        public static function requestIdentify(_arg1:String, _arg2:Boolean):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_IDENTIFICATION;
            _local3.m_sendpacket.WriteString(_arg1);
            if (_arg1 != ""){
                _local3.m_sendpacket.writeBoolean(_arg2);
            };
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
