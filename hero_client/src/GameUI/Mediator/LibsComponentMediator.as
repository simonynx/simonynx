//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class LibsComponentMediator extends Mediator {

        public static const NAME:String = "LibsComponentMediator";

        public function LibsComponentMediator(){
            super(NAME, new LibsGameComponent(GameCommonData.GameInstance));
        }
        override public function listNotificationInterests():Array{
            return ([EventList.GETRESOURCE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            switch (_arg1.getName()){
                case EventList.GETRESOURCE:
                    _local2 = _arg1.getBody();
                    libsComponent.GetLibrary(_local2.type, _local2.mediator, _local2.name);
                    break;
            };
        }
        private function get libsComponent():LibsGameComponent{
            return ((viewComponent as LibsGameComponent));
        }

    }
}//package GameUI.Mediator 
