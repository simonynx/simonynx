//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class AutoAlphaPlugin extends TweenPlugin {

        public static const API:Number = 1;

        protected var _target:Object;
        protected var _ignoreVisible:Boolean;

        public function AutoAlphaPlugin(){
            this.propName = "autoAlpha";
            this.overwriteProps = ["alpha", "visible"];
        }
        override public function killProps(_arg1:Object):void{
            super.killProps(_arg1);
            _ignoreVisible = Boolean(("visible" in _arg1));
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            _target = _arg1;
            addTween(_arg1, "alpha", _arg1.alpha, _arg2, "alpha");
            return (true);
        }
        override public function set changeFactor(_arg1:Number):void{
            updateTweens(_arg1);
            if (!_ignoreVisible){
                _target.visible = Boolean(!((_target.alpha == 0)));
            };
        }

    }
}//package com.greensock.plugins 
