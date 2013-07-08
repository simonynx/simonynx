//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.View.Components.*;

    public class UIFriendsList extends UISprite {

        protected var isShow:Boolean = false;
        protected var cells:Array;
        protected var id:uint = 0;
        protected var _dataPro:Array;
        protected var currendPos:Point;
        protected var flag:Boolean = false;
        protected var cacheCells:Array;
        protected var countClick:uint = 0;

        public function UIFriendsList(){
            this._dataPro = [];
            this.cells = [];
            this.cacheCells = [];
            this.initView();
        }
        public function set dataPro(_arg1:Array):void{
            var _local2:Object = {};
            _local2["rePaintType"] = this.checkRepaintType(this._dataPro, _arg1);
            this._dataPro = _arg1;
            this.toRepaint(_local2);
        }
        protected function click(_arg1:MouseEvent):void{
            var _local2:String;
            this.countClick++;
            if (this.countClick == 1){
                id = setTimeout(onMouseClickHandler, 200, _arg1.currentTarget["roleInfo"], mouseX, mouseY);
                _arg1.stopPropagation();
            } else {
                if (this.countClick == 2){
                    this.countClick = 0;
                    clearTimeout(id);
                    _arg1.stopPropagation();
                    this.onMouseDoubleClick(_arg1.currentTarget["roleInfo"]);
                };
            };
            for (_local2 in cells) {
                if (cells[_local2] == _arg1.currentTarget){
                    cells[_local2].selectAsset.visible = true;
                } else {
                    cells[_local2].selectAsset.visible = false;
                };
            };
        }
        protected function toRepaint(_arg1:Object=null):void{
            var _local2:FriendInfoStruct;
            if (this._dataPro == null){
                return;
            };
            this.removeAllCells();
            this.cells = [];
            switch (_arg1["rePaintType"]){
                case -1:
                case 0:
                    this.cacheCells = this.cells;
                    this.cells = [];
                    for each (_local2 in this._dataPro) {
                        this.createCell(_local2);
                    };
                    break;
                case 1:
                    this.removeAllCells();
                    this.cells = [];
                    break;
                default:
                    trace("error");
            };
            this.doLayout();
        }
        protected function removeAllCells():void{
            var _local1:MovieClip;
            for each (_local1 in this.cells) {
                if (this.contains(_local1)){
                    this.removeChild(_local1);
                    this.cacheCells.push(_local1);
                };
            };
        }
        protected function initView():void{
            this.cells = [];
            this.cacheCells = [];
        }
        protected function onMouseClickHandler():void{
            this.countClick = 0;
            var _local2:FriendInfoStruct = (arguments[0] as FriendInfoStruct);
            var _local3:Point = this.localToGlobal(new Point(arguments[1], arguments[2]));
            UIFacade.GetInstance().sendNotification(FriendCommandList.SHOW_FRIENDMENU, {
                info:_local2,
                pos:_local3
            });
        }
        protected function doLayout():void{
            var _local1:uint;
            var _local2:MovieClip;
            var _local3:Number = 0;
            for each (_local2 in this.cells) {
                _local2.x = 0;
                _local2.y = _local3;
                _local1 = Math.max(_local1, _local2.width);
                _local3 = (_local3 + Math.floor((_local2.height + 1)));
            };
            this.width = _local1;
            this.height = _local3;
        }
        protected function onMouseRollOutHandler(_arg1:MouseEvent):void{
            (_arg1.target as MovieClip).alpha = 0;
        }
        protected function onMouseDoubleClick(_arg1:FriendInfoStruct):void{
            UIFacade.GetInstance().sendNotification(FriendCommandList.SHOW_SEND_MSG, _arg1);
        }
        public function get dataPro():Array{
            return (this._dataPro);
        }
        protected function getCell():MovieClip{
            var _local1:MovieClip = this.cacheCells.shift();
            if (_local1 == null){
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("FriendCellSprite");
            };
            if (_local1.parent == null){
                this.addChild(_local1);
            };
            this.cells.push(_local1);
            return (_local1);
        }
        protected function drawBg():void{
            this.graphics.beginFill(0xFFFFFF, 0);
            this.graphics.drawRect(0, 0, this.width, (this.height + 3));
            this.graphics.endFill();
        }
        protected function checkRepaintType(_arg1:Array, _arg2:Array):int{
            if (_arg1.length == _arg2.length){
                return (0);
            };
            return (((_arg1.length > _arg2.length)) ? 1 : -1);
        }
        protected function createCell(_arg1:FriendInfoStruct):void{
            if (_arg1.roleName == null){
                return;
            };
            var _local2:MovieClip = this.getCell();
            var _local3:Boolean = _arg1.isOnline;
            if (_local3){
                (_local2.userName as TextField).textColor = 0xFFFF00;
                (_local2.level as TextField).textColor = 0xFFFF00;
            } else {
                (_local2.userName as TextField).textColor = 0x666666;
                (_local2.level as TextField).textColor = 0x666666;
            };
            _local2.userName.text = _arg1.roleName;
            if (_arg1.level == 0){
                _local2.level.text = "";
            } else {
                _local2.level.text = ("Lv " + _arg1.level);
            };
            _local2.level.mouseEnabled = false;
            _local2.userName.mouseEnabled = false;
            _local2["roleInfo"] = _arg1;
            _local2.sexMc.gotoAndStop(((_arg1.sex == 0)) ? 1 : 2);
            _local2.sexMc.mouseEnabled = false;
            _local2.selectAsset.visible = false;
            _local2.addEventListener(MouseEvent.CLICK, click);
        }

    }
}//package GameUI.Modules.Friend.view.ui 
