//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.events.*;
    import flash.display.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;
    import GameUI.Modules.Task.Interface.*;

    public class TreeCellRenderer extends UISprite implements ITaskTimeUpdate {

        protected var followTf:TextField;
        private var _isSelected:Boolean = false;
        protected var taskFinishTf:TextField;
        public var taskInfo:TaskInfoStruct;
        private var selectAsset:Bitmap;
        private var mouseOverAsset:Bitmap;
        private var remainTime:int;
        public var id:uint;
        protected var desTf:TextField;
        public var data:Object;

        public function TreeCellRenderer(_arg1:uint, _arg2:Boolean=false, _arg3:Object=null){
            this.mouseEnabled = true;
            this.width = 170;
            this.height = 16;
            this.id = _arg1;
            this.isSelected = _arg2;
            this.data = _arg3;
            this.createChildren();
        }
        private function updateRemainTime():void{
            var _local1 = "";
            if ((((taskInfo.finishTime > 0)) && ((taskInfo.limitTime > 0)))){
                remainTime = (taskInfo.finishTime - (TimeManager.Instance.Now().time / 1000));
            };
            if (taskInfo.IsAccept){
                _local1 = (_local1 + ((taskInfo.finishTime == 0)) ? "" : ((remainTime > 0)) ? (((" <font color=\"#39FF0B\">(" + remainTime) + LanguageMgr.GetTranslation("秒")) + ")</font>") : (("<font color=\"#FF0000\">(" + LanguageMgr.GetTranslation("失败")) + ")</font>"));
                if (((taskInfo.IsComplete) && ((taskInfo.finishTime == 0)))){
                    _local1 = (_local1 + (("<font color=\"#39FF0B\">(" + LanguageMgr.GetTranslation("完成")) + ")</font>"));
                };
            };
            this.taskFinishTf.htmlText = _local1;
        }
        public function set isSelected(_arg1:Boolean):void{
            this._isSelected = _arg1;
            if (mouseOverAsset){
                if (mouseOverAsset.parent){
                    mouseOverAsset.parent.removeChild(mouseOverAsset);
                };
                mouseOverAsset.bitmapData.dispose();
                mouseOverAsset = null;
            };
            if (this.isSelected){
                showSelectAsset();
            } else {
                removeSelectAsset();
            };
        }
        protected function doLayout():void{
            this.followTf.x = 2;
            this.followTf.y = Math.floor(((this.height - this.followTf.height) / 2));
            this.desTf.x = 18;
            this.desTf.y = Math.floor(((this.height - this.desTf.height) / 2));
            this.taskFinishTf.x = ((this.width - this.taskFinishTf.width) - 5);
            this.taskFinishTf.y = Math.floor(((this.height - this.taskFinishTf.height) / 2));
        }
        private function removeOverAsset():void{
            if (mouseOverAsset){
                if (mouseOverAsset.parent){
                    mouseOverAsset.parent.removeChild(mouseOverAsset);
                };
                mouseOverAsset.bitmapData.dispose();
                mouseOverAsset = null;
            };
        }
        protected function createChildren():void{
            var _local1:TextFormat;
            this.buttonMode = true;
            taskInfo = (GameCommonData.TaskInfoDic[this.id] as TaskInfoStruct);
            if (taskInfo == null){
                return;
            };
            this.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
            this.addEventListener(MouseEvent.MOUSE_OVER, onRollOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, onRollOutHandler);
            _local1 = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            this.desTf = new TextField();
            this.desTf.mouseEnabled = false;
            this.desTf.defaultTextFormat = _local1;
            this.desTf.autoSize = TextFieldAutoSize.LEFT;
            this.desTf.type = TextFieldType.DYNAMIC;
            this.desTf.selectable = false;
            this.desTf.textColor = 118015;
            this.desTf.htmlText = taskInfo.title;
            if (((((taskInfo.IsAccept) && ((taskInfo.taskType == QuestType.DAILY)))) && ((taskInfo.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                this.desTf.textColor = TaskCommonData.dailyBOokQualityColor[TaskCommonData.CurrentDialyBookQuality][1];
            };
            this.addChild(this.desTf);
            this.taskFinishTf = new TextField();
            this.taskFinishTf.autoSize = TextFieldAutoSize.RIGHT;
            this.taskFinishTf.type = TextFieldType.DYNAMIC;
            this.taskFinishTf.selectable = false;
            this.taskFinishTf.textColor = 3800843;
            this.taskFinishTf.mouseEnabled = false;
            this.addChild(this.taskFinishTf);
            this.followTf = new TextField();
            this.followTf.autoSize = TextFieldAutoSize.LEFT;
            this.followTf.type = TextFieldType.DYNAMIC;
            this.followTf.selectable = false;
            this.followTf.textColor = 0xFF00;
            this.followTf.mouseEnabled = false;
            if (((taskInfo.isFollow) && (taskInfo.IsAccept))){
                this.followTf.text = "√";
            } else {
                this.followTf.text = "";
            };
            this.addChild(this.followTf);
            updateRemainTime();
            this.doLayout();
        }
        private function showSelectAsset():void{
            selectAsset = new Bitmap(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("shooter.task.accet.TaskCellSelectAsset"));
            selectAsset.width = 168;
            selectAsset.height = 16;
            addChild(selectAsset);
        }
        public function dispose():void{
            if (parent){
                parent.removeChild(this);
            };
        }
        protected function onMouseClickHandler(_arg1:MouseEvent):void{
        }
        public function get isSelected():Boolean{
            return (this._isSelected);
        }
        public function Update():void{
            updateRemainTime();
            doLayout();
        }
        private function removeSelectAsset():void{
            if (selectAsset){
                if (selectAsset.parent){
                    selectAsset.parent.removeChild(selectAsset);
                };
                selectAsset.bitmapData.dispose();
                selectAsset = null;
            };
        }
        protected function onRollOutHandler(_arg1:MouseEvent):void{
            if (!this.isSelected){
                removeOverAsset();
            };
        }
        protected function onRollOverHandler(_arg1:MouseEvent):void{
            if (!this.isSelected){
                showOverAsset();
            };
        }
        private function showOverAsset():void{
            mouseOverAsset = new Bitmap(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("shooter.task.accet.TaskCellOverAsset"));
            mouseOverAsset.width = 168;
            mouseOverAsset.height = 16;
            addChild(mouseOverAsset);
        }

    }
}//package GameUI.Modules.Task.View 
