//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class UpdateTaskProcess extends SimpleCommand {

        private var timeoutId:int = -1;

        override public function execute(_arg1:INotification):void{
            var _local2:uint;
            var _local6:GameElementNPC;
            var _local7:String;
            var _local3:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1.getBody()["id"]];
            if (_local3 == null){
                return;
            };
            var _local4:uint = (_arg1.getBody()["conId"] as uint);
            var _local5:Array = (_arg1.getBody()["dataArr"] as Array);
            _local3.Conditions[_local4].setProcess(_local5[0], _local5[1]);
            if (_local3.IsComplete){
                for (_local7 in GameCommonData.SameSecnePlayerList) {
                    if ((((GameCommonData.SameSecnePlayerList[_local7] is GameElementNPC)) && ((GameCommonData.SameSecnePlayerList[_local7].Role.MonsterTypeID == _local3.taskCommitNpcId)))){
                        _local6 = GameCommonData.SameSecnePlayerList[_local7];
                        break;
                    };
                };
                if (_local6 != null){
                    _local6.SetMissionPrompt(3);
                };
                if ((((((_local3.taskType == QuestType.MAIN)) && (!((_local3.taskId == 1233))))) && ((GameCommonData.Player.Role.Level < 30)))){
                    sendNotification(TaskCommandList.AUTOPATH_TASK, _local3);
                } else {
                    if ((((_local3.taskType == QuestType.DAILY)) && ((_local3.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                        if (!(facade.retrieveProxy(DataProxy.NAME) as DataProxy).TaskDailyBOokIsOpen){
                            facade.sendNotification(EventList.SHOWTASKDAILYBOOK);
                        };
                    };
                };
            };
            sendNotification(TaskCommandList.UPDATE_TASK_PROCESS_VIEW, _local3);
            if ((((timeoutId == -1)) && (GameCommonData.IsCollected))){
                clearTimeout(timeoutId);
                timeoutId = setTimeout(autoCollect, 500, _local3, _local4);
            };
        }
        private function autoCollect(_arg1:TaskInfoStruct, _arg2:int):void{
            var _local3:Array;
            var _local4:GameElementAnimal;
            timeoutId = -1;
            if ((((_arg1.Conditions[_arg2].type == QuestConditionType.QUEST_FLAG_COLLECT)) && (!(_arg1.Conditions[_arg2].IsComplete)))){
                _local3 = TaskCommonData.getQuestEventDataByCon(_arg1.taskId, _arg2);
                if (_local3){
                    _local4 = PlayerController.FindNearestAnimalByType(_local3[4]);
                    if (_local4){
                        GameCommonData.TargetAnimal = _local4;
                        GameCommonData.Scene.HelloNPC(_local4);
                    };
                };
            };
        }

    }
}//package GameUI.Modules.Task.Commamd 
