//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class StallSend {

        public static function sellStallGoods(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):void{
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_STALL_SELL;
            _local5.m_sendpacket.writeUnsignedInt(_arg1);
            _local5.m_sendpacket.writeUnsignedInt(_arg2);
            _local5.m_sendpacket.writeUnsignedInt(_arg3);
            _local5.m_sendpacket.writeUnsignedInt(_arg4);
            _local5.SendPacket();
        }
        public static function buyStallGoods(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):void{
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_STALL_BUY;
            _local5.m_sendpacket.writeUnsignedInt(_arg1);
            _local5.m_sendpacket.writeUnsignedInt(_arg2);
            _local5.m_sendpacket.writeUnsignedInt(_arg3);
            _local5.m_sendpacket.writeUnsignedInt(_arg4);
            _local5.SendPacket();
        }
        public static function requestStallGoods(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_STALL_GOODS;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function endStall():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_STALL_END;
            _local1.SendPacket();
        }
        public static function beginStall(_arg1:String, _arg2:uint, _arg3:Array, _arg4:uint, _arg5:Array):void{
            var _local6:GameNet = GameCommonData.GameNets;
            _local6.m_sendpacket.opcode = Protocol.CMSG_STALL_BEGIN;
            _local6.m_sendpacket.WriteString(_arg1);
            _local6.m_sendpacket.writeUnsignedInt(_arg2);
            var _local7:uint;
            _local7 = 0;
            while (_local7 < _arg2) {
                if (_arg3[_local7]){
                    _local6.m_sendpacket.writeUnsignedInt(_arg3[_local7].id);
                    _local6.m_sendpacket.writeUnsignedInt(_arg3[_local7].price);
                    _local6.m_sendpacket.writeUnsignedInt(_arg3[_local7].Count);
                    trace("出售物品", _arg3[_local7].id, _arg3[_local7].price, _arg3[_local7].Count);
                };
                _local7++;
            };
            _local6.m_sendpacket.writeUnsignedInt(_arg4);
            _local7 = 0;
            while (_local7 < _arg4) {
                if (_arg5[_local7]){
                    _local6.m_sendpacket.writeUnsignedInt(_arg5[_local7].type);
                    _local6.m_sendpacket.writeUnsignedInt(_arg5[_local7].price);
                    _local6.m_sendpacket.writeUnsignedInt(_arg5[_local7].Count);
                };
                _local7++;
            };
            _local6.SendPacket();
        }

    }
}//package Net.RequestSend 
