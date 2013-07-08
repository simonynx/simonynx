//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View.TaskFollow {
    import flash.display.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.View.Components.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.Task.Interface.*;

    public class TaskFollowGroupCellRender extends UISprite implements ITaskTimeUpdate {

        private var taskId:int;
        private var _isExpand:Boolean;
        private var isComplete:Boolean;
        private var des:String;
        public var taskInfo:TaskInfoStruct;
        private var _info:TaskGroupStruct;
        private var remainTime:int;
        public var desTf:TaskText;
        private var icon:MovieClip;

        public function TaskFollowGroupCellRender(_arg1:TaskGroupStruct){
            this._info = _arg1;
            this.des = _arg1.des;
            this.taskId = _arg1.taskType;
            this.isExpand = _arg1.isExpand;
            this.cacheAsBitmap = true;
            this.taskInfo = GameCommonData.TaskInfoDic[taskId];
            this.isComplete = taskInfo.IsComplete;
            this.createChildren();
        }
        private function updateRemainTime():void{
            var _local3:String;
            var _local4:int;
            var _local1 = "";
            if ((((taskInfo.finishTime > 0)) && ((taskInfo.limitTime > 0)))){
                remainTime = (taskInfo.finishTime - (TimeManager.Instance.Now().time / 1000));
            };
            var _local2 = "#FFE401";
            if ((((taskInfo.taskType == QuestType.DAILY)) && ((taskInfo.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                if (taskInfo.IsAccept){
                    _local2 = ("#" + TaskCommonData.dailyBOokQualityColor[TaskCommonData.CurrentDialyBookQuality][1].toString(16));
                } else {
                    if (TaskCommonData.CurrentDialyBookTaskId == 0){
                        this.des = LanguageMgr.GetTranslation("日常任务");
                    };
                };
            };
            if ((((taskInfo.taskId >= 2500)) && ((taskInfo.taskId <= 2509)))){
                _local3 = "春";
            } else {
                _local3 = QuestType.GetTypeName(taskInfo.taskType).charAt(0);
            };
            _local1 = (_local1 + (((((("<font color=\"" + _local2) + "\">【") + _local3) + "】") + this.des) + "</font>"));
            if (taskInfo.taskType == QuestType.LOOP){
                _local4 = (GameCommonData.Player.Role.loopTaskIdx + 1);
                _local1 = (_local1 + (((("<font color=\"#FFE401\">(" + _local4.toString()) + "/") + TaskCommonData.MaxLoopIdx) + ") </font>"));
            };
            if (taskInfo.IsAccept){
                _local1 = (_local1 + ((taskInfo.finishTime == 0)) ? "" : ((remainTime > 0)) ? ((((((" <font color=\"#39FF0B\">(" + uint((remainTime / 3600))) + ":") + uint(((remainTime % 3600) / 60))) + ":") + uint((remainTime % 60))) + ")</font>") : (("<font color=\"#FF0000\">(" + LanguageMgr.GetTranslation("失败")) + ")</font>"));
                if (((taskInfo.IsComplete) && ((taskInfo.finishTime == 0)))){
                    _local1 = (_local1 + (("<font color=\"#39FF0B\">(" + LanguageMgr.GetTranslation("完成")) + ")</font>"));
                };
            };
            if ((((taskInfo.taskType == QuestType.MAIN)) && ((GameCommonData.Player.Role.Level < taskInfo.minLevel)))){
                _local1 = (_local1 + ((("<font color=\"#FF0000\">【" + taskInfo.minLevel) + LanguageMgr.GetTranslation("级可接")) + "】</font>"));
            };
            this.desTf.tfText = _local1;
        }
        public function set isExpand(_arg1:Boolean):void{
            if (((this.icon) && (this.icon.parent))){
                this.icon.parent.removeChild(icon);
                this.icon = null;
            };
            if (_arg1){
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("expand");
            } else {
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("unExpand");
            };
            this.icon.buttonMode = true;
            this.icon.width = 13;
            this.icon.height = 13;
            this.icon.x = 5;
            this.icon.y = 3;
            this.addChild(this.icon);
            _isExpand = _arg1;
        }
        protected function doLayout():void{
            this.width = 170;
            this.height = 16;
            this.desTf.x = 15;
        }
        protected function createChildren():void{
            this.desTf = new TaskText(195);
            this.desTf.name = ("taskfollowTaskInfo_" + taskId);
            var _local1:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 13);
            this.desTf.Tf.filters = OopsEngine.Graphics.Font.Stroke();
            this.desTf.Tf.defaultTextFormat = _local1;
            this.desTf.Tf.autoSize = TextFieldAutoSize.LEFT;
            this.desTf.Tf.type = TextFieldType.DYNAMIC;
            this.desTf.Tf.selectable = false;
            this.desTf.Tf.textColor = 16770049;
            updateRemainTime();
            this.addChild(this.desTf);
            this.doLayout();
        }
        public function dispose():void{
            if (this.parent){
                this.parent.removeChild(this);
            };
        }
        public function get TaskId():int{
            return (this.taskId);
        }
        public function Update():void{
            updateRemainTime();
        }
        public function get info():TaskGroupStruct{
            return (this._info);
        }

    }
}//package GameUI.Modules.Task.View.TaskFollow 
