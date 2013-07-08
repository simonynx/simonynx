//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.View.HButton.*;
    import Utils.*;

    public class MarketSalesViewCell extends Sprite {

        private var currentPayWay:int = 2;
        private var btnSub:HBaseButton;
        private var remainTime:uint;
        private var curBuyCnt:int = 1;
        private var btnAdd:HBaseButton;
        private var gridUnit:MovieClip;
        private var view:MovieClip;
        private var buyBtn:HLabelButton;
        private var shopItemInfo:ShopItemInfo;
        private var useItem:UseItem;
        private var idx:int;

        public function MarketSalesViewCell(_arg1:int, _arg2:ShopItemInfo){
            this.idx = _arg1;
            this.shopItemInfo = _arg2;
            initView();
            addEvents();
        }
        public function get outTime():Boolean{
            return ((remainTime <= 0));
        }
        public function updateTime():void{
            var _local1:int;
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local5:Object;
            var _local6:Dictionary;
            var _local7:Object;
            if (shopItemInfo){
                if (shopItemInfo.curr_amount == 1000000){
                    view["txtCount"].text = LanguageMgr.GetTranslation("不限量");
                } else {
                    view["txtCount"].text = LanguageMgr.GetTranslation("剩余x个", shopItemInfo.curr_amount);
                };
                remainTime = (shopItemInfo.limitTime - uint((TimeManager.Instance.Now().time / 1000)));
                _local1 = uint((remainTime / (3600 * 24)));
                remainTime = (remainTime % (3600 * 24));
                _local2 = uint((remainTime / 3600));
                _local3 = uint(((remainTime % 3600) / 60));
                _local4 = uint((remainTime % 60));
                view["txtLimitTime"].text = (((((LanguageMgr.GetTranslation("剩余时间") + ":") + ((_local1 > 0)) ? (String(_local1) + LanguageMgr.GetTranslation("天")) : "") + (String(_local2) + LanguageMgr.GetTranslation("小时"))) + (String(_local3) + LanguageMgr.GetTranslation("分"))) + (String(_local4) + LanguageMgr.GetTranslation("秒")));
                _local5 = MarketConstData.SelfDayLimitCntBuyShopItemObj;
                _local6 = MarketConstData.MarketDayLimitCntBuyRecord;
                _local7 = GameCommonData.activityData;
                if (((((MarketConstData.SelfDayLimitCntBuyShopItemObj) && (MarketConstData.SelfDayLimitCntBuyShopItemObj.info))) && ((MarketConstData.SelfDayLimitCntBuyShopItemObj.info.ShopId == shopItemInfo.ShopId)))){
                    view["txtLimitTime"].text = LanguageMgr.GetTranslation("每人每天限购x个", MarketConstData.SelfDayLimitCntBuyShopItemObj.cnt);
                };
            };
        }
        private function __buyHandler(_arg1:MouseEvent):void{
            var _local2:ShopCarInfo = new ShopCarInfo();
            ClassFactory.copyProperties(shopItemInfo, _local2);
            _local2.buyNum = view["txtBuyCount"].text;
            _local2.currentPayWay = currentPayWay;
            if (((MarketConstData.SelfDayLimitCntBuyShopItemObj.info) && ((MarketConstData.SelfDayLimitCntBuyShopItemObj.info.ShopId == shopItemInfo.ShopId)))){
                if ((((int((MarketConstData.MarketDayLimitCntBuyRecord[9] / 100)) == shopItemInfo.ShopId)) && ((MarketConstData.SelfDayLimitCntBuyShopItemObj.cnt <= (MarketConstData.MarketDayLimitCntBuyRecord[9] % 100))))){
                    MessageTip.popup(LanguageMgr.GetTranslation("每天只能购买x次", MarketConstData.SelfDayLimitCntBuyShopItemObj.cnt));
                    return;
                };
                if (int((MarketConstData.MarketDayLimitCntBuyRecord[9] / 100)) == shopItemInfo.ShopId){
                    if (curBuyCnt > (MarketConstData.SelfDayLimitCntBuyShopItemObj.cnt - (MarketConstData.MarketDayLimitCntBuyRecord[9] % 100))){
                        MessageTip.popup(LanguageMgr.GetTranslation("超过限购最大数量"));
                        return;
                    };
                } else {
                    if (curBuyCnt > MarketConstData.SelfDayLimitCntBuyShopItemObj.cnt){
                        MessageTip.popup(LanguageMgr.GetTranslation("超过限购最大数量"));
                        return;
                    };
                };
            };
            UIFacade.GetInstance().sendNotification(MarketEvent.BUY_ITEM_MARKET, _local2);
        }
        private function __subBuyCntHandler(_arg1:MouseEvent):void{
            curBuyCnt = view["txtBuyCount"].text;
            curBuyCnt--;
            curBuyCnt = ((curBuyCnt < 1)) ? 1 : curBuyCnt;
            view["txtBuyCount"].text = curBuyCnt;
        }
        public function updateData():void{
            if (shopItemInfo){
                view["txtMarketGoodName"].text = shopItemInfo.Name;
                if (shopItemInfo.IsHot){
                    view["mcNewHot"].gotoAndStop(2);
                    view["mcNewHot"].visible = true;
                } else {
                    if (shopItemInfo.IsNew){
                        view["mcNewHot"].gotoAndStop(1);
                        view["mcNewHot"].visible = true;
                    } else {
                        if (shopItemInfo.IsLimitTime){
                            view["mcNewHot"].gotoAndStop(3);
                            view["mcNewHot"].visible = true;
                        } else {
                            view["mcNewHot"].visible = false;
                        };
                    };
                };
                view["mcMoney"].txtMoney.text = MarketConstData.GetMoneyText(shopItemInfo.exchangeGood2);
                ShowMoney.ShowIcon(view["mcMoney"], view["mcMoney"].txtMoney, true);
                view["mcMoneyOriginal"].txtMoney.text = MarketConstData.GetMoneyText(shopItemInfo.APriceArr[2]);
                ShowMoney.ShowIcon(view["mcMoneyOriginal"], view["mcMoneyOriginal"].txtMoney, true);
                curBuyCnt = 1;
                view["txtBuyCount"].text = curBuyCnt.toString();
                gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                useItem = new UseItem(idx, shopItemInfo.TemplateID, view, 0, 1);
                useItem.Num = shopItemInfo.SCount;
                useItem.x = 0;
                useItem.y = 0;
                useItem.setContentWH(69, 71);
                gridUnit.addChildAt(useItem, 1);
                gridUnit.shopItemInfo = shopItemInfo;
                gridUnit.name = ("MarketSaleViewItem_" + shopItemInfo.TemplateID);
                gridUnit.index = 0;
                gridUnit.x = 5;
                gridUnit.y = 5;
                view.addChild(gridUnit);
                view.addChild(view["mcNewHot"]);
                if (shopItemInfo.curr_amount == 0){
                    buyBtn.enable = false;
                };
                updateTime();
            };
        }
        private function initView():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MarketSalesViewCellAsset");
            addChild(view);
            view["mcNewHot"].mouseEnabled = false;
            view["mcNewHot"].gotoAndStop(1);
            view["txtMarketGoodName"].mouseEnabled = false;
            view["txtCount"].mouseEnabled = false;
            view["txtLimitTime"].mouseEnabled = false;
            view["mcMoney"].mouseEnabled = false;
            view["txtBuyCount"].maxChars = 2;
            view["txtBuyCount"].restrict = "0-9";
            buyBtn = new HLabelButton();
            buyBtn.name = "buyBtn";
            buyBtn.label = "购买";
            buyBtn.x = 125;
            buyBtn.y = 58;
            view.addChild(buyBtn);
            btnAdd = new HBaseButton(view.btnAdd);
            btnAdd.useBackgoundPos = true;
            view.addChild(btnAdd);
            btnSub = new HBaseButton(view.btnSub);
            btnSub.useBackgoundPos = true;
            view.addChild(btnSub);
        }
        private function addEvents():void{
            buyBtn.addEventListener(MouseEvent.CLICK, __buyHandler);
            btnAdd.addEventListener(MouseEvent.CLICK, __addBuyCntHandlerl);
            btnSub.addEventListener(MouseEvent.CLICK, __subBuyCntHandler);
            view["txtBuyCount"].addEventListener(Event.CHANGE, __textChangeHandler);
            UIUtils.TextFieldFocusEvent(view["txtBuyCount"], "1", 1, shopItemInfo.curr_amount, 1);
        }
        public function get Info():ShopItemInfo{
            return (this.shopItemInfo);
        }
        public function dispose():void{
            buyBtn.removeEventListener(MouseEvent.CLICK, __buyHandler);
            btnAdd.removeEventListener(MouseEvent.CLICK, __addBuyCntHandlerl);
            btnSub.removeEventListener(MouseEvent.CLICK, __subBuyCntHandler);
            view["txtBuyCount"].removeEventListener(Event.CHANGE, __textChangeHandler);
            if (parent){
                this.parent.removeChild(this);
            };
            if (buyBtn){
                buyBtn.dispose();
                buyBtn = null;
            };
            shopItemInfo = null;
            useItem = null;
            gridUnit = null;
            view = null;
        }
        private function __addBuyCntHandlerl(_arg1:MouseEvent):void{
            curBuyCnt = view["txtBuyCount"].text;
            curBuyCnt++;
            curBuyCnt = ((curBuyCnt > 99)) ? 99 : curBuyCnt;
            curBuyCnt = ((curBuyCnt)>shopItemInfo.curr_amount) ? shopItemInfo.curr_amount : curBuyCnt;
            view["txtBuyCount"].text = curBuyCnt;
        }
        private function __textChangeHandler(_arg1:Event):void{
            curBuyCnt = view["txtBuyCount"].text;
            curBuyCnt = ((curBuyCnt)>shopItemInfo.curr_amount) ? shopItemInfo.curr_amount : curBuyCnt;
            view["txtBuyCount"].text = curBuyCnt;
        }

    }
}//package GameUI.Modules.Maket.UI 
