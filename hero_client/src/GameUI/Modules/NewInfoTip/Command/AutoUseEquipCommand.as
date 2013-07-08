//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class AutoUseEquipCommand extends SimpleCommand {

        public static const NAME:String = "AutoUseEquipCommand";

        override public function execute(_arg1:INotification):void{
            var _local2:InventoryItemInfo = (_arg1.getBody() as InventoryItemInfo);
            sendNotification(GetRewardEvent.SHOW_GETEQUIPUSE_PANEL, _local2);
        }

    }
}//package GameUI.Modules.NewInfoTip.Command 
