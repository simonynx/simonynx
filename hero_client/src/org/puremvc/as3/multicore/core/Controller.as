//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.core {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class Controller implements IController {

        protected static var instanceMap:Array = new Array();

        protected const MULTITON_MSG:String = "Controller instance for this Multiton key already constructed!";

        protected var commandMap:Array;
        protected var view:IView;
        protected var multitonKey:String;

        public function Controller(_arg1:String){
            if (instanceMap[_arg1] != null){
                throw (Error(MULTITON_MSG));
            };
            multitonKey = _arg1;
            instanceMap[multitonKey] = this;
            commandMap = new Array();
            initializeController();
        }
        public static function removeController(_arg1:String):void{
            delete instanceMap[_arg1];
        }
        public static function getInstance(_arg1:String):IController{
            if (instanceMap[_arg1] == null){
                instanceMap[_arg1] = new Controller(_arg1);
            };
            return (instanceMap[_arg1]);
        }

        public function removeCommand(_arg1:String):void{
            if (hasCommand(_arg1)){
                view.removeObserver(_arg1, this);
                commandMap[_arg1] = null;
            };
        }
        public function registerCommand(_arg1:String, _arg2:Class):void{
            if (commandMap[_arg1] == null){
                view.registerObserver(_arg1, new Observer(executeCommand, this));
            };
            commandMap[_arg1] = _arg2;
        }
        protected function initializeController():void{
            view = View.getInstance(multitonKey);
        }
        public function hasCommand(_arg1:String):Boolean{
            return (!((commandMap[_arg1] == null)));
        }
        public function executeCommand(_arg1:INotification):void{
            var _local2:Class = commandMap[_arg1.getName()];
            if (_local2 == null){
                return;
            };
            var _local3:ICommand = new (_local2)();
            _local3.initializeNotifier(multitonKey);
            _local3.execute(_arg1);
        }

    }
}//package org.puremvc.as3.multicore.core 
