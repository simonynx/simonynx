//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GuildFight.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.GuildFight.View.*;
    import OopsFramework.Utils.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Unity.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import Net.RequestSend.*;

    public class GuildFightMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "GuildFightMediator";
        private static const NEEDGOLD:int = 1000000;

        private var _timer:Timer;
        private var gfProcessView:GuildFightProcessView;
        private var dataProxy:DataProxy;
        private var betMoney:uint = 10;
        private var parent:Sprite;
        private var hlepView:GuildFightHelpView;

        public function GuildFightMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:int;
            var _local4:Array;
            var _local5:String;
            var _local6:int;
            var _local7:int;
            var _local8:Number;
            var _local9:int;
            var _local10:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    initView();
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    GuildFightSend.sendRequest(0, 111111);
                    break;
                case EventList.UPDATE_GUILD_FIGHT_ITEM:
                    _local2 = _arg1.getBody();
                    if (_local2){
                        updateItems(_local2.guildArray);
                        _local4 = _local2.infoArray;
                        if (_local4.length > 0){
                            view.setInfos(_local4[0], _local4[1]);
                        };
                        checkBtn();
                    };
                    if (GameCommonData.GuildFight_IsStarting){
                        createGuildFightBtn();
                    } else {
                        hideGuildFightBtn();
                    };
                    break;
                case EventList.UPDATE_GUILD_FIGHT_PROCESS:
                    _local2 = _arg1.getBody();
                    _local3 = _local2.type;
                    if (_local3 == 0){
                        _local5 = _local2.curDefGuildName;
                        _local6 = _local2.keepTime;
                        _local7 = _local2.state;
                        _local8 = _local2.overTime;
                        _local9 = _local2.selfKeepTime;
                        if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                            GameCommonData.GameInstance.GameUI.Elements.Add(this);
                        };
                        if (gfProcessView == null){
                            gfProcessView = new GuildFightProcessView();
                            gfProcessView.show();
                            gfProcessView.resetPos();
                            gfProcessView.switchShowCallBack = switchShowCallBack;
                        };
                        gfProcessView.state = _local7;
                        gfProcessView.overTime = _local8;
                        gfProcessView.curDefGuildName = _local5;
                        gfProcessView.keepTime = _local6;
                        gfProcessView.selfKeepTime = _local9;
                        gfProcessView.Update();
                        createGuildFightBtn();
                        facade.sendNotification(TaskCommandList.VISIBLE_TASKFOLLOW_UI, false);
                    } else {
                        if (_local3 == 1){
                            _local5 = _local2.curDefGuildName;
                            _local10 = _local2.playerId;
                            gfProcessView.curDefGuildName = _local5;
                            if (_local10 == 0){
                                gfProcessView.holded = false;
                                gfProcessView.keepTime = 0;
                            } else {
                                if (_local10 == GameCommonData.Player.Role.Id){
                                    gfProcessView.holded = true;
                                    gfProcessView.keepTime = (TimeManager.Instance.Now().time / 1000);
                                } else {
                                    gfProcessView.holded = false;
                                    gfProcessView.keepTime = (TimeManager.Instance.Now().time / 1000);
                                };
                            };
                        } else {
                            if (_local3 == 2){
                                if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) != -1){
                                    GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                                };
                                if (gfProcessView){
                                    gfProcessView.close();
                                    gfProcessView = null;
                                };
                                facade.sendNotification(TaskCommandList.VISIBLE_TASKFOLLOW_UI, true);
                            };
                        };
                    };
                    break;
                case UnityEvent.SHOW_GUILDGF:
                    parent = (_arg1.getBody() as Sprite);
                    parent.addChild(view);
                    checkBtn();
                    GuildFightSend.sendRequest(0, 111111);
                    break;
                case UnityEvent.HIDE_GUILDGF:
                    if (view.parent){
                        view.parent.removeChild(view);
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    if (gfProcessView){
                        gfProcessView.resetPos();
                    };
                    break;
            };
        }
        public function get timer():Timer{
            if (_timer == null){
                _timer = new Timer();
                _timer.Frequency = 1;
            };
            return (_timer);
        }
        private function onBtnClick(_arg1:MouseEvent):void{
            var str:* = null;
            var event:* = _arg1;
            switch (uint(event.currentTarget.name)){
                case 1:
                    if (UnityConstData.myGuildInfo.Level < 4){
                        MessageTip.popup(LanguageMgr.GetTranslation("4级公会才可以报名城战"));
                        return;
                    };
                    if (GameCommonData.Player.Role.Gold < NEEDGOLD){
                        MessageTip.popup(LanguageMgr.GetTranslation("报名城战需要100金币以上"));
                        return;
                    };
                    str = LanguageMgr.GetTranslation("你是否要花费100金币进行公会战报名");
                    facade.sendNotification(EventList.SHOWALERT, {
                        comfrim:function ():void{
                            GuildFightSend.sendRequest(1, 111111);
                        },
                        cancel:function ():void{
                        },
                        info:str,
                        title:"提 示"
                    });
                    break;
                case 2:
                    if (GameCommonData.GuildFight_LineId != GameConfigData.CurrentServerId){
                        MessageTip.popup(LanguageMgr.GetTranslation("城战在x线开启", GameCommonData.GuildFight_LineId));
                        return;
                    };
                    if (GameCommonData.Player.Role.Level < 30){
                        MessageTip.popup(LanguageMgr.GetTranslation("等级达到30级才能进入"));
                        return;
                    };
                    GuildSend.EnterGuildFB(6001);
                    break;
                case 3:
                    openHelp();
                    break;
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        private function switchShowCallBack():void{
            if (gfProcessView){
                if (gfProcessView.isShowing){
                    gfProcessView.hide();
                } else {
                    gfProcessView.show();
                };
            };
        }
        private function onClose():void{
            if (dataProxy.GuildFightIsOpen){
                if (view.parent){
                    view.parent.removeChild(view);
                };
                dataProxy.GuildFightIsOpen = false;
            };
        }
        private function initView():void{
            setViewComponent(new GuildFightView());
            var _local1:int;
            while (_local1 < view.btnArray.length) {
                view.btnArray[_local1].addEventListener(MouseEvent.CLICK, onBtnClick);
                _local1++;
            };
        }
        private function hideGuildFightBtn():void{
            if (BtnManager.guildFightBtn){
                if (((BtnManager.guildFightBtn) && (BtnManager.guildFightBtn.parent))){
                    BtnManager.guildFightBtn.parent.removeChild(BtnManager.guildFightBtn);
                };
                BtnManager.guildFightBtn = null;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.UPDATE_GUILD_FIGHT_ITEM, EventList.UPDATE_GUILD_FIGHT_PROCESS, UnityEvent.SHOW_GUILDGF, UnityEvent.HIDE_GUILDGF, EventList.RESIZE_STAGE]);
        }
        public function get Enabled():Boolean{
            return (true);
        }
        private function createGuildFightBtn():void{
            if (GameCommonData.GuildFight_IsStarting){
                if (BtnManager.guildFightBtn == null){
                    BtnManager.guildFightBtn = new HBaseButton(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("GuildFightBtnAsset"));
                    GameCommonData.GameInstance.GameUI.addChild(BtnManager.guildFightBtn);
                    BtnManager.RankBtnPos();
                    BtnManager.guildFightBtn.addEventListener(MouseEvent.CLICK, __guildFightBtnHandler);
                };
            };
        }
        private function get view():GuildFightView{
            return ((viewComponent as GuildFightView));
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function Update(_arg1:GameTime):void{
            if (timer.IsNextTime(_arg1)){
                if (gfProcessView){
                    gfProcessView.Update();
                };
                if (gfProcessView.treasureKeepRemainTime > (20 * 60)){
                    gfProcessView.curDefGuildName = "";
                    gfProcessView.keepTime = 0;
                    gfProcessView.selfKeepTime = 0;
                };
            };
        }
        private function openHelp():void{
            if (hlepView == null){
                hlepView = new GuildFightHelpView();
            };
            if (hlepView.parent){
                hlepView.close();
            } else {
                hlepView.show();
                hlepView.centerFrame();
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }
        private function __guildFightBtnHandler(_arg1:MouseEvent):void{
            var str:* = null;
            var evt:* = _arg1;
            if (GameCommonData.GameInstance.GameScene.GetGameScene.name != "6001"){
                if (GameCommonData.GuildFight_LineId != GameConfigData.CurrentServerId){
                    MessageTip.popup(LanguageMgr.GetTranslation("城战在x线开启", GameCommonData.GuildFight_LineId));
                    return;
                };
                if (GameCommonData.Player.Role.Level < 30){
                    MessageTip.popup(LanguageMgr.GetTranslation("等级达到30级才能进入"));
                    return;
                };
                str = LanguageMgr.GetTranslation("你是否进入远古祭坛");
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:function ():void{
                        GuildSend.EnterGuildFB(6001);
                    },
                    cancel:function ():void{
                    },
                    info:str,
                    title:"提 示"
                });
            };
        }
        private function checkBtn():void{
            view.btnArray[0].enable = !(GameCommonData.GuildFight_IsStarting);
            view.btnArray[1].enable = GameCommonData.GuildFight_IsStarting;
            view.btnArray[2].enable = true;
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        private function updateItems(_arg1:Array):void{
            var _local4:Object;
            var _local5:GuildFightItem;
            var _local2:Array = [];
            var _local3:int;
            while (_local3 < _arg1.length) {
                _local4 = _arg1[_local3];
                _local5 = new GuildFightItem();
                _local5.list = (_local4.list + 1);
                _local5.guilder = _local4.guilder;
                _local5.guildname = _local4.guildname;
                _local5.roleid = _local4.roleid;
                _local2.push(_local5);
                _local3++;
            };
            view.updateItem(_local2);
        }
        private function show():void{
            GameCommonData.GameInstance.GameUI.addChild(view);
            view.x = int(((GameCommonData.GameInstance.ScreenWidth - view.width) / 2));
            view.y = int(((GameCommonData.GameInstance.ScreenHeight - view.height) / 2));
            dataProxy.GuildFightIsOpen = true;
            checkBtn();
            GuildFightSend.sendRequest(0, 111111);
        }

    }
}//package GameUI.Modules.GuildFight.Mediator 
