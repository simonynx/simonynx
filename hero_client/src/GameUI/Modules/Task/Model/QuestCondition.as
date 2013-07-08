//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {
    import GameUI.UICore.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class QuestCondition {

        private var _parm1:int;
        private var _parm2:int;
        private var _onlineTime_ResultTime:Number;
        private var _type:int;
        private var _questId:int;
        private var _current:int;
        private var _description:String;
        private var _conId:int;

        public function QuestCondition(_arg1:int, _arg2:int, _arg3:int=0, _arg4:String="", _arg5:int=0, _arg6:int=0){
            this._questId = _arg1;
            this._conId = _arg2;
            this._description = _arg4;
            this._type = _arg3;
            this._parm1 = _arg5;
            this._parm2 = _arg6;
        }
        public function get Target():int{
            return (_parm2);
        }
        public function get type():int{
            return (_type);
        }
        public function get description():String{
            if (_description == "0"){
                return ("");
            };
            return (_description);
        }
        public function get ConID():int{
            return (_conId);
        }
        public function get parm1():int{
            return (_parm1);
        }
        public function set OnlineTime_ResultTime(_arg1:Number):void{
            this._onlineTime_ResultTime = _arg1;
        }
        public function get QuestID():int{
            return (_questId);
        }
        public function setConComplete():void{
            _current = _parm2;
        }
        public function get IsValid():Boolean{
            if (description == ""){
                return (false);
            };
            return (true);
        }
        public function get ProcessStr():String{
            var _local1:String;
            if (_parm2 == 0){
                return ("");
            };
            switch (_type){
                case QuestConditionType.QUEST_FLAG_CHOOSECARRER:
                case QuestConditionType.QUEST_FLAG_ENTERUNDERCITY:
                    _local1 = "";
                    break;
                default:
                    _local1 = (((("(" + _current) + "/") + _parm2) + ")");
            };
            return (_local1);
        }
        public function get IsComplete():Boolean{
            var _local1:int;
            switch (_type){
                case QuestConditionType.QUEST_FLAG_COLLECT:
                case QuestConditionType.QUEST_FLAG_GETITEM:
                    _local1 = BagData.getCountsByTemplateId(_parm1, false);
                    if (_local1 != _current){
                        _current = _local1;
                        UIFacade.GetInstance().sendNotification(TaskCommandList.UPDATE_TASK_PROCESS, {
                            id:_questId,
                            conId:_conId,
                            dataArr:[_current, _parm2]
                        });
                    };
                    break;
                case QuestConditionType.QUEST_FLAG_COLLECT_NEW:
                    _local1 = BagData.getCountsByTemplateId(_parm1, true);
                    if (_local1 != _current){
                        _current = _local1;
                        UIFacade.GetInstance().sendNotification(TaskCommandList.UPDATE_TASK_PROCESS, {
                            id:_questId,
                            conId:_conId,
                            dataArr:[_current, _parm2]
                        });
                    };
                    break;
            };
            if (_current >= _parm2){
                return (true);
            };
            return (false);
        }
        public function get Current():int{
            return (_current);
        }
        public function get OnlineTime_ResultTime():Number{
            return (this._onlineTime_ResultTime);
        }
        public function setProcess(_arg1:int, _arg2:int):void{
            this._current = _arg1;
            this._parm2 = _arg2;
        }
        public function clearProcess():void{
            this._current = 0;
        }
        public function set description(_arg1:String):void{
            this._description = _arg1;
        }

    }
}//package GameUI.Modules.Task.Model 
