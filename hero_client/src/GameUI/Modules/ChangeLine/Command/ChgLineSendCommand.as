//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ChangeLine.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;

    public class ChgLineSendCommand extends SimpleCommand {

        public static const NAME:String = "ChgLineSendCommand";

        override public function execute(_arg1:INotification):void{
            GameConnectSend.ChangeLine(GameConfigData.CurrentServerId, ChgLineData.flyLineId);
        }

    }
}//package GameUI.Modules.ChangeLine.Command 
