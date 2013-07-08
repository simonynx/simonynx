//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Unity.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Unity.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Unity.Proxy.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class GuildDonateMediator extends Mediator {

        public static const NAME:String = "GuildDonateMediator";

        private var dataProxy:DataProxy;
        private var guildDonateGridManager:GuildDonateGridManager;
        private var gridSprite:MovieClip;
        private var offerType:uint;

        public function GuildDonateMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, UnityEvent.SHOW_GUILDDONATEPANEL, UnityEvent.HIDE_GUILDDONATEPANEL, UnityEvent.BAGTOGUILDDONATE, UnityEvent.OFFERITEM_COMPLETE, NewGuideEvent.NEWPLAYER_GUILD_POINTDONATEBTN]);
        }
        private function updateSaleData():void{
            var _local1:int = (UnityConstData.goodSaleList.length - 1);
            guildDonateGridManager.addItem(_local1);
        }
        private function addEvents():void{
            view.allDonateBtn.addEventListener(MouseEvent.CLICK, __allAddInHandler);
            view.okBtn.addEventListener(MouseEvent.CLICK, comfrimHandler);
        }
        private function resetItemLock():void{
            var _local1:int;
            while (_local1 < UnityConstData.goodSaleList.length) {
                sendNotification(EventList.BAGITEMUNLOCK, UnityConstData.goodSaleList[_local1].id);
                _local1++;
            };
        }
        private function updateContribute():void{
            switch (offerType){
                case OfferType.OFFER_GUILD:
                    view.offerTypeTF.text = (LanguageMgr.GetTranslation("公会声望") + "：");
                    view.titleText = LanguageMgr.GetTranslation("公会声望");
                    view.prestigeTF.text = GameCommonData.Player.Role.GuildBuildValue.toString();
                    break;
                case OfferType.OFFER_WARRIOR:
                    view.offerTypeTF.text = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业1")) + ")：");
                    view.titleText = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业1")) + ")");
                    view.prestigeTF.text = GameCommonData.Player.Role.OfferValue[0].toString();
                    break;
                case OfferType.OFFER_MAGE:
                    view.offerTypeTF.text = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业2")) + ")：");
                    view.titleText = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业2")) + ")");
                    view.prestigeTF.text = GameCommonData.Player.Role.OfferValue[1].toString();
                    break;
                case OfferType.OFFER_PRIEST:
                    view.offerTypeTF.text = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业3")) + ")：");
                    view.titleText = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业3")) + ")");
                    view.prestigeTF.text = GameCommonData.Player.Role.OfferValue[2].toString();
                    break;
                case OfferType.OFFER_ROGUE:
                    view.offerTypeTF.text = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业4")) + ")：");
                    view.titleText = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业4")) + ")");
                    view.prestigeTF.text = GameCommonData.Player.Role.OfferValue[3].toString();
                    break;
                case OfferType.OFFER_HUNTER:
                    view.offerTypeTF.text = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业5")) + ")：");
                    view.titleText = (((LanguageMgr.GetTranslation("职业声望") + "(") + LanguageMgr.GetTranslation("职业5")) + ")");
                    view.prestigeTF.text = GameCommonData.Player.Role.OfferValue[4].toString();
                    break;
            };
        }
        private function showContribute():void{
            updateContribute();
            GameCommonData.GameInstance.GameUI.addChild(view);
            UnityConstData.contributeIsOpen = true;
        }
        private function closeHandler():void{
            sendNotification(UnityEvent.HIDE_GUILDDONATEPANEL);
        }
        override public function handleNotification(_arg1:INotification):void{
            var itemInfo:* = null;
            var jt:* = null;
            var notification:* = _arg1;
            switch (notification.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    setViewComponent(new GuildDonateWindow());
                    view.closeCallBack = closeHandler;
                    break;
                case UnityEvent.SHOW_GUILDDONATEPANEL:
                    if (dataProxy.DepotIsOpen){
                        sendNotification(EventList.CLOSEDEPOTVIEW);
                    };
                    if (dataProxy.NPCShopIsOpen){
                        sendNotification(EventList.CLOSENPCSHOPVIEW);
                    };
                    offerType = uint(notification.getBody());
                    UnityConstData.contributeIsOpen = true;
                    initView();
                    showContribute();
                    addEvents();
                    view.x = ((facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.x - view.width);
                    view.y = (facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.y;
                    GameCommonData.GameInstance.GameUI.addChild(view);
                    sendNotification(EventList.SHOWBAG, 1);
                    resetItemLock();
                    view.centerFrame();
                    EffectLib.checkTranslationByShow(view, GameCommonData.GameInstance.stage);
                    break;
                case UnityEvent.HIDE_GUILDDONATEPANEL:
                    UnityConstData.contributeIsOpen = false;
                    view.okBtn.removeEventListener(MouseEvent.CLICK, comfrimHandler);
                    resetItemLock();
                    guildDonateGridManager.removeAllItem();
                    UnityConstData.goodSaleList = [];
                    UnityConstData.GridUnitList = [];
                    if (GameCommonData.GameInstance.GameUI.contains(view)){
                        EffectLib.checkTranslationByClose(view, GameCommonData.GameInstance.stage);
                        GameCommonData.GameInstance.GameUI.removeChild(view);
                    };
                    guildDonateGridManager.Gc();
                    break;
                case UnityEvent.BAGTOGUILDDONATE:
                    itemInfo = (notification.getBody() as InventoryItemInfo);
                    if (UnityConstData.goodSaleList.length >= 18){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("公会提示8"),
                            color:0xFFFF00
                        });
                        sendNotification(EventList.BAGITEMUNLOCK, itemInfo.ItemGUID);
                    } else {
                        if (!ItemConst.IsOffer(itemInfo)){
                            facade.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("公会提示9"),
                                color:0xFFFF00
                            });
                            sendNotification(EventList.BAGITEMUNLOCK, itemInfo.ItemGUID);
                        } else {
                            UnityConstData.goodSaleList.push(itemInfo);
                            updateSaleData();
                        };
                    };
                    break;
                case UnityEvent.OFFERITEM_COMPLETE:
                    resetItemLock();
                    guildDonateGridManager.removeAllItem();
                    UnityConstData.goodSaleList = [];
                    updateContribute();
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_POINTDONATEBTN:
                    jt = JianTouMc.getInstance().show(view.allDonateBtn, "", 3);
                    jt.setJTToTargetPostion(view);
                    jt.autoClickClean = true;
                    jt.clickCallBack = function ():void{
                        __allAddInHandler(null);
                        facade.sendNotification(UnityEvent.HIDE_GUILDDONATEPANEL);
                        facade.sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[TaskCommonData.LoopBaseTaskId]);
                    };
                    break;
            };
        }
        private function __allAddInHandler(_arg1:MouseEvent):void{
            var _local3:InventoryItemInfo;
            var _local5:int;
            if ((((offerType == OfferType.OFFER_GUILD)) && ((GameCommonData.Player.Role.unityId <= 0)))){
                MessageTip.show(LanguageMgr.GetTranslation("公会提示10"));
                return;
            };
            var _local2:Array = [];
            var _local4:int;
            while (_local4 < BagData.AllItems.length) {
                _local5 = 0;
                while (_local5 < BagData.AllItems[_local4].length) {
                    _local3 = (BagData.AllItems[_local4][_local5] as InventoryItemInfo);
                    if (((((_local3) && ((_local3.MainClass == ItemConst.ITEM_CLASS_MATERIAL)))) && ((_local3.SubClass == ItemConst.ITEM_SUBCLASS_MATERIAL_OFFER)))){
                        _local2.push(_local3);
                    };
                    _local5++;
                };
                _local4++;
            };
            if (_local2.length == 0){
                MessageTip.show(LanguageMgr.GetTranslation("公会提示11"));
                return;
            };
            GuildSend.RichOffer(offerType, []);
        }
        private function initView():void{
            gridSprite = new MovieClip();
            view.addChild(gridSprite);
            gridSprite.x = 19;
            gridSprite.y = 228;
            initGrid();
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < 18) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = ((_local1.width + 1) * (_local3 % 6));
                _local1.y = ((_local1.height + 1) * int((_local3 / 6)));
                _local1.name = ("donateprop_" + _local3.toString());
                gridSprite.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = gridSprite;
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                UnityConstData.GridUnitList.push(_local2);
                _local3++;
            };
            guildDonateGridManager = new GuildDonateGridManager(UnityConstData.GridUnitList, gridSprite);
            facade.registerProxy(guildDonateGridManager);
        }
        private function comfrimHandler(_arg1:MouseEvent):void{
            var _local4:int;
            if ((((offerType == OfferType.OFFER_GUILD)) && ((GameCommonData.Player.Role.unityId <= 0)))){
                MessageTip.show(LanguageMgr.GetTranslation("公会提示10"));
                return;
            };
            if (UnityConstData.goodSaleList.length <= 0){
                MessageTip.show("");
                return;
            };
            var _local2:Array = [];
            var _local3:Object = UnityConstData.goodSaleList;
            while (_local4 < UnityConstData.goodSaleList.length) {
                _local2.push(UnityConstData.goodSaleList[_local4].ItemGUID);
                _local4++;
            };
            GuildSend.RichOffer(offerType, _local2);
        }
        private function get view():GuildDonateWindow{
            return ((getViewComponent() as GuildDonateWindow));
        }

    }
}//package GameUI.Modules.Unity.Mediator 
