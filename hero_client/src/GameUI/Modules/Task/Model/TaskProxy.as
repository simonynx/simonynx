//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.Modules.Task.Mediator.*;

    public class TaskProxy {

        private static var _instance:TaskProxy;

        public var linkDesDic:Dictionary;
        private var taskMediator:TaskMediator;

        public function TaskProxy(){
            linkDesDic = new Dictionary();
        }
        public static function getInstance():TaskProxy{
            if (_instance == null){
                _instance = new (TaskProxy)();
            };
            return (_instance);
        }

        public function getNpcShowTaskType(_arg1:uint):uint{
            var _local2:uint;
            taskMediator = (UIFacade.UIFacadeInstance.retrieveMediator(TaskMediator.NAME) as TaskMediator);
            var _local3:Array = [];
            var _local4:Array = [];
            if (taskMediator != null){
                _local3 = taskMediator.getViewComponent().taskTree.dataProvider;
                _local4 = taskMediator.getViewComponent().accTaskTree.dataProvider;
                _local2 = this.getAccpetedType(_local3, _arg1);
                _local2 = Math.max(this.getAccpetType(_local4, _arg1), _local2);
            };
            return (_local2);
        }
        private function getAccpetedType(_arg1:Array, _arg2:uint):uint{
            var _local3:TaskGroupStruct;
            var _local4:Dictionary;
            var _local5:*;
            var _local6:TaskInfoStruct;
            var _local7:uint;
            if ((((_arg1 == null)) || ((_arg1.length == 0)))){
                return (_local7);
            };
            for each (_local3 in _arg1) {
                _local4 = _local3.taskDic;
                for (_local5 in _local4) {
                    if (GameCommonData.TaskInfoDic[_local5] != null){
                        _local6 = GameCommonData.TaskInfoDic[_local5];
                        if (_local6.taskCommitNpcId == _arg2){
                            if (_local6.IsComplete){
                                _local7 = 3;
                            } else {
                                _local7 = Math.max(1, _local7);
                            };
                        };
                    };
                };
            };
            return (_local7);
        }
        private function getAccpetType(_arg1:Array, _arg2:uint):uint{
            var _local3:TaskGroupStruct;
            var _local4:Dictionary;
            var _local5:*;
            var _local6:TaskInfoStruct;
            var _local7:uint;
            if ((((_arg1 == null)) || ((_arg1.length == 0)))){
                return (_local7);
            };
            for each (_local3 in _arg1) {
                _local4 = _local3.taskDic;
                for (_local5 in _local4) {
                    if (GameCommonData.TaskInfoDic[_local5] != null){
                        _local6 = GameCommonData.TaskInfoDic[_local5];
                        if (_local6.taskNpcId == _arg2){
                            _local7 = 2;
                            break;
                        };
                    };
                };
            };
            return (_local7);
        }

    }
}//package GameUI.Modules.Task.Model 
