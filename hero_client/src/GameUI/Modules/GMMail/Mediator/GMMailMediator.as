//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GMMail.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.*;

    public class GMMailMediator extends Mediator {

        public static const NAME:String = "GMMailMediator";

        private var dataProxy:DataProxy;
        private var greenServiceBtn:ToggleButton;
        private var commonQuestionBtn:ToggleButton;
        private var selectType:uint = 0;
        private var commitQuestionBtn:ToggleButton;

        public function GMMailMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.CLOSE_GMMAIL_UI, EventList.SHOW_GMMAIL_UI, EventList.ENTERMAPCOMPLETE]);
        }
        private function radioClickHandler(_arg1:MouseEvent):void{
            if (_arg1.target.name.split("_")[1] == this.selectType){
                return;
            };
            this.selectType = _arg1.target.name.split("_")[1];
            var _local2:int;
            while (_local2 < 4) {
                gmMail.content[("mcRadio_" + _local2)].gotoAndStop(1);
                _local2++;
            };
            _arg1.currentTarget.gotoAndStop(2);
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == commonQuestionBtn){
                closePanel();
                facade.sendNotification(EventList.SHOW_HELP_UI, {
                    posX:gmMail.x,
                    posY:gmMail.y
                });
                return;
            };
            if (_arg1.currentTarget == greenServiceBtn){
                closePanel();
                facade.sendNotification(EventList.SHOW_HELP_UI, {
                    posX:gmMail.x,
                    posY:gmMail.y,
                    toggleGreenService:true
                });
                return;
            };
            switch (_arg1.target.parent.name){
                case "btnSend":
                    if (gmMail.content.txtContent.text == ""){
                        MessageTip.show(LanguageMgr.GetTranslation("邮件提示17"));
                        return;
                    };
                    if (UIUtils.isPermitedName(gmMail.content.txtContent.text) == false){
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:sure,
                            cancel:null,
                            isShowClose:false,
                            info:LanguageMgr.GetTranslation("邮件提示16")
                        });
                        return;
                    };
                    MailSend.sendMail("GM", LanguageMgr.GetTranslation("问题"), gmMail.content.txtContent.text, (selectType + 1));
                    break;
                case "btnCancel":
                    closePanel();
                    break;
                case "btnFillMoney":
                    if (GameConfigData.GamePay != ""){
                        navigateToURL(new URLRequest(GameConfigData.GamePay));
                    };
                    break;
            };
        }
        private function initViewUI():void{
            setViewComponent(new GMMailView());
            gmMail.closeCallBack = closePanel;
            gmMail.content.txtNotice.selectable = true;
            gmMail.content.txtNotice.text = GameConfigData.GMNotice;
            commonQuestionBtn = new ToggleButton(1, LanguageMgr.GetTranslation("常见问题"));
            commonQuestionBtn.x = 15;
            commonQuestionBtn.y = 34;
            commonQuestionBtn;
            commonQuestionBtn.selected = false;
            commitQuestionBtn = new ToggleButton(1, LanguageMgr.GetTranslation("提交问题"));
            commitQuestionBtn.x = ((commonQuestionBtn.x + commonQuestionBtn.width) + 2);
            commitQuestionBtn.y = 34;
            commitQuestionBtn.selected = true;
        }
        private function sure():void{
        }
        private function contentFocusOut(_arg1:FocusEvent):void{
            UIConstData.FocusIsUsing = false;
        }
        public function radioOne():void{
            var _local1:int;
            while (_local1 < 4) {
                gmMail.content[("mcRadio_" + _local1)].gotoAndStop(1);
                _local1++;
            };
            gmMail.content[("mcRadio_" + this.selectType)].gotoAndStop(2);
        }
        private function get gmMail():GMMailView{
            return ((viewComponent as GMMailView));
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    break;
                case EventList.SHOW_GMMAIL_UI:
                    if (!gmMail){
                        initViewUI();
                    } else {
                        if (((_arg1.getBody()) && (_arg1.getBody().hasOwnProperty("posX")))){
                            gmMail.x = int(_arg1.getBody().posX);
                            gmMail.y = int(_arg1.getBody().posY);
                        } else {
                            gmMail.x = int(((GameCommonData.GameInstance.ScreenWidth / 2) - (gmMail.width / 2)));
                            gmMail.y = int(((GameCommonData.GameInstance.ScreenHeight / 2) - (gmMail.height / 2)));
                        };
                    };
                    if (((((!(greenServiceBtn)) && (GameConfigData.GreenService))) && ((GameCommonData.totalPayMoney >= GameCommonData.goldenAccountNeed)))){
                        greenServiceBtn = new ToggleButton(1, LanguageMgr.GetTranslation("金牌客服"));
                        greenServiceBtn.x = ((commitQuestionBtn.x + commitQuestionBtn.width) + 2);
                        greenServiceBtn.y = 34;
                        commitQuestionBtn.selected = false;
                    };
                    gmMail.addChild(commonQuestionBtn);
                    gmMail.addChild(commitQuestionBtn);
                    if (greenServiceBtn){
                        gmMail.addChild(greenServiceBtn);
                        greenServiceBtn.selected = false;
                        greenServiceBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    };
                    commonQuestionBtn.selected = false;
                    commitQuestionBtn.selected = true;
                    GameCommonData.GameInstance.GameUI.addChild(gmMail);
                    UIUtils.addFocusLis(gmMail.content.txtContent);
                    gmMail.content.txtContent.addEventListener(FocusEvent.FOCUS_IN, contentFocusIn);
                    gmMail.content.txtContent.addEventListener(FocusEvent.FOCUS_OUT, contentFocusOut);
                    gmMail.btnSend.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    gmMail.btnCancel.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    gmMail.btnFillMoney.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    commonQuestionBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    gmMail.content.txtContent.text = "";
                    selectType = 0;
                    while (_local2 < 4) {
                        gmMail.content[("mcRadio_" + _local2)].addEventListener(MouseEvent.CLICK, this.radioClickHandler);
                        _local2++;
                    };
                    radioOne();
                    dataProxy.GMMailIsOpen = true;
                    break;
                case EventList.CLOSE_GMMAIL_UI:
                    closePanel();
                    break;
            };
        }
        private function closePanel():void{
            if (dataProxy.GMMailIsOpen == false){
                return;
            };
            gmMail.removeChild(commonQuestionBtn);
            gmMail.removeChild(commitQuestionBtn);
            if (greenServiceBtn){
                gmMail.removeChild(greenServiceBtn);
            };
            GameCommonData.GameInstance.GameUI.removeChild(gmMail);
            gmMail.btnSend.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            gmMail.btnCancel.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            gmMail.btnFillMoney.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            commonQuestionBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            if (greenServiceBtn){
                greenServiceBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            selectType = 0;
            var _local1:uint;
            while (_local1 < 4) {
                gmMail.content[("mcRadio_" + _local1)].removeEventListener(MouseEvent.CLICK, this.radioClickHandler);
                _local1++;
            };
            dataProxy.GMMailIsOpen = false;
        }
        private function contentFocusIn(_arg1:FocusEvent):void{
            UIConstData.FocusIsUsing = true;
        }

    }
}//package GameUI.Modules.GMMail.Mediator 
