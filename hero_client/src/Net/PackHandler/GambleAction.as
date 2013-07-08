//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.OpenItemBox.Data.*;

    public class GambleAction extends GameAction {

        private static var instance:GambleAction;

        private const GAMBLE_HISTORY_PERSONAL:uint = 1;
        private const GAMBLE_HISTORY_GADD:uint = 4;
        private const BOX_OP_MODIFY:uint = 5;
        private const GAMBLE_HISTORY_GLOBAL:uint = 2;
        private const BOX_OP_GET_ITEM:uint = 2;
        private const BOX_OP_RESULT:uint = 4;
        private const BOX_OP_SORT:uint = 3;
        private const GAMBLE_HISTORY_PADD:uint = 3;
        private const BOX_OP_QUERY:uint = 1;

        public function GambleAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():GambleAction{
            if (instance == null){
                instance = new (GambleAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_GAMBLE:
                    gambleResult(_arg1);
                    break;
                case Protocol.SMSG_GAMBLE_BOX:
                    gambleDepot(_arg1);
                    break;
                case Protocol.SMSG_GAMBLE_HISTORY:
                    gambleHistroy(_arg1);
                    break;
            };
        }
        private function gambleResult(_arg1:NetPacket):void{
            var _local4:Object;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            _local3 = 0;
            while (_local3 < _local2) {
                _local4 = new Object();
                _local4.pos = _local3;
                _local4.itemId = _arg1.readUnsignedInt();
                _local4.count = _arg1.readUnsignedInt();
                if (_local3 == 0){
                    GambleData.currGambleList = [];
                };
                GambleData.currGambleList.push(_local4);
                _local3++;
            };
            UIFacade.GetInstance().sendNotification(EventList.OPENITEMBOX_RESULT);
        }
        private function gambleHistroy(_arg1:NetPacket):void{
            var _local5:Object;
            var _local6:ItemTemplateInfo;
            var _local7:String;
            var _local8:String;
            var _local9:String;
            var _local10:ChatReceiveMsg;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint;
            switch (_local2){
                case GAMBLE_HISTORY_PERSONAL:
                case GAMBLE_HISTORY_PADD:
                    _local4 = 0;
                    while (_local4 < _local3) {
                        _local5 = new Object();
                        _local5.level = _arg1.readUnsignedInt();
                        _local5.itemId = _arg1.readUnsignedInt();
                        _local5.count = _arg1.readUnsignedInt();
                        if (_local2 == GAMBLE_HISTORY_PERSONAL){
                            GambleData.selfHistroyList.splice(0, 0, _local5);
                        } else {
                            GambleData.selfHistroyList.push(_local5);
                        };
                        _local4++;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_SELF_RECORD);
                    break;
                case GAMBLE_HISTORY_GLOBAL:
                case GAMBLE_HISTORY_GADD:
                    _local4 = 0;
                    while (_local4 < _local3) {
                        _local5 = new Object();
                        _local5.playerId = _arg1.readUnsignedInt();
                        _local5.playerName = _arg1.ReadString();
                        _local5.level = _arg1.readUnsignedInt();
                        _local5.itemId = _arg1.readUnsignedInt();
                        _local5.count = _arg1.readUnsignedInt();
                        GambleData.globalHistroyList.push(_local5);
                        if (_local2 == GAMBLE_HISTORY_GADD){
                            _local6 = UIConstData.ItemDic[_local5.itemId];
                            if (((_local6) && ((((_local6.Color == 3)) || ((_local6.TemplateID == 10100052)))))){
                                _local7 = (((((((((("<1_[" + _local6.Name) + "]_") + 0) + "_") + _local6.TemplateID) + "_0_") + 0) + "_") + _local6.Color) + ">");
                                _local8 = LanguageMgr.GetTranslation("[x]人品爆发在[y]的寻宝发现z", _local5.playerName, GambleData.labelNames[_local5.level], _local6.Name);
                                MessageTip.popup(_local8);
                                _local9 = LanguageMgr.GetTranslation("[0_x_4]人品爆发在[0_y_6]的寻宝发现z", _local5.playerName, GambleData.labelNames[_local5.level], _local7);
                                _local10 = new ChatReceiveMsg();
                                _local10.talkObj = new Array(5);
                                _local10.type = ChatData.CHAT_TYPE_STS;
                                _local10.sendId = _local5.playerId;
                                _local10.talkObj[0] = _local5.playerName;
                                _local10.talkObj[2] = "";
                                _local10.content = _local9;
                                _local10.color = 0xFFFF00;
                                _local10.talkObj[4] = int(_local10.color).toString(16);
                                _local10.talkObj[3] = _local9;
                                facade.sendNotification(CommandList.RECEIVECOMMAND, _local10);
                            };
                        };
                        _local4++;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_GLOBAL_RECORD, _local2);
                    break;
            };
        }
        private function gambleDepot(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:uint;
            var _local5:Object;
            var _local6:Array;
            var _local7:uint;
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local11:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            switch (_local2){
                case BOX_OP_GET_ITEM:
                    _local4 = _arg1.readUnsignedInt();
                    _local6 = [];
                    _local3 = 0;
                    while (_local3 < _local4) {
                        _local7 = _arg1.readUnsignedInt();
                        _local6.push(_local7);
                        _local3++;
                    };
                    _local3 = (_local6.length - 1);
                    while (_local3 >= 0) {
                        GambleData.gambleDepotList.splice(_local6[_local3], 1);
                        _local3--;
                    };
                    GambleData.DepotCount = (GambleData.DepotCount - _local4);
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_OPENITEMBOX_UI);
                    break;
                case BOX_OP_QUERY:
                    GambleData.gambleDepotList = [];
                    _local4 = _arg1.readUnsignedInt();
                    _local3 = 0;
                    while (_local3 < _local4) {
                        _local5 = GambleData.gambleDepotList[_local3];
                        if (!_local5){
                            _local5 = new Object();
                        };
                        _local5.itemId = _arg1.readUnsignedInt();
                        _local5.count = _arg1.readUnsignedShort();
                        GambleData.gambleDepotList[_local3] = _local5;
                        _local3++;
                    };
                    GambleData.DepotCount = _local4;
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_OPENITEMBOX_UI);
                    break;
                case BOX_OP_MODIFY:
                    _local4 = _arg1.readUnsignedInt();
                    _local3 = 0;
                    while (_local3 < _local4) {
                        _local8 = _arg1.readUnsignedInt();
                        _local9 = _arg1.readByte();
                        _local10 = _arg1.readUnsignedInt();
                        _local11 = _arg1.readUnsignedShort();
                        if (_local9 == 1){
                            _local5 = GambleData.gambleDepotList[_local8];
                            _local5.count = _local11;
                            GambleData.gambleDepotList[_local8] = _local5;
                        } else {
                            if (_local9 == 2){
                                _local5 = new Object();
                                _local5.itemId = _local10;
                                _local5.count = _local11;
                                GambleData.DepotCount++;
                                GambleData.gambleDepotList.splice(_local8, 0, _local5);
                            };
                        };
                        _local3++;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_OPENITEMBOX_UI);
                    break;
            };
        }

    }
}//package Net.PackHandler 
