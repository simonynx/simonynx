//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Relive.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.View.HButton.*;
    import OopsEngine.Graphics.Tagger.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Relive.Data.*;
    import OopsEngine.Graphics.*;
    import flash.external.*;

    public class ReliveMediator extends Mediator {

        public static const NAME:String = "ReliveMediator";
        private static const PROP_RELIVE:int = 1;
        private static const TOWN_RELIVE:int = 0;
        private static const SKILL_RELIVE:int = 2;
        private static const COUNT:int = 5;

        private var prop_btn:HLabelButton;
        private var nameTextField:TextField;
        private var cancelBtn:HLabelButton;
        private var select_type:int = 0;
        private var skillReliveInfo:Object;
        private var isShowSRelive:Boolean;
        private var cdCount:int = 5;
        private var sRelivePanel:HFrame;
        private var town_btn:HLabelButton;
        private var bg:Sprite;
        private var isInit:Boolean;
        private var reliveTimer:Timer;
        private var timeTextFiled:TextField;
        private var dataProxy:DataProxy;
        private var panelBase:HFrame;
        private var receiveBtn:HLabelButton;
        private var sReliveCd:int = 20;
        private var isClick:Boolean = false;

        public function ReliveMediator(){
            reliveTimer = new Timer(1000);
            super(NAME);
        }
        private function showDieView(_arg1:Boolean):void{
            var _local3:GameElementAnimal;
            var _local4:DragItem;
            var _local2:Array;
            if (((MapManager.IsInArena()) || (MapManager.IsInGVG()))){
                return;
            };
            if (_arg1 == true){
                _local2 = [ColorFilters.BWFilter];
                GameCommonData.IsSelfDead = true;
            } else {
                GameCommonData.IsSelfDead = false;
            };
            GameCommonData.Scene.gameScenePlay.Background.filters = _local2;
            for each (_local3 in GameCommonData.SameSecnePlayerList) {
                _local3.filters = _local2;
            };
            for each (_local4 in GameCommonData.PackageList) {
                _local4.filters = _local2;
            };
            GameCommonData.Player.filters = _local2;
        }
        private function onReliveHandler(_arg1:MouseEvent):void{
            switch (_arg1.currentTarget.name){
                case "town_btn":
                    select_type = TOWN_RELIVE;
                    break;
                case "prop_btn":
                    select_type = PROP_RELIVE;
                    cdCount = 3;
                    break;
                case "receiveBtn":
                    select_type = SKILL_RELIVE;
                    break;
            };
            isClick = true;
            if (((panelBase) && (GameCommonData.GameInstance.GameUI.contains(panelBase)))){
                GameCommonData.GameInstance.GameUI.removeChild(panelBase);
            };
            if (((sRelivePanel) && (GameCommonData.GameInstance.GameUI.contains(sRelivePanel)))){
                GameCommonData.GameInstance.GameUI.removeChild(sRelivePanel);
            };
            GameCommonData.GameInstance.GameUI.addChild(bg);
        }
        private function init():void{
            viewComponent = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ReliveNewerView");
            viewComponent.txt.htmlText = LanguageMgr.GetTranslation("金叶子复活或消耗十字章");
            panelBase = new HFrame();
            panelBase.setSize(410, 120);
            reliveView.x = 7;
            reliveView.y = 32;
            reliveView.mouseChildren = false;
            reliveView.mouseEnabled = false;
            panelBase.addContent(reliveView);
            panelBase.blackGound = true;
            panelBase.name = "RelivePanel";
            panelBase.titleText = LanguageMgr.GetTranslation("死亡复活");
            panelBase.centerTitle = true;
            panelBase.showClose = false;
            town_btn = new HLabelButton();
            town_btn.name = "town_btn";
            town_btn.label = LanguageMgr.GetTranslation("免费回城复活");
            panelBase.addContent(town_btn);
            town_btn.x = 70;
            town_btn.y = (114 - 30);
            prop_btn = new HLabelButton();
            prop_btn.name = "prop_btn";
            prop_btn.label = LanguageMgr.GetTranslation("金叶子原地复活");
            panelBase.addContent(prop_btn);
            prop_btn.x = 220;
            prop_btn.y = (114 - 30);
            bg = new Sprite();
            bg.graphics.beginFill(0, 0.1);
            bg.graphics.drawRect(-500, -500, 2000, 2000);
            bg.graphics.endFill();
            sRelivePanelInit();
        }
        private function setPos():void{
            if (isInit){
                panelBase.x = int(((GameCommonData.GameInstance.ScreenWidth / 2) - (panelBase.frameWidth / 2)));
                panelBase.y = int(((GameCommonData.GameInstance.ScreenHeight / 2) - (panelBase.frameHeight / 2)));
                sRelivePanel.x = int(((GameCommonData.GameInstance.ScreenWidth / 2) - (sRelivePanel.frameWidth / 2)));
                sRelivePanel.y = int(((GameCommonData.GameInstance.ScreenHeight / 2) - (sRelivePanel.frameHeight / 2)));
            };
        }
        private function useEnableKey():void{
            UIConstData.KeyBoardCanUse = true;
        }
        private function showSReLivePanel():void{
            GameCommonData.GameInstance.GameUI.addChild(sRelivePanel);
        }
        private function onCountDownHandler(_arg1:TimerEvent):void{
            if (isClick){
                if (cdCount == 0){
                    PlayerActionSend.PlayerRelive(select_type, skillReliveInfo);
                    reliveTimer.reset();
                    return;
                };
                GameCommonData.Player.showAttackFace(AttackFace.OTHERS_RELIVE_COUNTDOWN, cdCount);
                cdCount--;
                return;
            };
            if (reliveTimer.currentCount == 30){
                PlayerActionSend.PlayerRelive(TOWN_RELIVE);
                reliveTimer.reset();
            };
            if (isShowSRelive){
                timeTextFiled.htmlText = ((("<font color='#ff0000'>" + sReliveCd) + "</font>") + "秒");
                sReliveCd--;
                if (sReliveCd < 0){
                    onCancelHandler(null);
                };
            };
        }
        private function showView():void{
            initEvent();
            GameCommonData.GameInstance.GameUI.addChild(panelBase);
            setPos();
            if ((((((((GameCommonData.Player.Role.Money >= 1000)) || (BagData.isHasItem(50700001)))) || ((GameCommonData.Player.Role.Level <= 20)))) && (!(MapManager.IsInGVG())))){
                prop_btn.enable = true;
            } else {
                prop_btn.enable = false;
            };
            if (dataProxy.TradeIsOpen){
                sendNotification(EventList.REMOVETRADE);
            };
            if (isShowSRelive){
                GameCommonData.GameInstance.GameUI.addChild(sRelivePanel);
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:GameElementAnimal;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    if (!dataProxy){
                        dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    };
                    break;
                case ReliveEvent.SHOWRELIVE:
                    if (isInit == false){
                        init();
                        isInit = true;
                    };
                    if (dataProxy.ReliveIsOpen == true){
                        return;
                    };
                    if (MapManager.IsInArenaDieoutBattle){
                        return;
                    };
                    if (GameCommonData.IsInCrossServer){
                        facade.sendNotification(EventList.CSB_DIEALERT);
                        return;
                    };
                    dataProxy.ReliveIsOpen = true;
                    UIConstData.KeyBoardCanUse = false;
                    isClick = false;
                    cdCount = 5;
                    UIFacade.GetInstance().closeOpenPanel();
                    sendNotification(EventList.CLOSE_NPC_ALL_PANEL);
                    reliveTimer.reset();
                    reliveTimer.start();
                    showView();
                    showDieView(true);
                    JSManager.showMessage(LanguageMgr.GetTranslation("新提醒你已经死亡"), 2);
                    break;
                case ReliveEvent.REMOVERELIVE:
                    if (dataProxy.ReliveIsOpen == true){
                        dataProxy.ReliveIsOpen = false;
                        showDieView(false);
                        gc();
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    setPos();
                    break;
                case ReliveEvent.SHOWSKILL_RELIVE:
                    if (isClick == true){
                        return;
                    };
                    _local2 = _arg1.getBody();
                    skillReliveInfo = _local2;
                    _local3 = GameCommonData.SameSecnePlayerList[_local2.Id];
                    if (_local3 == null){
                        nameTextField.htmlText = LanguageMgr.GetTranslation("有人想要复活你");
                    } else {
                        nameTextField.htmlText = ((("<font color='#ffcc00'>" + _local3.Role.Name) + "</font>") + LanguageMgr.GetTranslation("想要复活你"));
                    };
                    sReliveCd = 20;
                    isShowSRelive = true;
                    reliveTimer.reset();
                    reliveTimer.start();
                    showSReLivePanel();
                    break;
            };
        }
        private function onCancelHandler(_arg1:MouseEvent):void{
            if (sRelivePanel.parent){
                sRelivePanel.parent.removeChild(sRelivePanel);
            };
            isShowSRelive = false;
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, ReliveEvent.SHOWRELIVE, ReliveEvent.REMOVERELIVE, EventList.RESIZE_STAGE, ReliveEvent.SHOWSKILL_RELIVE]);
        }
        private function sRelivePanelInit():void{
            sRelivePanel = new HFrame();
            sRelivePanel.setSize(300, 200);
            sRelivePanel.showClose = false;
            sRelivePanel.blackGound = true;
            sRelivePanel.titleText = LanguageMgr.GetTranslation("技能复活");
            sRelivePanel.centerTitle = true;
            receiveBtn = new HLabelButton();
            receiveBtn.name = "receiveBtn";
            receiveBtn.label = LanguageMgr.GetTranslation("accept");
            receiveBtn.x = 90;
            receiveBtn.y = 160;
            sRelivePanel.addContent(receiveBtn);
            cancelBtn = new HLabelButton();
            cancelBtn.label = LanguageMgr.GetTranslation("refuse");
            cancelBtn.x = 180;
            cancelBtn.y = 160;
            sRelivePanel.addContent(cancelBtn);
            nameTextField = new TextField();
            nameTextField.autoSize = TextFieldAutoSize.LEFT;
            nameTextField.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 14, 0xFFFFFF);
            nameTextField.filters = OopsEngine.Graphics.Font.Stroke();
            nameTextField.x = 85;
            nameTextField.y = 75;
            nameTextField.mouseEnabled = false;
            sRelivePanel.addContent(nameTextField);
            timeTextFiled = new TextField();
            timeTextFiled.autoSize = TextFieldAutoSize.LEFT;
            timeTextFiled.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 13, 0xFFFFFF);
            timeTextFiled.filters = OopsEngine.Graphics.Font.Stroke();
            timeTextFiled.x = 135;
            timeTextFiled.y = 105;
            timeTextFiled.mouseEnabled = false;
            sRelivePanel.addContent(timeTextFiled);
        }
        private function get reliveView():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function initEvent():void{
            town_btn.addEventListener(MouseEvent.CLICK, onReliveHandler);
            prop_btn.addEventListener(MouseEvent.CLICK, onReliveHandler);
            reliveTimer.addEventListener(TimerEvent.TIMER, onCountDownHandler);
            receiveBtn.addEventListener(MouseEvent.CLICK, onReliveHandler);
            cancelBtn.addEventListener(MouseEvent.CLICK, onCancelHandler);
        }
        private function gc():void{
            removeEvent();
            reliveTimer.reset();
            if (((panelBase) && (GameCommonData.GameInstance.GameUI.contains(panelBase)))){
                GameCommonData.GameInstance.GameUI.removeChild(panelBase);
            };
            onCancelHandler(null);
            if (bg.parent){
                bg.parent.removeChild(bg);
            };
            setTimeout(useEnableKey, 1000);
        }
        private function removeEvent():void{
            town_btn.removeEventListener(MouseEvent.CLICK, onReliveHandler);
            prop_btn.removeEventListener(MouseEvent.CLICK, onReliveHandler);
            reliveTimer.removeEventListener(TimerEvent.TIMER, onCountDownHandler);
            receiveBtn.removeEventListener(MouseEvent.CLICK, onReliveHandler);
            cancelBtn.removeEventListener(MouseEvent.CLICK, onCancelHandler);
        }

    }
}//package GameUI.Modules.Relive.Mediator 
