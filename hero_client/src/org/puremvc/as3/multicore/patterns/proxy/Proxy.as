//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.patterns.proxy {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class Proxy extends Notifier implements IProxy, INotifier {

        public static var NAME:String = "Proxy";

        protected var data:Object;
        protected var proxyName:String;

        public function Proxy(_arg1:String=null, _arg2:Object=null){
            this.proxyName = ((_arg1)!=null) ? _arg1 : NAME;
            if (_arg2 != null){
                setData(_arg2);
            };
        }
        public function getData():Object{
            return (data);
        }
        public function setData(_arg1:Object):void{
            this.data = _arg1;
        }
        public function onRegister():void{
        }
        public function getProxyName():String{
            return (proxyName);
        }
        public function onRemove():void{
        }

    }
}//package org.puremvc.as3.multicore.patterns.proxy 
