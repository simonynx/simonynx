//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.patterns.facade {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;
    import org.puremvc.as3.multicore.core.*;

    public class Facade implements IFacade {

        protected static var instanceMap:Array = new Array();

        protected const MULTITON_MSG:String = "Facade instance for this Multiton key already constructed!";

        protected var multitonKey:String;
        protected var controller:IController;
        protected var model:IModel;
        protected var view:IView;

        public function Facade(_arg1:String){
            if (instanceMap[_arg1] != null){
                throw (Error(MULTITON_MSG));
            };
            initializeNotifier(_arg1);
            instanceMap[multitonKey] = this;
            initializeFacade();
        }
        public static function hasCore(_arg1:String):Boolean{
            return (!((instanceMap[_arg1] == null)));
        }
        public static function getInstance(_arg1:String):IFacade{
            if (instanceMap[_arg1] == null){
                instanceMap[_arg1] = new Facade(_arg1);
            };
            return (instanceMap[_arg1]);
        }
        public static function removeCore(_arg1:String):void{
            if (instanceMap[_arg1] == null){
                return;
            };
            Model.removeModel(_arg1);
            View.removeView(_arg1);
            Controller.removeController(_arg1);
            delete instanceMap[_arg1];
        }

        public function removeProxy(_arg1:String):IProxy{
            var _local2:IProxy;
            if (model != null){
                _local2 = model.removeProxy(_arg1);
            };
            return (_local2);
        }
        public function registerProxy(_arg1:IProxy):void{
            model.registerProxy(_arg1);
        }
        protected function initializeController():void{
            if (controller != null){
                return;
            };
            controller = Controller.getInstance(multitonKey);
        }
        protected function initializeFacade():void{
            initializeModel();
            initializeController();
            initializeView();
        }
        public function retrieveProxy(_arg1:String):IProxy{
            return (model.retrieveProxy(_arg1));
        }
        public function sendNotification(_arg1:String, _arg2:Object=null, _arg3:String=null):void{
            notifyObservers(new Notification(_arg1, _arg2, _arg3));
        }
        public function notifyObservers(_arg1:INotification):void{
            if (view != null){
                view.notifyObservers(_arg1);
            };
        }
        protected function initializeView():void{
            if (view != null){
                return;
            };
            view = View.getInstance(multitonKey);
        }
        public function retrieveMediator(_arg1:String):IMediator{
            return ((view.retrieveMediator(_arg1) as IMediator));
        }
        public function initializeNotifier(_arg1:String):void{
            multitonKey = _arg1;
        }
        public function removeMediator(_arg1:String):IMediator{
            var _local2:IMediator;
            if (view != null){
                _local2 = view.removeMediator(_arg1);
            };
            return (_local2);
        }
        public function hasCommand(_arg1:String):Boolean{
            return (controller.hasCommand(_arg1));
        }
        public function removeCommand(_arg1:String):void{
            controller.removeCommand(_arg1);
        }
        public function registerCommand(_arg1:String, _arg2:Class):void{
            controller.registerCommand(_arg1, _arg2);
        }
        public function hasMediator(_arg1:String):Boolean{
            return (view.hasMediator(_arg1));
        }
        public function registerMediator(_arg1:IMediator):void{
            if (view != null){
                view.registerMediator(_arg1);
            };
        }
        protected function initializeModel():void{
            if (model != null){
                return;
            };
            model = Model.getInstance(multitonKey);
        }
        public function hasProxy(_arg1:String):Boolean{
            return (model.hasProxy(_arg1));
        }

    }
}//package org.puremvc.as3.multicore.patterns.facade 
