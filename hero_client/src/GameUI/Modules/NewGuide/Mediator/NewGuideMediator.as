//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class NewGuideMediator extends Mediator {

        public static const NAME:String = "NewPlayerGuildMediator";

        private var _uiManager:NewGuideUIMediator;
        private var _dataProxy:DataProxy;

        public function NewGuideMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        override public function listNotificationInterests():Array{
            return ([NewGuideEvent.NEWPLAYER_GUILD_INIT, NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, NewGuideEvent.NEWPLAYER_GUILD_UPSTEP, NewGuideEvent.NEWPLAYER_GUILD_UPDATESTEP, NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP, NewGuideEvent.NEWPLAYER_GUILD_CLOSEGUIDEFRAME, NewGuideEvent.NEWPLAYER_GUILD_HAVENEWSKILLPOINT, NewGuideEvent.NEWPLAYER_GUILD_OPENBOX10, NewGuideEvent.NEWPLAYER_GUILD_CONSIGNMENT, NewGuideEvent.NEWPLAYER_GUILD_TREASURE, NewGuideEvent.NEWPLAYER_GUILD_CHANGESCENE, NewGuideEvent.NEWPLAYER_GUILD_FLY, NewGuideEvent.NEWPLAYER_GUILD_EXCHANGE, NewGuideEvent.NEWPLAYER_GUILD_TOWERJUMP, NewGuideEvent.NEWPLAYER_GUILD_PETRACE, NewGuideEvent.NEWPLAYER_GUILD_STRENGTHEN, NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_STARTUP, NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_SHUTDOWN, NewGuideEvent.NEWPLAYER_GUILD_PETQUALITYREFRESH_STARTUP, NewGuideEvent.NEWPLAYER_GUILD_PETQUALITYREFRESH_SHUTDOWN, NewGuideEvent.NEWPLAYER_GUILD_USEVIPCAR_STARTUP, NewGuideEvent.NEWPLAYER_GUILD_USEVIPCAR_SHUTDOWN, NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_STARTUP, NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_SHUTDOWN, NewGuideEvent.POINTBAGITEM, NewGuideEvent.POINTBAGITEM_CLOSE, EventList.RESIZE_STAGE]);
        }
        private function checkOccupationIntro():void{
            var _local1:TaskInfoStruct = GameCommonData.TaskInfoDic[NewGuideData.TASK_15];
            if (((_local1.IsAccept) && (!(_local1.IsComplete)))){
                facade.registerCommand(Guide_OccupationIntro_Command.NAME, Guide_OccupationIntro_Command);
            };
        }
        private function checkTypeStep():void{
            var _local2:int;
            var _local1 = 1;
            NewGuideData.curType = 0;
            NewGuideData.newerHelpIsOpen = true;
            if (GameCommonData.Player.Role.Level < 2){
                NewGuideData.CurrentTaskId = NewGuideData.TASK_1;
                NewGuideData.curType = 1;
                NewGuideData.curStep = 1;
                return;
            };
            if (initTypeStep(NewGuideData.TASK_1, [1, 3], [], [1, 6])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_2, [2, 1], [2, 2], [2, 3])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_4, [], [4, 1], [4, 3])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_5, [], [], [5, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_6, [], [6, 1], [6, 3])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_7, [], [], [7, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_8, [], [8, 1], [8, 7])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_9, [], [9, 1], [9, 3])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_10, [], [], [10, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_11, [], [], [11, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_12, [], [], [12, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_13, [], [13, 1], [13, 10])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_14, [], [], [14, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_15, [], [15, 1], [15, 2])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_16, [], [], [16, 1])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_17, [], [17, 1], [17, 4])){
                return;
            };
            if (initTypeStep(NewGuideData.TASK_18, [], [], [18, 1])){
                return;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:DisplayObject;
            var _local3:uint;
            var _local4:uint;
            var _local5:int;
            var _local6:Object;
            switch (_arg1.getName()){
                case NewGuideEvent.NEWPLAYER_GUILD_INIT:
                    _dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    _uiManager = new NewGuideUIMediator();
                    facade.registerMediator(_uiManager);
                    facade.registerCommand(Guide_ChangeSceneCommand.NAME, Guide_ChangeSceneCommand);
                    facade.registerCommand(Guide_TaskCommand.NAME, Guide_TaskCommand);
                    facade.registerCommand(Guide_BagCommand.NAME, Guide_BagCommand);
                    facade.registerCommand(Guide_PetRaceCommand.NAME, Guide_PetRaceCommand);
                    checkTypeStep();
                    checkOccupationIntro();
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP:
                    if (((!(NewGuideData.newerHelpIsOpen)) || (!(_uiManager)))){
                        return;
                    };
                    if (_arg1.getBody()){
                        _local2 = (_arg1.getBody()["POINT"] as DisplayObject);
                    };
                    if (_arg1.getBody()["TYPE"] == null){
                        _local3 = 0;
                    } else {
                        _local3 = uint(_arg1.getBody()["TYPE"]);
                    };
                    if (_arg1.getBody()["STEP"] == null){
                        _local4 = 1;
                    } else {
                        _local4 = uint(_arg1.getBody()["STEP"]);
                    };
                    if (_local3 > 0){
                        NewGuideData.curType = _local3;
                        NewGuideData.curStep = _local4;
                        _uiManager.doGuide(_local3, _local4, _local2);
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_UPSTEP:
                    NewGuideData.curStep++;
                    if (_arg1.getBody()){
                        _local2 = (_arg1.getBody()["POINT"] as DisplayObject);
                    };
                    if (_uiManager){
                        _uiManager.doGuide(NewGuideData.curType, NewGuideData.curStep, _local2);
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP:
                    if (_uiManager){
                        _uiManager.hideJianTouUI();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_UPDATESTEP:
                    checkTypeStep();
                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:NewGuideData.curType,
                        STEP:NewGuideData.curStep
                    });
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_CLOSEGUIDEFRAME:
                    if (GameCommonData.Player.Role.Level < 2){
                        CharacterSend.GetReward(GetRewardType.LEVEL_ITEM_EXP);
                    };
                    if (_uiManager){
                        _uiManager.closeGuideFrame();
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    if (_uiManager){
                        _uiManager.resize();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_HAVENEWSKILLPOINT:
                    if (_uiManager){
                        _uiManager.Guide_HaveNewSkillPoint();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_OPENBOX10:
                    if (_uiManager){
                        _uiManager.Guide_OpenBox10();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_CONSIGNMENT:
                    if (_uiManager){
                        _uiManager.Guide_Consignment();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_TREASURE:
                    if (_uiManager){
                        _uiManager.Guide_Treasure();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_CHANGESCENE:
                    facade.sendNotification(Guide_ChangeSceneCommand.NAME);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_FLY:
                    if (_uiManager){
                        _uiManager.Guide_Fly();
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_TOWERJUMP:
                    if (_uiManager){
                        _uiManager.Guide_TowerJump((_arg1.getBody() as DisplayObject));
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_EXCHANGE:
                    if (_uiManager){
                        _local5 = int(_arg1.getBody()["step"]);
                        _local6 = _arg1.getBody()["data"];
                        NewGuideData.curType = 20;
                        NewGuideData.curStep = _local5;
                        _uiManager.Guide_Exchange(_local5, _local6);
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_PETRACE:
                    if (_uiManager){
                        _local5 = int(_arg1.getBody()["step"]);
                        _local6 = _arg1.getBody()["data"];
                        NewGuideData.curType = 21;
                        NewGuideData.curStep = _local5;
                        _uiManager.Guide_PetRace(_local5, _local6);
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_STRENGTHEN:
                    if (_uiManager){
                        _local5 = int(_arg1.getBody()["step"]);
                        _local6 = _arg1.getBody()["data"];
                        NewGuideData.curType = 22;
                        NewGuideData.curStep = _local5;
                        _uiManager.Guide_Strengthen(_local5, _local6);
                    };
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_STARTUP:
                    facade.registerCommand(Guide_PetUpstarCommand.NAME, Guide_PetUpstarCommand);
                    facade.sendNotification(Guide_PetUpstarCommand.NAME, {step:1});
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_SHUTDOWN:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETUPSTAR).close();
                    facade.removeCommand(Guide_PetUpstarCommand.NAME);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_PETQUALITYREFRESH_STARTUP:
                    facade.registerCommand(Guide_PetQualityRefreshCommand.NAME, Guide_PetQualityRefreshCommand);
                    facade.sendNotification(Guide_PetQualityRefreshCommand.NAME, {step:1});
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_PETQUALITYREFRESH_SHUTDOWN:
                    facade.sendNotification(Guide_PetQualityRefreshCommand.NAME, {step:5});
                    facade.removeCommand(Guide_PetQualityRefreshCommand.NAME);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_USEVIPCAR_STARTUP:
                    facade.registerCommand(Guide_UseVipcarCommand.NAME, Guide_UseVipcarCommand);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_USEVIPCAR_SHUTDOWN:
                    facade.removeCommand(Guide_UseVipcarCommand.NAME);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_STARTUP:
                    facade.registerCommand(Guide_AddJobSkillCommand.NAME, Guide_AddJobSkillCommand);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_SHUTDOWN:
                    facade.removeCommand(Guide_AddJobSkillCommand.NAME);
                    break;
                case NewGuideEvent.POINTBAGITEM:
                    if (_arg1.getBody()){
                        uiManager.Guide_PointBag(_arg1.getBody());
                    };
                    break;
                case NewGuideEvent.POINTBAGITEM_CLOSE:
                    uiManager.Guide_ClosePointBag(_arg1.getBody());
                    break;
            };
        }
        private function initTypeStep(_arg1:int, _arg2:Array, _arg3:Array, _arg4:Array):Boolean{
            var _local5:TaskInfoStruct;
            _local5 = GameCommonData.TaskInfoDic[_arg1];
            if (((_local5) && ((TaskCommonData.CompleteTaskIdArray.indexOf(_local5.taskId) == -1)))){
                NewGuideData.CurrentTaskId = _arg1;
                if (!_local5.IsAccept){
                    if (_arg2.length > 0){
                        NewGuideData.curType = _arg2[0];
                        NewGuideData.curStep = _arg2[1];
                        return (true);
                    };
                    return (false);
                };
                if (!_local5.IsComplete){
                    if (_arg3.length > 0){
                        NewGuideData.curType = _arg3[0];
                        NewGuideData.curStep = _arg3[1];
                        return (true);
                    };
                    return (false);
                };
                if (_arg4.length > 0){
                    NewGuideData.curType = _arg4[0];
                    NewGuideData.curStep = _arg4[1];
                    return (true);
                };
                return (false);
            };
            return (false);
        }
        public function get uiManager():NewGuideUIMediator{
            if (_uiManager == null){
                _uiManager = new NewGuideUIMediator();
            };
            return (_uiManager);
        }

    }
}//package GameUI.Modules.NewGuide.Mediator 
