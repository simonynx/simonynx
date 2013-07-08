//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import GameUI.Modules.Task.Model.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class UpdateLevelTaskCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local2:String;
            if (GameCommonData.TaskInfoDic[TaskCommonData.LoopBaseTaskId].taskNPC == ""){
                TaskCommonData.CreateLoopBaseTempTask();
            };
            for (_local2 in GameCommonData.SameSecnePlayerList) {
                if (GameCommonData.SameSecnePlayerList[_local2].Role.Type == GameRole.TYPE_NPC){
                    TaskCommonData.setNpcState(GameCommonData.SameSecnePlayerList[_local2]);
                };
            };
            facade.sendNotification(TaskCommandList.UPDATE_ACCTASK_UITREE);
        }

    }
}//package GameUI.Modules.Task.Commamd 
