//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Modules.Friend.command.*;

    public class MenuItem extends Sprite {

        protected var _dataPro:Array;
        public var contentPanel:MovieClip;
        protected var cells:Array;
        public var roleInfo:FriendInfoStruct;
        public var w:Number = 100;
        protected var childrenMenu:MenuItem;

        public function MenuItem(_arg1:Array=null){
            this.name = "MENU";
            this._dataPro = _arg1;
            this.contentPanel = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("menuBack");
            this.contentPanel.width = w;
            this.addChild(this.contentPanel);
            this.createChildren();
        }
        public function get dataPro():Array{
            return (this._dataPro);
        }
        protected function onCellMouseClick(_arg1:MouseEvent):void{
            this.dispatchEvent(new MenuEvent(MenuEvent.Cell_Click, false, false, (_arg1.currentTarget as MenuItemCell), this.roleInfo));
        }
        protected function createChildren():void{
            var _local1:Object;
            var _local2:MenuItemCell;
            this.cells = [];
            for each (_local1 in this.dataPro) {
                _local2 = this.getCell();
                _local2.setText(_local1["cellText"]);
                if (_local1.hasOwnProperty("data")){
                    _local2.data = _local1["data"];
                };
                this.addChild(_local2);
                this.cells.push(_local2);
            };
            this.doLayout();
        }
        protected function onCellMouseRollOut(_arg1:MouseEvent):void{
            var _local2:MenuItemCell = (_arg1.target as MenuItemCell);
            var _local3:Object = _local2.data;
            if (this.childrenMenu == null){
                return;
            };
            if (!_local3["hasChild"]){
                if (this.childrenMenu.parent != null){
                    this.removeChild(this.childrenMenu);
                };
            };
        }
        protected function toRepaint():void{
            this.createChildren();
        }
        protected function onChildrenMenuClick(_arg1:MenuEvent):void{
            this.dispatchEvent(new MenuEvent(_arg1.type, false, false, _arg1.cell));
        }
        protected function doLayout():void{
            var _local1:MenuItemCell;
            var _local2:Number;
            _local2 = 2;
            for each (_local1 in this.cells) {
                _local1.content.width = (w - 4);
                _local1.y = _local2;
                _local1.x = 2;
                _local2 = (_local2 + _local1.height);
            };
            this.contentPanel.height = (_local2 + 3);
        }
        protected function getCell():MenuItemCell{
            var _local1:MenuItemCell = new MenuItemCell();
            _local1.addEventListener(MouseEvent.CLICK, onCellMouseClick);
            _local1.addEventListener(MouseEvent.ROLL_OUT, onCellMouseRollOut);
            _local1.addEventListener(MouseEvent.ROLL_OVER, onCellMouseRollOver);
            return (_local1);
        }
        protected function onCellMouseRollOver(_arg1:MouseEvent):void{
            var _local2:Point;
            var _local3:Point;
            var _local4:MenuItemCell = (_arg1.target as MenuItemCell);
            var _local5:Object = _local4.data;
            if (_local5["hasChild"]){
                if (((!((this.childrenMenu == null))) && (this.contains(this.childrenMenu)))){
                    this.removeChild(this.childrenMenu);
                };
                this.childrenMenu = new MenuItem(_local5["data"]);
                this.childrenMenu.addEventListener(MenuEvent.Cell_Click, onChildrenMenuClick);
                this.addChild(this.childrenMenu);
                _local2 = new Point((((_local4.x + _local4.width) + 2) + this.childrenMenu.width), _local4.y);
                _local3 = this.localToGlobal(_local2);
                if (_local3.x > this.stage.stageWidth){
                    this.childrenMenu.x = ((_local4.x - this.childrenMenu.width) - 2);
                } else {
                    this.childrenMenu.x = ((_local4.x + _local4.width) + 2);
                };
                this.childrenMenu.y = _local4.y;
            };
        }
        protected function removeAll():void{
            var _local1:MenuItemCell;
            for each (_local1 in this.cells) {
                if (this.contains(_local1)){
                    this.removeChild(_local1);
                };
            };
        }
        public function set dataPro(_arg1:Array):void{
            removeAll();
            this._dataPro = _arg1;
            this.toRepaint();
        }

    }
}//package GameUI.Modules.Friend.view.ui 
