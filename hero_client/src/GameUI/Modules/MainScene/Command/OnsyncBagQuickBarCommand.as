//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.MainScene.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.AutoPlay.command.*;

    public class OnsyncBagQuickBarCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local2:QuickSkillManager = (facade.retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
            _local2.onSyncBag();
            sendNotification(AutoPlayEventList.ONSYN_BAG_NUM);
        }

    }
}//package GameUI.Modules.MainScene.Command 
