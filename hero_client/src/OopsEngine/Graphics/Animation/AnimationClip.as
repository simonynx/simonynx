//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Graphics.Animation {

    public class AnimationClip {

        public var FrameCount:int;
        public var OffsetX:int;
        public var OffsetY:int;
        public var Name:String;
        public var Frame:Array;
        public var TurnType:Boolean;

        public function AnimationClip(){
            Frame = [];
            super();
        }
    }
}//package OopsEngine.Graphics.Animation 
