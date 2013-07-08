//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GameTarget.VO {

    public class TargetItem {

        public var help:String = "";
        public var start:String;
        public var award:Array;
        public var target:String;
        public var name:String;
        public var status:uint = 0;
        public var distanceTime:String;
        public var limit:String;
        public var day:int;

        public function TargetItem(){
            award = [];
            super();
        }
    }
}//package GameUI.Modules.GameTarget.VO 
