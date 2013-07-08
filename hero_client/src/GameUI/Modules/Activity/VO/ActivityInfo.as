//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.VO {

    public class ActivityInfo {

        public var id:uint;
        public var level:uint;
        public var price:uint;
        public var name:String;
        public var description:String;

        public function ActivityInfo(_arg1:XML){
            id = _arg1.@id;
            name = _arg1.@name;
            description = _arg1.@description;
            price = _arg1.@price;
            level = _arg1.@level;
        }
        public function toString():String{
            return (((name + "\n\n") + description));
        }

    }
}//package GameUI.Modules.Activity.VO 
