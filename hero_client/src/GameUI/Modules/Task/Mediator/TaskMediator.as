//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.*;

    public class TaskMediator extends Mediator {

        public static const NAME:String = "TaskMediator";

        private var dataProxy:DataProxy;
        protected var doneFirst:Boolean;

        public function TaskMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWTASKVIEW, EventList.CLOSETASKVIEW, TaskCommandList.UPDATETASKTREE, TaskCommandList.UPDATE_TASK_PROCESS_VIEW, TaskCommandList.UPDATE_TASK_TOTAL, TaskCommandList.ADD_ACCEPT_TASK, TaskCommandList.REMOVE_ACCEPT_TASK, TaskCommandList.SET_SHOW_FOLLOW, TaskCommandList.UPDATE_ACCTASK_UITREE, TaskCommandList.AUTOPATH_TASK, TaskCommandList.AUTOFLY_TASK, TaskCommandList.UPDATE_DIVINE_REWARDTIME, TaskCommandList.TASK_UI_SELECTTASK, EventList.UPDATEBAG]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var taskInfo:* = null;
            var taskId:* = 0;
            var type:* = 0;
            var t:* = 0;
            var _arg1:* = _arg1;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    setViewComponent(new TaskWindow());
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.registerCommand(TaskCommandList.RECEIVE_TASK, ReceiveTaskCommand);
                    facade.registerCommand(TaskCommandList.UPDATE_TASK_PROCESS, UpdateTaskProcess);
                    facade.registerCommand(TaskCommandList.UPDATE_LEVEL_TASK, UpdateLevelTaskCommand);
                    facade.registerCommand(TaskTextCommand.NAME, TaskTextCommand);
                    facade.registerCommand(TaskQuickCompleteCommand.NAME, TaskQuickCompleteCommand);
                    view.closeCallBack = panelCloseHandler;
                    break;
                case EventList.SHOWTASKVIEW:
                    if (GameCommonData.IsInCrossServer){
                        break;
                    };
                    dataProxy.TaskIsOpen = true;
                    view.show();
                    if (_arg1.getBody() != null){
                        view.setSelectedPage(uint(_arg1.getBody()));
                    } else {
                        view.setSelectedPage(0);
                    };
                    view.centerFrame();
                    break;
                case EventList.CLOSETASKVIEW:
                    dataProxy.TaskIsOpen = false;
                    view.close();
                    GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    break;
                case TaskCommandList.UPDATETASKTREE:
                    taskId = _arg1.getBody()["id"];
                    if (_arg1.getBody()["id"] == TaskCommonData.LoopBaseTaskId){
                        break;
                    };
                    type = _arg1.getBody()["type"];
                    if (type == 1){
                        addTask(taskId);
                    } else {
                        if (type == 2){
                            removeTask(taskId);
                        } else {
                            throw (new Error("error"));
                        };
                    };
                    sendNotification(TaskCommandList.UPDATE_TASK_TOTAL);
                    break;
                case TaskCommandList.ADD_ACCEPT_TASK:
                    taskId = (_arg1.getBody() as int);
                    addAccTask(taskId);
                    taskInfo = GameCommonData.TaskInfoDic[taskId];
                    if (taskInfo.taskType == QuestType.MAIN){
                        sendNotification(TaskCommandList.ADD_TASK_FOLLOW, taskInfo);
                    } else {
                        sendNotification(TaskCommandList.ADD_ACCEPT_TASK_TOFOLLOW, taskId);
                    };
                    break;
                case TaskCommandList.REMOVE_ACCEPT_TASK:
                    taskId = uint(_arg1.getBody());
                    removeAccTask(taskId);
                    sendNotification(TaskCommandList.REMOVE_ACCEPT_TASK_TOFOLLOW, taskId);
                    break;
                case TaskCommandList.UPDATE_TASK_PROCESS_VIEW:
                    taskInfo = (_arg1.getBody() as TaskInfoStruct);
                    this.view.updateTaskProcess(taskInfo.taskId);
                    break;
                case TaskCommandList.UPDATE_TASK_TOTAL:
                    this.view.updateAccTaskCnt();
                    break;
                case TaskCommandList.SET_SHOW_FOLLOW:
                    setShowFollow((_arg1.getBody() as Boolean));
                    break;
                case TaskCommandList.UPDATE_ACCTASK_UITREE:
                    sendNotification(TaskCommandList.REMOVEALL_ACCEPT_FOLLOW);
                    this.refreshAccTree();
                    break;
                case EventList.UPDATEBAG:
                    TaskCommonData.CheckAllTaskFinish();
                    break;
                case TaskCommandList.AUTOPATH_TASK:
                    taskInfo = (_arg1.getBody() as TaskInfoStruct);
                    if (((taskInfo) && (([NewGuideData.TASK_15].indexOf(taskInfo.taskId) == -1)))){
                        setTimeout(function ():void{
                            trace(("task autopath:" + taskInfo.taskId));
                            autoPath(taskInfo, false);
                        }, 500);
                    };
                    break;
                case TaskCommandList.AUTOFLY_TASK:
                    taskInfo = (_arg1.getBody() as TaskInfoStruct);
                    if (taskInfo){
                        autoPath(taskInfo, true);
                    };
                    break;
                case TaskCommandList.UPDATE_DIVINE_REWARDTIME:
                    t = (_arg1.getBody() as uint);
                    (GameCommonData.TaskInfoDic[TaskCommonData.DivineBaseTaskId] as TaskInfoStruct).Conditions[0].OnlineTime_ResultTime = TaskCommonData.DivineResultTime;
                    break;
                case TaskCommandList.TASK_UI_SELECTTASK:
                    taskId = (_arg1.getBody() as int);
                    if (taskId > 0){
                        taskInfo = GameCommonData.TaskInfoDic[taskId];
                        if (taskInfo.IsAccept){
                            view.setSelectedPage(0);
                            view.taskTree.selectedID = taskId;
                        } else {
                            view.setSelectedPage(1);
                            view.accTaskTree.selectedID = taskId;
                        };
                        view.updatePanelInfo(taskId);
                    };
                    break;
            };
        }
        private function get view():TaskWindow{
            return ((this.viewComponent as TaskWindow));
        }
        private function addTask(_arg1:int):void{
            var _local2:TaskInfoStruct = (GameCommonData.TaskInfoDic[_arg1] as TaskInfoStruct);
            if (_local2){
                this.view.taskTree.addTask(_local2);
                TaskCommonData.AccTaskTotalCnt++;
                if (_local2.isFollow){
                    sendNotification(TaskCommandList.ADD_TASK_FOLLOW, _local2);
                };
                this.view.taskTree.setSelected(_local2.taskId);
            };
        }
        private function removeTask(_arg1:int):void{
            var _local2:TaskInfoStruct = (GameCommonData.TaskInfoDic[_arg1] as TaskInfoStruct);
            if (_local2){
                this.view.taskTree.removeTask(_local2.taskId);
                TaskCommonData.AccTaskTotalCnt--;
                if (TaskCommonData.checkTaskIsCanAcc(_local2.taskId)){
                    view.accTaskTree.addTask(_local2);
                };
                sendNotification(TaskCommandList.REMOVE_TASK_FOLLOW, _local2);
            };
        }
        public function FindAllCell(_arg1:int):Array{
            var _local2:Array = [];
            _local2.push(view.taskTree.FindGroupCellById(_arg1));
            return (_local2);
        }
        private function refreshAccTree():void{
            var _local1:*;
            var _local2:TaskInfoStruct;
            this.view.accTaskTree.removeAll();
            this.setAcc();
        }
        private function addAccTask(_arg1:int):void{
            var _local2:TaskInfoStruct = (GameCommonData.TaskInfoDic[_arg1] as TaskInfoStruct);
            if (_local2){
                this.view.accTaskTree.addTask(_local2);
                this.view.accTaskTree.setSelected(_local2.taskId);
            };
        }
        public function get TaskPanel_ConPanel():TaskConPanel{
            return (this.view.taskConPanel);
        }
        protected function setShowFollow(_arg1:Boolean):void{
            if (_arg1){
                (this.view.bgView.mc_isShowFollow as MovieClip).gotoAndStop(2);
                sendNotification(TaskCommandList.SHOW_TASKFOLLOW_UI);
            } else {
                (this.view.bgView.mc_isShowFollow as MovieClip).gotoAndStop(1);
                sendNotification(TaskCommandList.HIDE_TASKFOLLOW_UI);
            };
        }
        private function removeAccTask(_arg1:int):void{
            this.view.accTaskTree.removeTask(_arg1);
        }
        private function autoPath(_arg1:TaskInfoStruct, _arg2:Boolean=false):void{
            var _local3:QuestCondition;
            var _local4:QuestCondition;
            if (_arg1.IsAccept){
                if (!_arg1.IsComplete){
                    for each (_local4 in _arg1.Conditions) {
                        if (((_local4) && (!(_local4.IsComplete)))){
                            _local3 = _local4;
                            break;
                        };
                    };
                    if (((((_local3) && (_local3.description))) && (!((_local3.description == ""))))){
                        autoPathFromTaskText(_local3.description, _arg2);
                    };
                } else {
                    if (_arg1.IsComplete){
                        if (((_arg1.taskProcessFinish) && (!((_arg1.taskProcessFinish == ""))))){
                            autoPathFromTaskText(_arg1.taskProcessFinish, _arg2);
                        };
                    };
                };
            } else {
                if (_arg1.taskNPCAndPoint != ""){
                    autoPathFromTaskText(_arg1.taskNPCAndPoint, _arg2);
                };
            };
        }
        private function panelCloseHandler():void{
            facade.sendNotification(EventList.CLOSETASKVIEW);
        }
        private function autoPathFromTaskText(_arg1:String, _arg2:Boolean=false):void{
            var _local3:Array = TaskCommonData.getQuestEventData(_arg1);
            if (((_local3) && ((_local3.length == 5)))){
                if (_arg2){
                    MoveToCommon.FlyTo(_local3[0], _local3[1], _local3[2], _local3[3], _local3[4]);
                } else {
                    MoveToCommon.MoveTo(_local3[0], _local3[1], _local3[2], _local3[3], _local3[4]);
                };
            };
        }
        public function searchGroupByDes(_arg1:String, _arg2:Array):TaskGroupStruct{
            var _local3:TaskGroupStruct;
            for each (_local3 in _arg2) {
                if (_local3.des == _arg1){
                    return (_local3);
                };
            };
            return (null);
        }
        protected function setAcc():void{
            var _local1:String;
            var _local3:TaskInfoStruct;
            var _local2:Boolean;
            for (_local1 in GameCommonData.TaskInfoDic) {
                if (TaskCommonData.checkTaskIsCanAcc(int(_local1))){
                    if (((GameCommonData.TaskInfoDic[_local1]) && ((GameCommonData.TaskInfoDic[_local1].taskType == QuestType.MAIN)))){
                        _local2 = true;
                    };
                    sendNotification(TaskCommandList.ADD_ACCEPT_TASK, int(_local1));
                };
            };
            if (!_local2){
                _local3 = TaskCommonData.GetCurrentMaintTask();
                if (((((((((((_local3) && (!(_local3.IsAccept)))) && ((TaskCommonData.CompleteTaskIdArray.indexOf(_local3.taskId) == -1)))) && (!((_local3.taskNPC == ""))))) && ((GameCommonData.Player.Role.Level < _local3.minLevel)))) && ((_local3.minLevel < 101)))){
                    sendNotification(TaskCommandList.ADD_ACCEPT_TASK, int(_local3.taskId));
                };
            };
        }

    }
}//package GameUI.Modules.Task.Mediator 
