//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.filters.*;
    import Utils.*;

    public class HSlider extends Sprite {

        private var _minimum:Number = 0;
        private var _leftGreyArea:Sprite;
        private var _maximum:Number = 100;
        private var _greyArea:Sprite;
        private var _bg_click:Sprite;
        private var _value:Number = 0;
        private var _bg:Sprite;

        public function HSlider(){
            init();
        }
        public function set maximum(_arg1:Number):void{
            this._maximum = _arg1;
        }
        private function __dragMove(_arg1:Event):void{
            this.updateValue();
        }
        public function ableUseGrey():void{
            this.mouseEnabled = true;
            this.mouseChildren = true;
            this.filters = [];
        }
        public function get minimum():Number{
            return (this._minimum);
        }
        private function init():void{
            _bg = (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SliderAsset") as MovieClip);
            addChild(_bg);
            _bg["thumb"].x = _bg["min_pos"].x;
            _bg["thumb"].y = _bg["min_pos"].y;
            _bg["thumb"].buttonMode = true;
            Helpers.hidePosMc(_bg);
            Helpers.registExtendMouseEvent(_bg["thumb"]);
            _bg["thumb"].addEventListener(MouseEvent.MOUSE_DOWN, this.__thumbMouseDown);
            _bg["thumb"].addEventListener(Helpers.STAGE_UP_EVENT, this.__thumbUp);
            _bg["thumb"].addEventListener(Helpers.MOUSE_DOWN_AND_DRAGING_EVENT, this.__dragMove);
            this.initBackClickArea();
            this.updateValue();
        }
        private function __thumbMouseDown(_arg1:Event):void{
            _bg["thumb"].startDrag(false, new Rectangle(_bg["min_pos"].x, _bg["min_pos"].y, (_bg["max_pos"].x - _bg["min_pos"].x), 0));
        }
        public function unableUseGrey():void{
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.filters = [new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0])];
        }
        public function showGreyAreaFull():void{
            this._leftGreyArea.graphics.clear();
            this._leftGreyArea.graphics.beginFill(0, 0.7);
            this._leftGreyArea.graphics.drawRoundRect(0, 0, (_bg["thumb"].x - _bg["min_pos"].x), 11, 10, 10);
            this._leftGreyArea.graphics.endFill();
            this._leftGreyArea.x = (_bg["min_pos"].x - 3);
            this._leftGreyArea.y = ((_bg["min_pos"].y - (this._bg_click.height / 2)) - 1);
        }
        public function set minimum(_arg1:Number):void{
            this._minimum = _arg1;
        }
        private function initBackClickArea():void{
            this._bg_click = new Sprite();
            this._bg_click.graphics.beginFill(0xFFFFFF, 0);
            this._bg_click.graphics.drawRect(0, 0, (_bg["max_pos"].x - _bg["min_pos"].x), 10);
            this._bg_click.graphics.endFill();
            this._bg_click.buttonMode = true;
            this._leftGreyArea = new Sprite();
            _bg.addChild(this._leftGreyArea);
            this._leftGreyArea.buttonMode = false;
            this._greyArea = new Sprite();
            _bg.addChild(this._greyArea);
            this._greyArea.buttonMode = false;
            _bg.addChild(this._bg_click);
            _bg.setChildIndex(this._bg_click, (_bg.numChildren - 1));
            _bg.setChildIndex(_bg["thumb"], (_bg.numChildren - 1));
            this._bg_click.x = _bg["min_pos"].x;
            this._bg_click.y = (_bg["min_pos"].y - (this._bg_click.height / 2));
            this._bg_click.addEventListener(MouseEvent.MOUSE_DOWN, this.__bgClick);
        }
        public function get maximum():Number{
            return (this._maximum);
        }
        public function set value(_arg1:Number):void{
            this._value = _arg1;
            _bg["thumb"].x = ((((_arg1 - this.minimum) / (this.maximum - this.minimum)) * (_bg["max_pos"].x - _bg["min_pos"].x)) + _bg["min_pos"].x);
            this.updateGreyArea();
        }
        private function __bgClick(_arg1:MouseEvent):void{
            _bg["thumb"].x = globalToLocal(this._bg_click.localToGlobal(new Point(_arg1.localX, 0))).x;
            this.updateValue();
        }
        private function updateValue():void{
            var _local1:* = this._value;
            this._value = ((((_bg["thumb"].x - _bg["min_pos"].x) / (_bg["max_pos"].x - _bg["min_pos"].x)) * (this.maximum - this.minimum)) + this.minimum);
            if (_local1 != this.value){
                dispatchEvent(new Event(Event.CHANGE));
            };
            this.updateGreyArea();
        }
        public function hideGreyArea():void{
            this._leftGreyArea.graphics.clear();
        }
        private function __thumbUp(_arg1:Event):void{
            _bg["thumb"].stopDrag();
        }
        private function updateGreyArea():void{
            this._greyArea.graphics.clear();
            this._greyArea.graphics.beginFill(0, 0.7);
            this._greyArea.graphics.drawRoundRect(0, 0, (_bg["max_pos"].x - _bg["thumb"].x), 11, 10, 10);
            this._greyArea.graphics.endFill();
            this._greyArea.x = _bg["thumb"].x;
            this._greyArea.y = ((_bg["min_pos"].y - (this._bg_click.height / 2)) - 1);
        }
        public function get value():Number{
            return (this._value);
        }

    }
}//package GameUI.View.BaseUI 
