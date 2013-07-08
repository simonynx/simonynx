//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import GameUI.UICore.*;
    import OopsFramework.*;
    import Manager.*;
    import GameUI.Modules.Task.Mediator.*;
    import GameUI.View.*;
    import OopsFramework.Utils.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Task.Interface.*;

    public class TaskTimeManager implements IUpdateable {

        public static const ADD:String = "add";
        public static const REMOVE:String = "remove";
        public static const NAME:String = "TaskTimeComand";

        private static var _instance:TaskTimeManager;

        private var TaskTimeoutArr:Array;
        private var timer:Timer;
        private var currentConvoyTask:TaskInfoStruct;
        private var ConvoyTaskEndTime:int = 0;

        public function TaskTimeManager(){
            TaskTimeoutArr = new Array();
            super();
            timer = new Timer();
            timer.DistanceTime = 1000;
        }
        public static function getInstance():TaskTimeManager{
            if (!_instance){
                _instance = new (TaskTimeManager)();
            };
            return (_instance);
        }

        private function taskErrorByTimeout(_arg1:TaskInfoStruct):void{
            var _local2:int;
            var _local3:ITaskTimeUpdate;
            _local2 = 0;
            while (_local2 < TaskTimeoutArr.length) {
                if (((TaskTimeoutArr[_local2]["info"]) && ((TaskTimeoutArr[_local2]["info"] == _arg1)))){
                    if (TaskTimeoutArr[_local2]["updateCells"] != null){
                        for each (_local3 in TaskTimeoutArr[_local2]["updateCells"]) {
                            if (_local3){
                                _local3.Update();
                            };
                        };
                    };
                };
                _local2++;
            };
            MessageTip.popup(LanguageMgr.GetTranslation("任务提示3", _arg1.title));
            MessageTip.show(LanguageMgr.GetTranslation("任务提示3", _arg1.title));
            TaskSend.DeleteTask(_arg1.taskId);
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function Update(_arg1:GameTime):void{
            if (timer.IsNextTime(_arg1)){
                updateTaskTimeText();
            };
        }
        private function updateTaskTimeText():void{
            var _local1:int;
            var _local2:TaskConPanel;
            var _local3:Array;
            var _local4:ITaskTimeUpdate;
            _local1 = 0;
            while (_local1 < TaskTimeoutArr.length) {
                if (TaskTimeoutArr[_local1]["info"]){
                    _local2 = (UIFacade.GetInstance().retrieveMediator(TaskMediator.NAME) as TaskMediator).TaskPanel_ConPanel;
                    if (((((_local2) && (_local2.info))) && ((_local2.info.taskId == TaskTimeoutArr[_local1]["info"].taskId)))){
                        _local2.Update();
                    };
                    _local3 = [];
                    _local3 = _local3.concat((UIFacade.GetInstance().retrieveMediator(TaskFollowMediator.NAME) as TaskFollowMediator).FindAllCell(TaskTimeoutArr[_local1]["info"].taskId));
                    _local3 = _local3.concat((UIFacade.GetInstance().retrieveMediator(TaskMediator.NAME) as TaskMediator).FindAllCell(TaskTimeoutArr[_local1]["info"].taskId));
                    TaskTimeoutArr[_local1]["updateCells"] = _local3;
                    if (TaskTimeoutArr[_local1]["updateCells"] != null){
                        for each (_local4 in TaskTimeoutArr[_local1]["updateCells"]) {
                            if (_local4){
                                _local4.Update();
                            };
                        };
                        if (((TaskTimeoutArr[_local1]["info"]) && ((TaskTimeoutArr[_local1]["info"].finishTime > 0)))){
                            if (TaskTimeoutArr[_local1]["info"].finishTime < (TimeManager.Instance.Now().time / 1000)){
                                taskErrorByTimeout(TaskTimeoutArr[_local1]["info"]);
                                removeTaskTimeout(TaskTimeoutArr[_local1]["info"]);
                            };
                        } else {
                            if (TaskTimeoutArr[_local1]["info"].IsComplete){
                                removeTaskTimeout(TaskTimeoutArr[_local1]["info"]);
                            };
                        };
                        UIFacade.GetInstance().sendNotification(TaskCommandList.UPDATE_LAYOUT);
                    };
                };
                _local1++;
            };
            if (((!((GameCommonData.Player.Role.ConvoyFlag > 0))) && (currentConvoyTask))){
                removeTaskTimeout(currentConvoyTask);
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function addTaskTimeout(_arg1:TaskInfoStruct):void{
            TaskTimeoutArr.push({info:_arg1});
            if (_arg1.flags == TaskCommonData.QFLAGS_CONVOY){
                ConvoyTaskEndTime = _arg1.finishTime;
                currentConvoyTask = _arg1;
            };
            if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                GameCommonData.GameInstance.GameUI.Elements.Add(this);
            };
        }
        public function removeTaskTimeout(_arg1:TaskInfoStruct):void{
            var _local2:int;
            if (((_arg1) && ((_arg1.taskId > 0)))){
                _local2 = 0;
                while (_local2 < TaskTimeoutArr.length) {
                    if (((TaskTimeoutArr[_local2]["info"]) && ((TaskTimeoutArr[_local2]["info"].taskId == _arg1.taskId)))){
                        TaskTimeoutArr.splice(_local2, 1);
                    };
                    _local2++;
                };
            };
            if (_arg1.flags == TaskCommonData.QFLAGS_CONVOY){
                ConvoyTaskEndTime = 0;
            };
            if (TaskTimeoutArr.length == 0){
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            };
        }

    }
}//package GameUI.Modules.Task.Commamd 
