//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HTree {
    import flash.events.*;
    import flash.utils.*;
    import GameUI.View.Components.*;

    public class HUITree extends UISprite {

        private var intervalId:uint;
        private var groupCell:Array;
        private var cells:Array;
        private var _selectedID:uint;
        private var _dataProvider:Array;
        protected var padding:uint = 18;

        public function HUITree(_arg1:Array=null){
            cells = [];
            groupCell = [];
            super();
            this._dataProvider = _arg1;
            if (this._dataProvider == null){
                this._dataProvider = [];
            };
            this.width = 196;
            this.createChildren();
        }
        public function searchGroupByDes(_arg1:uint, _arg2:Array):HTreeGroupStruct{
            var _local3:HTreeGroupStruct;
            for each (_local3 in _arg2) {
                if (_local3.type == _arg1){
                    return (_local3);
                };
            };
            return (null);
        }
        public function get selectedID():uint{
            return (_selectedID);
        }
        protected function getGroupCell(_arg1:String, _arg2:int, _arg3:int, _arg4:Boolean=false):HGroupCellRenderer{
            var _local5:HGroupCellRenderer = new HGroupCellRenderer(_arg1, _arg2, _arg3, _arg4);
            _local5.addEventListener(MouseEvent.CLICK, onClickTreeGroup);
            this.groupCell.push(_local5);
            this.addChild(_local5);
            return (_local5);
        }
        public function removeAll():void{
            while (this.numChildren > 1) {
                this.removeChildAt(1);
            };
            this.cells = [];
            this.groupCell = [];
        }
        public function clearAllSelected():void{
            var _local1:HTreeGroupStruct;
            var _local2:Object;
            for each (_local1 in this.dataProvider) {
                if (_local1.isExpand){
                    for each (_local2 in _local1.menuDic) {
                        _local2.isSelected = false;
                    };
                };
            };
        }
        protected function toRepaint():void{
            this.removeAll();
            this.createCells();
        }
        protected function checkSelectedInGroup(_arg1:HTreeGroupStruct):Boolean{
            var _local2:Object;
            for each (_local2 in _arg1.menuDic) {
                if (_local2.isSelected == true){
                    _local2.isSelected = false;
                    return (true);
                };
            };
            return (false);
        }
        protected function onClickTreeGroup(_arg1:MouseEvent):void{
            var _local2:HTreeGroupStruct;
            var _local3:int = this.groupCell.indexOf(_arg1.currentTarget);
            if (_local3 != -1){
                _local2 = this.dataProvider[_local3];
                if (((_local2.isExpand) && (this.checkSelectedInGroup(_local2)))){
                    this.selectedID = 0;
                    this.dispatchEvent(new HTreeEvent(HTreeEvent.CHANGE_SELECTED, 0));
                };
                if (_arg1.target.name != "icon"){
                    this.dispatchEvent(new HTreeEvent(HTreeEvent.GROUP_SELECTED, (_local3 + 1)));
                };
                _local2.isExpand = !(_local2.isExpand);
                this.refresh();
            };
        }
        protected function onDoubleClickCell(_arg1:MouseEvent):void{
            if (this.selectedID > 0){
                this.dispatchEvent(new HTreeEvent(HTreeEvent.DOUBLE_CLICK_TREE, this.selectedID, false, false));
            };
        }
        public function refresh():void{
            this.toRepaint();
        }
        public function setSelected(_arg1:uint):void{
            this.clearAllSelected();
            var _local2:Object = searchObjById(_arg1);
            if (_local2 == null){
                return;
            };
            var _local3:HTreeGroupStruct = this.searchGroupByDes(_local2.type, this.dataProvider);
            if (_local3 == null){
                return;
            };
            var _local4:Object = _local3.menuDic[_arg1];
            if (_local4 == null){
                return;
            };
            _local4.isSelected = true;
            _local3.isExpand = true;
            this.refresh();
            this.selectedID = _arg1;
            this.dispatchEvent(new HTreeEvent(HTreeEvent.CHANGE_SELECTED, _arg1, false, false));
        }
        private function setOneSelected(_arg1:uint):void{
            var _local2:HTreeCellRenderer;
            for each (_local2 in this.cells) {
                if ((((_local2.id == _arg1)) && ((_local2.isSelected == false)))){
                    _local2.isSelected = true;
                } else {
                    _local2.isSelected = false;
                };
            };
        }
        public function addMenu(_arg1:HTreeInfoStruct, _arg2:uint=1):void{
            var _local3:Dictionary;
            var _local4:HTreeGroupStruct = this.searchGroupByDes(_arg1.type, this.dataProvider);
            if (_local4){
                _local4.menuDic[_arg1.Id] = {
                    des:_arg1.des,
                    isSelected:false,
                    data:_arg1.Id,
                    type:_arg1.type
                };
                _local4.menuIds.push(_arg1.Id);
            } else {
                _local3 = new Dictionary();
                _local3[_arg1.Id] = {
                    des:_arg1.des,
                    isSelected:false,
                    data:_arg1.Id,
                    type:_arg1.type
                };
                _local4 = new HTreeGroupStruct(_local3, true, _arg1.type, 0xFFFFFF, _arg2);
                _local4.menuIds = [];
                _local4.menuIds.push(_arg1.Id);
                this.dataProvider.push(_local4);
            };
        }
        protected function getCell(_arg1:String, _arg2:Boolean=false, _arg3:uint=0):HTreeCellRenderer{
            var _local4:HTreeCellRenderer = new HTreeCellRenderer(_arg1, _arg2, _arg3);
            this.cells.push(_local4);
            this.addChild(_local4);
            _local4.addEventListener(MouseEvent.CLICK, onSelectedTreeCell);
            _local4.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickCell);
            return (_local4);
        }
        public function searchObjById(_arg1:uint):Object{
            var _local2:HTreeGroupStruct;
            for each (_local2 in this.dataProvider) {
                if (_local2.menuDic[_arg1] != null){
                    return (_local2.menuDic[_arg1]);
                };
            };
            return (null);
        }
        public function set selectedID(_arg1:uint):void{
            _selectedID = _arg1;
        }
        public function get Cells():Array{
            return (cells);
        }
        protected function onSelectedTreeCell(_arg1:MouseEvent):void{
            var _local2:Object = this.searchObjById(_arg1.currentTarget.id);
            if (_local2 == null){
                return;
            };
            var _local3:Object = this.searchObjById(this.selectedID);
            if (_local3 != null){
                this.selectedID = 0;
                _local3.isSelected = false;
            };
            this.selectedID = _local2.data;
            setOneSelected(_local2.data);
            _local2.isSelected = true;
            if (this.selectedID > 0){
                this.dispatchEvent(new HTreeEvent(HTreeEvent.CHANGE_SELECTED, this.selectedID, false, false));
            };
            this.dispatchEvent(new HTreeEvent(HTreeEvent.CLICK_TREE_CELL, this.selectedID, false, false));
        }
        protected function createCells():void{
            var _local1:HTreeGroupStruct;
            var _local2:HGroupCellRenderer;
            var _local3:Object;
            var _local4:HTreeCellRenderer;
            var _local6:uint;
            if ((((this.dataProvider == null)) || ((this.dataProvider.length == 0)))){
                return;
            };
            var _local5:Number = 0;
            this.selectedID = 0;
            for each (_local1 in this.dataProvider) {
                _local2 = this.getGroupCell(_local1.des, _local1.textSize, _local1.type, _local1.isExpand);
                _local2.y = _local5;
                _local5 = (_local5 + _local2.height);
                if (_local1.isExpand){
                    for each (_local6 in _local1.menuIds) {
                        _local3 = _local1.menuDic[_local6];
                        _local4 = this.getCell(_local3.des, _local3.isSelected, _local3.data);
                        _local4.y = _local5;
                        _local4.x = padding;
                        _local5 = (_local5 + _local4.height);
                        if (_local3.isSelected == true){
                            this.selectedID = _local3.data;
                        };
                    };
                };
            };
            this.height = _local5;
        }
        public function set dataProvider(_arg1:Array):void{
            this._dataProvider = _arg1;
            this.toRepaint();
        }
        public function get GroupCells():Array{
            return (groupCell);
        }
        public function get dataProvider():Array{
            return (this._dataProvider);
        }
        public function FindGroupCellById(_arg1:int):HTreeCellRenderer{
            var _local2:int;
            _local2 = 0;
            while (_local2 < cells.length) {
                if (((cells[_local2]) && ((cells[_local2].id == _arg1)))){
                    return (cells[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        protected function createChildren():void{
            this.cells = [];
            if ((((this.dataProvider == null)) || ((this.dataProvider.length == 0)))){
                return;
            };
            this.createCells();
        }

    }
}//package GameUI.View.HTree 
