//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HTree {
    import flash.events.*;

    public class HTreeEvent extends Event {

        public static const DOUBLE_CLICK_TREE:String = "doubleClickTree";
        public static const CHANGE_SELECTED:String = "changeSelected";
        public static const GROUP_SELECTED:String = "groupSelected";
        public static const CLICK_TREE_CELL:String = "clickTreeCell";

        public var id:uint;

        public function HTreeEvent(_arg1:String, _arg2:uint=0, _arg3:Boolean=false, _arg4:Boolean=false){
            super(_arg1, _arg3, _arg4);
            this.id = _arg2;
        }
    }
}//package GameUI.View.HTree 
