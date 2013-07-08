//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.Task.Interface.*;

    public class TaskGroupCellRenderer extends UISprite implements ITaskTimeUpdate {

        private var icon:MovieClip;
        private var _isExpand:Boolean;
        private var desTf:TextField;
        private var _info:TaskGroupStruct;
        private var des:String;
        public var taskType:int;

        public function TaskGroupCellRenderer(_arg1:TaskGroupStruct){
            this._info = _arg1;
            this.des = _arg1.des;
            this.isExpand = _arg1.isExpand;
            this.taskType = _arg1.taskType;
            this.cacheAsBitmap = true;
            this.createChildren();
        }
        public function Update():void{
        }
        public function get info():TaskGroupStruct{
            return (_info);
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
            this.width = 214;
            this.height = 16;
            this.desTf.x = 25;
        }
        public function dispose():void{
            if (parent){
                parent.removeChild(this);
            };
        }
        protected function createChildren():void{
            var _local2:int;
            this.desTf = new TextField();
            var _local1:TextFormat = new TextFormat("黑体", 13);
            this.desTf.filters = OopsEngine.Graphics.Font.Stroke();
            this.desTf.defaultTextFormat = _local1;
            this.desTf.autoSize = TextFieldAutoSize.LEFT;
            this.desTf.type = TextFieldType.DYNAMIC;
            this.desTf.selectable = false;
            this.desTf.textColor = 16770049;
            if (taskType == QuestType.LOOP){
                _local2 = (GameCommonData.Player.Role.loopTaskIdx + 1);
                this.des = (this.des + (((("(" + _local2.toString()) + "/") + TaskCommonData.MaxLoopIdx) + ") "));
            };
            this.desTf.text = this.des;
            this.addChild(this.desTf);
            this.doLayout();
        }

    }
}//package GameUI.Modules.Task.View 
