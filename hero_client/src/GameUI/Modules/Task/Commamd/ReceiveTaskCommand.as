//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Modules.Task.Model.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class ReceiveTaskCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local2:TaskInfoStruct;
            var _local3:uint = _arg1.getBody()["taskId"];
            var _local4:uint = _arg1.getBody()["npcId"];
            var _local5:String = _arg1.getBody()["npcName"];
            this.sendNotification(TaskCommandList.SHOW_TASKINFO_UI, {
                npcId:_local4,
                taskId:_local3,
                npcName:_local5
            });
        }

    }
}//package GameUI.Modules.Task.Commamd 
