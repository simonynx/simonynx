//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import Net.*;

    public class CharacterSend {

        public static const FASHION_VISIBLE_CHANGE:uint = 1;

        public static function CharRename(_arg1:int, _arg2:String){
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_CHAR_RENAME;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.WriteString(_arg2);
            _local3.SendPacket();
        }
        public static function GetReward(_arg1:int, _arg2:int=0):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_GET_STH;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            if (_arg2 != 0){
                _local3.m_sendpacket.writeUnsignedInt(_arg2);
            };
            _local3.SendPacket();
        }
        public static function getMyCharaterInfo():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_CHARINFO;
            _local1.SendPacket();
        }
        public static function chooseUseTitle(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_CHOOSE_TITLE;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function loginRole(_arg1:int, _arg2:int):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_ENTERGAME;
            _local3.m_sendpacket.writeInt(_arg1);
            _local3.m_sendpacket.writeInt(_arg2);
            _local3.SendPacket();
        }
        public static function createRole(_arg1:int, _arg2:String, _arg3:uint, _arg4:uint, _arg5:uint):void{
            var _local6:GameNet = GameCommonData.GameNets;
            _local6.m_sendpacket.opcode = Protocol.CMSG_CHAR_CREATE;
            _local6.m_sendpacket.writeUnsignedInt(_arg1);
            _local6.m_sendpacket.WriteString(_arg2);
            _local6.m_sendpacket.writeUnsignedInt(_arg3);
            _local6.m_sendpacket.writeUnsignedInt(_arg5);
            _local6.m_sendpacket.writeUnsignedInt(_arg4);
            _local6.SendPacket();
        }
        public static function CheckName(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_CHAR_NAMECHECK;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function GetRewardReward(_arg1:int):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_GET_STH;
            _local2.m_sendpacket.writeUnsignedInt(5000);
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function KeepRole(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_KEEP_MERGE_ROLES_REQUEST;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function sendCurrentStep(_arg1:String):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = 0;
            _local2.m_sendpacket.WriteString(_arg1);
            _local2.SendPacket();
        }
        public static function requestChange(_arg1:uint, _arg2:Boolean):void{
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_CHAR_CHANGE;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeBoolean(_arg2);
            _local3.SendPacket();
        }

    }
}//package Net.RequestSend 
