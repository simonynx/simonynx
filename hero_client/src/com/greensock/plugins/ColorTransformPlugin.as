//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import flash.geom.*;
    import com.greensock.*;

    public class ColorTransformPlugin extends TintPlugin {

        public static const API:Number = 1;

        public function ColorTransformPlugin(){
            this.propName = "colorTransform";
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            var _local5:String;
            var _local6:Number;
            if (!(_arg1 is DisplayObject)){
                return (false);
            };
            var _local4:ColorTransform = _arg1.transform.colorTransform;
            for (_local5 in _arg2) {
                if ((((_local5 == "tint")) || ((_local5 == "color")))){
                    if (_arg2[_local5] != null){
                        _local4.color = int(_arg2[_local5]);
                    };
                } else {
                    if ((((((_local5 == "tintAmount")) || ((_local5 == "exposure")))) || ((_local5 == "brightness")))){
                    } else {
                        _local4[_local5] = _arg2[_local5];
                    };
                };
            };
            if (!isNaN(_arg2.tintAmount)){
                _local6 = (_arg2.tintAmount / (1 - (((_local4.redMultiplier + _local4.greenMultiplier) + _local4.blueMultiplier) / 3)));
                _local4.redOffset = (_local4.redOffset * _local6);
                _local4.greenOffset = (_local4.greenOffset * _local6);
                _local4.blueOffset = (_local4.blueOffset * _local6);
                _local4.redMultiplier = (_local4.greenMultiplier = (_local4.blueMultiplier = (1 - _arg2.tintAmount)));
            } else {
                if (!isNaN(_arg2.exposure)){
                    _local4.redOffset = (_local4.greenOffset = (_local4.blueOffset = (0xFF * (_arg2.exposure - 1))));
                    _local4.redMultiplier = (_local4.greenMultiplier = (_local4.blueMultiplier = 1));
                } else {
                    if (!isNaN(_arg2.brightness)){
                        _local4.redOffset = (_local4.greenOffset = (_local4.blueOffset = Math.max(0, ((_arg2.brightness - 1) * 0xFF))));
                        _local4.redMultiplier = (_local4.greenMultiplier = (_local4.blueMultiplier = (1 - Math.abs((_arg2.brightness - 1)))));
                    };
                };
            };
            _ignoreAlpha = Boolean(((!((_arg3.vars.alpha == undefined))) && ((_arg2.alphaMultiplier == undefined))));
            init((_arg1 as DisplayObject), _local4);
            return (true);
        }

    }
}//package com.greensock.plugins 
