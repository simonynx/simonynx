//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import OopsEngine.Graphics.*;

    public class ContactListMediator extends Mediator {

        public static const NAME:String = "ContactListMediator";
        public static const DEFAULT_POS:Point = new Point(420, 260);

        private var listView:ListComponent = null;
        private var choiceView:MovieClip = null;
        private var iScrollPane:UIScrollPane;

        public function ContactListMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([ChatEvents.OPENCONTACTLIST, ChatEvents.CLOSECONTACTLIST, ChatEvents.ADDTOCONTACTLIST]);
        }
        private function showContactList():void{
            var _local1:Object;
            var _local2:MovieClip;
            for (_local1 in ChatData.ContactList) {
                _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ListItem");
                _local2.name = ("contactListChoice_" + _local1);
                _local2.mcSelected.visible = false;
                _local2.txtName.mouseEnabled = false;
                _local2.mcSelected.mouseEnabled = false;
                _local2.doubleClickEnabled = true;
                _local2.btnChosePlayer.mouseEnabled = false;
                _local2.txtName.text = ChatData.ContactList[_local1];
                _local2.addEventListener(MouseEvent.CLICK, selectItem);
                _local2.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickItem);
                listView.addChild(_local2);
            };
            listView.width = 100;
            listView.upDataPos();
        }
        private function gcPanel():void{
            if (GameCommonData.GameInstance.GameUI.contains(viewUI)){
                GameCommonData.GameInstance.GameUI.removeChild(viewUI);
            };
            ChatData.ContactListOpen = false;
        }
        private function doubleClickItem(_arg1:MouseEvent):void{
            var _local2:* = (_arg1.currentTarget as MovieClip);
            var _local3:String = _local2.name.split("_")[1];
            if (_local3 != ""){
                facade.sendNotification(ChatEvents.GET_PRIVATE_NAME, {name:ChatData.ContactList[_local3]});
            };
            gcPanel();
        }
        private function choiceCloseHandler():void{
            gcPanel();
        }
        private function setView():void{
            setViewComponent(new ContactListView());
            viewUI.closeCallBack = choiceCloseHandler;
            listView = new ListComponent(false);
            showContactList();
            iScrollPane = new UIScrollPane(listView);
            iScrollPane.x = 0;
            iScrollPane.y = 3;
            iScrollPane.width = 110;
            iScrollPane.height = 135;
            iScrollPane.scrollPolicy = UIScrollPane.SCROLLBAR_ALWAYS;
            iScrollPane.refresh();
            viewUI.content.addChild(iScrollPane);
            if (!GameCommonData.GameInstance.GameUI.contains(viewUI)){
                GameCommonData.GameInstance.GameUI.addChild(viewUI);
            };
            ChatData.ContactListOpen = true;
        }
        private function selectItem(_arg1:MouseEvent):void{
            var _local2:* = (_arg1.currentTarget as MovieClip);
            var _local3:* = _local2.name.split("_")[1];
            var _local4:int;
            while (_local4 < listView.numChildren) {
                (listView.getChildAt(_local4) as MovieClip).mcSelected.visible = false;
                _local4++;
            };
            _local2.mcSelected.visible = true;
            facade.sendNotification(ChatEvents.GET_PRIVATE_NAME, {name:ChatData.ContactList[_local3]});
        }
        private function get viewUI():ContactListView{
            return ((this.viewComponent as ContactListView));
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case ChatEvents.OPENCONTACTLIST:
                    if (!ChatData.ContactListOpen){
                        setView();
                    };
                    break;
                case ChatEvents.CLOSECONTACTLIST:
                    if (ChatData.ContactListOpen){
                        gcPanel();
                    };
                    break;
                case ChatEvents.ADDTOCONTACTLIST:
                    if (ChatData.ContactList.indexOf(_arg1.getBody().name) != -1){
                        return;
                    };
                    if (ChatData.ContactList.length >= 10){
                        ChatData.ContactList.splice(0, 1);
                    };
                    ChatData.ContactList.push(_arg1.getBody().name);
                    break;
            };
        }

    }
}//package GameUI.Modules.Chat.Mediator 
