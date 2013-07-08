//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsFramework.Audio.*;

    public class AudioController {

        public static var loginBgSound:AudioEngine;
        public static var homeSound:AudioEngine;

        public static function SoundPlay(_arg1:AudioEngine):void{
            if (SharedManager.getInstance().allowSound == true){
                _arg1.Volume = SharedManager.getInstance().soundVolumn;
                _arg1.Loop = 1;
                _arg1.Play();
            };
        }
        public static function CloseLoginSwitch(_arg1:Object, _arg2:Object):void{
            _arg2.visible = false;
            _arg1.visible = true;
            SoundLoginOff();
            SoundHomeOff();
        }
        public static function SoundHomeOff():void{
            if (homeSound){
                homeSound.Stop();
                homeSound = null;
                if (loginBgSound){
                    loginBgSound.Volume = 60;
                };
            };
        }
        public static function SoundHomeOn(_arg1:String):void{
            if (SharedManager.getInstance().allowMusic == false){
                return;
            };
            homeSound = new AudioEngine(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole).GetClassBySound(_arg1));
            homeSound.Loop = 1;
            homeSound.Play();
            homeSound.Volume = 100;
            if (loginBgSound){
                loginBgSound.Volume = 30;
            };
        }
        public static function OpenLoginSwitch(_arg1:Object, _arg2:Object):void{
            _arg2.visible = true;
            _arg1.visible = false;
            SoundLoginOn();
        }
        public static function SoundLoginOff():void{
            if (loginBgSound){
                loginBgSound.Stop();
                loginBgSound = null;
            };
        }
        public static function LoadAudio(_arg1:AudioEngine, _arg2:String):void{
            SoundManager.soundLoadDic[_arg2] = _arg1;
        }
        public static function SoundLoginOn():void{
        }

    }
}//package Manager 
