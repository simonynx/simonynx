//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class TaskSend {

        public static function DeleteTask(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_QUESTLOG_REMOVE_QUEST;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function AcceptQuest(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_QUESTGIVER_ACCEPT_QUEST;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function GetQuestLogQueryList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_QUESTLOG_GET_QUESTLOG;
            _local1.SendPacket();
        }
        public static function DailyBookRefreshQuality(_arg1:int, _arg2:Boolean):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_QUEST_DAILY_OP;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeBoolean(_arg2);
            _local3.SendPacket();
        }
        public static function UpdateFollowState(_arg1:int, _arg2:Boolean):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_QUEST_SHOWPROCESS;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeBoolean(_arg2);
            _local3.SendPacket();
        }
        public static function GetQuestQueryList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_QUEST_QUERY;
            _local1.m_sendpacket.writeUnsignedInt(0);
            _local1.SendPacket();
        }
        public static function CompleteTask(_arg1:int, _arg2:int, _arg3:int=0):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_QUESTGIVER_COMPLETE_QUEST;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }

    }
}//package Net.RequestSend 
