//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import com.greensock.core.*;

    public class TweenPlugin {

        public static const VERSION:Number = 1.32;
        public static const API:Number = 1;

        public var activeDisable:Boolean;
        protected var _changeFactor:Number = 0;
        protected var _tweens:Array;
        public var onDisable:Function;
        public var propName:String;
        public var round:Boolean;
        public var onEnable:Function;
        public var priority:int = 0;
        public var overwriteProps:Array;
        public var onComplete:Function;

        public function TweenPlugin(){
            _tweens = [];
            super();
        }
        public static function activate(_arg1:Array):Boolean{
            var _local3:Object;
            TweenLite.onPluginEvent = TweenPlugin.onTweenEvent;
            var _local2:int = _arg1.length;
            while (_local2--) {
                if (_arg1[_local2].hasOwnProperty("API")){
                    _local3 = new ((_arg1[_local2] as Class))();
                    TweenLite.plugins[_local3.propName] = _arg1[_local2];
                };
            };
            return (true);
        }
        private static function onTweenEvent(_arg1:String, _arg2:TweenLite):Boolean{
            var _local4:Boolean;
            var _local5:Array;
            var _local6:int;
            var _local3:PropTween = _arg2.cachedPT1;
            if (_arg1 == "onInit"){
                _local5 = [];
                while (_local3) {
                    _local5[_local5.length] = _local3;
                    _local3 = _local3.nextNode;
                };
                _local5.sortOn("priority", (Array.NUMERIC | Array.DESCENDING));
                _local6 = _local5.length;
                while (_local6--) {
                    PropTween(_local5[_local6]).nextNode = _local5[(_local6 + 1)];
                    PropTween(_local5[_local6]).prevNode = _local5[(_local6 - 1)];
                };
                _arg2.cachedPT1 = _local5[0];
            } else {
                while (_local3) {
                    if (((_local3.isPlugin) && (_local3.target[_arg1]))){
                        if (_local3.target.activeDisable){
                            _local4 = true;
                        };
                        var _local7 = _local3.target;
                        _local7[_arg1]();
                    };
                    _local3 = _local3.nextNode;
                };
            };
            return (_local4);
        }

        protected function updateTweens(_arg1:Number):void{
            var _local3:PropTween;
            var _local4:Number;
            var _local2:int = _tweens.length;
            if (this.round){
                while (--_local2 > -1) {
                    _local3 = _tweens[_local2];
                    _local4 = (_local3.start + (_local3.change * _arg1));
                    if (_local4 > 0){
                        _local3.target[_local3.property] = ((_local4 + 0.5) >> 0);
                    } else {
                        _local3.target[_local3.property] = ((_local4 - 0.5) >> 0);
                    };
                };
            } else {
                while (--_local2 > -1) {
                    _local3 = _tweens[_local2];
                    _local3.target[_local3.property] = (_local3.start + (_local3.change * _arg1));
                };
            };
        }
        protected function addTween(_arg1:Object, _arg2:String, _arg3:Number, _arg4, _arg5:String=null):void{
            var _local6:Number;
            if (_arg4 != null){
                _local6 = ((typeof(_arg4))=="number") ? (Number(_arg4) - _arg3) : Number(_arg4);
                if (_local6 != 0){
                    _tweens[_tweens.length] = new PropTween(_arg1, _arg2, _arg3, _local6, ((_arg5) || (_arg2)), false);
                };
            };
        }
        public function get changeFactor():Number{
            return (_changeFactor);
        }
        public function onInitTween(_arg1:Object, _arg2, _arg3:TweenLite):Boolean{
            addTween(_arg1, this.propName, _arg1[this.propName], _arg2, this.propName);
            return (true);
        }
        public function killProps(_arg1:Object):void{
            var _local2:int = this.overwriteProps.length;
            while (--_local2 > -1) {
                if ((this.overwriteProps[_local2] in _arg1)){
                    this.overwriteProps.splice(_local2, 1);
                };
            };
            _local2 = _tweens.length;
            while (--_local2 > -1) {
                if ((PropTween(_tweens[_local2]).name in _arg1)){
                    _tweens.splice(_local2, 1);
                };
            };
        }
        public function set changeFactor(_arg1:Number):void{
            updateTweens(_arg1);
            _changeFactor = _arg1;
        }

    }
}//package com.greensock.plugins 
