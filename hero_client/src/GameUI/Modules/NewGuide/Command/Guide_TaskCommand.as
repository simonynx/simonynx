//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.Modules.NewGuide.UI.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Task.Mediator.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.NewInfoTip.Mediator.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;

    public class Guide_TaskCommand extends SimpleCommand {

        public static const NAME:String = "Guide_TaskCommand";

        private var dataProxy:DataProxy;

        private function guidetask_updateProcess(_arg1:TaskInfoStruct, _arg2:Object):void{
            if (_arg2 == null){
                return;
            };
            var _local3:uint = _arg1.taskId;
            var _local4:uint = _arg2["conId"];
            if ((((((_local3 == NewGuideData.TASK_13)) && ((NewGuideData.curType == 13)))) && ((NewGuideData.curStep <= 7)))){
                if ((((_local4 == 1)) && (GameCommonData.TaskInfoDic[_local3].Conditions[_local4].IsComplete))){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:13,
                        STEP:6
                    });
                } else {
                    if ((((_local4 == 2)) && (GameCommonData.TaskInfoDic[_local3].Conditions[_local4].IsComplete))){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:13,
                            STEP:7
                        });
                    };
                };
            } else {
                if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep == 1)))){
                    if ((((_local4 == 0)) && ((GameCommonData.TaskInfoDic[_local3].Conditions[_local4].Current == 1)))){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:19,
                            STEP:2
                        });
                    };
                };
            };
        }
        override public function execute(_arg1:INotification):void{
            if (_arg1.getBody() == null){
                return;
            };
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local2:TaskInfoStruct = _arg1.getBody()["taskInfo"];
            var _local3:uint = _arg1.getBody()["state"];
            var _local4:Object = _arg1.getBody()["data"];
            switch (_local3){
                case 0:
                    guidetask_canAcc(_local2);
                    break;
                case 1:
                    guidetask_acc(_local2);
                    break;
                case 2:
                    guidetask_complete(_local2);
                    break;
                case 3:
                    guidetask_removeComplete(_local2);
                    break;
                case 4:
                    guidetask_updateProcess(_local2, _local4);
                    break;
            };
        }
        private function guidetask_complete(_arg1:TaskInfoStruct):void{
            var _local2:uint = _arg1.taskId;
            switch (_local2){
                case NewGuideData.TASK_5:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:5,
                        STEP:3
                    });
                    break;
                case NewGuideData.TASK_9:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:9,
                        STEP:3
                    });
                    break;
                case NewGuideData.TASK_13:
                    NewGuideData.CurrentTaskId = _arg1.taskId;
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:13,
                        STEP:7
                    });
                    break;
                case NewGuideData.TASK_14:
                    NewGuideData.CurrentTaskId = _arg1.taskId;
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:14,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_15:
                    NewGuideData.CurrentTaskId = _arg1.taskId;
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:15,
                        STEP:2
                    });
                    break;
                case 1306:
                    facade.sendNotification(TranscriptEvent.GUIDE_POINT_LEVELBTN);
                    break;
            };
            if (NewGuideData.TASK_JOBS.indexOf(_local2) != -1){
                facade.sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[_local2]);
                return;
            };
        }
        private function guidetask_acc(_arg1:TaskInfoStruct){
            var taskId:* = 0;
            var str:* = null;
            var pathStr:* = null;
            var taskText:* = null;
            var re:* = null;
            var jm:* = null;
            var taskInfo:* = _arg1;
            if (taskInfo.taskType == QuestType.MAIN){
                NewGuideData.CurrentTaskId = taskInfo.taskId;
            };
            taskId = taskInfo.taskId;
            switch (taskId){
                case NewGuideData.TASK_1:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:1,
                        STEP:6
                    });
                    break;
                case NewGuideData.TASK_4:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:4,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_5:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:5,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_6:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:6,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_7:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:7,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_8:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:8,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_9:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:9,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_10:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:10,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_11:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:11,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_12:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:12,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_13:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:13,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_15:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:15,
                        STEP:1
                    });
                    facade.registerCommand(Guide_OccupationIntro_Command.NAME, Guide_OccupationIntro_Command);
                    break;
                case NewGuideData.TASK_16:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:16,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_17:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:17,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_18:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:18,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_22:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:19,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_FLY:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_FLY);
                    break;
                case 1110:
                case 1113:
                case 1115:
                case 1117:
                    if (GameCommonData.Player.Role.VIP > 0){
                        taskText = TaskCommonData.GetPointFromFollowTree(0);
                        re = TaskCommonData.GetRecBoundToFollowTree(taskText);
                        if (re){
                            if (taskId == 1113){
                                re.x = (re.x + (re.width - 5));
                            } else {
                                re.x = (re.x + re.width);
                            };
                            re.width = 15;
                            jm = JianTouMc.getInstance(JianTouMc.TYPE_VIPFLYTIP).show(taskText, LanguageMgr.GetTranslation("用翅膀瞬间到达目的地"), 1, re);
                            setTimeout(function ():void{
                                jm.close();
                            }, 10000);
                        };
                    };
                    break;
                case 1700:
                    GameCommonData.Player.Stop();
                    if (GameCommonData.Player.Role.UsingPetAnimal){
                        GameCommonData.Player.Role.UsingPetAnimal.Stop();
                    };
                    str = (GameCommonData.TaskInfoDic[taskId] as TaskInfoStruct).taskProcessFinish;
                    pathStr = TaskCommonData.getQuestEventData(str);
                    GameCommonData.TaskTargetCommand = pathStr[4];
                    GameCommonData.targetID = pathStr[4];
                    facade.sendNotification(EventList.SHOWALERT, {
                        comfrim:MoveToCommon.sendFlyToCommand,
                        isShowClose:false,
                        comfirmTxt:LanguageMgr.GetTranslation("立即传送"),
                        title:LanguageMgr.GetTranslation("提示"),
                        delayTime:5,
                        info:LanguageMgr.GetTranslation("5秒自动回主城提示句"),
                        params:{
                            mapId:pathStr[0],
                            tileX:pathStr[1],
                            tileY:pathStr[2],
                            taskId:pathStr[3],
                            npcId:pathStr[4]
                        }
                    });
                    break;
                case NewGuideData.TASK_SHENGYUAN_SINGLE:
                    sendNotification(EventList.SELECTED_NPC_ELEMENT, {npcId:DialogConstData.getInstance().getNpcByMonsterId(1078).Role.Id});
                    NewGuideData.PointNPCIsOpen = true;
                    break;
                case NewGuideData.TASK_EQUIPEXCHANGE:
                    facade.registerCommand(Guide_EquipExchangeCommand.NAME, Guide_EquipExchangeCommand);
                    facade.sendNotification(Guide_EquipExchangeCommand.NAME, {step:1});
                    break;
                case 1301:
                    facade.registerCommand(Guide_Strengthen_New_Command.NAME, Guide_Strengthen_New_Command);
                    facade.sendNotification(EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI);
                    break;
                case 1306:
                    NewGuideData.PointNPCIsOpen = true;
                    break;
                case 1308:
                    facade.registerCommand(Guide_ConvoyCommand.NAME, Guide_ConvoyCommand);
                    break;
            };
            if (taskInfo.flags == TaskCommonData.QFLAGS_CONVOY){
                if (facade.hasCommand("Guide_ConvoyCommand")){
                    facade.sendNotification("Guide_ConvoyCommand", {step:3});
                };
            };
        }
        private function guidetask_removeComplete(_arg1:TaskInfoStruct):void{
            var _local3:DisplayObject;
            var _local4:Rectangle;
            var _local2:uint = _arg1.taskId;
            if (NewGuideData.TASK_JOBS.indexOf(_local2) != -1){
                NewGuideData.CurrentTaskId = _arg1.taskId;
                facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_EXCHANGE, {
                    step:1,
                    data:{npcId:_arg1.taskCommitNpcId}
                });
                return;
            };
            switch (_local2){
                case 1001:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:14,
                        STEP:2
                    });
                    break;
                case NewGuideData.TASK_1:
                    if ((((facade.retrieveMediator(GetRewardMediator.NAME) as GetRewardMediator)) && ((facade.retrieveMediator(GetRewardMediator.NAME) as GetRewardMediator).equipPanel))){
                        facade.sendNotification(NPCChatComList.HIDE_NPC_CHAT);
                        (facade.retrieveMediator(GetRewardMediator.NAME) as GetRewardMediator).equipPanel.centerFrame();
                        _local3 = (facade.retrieveMediator(GetRewardMediator.NAME) as GetRewardMediator).equipPanel.okBtn;
                        _local4 = _local3.getBounds(_local3.stage);
                        JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("点击领取使用武器"), 1, _local4);
                    };
                    break;
                case NewGuideData.TASK_TRANS:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:NewGuideData.TASK_TRANS,
                        STEP:1
                    });
                    break;
                case NewGuideData.TASK_CONSIGNMENT:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_CONSIGNMENT);
                    break;
                case NewGuideData.TASK_SHOWBTN_TREASURE:
                    GuidePicFrame.show(GuidePicFrame.TYPE_TREASURE);
                    break;
                case NewGuideData.TASK_SHOWBTN_STRENGTHEN:
                    GuidePicFrame.show(GuidePicFrame.TYPE_STRENGTHEN);
                    break;
                case NewGuideData.TASK_SHOWBTN_SHILIAN:
                    GuidePicFrame.show(GuidePicFrame.TYPE_SHILIAN);
                    break;
                case 1109:
                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_USEVIPCAR_STARTUP);
                    facade.sendNotification(Guide_UseVipcarCommand.NAME, {step:1});
                    break;
                case 1223:
                    facade.registerCommand(Guide_PointJewelry.NAME, Guide_PointJewelry);
                    facade.sendNotification(Guide_PointJewelry.NAME);
                    break;
                case 1700:
                    GameCommonData.Player.Stop();
                    if (GameCommonData.Player.Role.UsingPetAnimal){
                        GameCommonData.Player.Role.UsingPetAnimal.Stop();
                    };
                    facade.sendNotification(TaskTextCommand.NAME, {text:"showBagPanel_0_50200003"});
                    dataProxy.Guide_30Chest_Started = true;
                    break;
                case 1229:
                    facade.registerCommand(Guide_SaleItemCommand.NAME, Guide_SaleItemCommand);
                    facade.sendNotification(Guide_SaleItemCommand.NAME, {step:0});
                    break;
                case 1306:
                    if (GameCommonData.ModuleCloseConfig[2] == 1){
                        break;
                    };
                    facade.sendNotification(TranscriptEvent.SHOW_TOWER_VIEW);
                    facade.sendNotification(TranscriptEvent.GUILD_POINT_RANKTEXT);
                    break;
                case 1307:
                    facade.sendNotification(EventList.SHOW_UPGRADE_BIBLE_ICON);
                    break;
                case 1310:
                    if (facade.retrieveMediator(TaskFollowMediator.NAME).getViewComponent().taskFollowPanel.CanAccTree.dataProvider.length > 0){
                        facade.retrieveMediator(TaskFollowMediator.NAME).getViewComponent().selectPage(1);
                    };
                    break;
            };
        }
        private function guidetask_canAcc(_arg1:TaskInfoStruct){
        }

    }
}//package GameUI.Modules.NewGuide.Command 
