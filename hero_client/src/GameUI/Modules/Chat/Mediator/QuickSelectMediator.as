//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import OopsEngine.Graphics.*;
    import flash.system.*;

    public class QuickSelectMediator extends Mediator {

        public static const NAME:String = "QuickSelectMediator";

        private var container:ListComponent = null;
        private var curSendId:uint;
        private var ownerItemId:uint;
        private var model:Array;
        private var parent:DisplayObjectContainer;
        private var curName:String = "";
        private var menubackMc:MovieClip;

        public function QuickSelectMediator(_arg1:DisplayObjectContainer=null){
            model = [LanguageMgr.GetTranslation("查看信息"), LanguageMgr.GetTranslation("加为好友"), LanguageMgr.GetTranslation("设为私聊"), LanguageMgr.GetTranslation("复制姓名"), LanguageMgr.GetTranslation("邀请入队"), LanguageMgr.GetTranslation("查看宠物"), LanguageMgr.GetTranslation("屏蔽发言")];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([ChatEvents.SHOWQUICKOPERATOR, ChatEvents.HIDEQUICKOPERATOR]);
        }
        private function removeList(_arg1:MouseEvent):void{
            if (_arg1.target.name == "selectBtn"){
                return;
            };
            GameCommonData.GameInstance.TooltipLayer.removeEventListener(MouseEvent.MOUSE_DOWN, removeList);
            removeThis();
        }
        private function setView():void{
            var _local1:MovieClip;
            var _local2:int;
            menubackMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("menuBack");
            ChatData.QuickChatIsOpen = true;
            container = new ListComponent();
            container.Offset = 0;
            container.name = "QuickSelectList";
            container.setBackVisible(false);
            menubackMc.addChild(container);
            while (_local2 < model.length) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("QuickOperator");
                _local1.txtOpName.text = model[_local2];
                _local1.txtOpName.mouseEnabled = false;
                _local1.txtOpName.filters = Font.Stroke(0);
                _local1.name = _local2.toString();
                _local1.addEventListener(MouseEvent.CLICK, onSelect);
                container.SetChild(_local1);
                _local2++;
            };
            container.upDataPos();
            GameCommonData.GameInstance.TooltipLayer.addChild(menubackMc);
            GameCommonData.GameInstance.TooltipLayer.addChild(container);
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_DOWN, removeList);
            container.x = GameCommonData.GameInstance.TooltipLayer.mouseX;
            container.y = (GameCommonData.GameInstance.TooltipLayer.mouseY - container.height);
            menubackMc.width = 104;
            menubackMc.height = (container.height + 6);
            menubackMc.x = (container.x - 2);
            menubackMc.y = (container.y - 3);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case ChatEvents.SHOWQUICKOPERATOR:
                    curName = (_arg1.getBody().name as String);
                    curSendId = uint(_arg1.getBody().sendId);
                    ownerItemId = uint(_arg1.getBody().ownerItemId);
                    if (_arg1.getBody().model){
                        this.model = _arg1.getBody().model;
                    };
                    setView();
                    break;
                case ChatEvents.HIDEQUICKOPERATOR:
                    removeThis();
                    break;
            };
        }
        private function removeThis():void{
            if (container){
                if (GameCommonData.GameInstance.TooltipLayer.contains(container)){
                    ChatData.QuickChatIsOpen = false;
                    GameCommonData.GameInstance.TooltipLayer.removeChild(menubackMc);
                    GameCommonData.GameInstance.TooltipLayer.removeChild(container);
                    container = null;
                    facade.removeMediator(NAME);
                };
            };
        }
        private function onSelect(_arg1:MouseEvent):void{
            var _local2:String = _arg1.currentTarget.txtOpName.text;
            switch (_local2){
                case "查看信息":
                    FriendSend.getFriendInfo(this.curSendId, 0);
                    break;
                case "加为好友":
                    facade.sendNotification(FriendCommandList.ADD_TO_FRIEND, {
                        id:-1,
                        name:curName
                    });
                    break;
                case "设为私聊":
                    if (curName != GameCommonData.Player.Role.Name){
                        facade.sendNotification(ChatEvents.QUICKCHAT, curName);
                    };
                    break;
                case "复制姓名":
                    System.setClipboard(curName);
                    break;
                case "邀请入队":
                    sendNotification(EventList.INVITETEAM, {id:curSendId});
                    break;
                case "查看宠物":
                    if (curSendId == ownerItemId){
                        FriendSend.getFriendInfo(this.curSendId, 2);
                    } else {
                        GetPetInfoSend.sendRequest(ownerItemId);
                    };
                    break;
                case "屏蔽发言":
                    facade.sendNotification(FriendCommandList.ADD_BLACK, {name:curName});
                    break;
            };
            removeThis();
        }

    }
}//package GameUI.Modules.Chat.Mediator 
