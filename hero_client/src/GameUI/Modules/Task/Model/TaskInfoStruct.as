//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {
    import flash.utils.*;
    import Manager.*;
    import Utils.*;
    import GameUI.Modules.Convoy.Data.*;

    public class TaskInfoStruct {

        public var preTaskId:uint;
        public var finishTime:uint;
        private var _status:uint;
        public var requireJob:uint;
        public var storyCount:int;
        public var taskNPC:String;
        public var taskCommitNpcId:uint;
        public var taskCommitNPC:String;
        public var limitTime:uint;
        public var taskUnFinish:String;
        public var taskNPCAndPoint:String;
        public var taskCommitNPCAndPoint:String;
        private var _isAccept:Boolean;
        public var taskDes:String;
        public var minLevel:uint;
        public var nextTaskId:uint;
        public var loopTaskFlag:Boolean;
        public var taskNpcId:uint;
        private var _title:String;
        public var objectives:String;
        public var taskProcessFinish:String;
        private var _conditions:Array;
        public var taskType:uint;
        private var _itemRewardsOptionals:Array;
        public var rewardJobPrestige:uint;
        public var isFollow:Boolean;
        public var taskFinish:String;
        public var taskId:uint;
        public var flags:uint;
        public var maxLevel:uint;
        public var requiredGold:uint;
        public var IsCareerItemReward:Boolean;
        private var _rewardPrestige:uint;
        public var taskArea:String;
        public var dailyTotalCnt:int;
        private var _rewardGold:uint;
        private var _itemRewards:Array;
        public var receiveGold:uint;
        private var _rewardExp:uint;
        public var quality:uint;

        public function TaskInfoStruct(){
            _itemRewards = [];
            _itemRewardsOptionals = [];
            _conditions = [];
        }
        public function addItemRewardOptional(_arg1:QuestItemReward):void{
            _itemRewardsOptionals.push(_arg1);
        }
        public function set rewardPrestige(_arg1:uint):void{
            _rewardPrestige = _arg1;
        }
        public function get rewardGold():uint{
            var _local1:uint = _rewardGold;
            if (IsGuildquest){
                _local1 = (_rewardGold * TaskCommonData.GetGuildQuestFactor(TaskCommonData.GUILD_QUEST_REWARD_GOLD));
            } else {
                if (flags == 1){
                    _local1 = (_rewardGold * ConvoyData.ConvoyTimes[GameCommonData.ConvoyQuality]);
                };
            };
            return (_local1);
        }
        public function clearItemReward():void{
            _itemRewards = [];
        }
        public function get title():String{
            var _local1:String = _title;
            if (IsGuildquest){
                _local1 = (_title + LanguageMgr.GetTranslation("公会任务第几阶", TaskCommonData.UintChangeChinieseuin((TaskCommonData.GetGuildQuestRewardStep(GameCommonData.Player.Role.GuildBuildValue) + 1))));
            };
            return (_local1);
        }
        public function setTaskComplete():void{
            var _local1:int;
            while (_local1 < _conditions.length) {
                (_conditions[_local1] as QuestCondition).setConComplete();
                _local1++;
            };
        }
        public function checkComplete():void{
            var _local1:QuestCondition;
            for each (_local1 in _conditions) {
                ((_local1) && (_local1.IsComplete));
            };
        }
        public function set rewardGold(_arg1:uint):void{
            _rewardGold = _arg1;
        }
        public function clearProcess():void{
            var _local1:QuestCondition;
            var _local2:int;
            _local2 = 0;
            while (_local2 < _conditions.length) {
                _local1 = _conditions[_local2];
                _local1.clearProcess();
                _local2++;
            };
        }
        public function getConditionDes():String{
            var _local1:QuestCondition;
            var _local3:int;
            var _local4:uint;
            var _local2 = "";
            for each (_local1 in _conditions) {
                if (((_local1) && (!((_local1.description == ""))))){
                    switch (_local1.type){
                        case QuestConditionType.QUEST_FLAG_ONLINE:
                            _local4 = ((_local1.OnlineTime_ResultTime - TimeManager.Instance.Now().time) / 1000);
                            ++_local3;
                            _local2 = (_local2 + (((("" + _local3) + "：") + LanguageMgr.GetTranslation("任务剩余时间", uint((_local4 / 3600)), uint(((_local4 % 3600) / 60)), uint((_local4 % 60)))) + "<br>"));
                            break;
                        default:
                            ++_local3;
                            _local2 = (_local2 + ((((("" + _local3) + "：") + _local1.description) + _local1.ProcessStr) + "<br>"));
                    };
                };
            };
            return (_local2);
        }
        public function get rewardExp():uint{
            var _local2:Array;
            var _local1:uint = _rewardExp;
            if (IsGuildquest){
                _local1 = (_rewardExp * TaskCommonData.GetGuildQuestFactor(TaskCommonData.GUILD_QUEST_REWARD_EXP));
            } else {
                if (this.flags == TaskCommonData.QFLAGS_MAYOR){
                    _local1 = (((GameCommonData.Player.Role.Level * 4) * 1040) * 0.6);
                } else {
                    if (flags == 1){
                        _local1 = (_rewardExp * ConvoyData.ConvoyTimes[GameCommonData.ConvoyQuality]);
                        if ((GameCommonData.activityFlags & 32) != 0){
                            _local1 = (2 * _local1);
                        };
                        if (GameCommonData.activityNight){
                            _local1 = (1.2 * _local1);
                        };
                    } else {
                        if ((((taskType == QuestType.DAILY)) && ((this.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                            _local2 = [1, 1.5, 2, 2.3, 2.5];
                            _local1 = (_rewardExp * _local2[TaskCommonData.CurrentDialyBookQuality]);
                        };
                    };
                };
            };
            return (_local1);
        }
        public function get ItemRewards():Array{
            if ((((taskType == QuestType.DAILY)) && ((this.flags == TaskCommonData.QFLAGS_DAILYBOOK)))){
                clearItemReward();
                if ((((TaskCommonData.CurrentDialyBookTaskId == this.taskId)) && ((TaskCommonData.CurrentDialyBookQuality >= 2)))){
                    _itemRewards.push(new QuestItemReward(50800001, TaskCommonData.CurrentDialyBookQuality, this));
                };
            };
            return (_itemRewards);
        }
        public function get OriExp():uint{
            return (_rewardExp);
        }
        public function addCondition(_arg1:QuestCondition):void{
            _conditions.push(_arg1);
        }
        public function clearItemRewardOptionals():void{
            _itemRewardsOptionals = [];
        }
        public function get taskTypeName():String{
            return (QuestType.GetTypeName(taskType));
        }
        public function get rewardPrestige():uint{
            var _local1:uint = _rewardPrestige;
            if (IsGuildquest){
                _local1 = (_rewardPrestige * TaskCommonData.GetGuildQuestFactor(TaskCommonData.GUILD_QUEST_REWARD_GOLD));
            };
            return (_local1);
        }
        public function get ItemRewardsOptionals():Array{
            return (_itemRewardsOptionals);
        }
        public function get IsComplete():Boolean{
            var _local1:QuestCondition;
            if ((((taskType == QuestType.MAIN)) && (!((TaskCommonData.CompleteTaskIdArray.indexOf(this.taskId) == -1))))){
                return (true);
            };
            if (!IsAccept){
                return (false);
            };
            for each (_local1 in _conditions) {
                if (((_local1) && (!(_local1.IsComplete)))){
                    return (false);
                };
            };
            if (this.finishTime > 0){
                if ((this.finishTime - (TimeManager.Instance.Now().time / 1000)) <= 0){
                    return (false);
                };
            };
            return (true);
        }
        public function set title(_arg1:String):void{
            _title = _arg1;
        }
        public function addItemReward(_arg1:QuestItemReward):void{
            _itemRewards.push(_arg1);
        }
        public function get IsGuildquest():Boolean{
            return ((this.flags == TaskCommonData.QFLAGS_GUILD));
        }
        public function get Conditions():Array{
            return (_conditions);
        }
        public function set rewardExp(_arg1:uint):void{
            _rewardExp = _arg1;
        }
        public function set IsAccept(_arg1:Boolean):void{
            _isAccept = _arg1;
        }
        public function ReadFromNetPacket(_arg1:ByteArray):void{
            var _local2:QuestItemReward;
            var _local3:int;
            var _local4:int;
            var _local6:uint;
            var _local7:uint;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:String;
            this.taskId = _arg1.readUnsignedInt();
            this.title = UIUtils.ReadString(_arg1);
            this.objectives = UIUtils.ReadString(_arg1);
            this.taskDes = UIUtils.ReadString(_arg1);
            this.taskProcessFinish = UIUtils.ReadString(_arg1);
            this.taskFinish = UIUtils.ReadString(_arg1);
            this.taskUnFinish = UIUtils.ReadString(_arg1);
            this.taskType = _arg1.readUnsignedInt();
            this.flags = _arg1.readUnsignedInt();
            this.quality = _arg1.readUnsignedInt();
            this.taskNpcId = _arg1.readUnsignedInt();
            this.taskNPC = UIUtils.ReadString(_arg1);
            this.taskCommitNpcId = _arg1.readUnsignedInt();
            this.taskCommitNPC = UIUtils.ReadString(_arg1);
            this.taskNPCAndPoint = UIUtils.ReadString(_arg1);
            this.minLevel = _arg1.readUnsignedInt();
            this.maxLevel = _arg1.readUnsignedInt();
            this.requireJob = _arg1.readUnsignedInt();
            this.limitTime = _arg1.readUnsignedInt();
            this.preTaskId = _arg1.readUnsignedInt();
            this.nextTaskId = _arg1.readUnsignedInt();
            this.rewardGold = _arg1.readUnsignedInt();
            this.rewardExp = _arg1.readUnsignedInt();
            var _local5:uint;
            _local5 = 0;
            while (_local5 < 3) {
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                if (((_local3) && ((_local4 > 0)))){
                    _local2 = new QuestItemReward(_local3, _local4, this);
                    this.addItemReward(_local2);
                };
                _local5++;
            };
            _local5 = 0;
            while (_local5 < 5) {
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                if (((_local3) && ((_local4 > 0)))){
                    _local2 = new QuestItemReward(_local3, _local4, this);
                    this.addItemRewardOptional(_local2);
                };
                _local5++;
            };
            _local5 = 0;
            while (_local5 < 2) {
                _local6 = _arg1.readUnsignedInt();
                _local7 = _arg1.readUnsignedInt();
                if ((((_local6 >= 1)) && ((_local6 <= 5)))){
                } else {
                    if (_local6 == 6){
                        rewardPrestige = _local7;
                    };
                };
                _local5++;
            };
            _local5 = 0;
            while (_local5 < 2) {
                _local8 = _arg1.readUnsignedInt();
                _local9 = _arg1.readUnsignedInt();
                if (_local8 == 1){
                    receiveGold = _local9;
                };
                _local5++;
            };
            _local5 = 0;
            while (_local5 < 1) {
                _arg1.readUnsignedInt();
                _arg1.readUnsignedInt();
                _local5++;
            };
            this.requiredGold = _arg1.readUnsignedInt();
            _local5 = 0;
            while (_local5 < 3) {
                _local10 = _arg1.readUnsignedInt();
                _local11 = _arg1.readUnsignedInt();
                _local12 = _arg1.readUnsignedInt();
                _local13 = UIUtils.ReadString(_arg1);
                addCondition(new QuestCondition(this.taskId, _local5, _local10, _local13, _local11, _local12));
                _local5++;
            };
            dailyTotalCnt = _arg1.readUnsignedInt();
            this.taskDes = this.taskDes.replace(/\n/g, "<BR>");
            taskCommitNPCAndPoint = TaskCommonData.getNpcAndPoint(this.taskCommitNPC, this.taskProcessFinish);
            if (taskCommitNPCAndPoint == ""){
                taskCommitNPCAndPoint = taskCommitNPC;
            };
        }
        public function get status():uint{
            if (!IsAccept){
                return (0);
            };
            if (!IsComplete){
                return (1);
            };
            return (2);
        }
        public function get IsAccept():Boolean{
            return (_isAccept);
        }

    }
}//package GameUI.Modules.Task.Model 
