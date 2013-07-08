//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.list {
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.OhterUI.event.*;

    public class FList extends Sprite {

        private var _height:Number = 10;
        private var _width:Number = 10;
        private var _itemRenderer:FListCellRenderer;
        private var _dataProvider;
        private var _skin:String;
        private var _selectItem:Object;
        private var fListcellRendererArray:Array;

        public function FList(){
            this.fListcellRendererArray = [];
            super();
            this.init();
        }
        public function set listHeight(_arg1:Number):void{
            this._height = _arg1;
            graphics.clear();
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, this._width, this._height);
            graphics.endFill();
        }
        public function setSelcetNext():void{
            var _local1:int;
            var _local2:int = numChildren;
            _local1 = 0;
            while (_local1 < _local2) {
                if ((getChildAt(_local1) as FListCellRenderer).selectState){
                    (getChildAt(_local1) as FListCellRenderer).unSelect();
                    if ((_local1 + 1) == _local2){
                        _local1 = 0;
                    } else {
                        _local1 = (_local1 + 1);
                    };
                    (getChildAt(_local1) as FListCellRenderer).select();
                    this._selectItem = (getChildAt(_local1) as FListCellRenderer).data;
                };
                _local1++;
            };
        }
        public function set listWidth(_arg1:Number):void{
            this._width = _arg1;
            graphics.clear();
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, this._width, this._height);
            graphics.endFill();
        }
        public function setSelectItemByIndex(_arg1:int):void{
            (getChildAt(_arg1) as FListCellRenderer).select();
            this._selectItem = (getChildAt(_arg1) as FListCellRenderer).data;
        }
        private function init():void{
            this.initListener();
        }
        private function initListener():void{
            addEventListener(FListEvent.CLICK_CELL, this.onCellClick);
        }
        private function xmlToObj(_arg1:XML):Object{
            var _local2:int;
            var _local3:XMLList = _arg1.@*;
            var _local4:Object = {};
            var _local5:int = _local3.length();
            _local2 = 0;
            while (_local2 < _local5) {
                _local4[_local3[_local2].name().toString()] = _local3[_local2].toString();
                _local2++;
            };
            return (_local4);
        }
        public function get length():int{
            return (fListcellRendererArray.length);
        }
        private function onCellClick(_arg1:FListEvent):void{
            var _local2:FListCellRenderer;
            this._selectItem = _arg1.item.data;
            for each (_local2 in this.fListcellRendererArray) {
                if (_arg1.target != _local2){
                    _local2.unSelect();
                };
            };
        }
        public function set itemRenderer(_arg1:FListCellRenderer):void{
            this._itemRenderer = _arg1;
        }
        public function setSelectPrevious():void{
            var _local1:int;
            var _local2:int = numChildren;
            _local1 = 0;
            while (_local1 < _local2) {
                if ((getChildAt(_local1) as FListCellRenderer).selectState){
                    (getChildAt(_local1) as FListCellRenderer).unSelect();
                    if (_local1 == 0){
                        _local1 = (_local2 - 1);
                    } else {
                        _local1--;
                    };
                    (getChildAt(_local1) as FListCellRenderer).select();
                    this._selectItem = (getChildAt(_local1) as FListCellRenderer).data;
                };
                _local1++;
            };
        }
        public function get selectItem():Object{
            return (this._selectItem);
        }
        private function initUIforXml(_arg1:XML):void{
            var _local2:int;
            var _local3:XML;
            var _local4:int = _arg1.children().length();
            var _local5:Array = [];
            var _local6:XMLList = _arg1.children();
            _local2 = 0;
            while (_local2 < _local4) {
                _local3 = _local6[_local2];
                _local5.push(this.xmlToObj(_local3));
                _local2++;
            };
            this.reInitUI(_local5);
        }
        public function get itemRenderer():FListCellRenderer{
            return (this._itemRenderer);
        }
        private function reInitUI(_arg1:Array):void{
            var _local2:int;
            var _local3:FListCellRenderer;
            var _local4:Class;
            var _local6:int;
            this.fListcellRendererArray = [];
            while (numChildren > 0) {
                removeChildAt(0);
            };
            var _local5:int = _arg1.length;
            _local2 = 0;
            while (_local2 < _local5) {
                if (this._itemRenderer == null){
                    _local3 = new FListCellRenderer();
                } else {
                    _local4 = (getDefinitionByName(getQualifiedClassName(this._itemRenderer)) as Class);
                    _local3 = (new (_local4)() as FListCellRenderer);
                };
                _local3.updataRender(this._width);
                _local3.data = _arg1[_local2];
                _local3.y = _local6;
                _local6 = (_local6 + _local3.height);
                addChild(_local3);
                this.fListcellRendererArray.push(_local3);
                _local2++;
            };
        }
        public function set skin(_arg1:String):void{
            this._skin = _arg1;
        }
        public function setSelectItemByLabel(_arg1:String):void{
            var _local2:int;
            var _local3:int = numChildren;
            _local2 = 0;
            while (_local2 < _local3) {
                if ((getChildAt(_local2) as FListCellRenderer).data.label == _arg1){
                    (getChildAt(_local2) as FListCellRenderer).select();
                    this._selectItem = (getChildAt(_local2) as FListCellRenderer).data;
                } else {
                    (getChildAt(_local2) as FListCellRenderer).unSelect();
                };
                _local2++;
            };
        }
        public function set dataProvider(_arg1:Object):void{
            this._dataProvider = _arg1;
            if ((_arg1 is Array)){
                this.reInitUI((_arg1 as Array));
            } else {
                if ((_arg1 is XML)){
                    this.initUIforXml((_arg1 as XML));
                };
            };
            this._selectItem = null;
        }

    }
}//package GameUI.View.OhterUI.list 
