//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import flash.filters.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;
    import GameUI.Modules.Stall.Data.*;
    import GameUI.Modules.Bag.Command.*;
    import GameUI.Modules.Bag.Mediator.DealItem.*;
    import flash.ui.*;
    import GameUI.*;

    public class BagMediator extends Mediator {

        private static const MAXTAB:uint = 3;
        public static const STARTPOS:Point = new Point(7, 24);
        public static const NAME:String = "BagMediator";

        private var gridManager:GridManager = null;
        public var splitOper:DragOperator;
        private var dealItemDelayTime:Number = 0;
        private var initFlag:Boolean = true;
        private var BagFullIdx:int = -1;
        private var isGet:Boolean = false;
        public var vipItem:VIPMenuItem = null;
        private var dataProxy:DataProxy = null;
        public var destroyOper:DragOperator;
        private var flag:String = "";
        public var comfrim:Function;
        public var cancel:Function;

        public function BagMediator(){
            comfrim = comfrimDrop;
            cancel = cancelDrop;
            super(NAME);
        }
        private function extendGrid(_arg1:uint):void{
            var _local3:uint;
            var _local2:uint = BagData.BagNum[0];
            if (_local2 == (BagData.MAX_GRIDS * BagData.MAX_PAGE)){
                return;
            };
            if (_arg1 == 0){
                _local3 = BagData.MAX_GRIDS;
                BagData.BagNum[0] = BagData.MAX_GRIDS;
            } else {
                _local3 = _arg1;
                BagData.BagNum[0] = _arg1;
            };
            updateExtendAllTips();
            if (_local3 > BagData.MAX_GRIDS){
                _local3 = (_local3 - BagData.MAX_GRIDS);
            };
            var _local4:uint;
            while (_local4 < _local3) {
                BagData.GridUnitList[0][_local4].Grid.visible = true;
                BagData.GridUnitList[BagData.SelectIndex][_local4].HasBag = true;
                _local4++;
            };
            bag.content.txt_hasUseCount.text = (((BagData.BagNum[BagData.SelectIndex] - BagData.getPanelEmptyNum(BagData.SelectIndex)) + "/") + BagData.BagNum[BagData.SelectIndex]);
        }
        private function updateBagMoney():void{
            this.bag.content.txtMoney1.text = String(int((GameCommonData.Player.Role.Gold / 10000)));
            this.bag.content.txtMoney2.text = String(int(((GameCommonData.Player.Role.Gold % 10000) / 100)));
            this.bag.content.txtMoney3.text = String(int((GameCommonData.Player.Role.Gold % 100)));
            this.bag.content.txtLeaf1.text = String(int((GameCommonData.Player.Role.Money / 100)));
            this.bag.content.txtLeaf2.text = String(int((GameCommonData.Player.Role.Money % 100)));
            this.bag.content.txtCoupon.text = String(GameCommonData.Player.Role.Gift);
        }
        private function getUseItem(_arg1:Object):UseItem{
            var _local3:String;
            var _local2:UseItem = new UseItem(_arg1.index, _arg1.type, bag, _arg1.ItemGUID);
            _local2.Num = _arg1.Count;
            _local2.clearThumbLock();
            _local2.itemIemplateInfo = (UIConstData.ItemDic[_arg1.TemplateID] as ItemTemplateInfo);
            if (_local2.iconName != _arg1.img){
                _local2.resetIcon(_arg1.img);
            };
            if ((((((_local2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_local2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))) && ((_local2.itemIemplateInfo.HpBonus > 4)))){
                _local3 = String((_arg1.img + (BagData.getItemById(_arg1.ItemGUID).Add1 * 10)));
                _local2.resetIcon(_local3);
            };
            if (((((_arg1 as InventoryItemInfo).Flags & ItemConst.FlAGS_TRADE)) || ((_arg1 as InventoryItemInfo).isBind))){
                _local2.setThumbLock();
            };
            _local2.setBroken((_arg1 as InventoryItemInfo).isBroken);
            _local2.x = (BagData.GridUnitList[0][(_arg1.index % BagData.MAX_GRIDS)].Grid.x + 2);
            _local2.y = (BagData.GridUnitList[0][(_arg1.index % BagData.MAX_GRIDS)].Grid.y + 2);
            _local2.Id = _arg1.ItemGUID;
            _local2.IsBind = _arg1.isBind;
            _local2.Type = _arg1.type;
            _local2.IsLock = BagData.AllLocks[BagData.SelectIndex][_arg1.index];
            return (_local2);
        }
        public function cancelDrop():void{
        }
        public function get bag():BagUIView{
            return ((this.viewComponent as BagUIView));
        }
        private function setPos():void{
            if (((dataProxy.StallIsOpen) || (dataProxy.TradeIsOpen))){
                bag.X = (GameCommonData.GameInstance.ScreenWidth / 2);
                bag.Y = (((GameCommonData.GameInstance.ScreenHeight - bag.height) / 2) - 20);
            } else {
                bag.X = ((GameCommonData.GameInstance.ScreenWidth / 2) + 100);
                bag.Y = (((GameCommonData.GameInstance.ScreenHeight - bag.height) / 2) - 20);
            };
        }
        private function Cancel():void{
            BagData.gotoClickExtendBtn = true;
        }
        protected function getCells(_arg1:int, _arg2:int, _arg3:DisplayObjectContainer, _arg4:uint=0):UseItem{
            if (((!((BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].Item == null))) && ((BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].Item.Pos == _arg1)))){
                return (BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].Item);
            };
            return (new UseItem(_arg1, _arg2, _arg3, _arg4));
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            var _local2:uint;
            switch (_arg1.target.parent.name){
                case "btnStall":
                    bag.btnDeal.enable = false;
                    bag.btnDrop.enable = false;
                    bag.btnSplit.enable = false;
                    bag.btnStall.enable = false;
                    facade.sendNotification(EventList.SHOWSTALL);
                    break;
                case "btnSplit":
                    splitOper.setDrag(_arg1);
                    Mouse.hide();
                    break;
                case "btnDrop":
                    destroyOper.setDrag(_arg1);
                    Mouse.hide();
                    break;
                case "btnDeal":
                    _local2 = getTimer();
                    if ((_local2 - this.dealItemDelayTime) > 5000){
                        this.dealItemDelayTime = _local2;
                        facade.sendNotification(DealItemCommand.NAME, bag);
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("dealtoofast"),
                            color:0xFFFF00
                        });
                    };
                    break;
                case "btnVIP":
                    if (vipItem == null){
                        vipItem = new VIPMenuItem(this.view);
                    } else {
                        vipItem.showMenu();
                    };
                    _arg1.stopImmediatePropagation();
                    break;
            };
        }
        private function onClickHandler(_arg1:MouseEvent):void{
            var _local2:int;
            var _local3:int;
            switch (String(_arg1.target.name)){
                case "vipItem_0":
                    if (GameCommonData.Player.Role.VIP <= 0){
                        MessageTip.popup(LanguageMgr.GetTranslation("周卡及以上VIP玩家才拥有此特权"));
                        return;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.CLOSEHEROPROP);
                    UIFacade.GetInstance().sendNotification(EventList.SHOWDEPOTVIEW);
                    break;
                case "vipItem_1":
                    if (GameCommonData.Player.Role.VIP <= 1){
                        MessageTip.popup(LanguageMgr.GetTranslation("月卡及以上VIP玩家才拥有此特权"));
                        return;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.CLOSEHEROPROP);
                    MarketSend.requestInventory(1);
                    break;
                case "vipItem_2":
                    if (GameCommonData.Player.Role.VIP <= 2){
                        MessageTip.popup(LanguageMgr.GetTranslation("半年卡VIP玩家才拥有此特权"));
                        return;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.CLOSEHEROPROP);
                    UIFacade.GetInstance().sendNotification(UnityEvent.SHOW_GUILDDONATEPANEL, OfferType.OFFER_GUILD);
                    break;
                case "vipItem_3":
                    if (GameCommonData.Player.Role.VIP <= 2){
                        MessageTip.popup(LanguageMgr.GetTranslation("半年卡VIP玩家才拥有此特权"));
                        return;
                    };
                    if (GameCommonData.Player.Role.CurrentJobID > 0){
                        UIFacade.GetInstance().sendNotification(UnityEvent.SHOW_GUILDDONATEPANEL, GameCommonData.Player.Role.CurrentJobID);
                        UIFacade.GetInstance().sendNotification(EventList.CLOSEHEROPROP);
                    } else {
                        MessageTip.popup(LanguageMgr.GetTranslation("你尚未加入职业"));
                    };
                    break;
                case "treasureBtn":
                    UIFacade.GetInstance().sendNotification(EventList.OPENITEMBOX_OPEN_DEPOT);
                    break;
                case "pageBtn1":
                    if ((((BagData.currentPage == 1)) || (!((BagData.SelectIndex == BagData.NormalId))))){
                        return;
                    };
                    BagData.currentPage = 1;
                    resetPageBtn(true, BagData.currentPage);
                    showItems(BagData.AllItems[BagData.SelectIndex]);
                    bag.extendRowTip = false;
                    break;
                case "pageBtn2":
                    if ((((BagData.currentPage == 2)) || (!((BagData.SelectIndex == BagData.NormalId))))){
                        return;
                    };
                    BagData.currentPage = 2;
                    resetPageBtn(true, BagData.currentPage);
                    showItems(BagData.AllItems[BagData.SelectIndex]);
                    break;
                case "extendBtn1":
                case "extendBtn2":
                case "extendBtn3":
                case "extendBtn4":
                    if (BagData.gotoClickExtendBtn){
                        _local2 = ((BagData.EXTEND_NUM / BagData.GRID_COLS) - 3);
                        _local3 = (10 * Math.pow(2, _local2));
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:ComfrimExtend,
                            cancel:Cancel,
                            info:LanguageMgr.GetTranslation("扩充一行背包句", _local3)
                        });
                    };
                    break;
            };
        }
        private function updateGrids():void{
            var _local1:int;
            var _local2:int = (BagData.GRID_COLS * BagData.GRID_ROWS);
            var _local3:int = ((BagData.currentPage - 1) * BagData.MAX_GRIDS);
            while (_local1 < _local2) {
                BagData.GridUnitList[0][_local1].Grid.visible = false;
                BagData.GridUnitList[0][_local1].HasBag = false;
                BagData.GridUnitList[0][_local1].Index = (_local3 + _local1);
                _local1++;
            };
        }
        public function get view():BagUIView{
            return ((getViewComponent() as BagUIView));
        }
        private function initViewUI():void{
            setViewComponent(new BagUIView());
            bag.extendRowTip = false;
            bag.extendRowTipPos = BagData.extendGridTipPos[0];
            bag.name = "bag";
            UIConstData.BagWidth = bag.width;
            UIConstData.BagHeight = (bag.height + 40);
            BagData.bagView = bag;
            facade.registerCommand(UseItemCommand.NAME, UseItemCommand);
            facade.registerCommand(DealItemCommand.NAME, DealItemCommand);
            facade.registerCommand(SplitCommand.NAME, SplitCommand);
            splitOper = new DragOperator((bag as Sprite), 0);
            destroyOper = new DragOperator((bag as Sprite), 1);
            this.bag.content.txtMoney1.text = "";
            this.bag.content.txtMoney2.text = "";
            this.bag.content.txtMoney3.text = "";
            if (BagData.BagNum[0] < BagData.MAX_GRIDS){
                bag.content.txt_extend1.htmlText = LanguageMgr.GetTranslation("x等级自动扩充背包", "#00ff00", "20");
                bag.content.txt_extend2.htmlText = LanguageMgr.GetTranslation("x等级自动扩充背包", "#ff9933", "45");
                bag.content.txt_extend3.htmlText = LanguageMgr.GetTranslation("x等级自动扩充背包", "#ff9933", "55");
            };
            initGrid();
        }
        public function comfrimDrop():void{
            BagData.comfirmDrop();
        }
        private function removeAllItem():void{
            var _local1:ItemBase;
            var _local2:int = (bag.content.numChildren - 1);
            while (_local2 >= 0) {
                if ((bag.content.getChildAt(_local2) is ItemBase)){
                    _local1 = (bag.content.getChildAt(_local2) as ItemBase);
                    bag.content.removeChild(_local1);
                };
                _local2--;
            };
            SetFrame.RemoveFrame(bag.content);
            _local2 = 0;
            while (_local2 < BagData.BagNum[BagData.SelectIndex]) {
                if (BagData.GridUnitList[BagData.SelectIndex][_local2] == null){
                } else {
                    BagData.GridUnitList[BagData.SelectIndex][_local2].IsUsed = false;
                };
                _local2++;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Boolean;
            var _local3:uint;
            var _local4:int;
            var _local5:int;
            var _local6:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    initData();
                    gridManager = new GridManager();
                    facade.registerProxy(gridManager);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    GameCommonData.GameInstance.GameUI.tabChildren = false;
                    GameCommonData.GameInstance.GameUI.tabEnabled = false;
                    GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    if (!bag){
                        initViewUI();
                    };
                    break;
                case EventList.SHOWBAG:
                    if (GameCommonData.IsInCrossServer){
                        if (!dataProxy.CSBBagIsOpen){
                            facade.sendNotification(EventList.CSB_SHOWCSBBAG);
                        } else {
                            facade.sendNotification(EventList.CSB_CLOSECSBBAG);
                        };
                        return;
                    };
                    if (BagData.IsLoadBagGoodList == false){
                        MessageTip.show(LanguageMgr.GetTranslation("bagloading"));
                        return;
                    };
                    setPos();
                    bag.centerFrame();
                    resetPageBtn(true, 1);
                    if (_arg1.getBody() != null){
                        _local6 = uint(_arg1.getBody());
                        if ((((_local6 >= 0)) && ((_local6 <= 2)))){
                            changePage(_local6);
                        };
                    } else {
                        if (BagFullIdx != -1){
                            changePage(BagFullIdx);
                        };
                    };
                    if (dataProxy.BagIsOpen){
                        showItems(BagData.AllItems[BagData.SelectIndex]);
                        return;
                    };
                    if (dataProxy.ConvoyIsOpen){
                        dataProxy.BagIsOpen = false;
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidopen2"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (dataProxy.FilterBagIsOpen){
                        dataProxy.BagIsOpen = false;
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidopen1"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    GameCommonData.GameInstance.GameUI.addChild(bag);
                    dataProxy.BagIsOpen = true;
                    bag.alpha = 1;
                    bag.closeCallBack = panelCloseHandler;
                    bag.closeBtn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
                    facade.sendNotification(NPCChatComList.NPCCHAT_VISIBLE, false);
                    bag.centerFrame();
                    bag.name = "bag";
                    EffectLib.checkTranslationByShow(bag, GameCommonData.GameInstance.stage);
                    showItems(BagData.AllItems[BagData.SelectIndex]);
                    doGuide_show();
                    break;
                case EventList.UPDATEBAG:
                    doGuide_updateBag();
                    if (!bag){
                        return;
                    };
                    if (((((initFlag) || (dataProxy.BagIsOpen))) || (dataProxy.FilterBagIsOpen))){
                        initFlag = false;
                        showItems(BagData.AllItems[BagData.SelectIndex]);
                        facade.sendNotification(EventList.UPDATEFILTERBAG);
                    };
                    checkBagIsFull();
                    break;
                case EventList.BAGITEMUNLOCK:
                    if (!bag){
                        return;
                    };
                    _local3 = (_arg1.getBody() as int);
                    bagItemUnLock(_local3);
                    break;
                case EventList.TRADECOMPLETE:
                    showItems(BagData.AllItems[BagData.SelectIndex]);
                    break;
                case EventList.TRADEFAULT:
                    _local4 = 0;
                    while (_local4 < BagData.GridUnitList[BagData.SelectIndex].length) {
                        if (BagData.GridUnitList[BagData.SelectIndex][_local4].Item){
                            BagData.AllLocks[BagData.SelectIndex][_local4] = false;
                            BagData.GridUnitList[BagData.SelectIndex][_local4].Item.IsLock = false;
                        };
                        _local4++;
                    };
                    break;
                case EventList.CLOSEBAG:
                    flag = (_arg1.getBody() as String);
                    panelCloseHandler();
                    break;
                case EventList.UPDATEMONEY:
                    if (((!(bag)) || (!(dataProxy.BagIsOpen)))){
                        return;
                    };
                    EffectLib.textBlink(this.bag.content.txtMoney1, String(int((GameCommonData.Player.Role.Gold / 10000))));
                    EffectLib.textBlink(this.bag.content.txtMoney2, String(int(((GameCommonData.Player.Role.Gold % 10000) / 100))));
                    EffectLib.textBlink(this.bag.content.txtMoney3, String(int((GameCommonData.Player.Role.Gold % 100))));
                    if (this.bag.content.txtLeaf1 != null){
                        EffectLib.textBlink(this.bag.content.txtLeaf1, String(int((GameCommonData.Player.Role.Money / 100))));
                        EffectLib.textBlink(this.bag.content.txtLeaf2, String(int((GameCommonData.Player.Role.Money % 100))));
                        EffectLib.textBlink(this.bag.content.txtCoupon, String(GameCommonData.Player.Role.Gift));
                    };
                    updateBagMoney();
                    if (dataProxy.StallIsOpen){
                        facade.sendNotification(StallEvents.REFRESHMONEYSEFLSTALL);
                    };
                    break;
                case BagEvents.EXTENDBAG:
                    BagData.EXTEND_NUM = uint(_arg1.getBody());
                    if (!bag){
                        return;
                    };
                    extendGrid(BagData.EXTEND_NUM);
                    checkBagIsFull();
                    break;
                case BagEvents.BAG_GOTO_SOME_INDEX:
                    _local3 = uint(_arg1.getBody());
                    changePage(_local3);
                    break;
                case EventList.RESIZE_STAGE:
                    if (!bag){
                        return;
                    };
                    setPos();
                    break;
                case BagEvents.UPDATE_BAG_PAGE:
                    _local5 = (_arg1.getBody().page as int);
                    BagData.SelectIndex = (_arg1.getBody().selectIndex as int);
                    BagData.currentPage = _local5;
                    resetPageBtn((BagData.SelectIndex == 0), BagData.currentPage);
                    break;
            };
        }
        private function updateExtendAllTips():void{
            var _local2:int;
            bag.content.txt_extend1.visible = false;
            bag.content.txt_extend2.visible = false;
            bag.content.txt_extend3.visible = false;
            bag.content.extendBtn1.visible = false;
            bag.content.extendTxt1.visible = false;
            bag.content.extendBtn2.visible = false;
            bag.content.extendTxt2.visible = false;
            bag.content.extendBtn3.visible = false;
            bag.content.extendTxt3.visible = false;
            bag.extendRowTip = false;
            bag.content.extendBtn2.mouseEnabled = true;
            bag.content.extendBtn3.mouseEnabled = true;
            bag.content.pageBtn2.mouseEnabled = true;
            bag.content.extendBtn2.filters = [];
            bag.content.extendBtn3.filters = [];
            bag.content.pageBtn2.filters = [];
            var _local1:ColorMatrixFilter = new ColorMatrixFilter([0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 1, 0]);
            if ((((BagData.SelectIndex == BagData.NormalId)) && ((BagData.currentPage == 1)))){
                if (BagData.BagNum[0] <= (3 * BagData.GRID_COLS)){
                    bag.content.txt_extend1.visible = true;
                    bag.content.extendBtn1.visible = true;
                    bag.content.extendTxt1.visible = true;
                    bag.content.extendBtn2.mouseEnabled = false;
                    bag.content.extendBtn2.filters = [_local1];
                };
                if (BagData.BagNum[0] <= (4 * BagData.GRID_COLS)){
                    bag.content.txt_extend2.visible = true;
                    bag.content.extendBtn2.visible = true;
                    bag.content.extendTxt2.visible = true;
                    bag.content.extendBtn3.mouseEnabled = false;
                    bag.content.extendBtn3.filters = [_local1];
                };
                if (BagData.BagNum[0] <= (5 * BagData.GRID_COLS)){
                    bag.content.txt_extend3.visible = true;
                    bag.content.extendBtn3.visible = true;
                    bag.content.extendTxt3.visible = true;
                    bag.content.pageBtn2.mouseEnabled = false;
                    bag.content.pageBtn2.filters = [_local1];
                };
            };
            if ((((BagData.currentPage == 2)) && ((BagData.SelectIndex == BagData.NormalId)))){
                _local2 = int(((BagData.BagNum[0] / BagData.GRID_COLS) - 6));
                bag.extendRowTipPos = BagData.extendGridTipPos[_local2];
                if ((((BagData.BagNum[0] >= (BagData.MAX_GRIDS - BagData.GRID_COLS))) && ((BagData.BagNum[0] <= ((2 * BagData.MAX_GRIDS) - BagData.GRID_COLS))))){
                    bag.extendRowTip = true;
                };
            };
        }
        private function showItems(_arg1:Array):void{
			
			return;//geoffyan
            var _local2:int = BagData.currentPage;
            _arg1 = _arg1.slice(((_local2 - 1) * BagData.MAX_GRIDS), (_local2 * BagData.MAX_GRIDS));
            removeAllItem();
            initView();
            updateGrids();
            gridManager.Initialize();
            if (BagData.GridUnitList[BagData.SelectIndex].length == 0){
                return;
            };
            var _local3:int;
            var _local4:int = BagData.SelectIndex;
            var _local5:int = (BagData.BagNum[BagData.SelectIndex] - ((BagData.currentPage - 1) * BagData.MAX_GRIDS));
            while (_local3 < BagData.MAX_GRIDS) {
                BagData.GridUnitList[0][_local3].Grid.visible = true;
                BagData.GridUnitList[BagData.SelectIndex][_local3].HasBag = true;
                if (BagData.GridUnitList[0][_local3].Grid){
                    BagData.GridUnitList[0][_local3].Grid.name = ("bag_" + (_local3 + ((BagData.currentPage - 1) * BagData.MAX_GRIDS)));
                };
                if ((((_local4 == BagData.NormalId)) && ((_local3 >= _local5)))){
                    BagData.GridUnitList[0][_local3].Grid.visible = false;
                    BagData.GridUnitList[0][_local3].HasBag = false;
                };
                if (_arg1[_local3] == null){
                    BagData.GridUnitList[BagData.SelectIndex][_local3].Item = null;
                } else {
                    addItem(_arg1[_local3]);
                };
                _local3++;
            };
            bag.content.txt_hasUseCount.text = (((BagData.BagNum[BagData.SelectIndex] - BagData.getPanelEmptyNum(BagData.SelectIndex)) + "/") + BagData.BagNum[BagData.SelectIndex]);
            updateExtendAllTips();
        }
        private function ComfrimExtend():void{
            if (GameCommonData.Player.Role.isStalling > 0){
                BagData.gotoClickExtendBtn = true;
                MessageTip.popup(LanguageMgr.GetTranslation("摆摊中不扩充背包"));
                return;
            };
            var _local1:int = ((BagData.EXTEND_NUM / BagData.GRID_COLS) - 3);
            var _local2:int = (10 * Math.pow(2, _local1));
            BagData.gotoClickExtendBtn = (GameCommonData.Player.Role.Money < (_local2 * 100));
            BagInfoSend.ExtendGrid(0);
        }
        private function showLock():void{
            var _local1:int;
            var _local2:int = ((BagData.currentPage - 1) * BagData.MAX_GRIDS);
            while (_local1 < BagData.MAX_GRIDS) {
                if (BagData.GridUnitList[0][_local1].Item){
                    BagData.GridUnitList[0][_local1].Item.IsLock = BagData.AllLocks[BagData.SelectIndex][(_local2 + _local1)];
                };
                _local1++;
            };
        }
        public function removeAllListener():void{
            bag.btnStall.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            bag.btnSplit.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            bag.btnDrop.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            bag.btnDeal.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            if (((bag.yaodianIcon) && (bag.yaodianIcon.hasEventListener(MouseEvent.CLICK)))){
                bag.yaodianIcon.removeEventListener(MouseEvent.CLICK, onClickHandler);
                bag.cangkuIcon.removeEventListener(MouseEvent.CLICK, onClickHandler);
                bag.gonghuiIcon.removeEventListener(MouseEvent.CLICK, onClickHandler);
                bag.zhiyeIcon.removeEventListener(MouseEvent.CLICK, onClickHandler);
            };
            bag.content.treasureBtn.removeEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.pageBtn1.removeEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.pageBtn2.removeEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.pageBtn1.removeEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
            bag.content.pageBtn2.removeEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
            bag.content.extendBtn1.removeEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.extendBtn2.removeEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.extendBtn3.removeEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.extendBtn4.removeEventListener(MouseEvent.CLICK, onClickHandler);
        }
        private function doGuide_show():void{
            if (NewGuideData.newerHelpIsOpen){
                facade.sendNotification(Guide_BagCommand.NAME, {state:1});
            };
        }
        private function addItem(_arg1:Object):void{
            var _local4:String;
            var _local2:Array = BagData.GridUnitList[BagData.SelectIndex];
            var _local3:UseItem = this.getCells(_arg1.index, _arg1.type, bag, _arg1.ItemGUID);
            _local3.Num = _arg1.Count;
            _local3.clearThumbLock();
            _local3.itemIemplateInfo = (UIConstData.ItemDic[_arg1.TemplateID] as ItemTemplateInfo);
            if (_local3.iconName != _arg1.img){
                _local3.resetIcon(_arg1.img);
            };
            if ((((((_local3.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_local3.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))) && ((_local3.itemIemplateInfo.HpBonus > 4)))){
                _local4 = String((_arg1.img + (BagData.getItemById(_arg1.ItemGUID).Add1 * 10)));
                _local3.resetIcon(_local4);
            };
            if (((((_arg1 as InventoryItemInfo).Flags & ItemConst.FlAGS_TRADE)) || ((_arg1 as InventoryItemInfo).isBind))){
                _local3.setThumbLock();
            };
            _local3.setBroken((_arg1 as InventoryItemInfo).isBroken);
            _local3.x = (BagData.GridUnitList[0][(_arg1.index % BagData.MAX_GRIDS)].Grid.x + 2);
            _local3.y = (BagData.GridUnitList[0][(_arg1.index % BagData.MAX_GRIDS)].Grid.y + 2);
            _local3.Id = _arg1.ItemGUID;
            _local3.IsBind = _arg1.isBind;
            _local3.Type = _arg1.type;
            _local3.IsLock = BagData.AllLocks[BagData.SelectIndex][_arg1.index];
            _local2[(_arg1.index % BagData.MAX_GRIDS)].Item = _local3;
            _local2[(_arg1.index % BagData.MAX_GRIDS)].IsUsed = true;
            bag.content.addChild(_local3);
        }
        private function initView():void{
            var _local1:int;
            while (_local1 < MAXTAB) {
                bag.content[("mcPage_" + _local1)].buttonMode = true;
                bag.content[("txtPage_" + _local1)].mouseEnabled = false;
                bag.content[("mcPage_" + _local1)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                if (_local1 == BagData.SelectIndex){
                    bag.content[("mcPage_" + _local1)].gotoAndStop(1);
                    bag.content[("txtPage_" + _local1)].textColor = 16496146;
                    bag.content[("mcPage_" + _local1)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                } else {
                    bag.content[("mcPage_" + _local1)].gotoAndStop(2);
                    bag.content[("txtPage_" + _local1)].textColor = 250597;
                };
                _local1++;
            };
            addAllListenser();
            updateBagMoney();
            bag.content.txt_hasUseCount.text = (((BagData.BagNum[0] - BagData.getPanelEmptyNum(0)) + "/") + BagData.BagNum[2]);
        }
        private function panelCloseHandler():void{
            var _local1:int;
            doGuide_close();
            if (UnityConstData.contributeIsOpen){
                sendNotification(UnityEvent.HIDE_GUILDDONATEPANEL);
            };
            if (dataProxy.DepotIsOpen){
                sendNotification(EventList.CLOSEDEPOTVIEW);
            };
            if (dataProxy.NPCShopIsOpen){
                sendNotification(EventList.CLOSENPCSHOPVIEW);
            };
            if (bag.parent){
                EffectLib.checkTranslationByClose(bag, GameCommonData.GameInstance.stage);
                if (flag == "quikly"){
                    bag.parent.removeChild(bag);
                } else {
                    bag.close();
                };
            };
            if (BagData.SplitIsOpen){
                sendNotification(BagEvents.REMOVE_SPLIT);
            };
            while (_local1 < MAXTAB) {
                bag.content[("mcPage_" + _local1)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                _local1++;
            };
            resetPageBtn(true);
            removeAllListener();
            gridManager.Gc();
            dataProxy.BagIsOpen = false;
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
            BagData.SelectIndex = BagData.NormalId;
            facade.sendNotification(NPCChatComList.NPCCHAT_VISIBLE, true);
            if (facade.hasCommand(Guide_EquipExchangeCommand.NAME)){
                facade.sendNotification(Guide_EquipExchangeCommand.NAME, {step:4});
            };
        }
        private function checkBagIsFull():void{
            var _local1 = -1;
            var _local2:int;
            while (_local2 < 3) {
                if (BagData.getPanelEmptyNum(_local2) == 0){
                    _local1 = _local2;
                    break;
                };
                _local2++;
            };
            if (BagFullIdx != _local1){
                BagFullIdx = _local1;
                facade.sendNotification(EventList.MAINBAR_BAGFULL, _local1);
            };
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local2:int;
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            while (_local2 < MAXTAB) {
                bag.content[("mcPage_" + _local2)].gotoAndStop(2);
                bag.content[("txtPage_" + _local2)].textColor = 250597;
                bag.content[("mcPage_" + _local2)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                _local2++;
            };
            var _local3:uint = BagData.SelectIndex;
            if (_arg1){
                _local3 = uint(_arg1.currentTarget.name.split("_")[1]);
            };
            bag.content[("mcPage_" + _local3)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
            BagData.SelectIndex = _local3;
            BagData.SelectedItem = null;
            bag.content[("mcPage_" + _local3)].gotoAndStop(1);
            bag.content[("txtPage_" + _local3)].textColor = 16496146;
            SetFrame.RemoveFrame(bag);
            resetPageBtn((BagData.SelectIndex == BagData.NormalId));
            showItems(BagData.AllItems[BagData.SelectIndex]);
        }
        private function changePage(_arg1:uint):void{
            BagData.SelectIndex = _arg1;
            choicePageHandler(null);
        }
        private function initData():void{
            BagData.NormalItemLock = new Array((BagData.MAX_GRIDS * BagData.MAX_PAGE));
            var _local1:int;
            while (_local1 < BagData.NormalItemLock.length) {
                BagData.NormalItemLock[_local1] = false;
                _local1++;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.SHOWBAG, EventList.UPDATEBAG, EventList.CLOSEBAG, BagEvents.EXTENDBAG, EventList.BAGITEMUNLOCK, EventList.TRADECOMPLETE, EventList.TRADEFAULT, EventList.UPDATEMONEY, EventList.RESIZE_STAGE, BagEvents.BAG_GOTO_SOME_INDEX, BagEvents.UPDATE_BAG_PAGE]);
        }
        private function doGuide_close():void{
            if (NewGuideData.newerHelpIsOpen){
                facade.sendNotification(Guide_BagCommand.NAME, {state:2});
                facade.sendNotification(NewGuideEvent.POINTBAGITEM_CLOSE);
            };
        }
        private function updateUseItemList():void{
            var _local4:*;
            var _local1:int;
            var _local2:* = BagData.AllItems[BagData.SelectIndex];
            var _local3:int = BagData.AllItems[BagData.SelectIndex].length;
            while (_local1 < _local3) {
                _local4 = BagData.AllItems[BagData.SelectIndex][_local1];
                BagData.AllUseItemList[BagData.SelectIndex][_local1] = ((_local4 == null)) ? null : getUseItem(_local4);
                _local1++;
            };
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:uint;
            var _local5:int;
            var _local4:int = (BagData.GRID_COLS * BagData.GRID_ROWS);
            _local3 = 0;
            while (_local3 < 3) {
                _local5 = 0;
                while (_local5 < _local4) {
                    if (_local3 == BagData.NormalId){
                        _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                        _local1.x = (((_local1.width + 2) * (_local5 % BagData.GRID_COLS)) + STARTPOS.x);
                        _local1.y = (((_local1.height + 2) * int((_local5 / BagData.GRID_COLS))) + STARTPOS.y);
                        _local1.name = ("bag_" + _local5.toString());
                        if (_local5 >= 18){
                            _local1.visible = false;
                        };
                        bag.content.addChild(_local1);
                        _local2 = new GridUnit(_local1, true);
                    } else {
                        _local2 = new GridUnit(null, true);
                    };
                    _local2.parent = bag.content;
                    _local2.Index = _local5;
                    _local2.HasBag = true;
                    _local2.IsUsed = false;
                    _local2.Item = null;
                    BagData.GridUnitList[_local3].push(_local2);
                    _local5++;
                };
                _local3++;
            };
        }
        private function onOverHandler(_arg1:MouseEvent):void{
            if (BagData.itemDrag == 0){
                return;
            };
            switch (String(_arg1.target.name)){
                case "pageBtn1":
                    if (BagData.currentPage == 1){
                        return;
                    };
                    resetPageBtn(true, 1);
                    showItems(BagData.AllItems[BagData.SelectIndex]);
                    break;
                case "pageBtn2":
                    if (BagData.currentPage == 2){
                        return;
                    };
                    resetPageBtn(true, 2);
                    showItems(BagData.AllItems[BagData.SelectIndex]);
                    break;
            };
        }
        private function doGuide_updateBag():void{
            if (NewGuideData.newerHelpIsOpen){
                facade.sendNotification(Guide_BagCommand.NAME, {state:0});
            };
        }
        public function addAllListenser():void{
            bag.btnStall.addEventListener(MouseEvent.CLICK, btnClickHandler);
            bag.btnSplit.addEventListener(MouseEvent.CLICK, btnClickHandler);
            bag.btnDrop.addEventListener(MouseEvent.CLICK, btnClickHandler);
            bag.btnDeal.addEventListener(MouseEvent.CLICK, btnClickHandler);
            if (bag.yaodianIcon){
                bag.yaodianIcon.addEventListener(MouseEvent.CLICK, onClickHandler);
                bag.cangkuIcon.addEventListener(MouseEvent.CLICK, onClickHandler);
                bag.gonghuiIcon.addEventListener(MouseEvent.CLICK, onClickHandler);
                bag.zhiyeIcon.addEventListener(MouseEvent.CLICK, onClickHandler);
            };
            bag.content.treasureBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.pageBtn1.addEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.pageBtn2.addEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.pageBtn1.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
            bag.content.pageBtn2.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
            bag.content.extendBtn1.addEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.extendBtn2.addEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.extendBtn3.addEventListener(MouseEvent.CLICK, onClickHandler);
            bag.content.extendBtn4.addEventListener(MouseEvent.CLICK, onClickHandler);
        }
        private function resetPageBtn(_arg1:Boolean, _arg2:int=1):void{
            BagData.currentPage = _arg2;
            var _local3 = 1;
            while (_local3 <= BagData.MAX_PAGE) {
                if (BagData.currentPage == _local3){
                    (bag.content[("pageBtn" + _local3)] as MovieClip).gotoAndStop(2);
                } else {
                    (bag.content[("pageBtn" + _local3)] as MovieClip).gotoAndStop(1);
                };
                (bag.content[("pageBtn" + _local3)] as MovieClip).visible = _arg1;
                bag.content[("pageTxt" + _local3)].visible = _arg1;
                _local3++;
            };
        }
        private function bagItemUnLock(_arg1:int):void{
            var _local2:int;
            var _local3:int;
            while (_local2 < BagData.AllItems.length) {
                if (_local2 == BagData.SelectIndex){
                    _local3 = 0;
                    while (_local3 < BagData.GridUnitList[BagData.SelectIndex].length) {
                        if (BagData.GridUnitList[BagData.SelectIndex][_local3].Item){
                            if (_arg1 == BagData.GridUnitList[BagData.SelectIndex][_local3].Item.Id){
                                BagData.GridUnitList[BagData.SelectIndex][_local3].Item.IsLock = false;
                            };
                        };
                        _local3++;
                    };
                };
                _local3 = 0;
                while (_local3 < BagData.AllItems[_local2].length) {
                    if (BagData.AllItems[_local2][_local3] == null){
                        BagData.AllLocks[_local2][_local3] = false;
                    } else {
                        if (_arg1 == BagData.AllItems[_local2][_local3].ItemGUID){
                            BagData.AllLocks[_local2][_local3] = false;
                        };
                    };
                    _local3++;
                };
                _local2++;
            };
        }

    }
}//package GameUI.Modules.Bag.Mediator 
