//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.StartMediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Login.Model.*;
    import Utils.*;
    import Net.RequestSend.*;
    import flash.ui.*;

    public class CreateRoleSimpleMediator extends Mediator {

        public static const NAME:String = "CreateRoleSimpleMediator";

        private var checkCnt:int = 0;
        private var playerobj:RoleVo;
        private var rnadomNameLockTimeId:int;
        private var createRoleIndex:int;
        private var alertView:MovieClip;
        private var randomCnt:uint;

        public function CreateRoleSimpleMediator(){
            playerobj = new RoleVo();
            super(NAME);
        }
        private function show():void{
            view.resize();
            GameCommonData.GameInstance.GameUI.addChild(view);
        }
        private function completeFun():void{
            start();
        }
        protected function onKeyDown(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.ENTER){
                createdHandler(_arg1);
            };
        }
        private function createover():void{
            var _local1:RoleVo = new RoleVo();
            _local1.Index = playerobj.Index;
            _local1.UserId = playerobj.UserId;
            _local1.Level = 1;
            _local1.Photo = playerobj.Photo;
            _local1.Carrer = 0;
            _local1.Level = 1;
            _local1.Coattype = 0;
            _local1.Wapon = 0;
            _local1.Sex = playerobj.Sex;
            _local1.Name = playerobj.Name;
            GameCommonData.RoleList.push(_local1);
            facade.sendNotification(EventList.REMOVECREATEROLE);
            facade.sendNotification(CommandList.STARTUPROLE, _local1.Index);
        }
        private function manHandler(_arg1:MouseEvent):void{
            if (view.currentSex == 0){
                return;
            };
            view.setSex(0);
        }
        private function comfrimHandler(_arg1:MouseEvent):void{
            if (((alertView) && (GameCommonData.GameInstance.GameUI.contains(alertView)))){
                alertView.stage.removeEventListener(MouseEvent.CLICK, comfrimHandler);
                GameCommonData.GameInstance.GameUI.removeChild(alertView);
            };
            if (!view.enterGameBtn.hasEventListener(MouseEvent.CLICK)){
                view.enterGameBtn.addEventListener(MouseEvent.CLICK, createdHandler);
            };
        }
        private function addEvents():void{
            UIUtils.addFocusLis(view.nameTF);
            view.btnBoy.addEventListener(MouseEvent.CLICK, manHandler);
            view.btnGirl.addEventListener(MouseEvent.CLICK, womanHandler);
            view.nameTF.addEventListener(Event.CHANGE, __changeTextHandler);
            view.enterGameBtn.addEventListener(MouseEvent.CLICK, createdHandler);
            view.randomNameBtn.addEventListener(MouseEvent.CLICK, randomNamedHandler);
            GameCommonData.GameInstance.GameUI.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
        }
        private function gc():void{
            if (((view) && (GameCommonData.GameInstance.GameUI.contains(view)))){
                GameCommonData.GameInstance.GameUI.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                GameCommonData.GameInstance.GameUI.removeChild(view);
            };
            if (view){
                view.btnBoy.removeEventListener(MouseEvent.CLICK, manHandler);
                view.btnGirl.removeEventListener(MouseEvent.CLICK, womanHandler);
                view.enterGameBtn.removeEventListener(MouseEvent.CLICK, createdHandler);
                UIUtils.removeFocusLis(view.nameTF);
            };
            if (((alertView) && (alertView.parent))){
                alertView.stage.removeEventListener(MouseEvent.CLICK, comfrimHandler);
                alertView.parent.removeChild(alertView);
                alertView = null;
            };
        }
        private function start():void{
            CharacterSend.sendCurrentStep(LanguageMgr.GetTranslation("进入角色创建页面"));
            if (!GameCommonData.UILoad){
                new GameUIInit(GameCommonData.GameInstance);
                GameCommonData.UILoad = true;
            };
            if (getViewComponent() == null){
                setViewComponent(new CreateRoleSimpleWindow());
            };
            AudioController.SoundLoginOn();
            show();
            var _local1:Number = Math.random();
            var _local2:int = (int((_local1 * 10)) % 2);
            view.setSex(_local2);
            checkCnt = 0;
            if (GameCommonData.DefaultNickName != ""){
                view.nameTF.text = GameCommonData.DefaultNickName;
            } else {
                randomNamedHandler(null);
            };
            showaAlertView(LanguageMgr.GetTranslation("请输入角色名"));
            addEvents();
        }
        private function createdHandler(_arg1:Event):void{
            playerobj.Name = view.nameTF.text;
            playerobj.Sex = view.currentSex;
            playerobj.Photo = ((playerobj.Sex == 0)) ? 1 : 11;
            if (playerobj.Name == ""){
                showaAlertView(LanguageMgr.GetTranslation("角色名不能为空"));
            } else {
                if (playerobj.Photo == -1){
                    showaAlertView(LanguageMgr.GetTranslation("请选择角色头像"));
                } else {
                    if ((view.nameTF as TextField).length < 2){
                        showaAlertView(LanguageMgr.GetTranslation("角色名必须是2~7字符"));
                    } else {
                        if (((!(UIUtils.isPermitedName(view.nameTF.text))) || (!(UIUtils.legalRoleName(playerobj.Name))))){
                            showaAlertView(LanguageMgr.GetTranslation("角色姓名不合法"));
                        } else {
                            CharacterSend.createRole(this.createRoleIndex, playerobj.Name, playerobj.Sex, playerobj.Country, playerobj.Photo);
                            if (playerobj.Sex == 0){
                                GameConfigData.Freshman = ((("Resources/Player/Person/" + 1000) + ".swf?v=") + GameConfigData.PlayerVersion);
                            } else {
                                GameConfigData.Freshman = ((("Resources/Player/Person/" + 1100) + ".swf?v=") + GameConfigData.PlayerVersion);
                            };
                        };
                    };
                };
            };
            _arg1.stopPropagation();
        }
        private function get view():CreateRoleSimpleWindow{
            return ((getViewComponent() as CreateRoleSimpleWindow));
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWCREATEROLE, CommandList.CREATEOVER, EventList.REMOVECREATEROLE, EventList.RESIZE_STAGE, EventList.REMOVEALLCREATEROLE, EventList.CHECKROLENAME_RESULT]);
        }
        private function womanHandler(_arg1:MouseEvent):void{
            if (view.currentSex == 1){
                return;
            };
            view.setSex(1);
        }
        public function getRandomName():String{
            var _local1 = "";
            var _local2:Array = UIConstData.RandomNameArr[view.currentSex][0];
            var _local3:Array = UIConstData.RandomNameArr[view.currentSex][1];
            var _local4:String = _local2[Math.floor((_local2.length * Math.random()))];
            var _local5:String = _local3[Math.floor((_local3.length * Math.random()))];
            var _local6:int = Math.floor((Math.random() * 4));
            var _local7 = "";
            switch (_local6){
                case 0:
                    _local7 = _local4;
                    break;
                case 1:
                    _local7 = _local5;
                    break;
                case 2:
                    _local7 = (_local4 + _local5);
                    break;
                case 3:
                    _local7 = (_local5 + _local4);
                    break;
            };
            if ((((_local7.length > 1)) || ((randomCnt > 10)))){
                randomCnt = 0;
                return (_local7);
            };
            randomCnt++;
            return (getRandomName());
        }
        private function __changeTextHandler(_arg1:Event):void{
            if ((view.nameTF as TextField).length < 2){
                showaAlertView(LanguageMgr.GetTranslation("角色名必须是2~8字符"));
                return;
            };
            if (((!(UIUtils.isPermitedName(view.nameTF.text))) || (!(UIUtils.legalRoleName(view.nameTF.text))))){
                showaAlertView(LanguageMgr.GetTranslation("角色姓名不合法"));
                return;
            };
            comfrimHandler(null);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:String;
            var _local3:Object;
            var _local4:int;
            var _local5:String;
            switch (_arg1.getName()){
                case EventList.SHOWCREATEROLE:
                    this.createRoleIndex = int(_arg1.getBody());
                    if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple) == null){
                        CharacterSend.sendCurrentStep("加载角色创建页面");
                        new GameRoleManager(GameCommonData.GameInstance, 1, completeFun);
                    } else {
                        start();
                    };
                    break;
                case CommandList.CREATEOVER:
                    _local3 = _arg1.getBody();
                    if (_local3.ErrorType == 0){
                        playerobj.Index = _local3.Index;
                        playerobj.Name = _local3.Name;
                        createover();
                    } else {
                        if (_local3.ErrorType == 1){
                            showaAlertView(LanguageMgr.GetTranslation("名字重复"));
                        } else {
                            if (_local3.ErrorType == 1){
                                showaAlertView(LanguageMgr.GetTranslation("数量限制"));
                            };
                        };
                    };
                    break;
                case EventList.REMOVECREATEROLE:
                    gc();
                    break;
                case EventList.REMOVEALLCREATEROLE:
                    allDispose();
                    break;
                case EventList.RESIZE_STAGE:
                    if (view){
                        view.resize();
                        if (alertView != null){
                            showaAlertView(alertView.txtInfo.text);
                        };
                    };
                    break;
                case EventList.CHECKROLENAME_RESULT:
                    _local3 = _arg1.getBody();
                    _local4 = _local3["result"];
                    _local5 = _local3["name"];
                    if (_local4 == 0){
                        if (checkCnt <= 5){
                            randomNamedHandler(null);
                        } else {
                            showaAlertView(LanguageMgr.GetTranslation("名字重复"));
                        };
                    } else {
                        if (_local4 == 1){
                            view.nameTF.text = _local5;
                            showaAlertView(LanguageMgr.GetTranslation("以默认姓名进入游戏"));
                        };
                    };
                    clearTimeout(rnadomNameLockTimeId);
                    view.randomNameBtn.enabled = true;
                    break;
            };
        }
        private function randomNamedHandler(_arg1:MouseEvent):void{
            var e:* = _arg1;
            if (e){
                checkCnt = 0;
            };
            checkCnt++;
            var randomName:* = getRandomName();
            view.randomNameBtn.enabled = false;
            if (((!((randomName == ""))) && (!((randomName == null))))){
                CharacterSend.CheckName(randomName);
            };
            clearTimeout(rnadomNameLockTimeId);
            rnadomNameLockTimeId = setTimeout(function ():void{
                view.randomNameBtn.enabled = true;
            }, 5000);
        }
        private function showaAlertView(_arg1:String):void{
            if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple) == null){
                return;
            };
            if (((alertView) && (alertView.parent))){
                alertView.parent.removeChild(alertView);
            };
            alertView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple).GetClassByMovieClip("AlertView");
            GameCommonData.GameInstance.GameUI.addChild(alertView);
            alertView.txtInfo.width = 138;
            alertView.txtInfo.text = _arg1;
            alertView.x = (view.nameTF.x - 50);
            if (_arg1 == LanguageMgr.GetTranslation("请选择角色头像")){
                alertView.x = ((view.mainMc.x + view.mainMc["mclook_1"].x) - 5);
                alertView.y = ((view.mainMc.y + view.mainMc["mclook_1"].y) + 10);
            } else {
                if (_arg1 == LanguageMgr.GetTranslation("以默认姓名进入游戏")){
                    alertView.x = ((view.mainMc.x + view.enterGameBtn.x) - 5);
                    alertView.y = ((view.mainMc.y + view.enterGameBtn.y) + 5);
                } else {
                    alertView.x = ((view.mainMc.x + view.nameTF.x) - 5);
                    alertView.y = ((view.mainMc.y + view.nameTF.y) + 5);
                };
            };
        }
        private function allDispose():void{
            gc();
            if (view){
                view.nameTF.removeEventListener(Event.CHANGE, __changeTextHandler);
                view.randomNameBtn.removeEventListener(MouseEvent.CLICK, randomNamedHandler);
            };
        }

    }
}//package GameUI.Modules.Login.StartMediator 
