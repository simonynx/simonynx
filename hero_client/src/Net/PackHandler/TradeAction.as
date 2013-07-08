//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.Modules.Trade.Data.*;

    public class TradeAction extends GameAction {

        public static const FALSE:uint = 5;
        public static const COMPLETE_ERROR_SYSERROR:uint = 3;
        public static const REFUSE:uint = 19;
        public static const DELITEMFAIL:uint = 20;
        public static const ADDITEM:uint = 6;
        public static const LOCK:uint = 15;
        public static const SELFMONEYALL:uint = 9;
        public static const ADDITEMFAIL:uint = 11;
        public static const BACK_WU:uint = 13;
        public static const COMPLETE_ERROR_DISTANCE:uint = 2;
        public static const UNLOCK_OP:uint = 24;
        public static const ADDMONEY:uint = 7;
        public static const UNLOCK:uint = 23;
        public static const BACK_MONEY:uint = 14;
        public static const OPEN:uint = 3;
        public static const APPLY:uint = 1;
        public static const QUIT:uint = 2;
        public static const AGREE_TRADE:uint = 34;
        public static const VASSELF:uint = 18;
        public static const OK:uint = 10;
        public static const NOTALLOW:uint = 12;
        public static const MONEYALL:uint = 8;
        public static const SUCCESS:uint = 4;
        public static const OPISTRADING:uint = 25;
        public static const ADDVAS:uint = 16;
        public static const VASOTHER:uint = 17;
        public static const ADDITEM_OP:uint = 21;
        public static const COMPLETE_ERROR_NONE:uint = 0;
        public static const COMPLETE_ERROR_SLOTSCOUNT:uint = 1;
        public static const CANCEL:uint = 27;

        private static var instance:TradeAction;

        public function TradeAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():TradeAction{
            if (instance == null){
                instance = new (TradeAction)();
            };
            return (instance);
        }

        private function tradeSelect(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:Object = new Object();
            if ((((_local2 == GameCommonData.Player.Role.Id)) && ((_local4 == 0)))){
                if (_local4 == 0){
                    _local5.id = _local3;
                    sendNotification(EventList.SHOWTRADE, _local5);
                } else {
                    if (_local4 == 1){
                        _local5.id = _local3;
                        sendNotification(TradeEvent.SOMEONEREFUSEME, _local5);
                    };
                };
            } else {
                if (_local3 == GameCommonData.Player.Role.Id){
                    if (_local4 == 0){
                        _local5.id = _local2;
                        sendNotification(EventList.SHOWTRADE, _local5);
                    } else {
                        if (_local4 == 1){
                            _local5.id = _local2;
                            sendNotification(TradeEvent.YOUREFUSESOMEONE, _local5);
                        };
                    };
                };
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_TRADE_ASK:
                    tradeAsk(_arg1);
                    break;
                case Protocol.SMSG_TRADE_INVITE:
                    tradeInvite(_arg1);
                    break;
                case Protocol.SMSG_TRADE_SELECT:
                    tradeSelect(_arg1);
                    break;
                case Protocol.SMSG_TRADE_ADDITEM:
                    tradeAddItem(_arg1);
                    break;
                case Protocol.SMSG_TRADE_CANCEL:
                    tradeCancel(_arg1);
                    break;
                case Protocol.SMSG_TRADE_LOCK:
                    tradeLock(_arg1);
                    break;
                case Protocol.SMSG_TRADE_CONFIRM:
                    tradeConfirm(_arg1);
                    break;
                case Protocol.SMSG_TRADE_COMPLETE:
                    tradeComplete(_arg1);
                    break;
                case Protocol.SMSG_TRADE_GOLD:
                    tradeAddMoney(_arg1);
                    break;
            };
        }
        private function tradeComplete(_arg1:NetPacket):void{
            var _local4:String;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Object = new Object();
            if (_local2 == 0){
                _local3.action = SUCCESS;
                sendNotification(EventList.UPDATETRADE, _local3);
            } else {
                _local3.action = FALSE;
                sendNotification(EventList.UPDATETRADE, _local3);
                if (_local2 == COMPLETE_ERROR_SLOTSCOUNT){
                    _local4 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("一方栏位不够")) + "</font>");
                    MessageTip.popup(_local4);
                } else {
                    if (_local2 == COMPLETE_ERROR_DISTANCE){
                        _local4 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("双方距离太远")) + "</font>");
                        MessageTip.popup(_local4);
                    } else {
                        if (_local2 == COMPLETE_ERROR_SYSERROR){
                            _local4 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("被系统移除")) + "</font>");
                            MessageTip.popup(_local4);
                        };
                    };
                };
            };
        }
        private function tradeAsk(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            if (!SharedManager.getInstance().showBI){
                return;
            };
            if (_local3 == 0){
                sendNotification(TradeEvent.SHOWTRADEINFORMATION, {
                    type:3,
                    targetid:_local2
                });
            } else {
                if (_local3 == 1){
                    sendNotification(TradeEvent.SHOWTRADEINFORMATION, {
                        type:4,
                        targetid:_local2
                    });
                } else {
                    if (_local3 == 2){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {
                            type:5,
                            targetid:_local2
                        });
                    };
                };
            };
        }
        private function tradeAddItem(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:InventoryItemInfo;
            if (_local3 < 10000){
                _local4 = new InventoryItemInfo();
                _local4.ReadFromPacket(_arg1);
            };
            var _local5:Object = new Object();
            if (_local2 == GameCommonData.Player.Role.Id){
                _local5.action = ADDITEM;
            } else {
                _local5.action = ADDITEM_OP;
            };
            _local5.data = _local4;
            _local5.place = _local3;
            sendNotification(EventList.UPDATETRADE, _local5);
        }
        private function tradeAddMoney(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Object = new Object();
            _local4.gold = _local3;
            if (_local2 == GameCommonData.Player.Role.Id){
                _local4.action = SELFMONEYALL;
            } else {
                _local4.action = MONEYALL;
            };
            sendNotification(EventList.UPDATETRADE, _local4);
        }
        private function tradeConfirm(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Object = new Object();
            _local3.action = OK;
            _local3.operId = _local2;
            sendNotification(EventList.UPDATETRADE, _local3);
        }
        private function tradeInvite(_arg1:NetPacket):void{
            var _local3:String;
            var _local4:NewInfoTipVo;
            var _local2:uint = _arg1.readUnsignedInt();
            if (GameCommonData.SameSecnePlayerList[_local2]){
                _local3 = GameCommonData.SameSecnePlayerList[_local2].Role.Name;
                _local4 = new NewInfoTipVo();
                _local4.title = ((("[" + _local3) + "]") + LanguageMgr.GetTranslation("邀请你交易"));
                _local4.type = NewInfoTipType.TYPE_TRADEINVITE;
                _local4.data = {targetId:_local2};
                _local4.addTime = TimeManager.Instance.Now().time;
                sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local4);
            };
        }
        private function tradeCancel(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Object = new Object();
            _local3.action = CANCEL;
            _local3.operId = _local2;
            sendNotification(EventList.UPDATETRADE, _local3);
        }
        private function tradeLock(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Object = new Object();
            _local3.action = LOCK;
            _local3.operId = _local2;
            sendNotification(EventList.UPDATETRADE, _local3);
        }

    }
}//package Net.PackHandler 
