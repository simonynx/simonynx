//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class PetSend {

        public static function Feed(_arg1:int):void{
        }
        public static function Rest():void{
            GameCommonData.lastPlayPetIdx = -1;
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_PET_BACK_TO_REST;
            _local1.SendPacket();
        }
        public static function ReName(_arg1:int, _arg2:String):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PET_RENAME;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.WriteString(_arg2);
            _local3.SendPacket();
        }
        public static function Out(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_SELECT_TO_BATTLE;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }

    }
}//package Net.RequestSend 
