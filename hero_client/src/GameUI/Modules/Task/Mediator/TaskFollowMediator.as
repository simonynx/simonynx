//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import com.greensock.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;

    public class TaskFollowMediator extends Mediator {

        public static const NAME:String = "TaskFollowMediator";

        protected var dataProxy:DataProxy = null;

        public function TaskFollowMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        protected function showView():void{
            view.mouseEnabled = false;
            var toX:* = (GameCommonData.GameInstance.ScreenWidth - this.view.width);
            var toY:* = TaskFollowWindow.DEFAULT_POS.y;
            GameCommonData.GameInstance.GameUI.addChild(view);
            var timelineLite:* = new TimelineLite();
            timelineLite.append(new TweenLite(this.view.rightBtn, 0.5, {
                x:GameCommonData.GameInstance.ScreenWidth,
                onComplete:function ():void{
                    if (((view.rightBtn) && (GameCommonData.GameInstance.GameUI.contains(view.rightBtn)))){
                        GameCommonData.GameInstance.GameUI.removeChild(view.rightBtn);
                    };
                }
            }));
            timelineLite.append(new TweenLite(this.view, 0.5, {
                x:toX,
                y:toY
            }));
            dataProxy.TaskFollowIsOpen = true;
        }
        public function get view():TaskFollowWindow{
            return ((viewComponent as TaskFollowWindow));
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, TaskCommandList.SHOW_TASKFOLLOW_UI, TaskCommandList.HIDE_TASKFOLLOW_UI, TaskCommandList.ADD_TASK_FOLLOW, TaskCommandList.REMOVE_TASK_FOLLOW, EventList.ENTERMAPCOMPLETE, TaskCommandList.UPDATE_TASK_TOTAL, TaskCommandList.SET_TASKFOLLOW_DRAG, TaskCommandList.ADD_ACCEPT_TASK_TOFOLLOW, TaskCommandList.REMOVE_ACCEPT_TASK_TOFOLLOW, TaskCommandList.REMOVEALL_ACCEPT_FOLLOW, TaskCommandList.UPDATE_TASK_PROCESS_VIEW, TaskCommandList.UPDATE_LAYOUT, TaskCommandList.VISIBLE_TASKFOLLOW_UI, EventList.CHANGE_SCENEAFTER, EventList.RESIZE_STAGE]);
        }
        public function FindAllCell(_arg1:int):Array{
            var _local2:Array = [];
            _local2.push(view.taskFollowPanel.TaskTree.FindGroupCellById(_arg1));
            _local2 = _local2.concat(view.taskFollowPanel.TaskTree.FindCellRendererById(_arg1));
            return (_local2);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:TaskInfoStruct;
            var _local3:Dictionary;
            var _local4:Array;
            var _local5:Array;
            var _local6:int;
            var _local7:uint;
            var _local8:Boolean;
            _local2 = null;
            _local3 = null;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    setViewComponent(new TaskFollowWindow());
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    dataProxy.TaskFollowIsOpen = true;
                    view.selectPage(0);
                    break;
                case TaskCommandList.SHOW_TASKFOLLOW_UI:
                    this.showView();
                    break;
                case TaskCommandList.HIDE_TASKFOLLOW_UI:
                    this.closeView();
                    break;
                case TaskCommandList.ADD_TASK_FOLLOW:
                    _local2 = (_arg1.getBody() as TaskInfoStruct);
                    view.addTask(_local2.taskId);
                    sendNotification(TaskCommandList.UPDATE_TASK_TOTAL);
                    break;
                case TaskCommandList.REMOVE_TASK_FOLLOW:
                    _local2 = (_arg1.getBody() as TaskInfoStruct);
                    view.removeTask(_local2.taskId);
                    sendNotification(TaskCommandList.UPDATE_TASK_TOTAL);
                    break;
                case TaskCommandList.UPDATE_TASK_PROCESS_VIEW:
                    _local2 = (_arg1.getBody() as TaskInfoStruct);
                    this.view.updateTaskProcess(_local2.taskId);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    this.showView();
                    break;
                case TaskCommandList.UPDATE_TASK_TOTAL:
                    break;
                case TaskCommandList.SET_TASKFOLLOW_DRAG:
                    this.view.dragFlag = (_arg1.getBody() as Boolean);
                    if (this.view.dragFlag){
                        if (!dataProxy.TaskFollowIsOpen){
                            sendNotification(TaskCommandList.SET_SHOW_FOLLOW, true);
                        };
                        view.x = (GameCommonData.GameInstance.ScreenWidth - view.width);
                        this.view.y = TaskFollowWindow.DEFAULT_POS.y;
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    if (((view) && (view.parent))){
                        view.x = (GameCommonData.GameInstance.ScreenWidth - view.width);
                    } else {
                        view.x = GameCommonData.GameInstance.ScreenWidth;
                    };
                    view.y = TaskFollowWindow.DEFAULT_POS.y;
                    if (((view.rightBtn) && (view.rightBtn.parent))){
                        view.rightBtn.x = (GameCommonData.GameInstance.ScreenWidth - view.rightBtn.width);
                    } else {
                        view.rightBtn.x = GameCommonData.GameInstance.ScreenWidth;
                    };
                    view.rightBtn.y = TaskFollowWindow.DEFAULT_POS.y;
                    break;
                case TaskCommandList.ADD_ACCEPT_TASK_TOFOLLOW:
                    view.addCanAccTask(int(_arg1.getBody()));
                    break;
                case TaskCommandList.REMOVE_ACCEPT_TASK_TOFOLLOW:
                    _local7 = (_arg1.getBody() as uint);
                    view.removeCanAccTask(_local7);
                    break;
                case TaskCommandList.REMOVEALL_ACCEPT_FOLLOW:
                    view.removeAllAccTaskTree();
                    break;
                case TaskCommandList.UPDATE_LAYOUT:
                    view.updateLayout();
                    break;
                case TaskCommandList.VISIBLE_TASKFOLLOW_UI:
                    _local8 = (_arg1.getBody() as Boolean);
                    view.visible = _local8;
                    view.rightBtn.visible = _local8;
                    break;
                case EventList.CHANGE_SCENEAFTER:
                    if (((GameCommonData.IsInCrossServer) || (MapManager.IsInCSBattleReadyScene))){
                        if (view.visible){
                            view.visible = false;
                            view.rightBtn.visible = false;
                        };
                    } else {
                        if (!view.visible){
                            view.visible = true;
                            view.rightBtn.visible = true;
                        };
                    };
                    break;
            };
        }
        public function get NewGuidePoint_TaskTree():DisplayObject{
            return (this.view.taskFollowPanel.TaskTree);
        }
        public function get NewGuidePoint_TaskTree_Cells():Dictionary{
            return (this.view.taskFollowPanel.TaskTree.CellsDic);
        }
        protected function closeView():void{
            var toX:* = GameCommonData.GameInstance.ScreenWidth;
            var toY:* = TaskFollowWindow.DEFAULT_POS.y;
            GameCommonData.GameInstance.GameUI.addChild(view.rightBtn);
            var timelineLite:* = new TimelineLite();
            timelineLite.append(new TweenLite(this.view, 0.5, {
                x:toX,
                y:toY,
                onComplete:function ():void{
                    if (((view) && (GameCommonData.GameInstance.GameUI.contains(view)))){
                        GameCommonData.GameInstance.GameUI.removeChild(view);
                        dataProxy.TaskFollowIsOpen = false;
                    };
                }
            }));
            timelineLite.append(new TweenLite(this.view.rightBtn, 0.5, {x:(GameCommonData.GameInstance.ScreenWidth - view.rightBtn.width)}));
        }

    }
}//package GameUI.Modules.Task.Mediator 
