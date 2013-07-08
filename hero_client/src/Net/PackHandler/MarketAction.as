//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.NPCShop.Data.*;

    public class MarketAction extends GameAction {

        private static var _instance:MarketAction;

        public function MarketAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():MarketAction{
            if (!_instance){
                _instance = new (MarketAction)();
            };
            return (_instance);
        }

        private function buyResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readByte();
            if (_local2 != 0){
                trace("购买失败");
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("购买失败"),
                    color:0xFFFF00
                });
                facade.sendNotification(NPCShopEvent.NPC_TRADE_ERROR, _local2);
                return;
            };
            facade.sendNotification(NPCExchangeEvent.NPC_EXCHANGE_SUCESS);
            if (BagData.SelectIndex != 0){
                facade.sendNotification(BagEvents.BAG_GOTO_SOME_INDEX, 0);
            };
            trace("购买成功");
            UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX] = [];
            MarketSend.getShopItemList(MarketConstData.SHOPTYPE_SALES);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_PLAZA_GOODS:
                    getShopItemList(_arg1);
                    break;
                case Protocol.SMSG_BUY_ITEM:
                    buyResult(_arg1);
                    break;
                case Protocol.SMSG_SHOPPING:
                    marketBuyResult(_arg1);
                    break;
            };
        }
        private function getShopItemList(_arg1:NetPacket):void{
            var _local3:ShopItemInfo;
            var _local4:int;
            var _local5:int;
            var _local6:uint;
            var _local7:int;
            var _local2:uint = _arg1.readUnsignedInt();
            switch (_local2){
                case MarketConstData.SHOPTYPE_PLAZA:
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = 0;
                    _local5 = 0;
                    while (_local5 < UIConstData.MarketGoodList.length) {
                        UIConstData.MarketGoodList[_local5] = [];
                        _local5++;
                    };
                    _local5 = 0;
                    while (_local5 < _local4) {
                        _local3 = new ShopItemInfo();
                        _local3.ReadFromPacket(_arg1);
                        _local3.ShopType = _local2;
                        if (_local3.ClassTypeFlag > 0){
                            if (UIConstData.MarketGoodList[(_local3.ClassTypeFlag - 1)]){
                                UIConstData.MarketGoodList[(_local3.ClassTypeFlag - 1)].push(_local3);
                            };
                        };
                        _local5++;
                    };
                    _local5 = 0;
                    while (_local5 < UIConstData.MarketGoodList.length) {
                        UIConstData.MarketGoodList[_local5].sortOn("SortVal", Array.NUMERIC);
                        _local5++;
                    };
                    MarketConstData.IsLoadMarketGoodList = true;
                    break;
                case MarketConstData.SHOPTYPE_SALES:
                    _local4 = _arg1.readUnsignedInt();
                    UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX] = [];
                    _local5 = 0;
                    _local5 = 0;
                    while (_local5 < _local4) {
                        _local3 = new ShopItemInfo();
                        _local3.ReadFromPacket(_arg1);
                        _local3.ShopType = _local2;
                        UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX].push(_local3);
                        _local5++;
                    };
                    _local3 = new ShopItemInfo();
                    _local3.ReadFromPacket(_arg1);
                    if (_local3.ShopId > 0){
                        MarketConstData.SelfDayLimitCntBuyShopItemObj = {
                            info:_local3,
                            cnt:_arg1.readUnsignedInt()
                        };
                    } else {
                        MarketConstData.SelfDayLimitCntBuyShopItemObj = {
                            info:null,
                            cnt:0
                        };
                    };
                    UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX].sortOn("SortVal", Array.NUMERIC);
                    facade.sendNotification(MarketEvent.UPDATE_MARKETSALES);
                    break;
                case 0:
                    MarketConstData.MarketDayLimitCntBuyRecord = new Dictionary();
                    _local5 = 0;
                    _local5 = 0;
                    while (_local5 < 10) {
                        _local4 = _arg1.readUnsignedInt();
                        MarketConstData.MarketDayLimitCntBuyRecord[_local5] = _local4;
                        _local5++;
                    };
            };
        }
        private function marketBuyResult(_arg1:NetPacket):void{
            if (((!((facade.retrieveProxy(DataProxy.NAME) as DataProxy).treasureBatchIsOpen)) && (!((facade.retrieveProxy(DataProxy.NAME) as DataProxy).petBatchIsOpen)))){
                MessageTip.popup(LanguageMgr.GetTranslation("购买成功"));
            };
        }

    }
}//package Net.PackHandler 
