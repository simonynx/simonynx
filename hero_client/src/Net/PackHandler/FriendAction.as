//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.View.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import GameUI.Modules.RoleProperty.Datas.*;

    public class FriendAction extends GameAction {

        public static const FRIEND_ENEMY_ALREADY:int = 6;
        public static const FRIEND_SOCIAL_ONLINE:int = 14;
        public static const FRIEND_IGNORE_ALREADY:int = 7;
        public static const FRIEND_SELF:int = 8;
        public static const FRIEND_ENEMY_REMOVED:int = 10;
        public static const FRIEND_IGNORE_REMOVED:int = 11;
        public static const FRIEND_FRIEND_ALREADY:int = 5;
        public static const FRIEND_LEVELUP:int = 18;
        public static const FRIEND_REMOVED:int = 9;
        public static const FRIEND_IGNORE_LIST_FULL:int = 3;
        public static const FRIEND_ENEMY_LIST_FULL:int = 2;
        public static const FRIEND_DB_ERROR:int = 0;
        public static const BE_ADDED:int = 13;
        public static const FRIEND_FRIEND_LIST_FULL:int = 1;
        public static const FRIEND_ADD_SOCIAL_SUCCESS:int = 12;
        public static const FRIEND_NOT_FOUND:int = 4;
        public static const FRIEND_SOCIAL_OFFLINE:int = 15;

        private static var _instance:FriendAction;

        public function FriendAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():FriendAction{
            if (!_instance){
                _instance = new (FriendAction)();
            };
            return (_instance);
        }

        private function friendStatus(_arg1:NetPacket):void{
            var _local3:FriendInfoStruct;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local2:int = _arg1.readByte();
            trace(("add friend status" + _local2));
            switch (_local2){
                case FRIEND_ADD_SOCIAL_SUCCESS:
                    _local3 = new FriendInfoStruct();
                    _local3.type = _arg1.readUnsignedInt();
                    _local3.ReadFromPacket(_arg1);
                    sendNotification(FriendCommandList.ADD_FRIEND_SUCCESS, _local3);
                    break;
                case FRIEND_REMOVED:
                    _local3 = new FriendInfoStruct();
                    _local3.type = FriendType.TYPE_FRIEND;
                    _local3.frendId = _arg1.readUnsignedInt();
                    _local3.roleName = _arg1.ReadString();
                    facade.sendNotification(FriendCommandList.DELETE_FRIEND_SUCCESS, _local3);
                    break;
                case FRIEND_ENEMY_REMOVED:
                    _local3 = new FriendInfoStruct();
                    _local3.type = FriendType.TYPE_ENEMY;
                    _local3.frendId = _arg1.readUnsignedInt();
                    _local3.roleName = _arg1.ReadString();
                    facade.sendNotification(FriendCommandList.DELETE_FRIEND_SUCCESS, _local3);
                    break;
                case FRIEND_IGNORE_REMOVED:
                    _local3 = new FriendInfoStruct();
                    _local3.type = FriendType.TYPE_BLACK;
                    _local3.frendId = _arg1.readUnsignedInt();
                    _local3.roleName = _arg1.ReadString();
                    facade.sendNotification(FriendCommandList.DELETE_FRIEND_SUCCESS, _local3);
                    break;
                case FRIEND_SOCIAL_ONLINE:
                case FRIEND_SOCIAL_OFFLINE:
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = _arg1.readUnsignedInt();
                    facade.sendNotification(FriendCommandList.CHANGE_FRIEND_ONLINE, {
                        friendId:_local5,
                        lineId:_local4
                    });
                    break;
                case FRIEND_NOT_FOUND:
                    MessageTip.show(LanguageMgr.GetTranslation("找不到该玩家"));
                    break;
                case FRIEND_LEVELUP:
                    _local5 = _arg1.readUnsignedInt();
                    _local6 = _arg1.readUnsignedInt();
                    facade.sendNotification(FriendCommandList.FRIEND_LEVELUP, {
                        friendId:_local5,
                        newLevel:_local6
                    });
                    break;
            };
        }
        private function getFriendLists(_arg1:NetPacket):void{
            var _local5:FriendInfoStruct;
            var _local2:Array = [];
            var _local3:int = _arg1.readByte();
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = new FriendInfoStruct();
                _local5.type = FriendType.TYPE_FRIEND;
                _local5.ReadFromPacket(_arg1);
                _local2.push(_local5);
                _local4++;
            };
            sendNotification(FriendCommandList.GET_FRIEND_LIST, {
                type:FriendType.TYPE_FRIEND,
                data:_local2
            });
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_FRIEND_STATUS:
                    friendStatus(_arg1);
                    break;
                case Protocol.SMSG_FRIEND_LIST:
                    getFriendLists(_arg1);
                    break;
                case Protocol.SMSG_IGNORE_LIST:
                    getBlackList(_arg1);
                    break;
                case Protocol.SMSG_ENEMY_LIST:
                    getEnemyList(_arg1);
                    break;
                case Protocol.SMSG_FRIEND_ROLE_PANEL:
                    getPlayerInfo(_arg1);
                    break;
            };
        }
        private function getPlayerInfo(_arg1:NetPacket):void{
            var playerInfo:* = null;
            var itemInfo:* = null;
            var itemCnt:* = 0;
            var itemList:* = null;
            var friendCurrLine:* = 0;
            var mapId:* = 0;
            var mapX:* = 0;
            var mapY:* = 0;
            var mapName:* = null;
            var info:* = null;
            var i:* = 0;
            var netPacket:* = _arg1;
            var myId:* = netPacket.readUnsignedInt();
            if (myId == 0){
                MessageTip.show(LanguageMgr.GetTranslation("好友不在线"));
                return;
            };
            playerInfo = new GameRole();
            playerInfo.Id = netPacket.readUnsignedInt();
            playerInfo.Name = netPacket.ReadString();
            var operType:* = netPacket.readUnsignedInt();
            switch (operType){
                case 0:
                    playerInfo.Sex = netPacket.readUnsignedInt();
                    playerInfo.MainJob.Job = netPacket.readUnsignedInt();
                    itemCnt = netPacket.readUnsignedInt();
                    itemList = new Array(20);
                    i = 0;
                    while (i < itemCnt) {
                        itemInfo = new InventoryItemInfo();
                        itemInfo.ReadFromPacket(netPacket);
                        itemList[itemInfo.Place] = itemInfo;
                        i = (i + 1);
                    };
                    if (playerInfo.Id == GameCommonData.Player.Role.Id){
                        playerInfo = GameCommonData.Player.Role;
                    } else {
                        playerInfo.ReadProperties(netPacket);
                        playerInfo.GuildName = netPacket.ReadString();
                    };
                    facade.sendNotification(RoleEvents.SHOW_PLAYER_PROPELEMENT, {
                        itemlist:itemList,
                        role:playerInfo
                    });
                    break;
                case 1:
                    friendCurrLine = netPacket.readUnsignedInt();
                    mapId = netPacket.readUnsignedInt();
                    mapX = netPacket.readShort();
                    mapY = netPacket.readShort();
                    mapName = GameCommonData.MapConfigs[String(mapId)].@Name;
                    info = LanguageMgr.GetTranslation("该玩家z所在位置(x,y)", ChgLineData.getNameByIndex(friendCurrLine), mapName, String(mapX), String(mapY));
                    facade.sendNotification(EventList.SHOWALERT, {
                        comfrim:function ():void{
                        },
                        cancel:null,
                        isShowClose:true,
                        info:info,
                        title:LanguageMgr.GetTranslation("追踪定位")
                    });
                    break;
                case 2:
                    itemCnt = netPacket.readUnsignedInt();
                    itemList = [];
                    i = 0;
                    while (i < itemCnt) {
                        itemInfo = new InventoryItemInfo();
                        itemInfo.ReadFromPacket(netPacket);
                        itemList[i] = itemInfo;
                        i = (i + 1);
                    };
                    facade.sendNotification(EventList.SHOWONEPETVIEW, itemList);
                    break;
                case 3:
                    itemCnt = netPacket.readUnsignedInt();
                    itemList = [];
                    i = 0;
                    while (i < itemCnt) {
                        itemInfo = new InventoryItemInfo();
                        itemInfo.ReadFromPacket(netPacket);
                        itemList[itemInfo.Place] = itemInfo;
                        i = (i + 1);
                    };
                    facade.sendNotification(EventList.SHOWONEPETVIEW, [itemInfo]);
                    break;
            };
        }
        private function getEnemyList(_arg1:NetPacket):void{
            var _local5:FriendInfoStruct;
            var _local2:Array = [];
            var _local3:int = _arg1.readByte();
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = new FriendInfoStruct();
                _local5.type = FriendType.TYPE_ENEMY;
                _local5.ReadFromPacket(_arg1);
                _local2.push(_local5);
                _local4++;
            };
            sendNotification(FriendCommandList.GET_FRIEND_LIST, {
                type:FriendType.TYPE_ENEMY,
                data:_local2
            });
        }
        private function getBlackList(_arg1:NetPacket):void{
            var _local5:FriendInfoStruct;
            var _local2:Array = [];
            var _local3:int = _arg1.readByte();
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = new FriendInfoStruct();
                _local5.type = FriendType.TYPE_BLACK;
                _local5.ReadFromPacket(_arg1);
                _local2.push(_local5);
                _local4++;
            };
            sendNotification(FriendCommandList.GET_FRIEND_LIST, {
                type:FriendType.TYPE_BLACK,
                data:_local2
            });
        }

    }
}//package Net.PackHandler 
