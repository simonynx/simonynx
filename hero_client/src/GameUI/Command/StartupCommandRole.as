//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import Net.RequestSend.*;

    public class StartupCommandRole extends SimpleCommand {

        public function StartupCommandRole(){
            this.initializeNotifier(UIFacade.FACADEKEY);
        }
        override public function execute(_arg1:INotification):void{
            var _local2:int = (_arg1.getBody() as int);
            CharacterSend.loginRole(1, _local2);
        }

    }
}//package GameUI.Command 
