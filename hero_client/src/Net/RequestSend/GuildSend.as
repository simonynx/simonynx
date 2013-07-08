//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class GuildSend {

        public static function RichOffer(_arg1:int, _arg2:Array):void{
            var _local4:int;
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_OFFER;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2.length);
            while (_local4 < _arg2.length) {
                _local3.m_sendpacket.writeUnsignedInt(_arg2[_local4]);
                _local4++;
            };
            _local3.SendPacket();
        }
        public static function BanChatCancel(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_ALLOWCHAT;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ModifyPlacard(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_UPDATE_PLACARD;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function ApplyGuild(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_TRY_JOININ;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ApplyRecall(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            if (_arg2 == 0){
                _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_TRYIN_REFUSE;
            } else {
                if (_arg2 == 1){
                    _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_TRYIN_PASS;
                };
            };
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.SendPacket();
        }
        public static function GuildGB_GetApplyList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_CHALLENGE;
            _local1.m_sendpacket.writeUnsignedInt(4);
            _local1.SendPacket();
        }
        public static function KickOut(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_OUT_MEMBER;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function getDutyList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_DUTY_LIST;
            _local1.SendPacket();
        }
        public static function useGuildSkill(_arg1:int, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_SKILL_REQUEST;
            _local3.m_sendpacket.writeByte(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function getMemberList(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_MEMBER_LIST;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function DisbandGuild():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_DISBAND;
            _local1.SendPacket();
        }
        public static function TakeSalary():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_GET_SALARY;
            _local1.SendPacket();
        }
        public static function GetGuildAuras():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_GET_AURAS;
            _local1.SendPacket();
        }
        public static function GetGuildEventsList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_EVENT_LIST;
            _local1.SendPacket();
        }
        public static function createGuild(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_CREATE;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function InviteRecall(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            if (_arg2 == 0){
                _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_INVITE_DECLINE;
            } else {
                if (_arg2 == 1){
                    _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_INVITE_PASS;
                };
            };
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.SendPacket();
        }
        public static function GuildGB_Agree(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_CHALLENGE;
            _local2.m_sendpacket.writeUnsignedInt(3);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function EnterGuildFB(_arg1:uint=4001):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ENTER_SPECIAL_INSTANCE;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function CanApplyMode(_arg1:Boolean):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_APPLY_OPEN;
            _local2.m_sendpacket.writeBoolean(_arg1);
            _local2.SendPacket();
        }
        public static function OpenGuildFB(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_INSTANCE_START;
            _local2.m_sendpacket.writeByte(_arg1);
            _local2.SendPacket();
        }
        public static function BanChat(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_BLOCKCHAT;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function updateDuty(_arg1:int, _arg2:String, _arg3:int):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_GUILD_UPDATE_DUTY;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.WriteString(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function GuildRename(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_RENAME;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function updownDuty(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_MEMBER_GRADE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function GuildGB_Refuse(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_CHALLENGE;
            _local2.m_sendpacket.writeUnsignedInt(2);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function getApplyList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_APPLY_LIST;
            _local1.SendPacket();
        }
        public static function ChangeLeader(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_CHANGE_CHAIRMAN;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function InviteJoin(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_INVITE;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function getGuildList(_arg1:String="", _arg2:int=1):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GUILD_SEARCH;
            _local3.m_sendpacket.WriteString(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function GuildGB_Apply(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GUILD_CHALLENGE;
            _local2.m_sendpacket.writeUnsignedInt(1);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function getMyGuildInfo():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GUILD_MYGUILD;
            _local1.SendPacket();
        }

    }
}//package Net.RequestSend 
