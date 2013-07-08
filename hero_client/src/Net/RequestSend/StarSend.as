//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class StarSend {

        public static function sendTrainStart(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_CONSTELLATION_TRAIN_START;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendTrainFinish(_arg1:uint, _arg2:uint=1):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_CONSTELLATION_TRAIN_FINISH;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            if (_arg1 == 2){
                _local3.m_sendpacket.writeUnsignedInt(_arg2);
            };
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
