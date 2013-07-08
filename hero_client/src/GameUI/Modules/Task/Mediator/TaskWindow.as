//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.View.HButton.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Task.Commamd.*;
    import Net.RequestSend.*;

    public class TaskWindow extends HFrame {

        protected var isFirstCancel:Boolean;
        public var taskTree:TaskUITree;
        public var taskConPanel:TaskConPanel;
        public var bgView:MovieClip;
        public var curID:uint;
        public var isFollowBtn:HLabelButton;
        public var accTaskTree:TaskUITree;
        public var deleteBtn:HLabelButton;
        public var scrollPanel:UIScrollPane;
        public var currentPageIdx:int = 0;
        protected var accScrollPanel:UIScrollPane;
        private var taskDesPanel:TaskDesPanel;

        public function TaskWindow(){
            initView();
            addEvents();
        }
        protected function onShowFollowHandler(_arg1:MouseEvent):void{
            if (_arg1.target.currentFrame == 2){
                if (GameCommonData.Player.Role.Level < 20){
                    MessageTip.show(LanguageMgr.GetTranslation("任务提示6"));
                    return;
                };
                _arg1.target.gotoAndStop(1);
                UIFacade.GetInstance().sendNotification(TaskCommandList.HIDE_TASKFOLLOW_UI);
            } else {
                if (_arg1.target.currentFrame == 1){
                    _arg1.target.gotoAndStop(2);
                    UIFacade.GetInstance().sendNotification(TaskCommandList.SHOW_TASKFOLLOW_UI);
                };
            };
        }
        public function updatePanelInfo(_arg1:int):void{
            taskDesPanel.clearContent();
            taskConPanel.clearContent();
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            if (_local2){
                taskDesPanel.info = _local2;
                taskConPanel.info = _local2;
            };
        }
        private function confirmDelete():void{
            TaskSend.DeleteTask(this.curID);
        }
        public function setSelectedPage(_arg1:uint):void{
            this.currentPageIdx = _arg1;
            if (_arg1 == 0){
                this.bgView.mcpage_0.gotoAndStop(1);
                this.bgView.mcpage_1.gotoAndStop(2);
                this.bgView.mcpage_0.buttonMode = false;
                this.bgView.mcpage_1.buttonMode = true;
                this.bgView.textpage_0.textColor = 16496146;
                this.bgView.textpage_1.textColor = 250597;
                this.scrollPanel.visible = true;
                this.accScrollPanel.visible = false;
                this.scrollPanel.refresh();
                if (taskTree.dataProvider.length == 0){
                    taskTree.selectedID = 0;
                };
                updatePanelInfo(taskTree.selectedID);
                setStatusBySelected(taskTree.selectedID);
            } else {
                if (_arg1 == 1){
                    this.bgView.mcpage_0.gotoAndStop(2);
                    this.bgView.mcpage_1.gotoAndStop(1);
                    this.bgView.mcpage_0.buttonMode = true;
                    this.bgView.mcpage_1.buttonMode = false;
                    this.bgView.textpage_0.textColor = 250597;
                    this.bgView.textpage_1.textColor = 16496146;
                    this.scrollPanel.visible = false;
                    this.accScrollPanel.visible = true;
                    this.accScrollPanel.refresh();
                    if (accTaskTree.dataProvider.length == 0){
                        accTaskTree.selectedID = 0;
                    };
                    updatePanelInfo(accTaskTree.selectedID);
                    setStatusBySelected(accTaskTree.selectedID);
                };
            };
        }
        private function initMainContent():void{
            taskDesPanel = new TaskDesPanel(305, 130);
            taskDesPanel.x = 223;
            taskDesPanel.y = 35;
            bgView.addChild(taskDesPanel);
            taskConPanel = new TaskConPanel(305, 188);
            taskConPanel.x = 223;
            taskConPanel.y = 178;
            bgView.addChild(taskConPanel);
        }
        protected function onCancelTaskHandler(_arg1:MouseEvent):void{
            var _arg1:* = _arg1;
            if (this.currentPageIdx != 0){
                return;
            };
            if (!this.isFirstCancel){
                this.isFirstCancel = true;
            };
            if (this.curID == 0){
                return;
            };
            var taskInfo:* = GameCommonData.TaskInfoDic[this.curID];
            if (taskInfo == null){
                return;
            };
            if (taskInfo.taskType == QuestType.ACTIVE){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:confirmDelete,
                    cancel:function ():void{
                    },
                    info:LanguageMgr.GetTranslation("放弃任务不可再接句"),
                    title:LanguageMgr.GetTranslation("提 示")
                });
                return;
            };
            confirmDelete();
        }
        private function initView():void{
            setSize(542, 428);
            blackGound = false;
            name = "TaskView";
            x = UIConstData.DefaultPos1.x;
            y = UIConstData.DefaultPos1.y;
            titleText = LanguageMgr.GetTranslation("任务面板标题");
            centerTitle = true;
            bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(UIConfigData.TASKVIEW);
            addContent(bgView);
            bgView.mouseEnabled = false;
            bgView.x = 4;
            bgView.y = 22;
            this.deleteBtn = new HLabelButton();
            deleteBtn.label = LanguageMgr.GetTranslation("任务放弃");
            deleteBtn.x = 430;
            deleteBtn.y = 377;
            bgView.addChild(deleteBtn);
            this.isFollowBtn = new HLabelButton();
            isFollowBtn.label = LanguageMgr.GetTranslation("任务追踪1");
            isFollowBtn.x = 350;
            isFollowBtn.y = 377;
            bgView.addChild(this.isFollowBtn);
            this.isFollowBtn.enable = false;
            this.bgView.mc_isShowFollow.gotoAndStop(2);
            this.bgView.mcpage_0.buttonMode = false;
            this.bgView.mcpage_1.buttonMode = true;
            this.bgView.mcpage_0.gotoAndStop(1);
            this.bgView.mcpage_1.gotoAndStop(2);
            this.bgView.textpage_0.mouseEnabled = false;
            this.bgView.textpage_1.mouseEnabled = false;
            this.bgView.textpage_0.textColor = 16496146;
            this.bgView.textpage_1.textColor = 250597;
            initTree();
            initMainContent();
        }
        protected function onCurSelectedChange(_arg1:TreeEvent):void{
            clearContent();
            this.setStatusBySelected(_arg1.id);
            if (this.curID == 0){
                setSelectedPage(currentPageIdx);
            } else {
                updatePanelInfo(this.curID);
            };
        }
        private function addEvents():void{
            deleteBtn.addEventListener(MouseEvent.CLICK, onCancelTaskHandler);
            this.isFollowBtn.addEventListener(MouseEvent.CLICK, onIsFollowClick);
            this.bgView.mc_isShowFollow.addEventListener(MouseEvent.CLICK, onShowFollowHandler);
            this.bgView.mcpage_0.addEventListener(MouseEvent.CLICK, onPageClick);
            this.bgView.mcpage_1.addEventListener(MouseEvent.CLICK, onPageClick);
        }
        private function initTree():void{
            this.taskTree = new TaskUITree();
            this.taskTree.width = 218;
            this.taskTree.y = 5;
            this.taskTree.addEventListener(TreeEvent.CHANGE_SELECTED, onCurSelectedChange);
            this.scrollPanel = new UIScrollPane(taskTree);
            this.scrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            this.scrollPanel.width = 207;
            this.scrollPanel.height = 330;
            this.scrollPanel.x = 12;
            this.scrollPanel.y = 37;
            this.bgView.addChild(this.scrollPanel);
            this.accTaskTree = new TaskUITree();
            this.accTaskTree.width = 218;
            this.accTaskTree.y = 5;
            this.accTaskTree.addEventListener(TreeEvent.CHANGE_SELECTED, onCurSelectedChange);
            this.accScrollPanel = new UIScrollPane(accTaskTree);
            this.accScrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            this.accScrollPanel.width = 207;
            this.accScrollPanel.height = 330;
            this.accScrollPanel.x = 10;
            this.accScrollPanel.y = 37;
            this.bgView.addChild(this.accScrollPanel);
        }
        override public function show():void{
            super.show();
        }
        protected function setStatusBySelected(_arg1:uint):void{
            var _local2:TaskInfoStruct;
            if (_arg1 == 0){
                this.deleteBtn.enable = false;
                this.isFollowBtn.enable = false;
                this.curID = 0;
            } else {
                _local2 = (GameCommonData.TaskInfoDic[_arg1] as TaskInfoStruct);
                if (this.currentPageIdx == 0){
                    this.deleteBtn.enable = true;
                    this.isFollowBtn.enable = true;
                    this.deleteBtn.enable = true;
                    if (_local2.isFollow){
                        this.isFollowBtn.label = LanguageMgr.GetTranslation("任务追踪2");
                    } else {
                        this.isFollowBtn.label = LanguageMgr.GetTranslation("任务追踪1");
                    };
                    if (_local2.IsAccept){
                        this.curID = _arg1;
                    };
                } else {
                    this.deleteBtn.enable = false;
                    this.isFollowBtn.enable = false;
                    if (!_local2.IsAccept){
                        this.curID = _arg1;
                    };
                };
            };
        }
        protected function onIsFollowClick(_arg1:MouseEvent):void{
            var _local2:TaskInfoStruct = (GameCommonData.TaskInfoDic[this.curID] as TaskInfoStruct);
            if (_local2 == null){
                MessageTip.show(LanguageMgr.GetTranslation("任务提示4"));
                return;
            };
            if (((_local2) && (!(_local2.IsAccept)))){
                MessageTip.show(LanguageMgr.GetTranslation("任务提示5"));
                return;
            };
            if (_local2.isFollow){
                _local2.isFollow = false;
                TaskSend.UpdateFollowState(_local2.taskId, false);
                UIFacade.GetInstance().sendNotification(TaskCommandList.REMOVE_TASK_FOLLOW, _local2);
                this.isFollowBtn.label = LanguageMgr.GetTranslation("任务追踪1");
            } else {
                _local2.isFollow = true;
                TaskSend.UpdateFollowState(_local2.taskId, true);
                UIFacade.GetInstance().sendNotification(TaskCommandList.ADD_TASK_FOLLOW, _local2);
                this.isFollowBtn.label = LanguageMgr.GetTranslation("任务追踪2");
            };
        }
        public function updateTaskProcess(_arg1:int):void{
            taskTree.updateTaskProcess(_arg1);
            if (curID == _arg1){
                updatePanelInfo(_arg1);
            };
        }
        protected function onPageClick(_arg1:MouseEvent):void{
            clearContent();
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            if (_arg1.currentTarget.name.split("_")[1] == 0){
                this.setSelectedPage(0);
            } else {
                this.setSelectedPage(1);
            };
        }
        public function updateAccTaskCnt():void{
            this.bgView.txt_currentTaskNum.text = (TaskCommonData.AccTaskTotalCnt + "/20");
        }
        private function clearContent():void{
            taskDesPanel.clearContent();
            taskConPanel.clearContent();
        }

    }
}//package GameUI.Modules.Task.Mediator 
