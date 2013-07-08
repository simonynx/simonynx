//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pk.Mediator {
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import flash.geom.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Friend.view.ui.*;
    import OopsFramework.Utils.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Pk.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Pk.view.*;

    public class PkMediator extends Mediator {

        public static const NAME:String = "PkMediator";

        private var dataProxy:DataProxy;
        private var view:HFrame;
        private var box1:HCheckBox;
        private var box2:HCheckBox;
        private var _enterpkSceneTipsView:PkSceneTipsView;
        private var isInit:Boolean;
        private var box0:HCheckBox;

        public function PkMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWPKVIEW, PkEvent.UPDATEDATA, PkEvent.RESET_PK, PkEvent.PKSCENETIPS_SHOW, PkEvent.PKSCENETIPS_HIDE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:int;
            var _local3:String;
            var _local4:Object;
            var _local5:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.SHOWPKVIEW:
                    if (isInit == false){
                        initView();
                        isInit = true;
                    };
                    showPk();
                    break;
                case PkEvent.UPDATEDATA:
                    _local4 = _arg1.getBody();
                    PkData.PkStateList[_local4.type] = _local4.value;
                    if (isInit == true){
                        this[("box" + _local4.type)].selected = _local4.value;
                    };
                    break;
                case PkEvent.RESET_PK:
                    if (isInit == true){
                        _local5 = 0;
                        while (_local5 < 3) {
                            this[("box" + _local5)].selected = PkData.PkStateList[_local5];
                            _local5++;
                        };
                    };
                    break;
                case PkEvent.PKSCENETIPS_SHOW:
                    if (_enterpkSceneTipsView == null){
                        _enterpkSceneTipsView = new PkSceneTipsView();
                    };
                    _enterpkSceneTipsView.targetPoint = new Point(_arg1.getBody()["TitleX"], _arg1.getBody()["TitleY"]);
                    _enterpkSceneTipsView.x = ((GameCommonData.GameInstance.ScreenWidth - _enterpkSceneTipsView.frameWidth) / 2);
                    _enterpkSceneTipsView.y = ((GameCommonData.GameInstance.ScreenHeight - _enterpkSceneTipsView.frameHeight) / 2);
                    GameCommonData.GameInstance.GameUI.addChild(_enterpkSceneTipsView);
                    break;
                case PkEvent.PKSCENETIPS_HIDE:
                    _enterpkSceneTipsView.dispose();
                    _enterpkSceneTipsView = null;
                    break;
            };
        }
        private function onBoxChange(_arg1:Event):void{
            switch (_arg1.currentTarget.name){
                case "box0":
                    if (PkData.PkStateList[0] != box0.selected){
                        PkData.PkStateList[0] = box0.selected;
                        PlayerActionSend.SendPkState(PkData.PkStateList[0], 0);
                    };
                    break;
                case "box1":
                    if (PkData.PkStateList[1] != box1.selected){
                        PkData.PkStateList[1] = box1.selected;
                        PlayerActionSend.SendPkState(PkData.PkStateList[1], 1);
                    };
                    break;
                case "box2":
                    if (PkData.PkStateList[2] != box2.selected){
                        PkData.PkStateList[2] = box2.selected;
                        PlayerActionSend.SendPkState(PkData.PkStateList[2], 2);
                    };
                    break;
            };
        }
        private function removeEvent():void{
            var _local1:int;
            while (_local1 < 3) {
                this[("box" + _local1)].removeEventListener(Event.CHANGE, onBoxChange);
                _local1++;
            };
        }
        private function initEvent():void{
            var _local1:int;
            while (_local1 < 3) {
                this[("box" + _local1)].addEventListener(Event.CHANGE, onBoxChange);
                _local1++;
            };
        }
        private function showPk():void{
            if (dataProxy.isPkOpen == false){
                initEvent();
                GameCommonData.GameInstance.GameUI.addChild(view);
                view.x = 200;
                view.y = 100;
                dataProxy.isPkOpen = true;
            } else {
                onCloseView();
            };
        }
        private function initView():void{
            view = new HFrame();
            view.titleText = LanguageMgr.GetTranslation("PK设置");
            view.blackGound = false;
            view.showClose = true;
            view.moveEnable = true;
            view.closeCallBack = onCloseView;
            view.setSize(280, 140);
            view.centerTitle = true;
            box0 = new HCheckBox(LanguageMgr.GetTranslation("不攻击自己公会成员"));
            box0.name = "box0";
            box0.fireAuto = true;
            view.addChild(box0);
            box0.x = 24;
            box0.y = 40;
            box0.selected = PkData.PkStateList[0];
            box1 = new HCheckBox(LanguageMgr.GetTranslation("不攻击白名玩家句"));
            box1.name = "box1";
            box1.fireAuto = true;
            view.addChild(box1);
            box1.x = 24;
            box1.y = 70;
            box1.selected = PkData.PkStateList[1];
            box2 = new HCheckBox(LanguageMgr.GetTranslation("不攻黄红名玩家"));
            box2.name = "box2";
            box2.fireAuto = true;
            view.addChild(box2);
            box2.x = 24;
            box2.y = 100;
            box2.selected = PkData.PkStateList[2];
        }
        private function onCloseView():void{
            dataProxy.isPkOpen = false;
            GameCommonData.GameInstance.GameUI.removeChild(view);
            removeEvent();
        }

    }
}//package GameUI.Modules.Pk.Mediator 
