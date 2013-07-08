//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import flash.events.*;

    public class TreeEvent extends Event {

        public static const CHANGE_SELECTED:String = "changeSelected";

        public var id:uint;

        public function TreeEvent(_arg1:String, _arg2:uint, _arg3:Boolean=false, _arg4:Boolean=false){
            super(_arg1, _arg3, _arg4);
            this.id = _arg2;
        }
    }
}//package GameUI.Modules.Task.Commamd 
