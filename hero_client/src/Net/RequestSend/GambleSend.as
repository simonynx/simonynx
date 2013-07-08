//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class GambleSend {

        private static const BOX_OP_MODIFY:uint = 5;
        public static const BOX_OP_GET_ITEM:uint = 2;
        private static const BOX_OP_RESULT:uint = 4;
        public static const BOX_OP_SORT:uint = 3;
        public static const BOX_OP_QUERY:uint = 1;

        public static function Gameble(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GAMBLE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function GamebleDepot(_arg1:uint, _arg2:int=-1):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GAMBLE_BOX;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            if (_arg1 == BOX_OP_GET_ITEM){
                _local3.m_sendpacket.writeInt(_arg2);
            };
            _local3.SendPacket();
        }
        public static function GamebleHistroy():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GAMBLE_HISTORY;
            _local1.SendPacket();
        }

    }
}//package Net.RequestSend 
