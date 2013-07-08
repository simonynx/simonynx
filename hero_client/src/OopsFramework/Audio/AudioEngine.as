//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Audio {
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class AudioEngine {

        private var volume:Number = 1;
        public var Loop:int = 2147483647;
        public var Position:Number = 0;
        public var IsPlaying:Boolean = false;
        public var PlayComplete:Function;
        private var sound:Sound;
        private var soundChannel:SoundChannel;
        private var soundTransform:SoundTransform;

        public function AudioEngine(_arg1){
            if ((_arg1 is Sound)){
                this.sound = _arg1;
            } else {
                if ((_arg1 is String)){
                    this.sound = new Sound();
                    this.sound.load(new URLRequest(_arg1));
                };
            };
            this.sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        }
        public function Stop():void{
            try {
                if (((((this.sound) && (!((this.sound.bytesLoaded == this.sound.bytesTotal))))) && ((this.sound.bytesLoaded > 0)))){
                    this.sound.close();
                };
            } catch(error:Error) {
                trace("The stream could not be closed, or the stream was not open.");
            };
            if (((IsPlaying) && (this.soundChannel))){
                this.sound.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
                this.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
                this.soundChannel.stop();
                this.soundTransform = null;
                this.soundChannel = null;
                this.sound = null;
                this.IsPlaying = false;
            };
            this.sound = null;
        }
        public function set Volume(_arg1:Number):void{
            if (_arg1 > 100){
                this.volume = 1;
            };
            if (_arg1 < 0){
                this.volume = 0;
            } else {
                this.volume = (_arg1 / 100);
            };
            if ((((IsPlaying == true)) && (soundChannel))){
                this.soundTransform = new SoundTransform(this.volume, 0);
                this.soundChannel.soundTransform = soundTransform;
            };
        }
        public function get Volume():Number{
            return ((this.volume * 100));
        }
        private function onIOError(_arg1:IOErrorEvent):void{
            trace("声音播放IO错误");
        }
        public function Play(_arg1:Number=0):void{
           // var _arg1:int = _arg1;
            try {
                if (this.IsPlaying == false){
                    this.IsPlaying = true;
                    this.soundChannel = this.sound.play(_arg1, Loop);
                    this.soundTransform = new SoundTransform(this.volume, 0);
                    if (soundChannel != null){
                        this.soundChannel.soundTransform = soundTransform;
                        this.soundChannel.addEventListener(Event.SOUND_COMPLETE, onComplete);
                    };
                };
            } catch(e:Error) {
                trace(e.getStackTrace());
            };
			
		
        }
        public function Pause():void{
            try {
                if ((((IsPlaying == true)) && (soundChannel))){
                    this.Position = soundChannel.position;
                    this.Stop();
                } else {
                    this.Play(this.Position);
                };
            } catch(e:Error) {
                trace(e.getStackTrace());
            };
        }
        private function onComplete(_arg1:Event):void{
            this.IsPlaying = false;
            if (PlayComplete != null){
                PlayComplete();
            };
        }

    }
}//package OopsFramework.Audio 
