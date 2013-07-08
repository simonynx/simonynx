//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsFramework.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import flash.net.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Maket.UI.*;
    import GameUI.*;
    //import GameUI.Modules.Maket.Proxy.*;

    public class MarketMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "MarketMediator";

        private var buyCDTimerOutSide:Timer;
        private var dataProxy:DataProxy;
        private var frame:HFrame;
        private var panelBase:PanelBase;

        public function MarketMediator(){
            super(NAME);
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:Object;
            var _local4:int;
            var _local5:uint;
            var _local6:ShopCarInfo;
            var _local7:ShopItemInfo;
            var _local8:Object;
            var _local9:Dictionary;
            var _local10:Object;
            var _local11:int;
            var _local12:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.SHOWMARKETVIEW:
                    if (GameCommonData.Player.Role.isStalling > 0){
                        MessageTip.show(LanguageMgr.GetTranslation("摆摊时无法打开商店"));
                        return;
                    };
                    if (MarketConstData.IsLoadMarketGoodList == false){
                        MessageTip.show(LanguageMgr.GetTranslation("商城数据加载中"));
                        return;
                    };
                    if (GameCommonData.IsInCrossServer){
                        return;
                    };
                    if (getViewComponent() == null){
                        setViewComponent(new MarketWindow());
                        buyCDTimerOutSide = new Timer(1000, 1);
                    };
                    view.closeCallBack = panelCloseHandler;
                    view.show();
                    view.centerFrame();
                    _local4 = 0;
                    if (_arg1.getBody() != null){
                        _local4 = int(_arg1.getBody());
                    };
                    view.setPage(_local4);
                    view.updateMoney();
                    dataProxy.MarketIsOpen = true;
                    view.showEffect();
                    if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                        GameCommonData.GameInstance.GameUI.Elements.Add(this);
                    };
                    UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX] = [];
                    MarketSend.getShopItemList(MarketConstData.SHOPTYPE_SALES);
                    break;
                case EventList.SHOW_GET_MONEY_VIEW:
                    if (getViewComponent() == null){
                        setViewComponent(new MarketWindow());
                        buyCDTimerOutSide = new Timer(1000, 1);
                    };
                    view.bgMc.btnExchange.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                case EventList.SHOWMARKETVIEW_TOGGLE:
                    if (!dataProxy.MarketIsOpen){
                        facade.sendNotification(EventList.SHOWMARKETVIEW);
                    };
                    MarketSend.getShopItemList(MarketConstData.SHOPTYPE_SALES);
                    _local5 = MarketConstData.getMarketClass(uint(_arg1.getBody()));
                    view.setPage(_local5);
                    break;
                case EventList.CLOSEMARKETVIEW:
                    if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) != -1){
                        GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                    };
                    dataProxy.MarketIsOpen = false;
                    view.close();
                    break;
                case MarketEvent.FILL_MONEY_SUCESS:
                    if (((((dataProxy) && (view))) && (dataProxy.MarketIsOpen))){
                        view.showEffect();
                        view.updateTakeMoney();
                    };
                    break;
                case MarketEvent.BUY_ITEM_MARKET:
                    if (buyCDTimerOutSide.running){
                        return;
                    };
                    if (GameCommonData.Player.Role.isStalling > 0){
                        MessageTip.show(LanguageMgr.GetTranslation("摆摊时不能购买物品"));
                        return;
                    };
                    _local6 = (_arg1.getBody() as ShopCarInfo);
                    if (_local6){
                        sureToBuy(_local6);
                    };
                    break;
                case EventList.UPDATEMONEY:
                    if (view){
                        view.updateMoney();
                    };
                    break;
                case MarketEvent.UPDATE_MONEY_MARKET:
                    if (view){
                        view.updateMoney();
                    };
                    break;
                case MarketEvent.UPDATE_MARKETSALES:
                    if (((((view) && (dataProxy))) && (dataProxy.MarketIsOpen))){
                        view.updateMarketSalesData();
                        view.setPage(view.currToggle);
                    };
                    break;
                case MarketEvent.SHOW_PETPREVIEW:
                    _local7 = (_arg1.getBody() as ShopItemInfo);
                    view.showPetPreview(_local7);
                    break;
                case EventList.UPDATE_ACTIVITY:
                    _local8 = MarketConstData.SelfDayLimitCntBuyShopItemObj;
                    _local9 = MarketConstData.MarketDayLimitCntBuyRecord;
                    _local10 = GameCommonData.activityData;
                    _local11 = 0;
                    _local12 = 55;
                    while (_local12 < 65) {
                        if (GameCommonData.activityData[_local12]){
                            MarketConstData.MarketDayLimitCntBuyRecord[_local11] = GameCommonData.activityData[_local12];
                        };
                        _local11++;
                        _local12++;
                    };
                    if (((((view) && (dataProxy))) && (dataProxy.MarketIsOpen))){
                        view.updateMarketSalesData();
                    };
                    break;
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        private function panelCloseHandler():void{
            facade.sendNotification(EventList.CLOSEMARKETVIEW);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWMARKETVIEW, EventList.SHOWMARKETVIEW_TOGGLE, EventList.CLOSEMARKETVIEW, MarketEvent.FILL_MONEY_SUCESS, MarketEvent.BUY_ITEM_MARKET, MarketEvent.UPDATE_MONEY_MARKET, EventList.UPDATEMONEY, MarketEvent.UPDATE_MARKETSALES, MarketEvent.SHOW_PETPREVIEW, EventList.UPDATE_ACTIVITY, EventList.SHOW_GET_MONEY_VIEW]);
        }
        private function get view():MarketWindow{
            return ((viewComponent as MarketWindow));
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function Update(_arg1:GameTime):void{
            view.updateTime(_arg1);
        }
        public function get UpdateOrder():int{
            return (0);
        }
        private function sureToBuy(_arg1:ShopCarInfo):void{
            var mmm:* = null;
            var payMoneyStr:* = null;
            var shopCarInfo:* = _arg1;
            mmm = MarketConstData.getCostMoney(shopCarInfo);
//            with ({}) {
//                {}.__confirmHandler = function ():void{
//                    if (GameCommonData.Player.Role.Gold < mmm[0]){
//                        UIFacade.GetInstance().LackofGold();
//                        return;
//                    };
//                    if (GameCommonData.Player.Role.Gift < mmm[1]){
//                        UIFacade.GetInstance().LackofGift();
//                        return;
//                    };
//                    if (GameCommonData.Player.Role.Money < mmm[2]){
//                        UIFacade.GetInstance().LackofGoldLeaf();
//                        return;
//                    };
//                    if (GameCommonData.Player.Role.isStalling > 0){
//                        MessageTip.show(LanguageMgr.GetTranslation("摆摊时不能购买物品"));
//                        return;
//                    };
//                    MarketSend.buyItemForMarket(shopCarInfo.ShopId, shopCarInfo.buyNum);
//                };
//            };//geoffyan
            var __confirmHandler:* = function ():void{
                if (GameCommonData.Player.Role.Gold < mmm[0]){
                    UIFacade.GetInstance().LackofGold();
                    return;
                };
                if (GameCommonData.Player.Role.Gift < mmm[1]){
                    UIFacade.GetInstance().LackofGift();
                    return;
                };
                if (GameCommonData.Player.Role.Money < mmm[2]){
                    UIFacade.GetInstance().LackofGoldLeaf();
                    return;
                };
                if (GameCommonData.Player.Role.isStalling > 0){
                    MessageTip.show(LanguageMgr.GetTranslation("摆摊时不能购买物品"));
                    return;
                };
                MarketSend.buyItemForMarket(shopCarInfo.ShopId, shopCarInfo.buyNum);
            };
            var alertText:* = "";
            if (mmm[2] > 0){
                payMoneyStr = "";
                payMoneyStr = (payMoneyStr + ((int((mmm[2] / 100)) > 0)) ? (("<font color='#00FF00'>" + int((mmm[2] / 100))) + "</font>金叶子") : "");
                payMoneyStr = (payMoneyStr + ((int((mmm[2] % 100)) > 0)) ? (("<font color='#00FF00'>" + int((mmm[2] % 100))) + "</font>银叶子") : "");
                alertText = LanguageMgr.GetTranslation("购买x个y需要花费z是否购买", shopCarInfo.buyNum, shopCarInfo.Name, payMoneyStr);
            } else {
                if (mmm[1] > 0){
                    alertText = LanguageMgr.GetTranslation("购买x个y需要花费z礼券是否购买", shopCarInfo.buyNum, shopCarInfo.Name, mmm[1]);
                };
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:__confirmHandler,
                cancel:new Function(),
                info:alertText
            });
        }

    }
}//package GameUI.Modules.Maket.Mediator 
