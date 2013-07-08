//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class QuestionSend {

        public static function UseSpecial(_arg1:uint, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_QUESTION_SPECIAL;
            _local3.m_sendpacket.writeByte(_arg1);
            _local3.m_sendpacket.writeByte(_arg2);
            _local3.SendPacket();
        }
        public static function GetMyQuestinfo():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_CURRENT_QUESTION;
            _local1.SendPacket();
        }
        public static function SendAnswer(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_QUESTION_ANSWER;
            _local3.m_sendpacket.writeByte(_arg1);
            _local3.m_sendpacket.writeByte(_arg2);
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
