//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Achieve.Data {

    public class AchieveInfo {

        public var Des:String;
        public var TargetProgress:int = 0;
        public var AchievePoint:int;
        private var _CompleteTime:Number = 0;
        public var Name:String;
        public var CurrentProgress:int = 0;
        public var MainClass:int;
        public var TitleId:int;
        public var SubClass:int;
        public var SortId:int;
        public var Id:int;

        public function get CompleteTime():Number{
            if (!IsComplete){
                return (0);
            };
            return (_CompleteTime);
        }
        public function set CompleteTime(_arg1:Number):void{
            this._CompleteTime = _arg1;
        }
        public function get IsComplete():Boolean{
            return ((((TargetProgress > 0)) && ((TargetProgress == CurrentProgress))));
        }

    }
}//package GameUI.Modules.Achieve.Data 
