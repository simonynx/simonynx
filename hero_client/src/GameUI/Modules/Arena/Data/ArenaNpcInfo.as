//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Arena.Data {
    import flash.utils.*;

    public class ArenaNpcInfo {

        public static var dic:Dictionary = new Dictionary();

        public var info0:ArenaInfo;
        public var info1:ArenaInfo;
        public var info2:ArenaInfo;
        public var npcMaxBlood:int;
        public var npcBlood:int;
        public var team:int;

        public function ArenaNpcInfo(){
            info0 = new ArenaInfo();
            info1 = new ArenaInfo();
            info2 = new ArenaInfo();
            super();
        }
    }
}//package GameUI.Modules.Arena.Data 
