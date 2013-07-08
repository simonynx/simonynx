//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.Command {
    import flash.display.*;
    import flash.text.*;

    public class ActivityConstants {

        public static const DAILY_FINISH_VAL:uint = 10000;
        public static const DAILY_ADDITION_VAL:uint = 10000000;

        public static var chagerArray:Array = null;
        public static var textformat0:TextFormat = new TextFormat(null, 12, 14074524, null, null, null, null, null, TextFormatAlign.CENTER);
        public static var textformat1:TextFormat = new TextFormat(null, 12, 0x6C6C6C, null, null, null, null, null, TextFormatAlign.CENTER);
        public static var textformat2:TextFormat = new TextFormat(null, 12, 16459816, null, null, null, null, null, TextFormatAlign.CENTER);
        public static var itemIdArrlist:Array = new Array();
        public static var ChargeGoldList:Array = ["500", "1000", "2000", "5000", "10000", "20000", "50000", "100000", "200000", "30000"];
        public static var itemIdArr:Array = [];
        public static var toggleIndexs:Array = [8, 2, 3, 5, 7, 4];
        public static var chagerArraylist:Array = new Array();

        private static function textFormat(_arg1:int):TextFormat{
            if (_arg1 == 0){
                return (textformat0);
            };
            if (_arg1 == 1){
                return (textformat1);
            };
            if (_arg1 == 2){
                return (textformat2);
            };
            return (textformat0);
        }
        public static function setText(_arg1:TextField, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:DisplayObjectContainer=null, _arg7:String="", _arg8:int=0, _arg9:Boolean=false):void{
            _arg1.text = _arg7;
            if (_arg2 != 0){
                _arg1.x = _arg2;
            };
            if (_arg3 != 0){
                _arg1.y = _arg3;
            };
            if (_arg4 != 0){
                _arg1.width = _arg4;
            };
            if (_arg5 != 0){
                _arg1.height = _arg5;
            };
            if (_arg6){
                _arg6.addChild(_arg1);
            };
            var _local10:TextFormat = textFormat(_arg8);
            _arg1.setTextFormat(_local10);
            _arg1.selectable = _arg9;
        }

    }
}//package GameUI.Modules.Activity.Command 
