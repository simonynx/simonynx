//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Mail.Data.*;

    public class MailSend {

        public static function takeMailItem(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_MAIL_TAKE_ITEM;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function requestMailList():void{
            var _local1:GameNet;
            if (MailConstData.hasGetData){
                UIFacade.GetInstance().sendNotification(EventList.SHOWMAIL);
            } else {
                _local1 = GameCommonData.GameNets;
                _local1.m_sendpacket.opcode = Protocol.CMSG_GET_MAIL_LIST;
                _local1.SendPacket();
            };
            MailConstData.hasGetData = true;
        }
        public static function requestMailBody(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ITEM_TEXT_QUERY;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function delMail(_arg1:Array):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_MAIL_DELETE;
            var _local3:uint = _arg1.length;
            _local2.m_sendpacket.writeUnsignedInt(_arg1.length);
            var _local4:uint;
            while (_local4 < _local3) {
                _local2.m_sendpacket.writeUnsignedInt(_arg1[_local4]);
                _local4++;
            };
            _local2.SendPacket();
        }
        public static function maskMailAsRead(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_MAIL_MARK_AS_READ;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function sendMail(_arg1:String, _arg2:String, _arg3:String, _arg4:uint=1):void{
            var _local5:GameNet = GameCommonData.GameNets;
            _local5.m_sendpacket.opcode = Protocol.CMSG_SEND_MAIL;
            _local5.m_sendpacket.WriteString(_arg1);
            if (_arg1 == "GM"){
                _local5.m_sendpacket.writeUnsignedInt(_arg4);
            };
            _local5.m_sendpacket.WriteString(_arg2);
            _local5.m_sendpacket.WriteString(_arg3);
            _local5.SendPacket();
        }

    }
}//package Net.RequestSend 
