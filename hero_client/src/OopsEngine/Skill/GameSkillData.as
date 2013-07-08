//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Skill {
    import flash.display.*;
    import flash.geom.*;
    import OopsEngine.Graphics.Animation.*;
    import flash.utils.*;

    public class GameSkillData {

        private var clips:Dictionary;
        private var frames:Dictionary;
        private var animationskill:SkillAnimation;
        private var MiddlePoint:Point;
        protected var action:Dictionary;

        public function GameSkillData(_arg1:SkillAnimation){
            action = new Dictionary();
            clips = new Dictionary();
            frames = new Dictionary();
            super();
            this.animationskill = _arg1;
        }
        public function Analyze(_arg1):void{
            var _local2:Rectangle;
            var _local3:Matrix;
            var _local4:BitmapData;
            var _local5:AnimationFrame;
            var _local6:MovieClip = (_arg1 as MovieClip);
            _local6.cacheAsBitmap = true;
            var _local7:uint = 1;
            while (_local7 <= _local6.totalFrames) {
                _local6.gotoAndStop(_local7);
                _local2 = _local6.getBounds(_local6);
                _local3 = new Matrix();
                _local3.translate(-(_local2.x), -(_local2.y));
                _local4 = new BitmapData(_local2.width, _local2.height, true, 0);
                _local4.draw(_local6, _local3);
                _local5 = new AnimationFrame();
                _local5.FrameBitmapData = _local4;
                _local5.X = _local2.x;
                _local5.Y = _local2.y;
                _local5.Width = _local2.width;
                _local5.Height = _local2.height;
                _local5.Index = _local7;
                this.frames[_local7.toString()] = _local5;
                _local7++;
            };
            var _local8:AnimationClip = new AnimationClip();
            var _local9:uint = 1;
            while (_local9 <= _local6.totalFrames) {
                CreateClip(_local9, _local8);
                _local9++;
            };
            this.animationskill.Clips = this.clips;
            this.animationskill.Frames = this.frames;
        }
        public function SetAnimationData(_arg1:SkillAnimation):void{
            _arg1.Clips = this.clips;
            _arg1.Frames = this.frames;
        }
        private function CreateClip(_arg1:int, _arg2:AnimationClip):void{
            _arg2.Name = "jn";
            _arg2.TurnType = false;
            _arg2.Frame.push(_arg1);
            this.clips[_arg2.Name] = _arg2;
        }

    }
}//package OopsEngine.Skill 
