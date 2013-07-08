//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.core {
    import org.puremvc.as3.multicore.interfaces.*;

    public class Model implements IModel {

        protected static var instanceMap:Array = new Array();

        protected const MULTITON_MSG:String = "Model instance for this Multiton key already constructed!";

        protected var multitonKey:String;
        protected var proxyMap:Array;

        public function Model(_arg1:String){
            if (instanceMap[_arg1] != null){
                throw (Error(MULTITON_MSG));
            };
            multitonKey = _arg1;
            instanceMap[multitonKey] = this;
            proxyMap = new Array();
            initializeModel();
        }
        public static function getInstance(_arg1:String):IModel{
            if (instanceMap[_arg1] == null){
                instanceMap[_arg1] = new Model(_arg1);
            };
            return (instanceMap[_arg1]);
        }
        public static function removeModel(_arg1:String):void{
            delete instanceMap[_arg1];
        }

        protected function initializeModel():void{
        }
        public function removeProxy(_arg1:String):IProxy{
            var _local2:IProxy = (proxyMap[_arg1] as IProxy);
            if (_local2){
                proxyMap[_arg1] = null;
                _local2.onRemove();
            };
            return (_local2);
        }
        public function hasProxy(_arg1:String):Boolean{
            return (!((proxyMap[_arg1] == null)));
        }
        public function retrieveProxy(_arg1:String):IProxy{
            return (proxyMap[_arg1]);
        }
        public function registerProxy(_arg1:IProxy):void{
            _arg1.initializeNotifier(multitonKey);
            proxyMap[_arg1.getProxyName()] = _arg1;
            _arg1.onRegister();
        }

    }
}//package org.puremvc.as3.multicore.core 
