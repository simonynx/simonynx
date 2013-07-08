//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.core {

    public class SimpleTimeline extends TweenCore {

        public var autoRemoveChildren:Boolean;
        protected var _lastChild:TweenCore;
        protected var _firstChild:TweenCore;

        public function SimpleTimeline(_arg1:Object=null){
            super(0, _arg1);
        }
        override public function renderTime(_arg1:Number, _arg2:Boolean=false, _arg3:Boolean=false):void{
            var _local5:Number;
            var _local6:TweenCore;
            var _local4:TweenCore = _firstChild;
            this.cachedTotalTime = _arg1;
            this.cachedTime = _arg1;
            while (_local4) {
                _local6 = _local4.nextNode;
                if (((_local4.active) || ((((((_arg1 >= _local4.cachedStartTime)) && (!(_local4.cachedPaused)))) && (!(_local4.gc)))))){
                    if (!_local4.cachedReversed){
                        _local4.renderTime(((_arg1 - _local4.cachedStartTime) * _local4.cachedTimeScale), _arg2, false);
                    } else {
                        _local5 = (_local4.cacheIsDirty) ? _local4.totalDuration : _local4.cachedTotalDuration;
                        _local4.renderTime((_local5 - ((_arg1 - _local4.cachedStartTime) * _local4.cachedTimeScale)), _arg2, false);
                    };
                };
                _local4 = _local6;
            };
        }
        public function addChild(_arg1:TweenCore):void{
            if (((!(_arg1.cachedOrphan)) && (_arg1.timeline))){
                _arg1.timeline.remove(_arg1, true);
            };
            _arg1.timeline = this;
            if (_arg1.gc){
                _arg1.setEnabled(true, true);
            };
            if (_firstChild){
                _firstChild.prevNode = _arg1;
            };
            _arg1.nextNode = _firstChild;
            _firstChild = _arg1;
            _arg1.prevNode = null;
            _arg1.cachedOrphan = false;
        }
        public function remove(_arg1:TweenCore, _arg2:Boolean=false):void{
            if (_arg1.cachedOrphan){
                return;
            };
            if (!_arg2){
                _arg1.setEnabled(false, true);
            };
            if (_arg1.nextNode){
                _arg1.nextNode.prevNode = _arg1.prevNode;
            } else {
                if (_lastChild == _arg1){
                    _lastChild = _arg1.prevNode;
                };
            };
            if (_arg1.prevNode){
                _arg1.prevNode.nextNode = _arg1.nextNode;
            } else {
                if (_firstChild == _arg1){
                    _firstChild = _arg1.nextNode;
                };
            };
            _arg1.cachedOrphan = true;
        }
        public function get rawTime():Number{
            return (this.cachedTotalTime);
        }

    }
}//package com.greensock.core 
