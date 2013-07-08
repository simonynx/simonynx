//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Scene.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import flash.net.*;
    import OopsEngine.Graphics.*;
    import flash.system.*;
    import flash.ui.*;

    public class UIUtils {

        public static const textformat1:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFF00, null, null, null, null, null, TextFormatAlign.LEFT);
        public static const textformat:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);

        public static var itemFormat:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 16711257, false, null, null, null, null, TextFormatAlign.CENTER);

        public static function checkChat(_arg1:String):Boolean{
            var _local2:int;
            var _local3:RegExp;
            var _local4:Boolean;
            if (!_arg1){
                _local4 = false;
            } else {
                _local2 = 0;
                while (_local2 < UIConstData.Filter_chat.length) {
                    _local3 = new RegExp(UIConstData.Filter_chat[_local2], "ig");
                    if (_arg1.search(_local3) >= 0){
                        _local4 = false;
                        break;
                    };
                    _local2++;
                };
            };
            return (_local4);
        }
        public static function getTextFormat(_arg1:int=12, _arg2:int=0xFFFFFF, _arg3:String="right"):TextFormat{
            var _local4:TextFormat = new TextFormat();
            _local4.size = _arg1;
            _local4.color = _arg2;
            _local4.font = LanguageMgr.DEFAULT_FONT;
            _local4.align = _arg3;
            _local4.bold;
            return (_local4);
        }
        public static function removeFocusLis(_arg1:DisplayObject):void{
            _arg1.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            _arg1.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
        }
        public static function HandleTrans(_arg1:Sprite, _arg2:GameElement):void{
            var _local5:TextField;
            var _local6:TextFormat;
            var _local7:TextField;
            var _local3:Array = _arg2.name.split("_");
            if (_local3.length <= 1){
                return;
            };
            var _local4:Rectangle = _arg1.getBounds(_arg1);
            _local5 = new TextField();
            _local6 = new TextFormat();
            _local6.align = TextFormatAlign.CENTER;
            _local6.color = 0xFFFFFF;
            _local6.size = 12;
            _local6.font = LanguageMgr.DEFAULT_FONT;
            _local5.defaultTextFormat = _local6;
            _local5.cacheAsBitmap = true;
            _local5.mouseEnabled = false;
            _local5.selectable = false;
            _local5.text = _local3[0];
            _local5.filters = OopsEngine.Graphics.Font.Stroke();
            _local5.x = _local4.x;
            _local5.y = -150;
            _local5.width = _arg1.width;
            _local5.height = 20;
            _arg1.addChild(_local5);
            _local7 = new TextField();
            _local6 = new TextFormat();
            _local6.align = TextFormatAlign.CENTER;
            _local6.color = 0xFFFF00;
            _local6.size = 12;
            _local6.font = LanguageMgr.DEFAULT_FONT;
            _local7.defaultTextFormat = _local6;
            _local7.cacheAsBitmap = true;
            _local7.mouseEnabled = false;
            _local7.selectable = false;
            _local7.text = _local3[1];
            _local7.filters = OopsEngine.Graphics.Font.Stroke();
            _local7.x = _local4.x;
            _local7.y = -130;
            _local7.width = _arg1.width;
            _local7.height = 20;
            _arg1.addChild(_local7);
        }
        public static function formatMoney(_arg1:String):String{
            var _local2:Array;
            var _local3:int;
            var _local4:String;
            var _local5:String;
            var _local6:int;
            var _local7:int;
            var _local8:String;
            var _local9:* = "";
            if (_arg1){
                if (_arg1.length < 8){
                    if (_arg1.length > 3){
                        _local2 = new Array();
                        _local3 = (_arg1.length % 3);
                        _local4 = _arg1.substr(0, _local3);
                        if (_local4.length != 0){
                            _local2.push(_local4);
                        };
                        _local5 = _arg1.substr(_local3, (_arg1.length - _local3));
                        _local6 = 0;
                        while (_local6 < _local5.length) {
                            _local8 = _local5.slice(_local6, (_local6 + 3));
                            _local2.push(_local8);
                            _local6 = (_local6 + 3);
                        };
                        _local7 = 0;
                        while (_local7 < _local2.length) {
                            if (_local7 < (_local2.length - 1)){
                                _local9 = (_local9 + (_local2[_local7] + ","));
                            } else {
                                _local9 = (_local9 + _local2[_local7]);
                            };
                            _local7++;
                        };
                    } else {
                        _local9 = _arg1;
                    };
                } else {
                    if (_arg1.length == 8){
                        _local9 = ((Number(_arg1) / 10000).toFixed(1) + "W");
                    } else {
                        _local9 = ((Number(_arg1) / 100000000).toFixed(2) + "E");
                    };
                };
            };
            return (_local9);
        }
        public static function getMoney(_arg1:Number):Array{
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local2:Array = [];
            _local3 = (_arg1 / 10000);
            _local4 = ((_arg1 - (_local3 * 10000)) / 100);
            _local5 = (_arg1 % 100);
            _local2.push(_local3);
            _local2.push(_local4);
            _local2.push(_local5);
            return (_local2);
        }
        public static function initBackPicContainer(_arg1:Sprite, _arg2:String, _arg3:Boolean=false):void{
            var _local4:Loader = new Loader();
            _local4.load(new URLRequest((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + _arg2) + ".swf")));
            _arg1.addChildAt(_local4, 0);
        }
        public static function replaceChild(_arg1:Sprite, _arg2:DisplayObject, _arg3:DisplayObject, _arg4:Boolean=true):void{
            var _local5:* = _arg1.getChildIndex(_arg2);
            _arg3.x = _arg2.x;
            _arg3.y = _arg2.y;
            if (_arg4){
                _arg3.width = _arg2.width;
                _arg3.height = _arg2.height;
            };
            _arg1.addChildAt(_arg3, _local5);
            _arg1.removeChildAt((_local5 + 1));
        }
        public static function getMiddlePos(_arg1:DisplayObject):Point{
            var _local2:Number = ((1000 - _arg1.width) >> 1);
            var _local3:Number = ((580 - _arg1.height) >> 1);
            var _local4:Point = new Point(_local2, _local3);
            return (_local4);
        }
        public static function getMoneyStandInfo(_arg1:Number, _arg2:Array):String{
            var _local6:int;
            var _local3 = "";
            var _local4:Array = getMoney(_arg1);
            var _local5:Array = _arg2;
            while (_local6 < _local4.length) {
                if ((((_local6 == 0)) && ((_local4[0] == 0)))){
                } else {
                    if ((((((_local6 == 1)) && ((_local4[0] == 0)))) && ((_local4[1] == 0)))){
                    } else {
                        _local3 = (_local3 + (_local4[_local6] + _local5[_local6]));
                    };
                };
                _local6++;
            };
            return (_local3);
        }
        public static function removeBitmap(_arg1:Sprite):void{
            var _local3:DisplayObject;
            var _local2:int;
            while (_local2 < _arg1.numChildren) {
                _local3 = _arg1.getChildAt(_local2);
                if ((_local3 is Shape)){
                    _arg1.removeChild(_local3);
                } else {
                    _local2++;
                };
                if ((_local3 is TextField)){
                    (_local3 as TextField).addEventListener(Event.CHANGE, onChange);
                };
            };
        }
        public static function ArraysortOn(_arg1:String, _arg2:Array, _arg3:int, _arg4:Boolean, _arg5:int=10):Array{
            var _local6:int;
            var _local7:int;
            var _local8:String;
            var _local9:String;
            var _local10:String;
            var _local11:String;
            var _local15:int;
            var _local16:int;
            var _local17:int;
            var _local12:Array = [];
            var _local13:Array = [];
            var _local14:Array = [];
            while (_local15 < _arg2.length) {
                if ((_arg2[_local15] is Array)){
                    _local7 = 0;
                    while (_local7 < _arg2[_local15].length) {
                        if (_local15 == 0){
                            _local12[(_local7 + (_local15 * _arg2[_local15].length))] = _arg2[_local15][_local7];
                        } else {
                            _local12[(_local7 + (_local15 * _arg2[(_local15 - 1)].length))] = _arg2[_local15][_local7];
                        };
                        _local7++;
                    };
                };
                _local15++;
            };
            switch (_arg1){
                case "CASEINSENSITIVE":
                    _local8 = String(_arg3);
                    if (_arg4 == false){
                        _local12.sortOn(_local8, Array.CASEINSENSITIVE);
                    } else {
                        _local12.sortOn(_local8, (Array.CASEINSENSITIVE | Array.DESCENDING));
                    };
                    break;
                case "NUMERIC":
                    _local9 = String(_arg3);
                    if (_arg4 == false){
                        _local12.sortOn(_local9, Array.NUMERIC);
                    } else {
                        _local12.sortOn(_local9, (Array.NUMERIC | Array.DESCENDING));
                    };
                    break;
                case "DESCENDING":
                    _local10 = String(_arg3);
                    _local12.sortOn(_local10, Array.CASEINSENSITIVE);
                    break;
                case "UNIQUESORT":
                    _local11 = String(_arg3);
                    _local12.sortOn(_local11, Array.CASEINSENSITIVE);
                    break;
            };
            while (_local16 < _local12.length) {
                _local13[int((_local16 / _arg5))] = [];
                _local16++;
            };
            while (_local17 < _local12.length) {
                _local13[int((_local17 / _arg5))][int((_local17 % _arg5))] = _local12[_local17];
                _local17++;
            };
            return (_local13);
        }
        public static function textfillWithSpace(_arg1:String, _arg2:uint):String{
            var _local3:uint;
            var _local4:int;
            if (((!(_arg1)) || ((_arg2 == 0)))){
                return ("");
            };
            var _local5:String = _arg1;
            var _local6:ByteArray = new ByteArray();
            _local6.writeMultiByte(_local5, "gb2312");
            _local6.position = 0;
            var _local7:uint = _local6.bytesAvailable;
            if (_local7 < _arg2){
                _local3 = (_arg2 - _local7);
                _local4 = 0;
                while (_local4 < _local3) {
                    _local5 = (_local5 + " ");
                    _local4++;
                };
            };
            return (_local5);
        }
        public static function getMoneyInfo(_arg1:Number):String{
            var _local5:int;
            var _local2:* = "";
            var _local3:Array = getMoney(_arg1);
            var _local4:Array = ["\\ce ", "\\cs ", "\\cc "];
            while (_local5 < _local3.length) {
                if (_local3[_local5] != 0){
                    _local2 = (_local2 + (_local3[_local5] + _local4[_local5]));
                };
                _local5++;
            };
            return (_local2);
        }
        public static function getDictionaryLength(_arg1:Dictionary):int{
            var _local2:*;
            var _local3:int;
            for (_local2 in _arg1) {
                _local3++;
            };
            return (_local3);
        }
        public static function getGlowFilter(_arg1:int=0xFF0000, _arg2:Number=1, _arg3:Number=1.5, _arg4:Number=1.5, _arg5:Number=6):GlowFilter{
            var _local6:GlowFilter = new GlowFilter();
            _local6.color = _arg1;
            _local6.alpha = _arg2;
            _local6.blurX = _arg3;
            _local6.blurY = _arg4;
            _local6.quality = BitmapFilterQuality.MEDIUM;
            _local6.strength = _arg5;
            return (_local6);
        }
        public static function getTextByCharLength(_arg1:String, _arg2:int):String{
            if (_arg2 < 1){
                return ("");
            };
            var _local3:ByteArray = new ByteArray();
            _local3.writeMultiByte(_arg1, "gb2312");
            _local3.position = 0;
            return (_local3.readMultiByte(Math.min(_arg2, _local3.bytesAvailable), "gb2312"));
        }
        public static function getStrRealLenght(_arg1:String):uint{
            var _local2:uint;
            var _local3:ByteArray = new ByteArray();
            _local3.writeMultiByte(_arg1, "gb2312");
            _local3.position = 0;
            _local2 = _local3.bytesAvailable;
            return (_local2);
        }
        public static function addFocusLis(_arg1:DisplayObject):void{
            _arg1.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            _arg1.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
        }
        private static function focusOutHandler(_arg1:FocusEvent):void{
            GameCommonData.isFocusIn = false;
            IME.enabled = false;
            GameCommonData.GameInstance.MainStage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.F12));
        }
        public static function isPermitedPetName(_arg1:String):Boolean{
            var _local3:int;
            if (!_arg1){
                return (false);
            };
            var _local2:Boolean;
            while (_local3 < UIConstData.Filter_chat.length) {
                if ((((UIConstData.Filter_chat[_local3] == "(")) || ((UIConstData.Filter_chat[_local3] == ")")))){
                } else {
                    if (_arg1.indexOf(UIConstData.Filter_chat[_local3]) >= 0){
                        _local2 = false;
                        break;
                    };
                };
                _local3++;
            };
            return (_local2);
        }
        public static function ReadString(_arg1:ByteArray):String{
            var _local2:* = 0;
            var _local3:* = _arg1.position;
            while (_local3 < _arg1.length) {
                if (_arg1[_local3] == 0){
                    _local2 = ((_local3 - _arg1.position) + 1);
                    break;
                };
                _local3++;
            };
            if (_local2 > 0){
                return (_arg1.readMultiByte(_local2, "cn-gb"));
            };
            return ("");
        }
        private static function focusInHandler(_arg1:FocusEvent):void{
            GameCommonData.isFocusIn = true;
            IME.enabled = true;
        }
        public static function DeeplyCopy(_arg1:Object):Object{
            var _local2:Object = new Object();
            var _local3:ByteArray = new ByteArray();
            _local2 = _arg1;
            _local3.writeObject(_local2);
            _local3.position = 0;
            return (_local3.readObject());
        }
        public static function isPermitedName(_arg1:String):Boolean{
            var _local3:int;
            if (!_arg1){
                return (false);
            };
            var _local2:Boolean;
            while (_local3 < UIConstData.Filter_chat.length) {
                if (_arg1.indexOf(UIConstData.Filter_chat[_local3]) >= 0){
                    _local2 = false;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        public static function filterChat(_arg1:String):String{
            var _local2:RegExp;
            var _local5:int;
            if (!_arg1){
                return ("");
            };
            var _local3 = "*";
            var _local4:String = _arg1;
            if (_local4.indexOf("六四運動")){
                _local4 = _local4.replace("六四運\\動", "*");
            };
            if (_local4.indexOf("胡錦濤")){
                _local4 = _local4.replace("胡錦\\濤", "*");
            };
            if (_local4.indexOf("學生運動")){
                _local4 = _local4.replace("學生運\\動", "*");
            };
            if (_local4.indexOf("二?六宪章")){
                _local4 = _local4.replace("二?六宪章", "*");
            };
            _local4 = _local4.replace("工??裆", "*");
            _local4 = _local4.replace("二+六宪章", "*");
            _local4 = _local4.replace("3+1+4=85月12号", "*");
            _local4 = _local4.replace(/\s*$/g, "");
            _local4 = _local4.replace(/^\s*/g, "");
            while (_local5 < UIConstData.Filter_chat.length) {
                _local2 = new RegExp(UIConstData.Filter_chat[_local5], "g");
                if (_local2.test(_local4)){
                    _local4 = _local4.replace(_local2, _local3);
                    _local4 = _local4.replace("???", "");
                    _local4 = _local4.replace("?", "");
                    _local4 = _local4.replace("\\", "");
                    trace("i:", _local5, UIConstData.Filter_chat[_local5]);
                };
                _local5++;
            };
            return (_local4);
        }
        public static function createTextField(_arg1:Number=200, _arg2:Number=16):TextField{
            var _local3:TextField = new TextField();
            _local3.defaultTextFormat = textformat1;
            _local3.defaultTextFormat.align = TextFormatAlign.LEFT;
            _local3.textColor = 14074524;
            _local3.width = _arg1;
            _local3.height = _arg2;
            _local3.selectable = false;
            return (_local3);
        }
        public static function ReplaceButtonNTextFieldToButton(_arg1:MovieClip, _arg2:String, _arg3:String):void{
            var _local4:HLabelButton = new HLabelButton(1);
            _local4.label = _arg2;
            _local4.x = _arg1[_arg3].x;
            _local4.y = _arg1[_arg3].y;
            _local4.visible = _arg1[_arg3].visible;
            if (((_arg1[_arg3]) && (_arg1[_arg3].parent))){
                _arg1[_arg3].parent.removeChild(_arg1[_arg3]);
            };
            if (((_arg1[_arg2]) && (_arg1[_arg2].parent))){
                _arg1[_arg2].parent.removeChild(_arg1[_arg2]);
            };
            _arg1.addChild(_local4);
            _arg1[("_" + _arg3)] = _local4;
            _local4.name = ("_" + _arg3);
        }
        public static function TrimString(_arg1:String, _arg2:int=3):String{
            switch (_arg2){
                case 1:
                    _arg1 = _arg1.replace(/^\s*/g, "");
                    break;
                case 2:
                    _arg1 = _arg1.replace(/\s*$/g, "");
                    break;
                case 3:
                    _arg1 = _arg1.replace(/^\s*/g, "").replace(/\s*$/g, "");
                    break;
            };
            return (_arg1);
        }
        private static function onChange(_arg1:Event):void{
            _arg1.currentTarget.setTextFormat(itemFormat);
        }
        public static function formatMoneyToTong(_arg1:uint, _arg2:uint, _arg3:uint):uint{
            return ((((10000 * _arg1) + (100 * _arg2)) + _arg3));
        }
        public static function legalRoleName(_arg1:String):Boolean{
            var _local2:int;
            var _local6:int;
            var _local3:int = _arg1.length;
            var _local4:Boolean;
            var _local5:Array = _arg1.match(/./g);
            while (_local6 < _local5.length) {
                if (_local5[_local6].match(/[一-龥]+/g)[0] != null){
                    _local3--;
                } else {
                    if (_local5[_local6].match(/[a-zA-Z0-9]/g)[0] != null){
                        _local3--;
                    };
                };
                _local6++;
            };
            if (_local3 > 0){
                _local4 = false;
            };
            return (_local4);
        }
        public static function ReplaceInputText(_arg1:MovieClip, _arg2:String, _arg3:int=2):void{
            var _local4:TextField = new TextField();
            _local4.defaultTextFormat = textformat;
            _local4.type = TextFieldType.INPUT;
            _local4.defaultTextFormat = textformat;
            _local4.x = _arg1[_arg2].x;
            _local4.y = _arg1[_arg2].y;
            _local4.width = _arg1[_arg2].width;
            _local4.height = _arg1[_arg2].height;
            if (((_arg1[_arg2]) && (_arg1[_arg2].parent))){
                _arg1[_arg2].parent.removeChild(_arg1[_arg2]);
            };
            _arg1.addChild(_local4);
            _arg1[("_" + _arg2)] = _local4;
            _local4.name = ("_" + _arg2);
            _local4.maxChars = _arg3;
        }
        public static function fangDou(_arg1:DisplayObjectContainer):void{
            var _local4:DisplayObject;
            var _local2:int = _arg1.numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = _arg1.getChildAt(_local3);
                if ((_local4 is DisplayObjectContainer)){
                    fangDou((_local4 as DisplayObjectContainer));
                } else {
                    _local4.x = int(_local4.x);
                    _local4.y = int(_local4.y);
                    _local4.width = int(_local4.width);
                    _local4.height = int(_local4.height);
                };
                _local3++;
            };
            _arg1.x = int(_arg1.x);
            _arg1.y = int(_arg1.y);
            _arg1.width = int(_arg1.width);
            _arg1.height = int(_arg1.height);
        }
        public static function TextFieldFocusEvent(_arg1:TextField, _arg2:String, _arg3:int=-1, _arg4:int=-1, _arg5:int=1, _arg6:Boolean=true):void{
            var click:* = false;
            var focusInHandler:* = null;
            var focusOutHandler:* = null;
            var mouseClickHandler:* = null;
            var tf:* = _arg1;
            var defaultStr:* = _arg2;
            var min:int = _arg3;
            var max:int = _arg4;
            var type:int = _arg5;
            var changeDefaultStr:Boolean = _arg6;
            focusInHandler = function (_arg1:FocusEvent):void{
                if (changeDefaultStr){
                    defaultStr = tf.text;
                };
                tf.text = "";
            };
            focusOutHandler = function (_arg1:FocusEvent):void{
                if (TrimString(tf.text, 3) == ""){
                    tf.text = defaultStr;
                };
                if (((!((min == -1))) && ((int(tf.text) < min)))){
                    tf.text = ("" + min);
                };
                if (((!((max == -1))) && ((int(tf.text) > max)))){
                    tf.text = ("" + max);
                };
                click = false;
            };
            mouseClickHandler = function (_arg1:MouseEvent):void{
                if (click){
                    return;
                };
                if (changeDefaultStr){
                    defaultStr = tf.text;
                };
                tf.setSelection(0, tf.text.length);
                click = true;
            };
            if (tf.type != TextFieldType.INPUT){
                throw (new Error("应该传入输入文本"));
            };
            if (type == 1){
                tf.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            } else {
                tf.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            };
            tf.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
            click = false;
        }

    }
}//package Utils 
