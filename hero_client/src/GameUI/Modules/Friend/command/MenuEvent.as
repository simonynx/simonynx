//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.command {
    import flash.events.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Modules.Friend.view.ui.*;

    public class MenuEvent extends Event {

        public static const Cell_RollOut:String = "Cell_RollOut";
        public static const Cell_RollOver:String = "Cell_RollOver";
        public static const CELL_DOUBLE_CLICK:String = "cellDoubleClick";
        public static const Cell_Click:String = "Cell_Click";

        public var cell:MenuItemCell;
        public var roleInfo:FriendInfoStruct;

        public function MenuEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:MenuItemCell=null, _arg5:FriendInfoStruct=null){
            super(_arg1, _arg2, _arg3);
            this.cell = _arg4;
            this.roleInfo = _arg5;
        }
    }
}//package GameUI.Modules.Friend.command 
