//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Friend.view.ui.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.ScreenMessage.View.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import flash.system.*;
    import GameUI.*;

    public class FriendManagerMediator extends Mediator {

        public static const FRIENDDEFAULTPOS:Point = new Point(UIConstData.DefaultPos2.x, UIConstData.DefaultPos2.y);
        public static const NAME:String = "FriendManagerMediator";

        protected var flagShow:Boolean = false;
        private var isLockFeelStatus:Boolean = false;
        private var addFriendFrame:UIAddFriendFrame;
        protected var tempContainer:UIFriendListPanel;
        private var currentPage:int;
        protected var fContainer:UIFriendListPanel;
        private var deleteRole:FriendInfoStruct;
        protected var blackContainer:UIFriendListPanel;
        protected var roleInfo:FriendInfoStruct;
        protected var enemyContainer:UIFriendListPanel;
        public var menu:FriendMenuPanel;
        protected var dataProxy:DataProxy;
        protected var panelBase:HFrame;
        private var btn_addFriend:HLabelButton;

        public function FriendManagerMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        private function showMenu(_arg1:FriendInfoStruct, _arg2:Point):void{
            var _local4:DisplayObject;
            var _local5:DisplayObject;
            this.menu.info = (arguments[0] as FriendInfoStruct);
            this.menu.x = _arg2.x;
            this.menu.y = _arg2.y;
            if ((menu.x + menu.width) > GameCommonData.GameInstance.ScreenWidth){
                menu.x = (menu.x + ((GameCommonData.GameInstance.ScreenWidth - menu.x) - menu.width));
            };
            if ((menu.y + menu.height) > GameCommonData.GameInstance.ScreenHeight){
                menu.y = (menu.y + ((GameCommonData.GameInstance.ScreenHeight - menu.y) - menu.height));
            };
            GameCommonData.GameInstance.GameUI.addChild(this.menu);
        }
        protected function onRemoveStage(_arg1:Event):void{
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
            };
        }
        protected function onMenuCellClick(_arg1:FriendMenuEvent):void{
            var _local2:FriendMenuEvent = new FriendMenuEvent(_arg1.type, _arg1.clickCellType, _arg1.info);
            onMenuItemCellClick(_local2);
        }
        private function __frameDownHandler(_arg1:MouseEvent):void{
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
            };
        }
        protected function onCellDoubleClick(_arg1:FriendMenuEvent):void{
            this.sendNotification(FriendCommandList.SHOW_SEND_MSG, _arg1.info);
        }
        public function checkHasTheFriend(_arg1:String, _arg2:int=-1):Boolean{
            var _local3:uint;
            var _local5:uint;
            if (_arg2 == 0){
                _arg2 = -1;
            };
            var _local4:Array = FriendConstData.FriendList;
            while (_local3 < _local4.length) {
                if (((((_local4[_local3] as FriendInfoStruct).roleName == _arg1)) || (((_local4[_local3] as FriendInfoStruct).frendId == _arg2)))){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:(((("<font color=\"#ff0000\">" + _arg1) + "</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("已经在好友列表中")) + "</font>"),
                        color:0xFFFF00
                    });
                    return (true);
                };
                _local3++;
            };
            return (false);
        }
        protected function deleteFriend():void{
            FriendSend.deleteFriend(this.deleteRole.frendId, this.deleteRole.type);
        }
        protected function onAddFriendHandler(_arg1:MouseEvent):void{
            if (addFriendFrame){
                addFriendFrame.dispose();
                addFriendFrame = null;
            };
            addFriendFrame = new UIAddFriendFrame();
            addFriendFrame.okFun = addFriendHandler;
            addFriendFrame.show();
        }
        private function addFriendHandler(_arg1:String):void{
            if (_arg1 == ""){
                MessageTip.show(LanguageMgr.GetTranslation("输入名字不能为空"));
                return;
            };
            if (addFriendFrame){
                addFriendFrame.dispose();
                addFriendFrame = null;
            };
            sendNotification(FriendCommandList.ADD_TO_FRIEND, {name:_arg1});
        }
        public function get friendManager():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function selectPage(_arg1:int):void{
            friendManager.mc_Friend.gotoAndStop(2);
            friendManager.mc_CR.gotoAndStop(2);
            friendManager.mc_Temp.gotoAndStop(2);
            friendManager.mc_Black.gotoAndStop(2);
            var _local2:int;
            while (_local2 < 4) {
                if (_local2 != _arg1){
                    friendManager[("textpage_" + _local2)].textColor = 250597;
                } else {
                    friendManager[("textpage_" + _local2)].textColor = 16496146;
                };
                _local2++;
            };
            if (this.fContainer.parent != null){
                this.friendManager.removeChild(this.fContainer);
            };
            if (this.enemyContainer.parent != null){
                this.friendManager.removeChild(this.enemyContainer);
            };
            if (this.tempContainer.parent != null){
                this.friendManager.removeChild(this.tempContainer);
            };
            if (this.blackContainer.parent != null){
                this.friendManager.removeChild(this.blackContainer);
            };
            switch (_arg1){
                case 0:
                    friendManager.mc_Friend.gotoAndStop(1);
                    fContainer.setData(FriendConstData.FriendList);
                    this.friendManager.addChild(this.fContainer);
                    break;
                case 1:
                    friendManager.mc_CR.gotoAndStop(1);
                    enemyContainer.setData(FriendConstData.EnemyList);
                    this.friendManager.addChild(this.enemyContainer);
                    break;
                case 2:
                    friendManager.mc_Temp.gotoAndStop(1);
                    tempContainer.setData(FriendConstData.TempFriendList);
                    this.friendManager.addChild(this.tempContainer);
                    break;
                case 3:
                    friendManager.mc_Black.gotoAndStop(1);
                    blackContainer.setData(FriendConstData.BlackFriendList);
                    this.friendManager.addChild(this.blackContainer);
                    break;
            };
        }
        protected function onMenuItemCellClick(_arg1:FriendMenuEvent):void{
            if (_arg1.type == null){
                return;
            };
            switch (_arg1.clickCellType){
                case FriendMenuEvent.TYPE_PLAYERINFO:
                    FriendSend.getFriendInfo(_arg1.info.frendId);
                    break;
                case FriendMenuEvent.TYPE_WINDOWCHAT:
                    this.sendNotification(FriendCommandList.SHOW_SEND_MSG, _arg1.info);
                    break;
                case FriendMenuEvent.TYPE_BLACKFRIEND:
                    FriendSend.addFriend(_arg1.info.roleName, FriendType.TYPE_BLACK);
                    break;
                case FriendMenuEvent.TYPE_ENEMYFRIEND:
                    if (!isEnemy(_arg1.info.frendId)){
                        FriendSend.addFriend(_arg1.info.roleName, FriendType.TYPE_ENEMY);
                    };
                    break;
                case FriendMenuEvent.TYPE_DELETEFRIEND:
                    this.deleteRole = _arg1.info;
                    facade.sendNotification(EventList.SHOWALERT, {
                        comfrim:deleteFriend,
                        cancel:new Function(),
                        info:LanguageMgr.GetTranslation("是否确认册除该好友")
                    });
                    break;
                case FriendMenuEvent.TYPE_ADDFRIEND:
                    FriendSend.addFriend(_arg1.info.roleName, FriendType.TYPE_FRIEND);
                    break;
                case FriendMenuEvent.TYPE_CHAT:
                    facade.sendNotification(ChatEvents.QUICKCHAT, _arg1.info.roleName);
                    break;
                case FriendMenuEvent.TYPE_COPYNAME:
                    System.setClipboard(_arg1.info.roleName);
                    break;
                case FriendMenuEvent.TYPE_INVITETEAM:
                    sendNotification(EventList.INVITETEAM, {id:_arg1.info.frendId});
                    break;
                case FriendMenuEvent.TYPE_TRACKER:
                    sendNotification(FriendCommandList.SHOW_POSITION, _arg1.info);
                    break;
            };
        }
        public function isHasTheFriend(_arg1:String, _arg2:uint):Boolean{
            var _local3:uint;
            var _local5:uint;
            var _local4:Array = FriendConstData.FriendList;
            while (_local3 < _local4.length) {
                if (((((_local4[_local3] as FriendInfoStruct).roleName == _arg1)) || (((_local4[_local3] as FriendInfoStruct).frendId == _arg2)))){
                    return (true);
                };
                _local3++;
            };
            return (false);
        }
        protected function comfirm():void{
            sendNotification(FriendCommandList.ADD_TO_FRIEND, {
                id:roleInfo.frendId,
                name:roleInfo.roleName
            });
        }
        override public function handleNotification(_arg1:INotification):void{
            var type:* = 0;
            var data:* = null;
            var friendInfo:* = null;
            var _local7:* = null;
            var playerInfo:* = null;
            var friendId:* = 0;
            var lineId:* = 0;
            var tempOnlineState:* = false;
            var isFriend:* = false;
            var idx:* = 0;
            var _local15:* = null;
            var playerName:* = null;
            var playerId:* = 0;
            var addToEnemyFreind:* = null;
            var addToEnemyFreindCanael:* = null;
            var cw:* = null;
            var cellIdx:* = 0;
            var newLevel:* = 0;
            var bigm:* = null;
            var i:* = 0;
            var minCell:* = null;
            var tipInfo:* = null;
            var _arg1:* = _arg1;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    this.facade.registerCommand(CommandList.FRIEND_CHAT_MESSAGE, ReceiveMsgCommand);
                    this.facade.registerCommand(PlayerInfoComList.SELECT_ELEMENT, SelectElementCommand);
                    this.facade.registerMediator(new FriendAlterMediator());
                    this.dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"FriendManagerComponent"
                    });
                    this.friendManager.mouseEnabled = false;
                    panelBase = new HFrame();
                    panelBase.setSize(218, 450);
                    panelBase.addContent(this.friendManager);
                    friendManager.x = 4;
                    friendManager.y = 35;
                    panelBase.closeCallBack = panelCloseHandler;
                    panelBase.name = "Friend";
                    panelBase.x = FRIENDDEFAULTPOS.x;
                    panelBase.y = ((GameCommonData.GameInstance.ScreenHeight - panelBase.frameHeight) / 2);
                    panelBase.titleText = LanguageMgr.GetTranslation("好 友");
                    panelBase.centerTitle = true;
                    panelBase.blackGound = false;
                    friendManager.mc_Friend.gotoAndStop(1);
                    friendManager.mc_CR.gotoAndStop(2);
                    friendManager.mc_Temp.gotoAndStop(2);
                    friendManager.mc_Black.gotoAndStop(2);
                    this.fContainer = new UIFriendListPanel();
                    this.enemyContainer = new UIFriendListPanel();
                    this.tempContainer = new UIFriendListPanel();
                    this.blackContainer = new UIFriendListPanel();
                    friendManager.addChild(fContainer);
                    FriendSend.getFriendList();
                    this.createMenu();
                    panelBase.addEventListener(MouseEvent.MOUSE_DOWN, __frameDownHandler);
                    break;
                case FriendCommandList.SHOWFRIEND:
                    if (GameCommonData.IsInCrossServer){
                        return;
                    };
                    GameCommonData.GameInstance.GameUI.addChild(panelBase);
                    initView();
                    dataProxy.FriendsIsOpen = true;
                    break;
                case FriendCommandList.HIDEFRIEND:
                    this.panelCloseHandler();
                    break;
                case FriendCommandList.GET_FRIEND_LIST:
                    type = _arg1.getBody()["type"];
                    data = (_arg1.getBody()["data"] as Array);
                    data.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                    switch (type){
                        case FriendType.TYPE_FRIEND:
                            FriendConstData.FriendList = data;
                            break;
                        case FriendType.TYPE_ENEMY:
                            FriendConstData.EnemyList = data;
                            break;
                        case FriendType.TYPE_BLACK:
                            FriendConstData.BlackFriendList = data;
                            break;
                        case FriendType.TYPE_TEMP:
                            FriendConstData.TempFriendList = data;
                            break;
                    };
                    selectPage(currentPage);
                    break;
                case FriendCommandList.ADD_FRIEND_SUCCESS:
                    friendInfo = (_arg1.getBody() as FriendInfoStruct);
                    switch (friendInfo.type){
                        case FriendType.TYPE_FRIEND:
                            FriendConstData.FriendList.push(friendInfo);
                            FriendConstData.FriendList.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                            bigm = new BigMessageItem(LanguageMgr.GetTranslation("添加好友x成功", friendInfo.roleName));
                            bigm.Jump();
                            break;
                        case FriendType.TYPE_ENEMY:
                            FriendConstData.EnemyList.push(friendInfo);
                            FriendConstData.EnemyList.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                            MessageTip.show(LanguageMgr.GetTranslation("已将x成功加入到仇人名单中", friendInfo.roleName));
                            break;
                        case FriendType.TYPE_BLACK:
                            FriendConstData.BlackFriendList.push(friendInfo);
                            FriendConstData.BlackFriendList.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                            MessageTip.show(LanguageMgr.GetTranslation("已将x成功加入到黑名单中", friendInfo.roleName));
                            break;
                        case FriendType.TYPE_TEMP:
                            FriendConstData.TempFriendList.push(friendInfo);
                            break;
                    };
                    selectPage(currentPage);
                    break;
                case FriendCommandList.INVATE_TO_FRIEND:
                    _local7 = _arg1.getBody();
                    this.roleInfo = (_arg1.getBody() as FriendInfoStruct);
                    sendNotification(FriendCommandList.SHOW_FRIEND_ALTER, this.roleInfo);
                    break;
                case FriendCommandList.DELETE_FRIEND_SUCCESS:
                    playerInfo = (_arg1.getBody() as FriendInfoStruct);
                    switch (playerInfo.type){
                        case FriendType.TYPE_FRIEND:
                            i = 0;
                            while (i < FriendConstData.FriendList.length) {
                                if ((FriendConstData.FriendList[i] as FriendInfoStruct).frendId == playerInfo.frendId){
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:(((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("你成功的删除了好友")) + "</font><font color=\"#ff0000\">[") + (FriendConstData.FriendList[i] as FriendInfoStruct).roleName) + "]</font>"),
                                        color:0xFFFF00
                                    });
                                    FriendConstData.FriendList.splice(i, 1);
                                    break;
                                };
                                i = (i + 1);
                            };
                            break;
                        case FriendType.TYPE_ENEMY:
                            i = 0;
                            while (i < FriendConstData.EnemyList.length) {
                                if ((FriendConstData.EnemyList[i] as FriendInfoStruct).frendId == playerInfo.frendId){
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:(((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("你成功的删除了仇人")) + "</font><font color=\"#ff0000\">[") + (FriendConstData.EnemyList[i] as FriendInfoStruct).roleName) + "]</font>"),
                                        color:0xFFFF00
                                    });
                                    FriendConstData.EnemyList.splice(i, 1);
                                    break;
                                };
                                i = (i + 1);
                            };
                            break;
                        case FriendType.TYPE_TEMP:
                            i = 0;
                            while (i < FriendConstData.TempFriendList.length) {
                                if ((FriendConstData.TempFriendList[i] as FriendInfoStruct).frendId == playerInfo.frendId){
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:(((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("你成功的删除了临时好友")) + "</font><font color=\"#ff0000\">[") + (FriendConstData.TempFriendList[i] as FriendInfoStruct).roleName) + "]</font>"),
                                        color:0xFFFF00
                                    });
                                    FriendConstData.TempFriendList.splice(i, 1);
                                    break;
                                };
                                i = (i + 1);
                            };
                            break;
                        case FriendType.TYPE_BLACK:
                            i = 0;
                            while (i < FriendConstData.BlackFriendList.length) {
                                if ((FriendConstData.BlackFriendList[i] as FriendInfoStruct).frendId == playerInfo.frendId){
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:(((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("你成功的删除了黑名单")) + "</font><font color=\"#ff0000\">[") + (FriendConstData.BlackFriendList[i] as FriendInfoStruct).roleName) + "]</font>"),
                                        color:0xFFFF00
                                    });
                                    FriendConstData.BlackFriendList.splice(i, 1);
                                    break;
                                };
                                i = (i + 1);
                            };
                            break;
                    };
                    selectPage(currentPage);
                    break;
                case FriendCommandList.CHANGE_FRIEND_ONLINE:
                    friendId = _arg1.getBody()["friendId"];
                    lineId = _arg1.getBody()["lineId"];
                    tempOnlineState = false;
                    friendInfo = this.searchFriend(FriendConstData.FriendList, friendId);
                    if (friendInfo){
                        isFriend = true;
                        tempOnlineState = friendInfo.isOnline;
                        friendInfo.lineId = lineId;
                        FriendConstData.FriendList.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                        if (!((tempOnlineState) && (friendInfo.isOnline))){
                            if (friendInfo.isOnline){
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:(((((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("好友")) + "</font><font color=\"#ff0000\">[") + friendInfo.roleName) + "]</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("上线了")) + "</font>"),
                                    color:0xFFFF00
                                });
                            } else {
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:(((((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("好友")) + "</font><font color=\"#ff0000\">[") + friendInfo.roleName) + "]</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("下线了")) + "</font>"),
                                    color:0xFFFF00
                                });
                            };
                        };
                    };
                    friendInfo = this.searchFriend(FriendConstData.EnemyList, friendId);
                    if (friendInfo){
                        tempOnlineState = friendInfo.isOnline;
                        friendInfo.lineId = lineId;
                        FriendConstData.EnemyList.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                        if (!((tempOnlineState) && (friendInfo.isOnline))){
                            if (!isFriend){
                                if (friendInfo.isOnline){
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:(((((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("仇人")) + "</font><font color=\"#ff0000\">[") + friendInfo.roleName) + "]</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("上线了")) + "</font>"),
                                        color:0xFFFF00
                                    });
                                } else {
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:(((((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("仇人")) + "</font><font color=\"#ff0000\">[") + friendInfo.roleName) + "]</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("下线了")) + "</font>"),
                                        color:0xFFFF00
                                    });
                                };
                            };
                        };
                    };
                    friendInfo = this.searchFriend(FriendConstData.BlackFriendList, friendId);
                    if (friendInfo){
                        tempOnlineState = friendInfo.isOnline;
                        friendInfo.lineId = lineId;
                        FriendConstData.BlackFriendList.sortOn(["isOnline", "roleName"], [Array.DESCENDING, 0]);
                        if (!((tempOnlineState) && (friendInfo.isOnline))){
                            if (friendInfo.isOnline){
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:(((((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("黑名单")) + "</font><font color=\"#ff0000\">[") + friendInfo.roleName) + "]</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("上线了")) + "</font>"),
                                    color:0xFFFF00
                                });
                            } else {
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:(((((("<font color=\"#ffff00\">" + LanguageMgr.GetTranslation("黑名单")) + "</font><font color=\"#ff0000\">[") + friendInfo.roleName) + "]</font><font color=\"#ffff00\">") + LanguageMgr.GetTranslation("下线了")) + "</font>"),
                                    color:0xFFFF00
                                });
                            };
                        };
                    };
                    selectPage(currentPage);
                    break;
                case FriendCommandList.ADD_TEMP_FRIEND:
                    _local15 = (_arg1.getBody() as FriendInfoStruct);
                    if (((((!((_local15.frendId == GameCommonData.Player.Role.Id))) && ((this.searchFriend(FriendConstData.FriendList, _local15.frendId) == null)))) && ((this.searchFriend(FriendConstData.TempFriendList, _local15.frendId) == null)))){
                        _local15.type = FriendType.TYPE_TEMP;
                        FriendConstData.TempFriendList.push(_local15);
                    };
                    break;
                case FriendCommandList.ADD_TO_FRIEND:
                    playerName = _arg1.getBody()["name"];
                    if (((!(playerName)) || ((playerName == "")))){
                        MessageTip.show(LanguageMgr.GetTranslation("名称不能为空"));
                        return;
                    };
                    if (playerName == GameCommonData.Player.Role.Name){
                        MessageTip.show(LanguageMgr.GetTranslation("不能添加自己为好友"));
                        return;
                    };
                    if (this.checkHasTheFriend(playerName)){
                        MessageTip.show(LanguageMgr.GetTranslation("你已经有此好友"));
                        return;
                    };
                    FriendSend.addFriend(playerName, FriendType.TYPE_FRIEND);
                    break;
                case FriendCommandList.FRIEND_INFO_CLEAR:
                    FriendConstData.FriendList = [];
                    FriendConstData.BlackFriendList = [];
                    FriendConstData.EnemyList = [];
                    FriendConstData.TempFriendList = [];
                    break;
                case FriendCommandList.ADD_ENEMY_FRIEND:
                    playerId = (_arg1.getBody()["playerId"] as uint);
                    playerName = (_arg1.getBody()["playerName"] as String);
                    addToEnemyFreind = function ():void{
                        FriendSend.addFriend(playerName, FriendType.TYPE_ENEMY);
                    };
                    addToEnemyFreindCanael = function ():void{
                        if (FriendConstData.EnemyTempList.indexOf(playerId) != -1){
                            FriendConstData.EnemyTempList.splice(FriendConstData.EnemyTempList.indexOf(playerId), 1);
                        };
                    };
                    addToEnemyFreind();
                    addToEnemyFreindCanael();
                    return;
                case FriendCommandList.ADD_BLACK:
                    playerName = _arg1.getBody()["name"];
                    if (((!(playerName)) || ((playerName == "")))){
                        MessageTip.show(LanguageMgr.GetTranslation("名称不能为空"));
                        return;
                    };
                    if (playerName == GameCommonData.Player.Role.Name){
                        MessageTip.show(LanguageMgr.GetTranslation("不能添加自己为黑名单"));
                        return;
                    };
                    FriendSend.addFriend(playerName, FriendType.TYPE_BLACK);
                    break;
                case FriendCommandList.SHOW_FRIENDMENU:
                    showMenu((_arg1.getBody()["info"] as FriendInfoStruct), (_arg1.getBody()["pos"] as Point));
                    break;
                case FriendCommandList.FRIEND_MESSAGE:
                    playerId = _arg1.getBody()["sendId"];
                    playerName = _arg1.getBody()["sendName"];
                    cw = (facade.retrieveMediator(FriendChatMediator.NAME) as FriendChatMediator).SearchChatWindow(playerId, true);
                    if (cw){
                        minCell = (facade.retrieveMediator(FriendChatMediator.NAME) as FriendChatMediator).GetMinizeCellByChatWindow(cw);
                        if (minCell){
                            cellIdx = (facade.retrieveMediator(FriendChatMediator.NAME) as FriendChatMediator).MinimizeItemCells.indexOf(minCell);
                        };
                    };
                    if (((minCell) && ((cellIdx < 3)))){
                        sendNotification(FriendCommandList.MINIMIZEITEMCELL_SHINE_START, {friendId:playerId});
                    } else {
                        tipInfo = new NewInfoTipVo();
                        tipInfo.title = LanguageMgr.GetTranslation("x邀请你聊天", playerName);
                        tipInfo.type = NewInfoTipType.TYPE_CHAT;
                        tipInfo.data = {
                            sendId:playerId,
                            sendName:playerName,
                            minimize:false
                        };
                        sendNotification(NewInfoTipNotiName.ADD_INFOTIP, tipInfo);
                    };
                    break;
                case FriendCommandList.FRIEND_LEVELUP:
                    friendId = _arg1.getBody()["friendId"];
                    newLevel = _arg1.getBody()["newLevel"];
                    friendInfo = this.searchFriend(FriendConstData.FriendList, friendId);
                    if (friendInfo){
                        friendInfo.level = newLevel;
                    };
                    friendInfo = this.searchFriend(FriendConstData.EnemyList, friendId);
                    if (friendInfo){
                        friendInfo.level = newLevel;
                    };
                    friendInfo = this.searchFriend(FriendConstData.BlackFriendList, friendId);
                    if (friendInfo){
                        friendInfo.level = newLevel;
                    };
                    selectPage(currentPage);
                    break;
            };
        }
        public function isPersonOnline(_arg1:String):Boolean{
            var _local2:* = this.searchPersonByName(_arg1);
            if (_local2 != null){
                return (_local2.isOnline);
            };
            return (false);
        }
        protected function initView():void{
            fContainer.x = 6;
            fContainer.y = 25;
            enemyContainer.x = 6;
            enemyContainer.y = 25;
            tempContainer.x = 6;
            tempContainer.y = 25;
            blackContainer.x = 6;
            blackContainer.y = 25;
            panelBase.y = ((GameCommonData.GameInstance.ScreenHeight - panelBase.frameHeight) / 2);
            btn_addFriend = new HLabelButton();
            btn_addFriend.label = "添加好友";
            btn_addFriend.x = 70;
            btn_addFriend.y = 385;
            friendManager.addChild(btn_addFriend);
            btn_addFriend.addEventListener(MouseEvent.CLICK, onAddFriendHandler);
            friendManager.mc_CR.buttonMode = true;
            friendManager.mc_Friend.buttonMode = true;
            friendManager.mc_Temp.buttonMode = true;
            friendManager.mc_Black.buttonMode = true;
            friendManager.mc_Friend.addEventListener(MouseEvent.CLICK, onClick);
            friendManager.mc_CR.addEventListener(MouseEvent.CLICK, onClick);
            friendManager.mc_Temp.addEventListener(MouseEvent.CLICK, onClick);
            friendManager.mc_Black.addEventListener(MouseEvent.CLICK, onClick);
            friendManager.textpage_0.mouseEnabled = false;
            friendManager.textpage_1.mouseEnabled = false;
            friendManager.textpage_2.mouseEnabled = false;
            friendManager.textpage_3.mouseEnabled = false;
        }
        protected function panelCloseHandler():void{
            this.panelBase.close();
            dataProxy.FriendsIsOpen = false;
            friendManager.mc_Friend.removeEventListener(MouseEvent.CLICK, onClick);
            friendManager.mc_CR.removeEventListener(MouseEvent.CLICK, onClick);
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
        }
        private function sortFriend(_arg1:Array):void{
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, FriendCommandList.SHOWFRIEND, FriendCommandList.HIDEFRIEND, FriendCommandList.GET_FRIEND_LIST, FriendCommandList.INVATE_TO_FRIEND, FriendCommandList.ADD_FRIEND_SUCCESS, FriendCommandList.DELETE_FRIEND_SUCCESS, FriendCommandList.CHANGE_FRIEND_ONLINE, FriendCommandList.FRIEND_LEVELUP, FriendCommandList.ADD_TEMP_FRIEND, FriendCommandList.ADD_TO_FRIEND, FriendCommandList.FRIEND_INFO_CLEAR, FriendCommandList.ADD_ENEMY_FRIEND, FriendCommandList.ADD_BLACK, FriendCommandList.SHOW_FRIENDMENU, FriendCommandList.FRIEND_MESSAGE]);
        }
        public function getFriendNum():uint{
            return (FriendConstData.FriendList.length);
        }
        public function searchEnemyByName(_arg1:String):Object{
            var _local2:uint;
            while (_local2 < FriendConstData.EnemyList.length) {
                if ((FriendConstData.EnemyList[_local2] as FriendInfoStruct).roleName == _arg1){
                    return (FriendConstData.EnemyList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public function searchFriend(_arg1:Array, _arg2:int, _arg3:uint=1, _arg4:String=""):FriendInfoStruct{
            var _local5:uint;
            while (_local5 < _arg1.length) {
                if (_arg3 == 1){
                    if ((_arg1[_local5] as FriendInfoStruct).frendId == _arg2){
                        return (_arg1[_local5]);
                    };
                } else {
                    if ((_arg1[_local5] as FriendInfoStruct).roleName == _arg4){
                        return (_arg1[_local5]);
                    };
                };
                _local5++;
            };
            return (null);
        }
        protected function onClick(_arg1:MouseEvent):void{
            var _local2 = -1;
            switch (_arg1.currentTarget){
                case friendManager.mc_Friend:
                    _local2 = 0;
                    break;
                case friendManager.mc_CR:
                    _local2 = 1;
                    break;
                case friendManager.mc_Temp:
                    _local2 = 2;
                    break;
                case friendManager.mc_Black:
                    _local2 = 3;
                    break;
            };
            if (((!((_local2 == -1))) && (!((_local2 == currentPage))))){
                SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
                currentPage = _local2;
                selectPage(currentPage);
            };
        }
        protected function cancel():void{
        }
        protected function createMenu():void{
            this.menu = new FriendMenuPanel();
            this.menu.addEventListener(FriendMenuEvent.Cell_Click, onMenuCellClick);
            friendManager.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
        }
        public function isEnemy(_arg1:int):Boolean{
            var _local2:FriendInfoStruct;
            for each (_local2 in FriendConstData.EnemyList) {
                if (_local2.frendId == _arg1){
                    return (true);
                };
            };
            return (false);
        }
        public function searchPersonByName(_arg1:String):FriendInfoStruct{
            var _local2:FriendInfoStruct = this.searchFriend(FriendConstData.FriendList, 0, 0, _arg1);
            if (_local2 != null){
                return (_local2);
            };
            return ((this.searchEnemyByName(_arg1) as FriendInfoStruct));
        }

    }
}//package GameUI.Modules.Friend.view.mediator 
