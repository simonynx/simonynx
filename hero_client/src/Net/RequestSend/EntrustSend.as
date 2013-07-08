//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class EntrustSend {

        private static const ENTRUST_ITEMBUY:uint = 5;
        private static const ENTRUST_ITEMCANCEL:uint = 6;
        private static const ENTRUST_ITEMNAME:uint = 2;
        private static const ENTRUST_ITEMMY:uint = 7;
        private static const ENTRUST_ITEMSELL:uint = 4;
        private static const ENTRUST_ITEMCLASS:uint = 1;
        private static const ENTRUST_ITEMTYPE:uint = 3;

        public static function SearchByType(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_ENTRUST_ITEM;
            _local4.m_sendpacket.writeUnsignedInt(ENTRUST_ITEMTYPE);
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt((_arg3 + 1));
            _local4.SendPacket();
        }
        public static function ItemSell(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):void{
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_ENTRUST_ITEM;
            _local5.m_sendpacket.writeUnsignedInt(ENTRUST_ITEMSELL);
            _local5.m_sendpacket.writeUnsignedInt(_arg1);
            _local5.m_sendpacket.writeUnsignedInt(_arg2);
            _local5.m_sendpacket.writeUnsignedInt(_arg3);
            _local5.m_sendpacket.writeUnsignedInt(_arg4);
            _local5.SendPacket();
        }
        public static function ItemCancel(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ENTRUST_ITEM;
            _local2.m_sendpacket.writeUnsignedInt(ENTRUST_ITEMCANCEL);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ItemBuy(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_ENTRUST_ITEM;
            _local3.m_sendpacket.writeUnsignedInt(ENTRUST_ITEMBUY);
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function SearchByClass(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:String):void{
            var _local7:GameNet = GameCommonData.GameNets;
            _local7.m_sendpacket.opcode = Protocol.CMSG_ENTRUST_ITEM;
            _local7.m_sendpacket.writeUnsignedInt(ENTRUST_ITEMCLASS);
            _local7.m_sendpacket.writeUnsignedInt(_arg1);
            _local7.m_sendpacket.writeUnsignedInt(_arg2);
            _local7.m_sendpacket.writeUnsignedInt(_arg3);
            _local7.m_sendpacket.writeUnsignedInt(_arg4);
            _local7.m_sendpacket.writeUnsignedInt((_arg5 + 1));
            _local7.m_sendpacket.WriteString(_arg6);
            _local7.SendPacket();
        }
        public static function ItemMy():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_ENTRUST_ITEM;
            _local1.m_sendpacket.writeUnsignedInt(ENTRUST_ITEMMY);
            _local1.SendPacket();
        }

    }
}//package Net.RequestSend 
