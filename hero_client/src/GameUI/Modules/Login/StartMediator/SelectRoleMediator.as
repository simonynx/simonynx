//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.StartMediator {
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Login.Model.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Login.view.*;

    public class SelectRoleMediator extends Mediator {

        public static const NAME:String = "SelectRoleMediatorYL";

        private var grManager:GameRoleManager;

        public function SelectRoleMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWSELECTROLE, EventList.UPDATE_ROLELIST, EventList.REMOVESELECTROLE, EventList.SELECTROLE_CHARNAME_RESULT, EventList.RESIZE_STAGE, EventList.SHOW_OFFLINETIP]);
        }
        private function addEvents():void{
            view.enterGameBtn.addEventListener(MouseEvent.CLICK, enterGameHandler);
            view.addEventListener(Event.SELECT, __selectRoleHandler);
            view.keepBtn.addEventListener(MouseEvent.CLICK, __keepHandler);
        }
        private function setRoleData(_arg1:Array):void{
            view.setRoleData(_arg1);
        }
        private function __keepHandler(_arg1:MouseEvent):void{
            if (view.KeepRoleArr.length != 3){
                HAlertDialog.show(LanguageMgr.GetTranslation("提示"), LanguageMgr.GetTranslation("请确认已经选择保留角色个数为3"));
                return;
            };
            HConfirmDialog.show(LanguageMgr.GetTranslation("角色保留"), LanguageMgr.GetTranslation("确认保留这些角色后删除其他可否句"), true, KeepRole_sendSocket);
        }
        private function completeFun():void{
            start();
        }
        private function show():void{
            view.resize();
            GameCommonData.GameInstance.GameUI.addChild(view);
        }
        private function enterGameHandler(_arg1:MouseEvent):void{
            if ((((view.enterGameBtn.enabled == false)) || ((view.currentSelectInfo == null)))){
                return;
            };
            view.enterGameBtn.enabled = false;
            view.enterGameBtn.mouseEnabled = false;
            facade.sendNotification(CommandList.STARTUPROLE, view.currentSelectInfo.Index);
            view.enterGameBtn.removeEventListener(MouseEvent.CLICK, enterGameHandler);
        }
        private function start():void{
            if (!GameCommonData.UILoad){
                new GameUIInit(GameCommonData.GameInstance);
                GameCommonData.UILoad = true;
            };
            if (getViewComponent() == null){
                setViewComponent(new SelectRoleWindow());
            };
            AudioController.SoundLoginOn();
            setRoleData(GameCommonData.RoleList);
            addEvents();
            show();
        }
        private function get view():SelectRoleWindow{
            return ((getViewComponent() as SelectRoleWindow));
        }
        private function __selectRoleHandler(_arg1:Event):void{
            view.currentSelectInfo;
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Array;
            var _local3:Array;
            var _local4:RoleVo;
            var _local5:uint;
            var _local6:String;
            var _local7:int;
            var _local8:int;
            switch (_arg1.getName()){
                case EventList.SHOWSELECTROLE:
                    if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole) == null){
                        grManager = new GameRoleManager(GameCommonData.GameInstance, 0, completeFun);
                    } else {
                        start();
                    };
                    break;
                case EventList.UPDATE_ROLELIST:
                    _local2 = (_arg1.getBody() as Array);
                    _local3 = [];
                    _local7 = 0;
                    while (_local7 < GameCommonData.RoleList.length) {
                        _local8 = 0;
                        while (_local8 < _local2.length) {
                            if (((GameCommonData.RoleList[_local7]) && ((_local2[_local8].guid == GameCommonData.RoleList[_local7].UserId)))){
                                GameCommonData.RoleList[_local7].Index = _local2[_local8].slot;
                                _local3.push(GameCommonData.RoleList[_local7]);
                            };
                            _local8++;
                        };
                        _local7++;
                    };
                    GameCommonData.RoleList = _local3;
                    setRoleData(GameCommonData.RoleList);
                    break;
                case EventList.SELECTROLE_CHARNAME_RESULT:
                    _local5 = _arg1.getBody()["result"];
                    _local6 = _arg1.getBody()["newName"];
                    if ((((_local5 == 1)) && ((SelectRoleRenameView.RenameGuid > 0)))){
                        _local7 = 0;
                        while (_local7 < GameCommonData.RoleList.length) {
                            if (((GameCommonData.RoleList[_local7]) && ((SelectRoleRenameView.RenameGuid == GameCommonData.RoleList[_local7].UserId)))){
                                GameCommonData.RoleList[_local7].Name = _local6;
                            };
                            _local7++;
                        };
                        setRoleData(GameCommonData.RoleList);
                    } else {
                        HAlertDialog.show(LanguageMgr.GetTranslation("提示"), LanguageMgr.GetTranslation("修改名字失败"));
                    };
                    view.renameView.close();
                    break;
                case EventList.REMOVESELECTROLE:
                    gc();
                    break;
                case EventList.RESIZE_STAGE:
                    if (view){
                        view.resize();
                    };
                    break;
                case EventList.SHOW_OFFLINETIP:
                    this.view.errormsg.text = LanguageMgr.GetTranslation("连接断开请重新登录");
                    break;
            };
        }
        private function gc():void{
            if (view){
                removeEvents();
                if (GameCommonData.GameInstance.GameUI.contains(view)){
                    GameCommonData.GameInstance.GameUI.removeChild(view);
                };
            };
            if (grManager){
                grManager.dispose();
                grManager = null;
            };
        }
        private function removeEvents():void{
            view.enterGameBtn.removeEventListener(MouseEvent.CLICK, enterGameHandler);
            view.removeEventListener(Event.SELECT, __selectRoleHandler);
            view.keepBtn.removeEventListener(MouseEvent.CLICK, __keepHandler);
        }
        private function KeepRole_sendSocket():void{
            CharacterSend.KeepRole(view.KeepRoleArr[0].info.UserId, view.KeepRoleArr[1].info.UserId, view.KeepRoleArr[2].info.UserId);
        }

    }
}//package GameUI.Modules.Login.StartMediator 
