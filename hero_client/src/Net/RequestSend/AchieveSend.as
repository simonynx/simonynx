//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class AchieveSend {

        public static function GetAchieveLog():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_ACHIEVEMENT_LIST;
            _local1.SendPacket();
        }

    }
}//package Net.RequestSend 
