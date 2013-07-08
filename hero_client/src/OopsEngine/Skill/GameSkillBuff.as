//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Skill {

    public class GameSkillBuff {

        public var BuffTime:int;
        public var BuffEffect:String;
        public var Level:int;
        public var BuffType:int;
        public var BuffID:int;
        public var TypeID:uint;
        public var BuffName:String;

        public static function IsShowState(_arg1:int):int{
            var _local2:* = 3;
            if (_arg1 == 1){
                _local2 = 1;
            };
            if (_arg1 == 2){
                _local2 = 2;
            };
            return (_local2);
        }
        public static function IsBuff(_arg1:int):Boolean{
            if ((((_arg1 == 1)) || ((_arg1 == 3)))){
                return (true);
            };
            return (false);
        }

    }
}//package OopsEngine.Skill 
