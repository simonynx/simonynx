//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class FramePlugin extends TweenPlugin {

        public static const API:Number = 1;

        protected var _target:MovieClip;
        public var frame:int;

        public function FramePlugin(){
            this.propName = "frame";
            this.overwriteProps = ["frame", "frameLabel"];
            this.round = true;
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            if (((!((_arg1 is MovieClip))) || (isNaN(_arg2)))){
                return (false);
            };
            _target = (_arg1 as MovieClip);
            this.frame = _target.currentFrame;
            addTween(this, "frame", this.frame, _arg2, "frame");
            return (true);
        }
        override public function set changeFactor(_arg1:Number):void{
            updateTweens(_arg1);
            _target.gotoAndStop(this.frame);
        }

    }
}//package com.greensock.plugins 
