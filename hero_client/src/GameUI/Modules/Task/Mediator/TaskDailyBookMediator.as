//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;

    public class TaskDailyBookMediator extends Mediator {

        public static const NAME:String = "TaskDailyBookMediator";

        public function TaskDailyBookMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWTASKDAILYBOOK, EventList.CLOSETASKDAILYBOOK, TaskCommandList.UPDATE_TASK_PROCESS_VIEW, EventList.UPDATE_DAILYBOOKRESULT, EventList.UPDATE_ACTIVITY, TaskCommandList.REMOVE_ACCEPT_TASK, TaskCommandList.UPDATETASKTREE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:TaskInfoStruct;
            var _local4:InventoryItemInfo;
            switch (_arg1.getName()){
                case EventList.SHOWTASKDAILYBOOK:
                    if (TaskCommonData.CurrentDialyBookTaskId == 0){
                        _local4 = BagData.getItemById(TaskCommonData.DailyBookItemGuid);
                        if (_local4){
                            BagInfoSend.ItemUse(_local4.ItemGUID);
                        } else {
                            return;
                        };
                    };
                    view.show();
                    view.centerFrame();
                    dataProxy.TaskDailyBOokIsOpen = true;
                    break;
                case EventList.CLOSETASKDAILYBOOK:
                    view.close();
                    dataProxy.TaskDailyBOokIsOpen = false;
                    break;
                case EventList.UPDATE_DAILYBOOKRESULT:
                    if ((dataProxy.TaskDailyBOokIsOpen = false)){
                        return;
                    };
                    if (_arg1.getBody()){
                        view.updateData(true, _arg1.getBody());
                    } else {
                        view.updateData();
                    };
                    break;
                case EventList.UPDATE_ACTIVITY:
                    if ((dataProxy.TaskDailyBOokIsOpen = false)){
                        return;
                    };
                    view.updateData();
                    break;
                case TaskCommandList.REMOVE_ACCEPT_TASK:
                    view.updateData();
                    view.resetHC();
                    break;
                case TaskCommandList.UPDATETASKTREE:
                    if ((dataProxy.TaskDailyBOokIsOpen = false)){
                        return;
                    };
                    _local2 = _arg1.getBody();
                    if (_local2.type == 2){
                        if (_local2.id == TaskCommonData.CurrentDialyBookTaskId){
                            view.updateData();
                        };
                    };
                    break;
                case TaskCommandList.UPDATE_TASK_PROCESS_VIEW:
                    if ((dataProxy.TaskDailyBOokIsOpen = false)){
                        return;
                    };
                    _local3 = (_arg1.getBody() as TaskInfoStruct);
                    if (_local3.taskId == TaskCommonData.CurrentDialyBookTaskId){
                        view.updateData();
                    };
                    break;
            };
        }
        public function get dataProxy():DataProxy{
            return ((facade.retrieveProxy(DataProxy.NAME) as DataProxy));
        }
        public function get view():DailyBookTaskWindow{
            if (viewComponent == null){
                setViewComponent(new DailyBookTaskWindow());
                view.closeCallBack = function ():void{
                    facade.sendNotification(EventList.CLOSETASKDAILYBOOK);
                };
            };
            return ((viewComponent as DailyBookTaskWindow));
        }

    }
}//package GameUI.Modules.Task.Mediator 
