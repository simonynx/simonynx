//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.core {
    import com.greensock.*;

    public class TweenCore {

        public static const version:Number = 1.392;

        protected static var _classInitted:Boolean;

        public var initted:Boolean;
        protected var _hasUpdate:Boolean;
        public var active:Boolean;
        protected var _delay:Number;
        public var cachedReversed:Boolean;
        public var nextNode:TweenCore;
        public var cachedTime:Number;
        protected var _rawPrevTime:Number = -1;
        public var vars:Object;
        public var cachedTotalTime:Number;
        public var data;
        public var timeline:SimpleTimeline;
        public var cachedOrphan:Boolean;
        public var cachedStartTime:Number;
        public var prevNode:TweenCore;
        public var cachedDuration:Number;
        public var gc:Boolean;
        public var cachedPauseTime:Number;
        public var cacheIsDirty:Boolean;
        public var cachedPaused:Boolean;
        public var cachedTimeScale:Number;
        public var cachedTotalDuration:Number;

        public function TweenCore(_arg1:Number=0, _arg2:Object=null){
            this.vars = ((_arg2)!=null) ? _arg2 : {};
            this.cachedDuration = (this.cachedTotalDuration = _arg1);
            _delay = (this.vars.delay) ? Number(this.vars.delay) : 0;
            this.cachedTimeScale = (this.vars.timeScale) ? Number(this.vars.timeScale) : 1;
            this.active = Boolean((((((_arg1 == 0)) && ((_delay == 0)))) && (!((this.vars.immediateRender == false)))));
            this.cachedTotalTime = (this.cachedTime = 0);
            this.data = this.vars.data;
            if (!_classInitted){
                if (isNaN(TweenLite.rootFrame)){
                    TweenLite.initClass();
                    _classInitted = true;
                } else {
                    return;
                };
            };
            var _local3:SimpleTimeline = ((this.vars.timeline is SimpleTimeline)) ? this.vars.timeline : (this.vars.useFrames) ? TweenLite.rootFramesTimeline : TweenLite.rootTimeline;
            this.cachedStartTime = (_local3.cachedTotalTime + _delay);
            _local3.addChild(this);
            if (this.vars.reversed){
                this.cachedReversed = true;
            };
            if (this.vars.paused){
                this.paused = true;
            };
        }
        public function renderTime(_arg1:Number, _arg2:Boolean=false, _arg3:Boolean=false):void{
        }
        public function get delay():Number{
            return (_delay);
        }
        public function get duration():Number{
            return (this.cachedDuration);
        }
        public function set reversed(_arg1:Boolean):void{
            if (_arg1 != this.cachedReversed){
                this.cachedReversed = _arg1;
                setTotalTime(this.cachedTotalTime, true);
            };
        }
        public function set startTime(_arg1:Number):void{
            var _local2:Boolean = Boolean(((!((this.timeline == null))) && (((!((_arg1 == this.cachedStartTime))) || (this.gc)))));
            this.cachedStartTime = _arg1;
            if (_local2){
                this.timeline.addChild(this);
            };
        }
        public function restart(_arg1:Boolean=false, _arg2:Boolean=true):void{
            this.reversed = false;
            this.paused = false;
            this.setTotalTime((_arg1) ? -(_delay) : 0, _arg2);
        }
        public function set delay(_arg1:Number):void{
            this.startTime = (this.startTime + (_arg1 - _delay));
            _delay = _arg1;
        }
        public function resume():void{
            this.paused = false;
        }
        public function get paused():Boolean{
            return (this.cachedPaused);
        }
        public function play():void{
            this.reversed = false;
            this.paused = false;
        }
        public function set duration(_arg1:Number):void{
            this.cachedDuration = (this.cachedTotalDuration = _arg1);
            setDirtyCache(false);
        }
        public function invalidate():void{
        }
        public function complete(_arg1:Boolean=false, _arg2:Boolean=false):void{
            if (!_arg1){
                renderTime(this.totalDuration, _arg2, false);
                return;
            };
            if (this.timeline.autoRemoveChildren){
                this.setEnabled(false, false);
            } else {
                this.active = false;
            };
            if (!_arg2){
                if (((((this.vars.onComplete) && ((this.cachedTotalTime >= this.cachedTotalDuration)))) && (!(this.cachedReversed)))){
                    this.vars.onComplete.apply(null, this.vars.onCompleteParams);
                } else {
                    if (((((this.cachedReversed) && ((this.cachedTotalTime == 0)))) && (this.vars.onReverseComplete))){
                        this.vars.onReverseComplete.apply(null, this.vars.onReverseCompleteParams);
                    };
                };
            };
        }
        public function get totalTime():Number{
            return (this.cachedTotalTime);
        }
        public function get startTime():Number{
            return (this.cachedStartTime);
        }
        public function get reversed():Boolean{
            return (this.cachedReversed);
        }
        public function set currentTime(_arg1:Number):void{
            setTotalTime(_arg1, false);
        }
        protected function setDirtyCache(_arg1:Boolean=true):void{
            var _local2:TweenCore = (_arg1) ? this : this.timeline;
            while (_local2) {
                _local2.cacheIsDirty = true;
                _local2 = _local2.timeline;
            };
        }
        public function reverse(_arg1:Boolean=true):void{
            this.reversed = true;
            if (_arg1){
                this.paused = false;
            } else {
                if (this.gc){
                    this.setEnabled(true, false);
                };
            };
        }
        public function set paused(_arg1:Boolean):void{
            if (((!((_arg1 == this.cachedPaused))) && (this.timeline))){
                if (_arg1){
                    this.cachedPauseTime = this.timeline.rawTime;
                } else {
                    this.cachedStartTime = (this.cachedStartTime + (this.timeline.rawTime - this.cachedPauseTime));
                    this.cachedPauseTime = NaN;
                    setDirtyCache(false);
                };
                this.cachedPaused = _arg1;
                this.active = Boolean(((((!(this.cachedPaused)) && ((this.cachedTotalTime > 0)))) && ((this.cachedTotalTime < this.cachedTotalDuration))));
            };
            if (((!(_arg1)) && (this.gc))){
                this.setTotalTime(this.cachedTotalTime, false);
                this.setEnabled(true, false);
            };
        }
        public function kill():void{
            setEnabled(false, false);
        }
        public function set totalTime(_arg1:Number):void{
            setTotalTime(_arg1, false);
        }
        public function get currentTime():Number{
            return (this.cachedTime);
        }
        protected function setTotalTime(_arg1:Number, _arg2:Boolean=false):void{
            var _local3:Number;
            var _local4:Number;
            if (this.timeline){
                _local3 = (((this.cachedPauseTime) || ((this.cachedPauseTime == 0)))) ? this.cachedPauseTime : this.timeline.cachedTotalTime;
                if (this.cachedReversed){
                    _local4 = (this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration;
                    this.cachedStartTime = (_local3 - ((_local4 - _arg1) / this.cachedTimeScale));
                } else {
                    this.cachedStartTime = (_local3 - (_arg1 / this.cachedTimeScale));
                };
                if (!this.timeline.cacheIsDirty){
                    setDirtyCache(false);
                };
                if (this.cachedTotalTime != _arg1){
                    renderTime(_arg1, _arg2, false);
                };
            };
        }
        public function pause():void{
            this.paused = true;
        }
        public function set totalDuration(_arg1:Number):void{
            this.duration = _arg1;
        }
        public function get totalDuration():Number{
            return (this.cachedTotalDuration);
        }
        public function setEnabled(_arg1:Boolean, _arg2:Boolean=false):Boolean{
            this.gc = !(_arg1);
            if (_arg1){
                this.active = Boolean(((((!(this.cachedPaused)) && ((this.cachedTotalTime > 0)))) && ((this.cachedTotalTime < this.cachedTotalDuration))));
                if (((!(_arg2)) && (this.cachedOrphan))){
                    this.timeline.addChild(this);
                };
            } else {
                this.active = false;
                if (((!(_arg2)) && (!(this.cachedOrphan)))){
                    this.timeline.remove(this, true);
                };
            };
            return (false);
        }

    }
}//package com.greensock.core 
