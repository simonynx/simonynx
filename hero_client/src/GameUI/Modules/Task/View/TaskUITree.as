//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.events.*;
    import flash.utils.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;
    import GameUI.Modules.Task.Commamd.*;

    public class TaskUITree extends UISprite {

        private var groupCell:Dictionary;
        protected var noTaskTextField:TaskText;
        private var _selectedID:uint;
        private var cells:Dictionary;
        private var _dataProvider:Array;
        protected var padding:uint = 23;

        public function TaskUITree(_arg1:Array=null){
            cells = new Dictionary();
            groupCell = new Dictionary();
            this._dataProvider = _arg1;
            if (this._dataProvider == null){
                this._dataProvider = [];
            };
            this.width = 196;
        }
        public function searchGroupByDes(_arg1:uint, _arg2:Array):TaskGroupStruct{
            var _local3:TaskGroupStruct;
            for each (_local3 in _arg2) {
                if (_local3.taskType == _arg1){
                    return (_local3);
                };
            };
            return (null);
        }
        public function get selectedID():uint{
            return (_selectedID);
        }
        public function addTask(_arg1:TaskInfoStruct):void{
            var _local2:Dictionary;
            var _local5:TreeCellRenderer;
            var _local6:int;
            var _local7:int;
            var _local3:TaskGroupStruct = this.searchGroupByDes(_arg1.taskType, this.dataProvider);
            if (_local3){
                _local3.taskDic[_arg1.taskId] = {
                    id:_arg1.taskId,
                    isSelected:false,
                    data:null
                };
            } else {
                _local2 = new Dictionary();
                _local2[_arg1.taskId] = {
                    id:_arg1.taskId,
                    isSelected:false,
                    data:null
                };
                _local3 = new TaskGroupStruct(_local2, true, _arg1.taskType);
                _local6 = 0;
                _local7 = this.dataProvider.length;
                _local6 = 0;
                while (_local6 < _local7) {
                    if (_local3.taskType < this.dataProvider[_local6].taskType){
                        this.dataProvider.splice(_local6, 0, _local3);
                        break;
                    };
                    _local6++;
                };
                if (_local7 == this.dataProvider.length){
                    this.dataProvider.push(_local3);
                };
            };
            var _local4:TaskGroupCellRenderer = this.getGroupCell(_local3);
            this.addChild(_local4);
            _local5 = this.getCell(_local3.taskDic[_arg1.taskId].id, _local3.taskDic[_arg1.taskId].isSelected, _local3.taskDic[_arg1.taskId].data);
            _local5.addEventListener(MouseEvent.CLICK, onSelectedTaskCell);
            this.addChild(_local5);
            doLayout();
        }
        protected function onSelectedTaskCell(_arg1:MouseEvent):void{
            var _local2:Object = this.searchObjById(_arg1.currentTarget.id);
            if (_local2 == null){
                return;
            };
            this.selectedID = _local2.id;
            this.dispatchEvent(new TreeEvent(TreeEvent.CHANGE_SELECTED, this.selectedID, false, false));
        }
        protected function getGroupCell(_arg1:TaskGroupStruct):TaskGroupCellRenderer{
            var _local2:String;
            var _local3:TaskGroupCellRenderer;
            for (_local2 in groupCell) {
                if ((groupCell[_local2] as TaskGroupCellRenderer).taskType == _arg1.taskType){
                    return (groupCell[_local2]);
                };
            };
            _local3 = new TaskGroupCellRenderer(_arg1);
            _local3.addEventListener(MouseEvent.CLICK, onClickTaskGroup);
            this.groupCell[_arg1.taskType] = _local3;
            return (_local3);
        }
        public function removeAll():void{
            var _local1:String;
            for (_local1 in cells) {
                if (cells[_local1]){
                    cells[_local1].dispose();
                    delete cells[_local1];
                };
            };
            for (_local1 in groupCell) {
                if (groupCell[_local1]){
                    groupCell[_local1].dispose();
                    delete groupCell[_local1];
                };
            };
            _dataProvider = [];
        }
        public function clearAllSelected():void{
            var _local1:TaskGroupStruct;
            var _local2:Object;
            for each (_local1 in this.dataProvider) {
                if (_local1.isExpand){
                    for each (_local2 in _local1.taskDic) {
                        _local2.isSelected = false;
                    };
                };
            };
        }
        protected function toRepaint():void{
            this.removeAll();
            this.createCells();
        }
        protected function onClickTaskGroup(_arg1:MouseEvent):void{
            var _local3:TaskGroupStruct;
            var _local2:TaskGroupCellRenderer = (_arg1.currentTarget as TaskGroupCellRenderer);
            if (_local2){
                _local3 = _local2.info;
                if (((_local3.isExpand) && (this.checkSelectedInGroup(_local3)))){
                    this.selectedID = 0;
                    this.dispatchEvent(new TreeEvent(TreeEvent.CHANGE_SELECTED, 0));
                };
                _local3.isExpand = !(_local3.isExpand);
                _local2.isExpand = _local3.isExpand;
                doLayout();
            };
        }
        protected function checkSelectedInGroup(_arg1:TaskGroupStruct):Boolean{
            var _local2:Object;
            for each (_local2 in _arg1.taskDic) {
                if (_local2.isSelected == true){
                    _local2.isSelected = false;
                    return (true);
                };
            };
            return (false);
        }
        public function refresh():void{
            this.toRepaint();
        }
        private function doLayout():void{
            var _local1:int;
            var _local2:TaskGroupStruct;
            var _local3:TaskGroupCellRenderer;
            var _local4:TreeCellRenderer;
            var _local5:Object;
            for each (_local2 in this.dataProvider) {
                _local3 = this.groupCell[_local2.taskType];
                _local3.y = _local1;
                _local1 = (_local1 + _local3.height);
                for each (_local5 in _local2.taskDic) {
                    _local4 = cells[_local5.id];
                    if (_local2.isExpand){
                        _local4.y = _local1;
                        _local4.x = padding;
                        _local1 = (_local1 + _local4.height);
                        if (_local5.isSelected == true){
                            this.selectedID = _local5.id;
                        };
                        _local4.visible = true;
                    } else {
                        _local4.visible = false;
                    };
                };
            };
            this.height = _local1;
        }
        public function setSelected(_arg1:uint):void{
            this.clearAllSelected();
            var _local2:TaskInfoStruct = (GameCommonData.TaskInfoDic[_arg1] as TaskInfoStruct);
            if (_local2 == null){
                return;
            };
            var _local3:TaskGroupStruct = this.searchGroupByDes(_local2.taskType, this.dataProvider);
            if (_local3 == null){
                return;
            };
            var _local4:Object = _local3.taskDic[_arg1];
            if (_local4 == null){
                return;
            };
            _local4.isSelected = true;
            _local3.isExpand = true;
            this.selectedID = _arg1;
            this.dispatchEvent(new TreeEvent(TreeEvent.CHANGE_SELECTED, _arg1, false, false));
        }
        protected function getCell(_arg1:uint, _arg2:Boolean=false, _arg3:Object=null):TreeCellRenderer{
            if (cells[_arg1]){
                return (cells[_arg1]);
            };
            var _local4:TreeCellRenderer = new TreeCellRenderer(_arg1, _arg2, _arg3);
            this.cells[_local4.id] = _local4;
            return (_local4);
        }
        public function searchObjById(_arg1:uint):Object{
            var _local2:TaskGroupStruct;
            for each (_local2 in this.dataProvider) {
                if (_local2.taskDic[_arg1] != null){
                    return (_local2.taskDic[_arg1]);
                };
            };
            return (null);
        }
        private function checkIsNoTask():void{
        }
        public function updateTaskProcess(_arg1:int):void{
            if (cells[_arg1]){
                cells[_arg1].Update();
            };
        }
        public function set selectedID(_arg1:uint):void{
            var _local2:Object;
            if (cells[this._selectedID]){
                cells[this._selectedID].isSelected = false;
                _local2 = this.searchObjById(this._selectedID);
                if (_local2){
                    _local2.isSelected = false;
                };
            };
            if (cells[_arg1]){
                cells[_arg1].isSelected = true;
            };
            _selectedID = _arg1;
        }
        public function removeTask(_arg1:uint):void{
            var _local3:Boolean;
            var _local4:String;
            if (cells[_arg1] == null){
                return;
            };
            cells[_arg1].dispose();
            delete cells[_arg1];
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            if (groupCell[_local2.taskType]){
                delete groupCell[_local2.taskType].info.taskDic[_arg1];
                if (groupCell[_local2.taskType].info.taskDic){
                    _local3 = false;
                    for (_local4 in groupCell[_local2.taskType].info.taskDic) {
                        _local3 = true;
                    };
                    if (!_local3){
                        this.dataProvider.splice(this.dataProvider.indexOf(groupCell[_local2.taskType].info), 1);
                        groupCell[_local2.taskType].dispose();
                        delete groupCell[_local2.taskType];
                    };
                };
            };
            doLayout();
            this.checkIsNoTask();
            if (_arg1 == this.selectedID){
                this.dispatchEvent(new TreeEvent(TreeEvent.CHANGE_SELECTED, 0));
            };
        }
        public function FindGroupCellById(_arg1:int):TreeCellRenderer{
            var _local2:String;
            for (_local2 in cells) {
                if (((cells[_local2]) && ((cells[_local2].id == _arg1)))){
                    return (cells[_local2]);
                };
            };
            return (null);
        }
        protected function createCells():void{
            var _local1:TaskGroupStruct;
            var _local2:TaskGroupCellRenderer;
            var _local3:Object;
            var _local4:TreeCellRenderer;
            if ((((this.dataProvider == null)) || ((this.dataProvider.length == 0)))){
                return;
            };
            var _local5:Number = 0;
            this.selectedID = 0;
            for each (_local1 in this.dataProvider) {
                _local2 = this.getGroupCell(_local1);
                this.addChild(_local2);
                _local2.y = _local5;
                _local5 = (_local5 + _local2.height);
                if (_local1.isExpand){
                    for each (_local3 in _local1.taskDic) {
                        _local4 = this.getCell(_local3.id, _local3.isSelected, _local3.data);
                        this.addChild(_local4);
                        _local4.addEventListener(MouseEvent.CLICK, onSelectedTaskCell);
                        _local4.y = _local5;
                        _local4.x = padding;
                        _local5 = (_local5 + _local4.height);
                        if (_local3.isSelected == true){
                            this.selectedID = _local3.id;
                        };
                    };
                };
            };
            this.height = _local5;
        }
        public function set dataProvider(_arg1:Array):void{
            this._dataProvider = _arg1;
            this.toRepaint();
            this.checkIsNoTask();
        }
        public function get dataProvider():Array{
            return (this._dataProvider);
        }
        protected function createChildren():void{
            if ((((this.dataProvider == null)) || ((this.dataProvider.length == 0)))){
                return;
            };
            this.createCells();
        }

    }
}//package GameUI.Modules.Task.View 
