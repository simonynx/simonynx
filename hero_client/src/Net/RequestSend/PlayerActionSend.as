//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import flash.utils.*;
    import Net.*;
    import Net.PackHandler.*;

    public class PlayerActionSend {

        public static const FLY_TRAINSMIT:int = 3;
        public static const SKILL_TYPE:int = 1;
        public static const POST_HOUSE_TRAINSMIT:int = 2;
        public static const REMOVE_QUICKITEM:int = 1;
        public static const ADD_QUICKITEM:int = 0;
        public static const MAP_TRAINSMIT:int = 1;
        public static const BAG_TYPE:int = 2;

        public static function PlayerRelive(_arg1:uint, _arg2:Object=null):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PLAYER_REQRESPAWN;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            if ((((_arg1 == 2)) && (_arg2))){
                _local3.m_sendpacket.writeUnsignedInt(_arg2.Id);
                _local3.m_sendpacket.writeUnsignedInt(_arg2.lev);
            };
            _local3.SendPacket();
        }
        public static function GotoTheParty(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GAME_FUNC_TRANSFER;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function SendSkill(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:int):void{
            var _local7:GameNet = GameCommonData.GameNets;
            _local7.m_sendpacket.opcode = Protocol.CMSG_CAST_SPELL;
            _local7.m_sendpacket.writeUnsignedInt(_arg1);
            _local7.m_sendpacket.writeUnsignedInt(_arg2);
            _local7.m_sendpacket.writeFloat(_arg3);
            _local7.m_sendpacket.writeFloat(_arg4);
            _local7.m_sendpacket.writeFloat(_arg5);
            _local7.m_sendpacket.writeFloat(_arg6);
            _local7.SendPacket();
        }
        public static function PlayerAttackStop():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_PLAYER_COMATTACK_STOP;
            _local1.SendPacket();
        }
        public static function ClearSkillPoint(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_CLEARSKILLPOINT;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function SendTowerRank():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_TOWER_RANKING_LIST;
            _local1.SendPacket();
        }
        public static function SendPkState(_arg1:Boolean, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_SET_PK_MODE;
            _local3.m_sendpacket.writeBoolean(_arg1);
            _local3.m_sendpacket.writeByte(_arg2);
            _local3.SendPacket();
        }
        public static function JumptoTowerLayer(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_TOWER_JUMP_REQUEST;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function DuelResult(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_DUEL_INVITE_REPLY;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeByte(_arg2);
            _local3.SendPacket();
        }
        public static function SendAttack(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PLAYER_COMATTACK_START;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function InViteDuelSend(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_DUEL_REQUEST;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function gameSceneLoadComplete(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_MAP_LOADED;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function SelectGlassType(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GET_SUMMER_GLOBET;
            _local2.m_sendpacket.writeByte(_arg1);
            _local2.SendPacket();
        }
        public static function SendPickItem(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_LOOT_PICKITEM;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function SendCheers(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PARTY_CHEERS_REQUEST;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function SendQuickOperate(_arg1:int, _arg2:int, _arg3:int=0, _arg4:int=0, _arg5:uint=0):void{
            if (_arg2 > 18){
                throw (new Error("快捷栏操作位置错误"));
            };
            var _local6:GameNet = GameCommonData.GameNets;
            _local6.m_sendpacket.opcode = Protocol.CMSG_HOTKEY_OPERATE;
            if (_arg1 == ADD_QUICKITEM){
                _local6.m_sendpacket.writeUnsignedInt(_arg1);
                _local6.m_sendpacket.writeUnsignedInt(_arg2);
                _local6.m_sendpacket.writeUnsignedInt(_arg3);
                _local6.m_sendpacket.writeUnsignedInt(_arg4);
                _local6.m_sendpacket.writeByte(_arg5);
                _local6.SendPacket();
            } else {
                _local6.m_sendpacket.writeUnsignedInt(_arg1);
                _local6.m_sendpacket.writeUnsignedInt(_arg2);
                _local6.SendPacket();
            };
        }
        public static function trainmitChange(_arg1:int, _arg2:int, _arg3:int):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_TRANSFERSCENE;
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.m_sendpacket.writeShort(_arg1);
            _local4.m_sendpacket.writeShort(_arg2);
            _local4.SendPacket();
        }
        public static function AddSkillPoint(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ADDSKILLPOINT;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendRoll(_arg1:int, _arg2:int, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_ROLL_ITEM_REQUEST;
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.SendPacket();
        }
        public static function GetPartyInfo(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GAME_FUNC_REQUEST;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function setTrap(_arg1:int, _arg2:int, _arg3:int):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_INSTANCE_MENU;
            _local4.m_sendpacket.writeUnsignedInt(3);
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function CollectObject(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GATHER_OBJECT;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function PlayerWalk(_arg1:int, _arg2:int, _arg3:int):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_PLAYER_MOVE;
            _local4.m_sendpacket.writeShort(_arg1);
            _local4.m_sendpacket.writeShort(_arg2);
            _local4.m_sendpacket.writeByte(_arg3);
            _local4.SendPacket();
        }
        public static function tellTheGuard(_arg1:int, _arg2:Boolean, _arg3:int):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_TOWER_GUARDIAN_OPERATE;
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeBoolean(_arg2);
            _local4.SendPacket();
        }
        public static function addFavoriteReward():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_STH;
            _local1.m_sendpacket.writeUnsignedInt(6000);
            _local1.SendPacket();
        }
        public static function TowerLoadComplete():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_TOWER_LAYER_LOADED;
            _local1.SendPacket();
        }
        public static function BeginMediation(_arg1:Boolean):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_REST_BENGIN;
            _local2.m_sendpacket.writeBoolean(_arg1);
            _local2.SendPacket();
        }
        public static function atonement():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_CLEAR_PK_VALUE;
            _local1.SendPacket();
        }
        public static function GetTheTreasure():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_ONLINEREWARD;
            _local1.SendPacket();
        }
        public static function LeaveTrancript():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_EXIT_INSTANCE;
            _local1.SendPacket();
        }
        public static function getGuardInfo():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_TOWER_GUARDIAN_INFO_REQUEST;
            _local1.SendPacket();
        }
        public static function highLevelOper(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_INSTANCE_MENU;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
