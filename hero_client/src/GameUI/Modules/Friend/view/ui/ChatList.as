//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.display.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.Components.*;

    public class ChatList extends UISprite {

        protected var container:UISprite;
        protected var _dataPro:Array;
        protected var _h:uint;
        protected var cells:Array;
        protected var scrollPane:UIScrollPane;
        protected var cacheArray:Array;
        protected var _w:uint;

        public function ChatList(_arg1:uint, _arg2:uint){
            this._w = _arg1;
            this._h = _arg2;
            this.createChildren();
        }
        public function set dataPro(_arg1:Array):void{
            this._dataPro = _arg1;
            this.toRepaint();
        }
        public function scrollBottom():void{
            this.scrollPane.refresh();
            this.scrollPane.scrollBottom();
        }
        public function dispose():void{
            removeAllCells();
            if (this.parent){
                this.parent.removeChild(this);
            };
            if (((scrollPane) && (scrollPane.parent))){
                scrollPane.parent.removeChild(scrollPane);
            };
            scrollPane = null;
            cacheArray = null;
        }
        protected function doLayout():void{
            var _local1:FriendChatCell;
            var _local2:int = this.cells.length;
            var _local3:Number = 1;
            var _local4:uint;
            while (_local4 < _local2) {
                _local1 = this.cells[_local4];
                _local1.x = 1;
                _local1.y = _local3;
                _local3 = (_local3 + _local1.height);
                _local4++;
            };
            this.container.height = _local3;
            this.scrollPane.refresh();
        }
        public function removeAllCells():void{
            var _local1:FriendChatCell;
            var _local2:uint = this.cells.length;
            var _local3:uint;
            while (_local3 < _local2) {
                _local1 = this.cells.shift();
                if (this.container.contains(_local1)){
                    this.container.removeChild(_local1);
                };
                _local3++;
            };
        }
        protected function toRepaint():void{
            this.removeAllCells();
            this.createCells();
            this.doLayout();
        }
        public function addChatCell(_arg1:Object):void{
            var _local3:Array;
            this._dataPro.push(_arg1);
            var _local2:FriendChatCell = this.getCell();
            this.container.addChild(_local2);
            if ((_arg1 is ChatInfoStruct)){
                _local2.des = (((((("<font color=\"#FEFE59\">" + GameCommonData.Player.Role.Name) + "</font>&nbsp;&nbsp;&nbsp;<font color=\"#FEFE59\">[") + new Date(_arg1.timeT).toTimeString().split(" ")[0]) + "]</font><br>&nbsp;&nbsp;<font color=\"#59FEE5\">") + _arg1.content) + "</font>");
            } else {
                _local3 = _arg1.sendPersonName.split("_");
                _local2.des = (((((("<font color=\"#FEFE59\">" + _local3[0]) + "</font>&nbsp;&nbsp;&nbsp;<font color=\"#FEFE59f\">[") + new Date(_arg1.sendTime).toTimeString().split(" ")[0]) + "]</font><br>&nbsp;&nbsp;<font color=\"#59FEE5\">") + _arg1.msg) + "</font>");
            };
            cells.push(_local2);
            this.doLayout();
            scrollPane.scrollStep = -3;
            this.scrollPane.scrollBottom();
        }
        public function createCells():void{
            var _local5:Array;
            var _local1:int = this._dataPro.length;
            if (_local1 == 0){
                return;
            };
            var _local2:uint;
            var _local3:FriendChatCell;
            var _local4:Object;
            while (_local2 < _local1) {
                if ((((_dataPro[_local2] is ChatInfoStruct)) && ((_dataPro[_local2].content == null)))){
                    _local2++;
                } else {
                    _local4 = this._dataPro[_local2];
                    _local3 = this.getCell();
                    this.container.addChild(_local3);
                    if ((_local4 is ChatInfoStruct)){
                        _local3.des = (((((("<font color=\"#FEFE59\">" + GameCommonData.Player.Role.Name) + "</font>&nbsp;&nbsp;&nbsp;<font color=\"#FEFE59\">[") + new Date(_local4.timeT).toTimeString().split(" ")[0]) + "]</font><br>&nbsp;&nbsp;<font color=\"#59FEE5\">") + _local4.content) + "</font>");
                    } else {
                        _local5 = _local4.sendPersonName.split("_");
                        _local3.des = (((((("<font color=\"#FEFE59\">" + _local5[0]) + "</font>&nbsp;&nbsp;&nbsp;<font color=\"#FEFE59\">[") + new Date(_local4.sendTime).toTimeString().split(" ")[0]) + "]</font><br>&nbsp;&nbsp;<font color=\"#59FEE5\">") + _local4.msg) + "</font>");
                    };
                    cells.push(_local3);
                    _local2++;
                };
            };
        }
        protected function createChildren():void{
            this.cacheArray = [];
            this.cells = [];
            this._dataPro = [];
            this.container = new UISprite();
            this.container.width = (this._w - 16);
            this.scrollPane = new UIScrollPane(this.container);
            this.addChild(this.scrollPane);
            this.scrollPane.width = this._w;
            this.scrollPane.height = this._h;
            this.scrollPane.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            this.scrollPane.refresh();
        }
        public function getCell():FriendChatCell{
            var _local1:FriendChatCell = this.cacheArray.shift();
            if (_local1 == null){
                _local1 = new FriendChatCell((this._w - 16));
            };
            return (_local1);
        }

    }
}//package GameUI.Modules.Friend.view.ui 
