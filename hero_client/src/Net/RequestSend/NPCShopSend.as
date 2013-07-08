//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class NPCShopSend {

        public static function saleGood(_arg1:int, _arg2:int):void{
        }
        public static function saleNPCItem(_arg1:int, _arg2:Array):void{
            var _local5:uint;
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_SELL_ITEM;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            var _local4:uint = _arg2.length;
            _local3.m_sendpacket.writeUnsignedInt(_local4);
            while (_local5 < _local4) {
                _local3.m_sendpacket.writeUnsignedInt(_arg2[_local5].ItemGUID);
                _local5++;
            };
            _local3.SendPacket();
        }
        public static function buyNPCItem(_arg1:int, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_BUY_ITEM;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }

    }
}//package Net.RequestSend 
