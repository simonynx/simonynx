//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.MainScene.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import Manager.*;
    import GameUI.Modules.NewGuide.UI.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import GameUI.View.items.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PetRace.Data.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Transcript.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.SetView.Data.*;
    import GameUI.Modules.Pet.Mediator.*;
    import GameUI.Modules.Friend.model.proxy.*;
    import com.greensock.easing.*;
    import GameUI.Modules.MainScene.Command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.PlayerInfo.Mediator.*;
    import GameUI.*;

    public class MainSceneMediator extends Mediator {

        public static const NAME:String = "MainSceneMediator";

        private var shopBtn:HBaseButton;
        protected var ColorArr:Array;
        private var quickSkillManager:QuickSkillManager;
        private var hammerBtn:HBaseButton;
        private var fullBm:Bitmap;
        private var quickBarFlagRight:Boolean = false;
        private var redFrame:MovieClip = null;
        private var isInit:Boolean = true;
        private var dataProxy:DataProxy = null;
        private var quickBarFlag:Boolean = false;

        public function MainSceneMediator(){
            ColorArr = [0xFF0000, 0xE42200, 0xCE3E00, 0xB45F00, 0xA37400, 0x9F7A00, 0x998100, 0x8E8F00, 0x809F00, 0x77AB00, 0x67BF00, 0x60C800, 0x4FDD00, 0x45E900, 0x33FF00];
            super(NAME);
        }
        private function rightBtnHandler(_arg1:MouseEvent):void{
        }
        private function setPageBtn():void{
            var _local1:uint = (GameCommonData.dialogStatus & 2);
            quickBarFlag = Boolean(_local1);
            mainScene.mcQuickBar1.visible = quickBarFlag;
            switch (quickBarFlag){
                case true:
                    mainScene.quickbarPageTF.text = "2";
                    break;
                case false:
                    mainScene.quickbarPageTF.text = "1";
                    break;
            };
        }
        private function showBtnFlash(_arg1:uint):void{
            if (_arg1 > 13){
                return;
            };
            mainScene[("btn_" + _arg1)].mcFlash.play();
            mainScene[("btn_" + _arg1)].mcFlash.visible = true;
        }
        private function onShopHandler(_arg1:MouseEvent):void{
            if (dataProxy.MarketIsOpen){
                sendNotification(EventList.CLOSEMARKETVIEW);
                sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
            } else {
                sendNotification(EventList.SHOWMARKETVIEW);
            };
        }
        private function showTeamFlash():void{
            mainScene["btn_7"].mcFlash.play();
            mainScene["btn_7"].mcFlash.visible = true;
        }
        protected function updateExp():void{
            var _local9:Point;
            var _local1:uint = UIConstData.ExpDic[GameCommonData.Player.Role.Level];
            var _local2:uint = GameCommonData.Player.Role.Exp;
            if (_local2 > _local1){
                _local2 = _local1;
            };
            var _local3:Number = this.viewComponent.mcExp.width;
            var _local4:Number = ((_local2 / _local1) * this.viewComponent.mcExp.width);
            var _local5:int = this.viewComponent.mcExpMask.width;
            var _local6:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["mcExpMask"] as MovieClip);
            var _local7:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["mcExp"] as MovieClip);
            var _local8:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene") as MovieClip);
            if ((((Math.abs((_local4 - _local5)) > 5)) && (!(isInit)))){
                if (_local4 < _local5){
                    _local9 = _local8.localToGlobal(new Point(_local7.x, (_local7.y - 1)));
                    _local8.localToGlobal(new Point(_local7.x, (_local7.y - 1))).x = _local9.x;
                    showEffectExp(int(_local4), _local9);
                } else {
                    _local9 = _local8.localToGlobal(new Point(_local6.x, _local6.y));
                    _local8.localToGlobal(new Point(_local6.x, _local6.y)).x = (_local9.x + _local6.width);
                    showEffectExp(Math.abs(int((_local5 - _local4))), _local9);
                };
            };
            this.viewComponent.mcExpMask.width = _local4;
        }
        protected function hidePetRaceFlash():void{
            mainScene["btn_9"].mcFlash.stop();
            mainScene["btn_9"].mcFlash.visible = false;
        }
        public function getStrengthBtn():Object{
            return (mainScene["btn_11"]);
        }
        private function onQuickBtn(_arg1:MouseEvent):void{
            var _local2:uint = (_arg1.currentTarget.name as String).split("_")[1];
            useQuickBtn(_local2, _arg1);
        }
        private function setBtnRight():void{
            mainScene["btn_9"].visible = (GameCommonData.Player.Role.Level >= 33);
            mainScene["btn_10"].visible = ((GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_SHILIAN]) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_SHILIAN].IsComplete));
            mainScene["btn_11"].visible = ((GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_STRENGTHEN]) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_STRENGTHEN].IsComplete));
            mainScene["btn_12"].visible = ((GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_TREASURE]) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_TREASURE].IsComplete));
            if ((((BtnManager.CSBBtn == null)) && ((GameCommonData.Player.Role.Level >= 55)))){
                BtnManager.CSBBtn = new HBaseButton(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("CSBPicAsset"));
                GameCommonData.GameInstance.GameUI.addChild(BtnManager.CSBBtn);
                BtnManager.CSBBtn.visible = (GameCommonData.ModuleCloseConfig[3] == 0);
                BtnManager.CSBBtn.addEventListener(MouseEvent.CLICK, function ():void{
                    if (((!(dataProxy.CSBPanelIsOpen)) && (!(GameCommonData.IsInCrossServer)))){
                        facade.sendNotification(EventList.SHOW_CSBPANEL);
                    };
                });
                BtnManager.RankBtnPos();
            };
            updateModuleStatus();
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:* = 0;
            var expTipsMc:* = null;
            var itemId:* = 0;
            var useItem:* = null;
            var toP:* = null;
            var fullIdx:* = 0;
            var bagMc:* = null;
            var _arg1:* = _arg1;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    SysCursor.GetInstance().setMouseType();
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.MAINSCENE
                    });
                    redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
                    redFrame.name = "redFrame";
                    redFrame.mouseChildren = false;
                    redFrame.mouseEnabled = false;
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.registerMediator(new CounterWorkerInfoMediator());
                    facade.registerMediator(new PetInfoMediator());
                    facade.registerMediator(new TeamListInfoMediator());
                    facade.registerMediator(new SelfInfoMediator());
                    facade.registerMediator(new CollectionWorkerInfoMediator());
                    facade.sendNotification(PlayerInfoComList.INIT_PLAYERINFO_UI);
                    facade.registerProxy(new MessageWordProxy());
                    facade.registerCommand(EventList.ONSYNC_BAG_QUICKBAR, OnsyncBagQuickBarCommand);
                    this.viewComponent.mcExp.mask = this.viewComponent.mcExpMask;
                    this.viewComponent.mcExpMask.visible = false;
                    this.viewComponent.mcExpMask.alpha = 0;
                    expTipsMc = new Sprite();
                    expTipsMc.name = "expTipsMc";
                    expTipsMc.x = this.viewComponent.mcExpMask.x;
                    expTipsMc.y = this.viewComponent.mcExpMask.y;
                    expTipsMc.graphics.beginFill(0, 0);
                    expTipsMc.graphics.drawRect(0, 0, this.viewComponent.mcExpMask.width, this.viewComponent.mcExpMask.height);
                    this.viewComponent.addChild(expTipsMc);
                    mainScene.btn_vip.addEventListener(MouseEvent.CLICK, onVIP);
                    mainScene.petBtn.addEventListener(MouseEvent.CLICK, onPet);
                    mainScene.lockBtn.addEventListener(MouseEvent.CLICK, onMount);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    this.quickSkillManager = new QuickSkillManager(this.mainScene);
                    initmainScene();
                    updateExp();
                    isInit = false;
                    break;
                case EventList.DROPINQUICK:
                    this.quickSkillManager.addUseItem(_arg1.getBody());
                    break;
                case EventList.TEAMBTNRAY:
                    showTeamFlash();
                    break;
                case EventList.SHOW_MAINSENCE_BTN_FLASH:
                    _local2 = uint(_arg1.getBody());
                    showBtnFlash(_local2);
                    break;
                case FriendCommandList.LEAVE_WORD:
                    showFriendFlash();
                    break;
                case PetRaceEvent.SHOW_PETRACE_FLASH:
                    showPetRaceFlash();
                    break;
                case EventList.UPDATE_MAINSECEN_EXP:
                    this.updateExp();
                    break;
                case EventList.CHANGE_QUICKBAR_UI:
                    this.quickSkillManager.refresh();
                    break;
                case EventList.CLEAR_QUICKBAR_UI:
                    this.quickSkillManager.refresh();
                    break;
                case EventList.RECEIVE_QUICKBAR_MSG:
                    setPageBtn();
                    break;
                case EventList.PLAY_SOUND_OPEN_PANEL:
                    playSoundOpenPanel();
                    break;
                case EventList.UNITYBTNRAY:
                    if (((!((_arg1.getBody() == null))) && ((_arg1.getBody() == true)))){
                        showUnityFlash();
                    } else {
                        hideUnityFlash();
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    onResize();
                    break;
                case EventList.UPDATE_SKILLINFO:
                    this.quickSkillManager.updateSkillInfo();
                    break;
                case EventList.UPDATE_MAINBTN_RIGHT:
                    setBtnRight();
                    break;
                case EventList.UPDATE_MODULE_STATUS:
                    updateModuleStatus();
                    break;
                case EventList.EFFECT_GETITEMTOBAG:
                    itemId = (_arg1.getBody() as int);
                    useItem = new UseItem(0, itemId, null, 0, 0);
                    useItem.Num = 1;
                    useItem.Id = itemId;
                    useItem.IsLock = false;
                    useItem.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                    useItem.y = (GameCommonData.GameInstance.ScreenHeight - 250);
                    GameCommonData.GameInstance.GameUI.addChild(useItem);
                    toP = mainScene["btn_4"].parent.localToGlobal(new Point(mainScene["btn_4"].x, mainScene["btn_4"].y));
                    TweenLite.to(useItem, 2, {
                        x:(toP.x + 10),
                        y:(toP.y + 10),
                        scaleX:0.5,
                        scaleY:0.5,
                        onComplete:function ():void{
                            if (((useItem) && (useItem.parent))){
                                useItem.parent.removeChild(useItem);
                            };
                            useItem = null;
                        }
                    });
                    break;
                case EventList.MAINBAR_BAGFULL:
                    fullIdx = (_arg1.getBody() as int);
                    if (fullIdx == -1){
                        TweenLite.killTweensOf(fullBm);
                        if (((!((fullBm == null))) && (fullBm.parent))){
                            fullBm.parent.removeChild(fullBm);
                        };
                    } else {
                        bagMc = mainScene["btn_4"];
                        if (fullBm == null){
                            fullBm = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("FullAsset");
                        };
                        fullBm.x = (bagMc.x - 25);
                        fullBm.y = (bagMc.y - 40);
                        fullBm.name = ("bagfull_" + fullIdx);
                        mainScene.addChild(fullBm);
                        TweenMax.to(fullBm, 0.5, {
                            y:-10,
                            yoyo:true,
                            repeat:-1,
                            ease:Quad.easeInOut
                        });
                    };
                    break;
            };
        }
        protected function showFriendFlash():void{
            mainScene["btn_5"].mcFlash.play();
            mainScene["btn_5"].mcFlash.visible = true;
        }
        private function onVIP(_arg1:MouseEvent):void{
            if (dataProxy.VipIsOpen){
                sendNotification(EventList.CLOSE_VIP);
            } else {
                sendNotification(EventList.SHOW_VIP);
            };
        }
        private function onPet(_arg1:MouseEvent):void{
            var _local2:int;
            if (GameCommonData.Player.Role.UsingPetAnimal){
                PetSend.Rest();
            } else {
                _local2 = (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).getCurrSelect();
                if (_local2 != -1){
                    PetSend.Out(_local2);
                } else {
                    MessageTip.popup(LanguageMgr.GetTranslation("没有要出战的宠物"));
                };
            };
        }
        protected function onMouseOutHandler(_arg1:MouseEvent):void{
            if (_arg1.currentTarget.contains(redFrame)){
                _arg1.currentTarget.removeChild(redFrame);
            };
        }
        private function initmainScene():void{
            var _local2:int;
            shopBtn = new HBaseButton(mainScene.shopBtn);
            shopBtn.useBackgoundPos = true;
            mainScene.addChild(shopBtn);
            mainScene.shopBtn.addEventListener(MouseEvent.CLICK, onShopHandler);
            hammerBtn = new HBaseButton(mainScene.hammerBtn);
            hammerBtn.useBackgoundPos = true;
            mainScene.addChild(hammerBtn);
            mainScene.hammerBtn.addEventListener(MouseEvent.CLICK, onAutoPalyClickHandler);
            mainScene.x = ((((GameCommonData.GameInstance.ScreenWidth - 1000) / 2) + 1000) - 723);
            mainScene.y = (GameCommonData.GameInstance.ScreenHeight - 92);
            mainScene.name = "mainScene";
            GameCommonData.GameInstance.GameUI.addChild(mainScene);
            var _local1:int;
            while (_local1 < 14) {
                mainScene[("btn_" + _local1)].addEventListener(MouseEvent.CLICK, onQuickBtn);
                if (mainScene[("btn_" + _local1)].hasOwnProperty("mcFlash")){
                    mainScene[("btn_" + _local1)].mcFlash.mouseChildren = false;
                    mainScene[("btn_" + _local1)].mcFlash.mouseEnabled = false;
                    mainScene[("btn_" + _local1)].mcFlash.stop();
                    mainScene[("btn_" + _local1)].mcFlash.visible = false;
                };
                _local1++;
            };
            while (_local2 < 8) {
                (mainScene.mcQuickBar0[("quick_" + _local2)] as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
                (mainScene.mcQuickBar0[("quick_" + _local2)] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
                (mainScene.mcQuickBar1[("quickf_" + _local2)] as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
                (mainScene.mcQuickBar1[("quickf_" + _local2)] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
                _local2++;
            };
            facade.registerProxy(quickSkillManager);
            setPageBtn();
            mainScene.btnQuickLanUp.addEventListener(MouseEvent.CLICK, onPageBtn);
            mainScene.btnQuickLanDown.addEventListener(MouseEvent.CLICK, onPageBtn);
            setBtnRight();
        }
        protected function onAutoPalyClickHandler(_arg1:MouseEvent):void{
            if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                if (this.dataProxy.autoPlayIsOpen){
                    sendNotification(AutoPlayEventList.HIDE_AUTOPLAY_UI);
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                } else {
                    sendNotification(AutoPlayEventList.SHOW_AUTOPLAY_UI);
                };
            } else {
                UIFacade.GetInstance().ShowHint(LanguageMgr.GetTranslation("您还未装备上神兵"));
            };
        }
        private function showEffectExp(_arg1:Number, _arg2:Point):void{
            var url:* = null;
            var expComplete:* = null;
            var deltaExp:* = _arg1;
            var destP:* = _arg2;
            expComplete = function ():void{
                var _local1:MovieClip = ResourcesFactory.getInstance().getswfResourceByUrl(url);
                GameCommonData.GameInstance.GameUI.addChild(_local1);
                _local1.x = destP.x;
                _local1.y = (destP.y + 2);
                _local1.width = deltaExp;
                EffectLib.moveExp(_local1);
            };
            url = "Resources/Effect/ExpPromote.swf";
            ResourcesFactory.getInstance().getResource(url, expComplete);
        }
        protected function hideFriendFlash():void{
            mainScene["btn_5"].mcFlash.stop();
            mainScene["btn_5"].mcFlash.visible = false;
        }
        private function get mainScene():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        public function useQuickBtn(_arg1:uint, _arg2:MouseEvent=null):void{
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "downBtnSound");
            switch (_arg1){
                case 0:
                    if (!dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "hero");
                        dataProxy.HeroPropIsOpen = true;
                        facade.sendNotification(EventList.SHOWHEROPROP);
                    } else {
                        facade.sendNotification(EventList.CLOSEHEROPROP);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_0"].mcFlash.stop();
                    mainScene["btn_0"].mcFlash.visible = false;
                    break;
                case 1:
                    if (!dataProxy.NewSkillIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "skill");
                        dataProxy.NewSkillIsOpen = true;
                        facade.sendNotification(EventList.SHOWSKILLVIEW);
                    } else {
                        facade.sendNotification(EventList.CLOSESKILLVIEW);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_1"].mcFlash.stop();
                    mainScene["btn_1"].mcFlash.visible = false;
                    break;
                case 2:
                    if (!dataProxy.PetCanOperate){
                        facade.sendNotification(EventList.SHOWPETVIEW);
                        return;
                    };
                    if (!dataProxy.PetIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "pet");
                        facade.sendNotification(EventList.SHOWPETVIEW);
                    } else {
                        facade.sendNotification(EventList.CLOSEPETVIEW);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_2"].mcFlash.stop();
                    mainScene["btn_2"].mcFlash.visible = false;
                    break;
                case 3:
                    if (!dataProxy.AchieveIsOpen){
                        facade.sendNotification(EventList.SHOW_ACHIEVEVIEW);
                    } else {
                        facade.sendNotification(EventList.CLOSE_ACHIEVEVIEW);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_3"].mcFlash.stop();
                    mainScene["btn_3"].mcFlash.visible = false;
                    break;
                case 4:
                    if (!dataProxy.BagIsOpen){
                        sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "bag");
                        facade.sendNotification(EventList.SHOWBAG);
                    } else {
                        facade.sendNotification(EventList.CLOSEBAG);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_4"].mcFlash.stop();
                    mainScene["btn_4"].mcFlash.visible = false;
                    break;
                case 5:
                    if (!dataProxy.FriendsIsOpen){
                        facade.sendNotification(FriendCommandList.SHOWFRIEND);
                    } else {
                        facade.sendNotification(FriendCommandList.HIDEFRIEND);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    break;
                case 6:
                    if (!dataProxy.UnityIsOpen){
                        facade.sendNotification(EventList.SHOWUNITYVIEW);
                        sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "unity");
                    } else {
                        facade.sendNotification(EventList.CLOSEUNITYVIEW);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_6"].mcFlash.stop();
                    mainScene["btn_6"].mcFlash.visible = false;
                    break;
                case 7:
                    if (!dataProxy.TeamIsOpen){
                        sendNotification(EventList.SHOWTEAM);
                        sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "team");
                    } else {
                        facade.sendNotification(EventList.REMOVETEAM);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    mainScene["btn_7"].mcFlash.stop();
                    mainScene["btn_7"].mcFlash.visible = false;
                    break;
                case 8:
                    if (dataProxy.SetviewIsOpen){
                        sendNotification(SetViewEvent.HIDE_SETVIEW);
                    } else {
                        sendNotification(SetViewEvent.SHOW_SETVIEW);
                    };
                    break;
                case 9:
                    mainScene["btn_9"].mcFlash.stop();
                    mainScene["btn_9"].mcFlash.visible = false;
                    if (GameCommonData.Player.Role.Level < 35){
                        GuidePicFrame.show(GuidePicFrame.TYPE_PETRACE);
                        return;
                    };
                    if (!dataProxy.PetRaceIsOpen){
                        facade.sendNotification(EventList.SHOW_PETRACE);
                        if (((mainScene["btn_9"].mcFlash.visible) && (PetRacingBattle.IsRacing()))){
                            facade.sendNotification(PetRaceEvent.UPDATE_CHALLENGGE, {
                                type:1,
                                leftInfo:PetRaceConstData.selfRacingInfo,
                                rightInfo:PetRaceConstData.targetRacingInfo
                            });
                        };
                    } else {
                        facade.sendNotification(EventList.CLOSE_PETRACE);
                    };
                    break;
                case 10:
                    if (GameCommonData.ModuleCloseConfig[2] == 1){
                        break;
                    };
                    mainScene["btn_10"].mcFlash.stop();
                    mainScene["btn_10"].mcFlash.visible = false;
                    if (GameCommonData.Player.Role.Level < 31){
                        GuidePicFrame.show(GuidePicFrame.TYPE_SHILIAN);
                        return;
                    };
                    facade.sendNotification(TranscriptEvent.SHOW_TOWER_VIEW);
                    break;
                case 11:
                    SmallConstData.getInstance().onShowEquipStreng(_arg2);
                    mainScene["btn_11"].mcFlash.stop();
                    mainScene["btn_11"].mcFlash.visible = false;
                    break;
                case 12:
                    SmallConstData.getInstance().onShowEquipStreng(_arg2);
                    mainScene["btn_12"].mcFlash.stop();
                    mainScene["btn_12"].mcFlash.visible = false;
                    break;
                case 13:
                    if (dataProxy.OpenItemBoxIsOpen == false){
                        facade.sendNotification(EventList.SHOW_OPENITEMBOX_UI);
                    } else {
                        facade.sendNotification(EventList.CLOSE_OPENITEMBOX_UI);
                    };
            };
        }
        protected function showUnityFlash():void{
            mainScene["btn_6"].mcFlash.play();
            mainScene["btn_6"].mcFlash.visible = true;
        }
        protected function onMouseMoveHandler(_arg1:MouseEvent):void{
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            if (this.redFrame.parent != _arg1.currentTarget){
                _arg1.currentTarget.addChild(this.redFrame);
                redFrame.x = 0;
                redFrame.y = 0;
            };
        }
        protected function hideUnityFlash():void{
            mainScene["btn_6"].mcFlash.stop();
            mainScene["btn_6"].mcFlash.visible = false;
        }
        private function playSoundOpenPanel():void{
            SoundManager.PlaySound(SoundList.PANECLOSE);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.DROPINQUICK, EventList.TEAMBTNRAY, FriendCommandList.LEAVE_WORD, PetRaceEvent.SHOW_PETRACE_FLASH, EventList.UPDATE_MAINSECEN_EXP, EventList.DROPSKILLINQUICK, EventList.USE_EXTENDSKILL_MSG, EventList.SHOW_MAINSENCE_BTN_FLASH, EventList.PET_RESTORDEAD_MSG, EventList.CHANGE_QUICKBAR_UI, EventList.RECEIVE_QUICKBAR_MSG, EventList.PLAY_SOUND_OPEN_PANEL, EventList.UNITYBTNRAY, EventList.CLEAR_QUICKBAR_UI, EventList.RESIZE_STAGE, EventList.UPDATE_SKILLINFO, EventList.UPDATE_MAINBTN_RIGHT, EventList.UPDATE_MODULE_STATUS, EventList.EFFECT_GETITEMTOBAG, EventList.MAINBAR_BAGFULL]);
        }
        private function updateModuleStatus(){
            mainScene["btn_13"].visible = (GameCommonData.ModuleCloseConfig[0] == 0);
            mainScene["btn_9"].visible = (((GameCommonData.Player.Role.Level >= 33)) && ((GameCommonData.ModuleCloseConfig[1] == 0)));
            mainScene["btn_10"].visible = ((((GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_SHILIAN]) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_SHOWBTN_SHILIAN].IsComplete))) && ((GameCommonData.ModuleCloseConfig[2] == 0)));
            if (((!((BtnManager.CSBBtn == null))) && ((GameCommonData.Player.Role.Level >= 65)))){
                BtnManager.CSBBtn.visible = (GameCommonData.ModuleCloseConfig[3] == 0);
            };
        }
        private function onResize():void{
            var _local1:int = ((((GameCommonData.GameInstance.ScreenWidth - 1000) / 2) + 1000) - 723);
            var _local2:int = (GameCommonData.GameInstance.ScreenHeight - 92);
            mainScene.x = int(_local1);
            mainScene.y = int(_local2);
        }
        private function onPageBtn(_arg1:MouseEvent):void{
            quickBarFlag = !(quickBarFlag);
            mainScene.mcQuickBar1.visible = quickBarFlag;
            switch (quickBarFlag){
                case true:
                    mainScene.quickbarPageTF.text = "2";
                    break;
                case false:
                    mainScene.quickbarPageTF.text = "1";
                    break;
            };
            if (quickBarFlag){
                GameCommonData.dialogStatus = (GameCommonData.dialogStatus | 2);
            } else {
                GameCommonData.dialogStatus = (GameCommonData.dialogStatus & (uint.MAX_VALUE - 2));
            };
        }
        public function getTreasureBtn():Object{
            return (mainScene["btn_12"]);
        }
        private function onMount(_arg1:MouseEvent):void{
            if (GameCommonData.IsInCrossServer){
                return;
            };
            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT]){
                BagInfoSend.ItemUse((RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT] as InventoryItemInfo).ItemGUID);
            } else {
                MessageTip.show(LanguageMgr.GetTranslation("请先装备坐骑"));
            };
        }
        protected function showPetRaceFlash():void{
            if (!dataProxy.PetRaceIsOpen){
                mainScene["btn_9"].mcFlash.play();
                mainScene["btn_9"].mcFlash.visible = true;
            };
        }

    }
}//package GameUI.Modules.MainScene.Mediator 
