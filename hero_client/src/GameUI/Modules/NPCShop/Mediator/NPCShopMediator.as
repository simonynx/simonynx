//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCShop.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import flash.filters.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.NPCShop.Data.*;
    import GameUI.Modules.NPCShop.Proxy.*;
    import GameUI.*;
    //import GameUI.Modules.NPCShop.UI.*;

    public class NPCShopMediator extends Mediator {

        public static const NAME:String = "NPCShopMediator";
        private static const START_POS:Point = new Point();

        private var maxCount:uint;
        private var yellowFilter:GlowFilter = null;
        private var shopName:String = "";
        private var gridSprite:MovieClip = null;
        private var shopGridManager:NPCShopGridManager = null;
        private var mosterId:int = 0;
        private var pageCount:int = 0;
        private var shopType:int = 0;
        private var npcId:int = 0;
        private var isReparing:Boolean = false;
        private var dataProxy:DataProxy = null;
        private var redFilter:GlowFilter = null;
        private var strSyArr:Array;
        private var curPage:int = 1;
        private var strArr:Array;

        public function NPCShopMediator(){
            strArr = ["\\ce", "\\cs", "\\cc"];
            strSyArr = ["\\se", "\\ss", "\\sc"];
            super(NAME);
        }
        private function removeAllFrames():void{
            var _local1:int;
            while (_local1 < NPCShopConstData.COUNT_PER_PAGE) {
                shopView.content[("mcNPCGood_" + _local1)].mcRed.visible = false;
                shopView.content[("mcNPCGood_" + _local1)].mcYellow.visible = false;
                _local1++;
            };
        }
        private function mouseOverHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.mcRed.visible = true;
        }
        private function initFrames():void{
            var _local1:int;
            shopView.content.txtInputCount.restrict = "0-9";
            shopView.content.txtInputCount.text = "1";
            while (_local1 < NPCShopConstData.COUNT_PER_PAGE) {
                shopView.content[("mcNPCGood_" + _local1)].mcRed.visible = false;
                shopView.content[("mcNPCGood_" + _local1)].mcYellow.visible = false;
                _local1++;
            };
        }
        private function setPos():void{
            shopView.x = ((facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.x - shopView.width);
            shopView.y = (facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.y;
        }
        private function updateData():void{
            var _local1:FaceItem;
            var _local2:uint;
            var _local5:ShopItemInfo;
            var _local6:int;
            var _local7:uint;
            var _local3:int = ((curPage - 1) * NPCShopConstData.COUNT_PER_PAGE);
            var _local4:Array = NPCShopConstData.goodList[mosterId][NPCShopConstData.currType];
            while (_local6 < NPCShopConstData.COUNT_PER_PAGE) {
                if (_local4[(_local3 + _local6)]){
                    _local5 = _local4[(_local3 + _local6)];
                    _local1 = new FaceItem(String(_local5.img), shopView.content[("mcNPCGood_" + _local6)]);
                    _local1.Num = _local5.SCount;
                    _local1.x = 7;
                    _local1.y = 6;
                    _local1.setEnable(true);
                    _local1.name = ("mcNPCGoodPhoto_" + _local5.type);
                    shopView.content[("mcNPCGood_" + _local6)].addChild(_local1);
                    _local2 = UIConstData.ItemDic[_local5.type].Color;
                    shopView.content[("mcNPCGood_" + _local6)].txtGoodName.htmlText = (((("<font color=\"" + IntroConst.itemColors[_local2]) + "\">") + _local5.Name) + "</font>");
                    _local7 = _local5.APriceArr[0];
                    if (uint((_local7 / 10000)) > 0){
                        shopView.content[("mcNPCGood_" + _local6)].txtMoney1.text = String(uint((_local7 / 10000)));
                        if ((_local7 % 100) > 0){
                            shopView.content[("mcNPCGood_" + _local6)].txtMoney2.text = String((_local7 % 100));
                            shopView.content[("mcNPCGood_" + _local6)].moneyType.gotoAndStop(3);
                        } else {
                            shopView.content[("mcNPCGood_" + _local6)].txtMoney2.text = String(uint(((_local7 % 10000) / 100)));
                            shopView.content[("mcNPCGood_" + _local6)].moneyType.gotoAndStop(2);
                        };
                    } else {
                        shopView.content[("mcNPCGood_" + _local6)].txtMoney1.text = String(uint(((_local7 % 10000) / 100)));
                        shopView.content[("mcNPCGood_" + _local6)].txtMoney2.text = String((_local7 % 100));
                        shopView.content[("mcNPCGood_" + _local6)].moneyType.gotoAndStop(1);
                    };
                    shopView.content[("mcNPCGood_" + _local6)].addEventListener(MouseEvent.CLICK, goodSelectHandler);
                } else {
                    shopView.content[("mcNPCGood_" + _local6)].removeEventListener(MouseEvent.CLICK, goodSelectHandler);
                };
                _local6++;
            };
        }
        private function backPage():void{
            if ((((pageCount > 0)) && ((curPage < pageCount)))){
                removeAllFrames();
                curPage++;
                clearData();
                updateData();
                shopView.content.txtPageInfo.text = ((curPage + "/") + pageCount);
            };
        }
        private function clearData():void{
            var _local1:int;
            var _local2:int;
            while (_local2 < NPCShopConstData.COUNT_PER_PAGE) {
                _local1 = 0;
                while (_local1 < (shopView.content[("mcNPCGood_" + _local2)] as MovieClip).numChildren) {
                    if (((shopView.content[("mcNPCGood_" + _local2)] as MovieClip).getChildAt(_local1) is ItemBase)){
                        (shopView.content[("mcNPCGood_" + _local2)] as MovieClip).removeChild((shopView.content[("mcNPCGood_" + _local2)] as MovieClip).getChildAt(_local1));
                        break;
                    };
                    _local1++;
                };
                shopView.content[("mcNPCGood_" + _local2)].txtGoodName.text = "";
                shopView.content[("mcNPCGood_" + _local2)].txtMoney1.text = "0";
                shopView.content[("mcNPCGood_" + _local2)].txtMoney2.text = "0";
                shopView.content[("mcNPCGood_" + _local2)].removeEventListener(MouseEvent.CLICK, goodSelectHandler);
                _local2++;
            };
            NPCShopConstData.selectedIndex = -1;
            shopView.content.txtInputCount.text = "1";
            shopView.content.txtMoney1.text = "0";
            shopView.content.txtMoney2.text = "0";
            shopView.content.txtMoney3.text = "0";
            shopView.content.txtMoney7.text = "0";
            shopView.content.txtMoney8.text = "0";
            shopView.content.txtMoney9.text = "0";
            NPCShopConstData.payWay = 0;
        }
        private function judge():Boolean{
            var _local1:Boolean;
            if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("死亡状态不能打开商店"),
                    color:0xFFFF00
                });
                _local1 = false;
            } else {
                if (dataProxy.TradeIsOpen){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易中不能打开商店"),
                        color:0xFFFF00
                    });
                    _local1 = false;
                } else {
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摆摊中不能打开商店"),
                            color:0xFFFF00
                        });
                        _local1 = false;
                    } else {
                        if (dataProxy.DepotIsOpen){
                            sendNotification(EventList.CLOSEDEPOTVIEW);
                        };
                        if (UnityConstData.contributeIsOpen){
                            sendNotification(UnityEvent.HIDE_GUILDDONATEPANEL);
                        };
                    };
                };
            };
            return (_local1);
        }
        private function inputHandler(_arg1:Event):void{
            var _local2:int;
            var _local3:ShopItemInfo;
            var _local4:Number;
            var _local5:Number;
            if (NPCShopConstData.selectedIndex == -1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("请先选择物品"),
                    color:0xFFFF00
                });
                shopView.content.txtInputCount.text = "1";
                return;
            };
            _local2 = int(shopView.content.txtInputCount.text);
            if (_local2 <= 0){
                _local2 = 1;
                shopView.content.txtInputCount.text = "1";
            };
            if (NPCShopConstData.selectedIndex > -1){
                _local3 = NPCShopConstData.goodList[mosterId][NPCShopConstData.currType][(((curPage - 1) * NPCShopConstData.COUNT_PER_PAGE) + NPCShopConstData.selectedIndex)];
                if (_local2 > maxCount){
                    shopView.content.txtInputCount.text = maxCount.toString();
                    _local2 = maxCount;
                };
                _local4 = _local3.APriceArr[0];
                _local5 = (_local4 * _local2);
                shopView.content.txtMoney1.text = String(int((_local5 / 10000)));
                shopView.content.txtMoney2.text = String(int(((_local5 % 10000) / 100)));
                shopView.content.txtMoney3.text = String((_local5 % 100));
            };
        }
        private function saleGood():void{
            var _local1:int;
            if (NPCShopConstData.goodSaleList.length <= 0){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("当前没有要出售物品"),
                    color:0xFFFF00
                });
            } else {
                NPCShopSend.saleNPCItem(npcId, NPCShopConstData.goodSaleList);
                _local1 = 0;
                while (_local1 < NPCShopConstData.goodSaleList.length) {
                    sendNotification(EventList.BAGITEMUNLOCK, NPCShopConstData.goodSaleList[_local1].ItemGUID);
                    _local1++;
                };
                shopGridManager.removeAllItem();
                NPCShopConstData.goodSaleList = [];
                shopView.content.txtMoney7.text = "0";
                shopView.content.txtMoney8.text = "0";
                shopView.content.txtMoney9.text = "0";
            };
        }
        private function gcAll():void{
            removLis();
            if (GameCommonData.GameInstance.GameUI.contains(shopView)){
                EffectLib.checkTranslationByClose(shopView, GameCommonData.GameInstance.stage);
                GameCommonData.GameInstance.GameUI.removeChild(shopView);
            };
            var _local1:uint;
            _local1 = 0;
            while (_local1 < 4) {
                if (shopView.content[("mcPage_" + _local1)].hasEventListener(MouseEvent.CLICK)){
                    shopView.content[("mcPage_" + _local1)].removeEventListener(MouseEvent, choicePageHandler);
                };
                _local1++;
            };
            _local1 = 0;
            while (_local1 < NPCShopConstData.goodSaleList.length) {
                sendNotification(EventList.BAGITEMUNLOCK, NPCShopConstData.goodSaleList[_local1].ItemGUID);
                _local1++;
            };
            NPCShopConstData.SelectedItem = null;
            if (shopGridManager){
                shopGridManager.removeAllItem();
            };
            viewComponent = null;
            yellowFilter = null;
            redFilter = null;
            gridSprite = null;
            pageCount = 0;
            curPage = 1;
            NPCShopConstData.currType = 0;
            npcId = 0;
            shopName = "";
            shopType = 0;
            NPCShopConstData.goodTypeIdList = [];
            NPCShopConstData.goodSaleList = [];
            NPCShopConstData.GridUnitList = [];
            (NPCShopConstData.selectedIndex - 1);
            NPCShopConstData.TmpIndex = 0;
            NPCShopConstData.payWay = 0;
            shopGridManager = null;
            dataProxy.NPCShopIsOpen = false;
            dataProxy = null;
            facade.removeMediator(NPCShopMediator.NAME);
        }
        private function mouseOutHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.mcRed.visible = false;
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            switch (_arg1.target.parent.name){
                case "btnFrontPage":
                    frontPage();
                    break;
                case "btnBackPage":
                    backPage();
                    break;
                case "btnBuy":
                    buyGood();
                    break;
                case "btnSale":
                    saleGood();
                    break;
            };
            switch (_arg1.target.name){
                case "btnMax":
                    inputMax();
                    inputHandler(null);
                    break;
                case "btnAdd":
                    if (NPCShopConstData.selectedIndex == -1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择物品"),
                            color:0xFFFF00
                        });
                        shopView.content.txtInputCount.text = "1";
                        return;
                    };
                    if (int(shopView.content.txtInputCount.text) < maxCount){
                        shopView.content.txtInputCount.text = String((int(shopView.content.txtInputCount.text) + 1));
                    };
                    inputHandler(null);
                    break;
                case "btnSub":
                    if (NPCShopConstData.selectedIndex == -1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择物品"),
                            color:0xFFFF00
                        });
                        shopView.content.txtInputCount.text = "1";
                        return;
                    };
                    if (int(shopView.content.txtInputCount.text) > 1){
                        shopView.content.txtInputCount.text = String((int(shopView.content.txtInputCount.text) - 1));
                    };
                    inputHandler(null);
                    break;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:uint;
            switch (_arg1.getName()){
                case EventList.SHOWNPCSHOPVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    if (dataProxy.NPCShopIsOpen){
                        shopView.centerFrame();
                        shopView.name = "vipshop";
                        EffectLib.checkTranslationByShow(shopView, GameCommonData.GameInstance.stage);
                        sendNotification(EventList.SHOWBAG);
                        return;
                    };
                    if (!judge()){
                        if (dataProxy.NPCShopIsOpen){
                            gcAll();
                        };
                        return;
                    };
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.NPCSHOPVIEW
                    });
                    yellowFilter = UIUtils.getGlowFilter(0xFFFF00, 1, 2, 2, 4);
                    redFilter = UIUtils.getGlowFilter(0xFF0000, 1, 2, 2, 4);
                    npcId = _arg1.getBody().npcId;
                    mosterId = 0;
                    if (GameCommonData.SameSecnePlayerList[npcId]){
                        mosterId = GameCommonData.SameSecnePlayerList[npcId].Role.MonsterTypeID;
                    };
                    NPCShopConstData.currMosterID = mosterId;
                    shopName = _arg1.getBody().shopName;
                    shopType = _arg1.getBody().shopType;
                    initView();
                    initData();
                    addLis();
                    dataProxy.NPCShopIsOpen = true;
                    sendNotification(EventList.SHOWBAG, 0);
                    shopView.content.btnMax.visible = false;
                    if (dataProxy.Guide_SaleItem_Started){
                        facade.sendNotification(Guide_SaleItemCommand.NAME, {step:1});
                    };
                    shopView.centerFrame();
                    shopView.name = "vipshop";
                    EffectLib.checkTranslationByShow(shopView, GameCommonData.GameInstance.stage);
                    break;
                case EventList.UPDATEMONEY:
                    if (shopView){
                        _local3 = GameCommonData.Player.Role.Gold;
                        EffectLib.textBlink(shopView.content.txtMoney4, String(int((_local3 / 10000))));
                        EffectLib.textBlink(shopView.content.txtMoney5, String(int(((_local3 % 10000) / 100))));
                        EffectLib.textBlink(shopView.content.txtMoney6, String((_local3 % 100)));
                        shopView.content.txtMoney4.text = String(int((_local3 / 10000)));
                        shopView.content.txtMoney5.text = String(int(((_local3 % 10000) / 100)));
                        shopView.content.txtMoney6.text = String(int((_local3 % 100)));
                    };
                    break;
                case EventList.CLOSENPCSHOPVIEW:
                    gcAll();
                    break;
                case EventList.CLOSE_NPC_ALL_PANEL:
                    if (((dataProxy) && (dataProxy.NPCShopIsOpen))){
                        gcAll();
                    };
                    break;
                case NPCShopEvent.BAGTONPCSHOP:
                    _local2 = _arg1.getBody();
                    if (NPCShopConstData.goodSaleList.length >= 8){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("一次最多出售8件物品"),
                            color:0xFFFF00
                        });
                        sendNotification(EventList.BAGITEMUNLOCK, _local2.ItemGUID);
                    } else {
                        NPCShopConstData.goodSaleList.push(_local2);
                        updateSaleData();
                    };
                    if (dataProxy.Guide_SaleItem_Started){
                        facade.sendNotification(Guide_SaleItemCommand.NAME, {
                            step:2,
                            target:shopView.btnSale
                        });
                    };
                    break;
                case NPCShopEvent.NPC_TRADE_ERROR:
                    _local2 = NPCShopConstData.tradeResultObj[String(_arg1.getBody())];
                    if (_local2){
                        MessageTip.show(String(_local2));
                    };
                    break;
                case NPCShopEvent.UPDATENPCSALEMONEY:
                    updateSaleMoney();
                    break;
                case EventList.RESIZE_STAGE:
                    setPos();
                    break;
            };
        }
        private function addLis():void{
            var _local1:int;
            while (_local1 < NPCShopConstData.COUNT_PER_PAGE) {
                shopView.content[("mcNPCGood_" + _local1)].addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
                shopView.content[("mcNPCGood_" + _local1)].addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
                _local1++;
            };
            shopView.content.txtInputCount.addEventListener(Event.CHANGE, inputHandler);
            shopView.content.btnMax.addEventListener(MouseEvent.CLICK, btnClickHandler);
            shopView.content.btnAdd.addEventListener(MouseEvent.CLICK, btnClickHandler);
            shopView.content.btnSub.addEventListener(MouseEvent.CLICK, btnClickHandler);
            shopView.btnFrontPage.addEventListener(MouseEvent.CLICK, btnClickHandler);
            shopView.btnBackPage.addEventListener(MouseEvent.CLICK, btnClickHandler);
            shopView.btnBuy.addEventListener(MouseEvent.CLICK, btnClickHandler);
            shopView.btnSale.addEventListener(MouseEvent.CLICK, btnClickHandler);
            UIUtils.addFocusLis(shopView.content.txtInputCount);
        }
        private function cancelClose():void{
        }
        private function get shopView():NPCShopUIView{
            return ((viewComponent as NPCShopUIView));
        }
        private function inputMax():void{
            if (NPCShopConstData.selectedIndex == -1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("请先选择物品"),
                    color:0xFFFF00
                });
                shopView.content.txtInputCount.text = "1";
                return;
            };
            shopView.content.txtInputCount.text = String(maxCount);
        }
        private function initView():void{
            setViewComponent(new NPCShopUIView(shopName));
            shopView.closeCallBack = panelCloseHandler;
            gridSprite = new MovieClip();
            shopView.content.addChild(gridSprite);
            gridSprite.x = 10;
            gridSprite.y = 380;
            initFrames();
            initGrid();
            GameCommonData.GameInstance.GameUI.addChild(shopView);
            var _local1:uint = GameCommonData.Player.Role.Gold;
            shopView.content.txtMoney4.text = String(int((_local1 / 10000)));
            shopView.content.txtMoney5.text = String(int(((_local1 % 10000) / 100)));
            shopView.content.txtMoney6.text = String(int((_local1 % 100)));
            var _local2:uint;
            if (((((NPCShopConstData.goodList[mosterId][0][0]) && ((NPCShopConstData.goodList[mosterId][0][0].MainClass == ItemConst.ITEM_CLASS_EQUIP)))) && ((NPCShopConstData.goodList[mosterId][0][0].SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)))){
                _local2 = 0;
                while (_local2 < 4) {
                    NPCShopConstData.goodList[mosterId][_local2].sortOn(["Job", "RequiredLevel"], [Array.DESCENDING]);
                    shopView.content[("mcPage_" + _local2)].visible = true;
                    shopView.content[("txtPage_" + _local2)].visible = true;
                    shopView.content[("mcPage_" + _local2)].buttonMode = true;
                    shopView.content[("txtPage_" + _local2)].mouseEnabled = false;
                    shopView.content[("mcPage_" + _local2)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                    if (_local2 == 0){
                        shopView.content[("txtPage_" + 0)].text = LanguageMgr.GetTranslation("武器");
                        shopView.content[("mcPage_" + _local2)].gotoAndStop(1);
                        shopView.content[("txtPage_" + _local2)].textColor = 16496146;
                        shopView.content[("mcPage_" + _local2)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                    } else {
                        shopView.content[("mcPage_" + _local2)].gotoAndStop(2);
                        shopView.content[("txtPage_" + _local2)].textColor = 250597;
                    };
                    _local2++;
                };
            } else {
                NPCShopConstData.goodList[mosterId][_local2].sortOn(["RequiredLevel", "MpBonus"]);
                _local2 = 0;
                while (_local2 < 4) {
                    shopView.content[("mcPage_" + _local2)].buttonMode = false;
                    shopView.content[("mcPage_" + _local2)].visible = false;
                    shopView.content[("txtPage_" + _local2)].visible = false;
                    _local2++;
                };
                shopView.content[("mcPage_" + 0)].visible = true;
                shopView.content[("txtPage_" + 0)].visible = true;
                shopView.content[("txtPage_" + 0)].text = LanguageMgr.GetTranslation("物品");
                shopView.content[("txtPage_" + 0)].mouseEnabled = false;
            };
        }
        private function frontPage():void{
            if ((((pageCount > 0)) && ((curPage > 1)))){
                removeAllFrames();
                curPage--;
                clearData();
                updateData();
                shopView.content.txtPageInfo.text = ((curPage + "/") + pageCount);
            };
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local2:int;
            while (_local2 < 4) {
                shopView.content[("mcPage_" + _local2)].gotoAndStop(2);
                shopView.content[("txtPage_" + _local2)].textColor = 250597;
                shopView.content[("mcPage_" + _local2)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                _local2++;
            };
            var _local3:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            shopView.content[("mcPage_" + _local3)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
            shopView.content[("mcPage_" + _local3)].gotoAndStop(1);
            shopView.content[("txtPage_" + _local3)].textColor = 16496146;
            NPCShopConstData.currType = _local3;
            removeAllFrames();
            initData();
        }
        private function initData():void{
            pageCount = Math.ceil((NPCShopConstData.goodList[mosterId][NPCShopConstData.currType].length / NPCShopConstData.COUNT_PER_PAGE));
            if (pageCount > 0){
                clearData();
                curPage = 1;
                updateData();
                shopView.content.txtPageInfo.text = ((curPage + "/") + pageCount);
            } else {
                clearData();
                shopView.content.txtPageInfo.text = "1/1";
            };
        }
        private function buyGood():void{
            var _local1:int;
            var _local2:int;
            var _local3:ShopItemInfo;
            var _local4:ShopItemInfo;
            if (NPCShopConstData.selectedIndex > -1){
                _local1 = int(shopView.content.txtInputCount.text);
                _local4 = NPCShopConstData.goodList[mosterId][NPCShopConstData.currType][(((curPage - 1) * NPCShopConstData.COUNT_PER_PAGE) + NPCShopConstData.selectedIndex)];
                if (_local1 <= 0){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("请输入购买数量"),
                        color:0xFFFF00
                    });
                } else {
                    if (_local1 > 999){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("购买数量超过范围"),
                            color:0xFFFF00
                        });
                    } else {
                        if ((_local1 * _local4.APriceArr[0]) > GameCommonData.Player.Role.Gold){
                            UIFacade.GetInstance().LackofGold();
                        } else {
                            _local2 = (((curPage - 1) * NPCShopConstData.COUNT_PER_PAGE) + NPCShopConstData.selectedIndex);
                            _local3 = NPCShopConstData.goodList[mosterId][NPCShopConstData.currType][_local2];
                            NPCShopSend.buyNPCItem(npcId, _local3.ShopId, _local1);
                        };
                    };
                };
            } else {
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("请先选择物品"),
                    color:0xFFFF00
                });
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWNPCSHOPVIEW, EventList.RESIZE_STAGE, EventList.UPDATEMONEY, EventList.CLOSENPCSHOPVIEW, EventList.CLOSE_NPC_ALL_PANEL, NPCShopEvent.BAGTONPCSHOP, NPCShopEvent.NPC_TRADE_ERROR, NPCShopEvent.UPDATENPCSALEMONEY]);
        }
        private function removLis():void{
            var _local1:int;
            if (shopView){
                _local1 = 0;
                while (_local1 < NPCShopConstData.COUNT_PER_PAGE) {
                    shopView.content[("mcNPCGood_" + _local1)].removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
                    shopView.content[("mcNPCGood_" + _local1)].removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
                    _local1++;
                };
                shopView.content.txtInputCount.removeEventListener(Event.CHANGE, inputHandler);
                shopView.btnFrontPage.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                shopView.btnBackPage.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                shopView.btnBuy.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                shopView.btnSale.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                shopView.content.btnMax.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                shopView.content.btnAdd.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                shopView.content.btnSub.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                UIUtils.removeFocusLis(shopView.content.txtInputCount);
            };
        }
        private function panelCloseHandler():void{
            gcAll();
        }
        private function goodSelectHandler(_arg1:MouseEvent):void{
            var _local2:ShopItemInfo;
            removeAllFrames();
            _arg1.currentTarget.mcYellow.visible = true;
            var _local3:int = _arg1.currentTarget.name.split("_")[1];
            if (_local3 != NPCShopConstData.selectedIndex){
                _local2 = NPCShopConstData.goodList[mosterId][NPCShopConstData.currType][(((curPage - 1) * NPCShopConstData.COUNT_PER_PAGE) + _local3)];
                if (_local2){
                    NPCShopConstData.selectedIndex = _local3;
                    maxCount = uint((_local2.MaxCount / _local2.SCount));
                    shopView.content.txtInputCount.text = "1";
                    shopView.content.txtMoney1.text = String(int((_local2.APriceArr[0] / 10000)));
                    shopView.content.txtMoney2.text = String(int(((_local2.APriceArr[0] % 10000) / 100)));
                    shopView.content.txtMoney3.text = String((_local2.APriceArr[0] % 100));
                };
            };
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < 8) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = ((_local1.width + 1) * (_local3 % 8));
                _local1.y = (_local1.height * int((_local3 / 8)));
                _local1.name = ("NPCShopSale_" + _local3.toString());
                gridSprite.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = gridSprite;
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                NPCShopConstData.GridUnitList.push(_local2);
                _local3++;
            };
            shopView.content.addChild(gridSprite);
            shopGridManager = new NPCShopGridManager(NPCShopConstData.GridUnitList, gridSprite);
            facade.registerProxy(shopGridManager);
            shopGridManager.Initialize();
        }
        private function updateSaleMoney():void{
            var _local1:Number;
            var _local3:int;
            var _local2:Number = 0;
            while (_local3 < NPCShopConstData.goodSaleList.length) {
                _local1 = (UIConstData.ItemDic[NPCShopConstData.goodSaleList[_local3].type].PriceOut * NPCShopConstData.goodSaleList[_local3].Count);
                _local2 = (_local2 + _local1);
                _local3++;
            };
            var _local4 = "";
            if ((_local2 == 0)){
                _local4 = "";
            } else {
                _local4 = UIUtils.getMoneyStandInfo(_local2, strArr);
            };
            EffectLib.textBlink(shopView.content.txtMoney7, String(int((_local2 / 10000))));
            EffectLib.textBlink(shopView.content.txtMoney8, String(int(((_local2 % 10000) / 100))));
            EffectLib.textBlink(shopView.content.txtMoney9, String((_local2 % 100)));
            shopView.content.txtMoney7.text = String(int((_local2 / 10000)));
            shopView.content.txtMoney8.text = String(int(((_local2 % 10000) / 100)));
            shopView.content.txtMoney9.text = String((_local2 % 100));
        }
        private function updateSaleData():void{
            var _local1:int = (NPCShopConstData.goodSaleList.length - 1);
            shopGridManager.addItem(_local1);
            updateSaleMoney();
        }

    }
}//package GameUI.Modules.NPCShop.Mediator 
