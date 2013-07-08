//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.VO {
    import GameUI.Modules.Activity.Command.*;

    public class ActivityVO {

        public var maxLevel:uint;
        public var level:uint;
        public var endArr:Array;
        public var name:String;
        public var targetNPC:String;
        public var timePrompt:String;
        public var id:uint;
        public var startArr:Array;
        public var attend:int;
        public var sceneID:uint;
        public var reward:String;
        public var teamType:int;
        public var type:int;
        public var total:uint;
        public var rewardCnt:int;
        public var hot:uint;
        public var picPath:String;
        private var _current:uint = 0;
        public var currentType:int;
        public var award:Array;
        public var tileX:uint;
        public var tileY:uint;
        public var targetID:int;
        private var _value:uint;
        public var rule:String = "";

        public function ActivityVO(){
            award = [];
            super();
        }
        public function set current(_arg1:uint):void{
            _current = _arg1;
            if (_current == total){
                currentType = 1;
            };
        }
        public function set Value(_arg1:uint):void{
            _value = _arg1;
            attend = (_value / ActivityConstants.DAILY_ADDITION_VAL);
        }
        public function setAward(_arg1:String):void{
            var _local3:Array;
            var _local4:int;
            var _local2:Array = _arg1.split("?");
            var _local5:int = _local2.length;
            while (_local4 < _local5) {
                _local3 = _local2[_local4].toString().split(",");
                award.push(_local3);
                _local4++;
            };
        }
        public function get current():uint{
            return (_current);
        }

    }
}//package GameUI.Modules.Activity.VO 
