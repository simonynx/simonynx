//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.patterns.observer {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.facade.*;

    public class Notifier implements INotifier {

        protected const MULTITON_MSG:String = "multitonKey for this Notifier not yet initialized!";

        protected var multitonKey:String;

        public function sendNotification(_arg1:String, _arg2:Object=null, _arg3:String=null):void{
            if (facade != null){
                facade.sendNotification(_arg1, _arg2, _arg3);
            };
        }
        protected function get facade():IFacade{
            if (multitonKey == null){
                throw (Error(MULTITON_MSG));
            };
            return (Facade.getInstance(multitonKey));
        }
        public function initializeNotifier(_arg1:String):void{
            multitonKey = _arg1;
        }

    }
}//package org.puremvc.as3.multicore.patterns.observer 
