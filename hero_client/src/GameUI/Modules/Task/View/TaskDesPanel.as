//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;

    public class TaskDesPanel extends UIScrollPane {

        private var _height:int;
        private var _width:int;
        private var taskDes:TaskText;
        protected var taskInfo:TaskInfoStruct;
        private var taskTarget:TaskText;
        private var content:UISprite;

        public function TaskDesPanel(_arg1:int, _arg2:int){
            content = new UISprite();
            content.width = _arg1;
            content.height = _arg2;
            super(content);
            this._width = _arg1;
            this._height = _arg2;
            init();
        }
        protected function doLayout():void{
            this.taskDes.y = ((this.taskTarget.y + this.taskTarget.height) + 20);
            var _local1:int = (taskDes.y + taskDes.height);
            content.height = (_local1 + 10);
            refresh();
        }
        public function clearContent():void{
            this.taskDes.tfText = "";
            this.taskTarget.tfText = "";
            doLayout();
        }
        private function update():void{
            if (taskInfo.IsAccept){
                this.taskTarget.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("任务目标")) + ":</font><br><font color=\"#D6C29C\">&nbsp;&nbsp;") + taskInfo.objectives) + "</font>");
            } else {
                this.taskTarget.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("任务名称")) + ":</font><br><font color=\"#D6C29C\">&nbsp;&nbsp;") + taskInfo.title) + "</font>");
            };
            var _local1:Array = taskInfo.taskDes.split("@@");
            this.taskDes.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("任务描述")) + ":<br></font><font color=\"#D6C29C\">&nbsp;&nbsp;") + _local1[(_local1.length - 1)]) + "</font>");
            doLayout();
        }
        private function init():void{
            this.width = _width;
            this.height = _height;
            this.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            this.taskDes = new TaskText(290);
            content.addChild(this.taskDes);
            this.taskTarget = new TaskText(290);
            content.addChild(this.taskTarget);
        }
        public function set info(_arg1:TaskInfoStruct):void{
            this.taskInfo = _arg1;
            update();
        }
        public function get info():TaskInfoStruct{
            return (this.taskInfo);
        }

    }
}//package GameUI.Modules.Task.View 
