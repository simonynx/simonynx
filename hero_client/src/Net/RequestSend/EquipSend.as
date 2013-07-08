//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class EquipSend {

        public static const BATCH_REBUILD_PET:int = 1;
        public static const BATCH_REBUILD_REPLACE:int = 0;
        public static const BATCH_REBUILD_TREASURE:int = 2;

        public static function TreasureReset(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_TREASURE_RESET;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function PetLearn(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PET_LEARNSKILL;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function ItemActivate(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_ITEM_ACTIVATE;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function PetStrengthen(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PET_STRENGTHEN;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function ItemBreak(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ITEM_BREAK;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function RuneUnEmbed(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_ITEM_GET_OUT;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.SendPacket();
        }
        public static function TreasureRebuild(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_TREASURE_REBUILD;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function ItemStrength(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint):void{
            var _local7:GameNet = GameCommonData.GameNets;
            _local7.m_sendpacket.opcode = Protocol.CMSG_ITEM_STRENGTH;
            _local7.m_sendpacket.writeUnsignedInt(_arg1);
            _local7.m_sendpacket.writeUnsignedInt(_arg2);
            _local7.m_sendpacket.writeUnsignedInt(_arg3);
            _local7.m_sendpacket.writeUnsignedInt(_arg4);
            _local7.m_sendpacket.writeUnsignedInt(_arg5);
            _local7.m_sendpacket.writeUnsignedInt(_arg6);
            _local7.SendPacket();
        }
        public static function RuneIdentify(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_ITEM_IDENTIFY;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function RuneCompose(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint):void{
            var _local7:GameNet = GameCommonData.GameNets;
            _local7.m_sendpacket.opcode = Protocol.CMSG_ITEM_COMPOSE;
            _local7.m_sendpacket.writeUnsignedInt(_arg1);
            _local7.m_sendpacket.writeUnsignedInt(_arg2);
            _local7.m_sendpacket.writeUnsignedInt(_arg3);
            _local7.m_sendpacket.writeUnsignedInt(_arg4);
            _local7.m_sendpacket.writeUnsignedInt(_arg5);
            _local7.m_sendpacket.writeUnsignedInt(_arg6);
            _local7.SendPacket();
        }
        public static function TreasureTransfer(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_TREASURE_SKILLCHANGE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function PetRebuild(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_PET_REBUILD;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function PetUpgrade(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_PET_UPGRADE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function SoulBoom():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_SOUL_BOOM;
            _local1.SendPacket();
        }
        public static function RuneEmbed(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_ITEM_ACTIVATE;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function BatchRebuild(_arg1:int, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_BATCH_REBUILD;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function EquipRefine(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_EQUIP_COMPOSE;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function ItemOrnamentStrength(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint):void{
            var _local7:GameNet = GameCommonData.GameNets;
            _local7.m_sendpacket.opcode = Protocol.CMSG_ORNAMENT_STRENGTHEN;
            _local7.m_sendpacket.writeUnsignedInt(_arg1);
            _local7.m_sendpacket.writeUnsignedInt(_arg2);
            _local7.m_sendpacket.writeUnsignedInt(_arg3);
            _local7.m_sendpacket.writeUnsignedInt(_arg4);
            _local7.m_sendpacket.writeUnsignedInt(_arg5);
            _local7.m_sendpacket.writeUnsignedInt(_arg6);
            _local7.SendPacket();
        }
        public static function TreasureSacrifice(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_TREASURE_SACRIFICE;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function ItemPour(_arg1:uint, _arg2:uint):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_ITEM_POUR;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeUnsignedInt(_arg2);
            _local3.SendPacket();
        }
        public static function TreasureLevelUp():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_TREASURE_LEVELUP;
            _local1.SendPacket();
        }
        public static function ItemTransfer(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):void{
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_ITEM_TRANSFER;
            _local5.m_sendpacket.writeUnsignedInt(_arg1);
            _local5.m_sendpacket.writeUnsignedInt(_arg2);
            _local5.m_sendpacket.writeUnsignedInt(_arg3);
            _local5.m_sendpacket.writeUnsignedInt(_arg4);
            _local5.SendPacket();
        }

    }
}//package Net.RequestSend 
