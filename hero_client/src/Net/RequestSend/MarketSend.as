//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class MarketSend {

        public static function takeMoney(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GET_ACCOUNTMONEY;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function buyItemForMarket(_arg1:int, _arg2:int, _arg3:Boolean=false):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_SHOPPING;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeBoolean(_arg3);
            _local4.SendPacket();
        }
        public static function getShopItemList(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PLAZA_GOODS;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function requestInventory(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_LIST_INVENTORY;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function createMsg(_arg1:Object):void{
        }

    }
}//package Net.RequestSend 
