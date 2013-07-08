//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View.TaskFollow {
    import flash.events.*;
    import GameUI.UICore.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.View.HButton.*;
    import GameUI.View.Components.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Task.Interface.*;

    public class TaskFollowTreeCellRenderer extends UISprite implements ITaskTimeUpdate {

        private var _isComplete:Boolean;
        public var data:QuestCondition;
        public var desTT:TaskText;
        private var taskInfo:TaskInfoStruct;
        public var id:uint;
        private var quickCompleteBtn:HLabelButton;

        public function TaskFollowTreeCellRenderer(_arg1:uint, _arg2:Boolean=false, _arg3:Object=null){
            this.mouseEnabled = false;
            this.width = 170;
            this.height = 25;
            this.id = _arg1;
            this.data = (_arg3 as QuestCondition);
            this.taskInfo = GameCommonData.TaskInfoDic[id];
            this.createChildren();
        }
        public function get isComplete():Boolean{
            if (((data) && (data.IsComplete))){
                return (true);
            };
            return (false);
        }
        private function updateText():void{
            var _local1:uint;
            var _local2:String;
            if (!taskInfo.IsAccept){
                desTT.tfText = (((("<font color=\"#FFFFFF\">" + LanguageMgr.GetTranslation("任务接取")) + ":<U>") + taskInfo.taskNPCAndPoint) + "</U></font>");
            } else {
                if (taskInfo.IsComplete){
                    desTT.tfText = (("<font color=\"#00FF00\">" + taskInfo.taskProcessFinish) + "</font>");
                } else {
                    if (data.IsComplete){
                        desTT.tfText = ((("<font color=\"#00FF00\">" + data.description) + data.ProcessStr) + "</font>");
                    } else {
                        switch (data.type){
                            case QuestConditionType.QUEST_FLAG_ONLINE:
                                _local1 = ((data.OnlineTime_ResultTime - TimeManager.Instance.Now().time) / 1000);
                                _local2 = (((((((("<font color=\"#FFFFFF\">" + LanguageMgr.GetTranslation("剩余时间")) + ":") + uint((_local1 / 3600))) + ":") + uint(((_local1 % 3600) / 60))) + ":") + uint((_local1 % 60))) + "</font>");
                                _local2 = (_local2 + ((("<br><font color=\"#FFFFFF\">" + data.description) + data.ProcessStr) + "</font>"));
                                desTT.tfText = _local2;
                                break;
                            default:
                                desTT.tfText = ((("<font color=\"#FFFFFF\">" + data.description) + data.ProcessStr) + "</font>");
                        };
                    };
                };
            };
            this.addChild(desTT);
            this.doLayout();
        }
        protected function createChildren():void{
            this.mouseEnabled = false;
            var _local1:TaskInfoStruct = (GameCommonData.TaskInfoDic[this.id] as TaskInfoStruct);
            if (_local1 == null){
                return;
            };
            var _local2:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            quickCompleteBtn = new HLabelButton();
            quickCompleteBtn.label = LanguageMgr.GetTranslation("快速完成");
            if ((((((taskInfo.taskType == QuestType.DAILY)) && (taskInfo.IsAccept))) && (!(taskInfo.IsComplete)))){
            };
            desTT = new TaskText(170);
            desTT.mouseEnabled = false;
            updateText();
        }
        public function Update():void{
            if (((taskInfo) && (data))){
                updateText();
            };
        }
        private function __clickHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(TaskQuickCompleteCommand.NAME, taskInfo.taskId);
        }
        protected function doLayout():void{
            var _local1:int;
            _local1 = 5;
            this.desTT.x = 0;
            this.desTT.y = _local1;
            _local1 = (_local1 + desTT.height);
            if (quickCompleteBtn.parent){
                quickCompleteBtn.x = 0;
                quickCompleteBtn.y = _local1;
                _local1 = (_local1 + quickCompleteBtn.height);
            };
            this.height = (5 + _local1);
        }
        public function dispose():void{
            if (parent){
                parent.removeChild(this);
            };
        }

    }
}//package GameUI.Modules.Task.View.TaskFollow 
