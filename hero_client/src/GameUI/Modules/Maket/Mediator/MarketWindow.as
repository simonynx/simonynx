//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.Mediator {
    import GameUI.ConstData.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.Maket.UI.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.*;
    import GameUI.View.BaseUI.*;
    import GameUI.View.HButton.*;
    
    import Manager.*;
    
    import Net.RequestSend.*;
    
    import OopsFramework.*;
    import OopsFramework.Utils.*;
    
    import Utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class MarketWindow extends HFrame {

        private static const MAXPAGE:uint = UIConstData.MarketGoodList.length;
        private static const PERPAGE_CNT:uint = 12;

        private var targetEffect:MovieClip;
        private var btnNN:HLabelButton;
        private var intervalID:uint = 0;
        private var btnFF:HLabelButton;
        public var currToggle:uint = 0;
        private var m_bgloader:Loader = null;
        public var moneyTakeView:MoneyTakeView;
        private var btnFront:HLabelButton;
        public var bgMc:MovieClip;
        private var pageCount:uint = 0;
        private var _timer:OopsFramework.Utils.Timer;
        private var sjEffect:MovieClip;
        public var cells:Array;
        private var petPreviewView:MarketPetPreviewView;
        private var btnNext:HLabelButton;
        private var marketSalesView:MarketSalesView;
        public var curPage:uint = 0;

        public function MarketWindow(){
            initView();
            addEvents();
        }
        private function initGrid():void{
            var _local2:MarketViewCell;
            cells = [];
            var _local1:int;
            while (_local1 < PERPAGE_CNT) {
                _local2 = new MarketViewCell(_local1);
                _local2.x = (20 + ((_local1 % 3) * (_local2.width + 10)));
                _local2.y = (60 + (int((_local1 / 3)) * (_local2.height + 5)));
                bgMc.addChild(_local2);
                cells.push(_local2);
                _local1++;
            };
        }
        public function showPetPreview(_arg1:ShopItemInfo):void{
            if (ItemConst.IsPet((_arg1 as ItemTemplateInfo))){
                petPreviewView.visible = true;
                marketSalesView.visible = false;
                bgMc.tf_salesTips.text = LanguageMgr.GetTranslation("展示台");
                petPreviewView.info = _arg1;
            } else {
                petPreviewView.visible = false;
                marketSalesView.visible = true;
                bgMc.tf_salesTips.text = LanguageMgr.GetTranslation("限时优惠抢购");
            };
        }
        private function nnPage():void{
            if ((((pageCount > 0)) && ((curPage < pageCount)))){
                curPage = pageCount;
                clearData();
                showCurData();
                bgMc.txtPageInfo.text = ((curPage + "/") + pageCount);
            };
        }
        private function initPageData():void{
            curPage = 0;
            pageCount = Math.ceil((UIConstData.MarketGoodList[MarketConstData.curPageIndex].length / PERPAGE_CNT));
            if (pageCount > 0){
                curPage++;
                bgMc.txtPageInfo.text = ((curPage + "/") + pageCount);
            } else {
                bgMc.txtPageInfo.text = "1/1";
            };
            var _local1:int;
            while (_local1 < cells.length) {
                cells[_local1].info = null;
                _local1++;
            };
        }
        private function closeMoneyTakePanel():void{
            if (GameCommonData.GameInstance.GameUI.contains(moneyTakeView)){
                GameCommonData.GameInstance.GameUI.removeChild(moneyTakeView);
                moneyTakeView.btnMax.addEventListener(MouseEvent.CLICK, btnClickHandler);
                moneyTakeView.btnTake.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                moneyTakeView.btnFillMoney.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                moneyTakeView.content.txt_inputGet.text = "0";
                moneyTakeView.content.txt_inputGet.restrict = "0-9";
                moneyTakeView.content.txt_inputGet.removeEventListener(Event.CHANGE, inputHandler);
            };
        }
        public function setPage(_arg1:uint):void{
            if (_arg1 >= MAXPAGE){
                return;
            };
            currToggle = _arg1;
            if (_arg1 == 6){
                bgMc.bogMc.visible = true;
                bgMc.bogMc.gotoAndStop(1);
                MarketConstData.curSexDress = 0;
            } else {
                bgMc.bogMc.visible = false;
                MarketConstData.curSexDress = -1;
            };
            canShow_SuperUserView();
            showPetPreview(null);
            var _local2:int;
            while (_local2 < MAXPAGE) {
                if (bgMc.hasOwnProperty(("mcPage_" + _local2))){
                    bgMc[("mcPage_" + _local2)].gotoAndStop(2);
                    bgMc[("mcPage_" + _local2)].buttonMode = true;
                    bgMc[("textpage_" + _local2)].textColor = 250597;
                };
                _local2++;
            };
            bgMc[("mcPage_" + _arg1)].gotoAndStop(1);
            bgMc[("mcPage_" + _arg1)].buttonMode = false;
            bgMc[("textpage_" + _arg1)].textColor = 16496146;
            MarketConstData.curPageIndex = _arg1;
            initPageData();
            showCurData();
        }
        private function backPage():void{
            if ((((pageCount > 0)) && ((curPage < pageCount)))){
                curPage++;
                clearData();
                showCurData();
                bgMc.txtPageInfo.text = ((curPage + "/") + pageCount);
            };
        }
        public function clearData():void{
            var _local1:int;
            while (_local1 < cells.length) {
                cells[_local1].dispose();
                _local1++;
            };
            bgMc.txtPageInfo.text = "";
        }
        public function checkShowSJE():void{
            var _local2:Array;
            var _local3:int;
            var _local4:TaskInfoStruct;
            var _local1:Boolean;
            if ((((currToggle == 0)) && ((curPage == 1)))){
                _local2 = [2106, 2107, 2108, 2109, 2110];
                while (_local3 < _local2.length) {
                    _local4 = GameCommonData.TaskInfoDic[_local2[_local3]];
                    if (_local4.IsAccept){
                        _local1 = true;
                        break;
                    };
                    _local3++;
                };
            };
            if (_local1){
                showSJEffect();
            } else {
                if (sjEffect){
                    if (sjEffect.parent){
                        sjEffect.parent.removeChild(sjEffect);
                    };
                    sjEffect = null;
                };
            };
        }
        private function addEvents():void{
            var _local1:int;
            while (_local1 < MAXPAGE) {
                if (bgMc.hasOwnProperty(("mcPage_" + _local1))){
                    bgMc[("mcPage_" + _local1)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                };
                _local1++;
            };
            bgMc.bogMc.boyBtn.addEventListener(MouseEvent.CLICK, __chooseBoyOrGirl);
            bgMc.bogMc.girlBtn.addEventListener(MouseEvent.CLICK, __chooseBoyOrGirl);
            btnFront.addEventListener(MouseEvent.CLICK, btnClickHandler);
            btnNext.addEventListener(MouseEvent.CLICK, btnClickHandler);
            bgMc.btnExchange.addEventListener(MouseEvent.CLICK, btnClickHandler);
            bgMc.btnDeposit.addEventListener(MouseEvent.CLICK, btnClickHandler);
            btnFF.addEventListener(MouseEvent.CLICK, btnClickHandler);
            btnNN.addEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            var _local2:uint;
            switch (_arg1.currentTarget){
                case btnFront:
                    frontPage();
                    break;
                case btnNext:
                    backPage();
                    break;
                case btnFF:
                    ffPage();
                    break;
                case btnNN:
                    nnPage();
                    break;
                case bgMc.btnDeposit:
                    if (GameConfigData.GamePay != ""){
                        navigateToURL(new URLRequest(GameConfigData.GamePay), "_blank");
                    };
                    break;
                case bgMc.btnExchange:
                    if (GameCommonData.GameInstance.GameUI.contains(moneyTakeView) == false){
                        GameCommonData.GameInstance.GameUI.addChild(moneyTakeView);
                        moneyTakeView.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (moneyTakeView.frameWidth / 2));
                        moneyTakeView.y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (moneyTakeView.frameHeight / 2));
                        moneyTakeView.btnTake.addEventListener(MouseEvent.CLICK, btnClickHandler);
                        moneyTakeView.btnMax.addEventListener(MouseEvent.CLICK, btnClickHandler);
                        moneyTakeView.btnFillMoney.addEventListener(MouseEvent.CLICK, btnClickHandler);
                        if (GameCommonData.currAccountMoney < 0){
                            GameCommonData.currAccountMoney = 0;
                        };
                        moneyTakeView.content.txt_hasMoney.text = (GameCommonData.currAccountMoney / 100);
                        moneyTakeView.content.txt_inputGet.addEventListener(Event.CHANGE, inputHandler);
                        if (((targetEffect) && (targetEffect.parent))){
                            targetEffect.parent.removeChild(targetEffect);
                        };
                    };
                    break;
                case moneyTakeView.btnTake:
                    if (GameCommonData.currAccountMoney == 0){
                        MessageTip.show(LanguageMgr.GetTranslation("没有可提取的金叶子,请先充值"));
                        break;
                    };
                    _local2 = uint(moneyTakeView.content.txt_inputGet.text);
                    if (_local2 <= 0){
                        MessageTip.show(LanguageMgr.GetTranslation("请正确输入要提取的金叶子"));
                    };
                    MarketSend.takeMoney((uint(moneyTakeView.content.txt_inputGet.text) * 100));
                    closeMoneyTakePanel();
                    break;
                case moneyTakeView.btnFillMoney:
                    if (GameConfigData.GamePay != ""){
                        navigateToURL(new URLRequest(GameConfigData.GamePay), "_blank");
                    };
                    break;
                case moneyTakeView.btnMax:
                    moneyTakeView.content.txt_inputGet.text = String(uint((GameCommonData.currAccountMoney / 100)));
                    break;
            };
        }
        override public function dispose():void{
            super.dispose();
            removeEvents();
            if (btnFront){
                btnFront.dispose();
                btnFront = null;
            };
            if (btnNext){
                btnNext.dispose();
                btnNext = null;
            };
            if (btnFF){
                btnFF.dispose();
                btnFF = null;
            };
            if (btnNN){
                btnNN.dispose();
                btnNN = null;
            };
            if (moneyTakeView){
                moneyTakeView.dispose();
                moneyTakeView = null;
            };
            if (marketSalesView){
                marketSalesView.dispose();
                marketSalesView = null;
            };
            if (petPreviewView){
                petPreviewView.dispose();
                petPreviewView = null;
            };
            clearInterval(intervalID);
        }
        private function inputHandler(_arg1:Event):void{
            if (uint(moneyTakeView.content.txt_inputGet.text) > uint((GameCommonData.currAccountMoney / 100))){
                moneyTakeView.content.txt_inputGet.text = String(uint((GameCommonData.currAccountMoney / 100)));
            };
        }
        private function loadBG():void{
            if (m_bgloader == null){
                m_bgloader = new Loader();
                m_bgloader.contentLoaderInfo.addEventListener(Event.COMPLETE, __loadBgCompleteHandler);
                m_bgloader.load(new URLRequest(((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/market_bg .png?v=") + GameConfigData.PlayerVersion)));
            };
        }
        public function updateTakeMoney():void{
            moneyTakeView.content.txt_hasMoney.text = String(uint((GameCommonData.currAccountMoney / 100)));
        }
        private function removeEffect():void{
            clearInterval(intervalID);
            if (((targetEffect) && (targetEffect.parent))){
                targetEffect.parent.removeChild(targetEffect);
            };
        }
        public function updateTime(_arg1:GameTime):void{
            if (timer.IsNextTime(_arg1)){
                if (((marketSalesView) && (marketSalesView.visible))){
                    marketSalesView.updateTime();
                };
            };
            if (((petPreviewView) && (petPreviewView.visible))){
                petPreviewView.updateTime(_arg1);
            };
        }
        public function canShow_SuperUserView():void{
            var _local1:* = GameCommonData.goldenAccountNeed;
            if (GameCommonData.totalPayMoney >= GameCommonData.goldenAccountNeed){
                bgMc.mcPage_9.visible = true;
                bgMc.textpage_9.visible = true;
                bgMc.mcPage_9.mouseEnabled = true;
            } else {
                bgMc.mcPage_9.visible = false;
                bgMc.textpage_9.visible = false;
                bgMc.mcPage_9.mouseEnabled = false;
            };
        }
        private function removeEvents():void{
            var _local1:int;
            while (_local1 < MAXPAGE) {
                if (bgMc.hasOwnProperty(("mcPage_" + _local1))){
                    bgMc[("mcPage_" + _local1)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                };
                _local1++;
            };
            bgMc.bogMc.boyBtn.removeEventListener(MouseEvent.CLICK, __chooseBoyOrGirl);
            bgMc.bogMc.girlBtn.removeEventListener(MouseEvent.CLICK, __chooseBoyOrGirl);
            btnFront.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            btnNext.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            bgMc.btnExchange.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            bgMc.btnDeposit.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            btnFF.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            btnNN.removeEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function __loadBgCompleteHandler(_arg1:Event):void{
            var _local2:DisplayObject = (_arg1.currentTarget.content as DisplayObject);
            _local2.width = 994;
            _local2.height = 573;
            setBg(_local2);
        }
        private function showView(_arg1:Object):void{
            centerFrame();
            show();
            updateMoney();
            MarketConstData.curPageIndex = ((_arg1 == null)) ? 0 : uint(_arg1);
            var _local2:int;
            while (_local2 < MAXPAGE) {
                if (bgMc.hasOwnProperty(("mcPage_" + _local2))){
                    bgMc[("mcPage_" + _local2)].gotoAndStop(2);
                    bgMc[("mcPage_" + _local2)].buttonMode = true;
                    bgMc[("textpage_" + _local2)].textColor = 250597;
                };
                _local2++;
            };
            bgMc[("mcPage_" + MarketConstData.curPageIndex)].gotoAndStop(1);
            bgMc[("mcPage_" + MarketConstData.curPageIndex)].buttonMode = false;
            bgMc[("textpage_" + MarketConstData.curPageIndex)].textColor = 16496146;
        }
        public function get timer():OopsFramework.Utils.Timer
		{
            if (_timer == null){
                _timer = new OopsFramework.Utils.Timer();
                _timer.Frequency = 1;
            };
            return (_timer);
        }
        private function showCurData():void{
            var _local1:uint;
            var _local3:int;
            MarketConstData.curPageData = [];
            var _local2:int = ((curPage - 1) * PERPAGE_CNT);
            while (_local3 < PERPAGE_CNT) {
                _local1 = (_local2 + _local3);
                if (((UIConstData.MarketGoodList[MarketConstData.curPageIndex]) && (UIConstData.MarketGoodList[MarketConstData.curPageIndex][_local1]))){
                    if (MarketConstData.curSexDress != -1){
                        if (MarketConstData.curSexDress == GameCommonData.Player.Role.Sex){
                            MarketConstData.curPageData[_local3] = UIConstData.MarketGoodList[MarketConstData.curPageIndex][_local1];
                        };
                    } else {
                        MarketConstData.curPageData[_local3] = UIConstData.MarketGoodList[MarketConstData.curPageIndex][_local1];
                    };
                };
                cells[_local3].info = MarketConstData.curPageData[_local3];
                _local3++;
            };
            checkShowSJE();
        }
        private function initView():void{
            bgMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MarketViewAsset");
            moveEnable = true;
            setSize(1000, 580);
            titleText = LanguageMgr.GetTranslation("商  城");
            centerTitle = true;
            bgMc.x = 10;
            bgMc.y = 20;
            addContent(bgMc);
            blackGound = false;
            loadBG();
            bgMc.bogMc.visible = false;
            bgMc.bogMc.boyBtn.buttonMode = true;
            bgMc.bogMc.girlBtn.buttonMode = true;
            bgMc.bogMc.gotoAndStop(1);
            initGrid();
            btnNext = new HLabelButton(0);
            btnNext.label = LanguageMgr.GetTranslation("下一页");
            btnNext.x = 360;
            btnNext.y = 468;
            bgMc.addChild(btnNext);
            btnFront = new HLabelButton(0);
            btnFront.label = LanguageMgr.GetTranslation("上一页");
            btnFront.x = 220;
            btnFront.y = 468;
            bgMc.addChild(btnFront);
            btnFF = new HLabelButton(0);
            btnFF.label = LanguageMgr.GetTranslation("首页");
            btnFF.x = 150;
            btnFF.y = 468;
            bgMc.addChild(btnFF);
            btnNN = new HLabelButton(0);
            btnNN.label = LanguageMgr.GetTranslation("末页");
            btnNN.x = 445;
            btnNN.y = 468;
            bgMc.addChild(btnNN);
            var _local1:int;
            while (_local1 < MAXPAGE) {
                if (bgMc.hasOwnProperty(("mcPage_" + _local1))){
                    bgMc[("mcPage_" + _local1)].buttonMode = true;
                    bgMc[("mcPage_" + _local1)].gotoAndStop(2);
                    bgMc[("textpage_" + _local1)].mouseEnabled = false;
                };
                _local1++;
            };
            marketSalesView = new MarketSalesView();
            marketSalesView.x = 585;
            marketSalesView.y = 62;
            bgMc.addChild(marketSalesView);
            petPreviewView = new MarketPetPreviewView();
            petPreviewView.x = 587;
            petPreviewView.y = 65;
            bgMc.addChild(petPreviewView);
            moneyTakeView = new MoneyTakeView();
            moneyTakeView.closeCallBack = closeMoneyTakePanel;
            moneyTakeView.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (moneyTakeView.width / 2));
            moneyTakeView.y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (moneyTakeView.height / 2));
            bgMc.tf_salesTips.selectable = false;
            bgMc.txtShopTip.height = 50;
            bgMc.txtShopTip.htmlText = LanguageMgr.GetTranslation("特价提示");
        }
        private function __chooseBoyOrGirl(_arg1:MouseEvent):void{
            switch (_arg1.target.name){
                case "boyBtn":
                    MarketConstData.curSexDress = 0;
                    bgMc.bogMc.gotoAndStop(1);
                    break;
                case "girlBtn":
                    MarketConstData.curSexDress = 1;
                    bgMc.bogMc.gotoAndStop(2);
                    break;
                default:
                    MarketConstData.curSexDress = -1;
            };
            initPageData();
            showCurData();
        }
        public function showSJEffect():void{
            var url:* = null;
            if (sjEffect){
                if (sjEffect.parent){
                    sjEffect.parent.removeChild(sjEffect);
                };
                sjEffect = null;
            };
            url = (GameCommonData.GameInstance.Content.RootDirectory + "Resources/Effect/MarketSJE.swf");
            ResourcesFactory.getInstance().getResource(url, function ():void{
                var _local1:Sprite;
                sjEffect = ResourcesFactory.getInstance().getswfResourceByUrl(url);
                if (sjEffect){
                    sjEffect.mouseEnabled = false;
                    sjEffect.mouseChildren = false;
                    _local1 = cells[0];
                    sjEffect.x = (_local1.x - 5);
                    sjEffect.y = (_local1.y - 5);
                    bgMc.addChild(sjEffect);
                };
            });
        }
        private function frontPage():void{
            if ((((pageCount > 0)) && ((curPage > 1)))){
                curPage--;
                clearData();
                showCurData();
                bgMc.txtPageInfo.text = ((curPage + "/") + pageCount);
            };
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local2:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            if (_local2 == MarketConstData.curPageIndex){
                return;
            };
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            setPage(_local2);
        }
        private function playEffect():void{
            if (((targetEffect) && ((GameCommonData.currAccountMoney > 0)))){
                bgMc.addChild(targetEffect);
                targetEffect.mouseEnabled = false;
                targetEffect.mouseChildren = false;
                targetEffect.x = (bgMc.btnExchange.x + 50);
                targetEffect.y = (bgMc.btnExchange.y + 21);
                intervalID = setInterval(removeEffect, 4000);
            };
        }
        public function showEffect():void{
            if (targetEffect == null){
                targetEffect = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TargetEffect");
                targetEffect.mouseEnabled = false;
            };
            playEffect();
        }
        private function ffPage():void{
            if ((((pageCount > 0)) && ((curPage > 1)))){
                curPage = 1;
                clearData();
                showCurData();
                bgMc.txtPageInfo.text = ((curPage + "/") + pageCount);
            };
        }
        public function updateMarketSalesData():void{
            if (marketSalesView){
                marketSalesView.updateData();
            };
        }
        public function updateMoney():void{
            EffectLib.textBlink(bgMc["txt_moneyHave_G"], String(uint((GameCommonData.Player.Role.Money / 100))));
            EffectLib.textBlink(bgMc["txt_moneyHave_S"], String(uint((GameCommonData.Player.Role.Money % 100))));
            EffectLib.textBlink(bgMc["integral_have_TF"], String(GameCommonData.Player.Role.Gift));
            bgMc["txt_moneyHave_G"].text = String(uint((GameCommonData.Player.Role.Money / 100)));
            bgMc["txt_moneyHave_S"].text = String(uint((GameCommonData.Player.Role.Money % 100)));
            bgMc["integral_have_TF"].text = GameCommonData.Player.Role.Gift;
        }
        override public function close():void{
            super.close();
            curPage = 0;
            pageCount = 0;
            MarketConstData.curPageIndex = 0;
            MarketConstData.curPageData = [];
            MarketConstData.curSexDress = -1;
            clearData();
            bgMc.bogMc.visible = false;
        }

    }
}//package GameUI.Modules.Maket.Mediator 
