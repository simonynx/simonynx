//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Verification.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.Modules.Verification.Data.*;
    import flash.ui.*;
    import GameUI.*;

    public class VerificationUIMediator extends Mediator {

        public static const STARTPOS:Point = new Point(420, 350);
        public static const NAME:String = "VerificationUIMediator";

        private var verificationView1:VerificationView1;
        private var verificationView2:VerificationView2;
        private var verificationView3:VerificationView3;
        private var invervalID:uint;
        private var alertID:uint;

        public function VerificationUIMediator(){
            super(NAME);
        }
        private function confirm():void{
            var _local1:Sprite = new Sprite();
            _local1.graphics.beginFill(0);
            _local1.graphics.drawRect(-1000, -1000, 3000, 3000);
            _local1.graphics.endFill();
            GameCommonData.GameInstance.addChild(_local1);
            var _local2:URLRequest = new URLRequest(GameConfigData.LoginUrl);
            navigateToURL(_local2);
        }
        private function checkId():Boolean{
            var _local1:String = String(verificationView2.txtIdentity.text);
            if (_local1 == ""){
                MessageTip.show(LanguageMgr.GetTranslation("身份证号码不能为空!"));
                return (false);
            };
            if (_local1.length < 15){
                MessageTip.show(LanguageMgr.GetTranslation("请正确填写身份证号码"));
                return (false);
            };
            var _local2:int = int(_local1.substr(6, 4));
            if ((((_local2 < 1900)) || ((_local2 > 2011)))){
                MessageTip.show(LanguageMgr.GetTranslation("请正确填写身份证号码"));
                return (false);
            };
            _local2 = int(_local1.substr(10, 2));
            if ((((_local2 == 0)) || ((_local2 > 12)))){
                MessageTip.show(LanguageMgr.GetTranslation("请正确填写身份证号码"));
                return (false);
            };
            _local2 = int(_local1.substr(12, 2));
            if ((((_local2 == 0)) || ((_local2 > 31)))){
                MessageTip.show(LanguageMgr.GetTranslation("请正确填写身份证号码"));
                return (false);
            };
            var _local3:RegExp = /[a-z]/;
            if (_local3.test(_local1.substr(0, (_local1.length - 1)))){
                MessageTip.show(LanguageMgr.GetTranslation("请正确填写身份证"));
                return (false);
            };
            return (true);
        }
        private function closeAlert():void{
            if (VerificationData.AlertID > 0){
                facade.sendNotification(EventList.CLOSEALERT);
                clearInterval(VerificationData.AlertID);
                VerificationData.AlertID = 0;
            };
        }
        private function onKeyDown(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.TAB){
                if (_arg1.currentTarget == verificationView2.txtPlayerName){
                    verificationView2.stage.focus = verificationView2.txtIdentity;
                } else {
                    if (_arg1.currentTarget == verificationView2.txtIdentity){
                        verificationView2.stage.focus = verificationView2.txtPlayerName;
                    };
                };
                _arg1.stopImmediatePropagation();
            };
        }
        private function closeGame():void{
            facade.sendNotification(EventList.CLOSEALERT);
            clearInterval(invervalID);
            if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_CN){
                facade.sendNotification(EventList.SHOW_OFFLINETIP);
            };
        }
        private function onRecieverLoad(_arg1:Event):void{
            switch (int(_arg1.currentTarget.data)){
                case 1:
                    MessageTip.show(LanguageMgr.GetTranslation("成功登记并且年龄超过18岁"));
                    break;
                case 2:
                    MessageTip.show(LanguageMgr.GetTranslation("成功登记但年龄没有超过18岁"));
                    break;
                case -1:
                    MessageTip.show(LanguageMgr.GetTranslation("参数不全"));
                    break;
                case -2:
                    MessageTip.show(LanguageMgr.GetTranslation("验证失败"));
                    break;
                case -3:
                    MessageTip.show(LanguageMgr.GetTranslation("身份证号码无效"));
                    break;
                case -4:
                    MessageTip.show(LanguageMgr.GetTranslation("不允许重复登记"));
                    break;
                case -5:
                    MessageTip.show(LanguageMgr.GetTranslation("登记失败"));
                    break;
                case -6:
                    MessageTip.show(LanguageMgr.GetTranslation("用户不存在"));
                    break;
                default:
                    MessageTip.show(LanguageMgr.GetTranslation("平台未处理其他服仍然验证"));
            };
        }
        private function sure():void{
            if (VerificationData.TimeLimitFlag == VerificationData.TIME_LIMIT_NEED_RECHARGE){
                confirm();
            } else {
                if (VerificationData.TimeLimitFlag == VerificationData.TIME_LIMIT_NOTIMELEFT){
                    confirm();
                };
            };
        }
        private function btnInputHandler(_arg1:MouseEvent):void{
            var _local2:String;
            switch (_arg1.target.parent.name){
                case "btnView1FillIn":
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW1);
                    facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW2);
                    break;
                case "btnView1UnderAge":
                    if (VerificationData.TimeLimitFlag != VerificationData.TIME_LIMIT_NOTIMELEFT){
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:sure,
                            cancel:null,
                            isShowClose:false,
                            info:LanguageMgr.GetTranslation("不健康游戏提示句8"),
                            title:LanguageMgr.GetTranslation("警 告"),
                            comfirmTxt:LanguageMgr.GetTranslation("确定"),
                            cancelTxt:LanguageMgr.GetTranslation("取消")
                        });
                    } else {
                        facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW3);
                    };
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW1);
                    break;
                case "btnView2OK":
                    if (verificationView2.txtPlayerName.text == ""){
                        MessageTip.show(LanguageMgr.GetTranslation("玩家名称不能为空"));
                        return;
                    };
                    if (verificationView2.txtPlayerName.text.length < 2){
                        MessageTip.show(LanguageMgr.GetTranslation("请正确填写姓名"));
                        return;
                    };
                    if (checkId()){
                        _local2 = String(verificationView2.txtIdentity.text);
                        if (int(_local2.substr(6, 4)) <= 1993){
                            VerificationSend.requestIdentify(String(verificationView2.txtIdentity.text), true);
                        } else {
                            VerificationSend.requestIdentify(String(verificationView2.txtIdentity.text), false);
                        };
                        sendURLLoginPhp(GameCommonData.Player.Role.Name, verificationView2.txtPlayerName.text, _local2);
                    };
                    break;
                case "btnView2Cancel":
                    if (VerificationData.TimeLimitFlag != VerificationData.TIME_LIMIT_NOTIMELEFT){
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:sure,
                            cancel:null,
                            isShowClose:false,
                            info:LanguageMgr.GetTranslation("不健康游戏提示句8"),
                            title:LanguageMgr.GetTranslation("警 告"),
                            comfirmTxt:LanguageMgr.GetTranslation("确定"),
                            cancelTxt:LanguageMgr.GetTranslation("取消")
                        });
                    } else {
                        facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW3);
                    };
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW2);
                    break;
                case "btnView3OK":
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW3);
                    break;
            };
        }
        private function showAlert(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false):void{
            if ((((VerificationData.VerificationType == VerificationData.ANTIWALLOW_CN)) || (_arg3))){
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation(_arg1),
                    title:LanguageMgr.GetTranslation("警 告"),
                    comfirmTxt:LanguageMgr.GetTranslation("确定"),
                    cancelTxt:LanguageMgr.GetTranslation("取消")
                });
                if (_arg2){
                    VerificationData.AlertID = setInterval(closeAlert, 60000);
                };
            } else {
                _arg1 = (LanguageMgr.GetTranslation("越南") + _arg1);
                facade.sendNotification(HelpTipsNotiName.HELPTIPS_MMSHOW, {
                    content:LanguageMgr.GetTranslation(_arg1),
                    align:TextFormatAlign.LEFT,
                    title:LanguageMgr.GetTranslation("温馨提示")
                });
            };
        }
        override public function listNotificationInterests():Array{
            return ([VerificationEvent.SHOW_VERIFICATION_VIEW1, VerificationEvent.SHOW_VERIFICATION_VIEW2, VerificationEvent.SHOW_VERIFICATION_VIEW3, VerificationEvent.CLOSE_VERIFICATION_VIEW1, VerificationEvent.CLOSE_VERIFICATION_VIEW2, VerificationEvent.CLOSE_VERIFICATION_VIEW3, VerificationEvent.VERIFICATION_NOTPASS]);
        }
        private function inputHandler(_arg1:Event):void{
            var _local2:String;
            _local2 = verificationView2.txtIdentity.text.replace(/^\s*|\s*$""^\s*|\s*$/g, "").split(" ").join("");
            if (_local2){
                verificationView2.txtIdentity.text = UIUtils.getTextByCharLength(_local2, 18);
            };
        }
        private function removeLis():void{
            if (verificationView1){
                verificationView1.btnFillIn.removeEventListener(MouseEvent.CLICK, btnInputHandler);
                verificationView1.btnUnderAge.removeEventListener(MouseEvent.CLICK, btnInputHandler);
            } else {
                if (verificationView2){
                    verificationView2.btnOK.removeEventListener(Event.CHANGE, btnInputHandler);
                    verificationView2.btnCancel.removeEventListener(Event.CHANGE, btnInputHandler);
                    verificationView2.txtIdentity.removeEventListener(Event.CHANGE, inputHandler);
                    verificationView2.txtPlayerName.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                    verificationView2.txtIdentity.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                } else {
                    if (verificationView3){
                        verificationView3.btnOK.removeEventListener(MouseEvent.CLICK, btnInputHandler);
                    };
                };
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            trace(("" + _arg1.getName()));
            switch (_arg1.getName()){
                case VerificationEvent.SHOW_VERIFICATION_VIEW1:
                    verificationView1 = new VerificationView1();
                    addLis();
                    verificationView1.x = ((GameCommonData.GameInstance.ScreenWidth - (verificationView1.content.width + 40)) / 2);
                    verificationView1.y = ((GameCommonData.GameInstance.ScreenHeight - (verificationView1.content.height + 190)) / 2);
                    GameCommonData.GameInstance.WorldMap.addChild(verificationView1);
                    UIConstData.KeyBoardCanUse = false;
                    break;
                case VerificationEvent.SHOW_VERIFICATION_VIEW2:
                    if (GameConfigData.VerificationPath != ""){
                        navigateToURL(new URLRequest(GameConfigData.VerificationPath), "_blank");
                    } else {
                        verificationView2 = new VerificationView2();
                        verificationView2.x = ((GameCommonData.GameInstance.ScreenWidth - (verificationView2.contentSprite.width + 40)) / 2);
                        verificationView2.y = ((GameCommonData.GameInstance.ScreenHeight - (verificationView2.contentSprite.height + 90)) / 2);
                        addLis();
                        GameCommonData.GameInstance.WorldMap.addChild(verificationView2);
                    };
                    UIConstData.KeyBoardCanUse = false;
                    break;
                case VerificationEvent.SHOW_VERIFICATION_VIEW3:
                    switch (VerificationData.TimeLimitFlag){
                        case VerificationData.TIME_LIMIT_5_MIN:
                            facade.sendNotification(EventList.CLOSEALERT);
                            showAlert("5分钟进入沉迷状态", true, true);
                            break;
                        case VerificationData.TIME_LIMIT_NOTIMELEFT:
                            if (GameCommonData.Player.IsAutomatism){
                                facade.sendNotification(AutoPlayEventList.QUICK_AUTO_PLAY);
                            };
                            facade.sendNotification(EventList.CLOSEALERT);
                            if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_CN){
                                showAlert("您已进入不健康游戏时间提示句", false, true);
                                invervalID = setInterval(closeGame, 60000);
                            } else {
                                if (VerificationData.PlayTime >= 18000){
                                    showAlert("不健康游戏提示句2");
                                } else {
                                    showAlert("不健康游戏提示句3");
                                };
                            };
                            break;
                        case VerificationData.TIME_LIMIT_NEED_RECHARGE:
                            facade.sendNotification(EventList.CLOSEALERT);
                            showAlert("不健康游戏提示句4", true);
                            break;
                        case VerificationData.TIME_LIMIT_1_HOUR:
                            facade.sendNotification(EventList.CLOSEALERT);
                            showAlert("不健康游戏提示句5", true);
                            break;
                        case VerificationData.TIME_LIMIT_2_HOUR:
                            showAlert("不健康游戏提示句6", true);
                            break;
                    };
                    UIConstData.KeyBoardCanUse = false;
                    break;
                case VerificationEvent.CLOSE_VERIFICATION_VIEW1:
                    removeLis();
                    verificationView1.close();
                    verificationView1 = null;
                    UIConstData.KeyBoardCanUse = true;
                    break;
                case VerificationEvent.CLOSE_VERIFICATION_VIEW2:
                    removeLis();
                    if (verificationView2){
                        verificationView2.close();
                    };
                    verificationView2 = null;
                    UIConstData.KeyBoardCanUse = true;
                    break;
                case VerificationEvent.CLOSE_VERIFICATION_VIEW3:
                    if ((((VerificationData.TimeLimitFlag == VerificationData.TIME_LIMIT_NOTIMELEFT)) || ((VerificationData.TimeLimitFlag == VerificationData.TIME_LIMIT_NEED_RECHARGE)))){
                        VerificationSend.requestIdentify("", false);
                    };
                    removeLis();
                    if (verificationView3){
                        verificationView3.close();
                    };
                    verificationView3 = null;
                    UIConstData.KeyBoardCanUse = true;
                    break;
                case VerificationEvent.VERIFICATION_NOTPASS:
                    showAlert("不健康游戏提示句7", false, true);
                    break;
            };
        }
        private function addLis():void{
            if (verificationView1){
                verificationView1.btnFillIn.addEventListener(MouseEvent.CLICK, btnInputHandler);
                verificationView1.btnUnderAge.addEventListener(MouseEvent.CLICK, btnInputHandler);
            } else {
                if (verificationView2){
                    verificationView2.txtPlayerName.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                    verificationView2.txtIdentity.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                    verificationView2.btnOK.addEventListener(MouseEvent.CLICK, btnInputHandler);
                    verificationView2.btnCancel.addEventListener(MouseEvent.CLICK, btnInputHandler);
                    verificationView2.txtIdentity.addEventListener(Event.CHANGE, inputHandler);
                    verificationView2.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
                } else {
                    if (verificationView3){
                        verificationView3.btnOK.addEventListener(MouseEvent.CLICK, btnInputHandler);
                    };
                };
            };
        }
        private function sendURLLoginPhp(_arg1:String, _arg2:String, _arg3:String):void{
            var _local4 = (GameCommonData.GameInstance.Content.RootDirectory + "../hoho_admin/interface/export/fcm_api.php?");
            _local4 = ((_local4 + "account=") + _arg1);
            _local4 = ((_local4 + "&truename=") + _arg2);
            _local4 = ((_local4 + "&card=") + _arg3);
            var _local5:URLRequest = new URLRequest(_local4);
            _local5.method = URLRequestMethod.POST;
            var _local6:URLLoader = new URLLoader();
            _local6.addEventListener(Event.COMPLETE, onRecieverLoad);
            _local6.load(_local5);
        }
        private function onKeyUp(_arg1:KeyboardEvent):void{
        }

    }
}//package GameUI.Modules.Verification.Mediator 
