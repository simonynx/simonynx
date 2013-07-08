//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.Unity.Data.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class TaskTextCommand extends SimpleCommand {

        public static const NAME:String = "TaskTextCommand";

        private var dataProxy:DataProxy;

        public function doSystemCommand(_arg1:String):void{
            var _local2:int;
            var _local3:Array;
            var _local4:int;
            switch (_arg1.split("_")[0]){
                case "showSkillPanel":
                    if (!dataProxy.NewSkillIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "skill");
                        dataProxy.NewSkillIsOpen = true;
                        facade.sendNotification(EventList.SHOWSKILLVIEW);
                    };
                    break;
                case "showRoleEquipPanel":
                    if (!dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "hero");
                        dataProxy.HeroPropIsOpen = true;
                        _local3 = _arg1.split("_");
                        if ((((_local3[1] == 2)) && ((_local3[2] == 0)))){
                            facade.sendNotification(EventList.SET_STAR_OPEN_STATUS, 0);
                        };
                        facade.sendNotification(EventList.SHOWHEROPROP, _local3[1]);
                    };
                    break;
                case "showBagPanel":
                    if (!dataProxy.BagIsOpen){
                        facade.sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "bag");
                        facade.sendNotification(EventList.SHOWBAG, _arg1.split("_")[1]);
                        facade.sendNotification(NewGuideEvent.POINTBAGITEM, {
                            itemId:_arg1.split("_")[2],
                            isJT:true
                        });
                    };
                    break;
                case "showBagPanel2":
                    if (!dataProxy.BagIsOpen){
                        facade.sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "bag");
                        facade.sendNotification(EventList.SHOWBAG, _arg1.split("_")[1]);
                        facade.sendNotification(NewGuideEvent.POINTBAGITEM, {
                            itemId:_arg1.split("_")[2],
                            isJT:false
                        });
                    };
                    break;
                case "showPetViewPanel":
                    if (!dataProxy.PetIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "pet");
                        facade.sendNotification(EventList.SHOWPETVIEW);
                    };
                    break;
                case "showIMPanel":
                    if (!dataProxy.FriendsIsOpen){
                        facade.sendNotification(FriendCommandList.SHOWFRIEND);
                    };
                    break;
                case "showTaskPanel":
                    if (!dataProxy.TaskIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "task");
                        dataProxy.TaskIsOpen = true;
                        facade.sendNotification(EventList.SHOWTASKVIEW);
                        _local4 = _arg1.split("_")[1];
                        if (_local4 > 0){
                            facade.sendNotification(TaskCommandList.TASK_UI_SELECTTASK, _local4);
                        };
                    };
                    break;
                case "showMarketPanel":
                    if (!dataProxy.MarketIsOpen){
                        sendNotification(EventList.SHOWMARKETVIEW);
                    };
                    break;
                case "showEmbed":
                    if (dataProxy.ForgeOpenFlag != DataProxy.FORGE_EQUIP_EMBED){
                        facade.sendNotification(EquipCommandList.SHOW_EQUIPEMBED_UI);
                    };
                    break;
                case "showJobDonate":
                    _local2 = 0;
                    if (_arg1.split("_")[1] == 0){
                        _local2 = GameCommonData.Player.Role.CurrentJobID;
                    } else {
                        _local2 = _arg1.split("_")[1];
                    };
                    if ((((_local2 > 0)) && ((_local2 <= 5)))){
                        facade.sendNotification(UnityEvent.SHOW_GUILDDONATEPANEL, _local2);
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_POINTDONATEBTN);
                    };
                    break;
                case "showTower":
                    sendNotification(TranscriptEvent.SHOW_TOWER_VIEW);
                    break;
                case "showActivity":
                    if (!dataProxy.ActivityViewIsOpen){
                        facade.sendNotification(EventList.SHOW_ACTIVITY);
                    };
                    break;
                case "showPetRace":
                    break;
                case "showRolePanel":
                    if (!dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "hero");
                        dataProxy.HeroPropIsOpen = true;
                        facade.sendNotification(EventList.SHOWHEROPROP, _arg1.split("_")[1]);
                    };
                    break;
                case "showTeam":
                    if (!dataProxy.TeamIsOpen){
                        facade.sendNotification(EventList.SHOWTEAM);
                    };
                    break;
                case "showStrength":
                    facade.sendNotification(EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI);
                    break;
                case "ItemTips":
                    facade.sendNotification(EventList.SHOWITEMTOOLPANEL, {GUID:uint(_arg1.split("_")[1])});
                    break;
                case "UpGradeBible":
                    facade.sendNotification(EventList.SHOW_UPGRADE_BIBLE);
                    break;
                case "showDailyBook":
                    if (!dataProxy.TaskDailyBOokIsOpen){
                        facade.sendNotification(EventList.SHOWTASKDAILYBOOK);
                    };
                    break;
            };
        }
        override public function execute(_arg1:INotification):void{
            var _local6:TaskInfoStruct;
            if (_arg1.getBody() == null){
                return;
            };
            var _local2:int = getTimer();
            if ((facade.retrieveProxy(DataProxy.NAME) as DataProxy).IsCollecting){
                GameCommonData.TargetAnimal = null;
                facade.sendNotification(PlayerInfoComList.CANCEL_COLLECT, false);
            };
            var _local3:String = (_arg1.getBody()["type"] as String);
            var _local4:String = (_arg1.getBody()["text"] as String);
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local5:Array = _local4.split(",");
            if (_local5.length == 5){
                if ((_local5[4] as String)){
                    GameCommonData.TaskTargetCommand = _local5[4];
                    GameCommonData.targetID = -1;
                } else {
                    GameCommonData.TaskTargetCommand = "";
                };
                GameCommonData.targetID = _local5[4];
                _local6 = GameCommonData.TaskInfoDic[_local5[3]];
                if (_local6){
                    if ((((_local6.taskType == QuestType.DAILY)) && ((_local6.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                        if (!_local6.IsAccept){
                            MessageTip.popup("任务还没接取");
                            return;
                        };
                    };
                };
                if (_local3 == "MOVE"){
                    MoveToCommon.MoveTo(_local5[0], _local5[1], _local5[2], _local5[3], _local5[4]);
                } else {
                    if (_local3 == "FLY"){
                        MoveToCommon.FlyTo(_local5[0], _local5[1], _local5[2], _local5[3], _local5[4]);
                    };
                };
            } else {
                doSystemCommand(_local5[0]);
            };
            trace(("tt:" + (getTimer() - _local2)));
        }

    }
}//package GameUI.Modules.Task.Commamd 
