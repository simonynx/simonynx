//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.model {
    import flash.events.*;
    import GameUI.Modules.Friend.model.vo.*;

    public class FriendMenuEvent extends Event {

        public static const TYPE_COPYNAME:String = "TYPE_COPYNAME";
        public static const TYPE_ADDFRIEND:String = "TYPE_ADDFRIEND";
        public static const Cell_Click:String = "cellClick";
        public static const TYPE_WINDOWCHAT:String = "TYPE_WINDOWCHAT";
        public static const TYPE_INVITETEAM:String = "TYPE_INVITETEAM";
        public static const TYPE_TRACKER:String = "TYPE_CHATHISTORY";
        public static const TYPE_PLAYERINFO:String = "TYPE_PLAYERINFO";
        public static const TYPE_DELETEFRIEND:String = "TYPE_DELETEFRIEND";
        public static const CELL_DOUBLE_CLICK:String = "doubleClick";
        public static const TYPE_ENEMYFRIEND:String = "TYPE_ENEMYFRIEND";
        public static const TYPE_CHAT:String = "TYPE_CHAT";
        public static const TYPE_BLACKFRIEND:String = "TYPE_BLACKFRIEND";

        public var clickCellType:String;
        public var info:FriendInfoStruct;

        public function FriendMenuEvent(_arg1:String, _arg2:String, _arg3:FriendInfoStruct){
            super(_arg1, false, false);
            this.clickCellType = _arg2;
            this.info = _arg3;
        }
    }
}//package GameUI.Modules.Friend.model 
