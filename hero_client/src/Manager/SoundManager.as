//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import OopsEngine.Skill.*;
    import flash.utils.*;
    import flash.media.*;
    import OopsFramework.Audio.*;

    public class SoundManager {

        private static var _instance:SoundManager;
        public static var soundLoadDic:Dictionary = new Dictionary();
        public static var soundDic:Dictionary = new Dictionary();

        private var _allowSound:Boolean;
        private var _allowMusic:Boolean;

        public static function interruptSound(_arg1:String):void{
            var _local2:SoundChannel;
            if (soundDic[_arg1]){
                _local2 = (soundDic[_arg1] as SoundChannel);
                _local2.stop();
                _local2.removeEventListener(Event.SOUND_COMPLETE, soundCompHandler);
                delete soundDic[_arg1];
            };
        }
        public static function playSoundCanInterrupt(_arg1:String):void{
            var _local2:* = null;
            var _local3:* = null;
            var _local4:* = null;
            var _arg1:* = _arg1;
            if ((((SharedManager.getInstance().allowSound == false)) || ((SharedManager.getInstance().soundVolumn == 0)))){
                return;
            };
            try {
                interruptSound(_arg1);
                _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySound(_arg1);
                _local3 = new SoundTransform((SharedManager.getInstance().soundVolumn * 0.01));
                _local4 = _local2.play(0, 0, _local3);
                if (_local4){
                    _local4.addEventListener(Event.SOUND_COMPLETE, soundCompHandler);
                };
                soundDic[_arg1] = _local4;
            } catch(e:Error) {
                trace(e.getStackTrace());
            };
        }
        public static function getInstance():SoundManager{
            if (!_instance){
                _instance = new (SoundManager)();
            };
            return (_instance);
        }
        public static function PlaySound(_arg1:String):void{
            var _local2:* = null;
            var _local3:* = null;
            var _arg1:* = _arg1;
            if ((((SharedManager.getInstance().allowSound == false)) || ((SharedManager.getInstance().soundVolumn == 0)))){
                return;
            };
            try {
                _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySound(_arg1);
                _local3 = new SoundTransform((SharedManager.getInstance().soundVolumn / 100));
                _local2.play(0, 0, _local3);
            } catch(e:Error) {
                trace(e.getStackTrace());
            };
        }
        private static function soundCompHandler(_arg1:Event):void{
            var _local2:String;
            for (_local2 in soundDic) {
                if (soundDic[_local2] == _arg1.target){
                    interruptSound(_local2);
                    break;
                };
            };
        }

        public function set allowSound(_arg1:Boolean):void{
            _allowSound = _arg1;
        }
        public function setConfig(_arg1:Boolean, _arg2:Boolean, _arg3:uint, _arg4:uint):void{
            GameCommonData.GameInstance.GameScene.GetGameScene.SetVolume(_arg3);
            if (_arg1){
                if (!GameCommonData.GameInstance.GameScene.GetGameScene.IsMusicing){
                    GameCommonData.GameInstance.GameScene.GetGameScene.MusicLoad(_arg3);
                };
            } else {
                GameCommonData.GameInstance.GameScene.GetGameScene.MusicStop();
            };
        }
        public function playLoadSound(_arg1:String, _arg2:String):void{
            var _local3:GameAudioResource;
            var _local4:AudioEngine;
            if (((GameCommonData.Scene) && (GameCommonData.Scene.IsSceneLoaded))){
                if (soundLoadDic[_arg2] == null){
                    _local3 = new GameAudioResource();
                    _local3.AudioName = _arg2;
                    _local3.OnLoadAudio = AudioController.LoadAudio;
                    _local3.AudioPath = (((GameCommonData.GameInstance.Content.RootDirectory + _arg1) + _arg2) + ".mp3");
                    _local3.AudioBR.LoadComplete = _local3.onAudioComplete;
                    _local3.AudioBR.Download.Add(_local3.AudioPath);
                    _local3.AudioBR.Load();
                    soundLoadDic[_arg2] = _arg2;
                } else {
                    if (soundLoadDic[_arg2] != null){
                        _local4 = (soundLoadDic[_arg2] as AudioEngine);
                        if (_local4){
                            AudioController.SoundPlay(_local4);
                        };
                    };
                };
            };
        }
        public function set allowMusic(_arg1:Boolean):void{
            _allowMusic = _arg1;
            if (_arg1){
                GameCommonData.GameInstance.GameScene.GetGameScene.MusicLoad(SharedManager.getInstance().musicVolumn);
            } else {
                GameCommonData.GameInstance.GameScene.GetGameScene.MusicStop();
            };
        }
        public function get allowMusic():Boolean{
            return (_allowMusic);
        }
        public function get allowSound():Boolean{
            return (_allowSound);
        }

    }
}//package Manager 
