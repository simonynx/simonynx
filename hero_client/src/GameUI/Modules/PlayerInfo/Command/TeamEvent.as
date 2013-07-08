//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Command {
    import flash.events.*;
    import OopsEngine.Role.*;

    public class TeamEvent extends Event {

        public static const CELL_CLICK:String = "cellClick";

        public var flagStr:String;
        public var role:GameRole;

        public function TeamEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false){
            super(_arg1, _arg2, _arg3);
        }
    }
}//package GameUI.Modules.PlayerInfo.Command 
