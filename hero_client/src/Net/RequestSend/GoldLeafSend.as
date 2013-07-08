//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class GoldLeafSend {

        public static function sendCancelExch(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_EXCHANGE_CANCEL;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendExchange(_arg1:int, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_EXCHANGE;
            _local4.m_sendpacket.writeByte(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function sendRequestInfo(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_EXCHANGE_INFO;
            _local2.m_sendpacket.writeByte(_arg1);
            _local2.SendPacket();
        }
        public static function sendTakeout(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_MONEY_TOBAG;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function sendLogging(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_MONEY_TOBANK;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
