//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Entrust.Data.*;

    public class EntrustAction extends GameAction {

        private static var instance:EntrustAction;

        private var ENTRUST_MYLIST:uint = 2;
        private var ENTRUST_REDUCE_RESULT:uint = 2;
        private var ENTRUST_SELL_RESULT:uint = 1;
        private var ENTRUST_APPLYLIST:uint = 1;

        public function EntrustAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():EntrustAction{
            if (instance == null){
                instance = new (EntrustAction)();
            };
            return (instance);
        }

        private function EntrustResponse(_arg1:NetPacket):void{
            var _local3:uint;
            var _local4:EntrustInfo;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local5:uint;
            switch (_local2){
                case ENTRUST_MYLIST:
                    _local3 = _arg1.readUnsignedInt();
                    EntrustData.MyEntrustList = [];
                    _local5 = 0;
                    while (_local5 < _local3) {
                        _local4 = new EntrustInfo();
                        _local4.priceType = _arg1.readUnsignedInt();
                        _local4.price = _arg1.readUnsignedInt();
                        _local4.item.ReadFromPacket(_arg1);
                        _local4.itemguid = _local4.item.ItemGUID;
                        _local4.templateId = _local4.item.TemplateID;
                        _local4.num = _local4.item.Count;
                        EntrustData.MyEntrustList.push(_local4);
                        _local5++;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_MYENTRUST);
                    break;
                case ENTRUST_APPLYLIST:
                    _local3 = _arg1.readUnsignedInt();
                    EntrustData.currPageEntrustList = [];
                    _local5 = 0;
                    while (_local5 < EntrustData.PAGE_NUM) {
                        if (_local5 < _local3){
                            _local4 = new EntrustInfo();
                            _local4.priceType = _arg1.readUnsignedInt();
                            _local4.price = _arg1.readUnsignedInt();
                            _local4.item.ReadFromPacket(_arg1);
                            _local4.itemguid = _local4.item.ItemGUID;
                            _local4.templateId = _local4.item.TemplateID;
                            _local4.num = _local4.item.Count;
                            trace(_local4.item.Name);
                            EntrustData.currPageEntrustList[_local5] = _local4;
                        } else {
                            EntrustData.currPageEntrustList[_local5] = null;
                        };
                        _local5++;
                    };
                    if (_local3 > 0){
                        EntrustData.currEntrustPage = (_arg1.readUnsignedInt() - 1);
                        EntrustData.totalEntrustPage = _arg1.readUnsignedInt();
                    };
                    trace(EntrustData.currEntrustPage, EntrustData.totalEntrustPage);
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_ENTRUST_LIST);
                    break;
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_ENTRUST_ITEM:
                    EntrustResponse(_arg1);
                    break;
                case Protocol.SMSG_ENTRUST_ITEMRESULT:
                    EntrustResult(_arg1);
                    break;
            };
        }
        private function EntrustResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            switch (_local2){
                case ENTRUST_SELL_RESULT:
                    UIFacade.GetInstance().sendNotification(EventList.ENTRUST_SUCESS);
                    break;
                case ENTRUST_REDUCE_RESULT:
                    UIFacade.GetInstance().sendNotification(EventList.REFRESH_MYENTRUST_LIST);
                    break;
            };
        }

    }
}//package Net.PackHandler 
