//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.OhterUI.list.*;
    import GameUI.View.OhterUI.scroll.*;
    import GameUI.View.OhterUI.panel.*;
    import GameUI.View.OhterUI.text.*;

    public class MyCombox extends Sprite {

        private var _cWidth:int;
        private var scorb:FVScorllBar;
        private var canvas:FCanvas;
        private var _lWidth:int;
        public var btn:SimpleButton;
        private var _callback:Function;
        private var list:FList;
        private var _cHeight:int;
        private var label:FLabel;

        public function MyCombox(_arg1:int=80, _arg2:int=100, _arg3:int=60, _arg4:Function=null){
            _cWidth = _arg1;
            _cHeight = _arg2;
            _lWidth = _arg3;
            _callback = _arg4;
            init();
            initEvent();
        }
        public function setSelectItemByIndex(_arg1:int):void{
            this.list.setSelectItemByIndex(_arg1);
            this.label.text = this.list.selectItem.label;
            if (this.list.selectItem.color){
                this.label.textColor = this.list.selectItem.color;
            } else {
                this.label.textColor = 0xFFFFFF;
            };
            this.canvas.visible = false;
        }
        private function init():void{
            label = new FLabel();
            this.addChild(label);
            canvas = new FCanvas();
            canvas.width = _cWidth;
            canvas.height = _cHeight;
            this.addChild(canvas);
            this.canvas.visible = false;
            list = new FList();
            list.listWidth = _lWidth;
            canvas.addChild(list);
            scorb = new FVScorllBar(list, _cHeight);
            canvas.addChild(scorb);
            btn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("DownArrow");
            this.addChild(btn);
            setlabelBg();
            setPos();
        }
        private function setPos():void{
            btn.x = (canvas.width - btn.width);
            canvas.y = 15;
            scorb.x = (canvas.width - btn.width);
        }
        public function getlistUI():FList{
            return (list);
        }
        public function HideMenu():void{
            canvas.visible = false;
        }
        public function get length():int{
            return (this.list.length);
        }
        private function initEvent():void{
            this.btn.addEventListener(MouseEvent.CLICK, onShowMenu);
            this.label.addEventListener(MouseEvent.CLICK, onShowMenu);
            this.list.addEventListener(MouseEvent.CLICK, this.onListClick);
        }
        public function getCurrentItemLabel():String{
            return (this.label.text);
        }
        public function get selectItem():Object{
            return (this.list.selectItem);
        }
        public function setCurrentItemLabel(_arg1:String):void{
            this.label.text = _arg1;
        }
        public function set listXml(_arg1:XML):void{
            list.dataProvider = _arg1;
            scorb.update();
        }
        private function setlabelBg():void{
            this.graphics.beginFill(0, 1);
            this.graphics.drawRect(0, 0, _cWidth, 15);
            this.graphics.endFill();
        }
        private function onListClick(_arg1:MouseEvent):void{
            if (this.list.selectItem){
                this.label.text = this.list.selectItem.label;
                if (this.list.selectItem.color){
                    this.label.textColor = this.list.selectItem.color;
                } else {
                    this.label.textColor = 0xFFFFFF;
                };
                dispatchEvent(new Event(Event.CHANGE));
            };
            this.canvas.visible = false;
        }
        private function onShowMenu(_arg1:MouseEvent):void{
            canvas.visible = !(canvas.visible);
            if (_callback){
                _callback();
            };
        }

    }
}//package GameUI.View.OhterUI 
