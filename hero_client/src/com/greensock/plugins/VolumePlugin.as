//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.media.*;
    import com.greensock.*;

    public class VolumePlugin extends TweenPlugin {

        public static const API:Number = 1;

        protected var _target:Object;
        protected var _st:SoundTransform;

        public function VolumePlugin(){
            this.propName = "volume";
            this.overwriteProps = ["volume"];
        }
        override public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            if (((((isNaN(_arg2)) || (_arg1.hasOwnProperty("volume")))) || (!(_arg1.hasOwnProperty("soundTransform"))))){
                return (false);
            };
            _target = _arg1;
            _st = _target.soundTransform;
            addTween(_st, "volume", _st.volume, _arg2, "volume");
            return (true);
        }
        override public function set changeFactor(_arg1:Number):void{
            updateTweens(_arg1);
            _target.soundTransform = _st;
        }

    }
}//package com.greensock.plugins 
