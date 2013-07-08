//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import flash.events.*;

    public class DropEvent extends Event {

        public static const DRAG_THREW:String = "dragThrew";
        public static const SKILLITEMDRAGED:String = "skillItemDarged";
        public static const DRAG_DROPPED:String = "dragDropped";

        public var Data:Object;

        public function DropEvent(_arg1:String, _arg2:Object=null){
            super(_arg1);
            Data = _arg2;
        }
        override public function clone():Event{
            return (new DropEvent(type, Data));
        }

    }
}//package GameUI.View.items 
