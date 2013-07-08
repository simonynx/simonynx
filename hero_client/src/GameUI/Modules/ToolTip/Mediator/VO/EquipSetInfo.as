//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator.VO {
    import flash.utils.*;

    public class EquipSetInfo {

        public var setId:int;
        public var collectInfoList:Dictionary;
        public var equipIdList:Array;
        public var setName:String;

        public function EquipSetInfo(){
            collectInfoList = new Dictionary();
            super();
        }
    }
}//package GameUI.Modules.ToolTip.Mediator.VO 
