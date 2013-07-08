//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.utils.*;
    import flash.external.*;

    public class JSManager {

        private static var message:String = "";
        private static var position:uint = 0;
        private static var to:int = 0;
        private static var preTitle:String = "";
        private static var repeat:uint = 0;

        private static function caubeting():void{
            var temp:* = message.substring(position++);
            if ((((temp.length > 1)) && ((repeat > 0)))){
                try {
                    ExternalInterface.call("sendTitle", temp);
                } catch(error:Error) {
                    trace(error);
                    clearInterval(to);
                };
            } else {
                repeat--;
                if (repeat > 0){
                    showMessage(message, repeat);
                    position = 0;
                } else {
                    clearInterval(to);
                    showTitle();
                };
            };
        }
        public static function showMessage(_arg1:String, _arg2:uint=1, _arg3:uint=500):void{
            var string:* = _arg1;
            var repea:int = _arg2;
            var frequen:int = _arg3;
            if (preTitle == ""){
                try {
                    preTitle = ExternalInterface.call("getTitle");
                } catch(error:Error) {
                };
                if (preTitle == null){
                    preTitle = LanguageMgr.GetTranslation("2918英雄王座");
                };
            };
            showTitle();
            clearInterval(to);
            to = setInterval(caubeting, frequen);
            message = ("" + string);
            repeat = repea;
            position = 0;
        }
        public static function showTitle():void{
            try {
                ExternalInterface.call("sendTitle", preTitle);
            } catch(error:Error) {
                trace(error);
                clearInterval(to);
            };
        }

    }
}//package Manager 
