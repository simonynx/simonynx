//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.patterns.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class Mediator extends Notifier implements IMediator, INotifier {

        public static const NAME:String = "Mediator";

        protected var viewComponent:Object;
        protected var mediatorName:String;

        public function Mediator(_arg1:String=null, _arg2:Object=null){
            this.mediatorName = ((_arg1)!=null) ? _arg1 : NAME;
            this.viewComponent = _arg2;
        }
        public function listNotificationInterests():Array{
            return ([]);
        }
        public function onRegister():void{
        }
        public function onRemove():void{
        }
        public function getViewComponent():Object{
            return (viewComponent);
        }
        public function handleNotification(_arg1:INotification):void{
        }
        public function getMediatorName():String{
            return (mediatorName);
        }
        public function setViewComponent(_arg1:Object):void{
            this.viewComponent = _arg1;
        }

    }
}//package org.puremvc.as3.multicore.patterns.mediator 
