//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class GuildFightSend {

        public static function LevelGuildFight():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_EXIT_INSTANCE;
            _local1.SendPacket();
        }
        public static function sendRequest(_arg1:uint, _arg2):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_WAR_CMD;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            switch (_arg1){
                case 0:
                    break;
                case 1:
                    break;
            };
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
