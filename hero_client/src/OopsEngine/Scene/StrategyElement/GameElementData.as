//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement {
    import flash.display.*;
    import flash.geom.*;
    import OopsEngine.Graphics.Animation.*;
    import flash.utils.*;

    public class GameElementData {

        private var maxWidth:int = 0;
        private var clips:Dictionary;
        private var frames:Dictionary;
        private var maxHeight:int = 0;
        private var lazy:Function;
        public var ClipHeight:int = 0;
        public var resourceName:String;
        protected var action:Dictionary;

        public function GameElementData(){
            action = new Dictionary();
            clips = new Dictionary();
            frames = new Dictionary();
            super();
        }
        private function CreateClip(_arg1:String, _arg2:String, _arg3:int):void{
            var _local4:int;
            var _local5:AnimationClip = new AnimationClip();
            _local5.Name = (_arg1 + this.CreateDirection(_arg3));
            if ((((((_arg3 == 6)) || ((_arg3 == 7)))) || ((_arg3 == 8)))){
                _local5.TurnType = true;
            } else {
                _local5.TurnType = false;
            };
            var _local6:Array = _arg2.split("-");
            if (_local6.length > 1){
                _local4 = int(_local6[0]);
                while (_local4 <= int(_local6[1])) {
                    _local5.Frame.push(_local4);
                    this.clips[_local5.Name] = _local5;
                    _local4++;
                };
            } else {
                _local5.Frame.push(_local6[0]);
                this.clips[_local5.Name] = _local5;
            };
        }
        public function Analyze(_arg1):void{
            var _local3:Rectangle;
            var _local4:Matrix;
            var _local5:BitmapData;
            var _local6:AnimationFrame;
            var _local9:int;
            var _local10:uint;
            var _local11:MovieClip;
            var _local12:String;
            var _local13:Array;
            var _local14:Bitmap;
            var _local15:uint;
            var _local2:int = getTimer();
            var _local7:MovieClip = (_arg1 as MovieClip);
            var _local8:uint = 1;
            if (_local7.numChildren > 3){
                _local9 = 0;
                _local10 = _local7.numChildren;
                while (_local9 < _local7.numChildren) {
                    _local11 = (_local7.getChildAt(_local9) as MovieClip);
                    _local12 = _local11.name;
                    _local13 = _local12.split("_");
                    _local14 = Bitmap(_local11.getChildAt(0));
                    _local8 = uint(_local13[1]);
                    _local3 = new Rectangle(_local13[2], _local13[3], _local11.width, _local11.height);
                    _local5 = _local14.bitmapData;
                    if (_local5 == null){
                        _local5 = new BitmapData(_local11.width, _local11.height, true, 0);
                    };
                    _local6 = new AnimationFrame();
                    _local6.FrameBitmapData = _local5;
                    _local6.X = _local3.x;
                    _local6.Y = _local3.y;
                    _local6.Width = _local3.width;
                    _local6.Height = _local3.height;
                    _local6.Index = _local8;
                    if (_local6.Width > this.maxWidth){
                        this.maxWidth = _local6.Width;
                    };
                    if (_local6.Height > this.maxHeight){
                        this.maxHeight = _local6.Height;
                    };
                    this.frames[(_local8 + 1).toString()] = _local6;
                    _local9++;
                };
                _local9 = 0;
                while (_local9 < _local7.totalFrames) {
                    if (this.frames[_local9] == null){
                        this.frames[_local9] = new AnimationFrame();
                        this.frames[_local9].FrameBitmapData = new BitmapData(100, 100, true, 0);
                    };
                    _local9++;
                };
                analyzeComplete();
            } else {
                _local15 = 1;
                while (_local15 <= _local7.totalFrames) {
                    _local7.gotoAndStop(_local15);
                    _local3 = _local7.getBounds(_local7);
                    _local4 = new Matrix();
                    _local4.translate(-(_local3.x), -(_local3.y));
                    _local5 = new BitmapData(_local3.width, _local3.height, true, 0);
                    _local5.draw(_local7, _local4);
                    _local6 = new AnimationFrame();
                    _local6.FrameBitmapData = _local5;
                    _local6.X = _local3.x;
                    _local6.Y = _local3.y;
                    _local6.Width = _local3.width;
                    _local6.Height = _local3.height;
                    _local6.Index = _local15;
                    if (_local6.Width > this.maxWidth){
                        this.maxWidth = _local6.Width;
                    };
                    if (_local6.Height > this.maxHeight){
                        this.maxHeight = _local6.Height;
                    };
                    this.frames[_local15.toString()] = _local6;
                    _local15++;
                };
                analyzeComplete();
            };
        }
        private function analyzeComplete():void{
            this.CreateActionClips(GameElementSkins.ACTION_STATIC, this.action[GameElementSkins.ACTION_STATIC]);
            this.CreateActionClips(GameElementSkins.ACTION_NEAR_ATTACK, this.action[GameElementSkins.ACTION_NEAR_ATTACK]);
            this.CreateActionClips(GameElementSkins.ACTION_DEAD, this.action[GameElementSkins.ACTION_DEAD]);
            this.CreateActionClips(GameElementSkins.ACTION_RUN, this.action[GameElementSkins.ACTION_RUN]);
            this.CreateActionClips(GameElementSkins.ACTION_MOUNT_STATIC, this.action[GameElementSkins.ACTION_MOUNT_STATIC]);
            this.CreateActionClips(GameElementSkins.ACTION_MOUNT_RUN, this.action[GameElementSkins.ACTION_MOUNT_RUN]);
            this.CreateActionClips(GameElementSkins.ACTION_MEDITATION, this.action[GameElementSkins.ACTION_MEDITATION]);
        }
        private function CreateDirection(_arg1:int):int{
            switch (_arg1){
                case 1:
                    return (2);
                case 2:
                    return (1);
                case 3:
                    return (4);
                case 4:
                    return (7);
                case 5:
                    return (8);
                case 6:
                    return (9);
                case 7:
                    return (6);
                case 8:
                    return (3);
            };
            return (5);
        }
        private function CreateActionClips(_arg1:String, _arg2:Array):void{
            var _local3:String;
            var _local4 = 1;
            for each (_local3 in _arg2) {
                this.CreateClip(_arg1, _local3, _local4);
                if ((((((_local4 == 2)) || ((_local4 == 3)))) || ((_local4 == 4)))){
                    this.CreateClip(_arg1, _local3, (10 - _local4));
                };
                _local4++;
            };
        }
        public function SetAnimationData(_arg1:AnimationPlayer):void{
            _arg1.MaxWidth = this.maxWidth;
            _arg1.MaxHeight = this.maxHeight;
            _arg1.Clips = this.clips;
            _arg1.Frames = this.frames;
        }

    }
}//package OopsEngine.Scene.StrategyElement 
