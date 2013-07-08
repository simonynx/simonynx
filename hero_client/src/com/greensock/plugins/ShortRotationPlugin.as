//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class ShortRotationPlugin extends TweenPlugin {

        public static const API:Number = 1;

        public function ShortRotationPlugin(){
            this.propName = "shortRotation";
            this.overwriteProps = [];
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            var _local4:String;
            if (typeof(_arg2) == "number"){
                return (false);
            };
            for (_local4 in _arg2) {
                initRotation(_arg1, _local4, _arg1[_local4], ((typeof(_arg2[_local4]))=="number") ? Number(_arg2[_local4]) : (_arg1[_local4] + Number(_arg2[_local4])));
            };
            return (true);
        }
        public function initRotation(_arg1:Object, _arg2:String, _arg3:Number, _arg4:Number):void{
            var _local5:Number = ((_arg4 - _arg3) % 360);
            if (((_arg4 - _arg3) % 360) != (_local5 % 180)){
                _local5 = ((_local5)<0) ? (_local5 + 360) : (_local5 - 360);
            };
            addTween(_arg1, _arg2, _arg3, (_arg3 + _local5), _arg2);
            this.overwriteProps[this.overwriteProps.length] = _arg2;
        }

    }
}//package com.greensock.plugins 
