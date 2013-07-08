//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Skill {
    import flash.display.*;
    import OopsFramework.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import OopsEngine.Graphics.Animation.*;
    import flash.utils.*;
    import OopsFramework.Utils.*;
    import OopsEngine.Pool.*;

    public class SkillAnimation extends Bitmap implements IPoolClass {

        public static const LOOP:int = -1;
        public static const SINGLE:int = 1;

        public var PlayFrame:Function;
        public var Clips:Dictionary;
        public var guid:uint;
        public var MaxHeight:int;
        public var IsPool:Boolean = false;
        public var eventArgs:AnimationEventArgs;
        public var playAnimationClip:AnimationClip;
        protected var isPlaying:Boolean = false;
        public var offsetX:Number = 0;
        public var offsetY:Number = 0;
        public var PlayComplete:Function;
        public var gameScene:GameSceneLayer;
        protected var playCount:int;
        public var Frames:Dictionary;
        protected var playMaxCount:int = -1;
        public var player:GameElementAnimal;
        public var MaxWidth:int;
        private var frameRate:OopsFramework.Utils.Timer;
        public var isLoop:Boolean = false;
        public var IsPlayComplete:Boolean = false;
        protected var clipName:String;

        public function SkillAnimation(){
            frameRate = new OopsFramework.Utils.Timer();
            eventArgs = new AnimationEventArgs();
            super();
        }
        public static function recycleSkillAnimation(_arg1:SkillAnimation):void{
            ScenePool.skillAnimationPool.disposeObj(_arg1);
        }
        public static function createSkillAnimation():SkillAnimation{
            return ((ScenePool.skillAnimationPool.createObj(SkillAnimation) as SkillAnimation));
        }

        public function set FrameRate(_arg1:uint):void{
            this.frameRate.Frequency = _arg1;
        }
        public function dispose():void{
            Clips = null;
            Frames = null;
            player = null;
            bitmapData = null;
            PlayComplete = null;
            PlayFrame = null;
            playAnimationClip = null;
            gameScene = null;
        }
        public function reSet(_arg1:Array):void{
            IsPlayComplete = false;
            playCount = 0;
            offsetX = 0;
            offsetY = 0;
            playMaxCount = -1;
            clipName = "";
            isLoop = false;
            guid = 0;
        }
        public function StartClip(_arg1:String, _arg2:int=0, _arg3:uint=15):void{
            if (this.Clips[_arg1] != null){
                this.playAnimationClip = this.Clips[_arg1];
                this.eventArgs.CurrentClipName = _arg1;
                this.eventArgs.CurrentClipTotalFrameCount = this.playAnimationClip.Frame.length;
                this.eventArgs.CurrentClipFrameIndex = _arg2;
                this.frameRate.Frequency = _arg3;
                this.Play();
            };
        }
        public function get FrameRate():uint{
            return (this.frameRate.Frequency);
        }
        public function Play():void{
            this.playCount = 0;
            var _local1:AnimationFrame = (this.Frames[int(this.playAnimationClip.Frame[this.eventArgs.CurrentClipFrameIndex])] as AnimationFrame);
            this.CalculateOffset(_local1);
            this.bitmapData = _local1.FrameBitmapData;
            if (this.playAnimationClip.Frame.length > 1){
                this.isPlaying = true;
            } else {
                if (PlayFrame != null){
                    PlayFrame(this.eventArgs);
                };
                this.isPlaying = false;
            };
        }
        public function Pause():void{
            if (this.isPlaying == true){
                this.isPlaying = false;
            } else {
                this.isPlaying = true;
            };
        }
        public function Update(_arg1:GameTime):void{
            var _local2:AnimationFrame;
            if (frameRate.IsNextTime(_arg1)){
                if (((!((this.playAnimationClip == null))) && (this.isPlaying))){
                    if ((((this.playMaxCount == LOOP)) || ((this.playCount < this.playMaxCount)))){
                        this.eventArgs.CurrentClipFrameIndex++;
                        if (this.eventArgs.CurrentClipFrameIndex >= this.playAnimationClip.Frame.length){
                            this.eventArgs.CurrentClipFrameIndex = 0;
                            if (isLoop){
                                this.playCount = 0;
                            } else {
                                this.playCount++;
                                if (PlayComplete != null){
                                    PlayComplete(this);
                                };
                                IsPlayComplete = true;
                            };
                        };
                        if ((((this.playMaxCount == LOOP)) || ((this.playCount < this.playMaxCount)))){
                            _local2 = (this.Frames[int(this.playAnimationClip.Frame[this.eventArgs.CurrentClipFrameIndex])] as AnimationFrame);
                            this.bitmapData = _local2.FrameBitmapData;
                            this.CalculateOffset(_local2);
                            if (PlayFrame != null){
                                PlayFrame(this.eventArgs);
                            };
                        } else {
                            this.isPlaying = false;
                        };
                        if (((IsPlayComplete) && (IsPool))){
                            recycleSkillAnimation(this);
                        };
                    };
                };
            };
        }
        private function CalculateOffset(_arg1:AnimationFrame):void{
            this.x = (_arg1.X + offsetX);
            this.y = (_arg1.Y + offsetY);
        }

    }
}//package OopsEngine.Skill 
