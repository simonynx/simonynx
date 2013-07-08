//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class GameConnectSend {

        public static function GetLineList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_REQUESTLINELIST;
            _local1.SendPacket();
        }
        public static function ChangeLine(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_SELECTLINE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function GameServerConnect(_arg1:String, _arg2:String, _arg3:String):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_AUTH_SESSION;
            _local4.m_sendpacket.WriteString(_arg1.toUpperCase());
            _local4.m_sendpacket.WriteString(_arg2);
            _local4.m_sendpacket.writeInt(parseInt(_arg3));
            _local4.m_sendpacket.writeInt(GameConfigData.GameChengMi);
            _local4.SendPacket();
        }

    }
}//package Net.RequestSend 
