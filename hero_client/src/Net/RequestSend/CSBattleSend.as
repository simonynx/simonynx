//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class CSBattleSend {

        public static function inviteReply(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_CB_TEAM_INVITE_REPLY;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function ExchangeItem(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_CB_EXCHANGE_PRIZE_REQUEST;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function teamOperate(_arg1:int, _arg2:Object=null){
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_CB_TEAM_OPERATE;
            _local3.m_sendpacket.writeByte(_arg1);
            switch (_arg1){
                case 0:
                    _local3.m_sendpacket.WriteString(String(_arg2));
                    break;
                case 2:
                    _local3.m_sendpacket.writeUnsignedInt((_arg2 as uint));
                    break;
                case 6:
                    _local3.m_sendpacket.writeUnsignedInt((_arg2 as uint));
                    break;
            };
            _local3.SendPacket();
        }
        public static function CreateTeam(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_CB_CREATE_TEAM_REQUEST;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function RankList():void{
        }
        public static function GetMyTeamInfo():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_CB_GET_SELFTEAM_INFO;
            _local1.SendPacket();
        }
        public static function GetCSBTeamList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_CB_GET_TEAM_LIST;
            _local1.SendPacket();
        }

    }
}//package Net.RequestSend 
