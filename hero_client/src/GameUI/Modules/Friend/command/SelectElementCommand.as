//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.command {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class SelectElementCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            if (GameCommonData.TargetAnimal == null){
                return;
            };
            var _local3:GameRole = GameCommonData.TargetAnimal.Role;
            SysCursor.GetInstance().isLock = false;
        }

    }
}//package GameUI.Modules.Friend.command 
