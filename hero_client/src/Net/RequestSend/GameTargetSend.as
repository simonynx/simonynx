//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class GameTargetSend {

        public static function sendRequest(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PLAYER_GROWUP_OPERATE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
