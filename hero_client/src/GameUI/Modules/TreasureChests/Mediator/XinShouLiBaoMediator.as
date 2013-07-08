//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.TreasureChests.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;

    public class XinShouLiBaoMediator extends Mediator {

        public static const NAME:String = "XinShouLiBaoMediator";

        private var inputTips:TextField;
        private var dataProxy:DataProxy;
        private var getTips:TextField;
        private var linkID:int;
        private var inputText:TextField;
        private var npcID:uint;

        public function XinShouLiBaoMediator(){
            super(NAME);
            fuckView();
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOW_NEW_GIFT]);
        }
        private function get xinshow():HFrame{
            return ((viewComponent as HFrame));
        }
        private function onClose():void{
            if (xinshow.parent){
                GameCommonData.GameInstance.GameUI.removeChild(xinshow);
            };
            dataProxy.NewGiftIsOpen = false;
        }
        private function fuckView():void{
            var _local1:HFrame;
            var _local2:Sprite;
            _local1 = new HFrame();
            setViewComponent(_local1);
            _local1.closeCallBack = onClose;
            _local1.showClose = true;
            _local1.titleText = LanguageMgr.GetTranslation("礼品兑换");
            _local1.centerTitle = true;
            _local1.blackGound = true;
            _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("NewGift");
            inputText = _local2["input"];
            inputText.type = TextFieldType.INPUT;
            inputText.text = "";
            inputText.restrict = "0-9a-zA-Z";
            inputText.maxChars = 64;
            _local1.addChild(_local2);
            _local2.y = 15;
            inputTips = _local2["inputtips"];
            getTips = _local2["gettips"];
            inputTips.autoSize = TextFieldAutoSize.LEFT;
            _local1.setSize(420, 130);
            _local1.x = ((GameCommonData.GameInstance.ScreenWidth - 394) / 2);
            _local1.y = ((GameCommonData.GameInstance.ScreenHeight - 115) / 2);
            var _local3:HLabelButton = new HLabelButton();
            _local3.label = LanguageMgr.GetTranslation("领取礼品");
            _local1.addChild(_local3);
            _local3.addEventListener(MouseEvent.CLICK, onGetGift);
            _local3.x = 315;
            _local3.y = 66;
        }
        private function onGetGift(_arg1:MouseEvent):void{
            var _local2:String;
            if (inputText.text != ""){
                _local2 = inputText.text;
                _local2 = _local2.toLocaleLowerCase();
                NPCChatSend.SelectOption(npcID, linkID, _local2);
                facade.sendNotification(EventList.SHOW_GET_GIFT_EFFECT);
                onClose();
            };
        }
        private function shownimei(_arg1:INotification):void{
            GameCommonData.GameInstance.GameUI.addChild(xinshow);
            this.inputText.text = "";
            var _local2:Object = _arg1.getBody();
            this.inputTips.text = _local2.boxMessage;
            this.linkID = _local2.linkId;
            this.npcID = _local2.npcID;
            dataProxy.NewGiftIsOpen = true;
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.SHOW_NEW_GIFT:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    shownimei(_arg1);
                    break;
                default:
                    trace("你妹");
            };
        }

    }
}//package GameUI.Modules.TreasureChests.Mediator 
