//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import flash.geom.*;
    import com.greensock.*;
    import com.greensock.core.*;

    public class TintPlugin extends TweenPlugin {

        public static const API:Number = 1;

        protected static var _props:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

        protected var _ct:ColorTransform;
        protected var _transform:Transform;
        protected var _ignoreAlpha:Boolean;

        public function TintPlugin(){
            this.propName = "tint";
            this.overwriteProps = ["tint"];
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            if (!(_arg1 is DisplayObject)){
                return (false);
            };
            var _local4:ColorTransform = new ColorTransform();
            if (((!((_arg2 == null))) && (!((_arg3.vars.removeTint == true))))){
                _local4.color = uint(_arg2);
            };
            _ignoreAlpha = true;
            init((_arg1 as DisplayObject), _local4);
            return (true);
        }
        override public function set changeFactor(_arg1:Number):void{
            var _local2:ColorTransform;
            updateTweens(_arg1);
            if (_ignoreAlpha){
                _local2 = _transform.colorTransform;
                _ct.alphaMultiplier = _local2.alphaMultiplier;
                _ct.alphaOffset = _local2.alphaOffset;
            };
            _transform.colorTransform = _ct;
        }
        public function init(_arg1:DisplayObject, _arg2:ColorTransform):void{
            var _local4:String;
            _transform = _arg1.transform;
            _ct = _transform.colorTransform;
            var _local3:int = _props.length;
            while (_local3--) {
                _local4 = _props[_local3];
                if (_ct[_local4] != _arg2[_local4]){
                    _tweens[_tweens.length] = new PropTween(_ct, _local4, _ct[_local4], (_arg2[_local4] - _ct[_local4]), "tint", false);
                };
            };
        }

    }
}//package com.greensock.plugins 
