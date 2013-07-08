//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Graphics.Animation {
    import flash.display.*;
    import OopsFramework.*;
    import flash.utils.*;

    public class AnimationPlayer extends Bitmap {

        public static const LOOP:int = -1;
        public static const SINGLE:int = 1;

        protected var clipName:String;
        public var Clips:Dictionary;
        public var MaxHeight:int;
        public var Frames:Dictionary;
        private var eventArgs:AnimationEventArgs;
        protected var playMaxCount:int = -1;
        protected var playAnimationClip:AnimationClip;
        public var MaxWidth:int;
        protected var isPlaying:Boolean = false;
        public var offsetX:Number = 370;
        public var offsetY:Number = 200;
        public var PlayComplete:Function;
        public var PlayFrame:Function;
        protected var playCount:int;

        public function AnimationPlayer(_arg1:int=-1){
            eventArgs = new AnimationEventArgs();
            super();
            this.playMaxCount = _arg1;
        }
        public function StartClip(_arg1:String, _arg2:int=0):void{
            if (this.Clips[_arg1] != null){
                this.playAnimationClip = this.Clips[_arg1];
                this.eventArgs.CurrentClipName = _arg1;
                this.eventArgs.CurrentClipTotalFrameCount = this.playAnimationClip.Frame.length;
                this.eventArgs.CurrentClipFrameIndex = _arg2;
                this.Play();
            };
        }
        private function CalculateOffset(_arg1:AnimationFrame):void{
            if (this.playAnimationClip.TurnType){
                this.scaleX = -1;
                this.x = ((-1 * _arg1.X) + 463);
            } else {
                this.scaleX = 1;
                this.x = (_arg1.X - this.offsetX);
            };
            this.y = (_arg1.Y - this.offsetY);
            this.bitmapData = _arg1.FrameBitmapData;
        }
        public function Play():void{
            var _local3:String;
            var _local1:uint = int(this.playAnimationClip.Frame[this.eventArgs.CurrentClipFrameIndex]);
            this.playCount = 0;
            var _local2:AnimationFrame = (this.Frames[_local1] as AnimationFrame);
            if (_local2 == null){
                _local3 = "";
                _local3 = (_local3 + ("Frame:" + this.Frames));
                _local3 = (_local3 + ((("人物当前位置X" + GameCommonData.Player.Role.TileX) + "Y:") + GameCommonData.Player.Role.TileY));
                _local3 = (_local3 + ("\n帧出错:" + _local1));
                trace(_local3);
                return;
            };
            this.CalculateOffset(_local2);
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
        public function Stop():void{
            this.isPlaying = false;
        }
        public function Update(_arg1:GameTime):void{
            var _local2:AnimationFrame;
            if (((!((this.playAnimationClip == null))) && (this.isPlaying))){
                if ((((this.playMaxCount == LOOP)) || ((this.playCount < this.playMaxCount)))){
                    this.eventArgs.CurrentClipFrameIndex++;
                    if (this.eventArgs.CurrentClipFrameIndex >= this.playAnimationClip.Frame.length){
                        this.eventArgs.CurrentClipFrameIndex = 0;
                        this.playCount++;
                        if (PlayComplete != null){
                            PlayComplete(this.eventArgs);
                        };
                    };
                    if ((((this.playMaxCount == LOOP)) || ((this.playCount < this.playMaxCount)))){
                        _local2 = (this.Frames[int(this.playAnimationClip.Frame[this.eventArgs.CurrentClipFrameIndex])] as AnimationFrame);
                        if (_local2){
                            this.CalculateOffset(_local2);
                            if (PlayFrame != null){
                                PlayFrame(this.eventArgs);
                            };
                        };
                    } else {
                        this.isPlaying = false;
                    };
                };
            };
        }
        public function dispose():void{
            Clips = null;
            eventArgs = null;
            playAnimationClip = null;
            Frames = null;
        }

    }
}//package OopsEngine.Graphics.Animation 
