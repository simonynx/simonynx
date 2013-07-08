//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import Manager.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Task.View.TaskFollow.*;

    public class TaskFollowWindow extends Sprite {

        public static const BG_HEIGHT:Array = [150, 250, 400];
        public static const DEFAULT_POS:Point = new Point(764, 185);
        public static const ALPHA:Array = [0, 0.2, 0.4, 0.6, 1];

        public var dragFlag:Boolean;
        private var bgView:MovieClip;
        public var taskFollowPanel:TaskFollowPanel;
        public var rightBtn:MovieClip;
        protected var currentAlphaIndex:uint = 4;
        protected var currentHeightIndex:uint = 1;

        public function TaskFollowWindow(){
            initView();
            addEvents();
        }
        public function addTask(_arg1:int):void{
            taskFollowPanel.addTask(_arg1);
        }
        protected function onAlphaHandler(_arg1:MouseEvent):void{
            currentAlphaIndex++;
            if (currentAlphaIndex >= ALPHA.length){
                currentAlphaIndex = 0;
            };
            this.bgView.mc_bg.alpha = ALPHA[currentAlphaIndex];
        }
        protected function onDragMcMouseUpHandler(_arg1:MouseEvent):void{
            this.stopDrag();
        }
        private function initView():void{
            bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TaskFollow");
            addChild(bgView);
            this.x = (GameCommonData.GameInstance.ScreenWidth - bgView.width);
            this.y = DEFAULT_POS.y;
            rightBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TaskFollowRightBtn");
            rightBtn.x = (GameCommonData.GameInstance.ScreenWidth - rightBtn.width);
            rightBtn.y = DEFAULT_POS.y;
            rightBtn.titleTF.selectable = false;
            rightBtn.titleTF.mouseEnabled = false;
            this.taskFollowPanel = new TaskFollowPanel(BG_HEIGHT[currentHeightIndex]);
            taskFollowPanel.x = 0;
            taskFollowPanel.y = 25;
            this.bgView.addChild(taskFollowPanel);
            this.bgView.accTaskBtn.buttonMode = true;
            this.bgView.canAccTaskBtn.buttonMode = true;
            this.bgView.pagetext_0.selectable = false;
            this.bgView.pagetext_0.mouseEnabled = false;
            this.bgView.pagetext_1.selectable = false;
            this.bgView.pagetext_1.mouseEnabled = false;
            (this.bgView.mc_bg as MovieClip).mouseEnabled = false;
            (this.bgView.mc_bg as MovieClip).alpha = ALPHA[currentAlphaIndex];
            (this.bgView.mc_bg as MovieClip).height = BG_HEIGHT[currentHeightIndex];
        }
        private function addEvents():void{
            this.bgView.btn_Expand.addEventListener(MouseEvent.CLICK, onExpandHandler);
            this.bgView.btn_Alpha.addEventListener(MouseEvent.CLICK, onAlphaHandler);
            this.bgView.btn_Right.addEventListener(MouseEvent.CLICK, onCloseHandler);
            this.bgView.btn_Move.addEventListener(MouseEvent.MOUSE_DOWN, onDragMcMouseDownHandler);
            this.bgView.btn_Move.addEventListener(MouseEvent.MOUSE_UP, onDragMcMouseUpHandler);
            rightBtn.addEventListener(MouseEvent.CLICK, onShowHandler);
            this.bgView.accTaskBtn.addEventListener(MouseEvent.MOUSE_UP, __onSelectPageHandler);
            this.bgView.canAccTaskBtn.addEventListener(MouseEvent.MOUSE_UP, __onSelectPageHandler);
        }
        public function updateLayout():void{
            taskFollowPanel.updateLayout();
        }
        private function __onSelectPageHandler(_arg1:MouseEvent):void{
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            if (_arg1.currentTarget == this.bgView.accTaskBtn){
                selectPage(0);
            } else {
                if (_arg1.currentTarget == this.bgView.canAccTaskBtn){
                    selectPage(1);
                };
            };
        }
        public function updateTaskProcess(_arg1:int):void{
            taskFollowPanel.updateTaskProcess(_arg1);
        }
        public function removeTask(_arg1:int):void{
            taskFollowPanel.removeTask(_arg1);
        }
        public function selectPage(_arg1:int):void{
            if (_arg1 == 0){
                this.bgView.accTaskBtn.gotoAndStop(1);
                this.bgView.canAccTaskBtn.gotoAndStop(2);
                this.bgView.pagetext_0.textColor = 0xFFEA00;
                this.bgView.pagetext_1.textColor = 0xFFFFFF;
            } else {
                if (_arg1 == 1){
                    this.bgView.accTaskBtn.gotoAndStop(2);
                    this.bgView.canAccTaskBtn.gotoAndStop(1);
                    this.bgView.pagetext_0.textColor = 0xFFFFFF;
                    this.bgView.pagetext_1.textColor = 0xFFEA00;
                };
            };
            this.taskFollowPanel.selectPage(_arg1);
        }
        protected function onDragMcMouseDownHandler(_arg1:MouseEvent):void{
            if (this.dragFlag){
                return;
            };
            this.startDrag();
        }
        private function onShowHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(TaskCommandList.SET_SHOW_FOLLOW, true);
        }
        protected function onCloseHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(TaskCommandList.SET_SHOW_FOLLOW, false);
        }
        public function removeAllAccTaskTree():void{
            taskFollowPanel.removeAllAccTaskTree();
        }
        public function addCanAccTask(_arg1:int):void{
            taskFollowPanel.addCanAccTask(_arg1);
        }
        protected function onExpandHandler(_arg1:MouseEvent):void{
            currentHeightIndex++;
            if (currentHeightIndex >= BG_HEIGHT.length){
                currentHeightIndex = 0;
            };
            (this.bgView.mc_bg as MovieClip).height = BG_HEIGHT[currentHeightIndex];
            this.taskFollowPanel.maxHeight = BG_HEIGHT[currentHeightIndex];
        }
        public function removeCanAccTask(_arg1:int):void{
            taskFollowPanel.removeCanAccTask(_arg1);
        }

    }
}//package GameUI.Modules.Task.Mediator 
