//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import Net.RequestSend.*;

    public class SendNPCMsgCommand extends SimpleCommand {

        private var dataProxy:DataProxy;

        override public function execute(_arg1:INotification):void{
            var _local2:uint = _arg1.getBody().npcId;
            var _local3:uint = _arg1.getBody().linkId;
            NPCChatSend.SelectOption(_local2, _local3);
        }

    }
}//package GameUI.Modules.NPCChat.Command 
