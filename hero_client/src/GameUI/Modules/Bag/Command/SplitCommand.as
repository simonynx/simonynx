//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Bag.Datas.*;

    public class SplitCommand extends SimpleCommand {

        public static const NAME:String = "SplitCommand";

        private var splitMediator:SplitItemMediator;

        override public function execute(_arg1:INotification):void{
            if (BagData.SelectedItem){
                if (splitMediator != null){
                    splitMediator = null;
                };
                splitMediator = new SplitItemMediator();
                facade.registerMediator(splitMediator);
                facade.sendNotification(BagEvents.SHOWSPLIT, BagData.SelectedItem);
            };
        }

    }
}//package GameUI.Modules.Bag.Command 
