//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.MouseCursor {
    import flash.events.*;
    import flash.display.*;
    import GameUI.Modules.PlayerIcon.UI.*;
    import flash.ui.*;

    public class SysCursor {

        public static const PICK_CURSOR:uint = 3;
        public static const STALK_CURSOR:uint = 4;
        public static const ATTACK_CURSOR:uint = 1;

        private static var _instance:SysCursor;

        protected var type:int = -1;
        protected var systemCursorLayer:Sprite;
        protected var cursor:Sprite;
        public var _isLock:Boolean = false;
        protected var cursors:Array;

        public function SysCursor(){
            systemCursorLayer = GameCommonData.GameInstance.CursorLayer;
            Mouse.show();
            this.cursor = new Sprite();
            this.cursor.mouseEnabled = false;
            cursors = [];
            this.LoadIcon();
            systemCursorLayer.addChild(this.cursor);
            this.cursor.visible = false;
        }
        public static function GetInstance():SysCursor{
            if (_instance == null){
                _instance = new (SysCursor)();
            };
            return (_instance);
        }

        public function showSystemCursor():void{
            GameCommonData.GameInstance.MainStage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoverHandler);
            Mouse.show();
            this.cursor.visible = false;
        }
        public function set isLock(_arg1:Boolean):void{
            this._isLock = _arg1;
            if (_arg1 == false){
                this.revert();
            };
        }
        public function revert():void{
            if (this._isLock){
                return;
            };
            this.showSystemCursor();
        }
        protected function onMouseMoverHandler(_arg1:MouseEvent):void{
            this.cursor.x = systemCursorLayer.mouseX;
            this.cursor.y = systemCursorLayer.mouseY;
            if (this.cursor.visible == false){
                this.cursor.visible = true;
            };
        }
        public function get cursorType():uint{
            return (type);
        }
        public function setMouseType(_arg1:uint=0):void{
            if (this._isLock){
                return;
            };
            if (_arg1 == 0){
                this.showSystemCursor();
                return;
            };
            GameCommonData.GameInstance.MainStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoverHandler);
            onMouseMoverHandler(null);
            Mouse.hide();
            if (this.type == _arg1){
                return;
            };
            this.type = _arg1;
            while (this.cursor.numChildren > 0) {
                this.cursor.removeChildAt(0);
            };
            var _local2:DisplayObject = this.cursors[_arg1];
            if ((((_arg1 == 2)) || ((_arg1 == 4)))){
                _local2.x = -(Math.floor((_local2.width / 2)));
                _local2.y = -(Math.floor((_local2.height / 2)));
            };
            this.cursor.addChild(_local2);
        }
        public function get isLock():Boolean{
            return (this._isLock);
        }
        protected function LoadIcon():void{
            var _local1:CursorIcon = new CursorIcon("Cursor_Attack");
            cursors.push(_local1);
            var _local2:CursorIcon = new CursorIcon("Cursor_Attack");
            cursors.push(_local2);
            var _local3:CursorIcon = new CursorIcon("Cursor_Attack");
            cursors.push(_local3);
            var _local4:CursorIcon = new CursorIcon("Cursor_Pick");
            cursors.push(_local4);
            var _local5:CursorIcon = new CursorIcon("Cursor_Talk");
            cursors.push(_local5);
        }

    }
}//package GameUI.View.MouseCursor 
