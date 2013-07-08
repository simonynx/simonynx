//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Mail.Data.*;

    public class MailAction extends GameAction {

        private static var instance:MailAction;

        public function MailAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():MailAction{
            if (instance == null){
                instance = new (MailAction)();
            };
            return (instance);
        }

        private function delMail(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            facade.sendNotification(MailEvent.DELMAIL);
        }
        private function takMailItemResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local4 == 0){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("操作成功"),
                    color:0xFFFF00
                });
                facade.sendNotification(MailEvent.TAKEMAILITEM, {
                    mailId:_local2,
                    guid:_local3
                });
            } else {
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("bagisfull"),
                    color:0xFFFF00
                });
            };
        }
        private function sure():void{
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_MAIL_LIST_RESULT:
                    getMailList(_arg1);
                    break;
                case Protocol.SMSG_ITEM_TEXT_QUERY_RESPONSE:
                    readMailResponse(_arg1);
                    break;
                case Protocol.SMSG_SEND_MAIL_RESULT:
                    sendMailResult(_arg1);
                    break;
                case Protocol.SMSG_RECEIVED_MAIL:
                    receiveMail(_arg1);
                    break;
                case Protocol.SMSG_MAIL_TAKE_ITEM_RESULT:
                    takMailItemResult(_arg1);
                    break;
                case Protocol.SMSG_MAIL_DELETE_RESULT:
                    deleteMailResult(_arg1);
                    break;
            };
        }
        private function receiveMail(_arg1:NetPacket):void{
            var _local4:MailItemInfo;
            var _local5:uint;
            var _local6:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            if (_local2 == 0){
                _local2 = 1;
            };
            var _local3:uint;
            _local3 = 0;
            while (_local3 < _local2) {
                _local4 = new MailItemInfo();
                _local4.mailId = _arg1.readUnsignedInt();
                _local5 = 0;
                while (_local5 < MailConstData.mailList.length) {
                    if (MailConstData.mailList[_local5].mailId == _local4.mailId){
                        return;
                    };
                    _local5++;
                };
                _local4.mailType = _arg1.readByte();
                _local4.senderId = _arg1.readUnsignedInt();
                _local4.senderName = _arg1.ReadString();
                _local4.timeStamp = _arg1.readUnsignedInt();
                _local4.hasRead = _arg1.readBoolean();
                _local4.title = _arg1.ReadString();
                _local4.binding = _arg1.readUnsignedInt();
                _local4.itemNum = _arg1.readByte();
                if (_local4.itemNum > 0){
                    _local4.items = new Array();
                    _local6 = 0;
                    while (_local6 < _local4.itemNum) {
                        _local4.items.push(_arg1.readUnsignedInt());
                        _local4.items.push(_arg1.readUnsignedInt());
                        _local4.items.push(_arg1.readUnsignedInt());
                        _local6++;
                    };
                };
                MailConstData.noReadNum++;
                if (GameCommonData.Player.Role.Id == _local4.senderId){
                    _local4.hasRead = true;
                    facade.sendNotification(MailEvent.ADDMAIL, {item:_local4});
                } else {
                    facade.sendNotification(MailEvent.ADDMAIL, {item:_local4});
                };
                _local3++;
            };
        }
        private function getMailList(_arg1:NetPacket):void{
            var _local4:Boolean;
            var _local5:MailItemInfo;
            var _local7:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            _local3 = 0;
            while (_local3 < _local2) {
                _local5 = new MailItemInfo();
                _local5.mailId = _arg1.readUnsignedInt();
                if (_local5.mailId == 0){
                    trace("error:mail id is zero");
                };
                _local5.mailType = _arg1.readByte();
                _local5.senderId = _arg1.readUnsignedInt();
                _local5.senderName = _arg1.ReadString();
                _local5.timeStamp = _arg1.readUnsignedInt();
                _local5.hasRead = _arg1.readBoolean();
                _local5.title = _arg1.ReadString();
                _local5.binding = _arg1.readUnsignedInt();
                _local5.itemNum = _arg1.readByte();
                if (_local5.itemNum > 0){
                    _local5.items = new Array();
                    _local7 = 0;
                    while (_local7 < _local5.itemNum) {
                        _local5.items.push(_arg1.readUnsignedInt());
                        _local5.items.push(_arg1.readUnsignedInt());
                        _local5.items.push(_arg1.readUnsignedInt());
                        _local7++;
                    };
                };
                if (GameCommonData.Player.Role.Id == _local5.senderId){
                } else {
                    if (_local5.hasRead == false){
                        _local4 = true;
                        MailConstData.noReadNum++;
                    };
                    MailConstData.mailList.splice(0, 0, _local5);
                };
                _local3++;
            };
            var _local6:uint = _arg1.readUnsignedInt();
            _local3 = 0;
            while (_local3 < _local6) {
                _local5 = new MailItemInfo();
                _local5.mailId = _arg1.readUnsignedInt();
                _local5.mailType = 0;
                _local5.senderName = _arg1.ReadString();
                _local5.hasRead = true;
                _local5.title = _arg1.ReadString();
                _local5.itemNum = 0;
                _local5.bodyText = _arg1.ReadString();
                _local5.timeStamp = _arg1.readUnsignedInt();
                MailConstData.mailSelfList.push(_local5);
                _local3++;
            };
            if (_local4){
                facade.sendNotification(MailEvent.MAILMESSAGE);
            };
        }
        private function sendMailResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local4 == 4){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("邮件提示1"),
                    color:0xFFFF00
                });
                return;
            };
            if (_local2 != 0){
                if (_local4 == 0){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("邮件提示2"),
                        color:0xFFFF00
                    });
                    facade.sendNotification(MailEvent.CLOSEMAILNEW, _local2);
                    return;
                };
            };
            if (_local2 == 0){
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("邮件提示2")
                });
                facade.sendNotification(EventList.CLOSE_GMMAIL_UI);
                return;
            };
            if (_local3 == 4){
                facade.sendNotification(MailEvent.DELMAIL, {mailIds:[_local2]});
                return;
            };
        }
        private function readMailResponse(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            facade.sendNotification(MailEvent.READMAILBODY, {
                mailId:_local2,
                bodyText:_local3
            });
        }
        private function deleteMailResult(_arg1:NetPacket):void{
            var _local5:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Array = [];
            var _local4:uint;
            while (_local4 < _local2) {
                _local5 = _arg1.readUnsignedInt();
                _local3.push(_local5);
                _local4++;
            };
            facade.sendNotification(MailEvent.DELMAIL, {mailIds:_local3});
        }

    }
}//package Net.PackHandler 
