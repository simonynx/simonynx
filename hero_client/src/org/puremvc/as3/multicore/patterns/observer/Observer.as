//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.patterns.observer {
    import org.puremvc.as3.multicore.interfaces.*;

    public class Observer implements IObserver {

        private var notify:Function;
        private var context:Object;

        public function Observer(_arg1:Function, _arg2:Object){
            setNotifyMethod(_arg1);
            setNotifyContext(_arg2);
        }
        private function getNotifyMethod():Function{
            return (notify);
        }
        public function compareNotifyContext(_arg1:Object):Boolean{
            return ((_arg1 === this.context));
        }
        public function setNotifyContext(_arg1:Object):void{
            context = _arg1;
        }
        private function getNotifyContext():Object{
            return (context);
        }
        public function setNotifyMethod(_arg1:Function):void{
            notify = _arg1;
        }
        public function notifyObserver(_arg1:INotification):void{
            this.getNotifyMethod().apply(this.getNotifyContext(), [_arg1]);
        }

    }
}//package org.puremvc.as3.multicore.patterns.observer 
