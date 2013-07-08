//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;

    public class EndArrayPlugin extends TweenPlugin {

        public static const API:Number = 1;

        protected var _a:Array;
        protected var _info:Array;

        public function EndArrayPlugin(){
            _info = [];
            super();
            this.propName = "endArray";
            this.overwriteProps = ["endArray"];
        }
        public function init(_arg1:Array, _arg2:Array):void{
            _a = _arg1;
            var _local3:int = _arg2.length;
            while (_local3--) {
                if (((!((_arg1[_local3] == _arg2[_local3]))) && (!((_arg1[_local3] == null))))){
                    _info[_info.length] = new ArrayTweenInfo(_local3, _a[_local3], (_arg2[_local3] - _a[_local3]));
                };
            };
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            if (((!((_arg1 is Array))) || (!((_arg2 is Array))))){
                return (false);
            };
            init((_arg1 as Array), _arg2);
            return (true);
        }
        override public function set changeFactor(_arg1:Number):void{
            var _local3:ArrayTweenInfo;
            var _local4:Number;
            var _local2:int = _info.length;
            if (this.round){
                while (_local2--) {
                    _local3 = _info[_local2];
                    _local4 = (_local3.start + (_local3.change * _arg1));
                    if (_local4 > 0){
                        _a[_local3.index] = ((_local4 + 0.5) >> 0);
                    } else {
                        _a[_local3.index] = ((_local4 - 0.5) >> 0);
                    };
                };
            } else {
                while (_local2--) {
                    _local3 = _info[_local2];
                    _a[_local3.index] = (_local3.start + (_local3.change * _arg1));
                };
            };
        }

    }
}//package com.greensock.plugins 

class ArrayTweenInfo {

    public var change:Number;
    public var start:Number;
    public var index:uint;

    public function ArrayTweenInfo(_arg1:uint, _arg2:Number, _arg3:Number){
        this.index = _arg1;
        this.start = _arg2;
        this.change = _arg3;
    }
}
