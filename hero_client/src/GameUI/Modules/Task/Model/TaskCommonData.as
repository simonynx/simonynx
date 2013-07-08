//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Task.Mediator.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import GameUI.Modules.Task.View.TaskFollow.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NPCChat.Mediator.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class TaskCommonData {

        public static const GUILD_QUEST_REWARD_GOLD:uint = 2;
        public static const QFLAGS_GUILD:int = 2;
        public static const QFLAGS_SPECILDAILY:int = 5;
        public static const LoopBaseTaskId:int = 4000;
        public static const QFLAGS_DAILYBOOK:int = 6;
        public static const QFLAGS_MAYOR:int = 4;
        public static const QFLAGS_NONE:int = 0;
        public static const GUILD_QUEST_REWARD_ITEM:uint = 3;
        public static const QFLAGS_CONVOY:int = 1;
        public static const QFLAGS_DIVINE:int = 3;
        public static const GUILD_QUEST_REWARD_EXP:uint = 1;

        public static var CurrentDialyBookQuality:int;
        public static var CompleteTaskIdArray:Array = [];
        public static var AccTaskTotalCnt:int = 0;
        public static var IsLoadedQuestlog:Boolean = false;
        public static var GuildOfferStep:Array = [1000, 88000, 306000, 864000, 0x1F4000, 4620000, 9540000, 17550000];
        public static var DivineResultTime:Number = 0;
        public static var CurrentDialyBookTaskId:int;
        public static var TaskItemIds:Array = [60200002, 60200008, 60200007, 60200006, 60200003];
        private static var newguideTaskPathPointDic:Dictionary;
        public static var dailyBOokQualityColor:Array = [["白色", 0xFFFFFF], ["绿色", 0xFF00], ["蓝色", 39372], ["紫色", 0xCC00FF], ["橙色", 16750899]];
        public static var DivineBaseTaskInfo:TaskInfoStruct;
        public static var CurrentMainTaskId:int = 0;
        public static var SpecialDailyTaskCanAccList:Array = [];
        private static var _taskPathPointdic:Dictionary;
        public static var LoopTaskCommitNpcArrTemp:Array = [0, 1026, 1027, 0x0404, 1029, 1030];
        public static var DailyBookItemGuid:int;
        public static var DivineBaseTaskId:int = 3024;

        public static function Handler_CompleteTask(_arg1:int, _arg2:TaskInfoStruct):void{
            if ((((_arg2.taskType == QuestType.DAILY)) && ((_arg2.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                if (!(UIFacade.UIFacadeInstance.retrieveProxy(DataProxy.NAME) as DataProxy).TaskDailyBOokIsOpen){
                    UIFacade.UIFacadeInstance.sendNotification(EventList.SHOWTASKDAILYBOOK);
                };
            };
            if (((((((([NewGuideData.TASK_2, NewGuideData.TASK_8, NewGuideData.TASK_13, NewGuideData.TASK_14, NewGuideData.TASK_17, NewGuideData.TASK_EQUIPEXCHANGE].indexOf(_arg1) == -1)) && ((_arg2.taskType == QuestType.MAIN)))) && (!(MapManager.IsInFuben())))) && ((GameCommonData.Player.Role.Level < 30)))){
                UIFacade.UIFacadeInstance.sendNotification(TaskCommandList.AUTOPATH_TASK, _arg2);
            };
            if (NewGuideData.newerHelpIsOpen){
                UIFacade.UIFacadeInstance.sendNotification(Guide_TaskCommand.NAME, {
                    taskInfo:_arg2,
                    state:2
                });
            };
        }
        public static function IsNextMainTask(_arg1:int):void{
        }
        public static function get DBTodayCompleteCnt():int{
            return ((GameCommonData.activityData[44] % 10000));
        }
        public static function GetGuildQuestRewardStep(_arg1:uint):uint{
            var _local2:uint = 0;
            var _local3:uint = 7;
            while (_local3 > 0) {
                if (_arg1 >= GuildOfferStep[_local3]){
                    _local2 = _local3;
                    break;
                };
                _local3--;
            };
            return (_local2);
        }
        public static function AnalyzeTaskPathRandom(_arg1:XML):void{
            var _local2:XML;
            var _local3:Array;
            var _local4:String;
            var _local5:Array;
            var _local6:int;
            _taskPathPointdic = new Dictionary();
            for each (_local2 in _arg1.elements()) {
                _local3 = [];
                _local4 = String(_local2.@rp);
                _local5 = _local4.split("|");
                _local6 = 0;
                while (_local6 < _local5.length) {
                    _local3.push(_local5[_local6].split(","));
                    _local6++;
                };
                _taskPathPointdic[String(_local2.@id)] = _local3;
            };
        }
        public static function getQuestEventData(_arg1:String):Array{
            var _local3:Array;
            if (_arg1 == null){
                return (null);
            };
            var _local2:* = _arg1.replace(/\\fx/gi, "").match(/<a href="event:([^>]*)">/i);
            if (((_local2) && (_local2[1]))){
                _local3 = _local2[1].split(",");
                if (_local3.length == 5){
                    return (_local3);
                };
            };
            return (null);
        }
        public static function get MaxLoopIdx():int{
            if (GameCommonData.Player.Role.Level < 40){
                return (30);
            };
            if (GameCommonData.Player.Role.Level < 60){
                return (40);
            };
            if (GameCommonData.Player.Role.Level < 80){
                return (50);
            };
            return (60);
        }
        public static function checkMainTask():void{
            var i:* = 0;
//            with ({}) {
//                {}.loopFun = function (_arg1:TaskInfoStruct):TaskInfoStruct{
//                    var _local2:TaskInfoStruct;
//                    if (++i > 500){
//                        return (null);
//                    };
//                    if (_arg1.taskType == QuestType.MAIN){
//                        trace(_arg1.taskId);
//                        if (_arg1.taskId == 1306){
//                            _local2 = GameCommonData.TaskInfoDic[1307];
//                            trace("");
//                        };
//                        _arg1 = GameCommonData.TaskInfoDic[String(GetNextTask(_arg1.taskId))];
//                        if (((!((_arg1 == null))) && (!((_arg1.taskId == 0))))){
//                            return (loopFun(_arg1));
//                        };
//                    };
//                    return (null);
//                };
//            };//geoffyan
            var loopFun:* = function (_arg1:TaskInfoStruct):TaskInfoStruct{
                var _local2:TaskInfoStruct;
                if (++i > 500){
                    return (null);
                };
                if (_arg1.taskType == QuestType.MAIN){
                    trace(_arg1.taskId);
                    if (_arg1.taskId == 1306){
                        _local2 = GameCommonData.TaskInfoDic[1307];
                        trace("");
                    };
                    _arg1 = GameCommonData.TaskInfoDic[String(GetNextTask(_arg1.taskId))];
                    if (((!((_arg1 == null))) && (!((_arg1.taskId == 0))))){
                        return (loopFun(_arg1));
                    };
                };
                return (null);
            };
            var taskInfo:* = loopFun(GameCommonData.TaskInfoDic[1016]);
        }
        public static function getFollowTaskCount():int{
            var _local1:TaskInfoStruct;
            var _local2:int;
            for each (_local1 in GameCommonData.TaskInfoDic) {
                if (((_local1.IsAccept) && (_local1.isFollow))){
                    _local2++;
                };
            };
            return (_local2);
        }
        public static function GetRecBoundToFollowTree(_arg1:TaskText):Rectangle{
            if ((((_arg1 == null)) || ((_arg1.Tf == null)))){
                return (null);
            };
            var _local2:RegExp = /.*<a href="event:.*">(.*)<\/a>.*/gi;
            var _local3:String = _arg1.tfText.replace("\\fx", "").replace(_local2, "$1").replace(/<u>/gi, "").replace(/<\/u>/gi, "");
            var _local4:int = _arg1.Tf.text.indexOf(_local3);
            var _local5:Rectangle = _arg1.Tf.getCharBoundaries(_local4);
            if (_local5 == null){
                return (new Rectangle());
            };
            var _local6:Point = _arg1.Tf.parent.localToGlobal(new Point(_local5.x, _local5.y));
            var _local7:Rectangle = new Rectangle((_local6.x - 2), (_local6.y - 2), ((_local5.width * _local3.length) + 4), (_local5.height + 4));
            return (_local7);
        }
        public static function SetGuildQuestReward():void{
            var _local1:String;
            var _local2:TaskInfoStruct;
            var _local3:String;
            for (_local1 in GameCommonData.TaskInfoDic) {
                _local2 = GameCommonData.TaskInfoDic[_local1];
                if (_local2.IsGuildquest){
                    if (TaskCommonData.checkTaskIsCanAcc(_local2.taskId)){
                        for (_local3 in GameCommonData.SameSecnePlayerList) {
                            if ((((GameCommonData.SameSecnePlayerList[_local3].Role.Type == GameRole.TYPE_NPC)) && ((GameCommonData.SameSecnePlayerList[_local3].Role.Name == _local2.taskNPC)))){
                                TaskCommonData.setNpcState(GameCommonData.SameSecnePlayerList[_local3]);
                            };
                        };
                        UIFacade.GetInstance().sendNotification(TaskCommandList.ADD_ACCEPT_TASK, _local2.taskId);
                    };
                };
            };
        }
        public static function CheckTaskCanAccByNpc(_arg1:GameElementAnimal):Boolean{
            var _local2:String;
            var _local3:TaskInfoStruct;
            for (_local2 in GameCommonData.TaskInfoDic) {
                _local3 = GameCommonData.TaskInfoDic[_local2];
                if (_local3){
                    if (_arg1.Role.MonsterTypeID == _local3.taskNpcId){
                        if (checkTaskIsCanAcc(_local3.taskId)){
                            return (true);
                        };
                    };
                };
            };
            return (false);
        }
        public static function GetGuildQuestFactor(_arg1:uint):Number{
            var _local2:uint = GetGuildQuestRewardStep(GameCommonData.Player.Role.GuildBuildValue);
            var _local3:Number = 1;
            switch (_arg1){
                case GUILD_QUEST_REWARD_EXP:
                case GUILD_QUEST_REWARD_GOLD:
                    _local3 = Math.pow(1.3, _local2);
                    break;
                case GUILD_QUEST_REWARD_ITEM:
                    _local3 = (_local3 + _local2);
                    break;
            };
            return (_local3);
        }
        public static function checkTaskIsCanAcc(_arg1:int):Boolean{
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            if (((((((((_local2) && ((GameCommonData.Player.Role.Level >= _local2.minLevel)))) && ((GameCommonData.Player.Role.Level <= _local2.maxLevel)))) && (!(_local2.IsAccept)))) && ((TaskCommonData.CompleteTaskIdArray.indexOf(_local2.taskId) == -1)))){
                if ((((_local2.taskNPC == "")) && (!((((_local2.taskType == QuestType.DAILY)) && ((_local2.flags == TaskCommonData.QFLAGS_DAILYBOOK))))))){
                    return (false);
                };
                if (_local2.taskType == QuestType.LOOP){
                    if (GameCommonData.Player.Role.loopTaskIdx >= TaskCommonData.MaxLoopIdx){
                        return (false);
                    };
                    if (_local2.taskId != TaskCommonData.LoopBaseTaskId){
                        if (_local2.taskId == TaskCommonData.CurrentLoopTaskId){
                            return (true);
                        };
                        return (false);
                    };
                    if ((((_local2.taskId == TaskCommonData.LoopBaseTaskId)) && (!((TaskCommonData.CurrentLoopTaskId == TaskCommonData.LoopBaseTaskId))))){
                        return (false);
                    };
                };
                if (_local2.taskType == QuestType.DAILY){
                    if (_local2.flags == TaskCommonData.QFLAGS_SPECILDAILY){
                        if (TaskCommonData.SpecialDailyTaskCanAccList.indexOf(_local2.taskId) == -1){
                            return (false);
                        };
                    } else {
                        if (_local2.flags == TaskCommonData.QFLAGS_DAILYBOOK){
                            if (TaskCommonData.DBTodayCompleteCnt >= 10){
                                return (false);
                            };
                            if (TaskCommonData.CurrentDialyBookTaskId == _local2.taskId){
                                return (!(_local2.IsAccept));
                            };
                            if ((((((TaskCommonData.CurrentDialyBookTaskId == 0)) && ((_local2.taskId == 3200)))) && ((GameCommonData.Player.Role.Level >= 32)))){
                                return (true);
                            };
                            return (false);
                        };
                    };
                };
                if (_local2.requireJob > 0){
                    if (_local2.requireJob != GameCommonData.Player.Role.CurrentJobID){
                        return (false);
                    };
                };
                if (_local2.taskType == QuestType.ACTIVE){
                    if ((GameCommonData.activityData[(24 + (_local2.quality - 1))] % 10000) >= _local2.dailyTotalCnt){
                        return (false);
                    };
                    if ((((_local2.preTaskId > 0)) && ((_local2.preTaskId < 25)))){
                        if (GameCommonData.activityData[((24 + _local2.preTaskId) - 1)] < 10000){
                            return (false);
                        };
                    };
                };
                if (_local2.IsGuildquest){
                    if (GameCommonData.Player.Role.GuildBuildValue < 1000){
                        return (false);
                    };
                };
                if ((((_local2.preTaskId > 1000)) && ((TaskCommonData.CompleteTaskIdArray.indexOf(_local2.preTaskId) == -1)))){
                    return (false);
                };
                return (true);
            };
            return (false);
        }
        public static function setNpcState(_arg1:GameElementAnimal):int{
            var _local2:String;
            var _local3:TaskInfoStruct;
            if (_arg1 == null){
                return (0);
            };
            var _local4:int;
            for (_local2 in GameCommonData.TaskInfoDic) {
                _local3 = GameCommonData.TaskInfoDic[_local2];
                if (_local3){
                    if (_arg1.Role.MonsterTypeID == _local3.taskNpcId){
                        if (checkTaskIsCanAcc(_local3.taskId)){
                            _local4 = Math.max(1, _local4);
                        };
                    };
                    if (_arg1.Role.MonsterTypeID == _local3.taskCommitNpcId){
                        if (_local3.IsAccept){
                            if (_local3.IsComplete){
                                _local4 = Math.max(3, _local4);
                            } else {
                                _local4 = Math.max(2, _local4);
                            };
                        };
                    };
                };
            };
            _arg1.SetMissionPrompt(_local4);
            return (_local4);
        }
        public static function getNpcAndPoint(_arg1:String, _arg2:String):String{
            var _local5:String;
            var _local3:RegExp = /(<a href="event:).*(<\/a>)/g;
            var _local4:Array = _arg2.match(_local3);
            for each (_local5 in _local4) {
                if (_local5.indexOf(_arg1) != -1){
                    return (_local5);
                };
            };
            return ("");
        }
        public static function Handler_TaskAccept(_arg1:GameElementAnimal, _arg2:int, _arg3:TaskInfoStruct):void{
            var _local5:String;
            var _local6:TaskInfoStruct;
            if (_arg3.flags == TaskCommonData.QFLAGS_CONVOY){
                UIFacade.UIFacadeInstance.sendNotification(TaskCommandList.AUTOPATH_TASK, _arg3);
            };
            TaskShowMcManager.getInstance().show(TaskShowMcManager.TYPE_ACCEPTE);
            var _local4:Boolean;
            if (((_arg1) && (TaskCommonData.CheckTaskCanAccByNpc(_arg1)))){
                UIFacade.UIFacadeInstance.sendNotification(EventList.SELECTED_NPC_ELEMENT, {npcId:_arg1.Role.Id});
                _local4 = true;
            };
            if (((((_arg1) && ((_local4 == false)))) && (!((_arg2 == 1301))))){
                for (_local5 in GameCommonData.CurrentTaskList) {
                    _local6 = GameCommonData.CurrentTaskList[_local5];
                    if (((((_local6) && ((_local6.taskCommitNpcId == _arg1.Role.MonsterTypeID)))) && (_local6.IsComplete))){
                        UIFacade.UIFacadeInstance.sendNotification(EventList.SELECTED_NPC_ELEMENT, {npcId:_arg1.Role.Id});
                        _local4 = true;
                        break;
                    };
                };
            };
            UIFacade.UIFacadeInstance.sendNotification(HelpTipsNotiName.HELPTIPS_SHOW, {
                TYPE:"Task_0",
                VALUE:_arg3.taskId
            });
            if (NewGuideData.newerHelpIsOpen){
                UIFacade.UIFacadeInstance.sendNotification(Guide_TaskCommand.NAME, {
                    taskInfo:_arg3,
                    state:1
                });
            };
            if (_local4 == false){
                if ((((((((_arg3.taskId >= 1004)) && ((_arg3.taskId <= 1101)))) && (!((_arg3.taskId == 1006))))) && (!((_arg3.taskId == 1012))))){
                    UIFacade.UIFacadeInstance.sendNotification(TaskCommandList.AUTOPATH_TASK, _arg3);
                } else {
                    if ((((((_arg3.taskType == QuestType.MAIN)) && (_arg3.IsComplete))) && ((GameCommonData.Player.Role.Level < 30)))){
                        if (((((!((_arg3.taskId == NewGuideData.TASK_FLY))) && (!((_arg3.taskId == 1301))))) && (!((_arg3.taskId == 1700))))){
                            UIFacade.UIFacadeInstance.sendNotification(TaskCommandList.AUTOPATH_TASK, _arg3);
                        };
                    };
                };
            };
        }
        public static function GetPointFromFollowTree(_arg1:int=-1, _arg2:int=-1):TaskText{
            var _local3:TaskFollowTreeCellRenderer;
            var _local4:TaskFollowTreeCellRenderer;
            if (_arg2 == -1){
                _arg2 = NewGuideData.CurrentTaskId;
            };
            var _local5:Dictionary = (UIFacade.GetInstance().retrieveMediator(TaskFollowMediator.NAME) as TaskFollowMediator).NewGuidePoint_TaskTree_Cells;
            var _local6:* = _local5[_arg2];
            for each (_local4 in _local6) {
                if (_local4.id == _arg2){
                    if (_local4.data){
                        if (_arg1 != -1){
                            if (_local4.data.ConID == 0){
                                _local3 = _local4;
                            };
                            if (_local4.data.ConID == _arg1){
                                _local3 = _local4;
                                break;
                            };
                        };
                    } else {
                        _local3 = _local4;
                    };
                };
            };
            if (_local3 == null){
                return (null);
            };
            return (_local3.desTT);
        }
        public static function getNewGuideTaskPointWithFixed(_arg1:int):Point{
            var _local2:Array;
            var _local3:Array;
            var _local4:Point;
            if (newguideTaskPathPointDic == null){
                newguideTaskPathPointDic = new Dictionary();
            };
            if (newguideTaskPathPointDic[_arg1]){
                return (newguideTaskPathPointDic[_arg1]);
            };
            _local3 = taskPathPointdic[_arg1];
            if (_local3){
                _local2 = _local3[int((Math.random() * (_local3.length - 1)))];
                _local4 = new Point(_local2[0], _local2[1]);
                newguideTaskPathPointDic[_arg1] = _local4;
                return (_local4);
            };
            return (null);
        }
        public static function GetCurrentMaintTask():TaskInfoStruct{
            var i:* = 0;
//            with ({}) {
//                {}.loopFun = function (_arg1:TaskInfoStruct):TaskInfoStruct{
//                    if (++i > 500){
//                        return (null);
//                    };
//                    if (_arg1.taskType == QuestType.MAIN){
//                        if (_arg1.IsAccept){
//                            return (_arg1);
//                        };
//                        if (TaskCommonData.CompleteTaskIdArray.indexOf(_arg1.taskId) == -1){
//                            return (_arg1);
//                        };
//                        _arg1 = GameCommonData.TaskInfoDic[String(GetNextTask(_arg1.taskId))];
//                        if (((!((_arg1 == null))) && (!((_arg1.taskId == 0))))){
//                            return (loopFun(_arg1));
//                        };
//                    };
//                    return (null);
//                };
//            };//geoffyan
            var loopFun:* = function (_arg1:TaskInfoStruct):TaskInfoStruct{
                if (++i > 500){
                    return (null);
                };
                if (_arg1.taskType == QuestType.MAIN){
                    if (_arg1.IsAccept){
                        return (_arg1);
                    };
                    if (TaskCommonData.CompleteTaskIdArray.indexOf(_arg1.taskId) == -1){
                        return (_arg1);
                    };
                    _arg1 = GameCommonData.TaskInfoDic[String(GetNextTask(_arg1.taskId))];
                    if (((!((_arg1 == null))) && (!((_arg1.taskId == 0))))){
                        return (loopFun(_arg1));
                    };
                };
                return (null);
            };
            return (loopFun(GameCommonData.TaskInfoDic[1016]));
        }
        public static function get taskPathPointdic():Dictionary{
            return (_taskPathPointdic);
        }
        public static function checkHaveProgress(_arg1:int):Boolean{
            var _local3:QuestCondition;
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            var _local4:int;
            var _local5:int = _local2.Conditions.length;
            while (_local4 < _local5) {
                _local3 = _local2.Conditions[_local4];
                if (((((_local3) && ((_local3.Target > 0)))) && ((_local3.Current > 0)))){
                    return (true);
                };
                _local4++;
            };
            return (false);
        }
        public static function CreateDivineBaseTaskInfo(_arg1:TaskInfoStruct):void{
            _arg1.taskDes = TaskCommonData.DivineBaseTaskInfo.taskDes;
            _arg1.rewardExp = TaskCommonData.DivineBaseTaskInfo.rewardExp;
            _arg1.rewardGold = TaskCommonData.DivineBaseTaskInfo.rewardGold;
            _arg1.rewardPrestige = TaskCommonData.DivineBaseTaskInfo.rewardPrestige;
            _arg1.clearItemReward();
            _arg1.addItemReward(new QuestItemReward(50700019, 1, _arg1));
        }
        public static function GetNextTask(_arg1:int):int{
            var _local3:String;
            if (GameCommonData.TaskInfoDic[_arg1] == null){
                return (0);
            };
            var _local2:int = GameCommonData.TaskInfoDic[_arg1].taskType;
            for (_local3 in GameCommonData.TaskInfoDic) {
                if (((GameCommonData.TaskInfoDic[_local3]) && (((GameCommonData.TaskInfoDic[_local3] as TaskInfoStruct).preTaskId == _arg1)))){
                    if (_local2 == GameCommonData.TaskInfoDic[_local3].taskType){
                        return (int(_local3));
                    };
                };
            };
            return (0);
        }
        public static function CheckAllTaskFinish():void{
            var _local1:String;
            for (_local1 in GameCommonData.TaskInfoDic) {
                if (((GameCommonData.TaskInfoDic[_local1]) && (GameCommonData.TaskInfoDic[_local1].IsAccept))){
                    (GameCommonData.TaskInfoDic[_local1] as TaskInfoStruct).checkComplete();
                };
            };
        }
        public static function get DBFreeRefreshRemainCnt():int{
            return ((GameCommonData.activityData[45] % 10000));
        }
        public static function GetLoopQuestFactor(_arg1:int):Number{
            if (_arg1 > 30){
                return (1);
            };
            var _local2:Number = 1;
            var _local3:uint = ((_arg1 - 1) % 10);
            _local2 = (_local2 * Math.pow(1.05, int(((_local3 * (_local3 + 1)) / 2))));
            if (_arg1 <= 10){
                _local2 = (_local2 * 2);
            };
            return (_local2);
        }
        public static function UintChangeChinieseuin(_arg1:uint):String{
            var _local2 = "";
            switch (_arg1){
                case 1:
                    _local2 = LanguageMgr.GetTranslation("一");
                    break;
                case 2:
                    _local2 = LanguageMgr.GetTranslation("二");
                    break;
                case 3:
                    _local2 = LanguageMgr.GetTranslation("三");
                    break;
                case 4:
                    _local2 = LanguageMgr.GetTranslation("四");
                    break;
                case 5:
                    _local2 = LanguageMgr.GetTranslation("五");
                    break;
                case 6:
                    _local2 = LanguageMgr.GetTranslation("六");
                    break;
                case 7:
                    _local2 = LanguageMgr.GetTranslation("七");
                    break;
                case 8:
                    _local2 = LanguageMgr.GetTranslation("八");
                    break;
                case 9:
                    _local2 = LanguageMgr.GetTranslation("九");
                    break;
                case 10:
                    _local2 = LanguageMgr.GetTranslation("十");
                    break;
            };
            return (_local2);
        }
        public static function CreateLoopBaseTempTask():void{
            var _local1:TaskInfoStruct;
            _local1 = new TaskInfoStruct();
            _local1.taskId = TaskCommonData.LoopBaseTaskId;
            _local1.title = LanguageMgr.GetTranslation("职业试炼");
            _local1.objectives = LanguageMgr.GetTranslation("职业试炼");
            _local1.taskDes = LanguageMgr.GetTranslation("任务描述句来的");
            _local1.taskType = QuestType.LOOP;
            _local1.flags = TaskCommonData.LoopTaskCommitNpcArrTemp[GameCommonData.Player.Role.CurrentJobID];
            _local1.taskNPC = LanguageMgr.GetTranslation(("职业npc名" + GameCommonData.Player.Role.CurrentJobID.toString()));
            _local1.taskNpcId = TaskCommonData.LoopTaskCommitNpcArrTemp[GameCommonData.Player.Role.CurrentJobID];
            _local1.taskCommitNPC = _local1.taskNPC;
            _local1.taskCommitNpcId = 0;
            _local1.taskNPCAndPoint = LanguageMgr.GetTranslation(("职业npc位置" + GameCommonData.Player.Role.CurrentJobID.toString()));
            _local1.minLevel = 33;
            _local1.maxLevel = 100;
            _local1.limitTime = 0;
            _local1.preTaskId = 0;
            _local1.nextTaskId = 0;
            _local1.IsAccept = false;
            GameCommonData.TaskInfoDic[_local1.taskId] = _local1;
        }
        public static function getQuestEventDataByCon(_arg1:int, _arg2:int):Array{
            var _local3:TaskInfoStruct;
            var _local4:Array;
            _local3 = GameCommonData.TaskInfoDic[_arg1];
            _local3 = GameCommonData.TaskInfoDic[_arg1];
            if (((_local3) && (_local3.Conditions[_arg2]))){
                _local4 = getQuestEventData(_local3.Conditions[_arg2].description);
                return (_local4);
            };
            return (null);
        }
        public static function GetTaskConPath(_arg1:int, _arg2:int):Array{
            var _local5:Point;
            var _local3:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            var _local4:Array = [];
            _local4 = TaskCommonData.getQuestEventDataByCon(_arg1, _arg2);
            if (_local4.length >= 3){
                if (((((!((TaskCommonData.taskPathPointdic[TaskCommonData.CurrentMainTaskId] == null))) && (_local3.IsAccept))) && (!(_local3.IsComplete)))){
                    _local5 = TaskCommonData.getNewGuideTaskPointWithFixed(TaskCommonData.CurrentMainTaskId);
                    if (_local5){
                        _local4[1] = _local5.x;
                        _local4[2] = _local5.y;
                    };
                };
            };
            return (_local4);
        }
        public static function get CurrentLoopTaskId():int{
            var _local1:int = GameCommonData.activityData[23];
            if (GameCommonData.TaskInfoDic[_local1]){
                return (_local1);
            };
            return (LoopBaseTaskId);
        }
        public static function Handler_RemoveTask(_arg1:int, _arg2:Boolean, _arg3:TaskInfoStruct, _arg4:GameElementAnimal):void{
            var hasNextMainTaskCanAcc:* = false;
            var nextTaskInfo:* = null;
            var remainConvoyCnt:* = 0;
            var nextTaskAccNpc:* = null;
            var idx:* = null;
            var checkTaskInfo:* = null;
            var taskId:* = _arg1;
            var taskResult:* = _arg2;
            var taskInfo:* = _arg3;
            var taskCommitNpc:* = _arg4;
            var nextTaskId:* = TaskCommonData.GetNextTask(taskId);
            if (taskResult){
                hasNextMainTaskCanAcc = false;
                nextTaskInfo = GameCommonData.TaskInfoDic[nextTaskId];
                if (nextTaskInfo){
                    nextTaskAccNpc = DialogConstData.getInstance().getNpcByMonsterId(nextTaskInfo.taskNpcId);
                    if (nextTaskAccNpc){
                        TaskCommonData.setNpcState(nextTaskAccNpc);
                    };
                };
                if ((((((((taskInfo.taskType == QuestType.MAIN)) && (nextTaskInfo))) && ((nextTaskInfo.taskType == QuestType.MAIN)))) && (!(nextTaskInfo.IsComplete)))){
                    if (((((((((((((taskCommitNpc) && ((taskCommitNpc.Role.Id == (UIFacade.UIFacadeInstance.retrieveMediator(NPCChatMediator.NAME) as NPCChatMediator).npcId)))) && ((taskInfo.taskId == (UIFacade.UIFacadeInstance.retrieveMediator(NPCChatMediator.NAME) as NPCChatMediator).taskId)))) && ((GameCommonData.Player.Role.Level >= nextTaskInfo.minLevel)))) && ((GameCommonData.Player.Role.Level <= nextTaskInfo.maxLevel)))) && ((taskCommitNpc.Role.Name == nextTaskInfo.taskNPC)))) && (!((taskInfo.nextTaskId == nextTaskId))))){
                        if (Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - taskCommitNpc.Role.TileX), 2) + Math.pow((GameCommonData.Player.Role.TileY - taskCommitNpc.Role.TileY), 2))) <= 10){
                            UIFacade.UIFacadeInstance.sendNotification(TaskCommandList.RECEIVE_TASK, {
                                npcId:taskCommitNpc.Role.Id,
                                npcName:taskCommitNpc.Role.Name,
                                taskId:nextTaskId
                            });
                            hasNextMainTaskCanAcc = true;
                        };
                    };
                };
                if ((((hasNextMainTaskCanAcc == false)) && (taskCommitNpc))){
                    for (idx in GameCommonData.CurrentTaskList) {
                        checkTaskInfo = GameCommonData.CurrentTaskList[idx];
                        if (((((checkTaskInfo) && ((checkTaskInfo.taskCommitNpcId == taskCommitNpc.Role.MonsterTypeID)))) && (checkTaskInfo.IsComplete))){
                            UIFacade.UIFacadeInstance.sendNotification(EventList.SELECTED_NPC_ELEMENT, {npcId:taskCommitNpc.Role.Id});
                            break;
                        };
                    };
                };
                remainConvoyCnt = (3 - (GameCommonData.activityData[34] % 10000));
                if ((((taskInfo.flags == TaskCommonData.QFLAGS_CONVOY)) && ((remainConvoyCnt > 0)))){
                    UIFacade.UIFacadeInstance.sendNotification(EventList.SHOWALERT, {
                        comfrim:function ():void{
                            MoveToCommon.FlyTo(1005, 167, 121, 0, 1018, true);
                        },
                        isShowClose:true,
                        comfirmTxt:LanguageMgr.GetTranslation("继续护送"),
                        title:LanguageMgr.GetTranslation("提示"),
                        autoCloseTime:10,
                        info:(("<font color='#00FF00'>" + LanguageMgr.GetTranslation("你还有x次护送机会", remainConvoyCnt)) + "？</font>")
                    });
                };
                UIFacade.UIFacadeInstance.sendNotification(HelpTipsNotiName.HELPTIPS_SHOW, {
                    TYPE:"Task_1",
                    VALUE:taskInfo.taskId
                });
                if (NewGuideData.newerHelpIsOpen){
                    UIFacade.UIFacadeInstance.sendNotification(Guide_TaskCommand.NAME, {
                        taskInfo:taskInfo,
                        state:3
                    });
                };
            };
        }

    }
}//package GameUI.Modules.Task.Model 
