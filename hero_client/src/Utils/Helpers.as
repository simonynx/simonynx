//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;

    public class Helpers {

        private static const decode_arr:Array = [["%", "%01"], ["]", "%02"], ["[", "%03"]];
        public static const STAGE_UP_EVENT:String = "STAGE_UP_EVENT";
        private static const encode_arr:Array = [["%", "%01"], ["]", "%02"], ["\\[", "%03"]];
        public static const MOUSE_DOWN_AND_DRAGING_EVENT:String = "MOUSE_DOWN_AND_DRAGING_EVENT";

        private static var enterFrameDispatcher:Sprite = new Sprite();
        private static var _stage:Stage;

        public static function delayCall(_arg1:Function, _arg2:int=1):void{
            var fun_new:* = null;
            var param1:* = _arg1;
            var param2:int = _arg2;
            var fun:* = param1;
            var delay_frame:* = param2;
            fun_new = function (_arg1:Event):void{
                if (--delay_frame <= 0){
                    fun();
                    enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, fun_new);
                };
            };
            enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, fun_new);
        }
        public static function deCodeString(_arg1:String):String{
            var _local2:int;
            _local2 = (decode_arr.length - 1);
            while (_local2-- >= 0) {
                _arg1 = _arg1.replace(new RegExp(decode_arr[_local2][1], "g"), decode_arr[_local2][0]);
            };
            return (_arg1);
        }
        public static function setTextfieldFormat(_arg1:TextField, _arg2:Object, _arg3:Boolean=false):void{
            var _local4:String;
            var _local5:* = _arg1.getTextFormat();
            for (_local4 in _arg2) {
                _local5[_local4] = _local5[_local4];
            };
            if (_arg3){
                _arg1.setTextFormat(_local5);
            };
            _arg1.defaultTextFormat = _local5;
        }
        public static function copyProperty(_arg1:Object, _arg2:Object, _arg3:Array=null):void{
            var _local4:String;
            for each (_local4 in _arg3) {
                _arg2[_local4] = _arg1[_local4];
            };
        }
        public static function registExtendMouseEvent(_arg1:InteractiveObject):void{
            _arg1.addEventListener(MouseEvent.MOUSE_DOWN, __dobjDown);
        }
        public static function hidePosMc(_arg1:DisplayObjectContainer):void{
            var _local2:DisplayObject;
            var _local4:int;
            var _local3:* = /_pos$/;
            while (_local4 < _arg1.numChildren) {
                _local2 = _arg1.getChildAt(_local4);
                if (_local3.test(_local2.name)){
                    _local2.visible = false;
                };
                _local4++;
            };
        }
        public static function bubbleSort(_arg1:Array, _arg2:String, _arg3:Boolean):Array{
            var _local6:*;
            var _local4:int;
            var _local5:int;
            var _local7:int = _arg1.length;
            while (_local4 < _local7) {
                _local5 = 0;
                while (_local5 < (_local7 - _local4)) {
                    if (_arg3){
                        if (_arg1[_local5][_arg2] > _arg1[(_local5 + 1)][_arg2]){
                            _local6 = _arg1[_local5];
                            _arg1[_local5] = _arg1[(_local5 + 1)];
                            _arg1[(_local5 + 1)] = _local6;
                        };
                    } else {
                        if (((_arg1[(_local5 + 1)]) && ((_arg1[_local5][_arg2] < _arg1[(_local5 + 1)][_arg2])))){
                            _local6 = _arg1[_local5];
                            _arg1[_local5] = _arg1[(_local5 + 1)];
                            _arg1[(_local5 + 1)] = _local6;
                        };
                    };
                    _local5++;
                };
                _local4++;
            };
            return (_arg1);
        }
        private static function __dobjDown(_arg1:MouseEvent):void{
            var dobj:* = null;
            var fun_up:* = null;
            var fun_move:* = null;
            var param1:* = _arg1;
            var e:* = param1;
            dobj = (e.currentTarget as InteractiveObject);
            fun_up = function (_arg1:MouseEvent):void{
                dobj.dispatchEvent(new Event(STAGE_UP_EVENT));
                dobj.stage.removeEventListener(MouseEvent.MOUSE_UP, fun_up);
                dobj.stage.removeEventListener(MouseEvent.MOUSE_MOVE, fun_move);
            };
            fun_move = function (_arg1:MouseEvent):void{
                dobj.dispatchEvent(new Event(MOUSE_DOWN_AND_DRAGING_EVENT));
            };
            dobj.stage.addEventListener(MouseEvent.MOUSE_UP, fun_up);
            dobj.stage.addEventListener(MouseEvent.MOUSE_MOVE, fun_move);
        }
        public static function enCodeString(_arg1:String):String{
            var _local2:int;
            _local2 = 0;
            while (_local2 < encode_arr.length) {
                _arg1 = _arg1.replace(new RegExp(encode_arr[_local2][0], "g"), encode_arr[_local2][1]);
                _local2++;
            };
            return (_arg1);
        }
        public static function setup(_arg1:Stage):void{
            _stage = _arg1;
        }

    }
}//package Utils 
