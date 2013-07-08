//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Hint.Events.*;
    import OopsEngine.Graphics.*;

    public class SelectChanalMediator extends Mediator {

        public static const STARTPOSX:Number = 0;
        public static const SELECTCHANNEL:String = "SelectChanalMediator";
        public static const CONTACT_DEFAULT_POS:Point = new Point(365, 200);
        public static const STARTPOSY:Number = 556.5;

        private var container:ListComponent = null;
        private var contactPanel:RecentChatView;

        public function SelectChanalMediator(){
            super(SELECTCHANNEL);
            this.setViewComponent(container);
        }
        override public function listNotificationInterests():Array{
            return ([ChatEvents.OPENCHANNEL, ChatEvents.CLOSESELECTCHANNEL, ChatEvents.GET_PRIVATE_NAME, EventList.RESIZE_STAGE]);
        }
        private function removeList(_arg1:MouseEvent):void{
            if ((((((_arg1.target.name == "btnChang")) || ((_arg1.target.name == "btnSelectCh")))) || ((_arg1.target.name == "selectChanelBtn")))){
                return;
            };
            GameCommonData.GameInstance.TooltipLayer.removeEventListener(MouseEvent.MOUSE_DOWN, removeList);
            if (container){
                if (GameCommonData.GameInstance.GameUI.contains(container)){
                    GameCommonData.GameInstance.GameUI.removeChild(container);
                    container = null;
                    ChatData.SelectChannelOpen = false;
                };
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case ChatEvents.OPENCHANNEL:
                    ChatData.SelectChannelOpen = true;
                    setView();
                    break;
                case ChatEvents.CLOSESELECTCHANNEL:
                    if (GameCommonData.GameInstance.GameUI.contains(container)){
                        GameCommonData.GameInstance.GameUI.removeChild(container);
                        container = null;
                        ChatData.SelectChannelOpen = false;
                    };
                    break;
                case ChatEvents.GET_PRIVATE_NAME:
                    if (_arg1.getBody().name != ""){
                        contactPanel.content.txtInputName.text = _arg1.getBody().name;
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    if (container){
                        container.y = ((GameCommonData.GameInstance.ScreenHeight - container.height) - 20);
                    };
                    break;
            };
        }
        private function setView():void{
            var _local1:MovieClip;
            var _local2:int;
            container = new ListComponent();
            while (_local2 < LanguageMgr.channelModel.length) {
                if (LanguageMgr.channelModel[_local2] == undefined){
                } else {
                    _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Channel");
                    _local1.txtInfo.htmlText = LanguageMgr.channelModel[_local2].label;
                    _local1.txtInfo.filters = Font.Stroke(0);
                    _local1.txtInfo.mouseEnabled = false;
                    _local1.name = _local2.toString();
                    _local1.addEventListener(MouseEvent.CLICK, onChannelClick);
                    container.SetChild(_local1);
                };
                _local2++;
            };
            container.upDataPos();
            GameCommonData.GameInstance.GameUI.addChild(container);
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_DOWN, removeList);
            container.x = STARTPOSX;
            container.y = ((GameCommonData.GameInstance.ScreenHeight - container.height) - 20);
        }
        private function gcContactPanel():void{
            if (GameCommonData.GameInstance.GameUI.contains(contactPanel)){
                GameCommonData.GameInstance.GameUI.removeChild(contactPanel);
            };
            removeLis();
            facade.sendNotification(ChatEvents.CLOSECONTACTLIST);
            facade.sendNotification(ChatEvents.UNLOCKCHAT);
        }
        private function showContactPanel():void{
            if (GameCommonData.GameInstance.GameUI.contains(contactPanel)){
                contactPanel.x = CONTACT_DEFAULT_POS.x;
                contactPanel.y = CONTACT_DEFAULT_POS.y;
            } else {
                GameCommonData.GameInstance.GameUI.addChild(contactPanel);
                addLis();
                facade.sendNotification(ChatEvents.LOCKCHAT);
            };
            contactPanel.content.txtInputName.text = "";
            contactPanel.content.txtInputName.width = 108;
            contactPanel.content.txtInputName.maxChars = 8;
        }
        private function removeLis():void{
            contactPanel.content.getChildByName("_btnInputSure").removeEventListener(MouseEvent.CLICK, btnClickHandler);
            contactPanel.content.getChildByName("_btnInputCancel").removeEventListener(MouseEvent.CLICK, btnClickHandler);
            contactPanel.content.getChildByName("_btnRecent").removeEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function initContactPanel():void{
            if (contactPanel != null){
                gcContactPanel();
            };
            contactPanel = new RecentChatView();
            contactPanel.closeCallBack = contactCloseHandler;
            UIUtils.addFocusLis(contactPanel.content.txtInputName);
        }
        private function addLis():void{
            contactPanel.content.getChildByName("_btnInputSure").addEventListener(MouseEvent.CLICK, btnClickHandler);
            contactPanel.content.getChildByName("_btnInputCancel").addEventListener(MouseEvent.CLICK, btnClickHandler);
            contactPanel.content.getChildByName("_btnRecent").addEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function contactCloseHandler():void{
            gcContactPanel();
        }
        private function onChannelClick(_arg1:MouseEvent):void{
            var _local2:int;
            if (GameCommonData.GameInstance.GameUI.contains(container)){
                GameCommonData.GameInstance.GameUI.removeChild(container);
                container = null;
                _local2 = int(_arg1.currentTarget.name);
                if (ChatData.curSelectModel != _local2){
                    ChatData.curSelectModel = _local2;
                    facade.sendNotification(ChatEvents.SETCHANNEL);
                };
                ChatData.SelectChannelOpen = false;
            };
            if (ChatData.curSelectModel == 2){
                initContactPanel();
                showContactPanel();
            };
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            switch (_arg1.currentTarget.name){
                case "_btnRecent":
                    if (!ChatData.ContactListOpen){
                        facade.sendNotification(ChatEvents.OPENCONTACTLIST);
                    } else {
                        facade.sendNotification(ChatEvents.CLOSECONTACTLIST);
                    };
                    break;
                case "_btnInputSure":
                    if (contactPanel.content.txtInputName.text == ""){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("玩家名称不能为空"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    facade.sendNotification(ChatEvents.SET_PRIVATE_NAME, {name:contactPanel.content.txtInputName.text});
                    gcContactPanel();
                    break;
                case "_btnInputCancel":
                    gcContactPanel();
                    break;
            };
        }

    }
}//package GameUI.Modules.Chat.Mediator 
