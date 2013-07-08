//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Alert.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import Net.RequestSend.*;

    public class TaskQuickCompleteCommand extends SimpleCommand {

        public static const NAME:String = "TaskQuickCompleteCommand";

        private var taskInfo:TaskInfoStruct;

        private function okFun():void{
            ActivitySend.sendQuickFinish([taskInfo.taskId], 2);
        }
        override public function execute(_arg1:INotification):void{
            var _local4:Bitmap;
            var _local5:Sprite;
            var _local2:int = int(_arg1.getBody());
            taskInfo = GameCommonData.TaskInfoDic[_local2];
            var _local3 = "";
            _local3 = (_local3 + LanguageMgr.GetTranslation("提示快速完成东东要消耗金叶子"));
            _local3 = (_local3 + ((("<br>" + LanguageMgr.GetTranslation("任务名称")) + "：  ") + taskInfo.title));
            _local3 = (_local3 + (("<br>" + LanguageMgr.GetTranslation("预计花费")) + "： 10"));
            _local4 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("ab");
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:okFun,
                cancel:new Function(),
                info:_local3,
                comfirmTxt:LanguageMgr.GetTranslation("确定"),
                cancelTxt:LanguageMgr.GetTranslation("取消"),
                isShowClose:true
            });
            _local5 = (facade.retrieveMediator(AlertMediator.NAME).getViewComponent() as Sprite);
            if (_local5){
                _local4.x = 186;
                _local4.y = 73;
                _local5.addChild(_local4);
            };
        }

    }
}//package GameUI.Modules.Task.Commamd 
