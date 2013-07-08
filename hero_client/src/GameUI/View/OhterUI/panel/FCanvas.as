//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.panel {
    import flash.display.*;
    import GameUI.View.OhterUI.component.*;

    public class FCanvas extends FComponent {

        private var container:Sprite;
        private var bg:DisplayObject;
        private var _height:Number = 0;
        private var _width:Number = 0;
        private var _dragAble:Boolean;

        public function FCanvas(){
            this.init();
        }
        override public function getChildIndex(_arg1:DisplayObject):int{
            return (this.container.getChildIndex(_arg1));
        }
        override public function getChildByName(_arg1:String):DisplayObject{
            return (this.container.getChildByName(_arg1));
        }
        override public function removeChildAt(_arg1:int):DisplayObject{
            return (this.container.removeChildAt(_arg1));
        }
        private function init():void{
            this.container = new Sprite();
            super.addChild(this.container);
            graphics.beginFill(0, 0.5);
            graphics.drawRect(0, 0, this._width, this._height);
            graphics.endFill();
        }
        override public function set width(_arg1:Number):void{
            this._width = _arg1;
            if (this.bg == null){
                graphics.beginFill(0, 0.5);
                graphics.drawRect(0, 0, this._width, this._height);
                graphics.endFill();
            } else {
                this.bg.width = _arg1;
            };
        }
        override public function get numChildren():int{
            return (this.container.numChildren);
        }
        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            this.container.addChildAt(_arg1, _arg2);
            return (_arg1);
        }
        override public function removeChild(_arg1:DisplayObject):DisplayObject{
            return (this.container.removeChild(_arg1));
        }
        override public function getChildAt(_arg1:int):DisplayObject{
            return (this.container.getChildAt(_arg1));
        }
        override public function addChild(_arg1:DisplayObject):DisplayObject{
            this.container.addChild(_arg1);
            return (_arg1);
        }
        override public function set height(_arg1:Number):void{
            this._height = _arg1;
            if (this.bg == null){
                graphics.beginFill(0, 0.5);
                graphics.drawRect(0, 0, this._width, this._height);
                graphics.endFill();
            } else {
                this.bg.height = _arg1;
            };
        }

    }
}//package GameUI.View.OhterUI.panel 
