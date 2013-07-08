//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {
    import flash.events.*;
    import flash.utils.*;

    public class TaskGroupStruct extends EventDispatcher {

        public var taskDic:Dictionary;
        public var desColor:uint = 0xFFFFFF;
        public var des:String;
        public var isExpand:Boolean = false;
        public var taskType:uint;

        public function TaskGroupStruct(_arg1:Dictionary, _arg2:Boolean, _arg3:uint, _arg4:uint=0xFFFFFF){
            super(null);
            this.taskType = _arg3;
            this.des = QuestType.GetTypeName(taskType);
            this.desColor = _arg4;
            this.taskDic = _arg1;
            this.isExpand = _arg2;
        }
    }
}//package GameUI.Modules.Task.Model 
