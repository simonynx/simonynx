//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View.TaskFollow {
    import flash.events.*;
    import flash.utils.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;

    public class TaskFollowTree extends UISprite {

        private var groupCellDic:Dictionary;
        protected var padding:uint = 30;
        private var cellsDic:Dictionary;
        private var _dataProvider:Array;

        public function TaskFollowTree(){
            cellsDic = new Dictionary();
            groupCellDic = new Dictionary();
            this._dataProvider = [];
            this.width = 220;
        }
        public function addTask(_arg1:int):void{
            var _local3:Dictionary;
            var _local4:TaskGroupStruct;
            var _local5:QuestCondition;
            var _local6:int;
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            _local3 = new Dictionary();
            for each (_local5 in _local2.Conditions) {
                if (_local5.IsValid){
                    _local3[_local5.ConID] = {
                        id:_local2.taskId,
                        isSelected:false,
                        data:_local5
                    };
                };
            };
            _local4 = new TaskGroupStruct(_local3, true, _local2.taskId);
            _local4.des = _local2.title;
            _local6 = 0;
            while (_local6 < this.dataProvider.length) {
                if ((this.dataProvider[_local6] as TaskGroupStruct).taskType == _local2.taskId){
                    this.dataProvider.splice(_local6, 1);
                };
                _local6++;
            };
            var _local7:int;
            while (_local7 < this.dataProvider.length) {
                if (((GameCommonData.TaskInfoDic[this.dataProvider[_local7].taskType]) && (!((GameCommonData.TaskInfoDic[this.dataProvider[_local7].taskType].taskType == QuestType.MAIN))))){
                    break;
                };
                _local7++;
            };
            if (_local2.taskType == QuestType.MAIN){
                _local6 = 0;
                while (_local6 < this.dataProvider.length) {
                    if (((GameCommonData.TaskInfoDic[this.dataProvider[_local6].taskType]) && ((_local2.taskId < GameCommonData.TaskInfoDic[this.dataProvider[_local6].taskType].taskId)))){
                        break;
                    };
                    _local6++;
                };
                this.dataProvider.splice(_local6, 0, _local4);
            } else {
                this.dataProvider.splice(_local7, 0, _local4);
            };
            var _local8:* = this.getGroupCell(_local4);
            this.addChild(_local8);
            createCell(_local4);
            doLayout();
        }
        protected function getGroupCell(_arg1:TaskGroupStruct):TaskFollowGroupCellRender{
            if (this.groupCellDic[_arg1.taskType]){
                this.groupCellDic[_arg1.taskType].dispose();
                delete this.groupCellDic[_arg1.taskType];
            };
            var _local2:TaskFollowGroupCellRender = new TaskFollowGroupCellRender(_arg1);
            _local2.addEventListener(MouseEvent.CLICK, onClickTaskGroup);
            this.groupCellDic[_arg1.taskType] = _local2;
            return (_local2);
        }
        public function get CellsDic():Dictionary{
            return (this.cellsDic);
        }
        protected function toRepaint():void{
            this.removeAll();
            this.createCells();
        }
        public function doLayout():void{
            var _local1:int;
            var _local2:TaskGroupStruct;
            var _local4:TaskFollowGroupCellRender;
            var _local5:TaskFollowTreeCellRenderer;
            var _local6:int;
            var _local3:int;
            for each (_local2 in this.dataProvider) {
                _local1 = _local2.taskType;
                _local4 = groupCellDic[_local1];
                _local4.y = (_local3 + 5);
                _local3 = (_local3 + (_local4.height + 3));
                _local6 = 0;
                while (_local6 < cellsDic[_local1].length) {
                    _local5 = cellsDic[_local1][_local6];
                    if (_local2.isExpand){
                        _local5.y = _local3;
                        _local5.x = padding;
                        _local3 = (_local3 + (_local5.height - 5));
                        _local5.visible = true;
                    } else {
                        _local5.visible = false;
                    };
                    _local6++;
                };
            };
            this.height = (_local3 + 5);
        }
        protected function onClickTaskGroup(_arg1:MouseEvent):void{
            var _local3:TaskGroupStruct;
            var _local2:TaskFollowGroupCellRender = (_arg1.currentTarget as TaskFollowGroupCellRender);
            if (_local2){
                _local3 = _local2.info;
                _local3.isExpand = !(_local3.isExpand);
                _local2.isExpand = _local3.isExpand;
                doLayout();
            };
        }
        public function FindGroupCellById(_arg1:int):TaskFollowGroupCellRender{
            return (groupCellDic[_arg1]);
        }
        public function refresh():void{
            this.toRepaint();
        }
        public function hasSameTaskType(_arg1:int):Boolean{
            var _local2:TaskGroupStruct;
            var _local3:int;
            while (_local3 < this.dataProvider.length) {
                _local2 = this.dataProvider[_local3];
                if (((_local2) && ((GameCommonData.TaskInfoDic[_local2.taskType].taskType == _arg1)))){
                    return (true);
                };
                _local3++;
            };
            return (false);
        }
        public function updateTaskProcess(_arg1):void{
            if (groupCellDic[_arg1]){
                groupCellDic[_arg1].Update();
                createCell(groupCellDic[_arg1].info);
                doLayout();
            };
        }
        public function removeTask(_arg1:uint):void{
            var _local2:TaskGroupStruct;
            var _local3:int;
            for each (_local2 in this.dataProvider) {
                if (_local2.taskType == _arg1){
                    this.dataProvider.splice(this.dataProvider.indexOf(_local2), 1);
                };
            };
            if (groupCellDic[_arg1]){
                groupCellDic[_arg1].dispose();
                delete groupCellDic[_arg1];
            };
            if (cellsDic[_arg1]){
                while (_local3 < cellsDic[_arg1].length) {
                    cellsDic[_arg1][_local3].dispose();
                    cellsDic[_arg1][_local3] = null;
                    _local3++;
                };
                cellsDic[_arg1] = null;
                delete cellsDic[_arg1];
            };
            doLayout();
        }
        public function FindCellRendererById(_arg1:int):Array{
            return (cellsDic[_arg1]);
        }
        protected function createCells():void{
            var _local1:TaskGroupStruct;
            var _local2:TaskFollowGroupCellRender;
            var _local3:Object;
            var _local4:TaskFollowTreeCellRenderer;
            var _local5:Number;
            var _local7:int;
            if ((((this.dataProvider == null)) || ((this.dataProvider.length == 0)))){
                return;
            };
            _local5 = 0;
            var _local6:Array = [];
            for each (_local1 in this.dataProvider) {
                _local7 = _local1.taskType;
                _local2 = this.getGroupCell(_local1);
                this.addChild(_local2);
                _local2.y = (_local5 + 5);
                _local5 = (_local5 + (_local2.height + 3));
                if (_local1.isExpand){
                    if (((GameCommonData.TaskInfoDic[_local7].IsComplete) || (!(GameCommonData.TaskInfoDic[_local7].IsAccept)))){
                        _local4 = new TaskFollowTreeCellRenderer(_local1.taskType);
                        addChild(_local4);
                        _local4.y = _local5;
                        _local4.x = padding;
                        _local5 = (_local5 + (_local4.height - 5));
                    } else {
                        for each (_local3 in _local1.taskDic) {
                            _local4 = new TaskFollowTreeCellRenderer(_local3.id, _local3.isSelected, _local3.data);
                            addChild(_local4);
                            _local4.y = _local5;
                            _local4.x = padding;
                            _local5 = (_local5 + (_local4.height - 5));
                        };
                    };
                };
            };
            this.height = (_local5 + 5);
        }
        public function set dataProvider(_arg1:Array):void{
            this._dataProvider = _arg1;
            this.toRepaint();
        }
        public function get dataProvider():Array{
            return (this._dataProvider);
        }
        protected function removeAll():void{
            while (this.numChildren > 1) {
                this.removeChildAt(1);
            };
            this.cellsDic = new Dictionary();
            this.groupCellDic = new Dictionary();
        }
        protected function createCell(_arg1:TaskGroupStruct):void{
            var _local3:TaskFollowTreeCellRenderer;
            var _local4:int;
            var _local5:Object;
            var _local2:* = _arg1.taskType;
            if (cellsDic[_local2]){
                while (_local4 < cellsDic[_local2].length) {
                    cellsDic[_local2][_local4].dispose();
                    cellsDic[_local2][_local4] = null;
                    _local4++;
                };
                delete cellsDic[_local2];
            };
            cellsDic[_local2] = [];
            if (((GameCommonData.TaskInfoDic[_local2].IsComplete) || (!(GameCommonData.TaskInfoDic[_local2].IsAccept)))){
                _local3 = new TaskFollowTreeCellRenderer(_arg1.taskType);
                cellsDic[_local2].push(_local3);
                addChild(_local3);
            } else {
                for each (_local5 in _arg1.taskDic) {
                    _local3 = new TaskFollowTreeCellRenderer(_local5.id, _local5.isSelected, _local5.data);
                    cellsDic[_local2].push(_local3);
                    addChild(_local3);
                };
            };
        }

    }
}//package GameUI.Modules.Task.View.TaskFollow 
