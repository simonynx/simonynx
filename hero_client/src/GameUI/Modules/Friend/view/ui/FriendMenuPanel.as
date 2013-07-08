//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.model.vo.*;

    public class FriendMenuPanel extends Sprite {

        private var bg:MovieClip;
        private var _info:FriendInfoStruct;

        public function FriendMenuPanel(){
            this.name = "FRIEND_MENU";
        }
        private function __clickHandler(_arg1:MouseEvent):void{
            var _local2:String;
            switch (_arg1.currentTarget){
                case bg.chatBtn:
                    _local2 = FriendMenuEvent.TYPE_CHAT;
                    break;
                case bg.copyNameBtn:
                    _local2 = FriendMenuEvent.TYPE_COPYNAME;
                    break;
                case bg.playerInfoBtn:
                    _local2 = FriendMenuEvent.TYPE_PLAYERINFO;
                    break;
                case bg.windowChatBtn:
                    _local2 = FriendMenuEvent.TYPE_WINDOWCHAT;
                    break;
                case bg.inviteTeamBtn:
                    _local2 = FriendMenuEvent.TYPE_INVITETEAM;
                    break;
                case bg.chatHistoryBtn:
                    _local2 = FriendMenuEvent.TYPE_TRACKER;
                    break;
                case bg.addFriendBtn:
                    _local2 = FriendMenuEvent.TYPE_ADDFRIEND;
                    break;
                case bg.deleteBtn:
                    _local2 = FriendMenuEvent.TYPE_DELETEFRIEND;
                    break;
                case bg.blackBtn:
                    _local2 = FriendMenuEvent.TYPE_BLACKFRIEND;
                    break;
                case bg.enemyBtn:
                    _local2 = FriendMenuEvent.TYPE_ENEMYFRIEND;
                    break;
            };
            this.dispatchEvent(new FriendMenuEvent(FriendMenuEvent.Cell_Click, _local2, info));
            dispose();
        }
        public function set info(_arg1:FriendInfoStruct):void{
            this._info = _arg1;
            initView();
            addEvents();
            setData();
            checkRight();
        }
        private function setData():void{
        }
        public function get info():FriendInfoStruct{
            return (_info);
        }
        private function checkRight():void{
            var _local1:Array = [];
            switch (info.type){
                case FriendType.TYPE_FRIEND:
                    _local1 = [bg.chatBtn, bg.windowChatBtn, bg.inviteTeamBtn, bg.playerInfoBtn, bg.chatHistoryBtn, bg.copyNameBtn, bg.deleteBtn, bg.blackBtn, bg.enemyBtn];
                    break;
                case FriendType.TYPE_BLACK:
                    _local1 = [bg.chatBtn, bg.windowChatBtn, bg.inviteTeamBtn, bg.playerInfoBtn, bg.chatHistoryBtn, bg.copyNameBtn, bg.deleteBtn, bg.addFriendBtn, bg.enemyBtn];
                    break;
                case FriendType.TYPE_ENEMY:
                    _local1 = [bg.chatBtn, bg.windowChatBtn, bg.inviteTeamBtn, bg.playerInfoBtn, bg.chatHistoryBtn, bg.copyNameBtn, bg.deleteBtn, bg.addFriendBtn, bg.blackBtn];
                    break;
                case FriendType.TYPE_TEMP:
                    _local1 = [bg.chatBtn, bg.windowChatBtn, bg.inviteTeamBtn, bg.playerInfoBtn, bg.chatHistoryBtn, bg.copyNameBtn, bg.addFriendBtn];
                    break;
            };
            bg.removeChild(bg.chatBtn);
            bg.removeChild(bg.copyNameBtn);
            bg.removeChild(bg.playerInfoBtn);
            bg.removeChild(bg.windowChatBtn);
            bg.removeChild(bg.inviteTeamBtn);
            bg.removeChild(bg.chatHistoryBtn);
            bg.removeChild(bg.addFriendBtn);
            bg.removeChild(bg.deleteBtn);
            bg.removeChild(bg.blackBtn);
            bg.removeChild(bg.enemyBtn);
            var _local2:int;
            var _local3:int;
            while (_local3 < _local1.length) {
                _local1[_local3].x = 6;
                _local1[_local3].y = ((_local3 * 25) + 8);
                _local2 = ((_local3 + 1) * 25);
                bg.addChild(_local1[_local3]);
                _local3++;
            };
            bg.bg.height = (_local2 + 13);
        }
        private function initView():void{
            if (((bg) && (bg.parent))){
                bg.parent.removeChild(bg);
            };
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("shooter.friend.accect.FriendMenuPanel");
            this.addChild(this.bg);
        }
        private function addEvents():void{
            bg.chatBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.copyNameBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.playerInfoBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.windowChatBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.inviteTeamBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.chatHistoryBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.addFriendBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.deleteBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.blackBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            bg.enemyBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
        }
        private function doLayout():void{
        }
        private function removeEvents():void{
            bg.chatBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.copyNameBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.playerInfoBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.windowChatBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.inviteTeamBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.chatHistoryBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.addFriendBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.deleteBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.blackBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
            bg.enemyBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
        }
        private function dispose():void{
            if (parent){
                parent.removeChild(this);
            };
            removeEvents();
            this.removeChild(this.bg);
        }

    }
}//package GameUI.Modules.Friend.view.ui 
