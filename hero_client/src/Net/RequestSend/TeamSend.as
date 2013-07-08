//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import flash.utils.*;
    import Net.*;
    import GameUI.Modules.Team.Datas.*;

    public class TeamSend {

        public static function DisbandTeam():void{
            sendTeamCmd(TeamDataProxy.CTEAMCMD_DISBANDTEAM);
        }
        public static function GetTeamInfo():void{
        }
        public static function getMemberPos(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_TEAM_MEMBERPOS;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function InviteOther(_arg1:int):void{
            sendTeamCmd(TeamDataProxy.CTEAMCMD_INVITE, _arg1);
        }
        public static function KickOut(_arg1:int):void{
            sendTeamCmd(TeamDataProxy.CTEAMCMD_KICKPLAYER, _arg1);
        }
        public static function ChgLeader(_arg1):void{
            sendTeamCmd(TeamDataProxy.CTEAMCMD_CHANGELEADER, _arg1);
        }
        public static function RefushAroundTeam():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_INRANGETEAM;
            _local1.SendPacket();
        }
        public static function AutoApplySetting(_arg1:Boolean):void{
            sendTeamCmd(TeamDataProxy.CTEAMCMD_CHANGE_JOINTEAMMODE, _arg1);
        }
        public static function LeaveTeam():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_REQUEST_LEAVETEAM;
            _local1.SendPacket();
        }
        private static function sendTeamCmd(_arg1:int, ... _args):void{
            var _local4:int;
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PLAYERTEAMCMD;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            switch (_arg1){
                case TeamDataProxy.CTEAMCMD_CHANGE_JOINTEAMMODE:
                    _local3.m_sendpacket.writeBoolean(_args[0]);
                    break;
                default:
                    while (_local4 < _args.length) {
                        _local3.m_sendpacket.writeUnsignedInt(_args[_local4]);
                        _local4++;
                    };
            };
            _local3.SendPacket();
        }
        public static function GetApplyList():void{
        }
        public static function ApplyJoin(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_REQUEST_JOINTEAM;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function CreateTeam():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_REQUEST_CREATETEAM;
            _local1.SendPacket();
        }
        public static function RecallInvite(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PLAYER_REPLYINVITE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function RecallApply(_arg1, _arg2:int):void{
            sendTeamCmd(TeamDataProxy.CTEAMCMD_JOINTEAMREPLY, _arg1, _arg2);
        }

    }
}//package Net.RequestSend 
