//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import Utils.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;
    import GameUI.Modules.StoryDisplay.model.data.*;
    import GameUI.Modules.StoryDisplay.model.vo.*;

    public class TaskAction extends GameAction {

        private static var _instance:TaskAction;
        private static var IsLoaded:Boolean = false;

        public function TaskAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():TaskAction{
            if (!_instance){
                _instance = new (TaskAction)();
            };
            return (_instance);
        }

        public function getQuestListFromFile(_arg1:ByteArray):void{
            var _local4:GameElementAnimal;
            var _local5:GameElementAnimal;
            var _local6:TaskInfoStruct;
            _arg1.endian = "littleEndian";
            var _local2:int = _arg1.readUnsignedInt();
            _arg1.position = (_local2 + 4);
            var _local3:uint = _arg1.readUnsignedInt();
            var _local7:uint;
            while (_local7 < _local3) {
                _local6 = new TaskInfoStruct();
                _local6.ReadFromNetPacket(_arg1);
                GameCommonData.TaskInfoDic[_local6.taskId] = _local6;
                _local7++;
            };
            TaskCommonData.CreateLoopBaseTempTask();
            TaskCommonData.DivineBaseTaskInfo = (ClassFactory.copyProperties(GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId], new TaskInfoStruct()) as TaskInfoStruct);
            TaskCommonData.CreateDivineBaseTaskInfo(GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId]);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_QUEST_LIST:
                    getQuestListResult(_arg1);
                    break;
                case Protocol.SMSG_QUESTLOG_QUESTLOGLIST:
                    getQuestLogList(_arg1);
                    break;
                case Protocol.SMSG_QUESTGIVER_GETQUEST:
                    acceptQuestResult(_arg1);
                    break;
                case Protocol.SMSG_QUESTLOG_REMOVE_QUEST:
                    removeQuestResult(_arg1);
                    break;
                case Protocol.SMSG_QUESTUPDATE_COMPLETE:
                    completeQuest(_arg1);
                    break;
                case Protocol.SMSG_QUESTUPDATE_ADD_KILL:
                    updateProcess(_arg1);
                    break;
                case Protocol.SMSG_DIVINE_RESULT:
                    divineResult(_arg1);
                    break;
                case Protocol.SMSG_SERVER_DATA:
                    dailyTaskState(_arg1);
                    break;
                case Protocol.SMSG_QUEST_DAILY_OP:
                    dailyBookRecord(_arg1);
                    break;
            };
            TargetController.getTaskMonsterList();
        }
        private function dailyBookRecord(_arg1:NetPacket):void{
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            var _local9:String;
            var _local10:int;
            var _local2:int = _arg1.readUnsignedInt();
            switch (_local2){
                case 0:
                    _local3 = _arg1.readUnsignedInt();
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = _arg1.readUnsignedInt();
                    TaskCommonData.DailyBookItemGuid = _local3;
                    TaskCommonData.CurrentDialyBookTaskId = _local4;
                    TaskCommonData.CurrentDialyBookQuality = _local5;
                    facade.sendNotification(EventList.UPDATE_DAILYBOOKRESULT);
                    break;
                case 1:
                    _local6 = _arg1.readUnsignedInt();
                    _local5 = _arg1.readUnsignedInt();
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readUnsignedInt();
                    _local9 = "";
                    if (_local8 > 0){
                        _local9 = (_local9 + ((LanguageMgr.GetTranslation("消耗金叶子") + int((_local8 / 100))) + ","));
                    };
                    if (_local7 > 0){
                        _local9 = (_local9 + (LanguageMgr.GetTranslation("消耗礼券") + _local7));
                    } else {
                        _local9 = _local9.substr(0, (_local9.length - 1));
                    };
                    if (_local9 != ""){
                        MessageTip.popup(_local9);
                        MessageTip.show(_local9);
                    };
                    _local10 = TaskCommonData.CurrentDialyBookQuality;
                    TaskCommonData.CurrentDialyBookQuality = _local5;
                    facade.sendNotification(EventList.UPDATE_DAILYBOOKRESULT, [_local6, _local10]);
                    break;
            };
        }
        private function getQuestLogList(_arg1:NetPacket):void{
            var taskInfo:* = null;
            var taskNpc:* = null;
            var taskCommitNpc:* = null;
            var taskId:* = 0;
            var i:* = 0;
            var completeTaskId:* = 0;
            var j:* = 0;
            var aii:* = 0;
            var npcTaskStateIconType:* = 0;
            var parm1:* = 0;
            var parm2:* = 0;
            var pkg:* = _arg1;
            if (IsLoaded){
                i = 0;
                while (i < TaskCommonData.CompleteTaskIdArray.length) {
                    taskInfo = GameCommonData.TaskInfoDic[TaskCommonData.CompleteTaskIdArray[i]];
                    if (((taskInfo) && ((taskInfo.taskType == QuestType.DAILY)))){
                        TaskCommonData.CompleteTaskIdArray.splice(i, 1);
                        i = (i - 1);
                    };
                    i = (i + 1);
                };
                aii = 24;
                while (aii < 44) {
                    GameCommonData.activityData[aii] = 0;
                    aii = (aii + 1);
                };
                sendNotification(TaskCommandList.UPDATE_ACCTASK_UITREE);
                sendNotification(TaskCommandList.UPDATE_COMPLETETASK_LIST);
                return;
            };
            IsLoaded = true;
            var taskNum:* = pkg.readUnsignedInt();
            RepeatRequest.getInstance().taskCount = taskNum;
            var accTaskIdArr:* = [];
            i = 0;
            while (i < taskNum) {
                taskId = pkg.readUnsignedInt();
                taskInfo = (GameCommonData.TaskInfoDic[taskId] as TaskInfoStruct);
                GameCommonData.isNewTaskEnd = true;
                if (taskInfo != null){
                    pkg.ReadString();
                    pkg.readUnsignedInt();
                    pkg.readUnsignedInt();
                    taskInfo.finishTime = pkg.readUnsignedInt();
                    taskInfo.isFollow = pkg.readBoolean();
                    taskInfo.isFollow = true;
                    taskInfo.IsAccept = true;
                    j = 0;
                    while (j < 3) {
                        pkg.ReadString();
                        parm1 = pkg.readUnsignedInt();
                        parm2 = pkg.readUnsignedInt();
                        if (taskInfo.Conditions[j]){
                            (taskInfo.Conditions[j] as QuestCondition).setProcess(parm1, parm2);
                        };
                        j = (j + 1);
                    };
                    taskNpc = DialogConstData.getInstance().getNpcByMonsterId(taskInfo.taskNpcId);
                    if (taskNpc != null){
                        npcTaskStateIconType = TaskProxy.getInstance().getNpcShowTaskType(taskInfo.taskNpcId);
                        taskNpc.SetMissionPrompt(npcTaskStateIconType);
                    };
                    taskCommitNpc = DialogConstData.getInstance().getNpcByMonsterId(taskInfo.taskCommitNpcId);
                    if (taskCommitNpc != null){
                        npcTaskStateIconType = TaskProxy.getInstance().getNpcShowTaskType(taskInfo.taskCommitNpcId);
                        taskCommitNpc.SetMissionPrompt(npcTaskStateIconType);
                    };
                    if (taskInfo.taskType == QuestType.LOOP){
                        GameCommonData.TaskInfoDic[TaskCommonData.LoopBaseTaskId].IsAccept = true;
                        if (accTaskIdArr.indexOf(TaskCommonData.LoopBaseTaskId) == -1){
                            accTaskIdArr.push(TaskCommonData.LoopBaseTaskId);
                        };
                    };
                    if (taskInfo.taskType == QuestType.MAIN){
                        TaskCommonData.CurrentMainTaskId = taskInfo.taskId;
                    };
                    accTaskIdArr.push(taskId);
                    GameCommonData.CurrentTaskList[taskId] = taskInfo;
                    if (taskInfo.taskId == TaskCommonData.DivineBaseTaskId){
                        sendNotification(TaskCommandList.UPDATE_DIVINE_REWARDTIME, TaskCommonData.DivineResultTime);
                        TaskTimeManager.getInstance().addTaskTimeout(taskInfo);
                    };
                    if ((((taskInfo.finishTime > 0)) && ((taskInfo.limitTime > 0)))){
                        TaskTimeManager.getInstance().addTaskTimeout(taskInfo);
                    };
                };
                i = (i + 1);
            };
            var completeTaskIdCount:* = pkg.readUnsignedInt();
            TaskCommonData.CompleteTaskIdArray = [];
            j = 0;
            while (j < completeTaskIdCount) {
                completeTaskId = pkg.readUnsignedInt();
                TaskCommonData.CompleteTaskIdArray.push(completeTaskId);
                j = (j + 1);
            };
            sendNotification(TaskCommandList.UPDATE_ACCTASK_UITREE);
            sendNotification(TaskCommandList.UPDATE_COMPLETETASK_LIST);
            j = 0;
            while (j < accTaskIdArr.length) {
                sendNotification(TaskCommandList.UPDATETASKTREE, {
                    type:1,
                    id:accTaskIdArr[j]
                });
                sendNotification(TaskCommandList.REMOVE_ACCEPT_TASK, accTaskIdArr[j]);
                j = (j + 1);
            };
            TaskCommonData.IsLoadedQuestlog = true;
            setTimeout(function (){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_INIT);
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:NewGuideData.curType,
                    STEP:NewGuideData.curStep
                });
            }, 1000);
            facade.sendNotification(EventList.UPDATE_MAINBTN_RIGHT);
        }
        private function acceptQuestResult(_arg1:NetPacket):void{
            var _local4:int;
            var _local5:QuestCondition;
            var _local6:Boolean;
            var _local7:String;
            var _local8:int;
            var _local9:int;
            var _local10:GameElementAnimal;
            var _local11:GameElementAnimal;
            var _local12:StoryVO;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:TaskInfoStruct = (GameCommonData.TaskInfoDic[_local2] as TaskInfoStruct);
            GameCommonData.isNewTaskEnd = true;
            if (((_local3) && (_local3.IsAccept))){
                _arg1.ReadString();
                _arg1.readUnsignedInt();
                _arg1.readUnsignedInt();
                _arg1.readUnsignedInt();
                _arg1.readBoolean();
                _local4 = 0;
                _local6 = _local3.IsComplete;
                _local4 = 0;
                while (_local4 < 3) {
                    _local5 = _local3.Conditions[_local4];
                    _local7 = _arg1.ReadString();
                    _local8 = _arg1.readUnsignedInt();
                    _local9 = _arg1.readUnsignedInt();
                    if (((_local3.Conditions[_local4]) && (!((_local8 == _local5.Current))))){
                        sendNotification(TaskCommandList.UPDATE_TASK_PROCESS, {
                            id:_local2,
                            conId:_local5.ConID,
                            dataArr:[_local8, _local9]
                        });
                    };
                    _local4++;
                };
            };
            if (((_local3) && (!(_local3.IsAccept)))){
                _arg1.ReadString();
                _arg1.readUnsignedInt();
                _arg1.readUnsignedInt();
                _local3.IsAccept = true;
                _local3.finishTime = _arg1.readUnsignedInt();
                _local3.isFollow = _arg1.readBoolean();
                _local4 = 0;
                _local4 = 0;
                while (_local4 < 3) {
                    _local5 = _local3.Conditions[_local4];
                    _local7 = _arg1.ReadString();
                    _local8 = _arg1.readUnsignedInt();
                    _local9 = _arg1.readUnsignedInt();
                    if (_local3.Conditions[_local4]){
                        _local5.description = _local7;
                        _local5.setProcess(_local8, _local9);
                    };
                    _local4++;
                };
                if (_local3.taskType == QuestType.LOOP){
                    GameCommonData.TaskInfoDic[TaskCommonData.LoopBaseTaskId].IsAccept = true;
                    sendNotification(TaskCommandList.UPDATETASKTREE, {
                        type:1,
                        id:TaskCommonData.LoopBaseTaskId
                    });
                    sendNotification(TaskCommandList.REMOVE_ACCEPT_TASK, TaskCommonData.LoopBaseTaskId);
                };
                if (_local3.taskType == QuestType.MAIN){
                    TaskCommonData.CurrentMainTaskId = _local3.taskId;
                };
                sendNotification(TaskCommandList.UPDATETASKTREE, {
                    type:1,
                    id:_local2
                });
                sendNotification(TaskCommandList.REMOVE_ACCEPT_TASK, _local2);
                _local10 = DialogConstData.getInstance().getNpcByMonsterId(_local3.taskNpcId);
                if (_local10){
                    TaskCommonData.setNpcState(_local10);
                };
                _local11 = DialogConstData.getInstance().getNpcByMonsterId(_local3.taskCommitNpcId);
                if (_local11){
                    TaskCommonData.setNpcState(_local11);
                };
                if (_local3.taskId == TaskCommonData.DivineBaseTaskId){
                    TaskTimeManager.getInstance().addTaskTimeout(_local3);
                };
                if ((((_local3.finishTime > 0)) && ((_local3.limitTime > 0)))){
                    TaskTimeManager.getInstance().addTaskTimeout(_local3);
                };
                if (GameCommonData.NPCDialogIsOpen){
                    sendNotification(NPCChatComList.HIDE_NPC_CHAT);
                };
                GameCommonData.CurrentTaskList[_local2] = _local3;
                if ((((_local2 >= StoryDisplayConst.minTaskId)) && ((_local2 <= StoryDisplayConst.maxTaskId)))){
                    for each (_local12 in GameCommonData.StoryDisplayList) {
                        if ((((((_local12.taskID == _local2)) && ((_local12.count > _local3.storyCount)))) && ((_local12.taskProgress[_local3.storyCount] == 1)))){
                            sendNotification(StoryDisplayConst.TASK_ACCEPT, {
                                taskAccNpc:_local10,
                                taskId:_local2,
                                taskInfo:_local3,
                                vo:_local12
                            });
                            return;
                        };
                    };
                };
                TaskCommonData.Handler_TaskAccept(_local10, _local2, _local3);
            };
        }
        private function completeQuest(_arg1:NetPacket):void{
            var _local5:StoryVO;
            var _local2:int = _arg1.readUnsignedInt();
            trace(("任务完成" + _local2));
            var _local3:TaskInfoStruct = (GameCommonData.TaskInfoDic[_local2] as TaskInfoStruct);
            _local3.setTaskComplete();
            var _local4:GameElementAnimal = DialogConstData.getInstance().getNpcByMonsterId(_local3.taskCommitNpcId);
            if (_local4){
                TaskCommonData.setNpcState(_local4);
            };
            sendNotification(TaskCommandList.UPDATE_TASK_PROCESS_VIEW, _local3);
            if (_local2 == NewGuideData.TASK_15){
                sendNotification(Guide_OccupationIntro_Command.NAME, {type:6});
            };
            if ((((_local2 >= StoryDisplayConst.minTaskId)) && ((_local2 <= StoryDisplayConst.maxTaskId)))){
                for each (_local5 in GameCommonData.StoryDisplayList) {
                    if ((((((_local5.taskID == _local3.taskId)) && ((_local5.count > _local3.storyCount)))) && ((_local5.taskProgress[_local3.storyCount] == 2)))){
                        if ((((GameCommonData.Player.IsAutomatism == true)) || ((AutoFbManager.IsAutoFbing == true)))){
                            sendNotification(AutoPlayEventList.QUICK_AUTO_PLAY);
                        };
                        sendNotification(StoryDisplayConst.TASK_COMPLETE, {
                            taskId:_local2,
                            taskInfo:_local3,
                            vo:_local5
                        });
                        return;
                    };
                };
            };
            TaskCommonData.Handler_CompleteTask(_local2, _local3);
        }
        private function dailyTaskState(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            TaskCommonData.SpecialDailyTaskCanAccList = [];
            var _local3:int;
            while (_local3 < _local2) {
                TaskCommonData.SpecialDailyTaskCanAccList.push(_arg1.readUnsignedInt());
                _local3++;
            };
        }
        private function removeQuestResult(_arg1:NetPacket):void{
            var _local7:uint;
            var _local8:StoryVO;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:Boolean = _arg1.readBoolean();
            var _local4:TaskInfoStruct = GameCommonData.TaskInfoDic[_local2];
            if (_local4.IsAccept == false){
                return;
            };
            if (_local3){
                if ((((((_local4.taskType == QuestType.MAIN)) || ((_local4.taskType == QuestType.SIDE)))) || ((((_local4.taskType == QuestType.DAILY)) && (!((_local4.flags == TaskCommonData.QFLAGS_DAILYBOOK))))))){
                    TaskCommonData.CompleteTaskIdArray.push(_local2);
                };
                TaskShowMcManager.getInstance().show(TaskShowMcManager.TYPE_COMPLETE);
            };
            sendNotification(TaskCommandList.UPDATE_COMPLETETASK_LIST);
            trace(("删除成功" + _local2));
            _local4.IsAccept = false;
            _local4.clearProcess();
            TaskTimeManager.getInstance().removeTaskTimeout(_local4);
            delete GameCommonData.CurrentTaskList[_local2];
            sendNotification(TaskCommandList.UPDATETASKTREE, {
                type:2,
                id:_local2
            });
            sendNotification(TaskCommandList.REMOVE_TASK_FOLLOW, _local4);
            if (_local4.taskType == QuestType.LOOP){
                GameCommonData.TaskInfoDic[TaskCommonData.LoopBaseTaskId].IsAccept = false;
                if (_local3){
                    _local7 = ((GameCommonData.Player.Role.loopTaskIdx >= 10)) ? 10 : GameCommonData.Player.Role.loopTaskIdx;
                    sendNotification(EventList.UPDATE_EVERY_ACTIVITY, _local7);
                };
            };
            if ((((_local4.taskId == TaskCommonData.CurrentMainTaskId)) && ((_local4.taskType == QuestType.MAIN)))){
                TaskCommonData.CurrentMainTaskId = 0;
            };
            if (_local4.taskId == TaskCommonData.DivineBaseTaskId){
                TaskCommonData.CreateDivineBaseTaskInfo(GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId]);
            };
            facade.sendNotification(TaskCommandList.UPDATE_ACCTASK_UITREE);
            var _local5:GameElementAnimal = DialogConstData.getInstance().getNpcByMonsterId(_local4.taskNpcId);
            if (_local5){
                TaskCommonData.setNpcState(_local5);
            };
            var _local6:GameElementAnimal = DialogConstData.getInstance().getNpcByMonsterId(_local4.taskCommitNpcId);
            if (_local6){
                TaskCommonData.setNpcState(_local6);
            };
            facade.sendNotification(NPCChatComList.HIDE_NPC_CHAT);
            if ((((_local2 >= StoryDisplayConst.minTaskId)) && ((_local2 <= StoryDisplayConst.maxTaskId)))){
                for each (_local8 in GameCommonData.StoryDisplayList) {
                    if ((((((_local8.taskID == _local4.taskId)) && ((_local8.count > _local4.storyCount)))) && ((_local8.taskProgress[_local4.storyCount] == 3)))){
                        sendNotification(StoryDisplayConst.TASK_COMMIT, {
                            taskId:_local2,
                            taskInfo:_local4,
                            taskResult:_local3,
                            taskCommitNpc:_local6,
                            vo:_local8
                        });
                        return;
                    };
                };
            };
            TaskCommonData.Handler_RemoveTask(_local2, _local3, _local4, _local6);
        }
        private function divineResult(_arg1:NetPacket):void{
            var _local6:QuestItemReward;
            if (GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId] == null){
                return;
            };
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:TaskInfoStruct = GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId];
            _local5.taskDes = LanguageMgr.GetTranslation(("占卜结果" + _local2.toString()));
            _local5.clearItemReward();
            switch (_local3){
                case 1:
                    _local5.rewardExp = _local4;
                    break;
                case 2:
                    _local5.rewardGold = _local4;
                    break;
                default:
                    if (((_local3) && ((_local4 > 0)))){
                        _local6 = new QuestItemReward(_local3, _local4, _local5);
                        _local5.addItemReward(_local6);
                    };
            };
            TaskTimeManager.getInstance().removeTaskTimeout(GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId]);
            sendNotification(TaskCommandList.UPDATE_TASK_PROCESS_VIEW, GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId]);
        }
        private function updateProcess(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:uint = _arg1.readUnsignedInt();
            trace(((("更新任务进度" + _local2) + ",") + _local3));
            sendNotification(TaskCommandList.UPDATE_TASK_PROCESS, {
                id:_local2,
                conId:_local3,
                dataArr:[_local4, _local5]
            });
            var _local6:TaskInfoStruct = GameCommonData.TaskInfoDic[_local2];
            if (NewGuideData.newerHelpIsOpen){
                facade.sendNotification(Guide_TaskCommand.NAME, {
                    taskInfo:_local6,
                    state:4,
                    data:{conId:_local3}
                });
                if (_local6.taskId == 1010){
                    sendNotification(TaskCommandList.AUTOPATH_TASK, _local6);
                };
            };
        }
        private function getQuestListResult(_arg1:NetPacket):void{
            var _local3:GameElementAnimal;
            var _local4:GameElementAnimal;
            var _local5:TaskInfoStruct;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local6:uint;
            while (_local6 < _local2) {
                _local5 = new TaskInfoStruct();
                _local5.ReadFromNetPacket(_arg1);
                GameCommonData.TaskInfoDic[_local5.taskId] = _local5;
                _local6++;
            };
        }

    }
}//package Net.PackHandler 
