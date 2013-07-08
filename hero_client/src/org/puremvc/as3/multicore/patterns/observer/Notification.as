//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.patterns.observer {
    import org.puremvc.as3.multicore.interfaces.*;

    public class Notification implements INotification {

        private var body:Object;
        private var name:String;
        private var type:String;

        public function Notification(_arg1:String, _arg2:Object=null, _arg3:String=null){
            this.name = _arg1;
            this.body = _arg2;
            this.type = _arg3;
        }
        public function setBody(_arg1:Object):void{
            this.body = _arg1;
        }
        public function getName():String{
            return (name);
        }
        public function toString():String{
            var _local1:String = ("Notification Name: " + getName());
            _local1 = (_local1 + ("\nBody:" + ((body)==null) ? "null" : body.toString()));
            _local1 = (_local1 + ("\nType:" + ((type)==null) ? "null" : type));
            return (_local1);
        }
        public function getType():String{
            return (type);
        }
        public function setType(_arg1:String):void{
            this.type = _arg1;
        }
        public function getBody():Object{
            return (body);
        }

    }
}//package org.puremvc.as3.multicore.patterns.observer 
