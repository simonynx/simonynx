//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Verification.Proxy {
    import flash.events.*;
    import flash.utils.*;

    public class VerificationData {

        public static const ANTIWALLOW_VN:uint = 2;
        public static const ANTIWALLOW_CN:uint = 1;

        private static var _playTime:uint = 0;
        public static var TIME_LIMIT_1_HOUR:int = 2;
        public static var TIME_LIMIT_5_MIN:int = 1;
        public static var HasVerify:Boolean = false;
        public static var VerifiySucess:Boolean = false;
        public static var VerificationType:uint = 1;
        public static var AlertID:uint = 0;
        public static var TIME_LIMIT_NEED_RECHARGE:int = 4;
        public static var TimeLimitFlag:int = -1;
        public static var TIME_LIMIT_2_HOUR:int = 3;
        public static var TIME_LIMIT_NOTIMELEFT:int = 0;
        private static var _time:uint;

        public static function get PlayTime():uint{
            return ((_playTime + ((getTimer() - _time) / 1000)));
        }
        public static function set PlayTime(_arg1:uint):void{
            _playTime = _arg1;
            _time = getTimer();
        }
        public static function PlayTimeCount():void{
            var __timer:* = function ():void{
                PlayTime++;
            };
            var timer:* = new Timer(1000, 0);
            timer.addEventListener(TimerEvent.TIMER, __timer);
            timer.start();
        }

    }
}//package GameUI.Modules.Verification.Proxy 
