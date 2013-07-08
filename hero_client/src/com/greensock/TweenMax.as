//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import com.greensock.core.*;
    import com.greensock.plugins.*;
    import com.greensock.events.*;

    public class TweenMax extends TweenLite implements IEventDispatcher {

        public static const version:Number = 11.391;

        private static var _overwriteMode:int = (OverwriteManager.enabled) ? OverwriteManager.mode : OverwriteManager.init(2);
;
        public static var killTweensOf:Function = TweenLite.killTweensOf;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;

        protected var _cyclesComplete:int = 0;
        protected var _dispatcher:EventDispatcher;
        protected var _hasUpdateListener:Boolean;
        protected var _easeType:int;
        protected var _repeatDelay:Number = 0;
        public var yoyo:Boolean;
        protected var _easePower:int;
        protected var _repeat:int = 0;

        public function TweenMax(_arg1:Object, _arg2:Number, _arg3:Object){
            super(_arg1, _arg2, _arg3);
            if (TweenLite.version < 11.2){
                throw (new Error("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com."));
            };
            this.yoyo = Boolean(this.vars.yoyo);
            _repeat = uint(this.vars.repeat);
            _repeatDelay = (this.vars.repeatDelay) ? Number(this.vars.repeatDelay) : 0;
            this.cacheIsDirty = true;
            if (((((((((((this.vars.onCompleteListener) || (this.vars.onInitListener))) || (this.vars.onUpdateListener))) || (this.vars.onStartListener))) || (this.vars.onRepeatListener))) || (this.vars.onReverseCompleteListener))){
                initDispatcher();
                if ((((_arg2 == 0)) && ((_delay == 0)))){
                    _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
                    _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                };
            };
            if (((this.vars.timeScale) && (!((this.target is TweenCore))))){
                this.cachedTimeScale = this.vars.timeScale;
            };
        }
        public static function set globalTimeScale(_arg1:Number):void{
            if (_arg1 == 0){
                _arg1 = 0.0001;
            };
            if (TweenLite.rootTimeline == null){
                TweenLite.to({}, 0, {});
            };
            var _local2:SimpleTimeline = TweenLite.rootTimeline;
            var _local3:Number = (getTimer() * 0.001);
            _local2.cachedStartTime = (_local3 - (((_local3 - _local2.cachedStartTime) * _local2.cachedTimeScale) / _arg1));
            _local2 = TweenLite.rootFramesTimeline;
            _local3 = TweenLite.rootFrame;
            _local2.cachedStartTime = (_local3 - (((_local3 - _local2.cachedStartTime) * _local2.cachedTimeScale) / _arg1));
            TweenLite.rootFramesTimeline.cachedTimeScale = (TweenLite.rootTimeline.cachedTimeScale = _arg1);
        }
        public static function fromTo(_arg1:Object, _arg2:Number, _arg3:Object, _arg4:Object):TweenMax{
            _arg4.startAt = _arg3;
            if (_arg3.immediateRender){
                _arg4.immediateRender = true;
            };
            return (new TweenMax(_arg1, _arg2, _arg4));
        }
        public static function allFromTo(_arg1:Array, _arg2:Number, _arg3:Object, _arg4:Object, _arg5:Number=0, _arg6:Function=null, _arg7:Array=null):Array{
            _arg4.startAt = _arg3;
            if (_arg3.immediateRender){
                _arg4.immediateRender = true;
            };
            return (allTo(_arg1, _arg2, _arg4, _arg5, _arg6, _arg7));
        }
        public static function pauseAll(_arg1:Boolean=true, _arg2:Boolean=true):void{
            changePause(true, _arg1, _arg2);
        }
        public static function getTweensOf(_arg1:Object):Array{
            var _local4:int;
            var _local5:int;
            var _local2:Array = masterList[_arg1];
            var _local3:Array = [];
            if (_local2){
                _local4 = _local2.length;
                _local5 = 0;
                while (--_local4 > -1) {
                    if (!TweenLite(_local2[_local4]).gc){
                        var _temp1 = _local5;
                        _local5 = (_local5 + 1);
                        var _local6 = _temp1;
                        _local3[_local6] = _local2[_local4];
                    };
                };
            };
            return (_local3);
        }
        public static function get globalTimeScale():Number{
            return (((TweenLite.rootTimeline)==null) ? 1 : TweenLite.rootTimeline.cachedTimeScale);
        }
        public static function killChildTweensOf(_arg1:DisplayObjectContainer, _arg2:Boolean=false):void{
            var _local4:Object;
            var _local5:DisplayObjectContainer;
            var _local3:Array = getAllTweens();
            var _local6:int = _local3.length;
            while (--_local6 > -1) {
                _local4 = _local3[_local6].target;
                if ((_local4 is DisplayObject)){
                    _local5 = _local4.parent;
                    while (_local5) {
                        if (_local5 == _arg1){
                            if (_arg2){
                                _local3[_local6].complete(false);
                            } else {
                                _local3[_local6].setEnabled(false, false);
                            };
                        };
                        _local5 = _local5.parent;
                    };
                };
            };
        }
        public static function delayedCall(_arg1:Number, _arg2:Function, _arg3:Array=null, _arg4:Boolean=false):TweenMax{
            return (new TweenMax(_arg2, 0, {
                delay:_arg1,
                onComplete:_arg2,
                onCompleteParams:_arg3,
                immediateRender:false,
                useFrames:_arg4,
                overwrite:0
            }));
        }
        public static function isTweening(_arg1:Object):Boolean{
            var _local4:TweenLite;
            var _local2:Array = getTweensOf(_arg1);
            var _local3:int = _local2.length;
            while (--_local3 > -1) {
                _local4 = _local2[_local3];
                if (((_local4.active) || ((((_local4.cachedStartTime == _local4.timeline.cachedTime)) && (_local4.timeline.active))))){
                    return (true);
                };
            };
            return (false);
        }
        public static function killAll(_arg1:Boolean=false, _arg2:Boolean=true, _arg3:Boolean=true):void{
            var _local5:Boolean;
            var _local4:Array = getAllTweens();
            var _local6:int = _local4.length;
            while (--_local6 > -1) {
                _local5 = (_local4[_local6].target == _local4[_local6].vars.onComplete);
                if ((((_local5 == _arg3)) || (!((_local5 == _arg2))))){
                    if (_arg1){
                        _local4[_local6].complete(false);
                    } else {
                        _local4[_local6].setEnabled(false, false);
                    };
                };
            };
        }
        private static function changePause(_arg1:Boolean, _arg2:Boolean=true, _arg3:Boolean=false):void{
            var _local5:Boolean;
            var _local4:Array = getAllTweens();
            var _local6:int = _local4.length;
            while (--_local6 > -1) {
                _local5 = (TweenLite(_local4[_local6]).target == TweenLite(_local4[_local6]).vars.onComplete);
                if ((((_local5 == _arg3)) || (!((_local5 == _arg2))))){
                    TweenCore(_local4[_local6]).paused = _arg1;
                };
            };
        }
        public static function from(_arg1:Object, _arg2:Number, _arg3:Object):TweenMax{
            _arg3.runBackwards = true;
            if (!("immediateRender" in _arg3)){
                _arg3.immediateRender = true;
            };
            return (new TweenMax(_arg1, _arg2, _arg3));
        }
        public static function allFrom(_arg1:Array, _arg2:Number, _arg3:Object, _arg4:Number=0, _arg5:Function=null, _arg6:Array=null):Array{
            _arg3.runBackwards = true;
            if (!("immediateRender" in _arg3)){
                _arg3.immediateRender = true;
            };
            return (allTo(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6));
        }
        public static function getAllTweens():Array{
            var _local4:Array;
            var _local5:int;
            var _local1:Dictionary = masterList;
            var _local2:int;
            var _local3:Array = [];
            for each (_local4 in _local1) {
                _local5 = _local4.length;
                while (--_local5 > -1) {
                    if (!TweenLite(_local4[_local5]).gc){
                        var _temp1 = _local2;
                        _local2 = (_local2 + 1);
                        var _local8 = _temp1;
                        _local3[_local8] = _local4[_local5];
                    };
                };
            };
            return (_local3);
        }
        public static function resumeAll(_arg1:Boolean=true, _arg2:Boolean=true):void{
            changePause(false, _arg1, _arg2);
        }
        public static function to(_arg1:Object, _arg2:Number, _arg3:Object):TweenMax{
            return (new TweenMax(_arg1, _arg2, _arg3));
        }
        public static function allTo(_arg1:Array, _arg2:Number, _arg3:Object, _arg4:Number=0, _arg5:Function=null, _arg6:Array=null):Array{
            var i:* = 0;
            var varsDup:* = null;
            var p:* = null;
            var onCompleteProxy:* = null;
            var onCompleteParamsProxy:* = null;
            var targets:* = _arg1;
            var duration:* = _arg2;
            var vars:* = _arg3;
            var stagger:int = _arg4;
            var onCompleteAll = _arg5;
            var onCompleteAllParams = _arg6;
            var l:* = targets.length;
            var a:* = [];
            var curDelay:* = (("delay" in vars)) ? Number(vars.delay) : 0;
            onCompleteProxy = vars.onComplete;
            onCompleteParamsProxy = vars.onCompleteParams;
            var lastIndex:* = ((stagger)<=0) ? 0 : (l - 1);
            i = 0;
            while (i < l) {
                varsDup = {};
                for (p in vars) {
                    varsDup[p] = vars[p];
                };
                varsDup.delay = curDelay;
                if ((((i == lastIndex)) && (!((onCompleteAll == null))))){
                    varsDup.onComplete = function ():void{
                        if (onCompleteProxy != null){
                            onCompleteProxy.apply(null, onCompleteParamsProxy);
                        };
                        onCompleteAll.apply(null, onCompleteAllParams);
                    };
                };
                a[a.length] = new TweenMax(targets[i], duration, varsDup);
                curDelay = (curDelay + stagger);
                i = (i + 1);
            };
            return (a);
        }

        public function dispatchEvent(_arg1:Event):Boolean{
            return (((_dispatcher)==null) ? false : _dispatcher.dispatchEvent(_arg1));
        }
        public function set timeScale(_arg1:Number):void{
            if (_arg1 == 0){
                _arg1 = 0.0001;
            };
            var _local2:Number = (((this.cachedPauseTime) || ((this.cachedPauseTime == 0)))) ? this.cachedPauseTime : this.timeline.cachedTotalTime;
            this.cachedStartTime = (_local2 - (((_local2 - this.cachedStartTime) * this.cachedTimeScale) / _arg1));
            this.cachedTimeScale = _arg1;
            setDirtyCache(false);
        }
        override public function renderTime(_arg1:Number, _arg2:Boolean=false, _arg3:Boolean=false):void{
            var _local6:Boolean;
            var _local7:Boolean;
            var _local8:Boolean;
            var _local10:Number;
            var _local11:int;
            var _local12:int;
            var _local13:Number;
            var _local4:Number = (this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration;
            var _local5:Number = this.cachedTime;
            if (_arg1 >= _local4){
                this.cachedTotalTime = _local4;
                this.cachedTime = this.cachedDuration;
                this.ratio = 1;
                _local6 = true;
                if (this.cachedDuration == 0){
                    if ((((((_arg1 == 0)) || ((_rawPrevTime < 0)))) && (!((_rawPrevTime == _arg1))))){
                        _arg3 = true;
                    };
                    _rawPrevTime = _arg1;
                };
            } else {
                if (_arg1 <= 0){
                    if (_arg1 < 0){
                        this.active = false;
                        if (this.cachedDuration == 0){
                            if (_rawPrevTime > 0){
                                _arg3 = true;
                                _local6 = true;
                            };
                            _rawPrevTime = _arg1;
                        };
                    };
                    this.cachedTotalTime = (this.cachedTime = (this.ratio = 0));
                    if (((this.cachedReversed) && (!((_local5 == 0))))){
                        _local6 = true;
                    };
                } else {
                    this.cachedTotalTime = (this.cachedTime = _arg1);
                    _local8 = true;
                };
            };
            if (_repeat != 0){
                _local10 = (this.cachedDuration + _repeatDelay);
                if (_local6){
                    if (((this.yoyo) && ((_repeat % 2)))){
                        this.cachedTime = (this.ratio = 0);
                    };
                } else {
                    if (_arg1 > 0){
                        _local11 = _cyclesComplete;
                        _cyclesComplete = ((this.cachedTotalTime / _local10) >> 0);
                        if (_cyclesComplete == (this.cachedTotalTime / _local10)){
                            _cyclesComplete--;
                        };
                        if (_local11 != _cyclesComplete){
                            _local7 = true;
                        };
                        this.cachedTime = (((this.cachedTotalTime / _local10) - _cyclesComplete) * _local10);
                        if (((this.yoyo) && ((_cyclesComplete % 2)))){
                            this.cachedTime = (this.cachedDuration - this.cachedTime);
                        } else {
                            if (this.cachedTime >= this.cachedDuration){
                                this.cachedTime = this.cachedDuration;
                                this.ratio = 1;
                                _local8 = false;
                            };
                        };
                        if (this.cachedTime <= 0){
                            this.cachedTime = (this.ratio = 0);
                            _local8 = false;
                        };
                    };
                };
            };
            if ((((_local5 == this.cachedTime)) && (!(_arg3)))){
                return;
            };
            if (!this.initted){
                init();
            };
            if (((!(this.active)) && (!(this.cachedPaused)))){
                this.active = true;
            };
            if (_local8){
                if (_easeType){
                    _local12 = _easePower;
                    _local13 = (this.cachedTime / this.cachedDuration);
                    if (_easeType == 2){
                        _local13 = (1 - _local13);
                        this.ratio = _local13;
                        while (--_local12 > -1) {
                            this.ratio = (_local13 * this.ratio);
                        };
                        this.ratio = (1 - this.ratio);
                    } else {
                        if (_easeType == 1){
                            this.ratio = _local13;
                            while (--_local12 > -1) {
                                this.ratio = (_local13 * this.ratio);
                            };
                        } else {
                            if (_local13 < 0.5){
                                _local13 = (_local13 * 2);
                                this.ratio = _local13;
                                while (--_local12 > -1) {
                                    this.ratio = (_local13 * this.ratio);
                                };
                                this.ratio = (this.ratio * 0.5);
                            } else {
                                _local13 = ((1 - _local13) * 2);
                                this.ratio = _local13;
                                while (--_local12 > -1) {
                                    this.ratio = (_local13 * this.ratio);
                                };
                                this.ratio = (1 - (0.5 * this.ratio));
                            };
                        };
                    };
                } else {
                    this.ratio = _ease(this.cachedTime, 0, 1, this.cachedDuration);
                };
            };
            if ((((((_local5 == 0)) && (!((this.cachedTotalTime == 0))))) && (!(_arg2)))){
                if (this.vars.onStart){
                    this.vars.onStart.apply(null, this.vars.onStartParams);
                };
                if (_dispatcher){
                    _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
                };
            };
            var _local9:PropTween = this.cachedPT1;
            while (_local9) {
                _local9.target[_local9.property] = (_local9.start + (this.ratio * _local9.change));
                _local9 = _local9.nextNode;
            };
            if (((_hasUpdate) && (!(_arg2)))){
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            };
            if (((_hasUpdateListener) && (!(_arg2)))){
                _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            };
            if (_local6){
                if (((_hasPlugins) && (this.cachedPT1))){
                    onPluginEvent("onComplete", this);
                };
                complete(true, _arg2);
            } else {
                if (((_local7) && (!(_arg2)))){
                    if (this.vars.onRepeat){
                        this.vars.onRepeat.apply(null, this.vars.onRepeatParams);
                    };
                    if (_dispatcher){
                        _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
                    };
                };
            };
        }
        override public function set totalDuration(_arg1:Number):void{
            if (_repeat == -1){
                return;
            };
            this.duration = ((_arg1 - (_repeat * _repeatDelay)) / (_repeat + 1));
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            if (_dispatcher == null){
                initDispatcher();
            };
            if (_arg1 == TweenEvent.UPDATE){
                _hasUpdateListener = true;
            };
            _dispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        protected function insertPropTween(_arg1:Object, _arg2:String, _arg3:Number, _arg4, _arg5:String, _arg6:Boolean, _arg7:PropTween):PropTween{
            var _local9:Array;
            var _local10:int;
            var _local8:PropTween = new PropTween(_arg1, _arg2, _arg3, ((typeof(_arg4))=="number") ? (_arg4 - _arg3) : Number(_arg4), _arg5, _arg6, _arg7);
            if (((_arg6) && ((_arg5 == "_MULTIPLE_")))){
                _local9 = _arg1.overwriteProps;
                _local10 = _local9.length;
                while (--_local10 > -1) {
                    this.propTweenLookup[_local9[_local10]] = _local8;
                };
            } else {
                this.propTweenLookup[_arg5] = _local8;
            };
            return (_local8);
        }
        override protected function init():void{
            var _local1:TweenMax;
            var _local2:String;
            var _local3:String;
            var _local4:Array;
            var _local5:Object;
            var _local6:PropTween;
            var _local7:PropTween;
            var _local8:int;
            if (this.vars.startAt){
                this.vars.startAt.overwrite = 0;
                this.vars.startAt.immediateRender = true;
                _local1 = new TweenMax(this.target, 0, this.vars.startAt);
            };
            if (_dispatcher){
                _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.INIT));
            };
            super.init();
            if ((_ease in fastEaseLookup)){
                _easeType = fastEaseLookup[_ease][0];
                _easePower = fastEaseLookup[_ease][1];
            };
            if (((!((this.vars.roundProps == null))) && (("roundProps" in TweenLite.plugins)))){
                _local4 = this.vars.roundProps;
                _local8 = _local4.length;
                while (--_local8 > -1) {
                    _local2 = _local4[_local8];
                    _local7 = this.cachedPT1;
                    while (_local7) {
                        if (_local7.name == _local2){
                            if (_local7.isPlugin){
                                _local7.target.round = true;
                            } else {
                                if (_local5 == null){
                                    _local5 = new TweenLite.plugins.roundProps();
                                    _local5.add(_local7.target, _local2, _local7.start, _local7.change);
                                    _hasPlugins = true;
                                    _local6 = insertPropTween(_local5, "changeFactor", 0, 1, "_MULTIPLE_", true, this.cachedPT1);
                                    this.cachedPT1 = _local6;
                                } else {
                                    _local5.add(_local7.target, _local2, _local7.start, _local7.change);
                                };
                                this.removePropTween(_local7);
                                this.propTweenLookup[_local2] = _local6;
                            };
                        } else {
                            if (((((_local7.isPlugin) && ((_local7.name == "_MULTIPLE_")))) && (!(_local7.target.round)))){
                                _local3 = ((" " + _local7.target.overwriteProps.join(" ")) + " ");
                                if (_local3.indexOf(((" " + _local2) + " ")) != -1){
                                    _local7.target.round = true;
                                };
                            };
                        };
                        _local7 = _local7.nextNode;
                    };
                };
            };
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            if (_dispatcher){
                _dispatcher.removeEventListener(_arg1, _arg2, _arg3);
            };
        }
        public function setDestination(_arg1:String, _arg2, _arg3:Boolean=true):void{
            var _local4:Object = {};
            _local4[_arg1] = _arg2;
            updateTo(_local4, !(_arg3));
        }
        public function willTrigger(_arg1:String):Boolean{
            return (((_dispatcher)==null) ? false : _dispatcher.willTrigger(_arg1));
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (((_dispatcher)==null) ? false : _dispatcher.hasEventListener(_arg1));
        }
        protected function initDispatcher():void{
            if (_dispatcher == null){
                _dispatcher = new EventDispatcher(this);
            };
            if ((this.vars.onInitListener is Function)){
                _dispatcher.addEventListener(TweenEvent.INIT, this.vars.onInitListener, false, 0, true);
            };
            if ((this.vars.onStartListener is Function)){
                _dispatcher.addEventListener(TweenEvent.START, this.vars.onStartListener, false, 0, true);
            };
            if ((this.vars.onUpdateListener is Function)){
                _dispatcher.addEventListener(TweenEvent.UPDATE, this.vars.onUpdateListener, false, 0, true);
                _hasUpdateListener = true;
            };
            if ((this.vars.onCompleteListener is Function)){
                _dispatcher.addEventListener(TweenEvent.COMPLETE, this.vars.onCompleteListener, false, 0, true);
            };
            if ((this.vars.onRepeatListener is Function)){
                _dispatcher.addEventListener(TweenEvent.REPEAT, this.vars.onRepeatListener, false, 0, true);
            };
            if ((this.vars.onReverseCompleteListener is Function)){
                _dispatcher.addEventListener(TweenEvent.REVERSE_COMPLETE, this.vars.onReverseCompleteListener, false, 0, true);
            };
        }
        public function set currentProgress(_arg1:Number):void{
            if (_cyclesComplete == 0){
                setTotalTime((this.duration * _arg1), false);
            } else {
                setTotalTime(((this.duration * _arg1) + (_cyclesComplete * this.cachedDuration)), false);
            };
        }
        public function get totalProgress():Number{
            return ((this.cachedTotalTime / this.totalDuration));
        }
        public function set totalProgress(_arg1:Number):void{
            setTotalTime((this.totalDuration * _arg1), false);
        }
        protected function removePropTween(_arg1:PropTween):Boolean{
            if (_arg1.nextNode){
                _arg1.nextNode.prevNode = _arg1.prevNode;
            };
            if (_arg1.prevNode){
                _arg1.prevNode.nextNode = _arg1.nextNode;
            } else {
                if (this.cachedPT1 == _arg1){
                    this.cachedPT1 = _arg1.nextNode;
                };
            };
            if (((_arg1.isPlugin) && (_arg1.target.onDisable))){
                _arg1.target.onDisable();
                if (_arg1.target.activeDisable){
                    return (true);
                };
            };
            return (false);
        }
        public function get currentProgress():Number{
            return ((this.cachedTime / this.duration));
        }
        public function get repeat():int{
            return (_repeat);
        }
        public function updateTo(_arg1:Object, _arg2:Boolean=false):void{
            var _local4:String;
            var _local5:Number;
            var _local6:PropTween;
            var _local7:Number;
            var _local3:Number = this.ratio;
            if (((((_arg2) && (!((this.timeline == null))))) && ((this.cachedStartTime < this.timeline.cachedTime)))){
                this.cachedStartTime = this.timeline.cachedTime;
                this.setDirtyCache(false);
                if (this.gc){
                    this.setEnabled(true, false);
                } else {
                    this.timeline.addChild(this);
                };
            };
            for (_local4 in _arg1) {
                this.vars[_local4] = _arg1[_local4];
            };
            if (this.initted){
                this.initted = false;
                if (!_arg2){
                    init();
                    if (((((!(_arg2)) && ((this.cachedTime > 0)))) && ((this.cachedTime < this.cachedDuration)))){
                        _local5 = (1 / (1 - _local3));
                        _local6 = this.cachedPT1;
                        while (_local6) {
                            _local7 = (_local6.start + _local6.change);
                            _local6.change = (_local6.change * _local5);
                            _local6.start = (_local7 - _local6.change);
                            _local6 = _local6.nextNode;
                        };
                    };
                };
            };
        }
        override public function set currentTime(_arg1:Number):void{
            if (_cyclesComplete == 0){
            } else {
                if (((this.yoyo) && (((_cyclesComplete % 2) == 1)))){
                    _arg1 = ((this.duration - _arg1) + (_cyclesComplete * (this.cachedDuration + _repeatDelay)));
                } else {
                    _arg1 = (_arg1 + (_cyclesComplete * (this.duration + _repeatDelay)));
                };
            };
            setTotalTime(_arg1, false);
        }
        public function get repeatDelay():Number{
            return (_repeatDelay);
        }
        public function killProperties(_arg1:Array):void{
            var _local2:Object = {};
            var _local3:int = _arg1.length;
            while (--_local3 > -1) {
                _local2[_arg1[_local3]] = true;
            };
            killVars(_local2);
        }
        public function set repeatDelay(_arg1:Number):void{
            _repeatDelay = _arg1;
            setDirtyCache(true);
        }
        public function set repeat(_arg1:int):void{
            _repeat = _arg1;
            setDirtyCache(true);
        }
        override public function complete(_arg1:Boolean=false, _arg2:Boolean=false):void{
            super.complete(_arg1, _arg2);
            if (((!(_arg2)) && (_dispatcher))){
                if ((((this.cachedTotalTime == this.cachedTotalDuration)) && (!(this.cachedReversed)))){
                    _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                } else {
                    if (((this.cachedReversed) && ((this.cachedTotalTime == 0)))){
                        _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
                    };
                };
            };
        }
        override public function invalidate():void{
            this.yoyo = Boolean((this.vars.yoyo == true));
            _repeat = (this.vars.repeat) ? Number(this.vars.repeat) : 0;
            _repeatDelay = (this.vars.repeatDelay) ? Number(this.vars.repeatDelay) : 0;
            _hasUpdateListener = false;
            if (((((!((this.vars.onCompleteListener == null))) || (!((this.vars.onUpdateListener == null))))) || (!((this.vars.onStartListener == null))))){
                initDispatcher();
            };
            setDirtyCache(true);
            super.invalidate();
        }
        public function get timeScale():Number{
            return (this.cachedTimeScale);
        }
        override public function get totalDuration():Number{
            if (this.cacheIsDirty){
                this.cachedTotalDuration = ((_repeat)==-1) ? 999999999999 : ((this.cachedDuration * (_repeat + 1)) + (_repeatDelay * _repeat));
                this.cacheIsDirty = false;
            };
            return (this.cachedTotalDuration);
        }

        TweenPlugin.activate([AutoAlphaPlugin, EndArrayPlugin, FramePlugin, RemoveTintPlugin, TintPlugin, VisiblePlugin, VolumePlugin, BevelFilterPlugin, BezierPlugin, BezierThroughPlugin, BlurFilterPlugin, ColorMatrixFilterPlugin, ColorTransformPlugin, DropShadowFilterPlugin, FrameLabelPlugin, GlowFilterPlugin, HexColorsPlugin, RoundPropsPlugin, ShortRotationPlugin, {}]);
    }
}//package com.greensock 
