//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class TradeSend {

        public static function confirmTrade():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_TRADE_CONFIRM;
            _local1.SendPacket();
        }
        public static function addItemToTrade(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_TRADE_ADDITEM;
            _local3.m_sendpacket.writeInt(_arg2);
            _local3.m_sendpacket.writeInt(_arg1);
            _local3.SendPacket();
        }
        public static function applyTrade(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_TRADE_ASK;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function selectTrade(_arg1:uint, _arg2:Boolean):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_TRADE_SELECT;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeBoolean(_arg2);
            _local3.SendPacket();
        }
        public static function lockTrade():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_TRADE_LOCK;
            _local1.SendPacket();
        }
        public static function cancelTrade():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSM_TRADE_CANCEL;
            _local1.SendPacket();
        }
        public static function addMoney(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_TRADE_GOLD;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }

    }
}//package Net.RequestSend 
