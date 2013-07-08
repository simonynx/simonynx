//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View.TaskFollow {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.Components.*;

    public class TaskFollowPanel extends Sprite {

        private var taskTree:TaskFollowTree;
        private var canAccTree:TaskFollowTree;
        protected var cells:Array;
        protected var padding:uint = 10;
        private var canAccScrollPanel:UIScrollPane;
        private var _maxHeight:uint;
        protected var _dataDic:Dictionary;
        private var scrollPanel:UIScrollPane;

        public function TaskFollowPanel(_arg1:uint){
            this._maxHeight = (_arg1 - 5);
            init();
            addEvents();
            this.createChildren();
        }
        private function __mouseDownHandler(_arg1:MouseEvent):void{
            if ((_arg1.target is TaskFollowPanel)){
                GameCommonData.TargetAnimal = null;
                GameCommonData.IsMoveTargetAnimal = false;
                GameCommonData.GameInstance.GameScene.GetGameScene.dispatchEvent(_arg1);
            };
        }
        public function addTask(_arg1:int):void{
            taskTree.addTask(_arg1);
            scrollPanel.refresh();
        }
        private function init():void{
            this.taskTree = new TaskFollowTree();
            this.scrollPanel = new UIScrollPane(taskTree);
            this.scrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_NEVER;
            this.scrollPanel.width = 223;
            this.scrollPanel.height = _maxHeight;
            this.scrollPanel.x = 0;
            this.scrollPanel.y = 0;
            this.scrollPanel.mouseEnabled = false;
            this.taskTree.mouseEnabled = false;
            this.canAccTree = new TaskFollowTree();
            this.canAccScrollPanel = new UIScrollPane(canAccTree);
            this.canAccScrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_NEVER;
            this.canAccScrollPanel.width = 223;
            this.canAccScrollPanel.height = _maxHeight;
            this.canAccScrollPanel.x = 0;
            this.canAccScrollPanel.y = 0;
            this.canAccScrollPanel.mouseEnabled = false;
            this.canAccTree.mouseEnabled = false;
        }
        public function updateLayout():void{
            taskTree.doLayout();
            canAccTree.doLayout();
            toRepaint();
        }
        public function set maxHeight(_arg1:uint):void{
            this._maxHeight = _arg1;
            this.scrollPanel.height = _maxHeight;
            this.canAccScrollPanel.height = _maxHeight;
            this.toRepaint();
        }
        protected function toRepaint():void{
            scrollPanel.refresh();
            canAccScrollPanel.refresh();
        }
        public function addCanAccTask(_arg1:int):void{
            canAccTree.addTask(_arg1);
            canAccScrollPanel.refresh();
        }
        private function addEvents():void{
            this.addEventListener(MouseEvent.MOUSE_OVER, __scrollMouseOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, __scrollMouseOutHandler);
            this.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
        }
        protected function createChildren():void{
            this._dataDic = new Dictionary();
            this.cells = [];
            this.createCells();
        }
        public function removeAllTaskTree():void{
            taskTree.dataProvider = [];
            scrollPanel.refresh();
        }
        public function removeCanAccTask(_arg1:int):void{
            canAccTree.removeTask(_arg1);
            canAccScrollPanel.refresh();
        }
        public function get TaskTree():TaskFollowTree{
            return (taskTree);
        }
        public function removeAllAccTaskTree():void{
            canAccTree.dataProvider = [];
            canAccScrollPanel.refresh();
        }
        public function updateTaskProcess(_arg1:int):void{
            taskTree.updateTaskProcess(_arg1);
            canAccTree.updateTaskProcess(_arg1);
        }
        public function selectPage(_arg1:int):void{
            if (this.contains(scrollPanel)){
                this.removeChild(scrollPanel);
            };
            if (this.contains(canAccScrollPanel)){
                this.removeChild(canAccScrollPanel);
            };
            if (_arg1 == 0){
                addChild(scrollPanel);
            } else {
                if (_arg1 == 1){
                    addChild(canAccScrollPanel);
                };
            };
        }
        public function get CanAccTree():TaskFollowTree{
            return (canAccTree);
        }
        public function removeTask(_arg1:int):void{
            taskTree.removeTask(_arg1);
            scrollPanel.refresh();
        }
        public function get dataDic():Dictionary{
            return (_dataDic);
        }
        private function __scrollMouseOutHandler(_arg1:MouseEvent):void{
            this.scrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_NEVER;
            this.canAccScrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_NEVER;
        }
        private function createCells():void{
        }
        private function __scrollMouseOverHandler(_arg1:MouseEvent):void{
            this.scrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            this.canAccScrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
        }

    }
}//package GameUI.Modules.Task.View.TaskFollow 
