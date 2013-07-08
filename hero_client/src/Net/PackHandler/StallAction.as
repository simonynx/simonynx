//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Stall.Data.*;

    public class StallAction extends GameAction {

        public static const STALL_ERROR_NONE:uint = 0;
        public static const STALL_ERROR_ITEM:uint = 3;
        public static const STALL_ERROR_AMOUNT:uint = 4;
        public static const STALL_ERROR_VERSION:uint = 2;
        public static const STALL_ERROR_BACKPACK:uint = 6;
        public static const STALL_ERROR_PLAYER:uint = 1;
        public static const STALL_ERROR_MONEY:uint = 5;

        private static var instance:StallAction;

        public function StallAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():StallAction{
            if (instance == null){
                instance = new (StallAction)();
            };
            return (instance);
        }

        private function stallSell(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            switch (_local2){
                case STALL_ERROR_NONE:
                    facade.sendNotification(StallEvents.UPDATEDOWNSTALLITEM, {
                        param:_local3,
                        num:_local4
                    });
                    break;
                case STALL_ERROR_PLAYER:
                    break;
                case STALL_ERROR_VERSION:
                    break;
                case STALL_ERROR_ITEM:
                    facade.sendNotification(StallEvents.UPDATEDOWNSTALLITEM, {
                        param:_local3,
                        num:_local4
                    });
                    break;
                case STALL_ERROR_AMOUNT:
                    break;
                case STALL_ERROR_MONEY:
                    break;
                case STALL_ERROR_BACKPACK:
                    break;
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_STALL_BEGIN:
                    stallBegin(_arg1);
                    break;
                case Protocol.SMSG_STALL_GOODS:
                    getStallGoods(_arg1);
                    break;
                case Protocol.SMSG_STALL_BUY:
                    stallBuy(_arg1);
                    break;
                case Protocol.SMSG_STALL_SELL:
                    stallSell(_arg1);
                    break;
                case Protocol.SMSG_STALL_RESULT:
                    stallResult(_arg1);
                    break;
                case Protocol.SMSG_STALL_NAME:
                    stallName(_arg1);
                    break;
                case Protocol.SMSG_STALL_END:
                    stallEnd(_arg1);
                    break;
            };
        }
        private function stallBuy(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3 = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            switch (_local2){
                case STALL_ERROR_NONE:
                    facade.sendNotification(StallEvents.UPDATESTALLITEM, {
                        param:_local3,
                        num:_local4
                    });
                    break;
                case STALL_ERROR_PLAYER:
                    break;
                case STALL_ERROR_VERSION:
                    break;
                case STALL_ERROR_ITEM:
                    facade.sendNotification(StallEvents.UPDATESTALLITEM, {
                        param:_local3,
                        num:_local4
                    });
                    break;
                case STALL_ERROR_AMOUNT:
                    break;
                case STALL_ERROR_MONEY:
                    break;
                case STALL_ERROR_BACKPACK:
                    break;
            };
        }
        private function stallBegin(_arg1:NetPacket):void{
            var _local7:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            var _local4 = -1;
            _local3 = 0;
            while (_local3 < _local2) {
                _local7 = _arg1.readUnsignedInt();
                if (StallConstData.goodUpList[_local7]){
                    facade.sendNotification(EventList.BAGITEMUNLOCK, StallConstData.goodUpList[_local7].id);
                    StallConstData.goodUpList.splice(_local7, 1);
                    StallConstData.goodUpList.push(null);
                    StallConstData.sellNum--;
                    StallConstData.idToPlace1--;
                };
                if (_local4 == -1){
                    _local4 = _local7;
                };
                _local3++;
            };
            var _local5:uint = _arg1.readUnsignedInt();
            var _local6 = -1;
            _local3 = 0;
            while (_local3 < _local5) {
                _local7 = _arg1.readUnsignedInt();
                if (StallConstData.goodDownList[_local7]){
                    facade.sendNotification(EventList.BAGITEMUNLOCK, StallConstData.goodDownList[_local7].id);
                    StallConstData.goodDownList.splice(_local3, 1);
                    StallConstData.goodDownList.push(null);
                    StallConstData.buyNum--;
                    StallConstData.idToPlace2--;
                };
                if (_local6 == -1){
                    _local6 = _local7;
                };
                _local3++;
            };
            if (_local2 > 0){
                facade.sendNotification(StallEvents.ERRORSTALL, {
                    start:_local4,
                    flag:0
                });
            };
            if (_local5 > 0){
                facade.sendNotification(StallEvents.ERRORSTALL, {
                    start:_local6,
                    flag:1
                });
            };
        }
        private function stallEnd(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            if (GameCommonData.Player.Role.Id == _local2){
                GameCommonData.Player.Role.isStalling = 0;
            } else {
                if (GameCommonData.SameSecnePlayerList[_local2]){
                    GameCommonData.SameSecnePlayerList[_local2].Role.isStalling = 0;
                };
            };
        }
        private function stallName(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            facade.sendNotification(StallEvents.STALLNAME, {
                playerid:_local2,
                name:_local3
            });
        }
        private function getStallGoods(_arg1:NetPacket):void{
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            if (_local2 == 0){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("距离太远"),
                    color:0xFFFF00
                });
                return;
            };
            if (GameCommonData.GameInstance.GameScene.GetGameScene.name != "1004"){
                return;
            };
            StallConstData.stallIdToQuery = _local2;
            StallConstData.timeStamp = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint;
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = _arg1.readUnsignedInt();
                StallConstData.goodUpList[_local5] = new InventoryItemInfo();
                StallConstData.goodUpList[_local5].ReadFromPacket(_arg1);
                _local6 = _arg1.readUnsignedInt();
                _local7 = _arg1.readUnsignedInt();
                StallConstData.goodUpList[_local5].index = -1;
                StallConstData.goodUpList[_local5].type = StallConstData.goodUpList[_local5].TemplateID;
                StallConstData.goodUpList[_local5].isBind = 0;
                StallConstData.goodUpList[_local5].id = StallConstData.goodUpList[_local5].ItemGUID;
                StallConstData.goodUpList[_local5].ItemGUID = StallConstData.goodUpList[_local5].ItemGUID;
                StallConstData.goodUpList[_local5].price = _local6;
                StallConstData.goodUpList[_local5].Count = _local7;
                _local4++;
            };
            _local3 = _arg1.readUnsignedInt();
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = _arg1.readUnsignedInt();
                _local8 = _arg1.readUnsignedInt();
                _local6 = _arg1.readUnsignedInt();
                _local7 = _arg1.readUnsignedInt();
                StallConstData.goodDownList[_local5] = new Object();
                StallConstData.goodDownList[_local5].index = -1;
                StallConstData.goodDownList[_local5].type = _local8;
                StallConstData.goodDownList[_local5].isBind = 0;
                StallConstData.goodDownList[_local5].price = _local6;
                StallConstData.goodDownList[_local5].Count = _local7;
                _local4++;
            };
            facade.sendNotification(StallEvents.SHOWSOMESTALL);
            facade.sendNotification(EventList.STALLALLITEM);
        }
        private function stallResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            facade.sendNotification(StallEvents.STALLRESULT, {
                upFlag:_local2,
                place:_local3,
                num:_local4
            });
        }

    }
}//package Net.PackHandler 
