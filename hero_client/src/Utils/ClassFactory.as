//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.utils.*;

    public class ClassFactory {

        public var properties:Object = null;
        public var generator:Class;

        public function ClassFactory(_arg1:Class=null){
            this.generator = _arg1;
        }
        public static function copyProperties(_arg1:Object, _arg2:Object):Object{
            var _local3:Array;
            var _local4:int;
            if (((_arg1) && (_arg2))){
                _local3 = getObjectPropertyName(_arg1);
                _local4 = 0;
                while (_local4 < _local3.length) {
                    _arg2[_local3[_local4]] = _arg1[_local3[_local4]];
                    _local4++;
                };
            };
            return (_arg2);
        }
        public static function getObjectPropertyName(_arg1:Object):Array{
            var _local6:int;
            var _local2:* = describeType(_arg1);
            var _local3:* = _local2.accessor;
            var _local4:* = _local2.variable;
            var _local5:* = new Array();
            _local6 = 0;
            while (_local6 < _local3.length()) {
                if (_local3[_local6].@access != "writeonly"){
                    if (_local3[_local6].@access == "readwrite"){
                        _local5.push(_local3[_local6].@name.toXMLString());
                    };
                };
                _local6++;
            };
            _local6 = 0;
            while (_local6 < _local4.length()) {
                _local5.push(_local4[_local6].@name.toXMLString());
                _local6++;
            };
            return (_local5);
        }
        public static function copyPropertiesByTarget(_arg1:Object, _arg2:Object):Object{
            var _local3:Array;
            var _local4:int;
            if (((_arg1) && (_arg2))){
                _local3 = getObjectPropertyName(_arg2);
                _local4 = 0;
                while (_local4 < _local3.length) {
                    _arg2[_local3[_local4]] = _arg1[_local3[_local4]];
                    _local4++;
                };
            };
            return (_arg2);
        }

        public function newInstance(){
            var _local1:String;
            var _local2:* = new generator();
            if (properties != null){
                for (_local1 in properties) {
                    _local2[_local1] = properties[_local1];
                };
            };
            return (_local2);
        }

    }
}//package Utils 
