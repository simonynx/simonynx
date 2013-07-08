//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class ActivitySend {

        public static function sendQuickFinish(_arg1:Array, _arg2:uint=1):void{
            var _local4:int;
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_QUICK_COMPLETE;
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            switch (_arg2){
                case 1:
                    _local3.m_sendpacket.writeUnsignedInt(_arg1.length);
                    _local4 = 0;
                    while (_local4 < _arg1.length) {
                        _local3.m_sendpacket.writeUnsignedInt(_arg1[_local4]);
                        _local4++;
                    };
                    break;
                case 2:
                    _local3.m_sendpacket.writeUnsignedInt(_arg1[0]);
                    break;
            };
            _local3.SendPacket();
        }
        public static function sendAccumulativeCharge(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PAY_REWARD;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendGetFinish(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GET_STH;
            _local2.m_sendpacket.writeUnsignedInt(4000);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendActivityTry(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_DAILY_LOGIN;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendRequest(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_EXIT_INSTANCE;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }

    }
}//package Net.RequestSend 
