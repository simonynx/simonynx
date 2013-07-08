//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.core {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class View implements IView {

        protected static var instanceMap:Array = new Array();

        protected const MULTITON_MSG:String = "View instance for this Multiton key already constructed!";

        protected var multitonKey:String;
        protected var observerMap:Array;
        protected var mediatorMap:Array;

        public function View(_arg1:String){
            if (instanceMap[_arg1] != null){
                throw (Error(MULTITON_MSG));
            };
            multitonKey = _arg1;
            instanceMap[multitonKey] = this;
            mediatorMap = new Array();
            observerMap = new Array();
            initializeView();
        }
        public static function removeView(_arg1:String):void{
            delete instanceMap[_arg1];
        }
        public static function getInstance(_arg1:String):IView{
            if (instanceMap[_arg1] == null){
                instanceMap[_arg1] = new View(_arg1);
            };
            return (instanceMap[_arg1]);
        }

        public function removeObserver(_arg1:String, _arg2:Object):void{
            var _local3:Array = (observerMap[_arg1] as Array);
            var _local4:int;
            while (_local4 < _local3.length) {
                if (Observer(_local3[_local4]).compareNotifyContext(_arg2) == true){
                    _local3.splice(_local4, 1);
                    break;
                };
                _local4++;
            };
            if (_local3.length == 0){
                delete observerMap[_arg1];
            };
        }
        public function hasMediator(_arg1:String):Boolean{
            return (!((mediatorMap[_arg1] == null)));
        }
        public function notifyObservers(_arg1:INotification):void{
            var _local2:Array;
            var _local3:Array;
            var _local4:IObserver;
            var _local5:Number;
            if (observerMap[_arg1.getName()] != null){
                _local2 = (observerMap[_arg1.getName()] as Array);
                _local3 = new Array();
                _local5 = 0;
                while (_local5 < _local2.length) {
                    _local4 = (_local2[_local5] as IObserver);
                    _local3.push(_local4);
                    _local5++;
                };
                _local5 = 0;
                while (_local5 < _local3.length) {
                    _local4 = (_local3[_local5] as IObserver);
                    _local4.notifyObserver(_arg1);
                    _local5++;
                };
            };
        }
        protected function initializeView():void{
        }
        public function registerMediator(_arg1:IMediator):void{
            var _local3:Observer;
            var _local4:Number;
            if (mediatorMap[_arg1.getMediatorName()] != null){
                return;
            };
            _arg1.initializeNotifier(multitonKey);
            mediatorMap[_arg1.getMediatorName()] = _arg1;
            var _local2:Array = _arg1.listNotificationInterests();
            if (_local2.length > 0){
                _local3 = new Observer(_arg1.handleNotification, _arg1);
                _local4 = 0;
                while (_local4 < _local2.length) {
                    registerObserver(_local2[_local4], _local3);
                    _local4++;
                };
            };
            _arg1.onRegister();
        }
        public function removeMediator(_arg1:String):IMediator{
            var _local3:Array;
            var _local4:Number;
            var _local2:IMediator = (mediatorMap[_arg1] as IMediator);
            if (_local2){
                _local3 = _local2.listNotificationInterests();
                _local4 = 0;
                while (_local4 < _local3.length) {
                    removeObserver(_local3[_local4], _local2);
                    _local4++;
                };
                delete mediatorMap[_arg1];
                _local2.onRemove();
            };
            return (_local2);
        }
        public function registerObserver(_arg1:String, _arg2:IObserver):void{
            if (observerMap[_arg1] != null){
                observerMap[_arg1].push(_arg2);
            } else {
                observerMap[_arg1] = [_arg2];
            };
        }
        public function retrieveMediator(_arg1:String):IMediator{
            return (mediatorMap[_arg1]);
        }

    }
}//package org.puremvc.as3.multicore.core 
