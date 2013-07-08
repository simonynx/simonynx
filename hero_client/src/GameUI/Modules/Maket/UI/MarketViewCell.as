//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import Utils.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class MarketViewCell extends Sprite {

        private var currentPayWay:int;
        private var useItem:UseItem;
        private var btnSub:HBaseButton;
        private var index:int;
        private var redFrame:MovieClip;
        private var saleShopItemInfo:ShopItemInfo;
        private var curBuyCnt:int = 1;
        private var view:MovieClip;
        private var buyBtn:HLabelButton;
        private var shopItemInfo:ShopItemInfo;
        private var petPreviewBtn:HBaseButton;
        private var btnAdd:HBaseButton;

        public function MarketViewCell(_arg1:int){
            this.index = _arg1;
            initView();
            addEvents();
        }
        private function __petPreviewBtnClickHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(MarketEvent.SHOW_PETPREVIEW, info);
        }
        private function __textChangeHandler(_arg1:Event):void{
            curBuyCnt = view["txtBuyCount"].text;
            curBuyCnt = ((curBuyCnt > 99)) ? 99 : curBuyCnt;
            curBuyCnt = ((curBuyCnt < 1)) ? 1 : curBuyCnt;
            view["txtBuyCount"].text = curBuyCnt;
        }
        private function __clickHandler(_arg1:MouseEvent):void{
            if (_arg1.currentTarget != buyBtn){
                __petPreviewBtnClickHandler(null);
            };
        }
        private function __buyHandler(_arg1:MouseEvent):void{
            var _local2:ShopCarInfo = new ShopCarInfo();
            if (((saleShopItemInfo) && ((saleShopItemInfo.curr_amount > 0)))){
                ClassFactory.copyProperties(saleShopItemInfo, _local2);
            } else {
                ClassFactory.copyProperties(info, _local2);
            };
            _local2.buyNum = view["txtBuyCount"].text;
            _local2.currentPayWay = currentPayWay;
            UIFacade.GetInstance().sendNotification(MarketEvent.BUY_ITEM_MARKET, _local2);
        }
        private function __subBuyCntHandler(_arg1:MouseEvent):void{
            curBuyCnt = view["txtBuyCount"].text;
            curBuyCnt--;
            curBuyCnt = ((curBuyCnt < 1)) ? 1 : curBuyCnt;
            view["txtBuyCount"].text = curBuyCnt;
        }
        private function initView():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MarketViewCellAsset");
            view.mouseEnabled = true;
            addChild(view);
            this.mouseChildren = true;
            view["mcNewHot"].mouseEnabled = false;
            view["mcNewHot"].gotoAndStop(1);
            view["mcNewHot"].visible = false;
            view["mcMoney"].x = (view["mcMoney"].x + 2);
            view["mcMoney"].mouseEnabled = false;
            view["txtMarketGoodName"].mouseEnabled = false;
            view["txtMarketGoodName"].filters = Font.Stroke(0);
            view["txtCount"].mouseEnabled = false;
            view["txtBuyCount"].maxChars = 2;
            view["txtBuyCount"].restrict = "0-9";
            redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
            redFrame.name = "redFrame";
            redFrame.mouseEnabled = false;
            buyBtn = new HLabelButton();
            buyBtn.label = LanguageMgr.GetTranslation("购买");
            buyBtn.x = 124;
            buyBtn.y = 68;
            view.addChild(buyBtn);
            petPreviewBtn = new HBaseButton(view["petPreviewBtn"]);
            petPreviewBtn.useBackgoundPos = true;
            view.addChild(petPreviewBtn);
            petPreviewBtn.visible = false;
            petPreviewBtn.alpha = 0;
            btnAdd = new HBaseButton(view.btnAdd);
            btnAdd.useBackgoundPos = true;
            view.addChild(btnAdd);
            btnSub = new HBaseButton(view.btnSub);
            btnSub.useBackgoundPos = true;
            view.addChild(btnSub);
        }
        private function __showPetPreviewBtn(_arg1:MouseEvent):void{
            TweenLite.to(petPreviewBtn, 0.5, {autoAlpha:1});
        }
        public function clearData():void{
            view["txtMarketGoodName"].text = "";
            view["mcMoney"].txtMoney.text = "";
            ShowMoney.ShowIcon(view["mcMoney"], view["mcMoney"].txtMoney, true);
            view["mcNewHot"].visible = false;
            view["txtCount"].text = "";
            view["txtBuyCount"].text = "0";
            if (((useItem) && (useItem.parent))){
                useItem.parent.removeChild(useItem);
            };
            useItem = null;
            shopItemInfo = null;
            if (contains(redFrame)){
                removeChild(redFrame);
            };
        }
        private function addEvents():void{
            buyBtn.addEventListener(MouseEvent.CLICK, __buyHandler);
            btnAdd.addEventListener(MouseEvent.CLICK, __addBuyCntHandlerl);
            btnSub.addEventListener(MouseEvent.CLICK, __subBuyCntHandler);
            UIUtils.TextFieldFocusEvent(view["txtBuyCount"], "1", 1, 99);
            petPreviewBtn.addEventListener(MouseEvent.MOUSE_OVER, __showPetPreviewBtn);
            petPreviewBtn.addEventListener(MouseEvent.MOUSE_OUT, __hidePetPreviewBtn);
            petPreviewBtn.addEventListener(MouseEvent.CLICK, __petPreviewBtnClickHandler);
            addEventListener(MouseEvent.CLICK, __clickHandler);
        }
        public function dispose():void{
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (contains(redFrame)){
                removeChild(redFrame);
            };
        }
        public function set info(_arg1:ShopItemInfo):void{
            this.shopItemInfo = _arg1;
            if (_arg1 == null){
                this.visible = false;
                return;
            };
            this.visible = true;
            saleShopItemInfo = null;
            view["txtMarketGoodName"].htmlText = (_arg1.Name) ? _arg1.Name : "";
            view["txtMarketGoodName"].textColor = IntroConst.MarketColors[_arg1.Color];
            if (_arg1.APriceArr[2]){
                saleShopItemInfo = MarketConstData.getMarketSaleItem(_arg1.TemplateID);
                if (((saleShopItemInfo) && ((saleShopItemInfo.curr_amount > 0)))){
                    _arg1 = saleShopItemInfo;
                };
                view["mcMoney"].txtMoney.text = MarketConstData.GetMoneyText(_arg1.APriceArr[2]);
                currentPayWay = 2;
            } else {
                view["mcMoney"].txtMoney.htmlText = (((_arg1.APriceArr[1] + " <font color=\"#FFFF33\">") + LanguageMgr.GetTranslation("礼券")) + "</font>");
                currentPayWay = 1;
            };
            curBuyCnt = 1;
            ShowMoney.ShowIcon(view.mcMoney, view.mcMoney.txtMoney, true);
            if (_arg1.IsHot){
                view["mcNewHot"].gotoAndStop(2);
                view["mcNewHot"].visible = true;
            } else {
                if (_arg1.IsNew){
                    view["mcNewHot"].gotoAndStop(1);
                    view["mcNewHot"].visible = true;
                } else {
                    if (_arg1.IsLimitTime){
                        view["mcNewHot"].gotoAndStop(3);
                        view["mcNewHot"].visible = true;
                    } else {
                        if (_arg1.IsLimitDayCnt){
                            view["mcNewHot"].gotoAndStop(5);
                            view["mcNewHot"].visible = true;
                        } else {
                            view["mcNewHot"].visible = false;
                        };
                    };
                };
            };
            if (_arg1.IsLimitDayCnt){
                view["txtCount"].htmlText = LanguageMgr.GetTranslation("限购x个", (_arg1.exchangeNum2 - MarketConstData.MarketDayLimitCntBuyRecord[_arg1.exchangeNum1]).toString());
            } else {
                view["txtCount"].htmlText = LanguageMgr.GetTranslation("不限量");
            };
            view["txtBuyCount"].text = curBuyCnt.toString();
            if (((useItem) && (useItem.parent))){
                useItem.parent.removeChild(useItem);
                useItem = null;
            };
            if (_arg1){
                useItem = new UseItem(index, _arg1.TemplateID, view, 0, 1);
                useItem.x = 6;
                useItem.y = 18;
                useItem.setContentWH(69, 71);
                useItem.Num = _arg1.SCount;
                useItem.Id = _arg1.ShopId;
                useItem.IsLock = false;
                useItem.name = ("MarketSaleItem_" + index);
                view.addChild(useItem);
                useItem.mouseChildren = true;
                useItem.mouseEnabled = true;
                if (ItemConst.IsPet((_arg1 as ItemTemplateInfo))){
                    view.addChild(petPreviewBtn);
                    useItem.addEventListener(MouseEvent.MOUSE_OVER, __showPetPreviewBtn);
                    useItem.addEventListener(MouseEvent.MOUSE_OUT, __hidePetPreviewBtn);
                };
            };
            view.addChild(view["mcNewHot"]);
        }
        private function __addBuyCntHandlerl(_arg1:MouseEvent):void{
            curBuyCnt = view["txtBuyCount"].text;
            curBuyCnt++;
            curBuyCnt = ((curBuyCnt > 99)) ? 99 : curBuyCnt;
            view["txtBuyCount"].text = curBuyCnt;
        }
        private function __hidePetPreviewBtn(_arg1:MouseEvent):void{
            TweenLite.to(petPreviewBtn, 0.5, {autoAlpha:0});
        }
        public function get info():ShopItemInfo{
            return (shopItemInfo);
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (shopItemInfo){
                addChild(redFrame);
            };
        }

    }
}//package GameUI.Modules.Maket.UI 
