//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.NewInfoTip.UI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.NewInfoTip.Command.*;

    public class GetRewardMediator extends Mediator {

        public static const NAME:String = "GetRewardMediator";

        private var mountBtn:MovieClip;
        private var loginRewardBtn:MovieClip;
        private var mountPanel:GetMountPanel;
        private var ringBtn:MovieClip;
        public var equipPanel:GetEquipToUsePanel;
        private var giftRewardBtn:MovieClip;

        public function GetRewardMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.ENTERMAPCOMPLETE, GetRewardEvent.UPDATE_REWARD_RECORD, GetRewardEvent.UPDATE_REWARDRECORD, GetRewardEvent.SHOW_GETMOUNTCHEST_BTN, GetRewardEvent.HIDE_GETMOUNTCHEST_BTN, GetRewardEvent.SHOW_GETMOUNTCHEST_PANEL, GetRewardEvent.HIDE_GETMOUNTCHEST_PANEL, GetRewardEvent.SHOW_GETEQUIPUSE_PANEL, GetRewardEvent.HIDE_GETEQUIPUSE_PANEL, GetRewardEvent.HIDE_LOGINREWARD_BTN, GetRewardEvent.SHOW_GIFREWARDBTN, GetRewardEvent.HIDE_GIFREWARDBTN, GetRewardEvent.SHOW_BTN, GetRewardEvent.HIDE_BTN, EventList.RESIZE_STAGE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            var _local3:uint;
            var _local4:int;
            var _local5:DataProxy;
            switch (_arg1.getName()){
                case EventList.ENTERMAPCOMPLETE:
                    sendNotification(GetRewardEvent.UPDATE_REWARD_RECORD);
                    sendNotification(GetRewardEvent.UPDATE_REWARDRECORD);
                    facade.registerCommand(AutoUseEquipCommand.NAME, AutoUseEquipCommand);
                    break;
                case GetRewardEvent.UPDATE_REWARD_RECORD:
                    if (_arg1.getBody() != null){
                        _local3 = uint(_arg1.getBody());
                        _local4 = 0;
                        _local4 = 0;
                        while (_local4 < 32) {
                            if (((_local3 >> _local4) & 1) != ((GameCommonData.Player.Role.PermanentRecord >> _local4) & 1)){
                                break;
                            };
                            _local4++;
                        };
                        GameCommonData.Player.Role.PermanentRecord = _local3;
                        if ((((_local4 == 0)) || ((_local4 == 1)))){
                            GetRewardConstData.CurrentUpdateType_mount = GetRewardConstData.GetRewardTypeArr_mount[_local4];
                        };
                    } else {
                        GetRewardConstData.CurrentUpdateType_mount = -1;
                    };
                    if (((GetRewardConstData.IsCanShowGetMountBtn) && (!(GetRewardConstData.IsGetMount)))){
                        sendNotification(GetRewardEvent.SHOW_GETMOUNTCHEST_BTN);
                    };
                    switch (GetRewardConstData.CurrentUpdateType_mount){
                        case GetRewardType.LEVEL_ITEM_HORSE:
                            if (GetRewardConstData.IsCanGetMount){
                                if (((mountBtn) && (mountBtn.parent))){
                                    mountBtn.effect.visible = true;
                                    mountBtn.effect.play();
                                };
                            } else {
                                if (GetRewardConstData.IsGetMount){
                                    if (mountBtn){
                                        sendNotification(GetRewardEvent.HIDE_GETMOUNTCHEST_BTN);
                                    };
                                    if (mountPanel){
                                        sendNotification(GetRewardEvent.HIDE_GETMOUNTCHEST_PANEL);
                                    };
                                    _local5 = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                                    if (!((_local5.IsCollecting) || (_local5.IsGrabPeting))){
                                    } else {
                                        MessageTip.show(LanguageMgr.GetTranslation("采集或抓宠时不能乘骑"));
                                    };
                                };
                            };
                            break;
                    };
                    break;
                case GetRewardEvent.UPDATE_REWARDRECORD:
                    if (_arg1.getBody() != null){
                        _local3 = uint(_arg1.getBody());
                        _local4 = 0;
                        _local4 = 0;
                        while (_local4 < 32) {
                            if (((_local3 >> _local4) & 1) != ((GameCommonData.RewardRecord >> _local4) & 1)){
                                break;
                            };
                            _local4++;
                        };
                        GameCommonData.RewardRecord = _local3;
                        GetRewardConstData.CurrentUpdateRewardType = GetRewardConstData.GetRewardTypeArr[int((_local4 / 2))];
                    } else {
                        GetRewardConstData.CurrentUpdateRewardType = -1;
                    };
                    if (((GetRewardConstData.IsCanShowGetMountBtn) && (!(GetRewardConstData.IsGetMount)))){
                        sendNotification(GetRewardEvent.SHOW_GETMOUNTCHEST_BTN);
                    };
                    if (((GetRewardConstData.IsCanShowGetRingBtn) && (!(GetRewardConstData.IsGeted(GetRewardType.TYPE_RING))))){
                        sendNotification(GetRewardEvent.SHOW_BTN, GetRewardType.TYPE_RING);
                    };
                    switch (GetRewardConstData.CurrentUpdateRewardType){
                        case GetRewardType.TYPE_RING:
                            if (GetRewardConstData.IsGeted(GetRewardType.TYPE_RING)){
                                if (ringBtn){
                                    sendNotification(GetRewardEvent.HIDE_BTN, GetRewardType.TYPE_RING);
                                };
                                getAndUseItem(20600008);
                            } else {
                                if (GetRewardConstData.IsCanGet(GetRewardType.TYPE_RING)){
                                    if (((ringBtn) && (ringBtn.parent))){
                                        ringBtn.effect.visible = true;
                                        ringBtn.effect.play();
                                    };
                                };
                            };
                            break;
                    };
                    if ((((GameCommonData.Player.Role.Level >= 21)) && (((GameCommonData.NewAndCharge & 16) == 0)))){
                        facade.sendNotification(GetRewardEvent.SHOW_GIFREWARDBTN);
                    } else {
                        facade.sendNotification(GetRewardEvent.HIDE_GIFREWARDBTN);
                    };
                    break;
                case GetRewardEvent.SHOW_GETMOUNTCHEST_BTN:
                    if (mountBtn == null){
                        mountBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GetMountAsset");
                        mountBtn.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 130);
                        mountBtn.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                        mountBtn.mouseChildren = false;
                        mountBtn.buttonMode = true;
                        mountBtn.effect.stop();
                        mountBtn.effect.visible = false;
                        mountBtn.name = "GetRewardTips_Mount";
                        mountBtn.addEventListener(MouseEvent.CLICK, __clickBtnHandler);
                        GameCommonData.GameInstance.GameUI.addChild(mountBtn);
                    };
                    if (GetRewardConstData.IsCanGetMount){
                        if (((mountBtn) && (mountBtn.parent))){
                            mountBtn.effect.visible = true;
                            mountBtn.effect.play();
                        };
                    };
                    break;
                case GetRewardEvent.HIDE_GETMOUNTCHEST_BTN:
                    if (((mountBtn) && (mountBtn.parent))){
                        mountBtn.parent.removeChild(mountBtn);
                        mountBtn.removeEventListener(MouseEvent.CLICK, __clickBtnHandler);
                    };
                    break;
                case GetRewardEvent.SHOW_GETMOUNTCHEST_PANEL:
                    if (((mountPanel) && (mountPanel.parent))){
                        mountPanel.parent.removeChild(mountPanel);
                    };
                    mountPanel = new GetMountPanel();
                    mountPanel.x = ((GameCommonData.GameInstance.ScreenWidth - mountPanel.frameWidth) / 2);
                    mountPanel.y = ((GameCommonData.GameInstance.ScreenHeight - mountPanel.frameHeight) / 2);
                    GameCommonData.GameInstance.GameUI.addChild(mountPanel);
                    break;
                case GetRewardEvent.HIDE_GETMOUNTCHEST_PANEL:
                    if (((mountPanel) && (mountPanel.parent))){
                        mountPanel.parent.removeChild(mountPanel);
                    };
                    break;
                case GetRewardEvent.SHOW_GETEQUIPUSE_PANEL:
                    equipPanel = new GetEquipToUsePanel((_arg1.getBody() as InventoryItemInfo));
                    equipPanel.x = ((GameCommonData.GameInstance.ScreenWidth - equipPanel.frameWidth) / 2);
                    equipPanel.y = ((GameCommonData.GameInstance.ScreenHeight - equipPanel.frameHeight) / 2);
                    equipPanel.show();
                    break;
                case GetRewardEvent.HIDE_GETEQUIPUSE_PANEL:
                    break;
                case GetRewardEvent.HIDE_LOGINREWARD_BTN:
                    if (((loginRewardBtn) && (loginRewardBtn))){
                        loginRewardBtn.parent.removeChild(loginRewardBtn);
                    };
                    loginRewardBtn = null;
                    break;
                case GetRewardEvent.SHOW_BTN:
                    _local2 = (_arg1.getBody() as uint);
                    switch (_local2){
                        case GetRewardType.TYPE_RING:
                            if (ringBtn == null){
                                ringBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GetMountAsset");
                                ringBtn.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 130);
                                ringBtn.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                                ringBtn.mouseChildren = false;
                                ringBtn.buttonMode = true;
                                ringBtn.effect.stop();
                                ringBtn.effect.visible = false;
                                ringBtn.name = "GetRewardTips_Ring";
                                ringBtn.addEventListener(MouseEvent.CLICK, __clickBtnHandler);
                                GameCommonData.GameInstance.GameUI.addChild(ringBtn);
                                loadBtnIcon(ringBtn, 20600008);
                            };
                            if (GetRewardConstData.IsCanGet(GetRewardType.TYPE_RING)){
                                if (((ringBtn) && (ringBtn.parent))){
                                    ringBtn.effect.visible = true;
                                    ringBtn.effect.play();
                                };
                            };
                            break;
                    };
                    break;
                case GetRewardEvent.HIDE_BTN:
                    _local2 = (_arg1.getBody() as uint);
                    switch (_local2){
                        case GetRewardType.TYPE_RING:
                            if (((ringBtn) && (ringBtn.parent))){
                                ringBtn.parent.removeChild(ringBtn);
                                ringBtn.removeEventListener(MouseEvent.CLICK, __clickBtnHandler);
                            };
                            break;
                    };
                    break;
                case GetRewardEvent.SHOW_GIFREWARDBTN:
                    if (giftRewardBtn == null){
                        ResourcesFactory.getInstance().getResource((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Effect/GiftRewardBtn.swf"), onGiftRewardBtnComplete);
                    };
                    break;
                case GetRewardEvent.HIDE_GIFREWARDBTN:
                    if (((giftRewardBtn) && (giftRewardBtn.parent))){
                        giftRewardBtn.parent.removeChild(giftRewardBtn);
                        giftRewardBtn.removeEventListener(MouseEvent.CLICK, __giftRewardClick);
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    if (mountBtn){
                        mountBtn.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 130);
                        mountBtn.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                    };
                    if (loginRewardBtn){
                        loginRewardBtn.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 170);
                        loginRewardBtn.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                    };
                    if (ringBtn){
                        ringBtn.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 130);
                        ringBtn.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                    };
                    if (giftRewardBtn){
                        giftRewardBtn.x = int(((GameCommonData.GameInstance.ScreenWidth / 2) + 120));
                        giftRewardBtn.y = 20;
                    };
                    break;
            };
        }
        private function __clickBtnHandler(_arg1:MouseEvent):void{
            var _local2:GetRewardPreviewPanel;
            switch (_arg1.currentTarget){
                case mountBtn:
                    sendNotification(GetRewardEvent.SHOW_GETMOUNTCHEST_PANEL);
                    break;
                case ringBtn:
                    _local2 = new GetRewardPreviewPanel(UIConstData.ItemDic[20600008]);
                    _local2.show();
                    _local2.centerFrame();
                    break;
            };
        }
        private function __giftRewardClick(_arg1:MouseEvent):void{
            AddFavoriteRewardFrame.getInstance().show();
        }
        private function __loginRewardBtnClickHandler(_arg1:MouseEvent):void{
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            if (!_local2.ActivityViewIsOpen){
                facade.sendNotification(EventList.OPEN_ACTIVITY_WELFARE, 1);
            };
        }
        private function onGiftRewardBtnComplete():void{
            if (giftRewardBtn == null){
                giftRewardBtn = ResourcesFactory.getInstance().getswfResourceByUrl((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Effect/GiftRewardBtn.swf"));
                giftRewardBtn.x = int(((GameCommonData.GameInstance.ScreenWidth / 2) + 120));
                giftRewardBtn.y = 20;
                giftRewardBtn.GiftRewardBtn.mcFlash.mouseEnabled = false;
                giftRewardBtn.GiftRewardBtn.mcFlash.mouseChildren = false;
                GameCommonData.GameInstance.GameUI.addChild(giftRewardBtn);
                giftRewardBtn.addEventListener(MouseEvent.CLICK, __giftRewardClick);
            };
        }
        private function getAndUseItem(_arg1:int):void{
            var _local2:InventoryItemInfo = BagData.getItemByType(_arg1);
            if (_local2){
                BagInfoSend.ItemSwap(_local2.Place, -1);
            };
        }
        private function loadBtnIcon(_arg1:MovieClip, _arg2:int):void{
            var icon:* = null;
            var target:* = _arg1;
            var tempId:* = _arg2;
            icon = new Bitmap();
            var bmd:* = new BitmapData(target.width, target.height, true, 0);
            icon.bitmapData = bmd;
            target.addChildAt(icon, 1);
//            with ({}) {
//                {}.onLoadSmallBtnPicComplete = function ():void{
//                    var _local1:Bitmap = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/bagIcon/") + tempId) + ".png"));
//                    icon.bitmapData = _local1.bitmapData;
//                };
//            };//geoffyan
            var onLoadSmallBtnPicComplete:* = function ():void{
                var _local1:Bitmap = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/bagIcon/") + tempId) + ".png"));
                icon.bitmapData = _local1.bitmapData;
            };
            ResourcesFactory.getInstance().getResource((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/bagIcon/") + tempId) + ".png"), onLoadSmallBtnPicComplete);
        }

    }
}//package GameUI.Modules.NewInfoTip.Mediator 
