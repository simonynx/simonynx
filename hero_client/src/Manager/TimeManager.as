//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.RequestSend.*;

    public class TimeManager {

        public static const Minute_TICKS:Number = 60000;
        public static const DAY_TICKS:Number = 86400000;
        public static const HOUR_TICKS:Number = 3600000;

        private static var _dispatcher:EventDispatcher = new EventDispatcher();
        public static var CHANGE:String = "change";
        private static var _instance:TimeManager;

        private var _totalGameTime:Number;
        private var _serverTick:int;
        private var _cheattime:uint = 0;
        private var _startGameTime:Date;
        private var _currentTime:Date;
        public var _startTimer:Number = 0;
        public var _startData:Number = 0;
        private var _serverDate:Date;

        public function TimeManager(){
            setup();
        }
        public static function TimeToDates(_arg1:uint):String{
            var _local2:Date = new Date((_arg1 * 1000));
            var _local3:String = String(_local2.getFullYear());
            var _local4:String = String((_local2.getMonth() + 1));
            if (_local4.length == 1){
                _local4 = ("0" + _local4);
            };
            var _local5:String = String(_local2.getDate());
            if (_local5.length == 1){
                _local5 = ("0" + _local5);
            };
            var _local6:String = String(_local2.getHours());
            if (_local6.length == 1){
                _local6 = ("0" + _local6);
            };
            var _local7:String = String(_local2.getMinutes());
            if (_local7.length == 1){
                _local7 = ("0" + _local7);
            };
            var _local8:String = ((((((((_local3 + "-") + _local4) + "-") + _local5) + " ") + _local6) + ":") + _local7);
            return (_local8);
        }
        public static function get Instance():TimeManager{
            if (_instance == null){
                _instance = new (TimeManager)();
            };
            return (_instance);
        }
        public static function getTimeText(_arg1:int, _arg2:Boolean=true, _arg3:Boolean=false):String{
            var _local4:int = (_arg1 / 3600);
            var _local5:int = ((_arg1 % 3600) / 60);
            var _local6:int = (_arg1 % 60);
            var _local7 = "";
            if ((((_local4 > 0)) && (!(_arg3)))){
                _local7 = (("0" + _local4) + ":");
            } else {
                if ((((_local4 > 0)) && (_arg3))){
                    _local7 = (("0" + _local4) + "小时");
                } else {
                    if (!_arg3){
                        _local7 = "00:";
                    } else {
                        _local7 = "00小时";
                    };
                };
            };
            if ((((_local5 < 10)) && (!(_arg3)))){
                _local7 = (_local7 + ("0" + _local5));
            } else {
                if ((((_local5 < 10)) && (_arg3))){
                    _local7 = (_local7 + (("0" + _local5) + "分钟"));
                } else {
                    if (!_arg3){
                        _local7 = (_local7 + _local5.toString());
                    } else {
                        if (_arg3){
                            _local7 = (_local7 + (_local5.toString() + "分钟"));
                        };
                    };
                };
            };
            if (_arg2){
                if (_local6 < 10){
                    _local7 = (_local7 + (":0" + _local6));
                } else {
                    _local7 = (_local7 + (":" + _local6));
                };
            };
            return (_local7);
        }

        public function TotalDaysToNow(_arg1:Date):Number{
            return (((((_serverDate.getTime() + getTimer()) - _serverTick) - _arg1.time) / DAY_TICKS));
        }
        public function get totalGameTime():int{
            return (this._totalGameTime);
        }
        public function set totalGameTime(_arg1:int):void{
            _totalGameTime = _arg1;
            _dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
        }
        public function TotalHoursToNow(_arg1:Date):Number{
            return (((((_serverDate.getTime() + getTimer()) - _serverTick) - _arg1.time) / HOUR_TICKS));
        }
        private function onDisconnect(_arg1:TimerEvent):void{
            GameCommonData.GameNets.endGameNet();
        }
        public function TimeSpanToNow(_arg1:Date):Date{
            return (new Date(Math.abs((((_serverDate.getTime() + getTimer()) - _serverTick) - _arg1.time))));
        }
        public function get currentDay():Number{
            return (Now().getDay());
        }
        public function GetLastPong():int{
            return (_serverTick);
        }
        public function TotalDaysToNow2(_arg1:Date):Number{
            var _local2:Date = Now();
            _local2.setHours(0, 0, 0, 0);
            var _local3:Date = new Date(_arg1.time);
            _local3.setHours(0, 0, 0, 0);
            return (((_local2.time - _local3.time) / DAY_TICKS));
        }
        public function ServerData():Date{
            return (new Date((((_serverDate.getTime() + getTimer()) - _serverTick) + (((_serverDate.timezoneOffset + 480) * 60) * 1000))));
        }
        public function Now():Date{
            return (new Date(((_serverDate.getTime() + getTimer()) - _serverTick)));
        }
        public function UpdateServerTime(_arg1:uint):void{
            var _local3:Timer;
            _serverTick = getTimer();
            _serverDate.setTime((_arg1 * 1000));
            var _local2:Date = new Date();
            if (Math.abs(((_local2.getTime() - _startData) - (_serverTick - _startTimer))) > (2 * 1000)){
                _cheattime++;
                if (_cheattime > 0){
                    if ((_serverTick - _startTimer) > (180 * 1000)){
                        _cheattime = 0;
                    };
                    CharacterSend.sendCurrentStep("error 检查出系统时间异常");
                };
                if (_cheattime > 1){
                    _local3 = new Timer(1000, 1);
                    _local3.addEventListener(TimerEvent.TIMER, onDisconnect);
                    _local3.start();
                    trace("检查出加速");
                    CharacterSend.sendCurrentStep("error 系统时间异常，已断开连接");
                    UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                        comfrim:null,
                        cancel:null,
                        info:"系统时间异常，已断开连接"
                    });
                } else {
                    _startData = _local2.getTime();
                    _startTimer = _serverTick;
                };
            };
        }
        public function setup():void{
            _serverDate = new Date();
            _startData = _serverDate.getTime();
            _serverTick = getTimer();
            _startTimer = _serverTick;
        }

    }
}//package Manager 
