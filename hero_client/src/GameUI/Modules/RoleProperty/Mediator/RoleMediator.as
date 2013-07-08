//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Constellation.Mediator.*;
    import GameUI.*;

    public class RoleMediator extends Mediator {

        public static const NAME:String = "RoleMediator";
        public static const roleTitleArray:Array = ["人物属性", "声 望", "星座守护", "资 料"];

        private var equipMediator:EquipMediator = null;
        private var dataProxy:DataProxy;
        private var view:Sprite;
        private var isGet:Boolean;
        public var panelBase:HFrame;

        public function RoleMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.RESIZE_STAGE, EventList.SHOWHEROPROP, EventList.CLOSEHEROPROP, EventList.SETHEROVIEWPOS, RoleEvents.HEROPROP_PANEL_INIT_POS, RoleEvents.HEROPROP_PANEL_STOP_DRAG]);
        }
        private function selectView(_arg1:MouseEvent):void{
            var _local3:int;
            var _local2:int = int(_arg1.currentTarget.name.split("_")[1]);
            if (RolePropDatas.CurView == _local2){
                return;
            };
            if (GameCommonData.IsInCrossServer){
                if ([1, 2, 3].indexOf(_local2) != -1){
                    return;
                };
            };
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            RolePropDatas.CurView = int(_arg1.currentTarget.name.split("_")[1]);
            panelBase.titleText = LanguageMgr.roleTitleArray[RolePropDatas.CurView];
            heroProp["menuBar"].gotoAndStop((RolePropDatas.CurView + 1));
            facade.sendNotification(RoleEvents.SHOWPROPELEMENT, RolePropDatas.CurView);
            if (RolePropDatas.CurView == StarMediator.TYPE){
                panelBase.setSize(525, 418);
                sendNotification(EventList.SET_STAR_OPEN_STATUS, 0);
            } else {
                panelBase.setSize(296, 420);
            };
            heroProp["menuBar"].parent.addChild(heroProp["menuBar"]);
            while (_local3 < 4) {
                heroProp[("prop_" + _local3)].parent.addChild(heroProp[("prop_" + _local3)]);
                _local3++;
            };
        }
        private function setPage():void{
            var _local1:int;
            heroProp["menuBar"].gotoAndStop((RolePropDatas.CurView + 1));
            heroProp["menuBar"].parent.addChild(heroProp["menuBar"]);
            while (_local1 < 4) {
                heroProp[("prop_" + _local1)].buttonMode = true;
                heroProp[("prop_" + _local1)].addEventListener(MouseEvent.CLICK, selectView);
                heroProp[("prop_" + _local1)].parent.addChild(heroProp[("prop_" + _local1)]);
                _local1++;
            };
        }
        private function selectViewL(_arg1:int):void{
            var _local2:int;
            RolePropDatas.CurView = _arg1;
            heroProp["menuBar"].gotoAndStop((RolePropDatas.CurView + 1));
            facade.sendNotification(RoleEvents.SHOWPROPELEMENT, RolePropDatas.CurView);
            heroProp["menuBar"].parent.addChild(heroProp["menuBar"]);
            while (_local2 < 4) {
                heroProp[("prop_" + _local2)].parent.addChild(heroProp[("prop_" + _local2)]);
                _local2++;
            };
            panelBase.titleText = LanguageMgr.roleTitleArray[RolePropDatas.CurView];
        }
        private function mouseDownHandler(_arg1:MouseEvent):void{
            panelBase.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
        private function mouseMoveHandler(_arg1:MouseEvent):void{
            facade.sendNotification(RoleEvents.DRAG_ATTRIBUTE);
        }
        private function panelCloseHandler():void{
            var _local1:int;
            if (GameCommonData.GameInstance.GameUI.contains(panelBase)){
                _local1 = 0;
                while (_local1 < 4) {
                    heroProp[("prop_" + _local1)].removeEventListener(MouseEvent.CLICK, selectView);
                    _local1++;
                };
                facade.sendNotification(RoleEvents.MEDIATORGC);
                EffectLib.checkTranslationByClose(panelBase, GameCommonData.GameInstance.stage);
                panelBase.close();
            };
            facade.sendNotification(RoleEvents.CLOSE_PANEL);
            dataProxy.HeroPropIsOpen = false;
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
        }
        private function mouseUpHandler(_arg1:MouseEvent):void{
            panelBase.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.HEROPROPPANE
                    });
                    heroProp.x = 8;
                    heroProp.y = 30;
                    panelBase = new HFrame();
                    panelBase.setSize(296, 420);
                    panelBase.closeBtn.y = 6;
                    panelBase.titleText = LanguageMgr.GetTranslation("人物属性");
                    panelBase.centerTitle = true;
                    panelBase.offsetCloseBtnPos(0, -4);
                    LanguageMgr.roleTitleArray[0] = GameCommonData.Player.Role.Name;
                    heroProp.mouseEnabled = false;
                    panelBase.addContent(heroProp);
                    panelBase.closeCallBack = panelCloseHandler;
                    panelBase.blackGound = false;
                    panelBase.x = UIConstData.DefaultPos1.x;
                    panelBase.y = ((GameCommonData.GameInstance.ScreenHeight - panelBase.height) / 2);
                    panelBase.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                    panelBase.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                    registerMediator();
                    heroProp["menuBar"].gotoAndStop(1);
                    break;
                case EventList.RESIZE_STAGE:
                    panelBase.x = UIConstData.DefaultPos1.x;
                    panelBase.y = ((GameCommonData.GameInstance.ScreenHeight - panelBase.height) / 2);
                    break;
                case EventList.SHOWHEROPROP:
                    _local2 = 0;
                    if (_arg1.getBody() != null){
                        _local2 = int(_arg1.getBody());
                    };
                    initView();
                    if (_local2 == StarMediator.TYPE){
                        panelBase.setSize(525, 418);
                        panelBase.centerFrame();
                    } else {
                        panelBase.setSize(296, 415);
                        panelBase.centerFrame();
                        panelBase.x = (panelBase.x - int(((525 - 296) / 2)));
                    };
                    selectViewL(_local2);
                    panelBase.name = "role";
                    EffectLib.checkTranslationByShow(panelBase, GameCommonData.GameInstance.stage);
                    break;
                case EventList.SETHEROVIEWPOS:
                    selectViewL((_arg1.getBody() as int));
                    break;
                case EventList.CLOSEHEROPROP:
                    panelCloseHandler();
                    break;
                case RoleEvents.HEROPROP_PANEL_INIT_POS:
                    panelBase.x = UIConstData.DefaultPos1.x;
                    panelBase.y = UIConstData.DefaultPos1.y;
                    break;
                case RoleEvents.HEROPROP_PANEL_STOP_DRAG:
                    if (panelBase){
                    };
                    break;
            };
        }
        private function initView():void{
            GameCommonData.GameInstance.GameUI.addChild(panelBase);
            setPage();
        }
        private function registerMediator():void{
            equipMediator = new EquipMediator(heroProp);
            facade.registerMediator(equipMediator);
            facade.registerMediator(new MaterialMediator(heroProp));
            facade.registerMediator(new PrestigeMediator(heroProp));
            if (facade.retrieveMediator(StarMediator.NAME) == null){
                facade.registerMediator(new StarMediator(heroProp));
            } else {
                (facade.retrieveMediator(StarMediator.NAME) as StarMediator).setParentView(heroProp);
            };
            facade.sendNotification(RoleEvents.INITROLEVIEW);
        }
        public function get heroProp():MovieClip{
            return ((this.viewComponent as MovieClip));
        }

    }
}//package GameUI.Modules.RoleProperty.Mediator 
