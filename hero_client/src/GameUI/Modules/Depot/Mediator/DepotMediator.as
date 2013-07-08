//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Depot.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Depot.Proxy.*;
    import GameUI.Modules.Depot.Data.*;
    import GameUI.*;
    //import GameUI.Modules.Depot.UI.*;

    public class DepotMediator extends Mediator {

        private static const MAXPAGE:uint = 2;
        private static const START_POS:Point = new Point(0, 17);
        public static const NAME:String = "DepotMediator";

        private static var requestFlag:Boolean = false;

        private var yellowFilter:GlowFilter = null;
        private var iScrollPane_0:UIScrollPane = null;
        private var iScrollPane_1:UIScrollPane = null;
        private var listView_0:ListComponent = null;
        private var listView_1:ListComponent = null;
        private var dealBtn:HLabelButton = null;
        private var selectType:int = 0;
        private var dataProxy:DataProxy = null;
        private var gridSprite:MovieClip = null;
        private var itemGridManager:ItemGridManager = null;

        public function DepotMediator(){
            super(NAME);
        }
        private function dealDepot():void{
            initItemShow();
        }
        public function showMoneyPanel(_arg1:int):void{
        }
        private function doGuild_updatedepot():void{
        }
        private function deal(_arg1:MouseEvent):void{
            BagInfoSend.ItemDeal(4);
        }
        private function depotCloseHandler(_arg1:Event):void{
            gcAll();
        }
        private function extendGrid(_arg1:uint):void{
            var _local3:uint;
            var _local2:uint = (DepotConstData.gridCount - 6);
            if (_local2 == 42){
                return;
            };
            _local3 = _arg1;
            DepotConstData.gridCount = _arg1;
            if (depot == null){
                return;
            };
            if (_arg1 == 36){
                depot.content.txt_extend.visible = false;
            } else {
                if (_arg1 == 42){
                    depot.content.txt_extendDepot.visible = false;
                };
            };
            var _local4:uint = _local2;
            while (_local4 < _local3) {
                DepotConstData.GridUnitList[_local4].Grid.visible = true;
                DepotConstData.GridUnitList[_local4].HasBag = true;
                _local4++;
            };
            depot.content.txt_hasUseCount.text = ((DepotConstData.getHasUseNum() + "/") + DepotConstData.gridCount);
        }
        private function unLockBtnInOut():void{
        }
        private function ComfrimExtend():void{
            BagInfoSend.ExtendGrid(1);
        }
        private function gcMoneyPanel():void{
        }
        private function moneyCloseHandler(_arg1:Event):void{
            gcMoneyPanel();
        }
        private function setPos():void{
            if (depot){
                depot.x = ((facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.x - depot.width);
                depot.y = (facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.y;
            };
        }
        private function Cancel():void{
        }
        private function btnExtendHandler(_arg1:TextEvent):void{
            if ((((BagData.getCountsByTemplateId(10500002, false) > 0)) || ((GameCommonData.Player.Role.Money >= MarketConstData.getShopItemByTemplateID(10500002).APriceArr[2])))){
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:ComfrimExtend,
                    cancel:Cancel,
                    info:LanguageMgr.GetTranslation("提示用金叶子扩充背包句")
                });
            } else {
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:Cancel,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("提示买扩充包")
                });
            };
        }
        private function initView():void{
            var _local1:Bitmap;
            setViewComponent(new DepotView());
            depot.closeCallBack = gcAll;
            GameCommonData.GameInstance.GameUI.addChild(depot);
            initGrid();
            itemGridManager.showItems(DepotConstData.goodList);
            depot.content.txt_hasUseCount.text = ((DepotConstData.getHasUseNum() + "/") + DepotConstData.gridCount);
            depot.content.txt_extendDepot.htmlText = (("<a href=\"event:link\"><b><u>" + LanguageMgr.GetTranslation("仓库扩充")) + "</u></b></a>");
            depot.content.txt_extendDepot.addEventListener(TextEvent.LINK, btnExtendHandler);
            if (dealBtn == null){
                dealBtn = new HLabelButton();
                dealBtn.x = 162;
                dealBtn.y = 292;
                dealBtn.label = ("  " + LanguageMgr.GetTranslation("空格整理"));
                dealBtn.width = 52;
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("DealIcon");
                _local1.y = 2;
                dealBtn.addIcon(_local1);
            };
            depot.content.addChild(dealBtn);
            dealBtn.addEventListener(MouseEvent.CLICK, deal);
        }
        private function mouseOutHandler(_arg1:MouseEvent):void{
            (_arg1.target as MovieClip).filters = null;
        }
        private function gcAll():void{
            depot.content.removeChild(dealBtn);
            dealBtn.removeEventListener(MouseEvent.CLICK, deal);
            depot.content.txt_extendDepot.removeEventListener(TextEvent.LINK, btnExtendHandler);
            itemGridManager.removeAllItem();
            GameCommonData.GameInstance.GameUI.removeChild(depot);
            EffectLib.checkTranslationByClose(depot, GameCommonData.GameInstance.stage);
            DepotConstData.SelectIndex = 0;
            DepotConstData.curDepotIndex = 0;
            DepotConstData.SelectedItem = null;
            DepotConstData.TmpIndex = 0;
            DepotConstData.GridUnitList = new Array();
            dataProxy.DepotIsOpen = false;
            dataProxy = null;
            yellowFilter = null;
            viewComponent = null;
        }
        private function initItemShow():void{
            itemGridManager.removeAllItem();
            itemGridManager.showItems(DepotConstData.goodList);
        }
        override public function listNotificationInterests():Array{
            return ([DepotEvent.UPDATEDEPOT, EventList.SHOWDEPOTVIEW, EventList.CLOSEDEPOTVIEW, EventList.CLOSE_NPC_ALL_PANEL, DepotEvent.BAGTODEPOT, DepotEvent.DEPOTTOBAG, DepotEvent.ADDITEM, DepotEvent.DELITEM, EventList.RESIZE_STAGE, DepotEvent.DEALDEPOT, DepotEvent.EXTENDDEPOT]);
        }
        private function mouseOverHandler(_arg1:MouseEvent):void{
            (_arg1.target as MovieClip).filters = [yellowFilter];
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < 42) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = ((_local1.width * (_local3 % 6)) + 2);
                _local1.y = (((_local1.height + 2) * int((_local3 / 6))) + 16);
                _local1.name = ("depot_" + _local3);
                if (_local3 >= DepotConstData.gridCount){
                    _local1.visible = false;
                };
                depot.content.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = (depot.content as MovieClip);
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                DepotConstData.GridUnitList.push(_local2);
                _local3++;
            };
            itemGridManager = new ItemGridManager(DepotConstData.GridUnitList, (depot.content as MovieClip));
            facade.registerProxy(itemGridManager);
            itemGridManager.Initialize();
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:int;
            var _local4:Object;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            switch (_arg1.getName()){
                case EventList.SHOWDEPOTVIEW:
                    if (!requestFlag){
                        requestFlag = true;
                        BagInfoSend.RequestBanks();
                        return;
                    };
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    if (dataProxy.DepotIsOpen){
                        setPos();
                        facade.sendNotification(EventList.SHOWBAG, 0);
                        dataProxy.DepotIsOpen = true;
                        depot.centerFrame();
                        EffectLib.checkTranslationByShow(depot, GameCommonData.GameInstance.stage);
                        return;
                    };
                    if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("死亡状态不能打开仓库"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (dataProxy.TradeIsOpen){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易中不能打开仓库"),
                            color:0xFFFF00
                        });
                        dataProxy = null;
                        return;
                    };
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摆摊中不能打开仓库"),
                            color:0xFFFF00
                        });
                        dataProxy = null;
                        return;
                    };
                    if (dataProxy.NPCShopIsOpen){
                        sendNotification(EventList.CLOSENPCSHOPVIEW);
                    };
                    if (UnityConstData.contributeIsOpen){
                        sendNotification(UnityEvent.HIDE_GUILDDONATEPANEL);
                    };
                    yellowFilter = UIUtils.getGlowFilter(0xFFFF00, 1, 3, 3, 6);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.DEPOT
                    });
                    initView();
                    setPos();
                    dataProxy.DepotIsOpen = true;
                    facade.sendNotification(EventList.SHOWBAG, 0);
                    setPos();
                    depot.centerFrame();
                    depot.name = "depot";
                    EffectLib.checkTranslationByShow(depot, GameCommonData.GameInstance.stage);
                    break;
                case EventList.CLOSEDEPOTVIEW:
                    if (dataProxy.DepotIsOpen){
                        gcAll();
                    };
                    break;
                case EventList.CLOSE_NPC_ALL_PANEL:
                    if (((dataProxy) && (dataProxy.DepotIsOpen))){
                        gcAll();
                    };
                    break;
                case DepotEvent.BAGTODEPOT:
                    break;
                case DepotEvent.UPDATEDEPOT:
                    initItemShow();
                    depot.content.txt_hasUseCount.text = ((DepotConstData.getHasUseNum() + "/") + DepotConstData.gridCount);
                    doGuild_updatedepot();
                    break;
                case DepotEvent.DEPOTTOBAG:
                    _local4 = _arg1.getBody();
                    _local5 = (_local4.index + 1);
                    break;
                case DepotEvent.ADDITEM:
                    if (((dataProxy) && (dataProxy.DepotIsOpen))){
                        _local6 = int(_arg1.getBody());
                        itemGridManager.addItem(_local6);
                        depot.content.txt_hasUseCount.text = ((DepotConstData.getHasUseNum() + "/") + DepotConstData.gridCount);
                    };
                    break;
                case DepotEvent.DELITEM:
                    if (dataProxy.DepotIsOpen){
                        _local7 = int(_arg1.getBody());
                        itemGridManager.removeItem(_local7);
                        depot.content.txt_hasUseCount.text = ((DepotConstData.getHasUseNum() + "/") + DepotConstData.gridCount);
                    };
                    break;
                case DepotEvent.EXTENDDEPOT:
                    extendGrid(uint(_arg1.getBody()));
                    break;
                case EventList.RESIZE_STAGE:
                    setPos();
                    break;
                case DepotEvent.DEALDEPOT:
                    dealDepot();
                    break;
            };
        }
        private function get depot():DepotView{
            return ((viewComponent as DepotView));
        }

    }
}//package GameUI.Modules.Depot.Mediator 
