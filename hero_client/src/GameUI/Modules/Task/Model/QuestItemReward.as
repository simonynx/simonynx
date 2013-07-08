//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {

    public class QuestItemReward {

        private var _count:int;
        private var _taskInfo:TaskInfoStruct;
        private var _itemID:int;

        public function QuestItemReward(_arg1:int, _arg2:int, _arg3:TaskInfoStruct=null){
            this._itemID = _arg1;
            this._count = _arg2;
            this._taskInfo = _arg3;
        }
        public function set Count(_arg1:int):void{
            this._count = _arg1;
        }
        public function get ItemId():int{
            return (_itemID);
        }
        public function get Count():int{
            var _local1:int = _count;
            if (((_taskInfo) && (_taskInfo.IsGuildquest))){
                _local1 = TaskCommonData.GetGuildQuestFactor(TaskCommonData.GUILD_QUEST_REWARD_ITEM);
            };
            return (_local1);
        }

    }
}//package GameUI.Modules.Task.Model 
