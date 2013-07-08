//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class VisiblePlugin extends TweenPlugin {

        public static const API:Number = 1;

        protected var _target:Object;
        protected var _initVal:Boolean;
        protected var _visible:Boolean;
        protected var _tween:TweenLite;

        public function VisiblePlugin(){
            this.propName = "visible";
            this.overwriteProps = ["visible"];
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            _target = _arg1;
            _tween = _arg3;
            _initVal = _target.visible;
            _visible = Boolean(_arg2);
            return (true);
        }
        override public function set changeFactor(_arg1:Number):void{
            if ((((_arg1 == 1)) && ((((_tween.cachedDuration == _tween.cachedTime)) || ((_tween.cachedTime == 0)))))){
                _target.visible = _visible;
            } else {
                _target.visible = _initVal;
            };
        }

    }
}//package com.greensock.plugins 
