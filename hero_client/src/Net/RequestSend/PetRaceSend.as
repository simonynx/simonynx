//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.PetRace.Data.*;

    public class PetRaceSend {

        private static const CPF_INFOS_CHALLENGE_LIST:int = 2;
        private static const CPFO_APPLY:uint = 0;
        private static const CPFO_CHANGE_TEAM_NAME:uint = 2;
        private static const CPF_INFOS_SELFTEAM:uint = 0;
        private static const CPFO_REDEPLOY_FORMATION:uint = 6;
        private static const CPF_INFOS_TOTAL_RANK_LIST:uint = 6;
        private static const CPF_INFOS_SEASON_HISTORY_RANGE:uint = 16;
        private static const CPF_INFOS_RANK_LIST:uint = 4;
        private static const CPF_INFOS_HISTORY_REPORTS:uint = 14;
        private static const CPF_INFOS_GET_SIMPLE_REPORT:uint = 10;
        private static const CPFO_FORMATION_SETTING:uint = 4;
        private static const CPFO_CHALLENGE:uint = 8;
        private static const CPF_INFOS_FINAL_DUEL_LIST:uint = 8;

        public function PetRaceSend():void{
        }
        public static function UseRandomFormation(_arg1:Boolean):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_OPERATE;
            _local2.m_sendpacket.writeByte(CPFO_FORMATION_SETTING);
            _local2.m_sendpacket.writeBoolean(_arg1);
            _local2.SendPacket();
        }
        public static function GetPetRaceRankingInfo(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local2.m_sendpacket.writeByte(CPF_INFOS_RANK_LIST);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function GetCanDefyList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local1.m_sendpacket.writeByte(CPF_INFOS_CHALLENGE_LIST);
            _local1.SendPacket();
        }
        public static function GetPetRaceListInfo():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local1.m_sendpacket.writeByte(CPF_INFOS_SELFTEAM);
            _local1.SendPacket();
        }
        public static function GetFinalRacingList():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local1.m_sendpacket.writeByte(CPF_INFOS_FINAL_DUEL_LIST);
            _local1.SendPacket();
        }
        public static function Assign(_arg1:Array, _arg2:uint, _arg3:uint):void{
            if (_arg1 == null){
                return;
            };
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.m_sendpacket.writeUnsignedInt(_arg1.length);
            var _local5:uint;
            _local5 = 0;
            while (_local5 < _arg1.length) {
                _local4.m_sendpacket.writeUnsignedInt((_arg1[_local5] as InventoryItemInfo).ItemGUID);
                _local5++;
            };
            _local4.SendPacket();
        }
        public static function GetHistroyReport(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local2.m_sendpacket.writeByte(CPF_INFOS_HISTORY_REPORTS);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function DeployFormation(_arg1:uint, _arg2:uint, _arg3:Array):void{
            var _local7:Boolean;
            var _local8:uint;
            var _local4:uint = PetRaceConstData.teamChangeList.length;
            if (_local4 == 0){
                return;
            };
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_DEPLOY;
            _local5.m_sendpacket.writeUnsignedInt(_arg1);
            _local5.m_sendpacket.writeUnsignedInt(_arg2);
            _local5.m_sendpacket.writeUnsignedInt(_local4);
            var _local6:uint;
            _local6 = 0;
            while (_local6 < _local4) {
                _local7 = PetRaceConstData.teamChangeFlagList[_local6];
                _local8 = PetRaceConstData.teamChangeList[_local6];
                _local5.m_sendpacket.writeUnsignedInt(_local8);
                _local5.m_sendpacket.writeBoolean(_local7);
                _local6++;
            };
            _local5.SendPacket();
            PetRaceConstData.selectWaitFlag = true;
        }
        public static function GetReportInfo(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local4.m_sendpacket.writeByte(CPF_INFOS_GET_SIMPLE_REPORT);
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function GetLastRankingInfo(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_LIST_INFO;
            _local2.m_sendpacket.writeByte(CPF_INFOS_TOTAL_RANK_LIST);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function RenameTeam(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_OPERATE;
            _local2.m_sendpacket.writeByte(CPFO_CHANGE_TEAM_NAME);
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function SignUp(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_OPERATE;
            _local2.m_sendpacket.writeByte(CPFO_APPLY);
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function ApplyFormationConfig(_arg1:Array, _arg2:Boolean):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_OPERATE;
            _local3.m_sendpacket.writeByte(CPFO_FORMATION_SETTING);
            var _local4:uint = PetRaceConstData.getFormationValue(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_local4);
            _local3.m_sendpacket.writeBoolean(_arg2);
            _local3.SendPacket();
        }
        public static function Challenge(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_OPERATE;
            _local2.m_sendpacket.writeByte(CPFO_CHALLENGE);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ReDeployFormation(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):void{
            PetRaceConstData.selectWaitFlag = true;
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_PET_FIGHT_OPERATE;
            _local5.m_sendpacket.writeByte(CPFO_REDEPLOY_FORMATION);
            _local5.m_sendpacket.writeUnsignedInt(_arg1);
            _local5.m_sendpacket.writeUnsignedInt(_arg2);
            _local5.m_sendpacket.writeUnsignedInt(_arg3);
            _local5.m_sendpacket.writeUnsignedInt(_arg4);
            _local5.SendPacket();
        }

    }
}//package Net.RequestSend 
