//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.list {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import GameUI.View.OhterUI.event.*;
    import GameUI.View.OhterUI.text.*;
   // import GameUI.View.OhterUI.util.*;

    public class FListCellRenderer extends Sprite {

        private var _over:Bitmap;
        protected var _height:Number = 18;
        private var _width:Number = 100;
        private var _data:Object;
        private var _mask:Sprite;
        private var _tile:Bitmap;
        private var _select:Bitmap;
        private var _selected:Boolean;

        public function FListCellRenderer(){
            this._tile = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("shooter.task.accet.TaskCellOverAsset");
            this._over = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("shooter.task.accet.TaskCellOverAsset");
            this._select = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("shooter.task.accet.TaskCellSelectAsset");
            this._tile.visible = true;
            addChild(this._over);
            this._over.visible = false;
            addChild(this._select);
            this._select.visible = false;
            this.initListener();
            this._mask = new Sprite();
        }
        private function onMouseOver(_arg1:MouseEvent):void{
            this._over.visible = true;
        }
        public function get selectState():Boolean{
            return (this._selected);
        }
        private function reSize():void{
            this._mask.graphics.clear();
            var _local2:* = this._mask.graphics;
            var _local2 = _local2;
            with (_local2) {
                clear();
                beginFill(0);
                drawRect(0, 0, _width, _height);
                endFill();
            };
            this._tile.width = (this._select.width = (this._over.width = this._width));
            this._tile.height = (this._select.height = (this._over.height = this._height));
        }
        protected function removeListener():void{
            this.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
        public function set data(_arg1:Object):void{
            this._data = _arg1;
            this.initUI();
            this.reSize();
        }
        protected function initListener():void{
            this.addEventListener(MouseEvent.CLICK, this.onClick);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            this._over.visible = false;
        }
        private function onClick(_arg1:MouseEvent):void{
            this.select();
            var _local2:FListEvent = new FListEvent(FListEvent.CLICK_CELL, this, true);
            dispatchEvent(_local2);
        }
        public function get data():Object{
            return (this._data);
        }
        public function initUI():void{
            this._height = 18;
            var _local1:FLabel = new FLabel();
            addChild(_local1);
            if (data.color){
                _local1.textColor = data.color;
            } else {
                _local1.textColor = 0xFFFFFF;
            };
            _local1.name = "FLabel";
            _local1.selectable = false;
            _local1.text = this.data.label;
            _local1.x = 2;
            _local1.y = 2;
        }
        public function unSelect():void{
            this._selected = false;
            this._tile.visible = true;
            this._over.visible = false;
            this._select.visible = false;
        }
        public function updataRender(_arg1:Number):void{
            this._width = _arg1;
            this.reSize();
        }
        public function select():void{
            this._selected = true;
            this._tile.visible = false;
            this._over.visible = false;
            this._select.visible = true;
        }

    }
}//package GameUI.View.OhterUI.list 
