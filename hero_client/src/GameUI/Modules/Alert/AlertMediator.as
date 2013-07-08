//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Alert {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import OopsFramework.Utils.*;
    import com.greensock.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Stall.Data.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.*;

    public class AlertMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "AlertMediator";
        private static const textformat:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);

        private var comFirmPosX:Number = 0;
        private var comFirmPosY:Number = 0;
        private var params:Object = null;
        private var doExtends:uint = 0;
        private var cancelTxt:String = "取 消";
        private var warning:Boolean = false;
        private var cancelPosX:Number = 0;
        private var cancelPosY:Number = 0;
        private var alertView:MovieClip = null;
        private var canDrag:int = 0;
        private var info:String = "";
        private var comfirmTxt:String = "确 认";
        private var altertQuene:Array;
        private var extendsFn:Function = null;
        private var _timer:Timer;
        private var isShow:Boolean = false;
        private var params_extendsFn:Object = null;
        private var viewPanelBase:PanelBase = null;
        private var canOp:int = 0;
        private var params_cancel:Object = null;
        private var title:String = "提 示";
        private var width_param:uint = 300;
        private var viewPanel:MovieClip = null;
        private var btnBtn:int = 2;
        private var viewBtns:MovieClip = null;
        private var dataProxy:DataProxy;
        private var isVerification:Boolean = false;
        private var comfirmFn:Function = null;
        private var cancelFn:Function = null;
        private var worldMap:uint = 1;
        private var delayTime:int = -1;
        private var isShowClose:Boolean = true;
        private var isShowBg:Boolean = true;
        private var panelBase:PanelBase = null;
        private var autoCloseTime:int = -1;
        private var localMS:Number = 0;

        public function AlertMediator(){
            altertQuene = new Array();
            super(NAME);
        }
        private function comFrimHandler(_arg1:MouseEvent=null):void{
            if (params){
                comfirmFn(params);
            } else {
                comfirmFn();
            };
            if (((!((extendsFn == null))) && ((doExtends == 0)))){
                if (params_extendsFn){
                    extendsFn(params_extendsFn);
                } else {
                    extendsFn();
                };
                extendsFn = null;
            } else {
                extendsFn = null;
            };
            panelCloseHandler();
        }
        public function Update(_arg1:GameTime):void{
            if (timer.IsNextTime(_arg1)){
                if ((((delayTime > 0)) && ((localMS >= delayTime)))){
                    cancelUpdate();
                    comFrimHandler();
                    return;
                };
                if ((((autoCloseTime > 0)) && ((localMS >= autoCloseTime)))){
                    cancelUpdate();
                    cancelHandler(null);
                    return;
                };
                updateDoSomething();
                localMS++;
            };
        }
        private function get alert():AlertView{
            return ((this.viewComponent as AlertView));
        }
        private function updateDoSomething():void{
            if (delayTime > 0){
                alert.txtComfrim = (((comfirmTxt + "(") + (delayTime - localMS)) + ")");
            } else {
                if (autoCloseTime > 0){
                    alert.txtComfrim = (((comfirmTxt + "(") + (autoCloseTime - localMS)) + ")");
                };
            };
            if (delayTime > 0){
                alert.btnComfrim.x = int(((alert.frameWidth - alert.btnComfrim.width) / 2));
            };
        }
        private function dispose():void{
            alert.btnComfrim.removeEventListener(MouseEvent.CLICK, comFrimHandler);
            alert.btnCancel.removeEventListener(MouseEvent.CLICK, cancelHandler);
            alert.dispose();
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        private function effectCom():void{
        }
        public function get Enabled():Boolean{
            return (true);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:Object;
            var _local4:Object;
            switch (_arg1.getName()){
                case EventList.SHOWALERT:
                    _local2 = _arg1.getBody();
                    altertQuene.push(_local2);
                    if (!isShow){
                        showAlert(_arg1.getBody());
                    };
                    break;
                case EventList.CLOSEALERT:
                    if (isShow){
                        panelCloseHandler();
                    };
                    if (isVerification){
                        VerificationData.AlertID = 0;
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
        private function panelCloseHandler():void{
            if (alert == null){
                return;
            };
            if (worldMap == 1){
                if (GameCommonData.GameInstance.WorldMap.contains(alert)){
                    if (extendsFn != null){
                        if (params_extendsFn){
                            extendsFn(params_extendsFn);
                        } else {
                            extendsFn();
                        };
                        extendsFn = null;
                    };
                    isShow = false;
                    alert.close();
                    altertQuene.shift();
                    comfirmFn = null;
                    cancelFn = null;
                    params = null;
                    params_cancel = null;
                    params_extendsFn = null;
                    extendsFn = null;
                    isShowClose = true;
                    isVerification = false;
                    warning = false;
                    warning = false;
                    title = "提 示";
                    comfirmTxt = "确 认";
                    cancelTxt = "取 消";
                    doExtends = 0;
                    worldMap = 1;
                };
            } else {
                if (GameCommonData.GameInstance.GameUI.contains(alert)){
                    if (extendsFn != null){
                        if (params_extendsFn){
                            extendsFn(params_extendsFn);
                        } else {
                            extendsFn();
                        };
                        extendsFn = null;
                    };
                    isShow = false;
                    alert.close();
                    altertQuene.shift();
                    comfirmFn = null;
                    cancelFn = null;
                    params = null;
                    params_cancel = null;
                    params_extendsFn = null;
                    isShowBg = true;
                    extendsFn = null;
                    isShowClose = true;
                    isVerification = false;
                    title = "提 示";
                    comfirmTxt = "确 认";
                    cancelTxt = "取 消";
                    doExtends = 0;
                    worldMap = 1;
                };
            };
            dispose();
            this.viewComponent = null;
            if (altertQuene.length > 0){
                showAlert(altertQuene[0]);
                return;
            };
            if (((dataProxy.TradeIsOpen) || ((((StallConstData.stallIdToQuery == GameCommonData.Player.Role.Id)) && ((StallConstData.stallIdToQuery > 0)))))){
                return;
            };
            cancelUpdate();
            UIConstData.KeyBoardCanUse = true;
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        private function showAlert(_arg1:Object):void{
            if (!_arg1){
                return;
            };
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            isShow = true;
            facade.sendNotification(EventList.GETRESOURCE, {
                type:UIConfigData.MOVIECLIP,
                mediator:this,
                name:UIConfigData.ALERTTEXTVIEW
            });
            info = _arg1.info;
            comfirmFn = (_arg1.comfrim as Function);
            cancelFn = (_arg1.cancel as Function);
            extendsFn = (_arg1.extendsFn as Function);
            if (_arg1.title){
                title = _arg1.title;
            };
            if (_arg1.params){
                params = _arg1.params;
            };
            if (_arg1.comfirmTxt){
                comfirmTxt = _arg1.comfirmTxt;
            };
            if (_arg1.cancelTxt){
                cancelTxt = _arg1.cancelTxt;
            };
            if (_arg1.isShowClose != undefined){
                isShowClose = _arg1.isShowClose;
            };
            if (_arg1.isVerification != undefined){
                isVerification = _arg1.isVerification;
            };
            if (_arg1.warning != undefined){
                warning = _arg1.warning;
            };
            if (_arg1.doExtends){
                doExtends = _arg1.doExtends;
            };
            if (_arg1.params_cancel){
                params_cancel = _arg1.params_cancel;
            };
            if (_arg1.params_extendsFn){
                params_extendsFn = _arg1.params_extendsFn;
            };
            if (_arg1.worldMap){
                worldMap = _arg1.worldMap;
            };
            if (_arg1.delayTime){
                delayTime = _arg1.delayTime;
            } else {
                delayTime = -1;
            };
            if (_arg1.isShowBg != undefined){
                isShowBg = _arg1.isShowBg;
            };
            if (_arg1.autoCloseTime != undefined){
                autoCloseTime = _arg1.autoCloseTime;
            } else {
                autoCloseTime = -1;
            };
            UIConstData.KeyBoardCanUse = false;
            initView();
        }
        private function initView():void{
            setViewComponent(new AlertView(warning));
            if (worldMap == 1){
                GameCommonData.GameInstance.WorldMap.addChild(alert);
            } else {
                GameCommonData.GameInstance.GameUI.addChild(alert);
            };
            alert.titleText = title;
            alert.closeCallBack = panelCloseHandler;
            alert.txtInfo.htmlText = info;
            alert.txtComfrim = comfirmTxt;
            alert.txtCancel = cancelTxt;
            var _local1:int = (alert.txtInfo.width + 60);
            var _local2:int = (alert.txtInfo.height + 90);
            if (warning){
                _local1 = (alert.txtInfo.width + 60);
            };
            _local1 = ((_local1 > 235)) ? _local1 : 235;
            _local2 = ((_local2 > 120)) ? _local2 : 120;
            alert.setSize(_local1, _local2);
            if (!warning){
                alert.txtInfo.x = ((_local1 - alert.txtInfo.width) / 2);
                alert.txtInfo.y = 40;
            } else {
                alert.txtInfo.y = 50;
            };
            ShowMoney.ShowIcon(alert.txtparent, alert.txtInfo, true);
            if (comfirmFn != null){
                alert.btnComfrim.addEventListener(MouseEvent.CLICK, comFrimHandler);
                alert.btnComfrim.x = int((((_local1 / 2) - alert.btnComfrim.width) - 20));
                alert.btnComfrim.y = ((_local2 - alert.btnComfrim.height) - 10);
                alert.txtComfrim = comfirmTxt;
                alert.btnCancel.x = int(((_local1 / 2) + 20));
                alert.btnCancel.y = ((_local2 - alert.btnComfrim.height) - 10);
                alert.txtCancel = cancelTxt;
            };
            if (cancelFn != null){
                alert.btnCancel.addEventListener(MouseEvent.CLICK, cancelHandler);
            } else {
                alert.btnCancel.visible = false;
                alert.btnComfrim.x = int(((alert.frameWidth - alert.btnComfrim.width) / 2));
                alert.btnComfrim.y = ((alert.frameHeight - alert.btnComfrim.height) - 10);
            };
            alert.showClose = isShowClose;
            alert.blackGound = isShowBg;
            alert.x = ((GameCommonData.GameInstance.ScreenWidth - alert.frameWidth) / 2);
            alert.y = ((GameCommonData.GameInstance.ScreenHeight - alert.frameHeight) / 2);
            alert.updateBackBoardLayout();
            if (delayTime > 0){
                alert.txtComfrim = (((comfirmTxt + "(") + (delayTime - localMS)) + ")");
                alert.btnComfrim.x = int(((alert.frameWidth - alert.btnComfrim.width) / 2));
                if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                    GameCommonData.GameInstance.GameUI.Elements.Add(this);
                };
            };
            if (autoCloseTime > 0){
                alert.txtComfrim = (((comfirmTxt + "(") + (autoCloseTime - localMS)) + ")");
                if (cancelFn == null){
                    alert.btnComfrim.x = int(((alert.frameWidth - alert.btnComfrim.width) / 2));
                } else {
                    alert.btnComfrim.x = int(((_local1 / 2) - alert.btnComfrim.width));
                };
                if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                    GameCommonData.GameInstance.GameUI.Elements.Add(this);
                };
            };
            TweenLite.from(alert, 0.2, {
                x:(alert.stage.stageWidth / 2),
                y:(alert.stage.stageHeight / 2),
                scaleX:0.3,
                scaleY:0.3,
                onComplete:effectCom
            });
        }
        private function cancelHandler(_arg1:MouseEvent):void{
            if (params_cancel){
                cancelFn(params_cancel);
            } else {
                if (cancelFn != null){
                    cancelFn();
                };
            };
            if (((!((extendsFn == null))) && ((doExtends == 0)))){
                if (params_extendsFn){
                    extendsFn(params_extendsFn);
                } else {
                    extendsFn();
                };
                extendsFn = null;
            } else {
                extendsFn = null;
            };
            panelCloseHandler();
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWALERT, EventList.CLOSEALERT]);
        }
        private function cancelUpdate():void{
            localMS = 0;
            delayTime = -1;
            if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) != -1){
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }

    }
}//package GameUI.Modules.Alert 
