//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Trade.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import Net.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Trade.Data.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Trade.UI.*;
    import GameUI.*;

    public class TradeMediator extends Mediator {

        public static const NAME:String = "TradeMediator";
        public static const MONEY_PANEL_POS:Point = new Point(435, 94);
        public static const GRID_POS:Point = new Point(12, 55);
        public static const TRADE_PANEL_POS:Point = new Point(80, 58);

        private var tradePanel:PanelBase = null;
        private var moneyFrame:HFrame = null;
        private var applyPersonIds:uint;
        private var moneyContent:MovieClip = null;
        private var tradeUIManager:TradeUIManager = null;
        private var iScrollPane:UIScrollPane = null;
        private var tradeDataProxy:TradeDataProxy = null;
        private var notiData:Object;
        private var listView:ListComponent = null;
        private var dataProxy:DataProxy = null;

        public function TradeMediator(){
            notiData = new Object();
            super(NAME);
        }
        private function showItems(_arg1:Array):void{
            var _local2:UseItem;
            removeAllItem();
            var _local3:int;
            while (_local3 < _arg1.length) {
                if (_arg1[_local3] == undefined){
                } else {
                    _local2 = new UseItem(_arg1[_local3].index, _arg1[_local3].type, trade);
                    _local2.Num = _arg1[_local3].Count;
                    _local2.x = 2;
                    _local2.y = 2;
                    _local2.Id = _arg1[_local3].id;
                    _local2.IsBind = _arg1[_local3].isBind;
                    _local2.Type = _arg1[_local3].type;
                    TradeConstData.GridUnitList[_arg1[_local3].index].Item = _local2;
                    TradeConstData.GridUnitList[_arg1[_local3].index].IsUsed = true;
                    TradeConstData.GridUnitList[_arg1[_local3].index].Grid.addChild(_local2);
                };
                _local3++;
            };
        }
        private function showTradeInformation(_arg1:Object):void{
            var _local2:int;
            var _local3:GameElementAnimal;
            var _local4:String;
            switch (_arg1.type){
                case 1:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示5"),
                        color:0xFFFF00
                    });
                    break;
                case 2:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示6"),
                        color:0xFFFF00
                    });
                    break;
                case 3:
                    _local4 = GameCommonData.SameSecnePlayerList[_arg1.targetid].Role.Name;
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示7", _local4),
                        color:0xFFFF00
                    });
                    break;
                case 4:
                    _local4 = GameCommonData.SameSecnePlayerList[_arg1.targetid].Role.Name;
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示8", _local4),
                        color:0xFFFF00
                    });
                    break;
                case 5:
                    _local4 = GameCommonData.SameSecnePlayerList[_arg1.targetid].Role.Name;
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示9", _local4),
                        color:0xFFFF00
                    });
                    break;
                case 6:
                    break;
                case 7:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示10"),
                        color:0xFFFF00
                    });
                    break;
                case 8:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易成功"),
                        color:0xFFFF00
                    });
                    break;
                case 9:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示11"),
                        color:0xFFFF00
                    });
                    break;
                case 10:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("对方已确认"),
                        color:0xFFFF00
                    });
                    break;
                case 11:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易已取消"),
                        color:0xFFFF00
                    });
                    break;
                case 12:
                    _local2 = int(_arg1.data);
                    if (!GameCommonData.SameSecnePlayerList[_local2]){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:1});
                        return;
                    };
                    _local3 = GameCommonData.SameSecnePlayerList[_local2];
                    _local4 = _local3.Role.Name;
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示15"),
                        color:0xFFFF00
                    });
                    break;
                case 13:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示12"),
                        color:0xFFFF00
                    });
                    break;
                case 14:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示13"),
                        color:0xFFFF00
                    });
                    break;
                case 15:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示14"),
                        color:0xFFFF00
                    });
                    break;
            };
        }
        private function formatMoney(_arg1:Number, _arg2:Number, _arg3:Number):Number{
            return ((((10000 * _arg1) + (100 * _arg2)) + _arg3));
        }
        private function updateView():void{
            switch (notiData.action){
                case TradeAction.LOCK:
                    if (notiData.operId == GameCommonData.Player.Role.Id){
                        tradeDataProxy.sfLocked = true;
                        trade.content.txtState_self.htmlText = (("<font color='#5df029'>" + LanguageMgr.GetTranslation("已锁定")) + "</font>");
                        trade.btnLock.enable = false;
                        trade.btnInputMoney.enable = false;
                        trade.content.mcGreenRect.visible = true;
                    } else {
                        tradeDataProxy.opLocked = true;
                        trade.content.txtState_op.htmlText = (("<font color='#5df029'>" + LanguageMgr.GetTranslation("已锁定")) + "</font>");
                        trade.content.mcGreenRectOp.visible = true;
                    };
                    if (((tradeDataProxy.opLocked) && (tradeDataProxy.sfLocked))){
                        trade.btnSure.enable = true;
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:7});
                    };
                    break;
                case TradeAction.OK:
                    if (notiData.operId == GameCommonData.Player.Role.Id){
                        trade.btnSure.enable = false;
                        trade.content.txtState_self.htmlText = (("<font color='#5df029'>" + LanguageMgr.GetTranslation("已确认")) + "</font>");
                    } else {
                        trade.content.txtState_op.htmlText = (("<font color='#5df029'>" + LanguageMgr.GetTranslation("已确认")) + "</font>");
                    };
                    if (trade.content.txtState_op.text != LanguageMgr.GetTranslation("已确认")){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:9});
                    };
                    if (((dataProxy.TradeIsOpen) && (!((notiData.operId == GameCommonData.Player.Role.Id))))){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:10});
                    };
                    break;
                case TradeAction.CANCEL:
                    if (notiData.operId == GameCommonData.Player.Role.Id){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易提示1"),
                            color:0xFFFF00
                        });
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易提示2"),
                            color:0xFFFF00
                        });
                    };
                    sendNotification(EventList.TRADEFAULT);
                    gcAll();
                    break;
                case TradeAction.MONEYALL:
                    if (tradeDataProxy.moneyOp != notiData.gold){
                        if (tradeDataProxy.sfLocked){
                            facade.sendNotification(EventList.TRADEUNLOCK);
                        };
                    };
                    tradeDataProxy.moneyOp = notiData.gold;
                    tradeUIManager.showMoney(0);
                    break;
                case TradeAction.SELFMONEYALL:
                    if (tradeDataProxy.moneySelf != notiData.gold){
                        if (tradeDataProxy.opLocked){
                            facade.sendNotification(EventList.TRADEUNLOCK_OP);
                        };
                    };
                    tradeDataProxy.moneySelf = notiData.gold;
                    tradeUIManager.showMoney(1);
                    break;
                case TradeAction.SUCCESS:
                    sendNotification(EventList.TRADECOMPLETE);
                    sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:8});
                    gcAll();
                    break;
                case TradeAction.FALSE:
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易失败"),
                        color:0xFFFF00
                    });
                    gcAll();
                    break;
                case TradeAction.ADDITEM:
                    tradeUIManager.addItem(1, notiData);
                    break;
                case TradeAction.ADDITEM_OP:
                    tradeUIManager.addItem(0, notiData);
                    break;
                case TradeAction.ADDITEMFAIL:
                    break;
                case TradeAction.DELITEMFAIL:
                    break;
            };
        }
        private function showView():void{
            tradeUIManager.initPanel();
            trade.btnInputMoney.enable = true;
            trade.btnLock.enable = true;
            addLis();
            tradeDataProxy.opLocked = false;
            tradeDataProxy.sfLocked = false;
            EffectLib.checkTranslationByShow(trade, GameCommonData.GameInstance.stage);
            GameCommonData.GameInstance.GameUI.addChild(trade);
            trade.centerFrame();
            moneyFrame.x = MONEY_PANEL_POS.x;
            moneyFrame.y = MONEY_PANEL_POS.y;
        }
        private function showTradeAsk():void{
            var _local1:GameElementAnimal;
            var _local2:String;
            var _local3:* = applyPersonIds;
            if (((_local3) && (GameCommonData.SameSecnePlayerList[_local3]))){
                _local1 = GameCommonData.SameSecnePlayerList[_local3];
                _local2 = _local1.Role.Name;
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:applyTrade,
                    cancel:cancelClose,
                    isShowClose:false,
                    info:((("[" + _local2) + "]") + LanguageMgr.GetTranslation("希望与你交易")),
                    title:LanguageMgr.GetTranslation("提 示"),
                    comfirmTxt:LanguageMgr.GetTranslation("同 意"),
                    cancelTxt:LanguageMgr.GetTranslation("拒 绝")
                });
            };
        }
        private function applyTrade():void{
            var _local1:Object;
            var _local2:Array;
            var _local3:int;
            var _local4:Object;
            var _local5:Array;
            if (GameCommonData.Player.Role.isStalling > 0){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("交易提示3"),
                    color:0xFFFF00
                });
                cancelClose();
                return;
            };
            if (dataProxy.StallIsOpen){
                facade.sendNotification(EventList.CLOSESTALL);
            };
            var _local6:* = applyPersonIds;
            if (((_local6) && (GameCommonData.SameSecnePlayerList[_local6]))){
                _local1 = new Object();
                _local2 = new Array();
                TradeSend.selectTrade(_local6, true);
            } else {
                sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:1});
            };
        }
        private function btnHandler(_arg1:MouseEvent):void{
            var _local2:Array;
            switch (_arg1.target.parent.name){
                case "btnInputMoney":
                    if (!GameCommonData.GameInstance.GameUI.contains(moneyFrame)){
                        GameCommonData.GameInstance.GameUI.addChild(moneyFrame);
                        _local2 = tradeUIManager.getMoney(tradeDataProxy.moneySelf);
                        moneyContent._txtJin.text = _local2[0].toString();
                        moneyContent._txtYin.text = _local2[1].toString();
                        moneyContent._txtTong.text = _local2[2].toString();
                    } else {
                        gcMoneyPanel();
                    };
                    break;
                case "btnLock":
                    gcMoneyPanel();
                    sendData(TradeAction.LOCK);
                    break;
                case "btnSure":
                    if (checkBagEnough()){
                        sendData(TradeAction.OK);
                    };
                    break;
            };
            switch (_arg1.currentTarget.name){
                case "_btnInputSure":
                    sendData(TradeAction.ADDMONEY);
                    gcMoneyPanel();
                    break;
                case "_btnInputCancel":
                    gcMoneyPanel();
                    break;
            };
        }
        private function tradePanelCloseHandler():void{
            sendData(TradeAction.QUIT);
        }
        private function cancelClose():void{
            TradeSend.selectTrade(applyPersonIds, false);
        }
        private function gcMoneyPanel():void{
            if (GameCommonData.GameInstance.GameUI.contains(moneyFrame)){
                GameCommonData.GameInstance.GameUI.removeChild(moneyFrame);
            };
        }
        private function get trade():TradeView{
            return ((viewComponent as TradeView));
        }
        private function gcAll():void{
            var _local2:uint;
            removeLis();
            tradeUIManager.removeAllItem();
            tradeUIManager.removeAllItemOp();
            tradeDataProxy.moneyOp = 0;
            tradeDataProxy.moneySelf = 0;
            TradeConstData.opName = "";
            TradeConstData.goodSelfList = new Array(6);
            TradeConstData.goodOpList = new Array(6);
            if (GameCommonData.GameInstance.GameUI.contains(trade)){
                EffectLib.checkTranslationByClose(trade, GameCommonData.GameInstance.stage);
                trade.close();
            };
            gcMoneyPanel();
            UIConstData.IsTrading = false;
            dataProxy.TradeIsOpen = false;
            GameCommonData.Player.Role.State = GameRole.STATE_NULL;
            UIConstData.KeyBoardCanUse = true;
            var _local1:int;
            while (_local1 < TradeConstData.idItemSelfArr.length) {
                if (TradeConstData.idItemSelfArr[_local1] != -1){
                    _local2 = TradeConstData.idItemSelfArr[_local1];
                    if (BagData.SelectIndex == ItemConst.placeToPanel(_local2)){
                        if (BagData.GridUnitList[BagData.SelectIndex][(ItemConst.placeToOffset(_local2) % BagData.MAX_GRIDS)].Item){
                            BagData.GridUnitList[BagData.SelectIndex][(ItemConst.placeToOffset(_local2) % BagData.MAX_GRIDS)].Item.IsLock = false;
                        };
                    };
                    BagData.AllLocks[ItemConst.placeToPanel(_local2)][ItemConst.placeToOffset(_local2)] = false;
                    TradeConstData.idItemSelfArr[_local1] = -1;
                };
                _local1++;
            };
        }
        private function initView():void{
            moneyContent = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MoneyInput");
            setViewComponent(new TradeView());
            trade.closeCallBack = tradePanelCloseHandler;
            UIUtils.ReplaceButtonNTextFieldToButton(moneyContent, LanguageMgr.GetTranslation("确认"), "btnInputSure");
            UIUtils.ReplaceButtonNTextFieldToButton(moneyContent, LanguageMgr.GetTranslation("取消"), "btnInputCancel");
            UIUtils.ReplaceInputText(moneyContent, "txtJin", 6);
            UIUtils.ReplaceInputText(moneyContent, "txtYin", 2);
            UIUtils.ReplaceInputText(moneyContent, "txtTong", 2);
            moneyFrame = new HFrame();
            moneyFrame.centerTitle = true;
            moneyFrame.blackGound = true;
            this.moneyFrame.setSize((moneyContent.width + 40), (moneyContent.height + 50));
            moneyContent.x = 0;
            moneyContent.y = 40;
            moneyFrame.addChild(moneyContent);
            moneyContent._btnInputSure.x = 63;
            moneyContent._btnInputCancel.x = 127;
            moneyContent._btnInputSure.y = (moneyContent._btnInputSure.y - 5);
            moneyContent._btnInputCancel.y = (moneyContent._btnInputCancel.y - 5);
            moneyFrame.titleText = LanguageMgr.GetTranslation("金币输入");
            moneyFrame.closeCallBack = moneyPanelCloseHandler;
            trade.x = 325;
            trade.y = ((GameCommonData.GameInstance.ScreenHeight - trade.height) / 2);
            moneyFrame.x = MONEY_PANEL_POS.x;
            moneyFrame.y = MONEY_PANEL_POS.y;
            UIUtils.addFocusLis(moneyContent._txtJin);
            UIUtils.addFocusLis(moneyContent._txtYin);
            UIUtils.addFocusLis(moneyContent._txtTong);
            initGrid();
            tradeDataProxy = new TradeDataProxy(TradeConstData.GridUnitList, TradeConstData.GridUnitListOp);
            facade.registerProxy(tradeDataProxy);
            tradeDataProxy.Initialize();
            tradeUIManager = new TradeUIManager(trade.content, moneyContent, tradeDataProxy);
            trade.btnSure.enable = false;
            trade.btnLock.enable = true;
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.RESIZE_STAGE, EventList.SHOWTRADE, EventList.UPDATETRADE, EventList.REMOVETRADE, EventList.APPLYTRADE, EventList.GOTRADEVIEW, EventList.GOBAGVIEW, EventList.TRADEUNLOCK, EventList.TRADEUNLOCK_OP, TradeEvent.SOMEONETRADEME, TradeEvent.SOMEONEREFUSEME, TradeEvent.SHOWTRADEINFORMATION]);
        }
        private function removeAllItem():void{
            var _local1:ItemBase;
            var _local2:* = (trade.numChildren - 1);
            while (_local2) {
                if ((trade.getChildAt(_local2) is ItemBase)){
                    _local1 = (trade.getChildAt(_local2) as ItemBase);
                    trade.removeChild(_local1);
                    _local1 = null;
                };
                _local2--;
            };
            var _local3:int;
            while (_local3 < 6) {
                TradeConstData.GridUnitList[_local3].Item = null;
                TradeConstData.GridUnitList[_local3].IsUsed = false;
                _local3++;
            };
        }
        private function sendData(_arg1:int):void{
            var _local2:Number = NaN;
            var _local3:Number = NaN;
            var _local4:Number = NaN;
            var _local5:Number = NaN;
            switch (_arg1){
                case TradeAction.ADDMONEY:
                    _local2 = Number(moneyContent._txtJin.text);
                    _local3 = Number(moneyContent._txtYin.text);
                    _local4 = Number(moneyContent._txtTong.text);
                    _local5 = formatMoney(_local2, _local3, _local4);
                    if (_local5 > GameCommonData.Player.Role.Gold){
                        _local5 = GameCommonData.Player.Role.Gold;
                    };
                    if (_local5 != tradeDataProxy.moneySelf){
                        TradeSend.addMoney(_local5);
                    };
                    break;
                case TradeAction.LOCK:
                    TradeSend.lockTrade();
                    break;
                case TradeAction.OK:
                    TradeSend.confirmTrade();
                    break;
                case TradeAction.QUIT:
                    TradeSend.cancelTrade();
                    break;
                case TradeAction.BACK_WU:
                    TradeSend.addItemToTrade(-1, tradeDataProxy.goodPetOperating.place);
                    break;
                case TradeAction.ADDITEM:
                    TradeSend.addItemToTrade(notiData.place, notiData.dstPlace);
                    break;
                case TradeAction.APPLY:
                    TradeSend.applyTrade(notiData.id);
                    break;
            };
        }
        private function addLis():void{
            trade.btnInputMoney.addEventListener(MouseEvent.CLICK, btnHandler);
            trade.btnLock.addEventListener(MouseEvent.CLICK, btnHandler);
            trade.btnSure.addEventListener(MouseEvent.CLICK, btnHandler);
            moneyContent._btnInputSure.addEventListener(MouseEvent.CLICK, btnHandler);
            moneyContent._btnInputCancel.addEventListener(MouseEvent.CLICK, btnHandler);
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:MovieClip;
            var _local4:GridUnit;
            var _local5:int;
            while (_local5 < 6) {
                _local1 = trade.content[("mcPhoto_" + _local5)];
                _local2 = new GridUnit(_local1, true);
                _local2.parent = trade.content;
                _local2.Index = _local5;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                TradeConstData.GridUnitList.push(_local2);
                _local5++;
            };
            showItems(TradeConstData.goodSelfList);
            var _local6:int;
            while (_local6 < 6) {
                _local3 = trade.content[("mcOpPhoto_" + _local6)];
                _local4 = new GridUnit(_local3, false);
                _local4.parent = trade.content;
                _local4.Index = _local5;
                _local4.HasBag = true;
                _local4.IsUsed = false;
                _local4.Item = null;
                TradeConstData.GridUnitListOp.push(_local4);
                _local6++;
            };
            showItems(TradeConstData.goodOpList);
        }
        private function checkBagEnough():Boolean{
            var _local1:int;
            var _local2:int;
            var _local3:InventoryItemInfo;
            var _local4:uint;
            var _local5:uint;
            while (_local5 < TradeConstData.goodOpList.length) {
                _local3 = TradeConstData.goodOpList[_local5];
                if (!_local3){
                } else {
                    _local4 = ItemConst.placeToPanel(_local3.Place);
                    if (_local4 == 0){
                        _local1++;
                    } else {
                        if (_local4 == 1){
                            _local2++;
                        };
                    };
                };
                _local5++;
            };
            _local5 = 0;
            while (_local5 < TradeConstData.goodSelfList.length) {
                _local3 = TradeConstData.goodSelfList[_local5];
                if (!_local3){
                } else {
                    _local4 = ItemConst.placeToPanel(_local3.Place);
                    if (_local4 == 0){
                        _local1--;
                    } else {
                        if (_local4 == 1){
                            _local2--;
                        };
                    };
                };
                _local5++;
            };
            if (BagData.getPanelEmptyNum(0) < _local1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("交易提示16"),
                    color:0xFFFF00
                });
                return (false);
            };
            if (BagData.getPanelEmptyNum(1) < _local2){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("交易提示17"),
                    color:0xFFFF00
                });
                return (false);
            };
            return (true);
        }
        private function removeLis():void{
            trade.btnInputMoney.removeEventListener(MouseEvent.CLICK, btnHandler);
            trade.btnLock.removeEventListener(MouseEvent.CLICK, btnHandler);
            trade.btnSure.removeEventListener(MouseEvent.CLICK, btnHandler);
            moneyContent._btnInputSure.removeEventListener(MouseEvent.CLICK, btnHandler);
            moneyContent._btnInputCancel.removeEventListener(MouseEvent.CLICK, btnHandler);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local17:*;
            var _local18:FriendInfoStruct;
            var _local2:int;
            var _local3:GameElementAnimal;
            var _local4:String;
            var _local5:GameElementAnimal;
            var _local6:String;
            var _local7:int;
            var _local8:int;
            var _local9:Object;
            var _local10:Object;
            var _local11:int;
            var _local12:Object;
            var _local13:Dictionary;
            var _local14:Dictionary;
            var _local15:Object;
            var _local16:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.RESIZE_STAGE:
                    if (!trade){
                        return;
                    };
                    trade.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - trade.width);
                    trade.y = ((GameCommonData.GameInstance.ScreenHeight - UIConstData.BagHeight) / 2);
                    break;
                case EventList.SHOWTRADE:
                    if (!trade){
                        facade.sendNotification(EventList.GETRESOURCE, {
                            type:UIConfigData.MOVIECLIP,
                            mediator:this,
                            name:UIConfigData.TRADE
                        });
                        initView();
                        trade.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - trade.width);
                        trade.y = ((GameCommonData.GameInstance.ScreenHeight - UIConstData.BagHeight) / 2);
                    };
                    if (dataProxy.DepotIsOpen){
                        sendNotification(EventList.CLOSEDEPOTVIEW);
                    };
                    if (dataProxy.NPCShopIsOpen){
                        sendNotification(EventList.CLOSENPCSHOPVIEW);
                    };
                    GameCommonData.Player.Role.State = GameRole.STATE_TRADE;
                    _local2 = _arg1.getBody().id;
                    _local3 = GameCommonData.SameSecnePlayerList[_local2];
                    _local4 = _local3.Role.Name;
                    TradeConstData.opName = _local4;
                    trade.content.txtRoleName_op.text = _local4.toString();
                    showView();
                    dataProxy.TradeIsOpen = true;
                    UIConstData.IsTrading = true;
                    UIConstData.KeyBoardCanUse = false;
                    if (!dataProxy.BagIsOpen){
                        facade.sendNotification(EventList.SHOWBAG);
                    };
                    _local18 = new FriendInfoStruct();
                    _local18.roleName = _local4;
                    _local18.frendId = _local3.Role.Id;
                    _local18.level = _local3.Role.Level;
                    _local18.isOnline = true;
                    facade.sendNotification(FriendCommandList.ADD_TEMP_FRIEND, _local18);
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易提示19", _local4),
                        color:0xFFFF00
                    });
                    break;
                case EventList.UPDATETRADE:
                    if (dataProxy.TradeIsOpen){
                        notiData = new Object();
                        notiData = _arg1.getBody();
                        updateView();
                    };
                    break;
                case EventList.REMOVETRADE:
                    if (dataProxy.TradeIsOpen){
                        tradePanelCloseHandler();
                    };
                    break;
                case EventList.APPLYTRADE:
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易提示3"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:15});
                        return;
                    };
                    if (dataProxy.TradeIsOpen){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:2});
                        return;
                    };
                    notiData = _arg1.getBody();
                    if (!GameCommonData.SameSecnePlayerList[notiData.id]){
                        sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:1});
                        return;
                    };
                    _local5 = GameCommonData.SameSecnePlayerList[notiData.id];
                    _local6 = _local5.Role.Name;
                    sendData(TradeAction.APPLY);
                    break;
                case EventList.GOTRADEVIEW:
                    if (!tradeDataProxy.sfLocked){
                        _local11 = BagData.AllItems[ItemConst.placeToPanel(_arg1.getBody().srcPlace)][ItemConst.placeToOffset(_arg1.getBody().srcPlace)].ItemGUID;
                        notiData.place = _arg1.getBody().srcPlace;
                        notiData.dstPlace = _arg1.getBody().dstPlace;
                        sendData(TradeAction.ADDITEM);
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易提示4"),
                            color:0xFFFF00
                        });
                        TradeConstData.idItemSelfArr[_arg1.getBody().dstPlace] = -1;
                        sendNotification(EventList.BAGITEMUNLOCK, BagData.AllItems[ItemConst.placeToPanel(_arg1.getBody().srcPlace)][ItemConst.placeToOffset(_arg1.getBody().srcPlace)].ItemGUID);
                    };
                    break;
                case EventList.GOBAGVIEW:
                    tradeDataProxy.goodPetOperating.place = _arg1.getBody();
                    sendData(TradeAction.BACK_WU);
                    break;
                case EventList.TRADEUNLOCK:
                    trade.btnLock.enable = true;
                    trade.btnInputMoney.enable = true;
                    trade.content.mcGreenRect.visible = false;
                    trade.content.txtState_self.text = LanguageMgr.GetTranslation("尚未锁定");
                    tradeDataProxy.sfLocked = false;
                    if (((tradeDataProxy.opLocked) && (tradeDataProxy.sfLocked))){
                        trade.btnSure.visible = true;
                    };
                    sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:13});
                    break;
                case EventList.TRADEUNLOCK_OP:
                    tradeDataProxy.opLocked = false;
                    trade.content.txtState_op.htmlText = LanguageMgr.GetTranslation("尚未锁定");
                    trade.content.mcGreenRectOp.visible = false;
                    if (((tradeDataProxy.opLocked) && (tradeDataProxy.sfLocked))){
                        trade.btnSure.enable = false;
                    };
                    sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:14});
                    break;
                case TradeEvent.SOMEONETRADEME:
                    applyPersonIds = int(_arg1.getBody());
                    showTradeAsk();
                    break;
                case TradeEvent.YOUREFUSESOMEONE:
                    _local17 = applyPersonIds;
                    if (((_local17) && (GameCommonData.SameSecnePlayerList[_local17]))){
                        _local4 = (GameCommonData.SameSecnePlayerList[_local17] as GameElementAnimal).Role.Name;
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("你拒绝x的交易请求", _local4),
                            color:0xFFFF00
                        });
                    };
                    break;
                case TradeEvent.SOMEONEREFUSEME:
                    _local8 = int(_arg1.getBody());
                    showRefuseAlert(_local8);
                    break;
                case TradeEvent.SHOWTRADEINFORMATION:
                    _local9 = _arg1.getBody();
                    showTradeInformation(_local9);
                    break;
            };
        }
        private function alertBack():void{
        }
        private function moneyPanelCloseHandler():void{
            gcMoneyPanel();
        }
        private function showRefuseAlert(_arg1:int):void{
            var _local2:GameElementAnimal;
            var _local3:String;
            if (((_arg1) && (GameCommonData.SameSecnePlayerList[_arg1]))){
                _local2 = GameCommonData.SameSecnePlayerList[_arg1];
                _local3 = _local2.Role.Name;
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("交易提示18"),
                    color:0xFFFF00
                });
            } else {
                sendNotification(TradeEvent.SHOWTRADEINFORMATION, {type:1});
            };
        }

    }
}//package GameUI.Modules.Trade.Mediator 
