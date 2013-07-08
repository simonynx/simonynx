//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.scroll {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.OhterUI.panel.*;

    public class FVScorllBar extends Sprite {

        var slipBtn:MovieClip;
        var slipHeight:Number;
        var bottonBtn:SimpleButton;
        private var target:DisplayObject;
        private var ui:DisplayObject;
        var ScrollBarHeight:Number;
        var bgMc:FCanvas;
        var upBtn:SimpleButton;
        private var slipBtnHeight:Number = 30;
        var slipVar:Number;
        private var Text:TextField;
        var scrollMask:Sprite;
        var uiHeight:Number;
        private var _skin:String;
        var rect:Rectangle;
        private var isText:Boolean;
        var putTime:uint;

        public function FVScorllBar(_arg1:DisplayObject, _arg2:int=100){
            this.target = _arg1;
            this.ScrollBarHeight = _arg2;
            if ((_arg1 is TextField)){
                this.isText = true;
                this.initTextScroll();
                this.Text = (_arg1 as TextField);
            } else {
                this.ui = _arg1;
                this.isText = false;
                this.initPanelScroll();
            };
            this.reSize();
        }
        private function textSlipUp(_arg1:MouseEvent):void{
            this.Text.addEventListener(Event.SCROLL, this.textScroll);
            this.slipBtn.stopDrag();
            this.slipBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, this.textSlipUp);
        }
        private function slipDown(_arg1:MouseEvent):void{
            var _local2:Rectangle = new Rectangle(this.slipBtn.x, (this.bgMc.y + this.upBtn.height), 0, this.slipHeight);
            this.slipBtn.startDrag(false, _local2);
            addEventListener(Event.ENTER_FRAME, this.slipBtnDownTime);
            this.slipBtn.stage.addEventListener(MouseEvent.MOUSE_UP, this.slipUp);
        }
        private function initTextScroll():void{
            this.bgMc = new FCanvas();
            addChild(this.bgMc);
            this.bgMc.width = 13;
            this.upBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("UpArrow");
            addChild(this.upBtn);
            upBtn.name = "upBtn";
            this.bottonBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("DownArrow");
            addChild(this.bottonBtn);
            bottonBtn.name = "bottomBtn";
            this.slipBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Thumb");
            addChild(this.slipBtn);
            slipBtn.name = "slipBtn";
            this.bgMc.height = this.ScrollBarHeight;
            this.bottonBtn.y = (this.bgMc.height - this.bottonBtn.height);
            this.slipBtn.y = this.upBtn.height;
            visible = false;
            addEventListener(Event.ENTER_FRAME, this.addStageEvent);
        }
        private function upBtnDown(_arg1:MouseEvent):void{
            if ((this.scrollMask.y - this.ui.y) > 10){
                this.ui.y = (this.ui.y + 10);
            } else {
                this.ui.y = this.scrollMask.y;
            };
            if ((this.scrollMask.y - this.ui.y) > 0){
                this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * ((this.scrollMask.y - this.ui.y) / this.uiHeight)));
            } else {
                this.slipBtn.y = (this.bgMc.y + this.upBtn.height);
            };
            this.putTime = getTimer();
            addEventListener(Event.ENTER_FRAME, this.upBtnDownTime);
            this.upBtn.stage.addEventListener(MouseEvent.MOUSE_UP, this.upBtnUp);
        }
        private function textBottonBtnDown(_arg1:MouseEvent):void{
            this.Text.scrollV++;
            this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * (this.Text.scrollV / this.Text.maxScrollV)));
            this.putTime = getTimer();
            addEventListener(Event.ENTER_FRAME, this.textBottonBtnTime);
            this.bottonBtn.stage.addEventListener(MouseEvent.MOUSE_UP, this.textBottonBtnUp);
        }
        private function slipBtnDownTime(_arg1:Event):void{
            this.ui.y = (this.scrollMask.y - ((((this.slipBtn.y - this.upBtn.height) - this.bgMc.y) / this.slipHeight) * this.uiHeight));
        }
        private function upBtnUp(_arg1:MouseEvent):void{
            removeEventListener(Event.ENTER_FRAME, this.upBtnDownTime);
            this.upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, this.upBtnUp);
        }
        private function addStageEvent(_arg1:Event=null):void{
            if (!stage){
                return;
            };
            if (this.isText){
                this.Text.addEventListener(Event.SCROLL, this.textScroll);
                this.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.textUpBtnDown);
                this.bottonBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.textBottonBtnDown);
                this.slipBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.textSlipDown);
                _arg1.target.removeEventListener(Event.ENTER_FRAME, this.addStageEvent);
            } else {
                if ((this.uiHeight + this.ScrollBarHeight) > this.ScrollBarHeight){
                    visible = true;
                    this.slipBtn.y = (this.bgMc.y + this.upBtn.height);
                    this.slipBtn.height = ((this.ScrollBarHeight / this.ui.height) * this.slipHeight);
                    this.slipHeight = (((this.bgMc.height - this.slipBtn.height) - this.upBtn.height) - this.bottonBtn.height);
                } else {
                    visible = false;
                };
                this.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.upBtnDown);
                this.bottonBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.bottonBtnDown);
                this.slipBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.slipDown);
                if (_arg1 != null){
                    _arg1.target.removeEventListener(Event.ENTER_FRAME, this.addStageEvent);
                };
            };
        }
        public function update():void{
            this.reSize();
            this.uiHeight = (this.ui.height - this.ScrollBarHeight);
            this.addStageEvent();
        }
        private function textUpBtnDownTime(_arg1:Event):void{
            if ((getTimer() - this.putTime) > 500){
                this.Text.scrollV--;
                if (this.Text.scrollV > 1){
                    this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * (this.Text.scrollV / this.Text.maxScrollV)));
                } else {
                    this.slipBtn.y = (this.bgMc.y + this.upBtn.height);
                };
            };
        }
        private function bottonBtnUp(_arg1:MouseEvent):void{
            removeEventListener(Event.ENTER_FRAME, this.bottonBtnTime);
            this.bottonBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, this.bottonBtnUp);
        }
        override public function set height(_arg1:Number):void{
            this.ScrollBarHeight = _arg1;
            this.reSize();
        }
        private function textSlipDown(_arg1:MouseEvent):void{
            this.Text.removeEventListener(Event.SCROLL, this.textScroll);
            var _local2:Rectangle = new Rectangle(this.slipBtn.x, (this.bgMc.y + this.upBtn.height), 0, this.slipHeight);
            this.slipBtn.startDrag(false, _local2);
            addEventListener(Event.ENTER_FRAME, this.textslipBtnDownTime);
            this.slipBtn.stage.addEventListener(MouseEvent.MOUSE_UP, this.textSlipUp);
        }
        private function textBottonBtnTime(_arg1:Event):void{
            if ((getTimer() - this.putTime) > 500){
                this.Text.scrollV++;
                this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * (this.Text.scrollV / this.Text.maxScrollV)));
            };
        }
        private function bottonBtnDown(_arg1:MouseEvent):void{
            if ((this.scrollMask.y - this.ui.y) < (this.uiHeight - 10)){
                this.ui.y = (this.ui.y - 10);
            } else {
                this.ui.y = (this.scrollMask.y - this.uiHeight);
            };
            this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * ((this.scrollMask.y - this.ui.y) / this.uiHeight)));
            this.putTime = getTimer();
            addEventListener(Event.ENTER_FRAME, this.bottonBtnTime);
            this.bottonBtn.stage.addEventListener(MouseEvent.MOUSE_UP, this.bottonBtnUp);
        }
        private function reSize():void{
            this.upBtn.x = ((this.bgMc.width - this.upBtn.width) / 2);
            this.bgMc.height = this.ScrollBarHeight;
            this.bottonBtn.x = ((this.bgMc.width - this.bottonBtn.width) / 2);
            this.bottonBtn.y = (this.bgMc.height - this.bottonBtn.height);
            this.slipBtn.x = ((this.bgMc.width - this.slipBtn.width) / 2);
            this.slipBtn.y = this.upBtn.height;
            this.slipBtn.height = this.slipBtnHeight;
            this.slipHeight = (((this.bgMc.height - this.slipBtn.height) - this.upBtn.height) - this.bottonBtn.height);
        }
        private function textUpBtnDown(_arg1:MouseEvent):void{
            this.Text.scrollV--;
            if (this.Text.scrollV > 1){
                this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * (this.Text.scrollV / this.Text.maxScrollV)));
            } else {
                this.slipBtn.y = (this.bgMc.y + this.upBtn.height);
            };
            this.putTime = getTimer();
            addEventListener(Event.ENTER_FRAME, this.textUpBtnDownTime);
            this.upBtn.stage.addEventListener(MouseEvent.MOUSE_UP, this.textUpBtnUp);
        }
        private function textBottonBtnUp(_arg1:MouseEvent):void{
            removeEventListener(Event.ENTER_FRAME, this.textBottonBtnTime);
            this.bottonBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, this.textBottonBtnUp);
        }
        private function textScroll(_arg1:Event):void{
            if (this.Text.maxScrollV != 1){
                visible = true;
                this.slipVar = (this.Text.scrollV / this.Text.maxScrollV);
                this.slipBtn.height = ((this.Text.height / (this.Text.textHeight + 4)) * this.slipHeight);
                this.slipHeight = (((this.bgMc.height - this.slipBtn.height) - this.upBtn.height) - this.bottonBtn.height);
                if (this.Text.scrollV != 1){
                    this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * this.slipVar));
                } else {
                    this.slipBtn.y = (this.bgMc.y + this.upBtn.height);
                };
            } else {
                visible = false;
            };
        }
        private function initPanelScroll():void{
            this.bgMc = new FCanvas();
            addChild(this.bgMc);
            this.bgMc.width = 13;
            this.upBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("UpArrow");
            addChild(this.upBtn);
            upBtn.name = "upBtn";
            this.bottonBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("DownArrow");
            addChild(this.bottonBtn);
            bottonBtn.name = "bottomBtn";
            this.slipBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Thumb");
            addChild(this.slipBtn);
            slipBtn.name = "slipBtn";
            this.scrollMask = new Sprite();
            this.ui.parent.addChild(this.scrollMask);
            this.scrollMask.x = this.ui.x;
            this.scrollMask.y = this.ui.y;
            this.scrollMask.graphics.beginFill(0xFFFFFF);
            this.scrollMask.graphics.drawRect(0, 0, this.ui.width, this.ScrollBarHeight);
            this.scrollMask.graphics.endFill();
            this.ui.mask = this.scrollMask;
            this.uiHeight = (this.ui.height - this.ScrollBarHeight);
            this.bgMc.height = this.ScrollBarHeight;
            this.bottonBtn.y = (this.bgMc.height - this.bottonBtn.height);
            this.slipBtn.y = this.upBtn.height;
            this.slipHeight = (((this.bgMc.height - this.slipBtn.height) - this.upBtn.height) - this.bottonBtn.height);
            visible = false;
            addEventListener(Event.ENTER_FRAME, this.addStageEvent);
        }
        private function textslipBtnDownTime(_arg1:Event):void{
            this.Text.scrollV = Math.round((((this.slipBtn.y - this.upBtn.height) / this.slipHeight) * this.Text.maxScrollV));
        }
        private function textUpBtnUp(_arg1:MouseEvent):void{
            removeEventListener(Event.ENTER_FRAME, this.textUpBtnDownTime);
            this.upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, this.textUpBtnUp);
        }
        private function upBtnDownTime(_arg1:Event):void{
            if ((getTimer() - this.putTime) > 500){
                if ((this.scrollMask.y - this.ui.y) > 10){
                    this.ui.y = (this.ui.y + 10);
                } else {
                    this.ui.y = this.scrollMask.y;
                };
                if ((this.scrollMask.y - this.ui.y) > 0){
                    this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * ((this.scrollMask.y - this.ui.y) / this.uiHeight)));
                } else {
                    this.slipBtn.y = (this.bgMc.y + this.upBtn.height);
                };
            };
        }
        private function slipUp(_arg1:MouseEvent):void{
            this.slipBtn.stopDrag();
            this.slipBtn.stage.removeEventListener(Event.ENTER_FRAME, this.slipBtnDownTime);
            this.slipBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, this.slipUp);
        }
        private function bottonBtnTime(_arg1:Event):void{
            if ((getTimer() - this.putTime) > 500){
                if ((this.scrollMask.y - this.ui.y) < (this.uiHeight - 10)){
                    this.ui.y = (this.ui.y - 10);
                } else {
                    this.ui.y = (this.scrollMask.y - this.uiHeight);
                };
                this.slipBtn.y = ((this.bgMc.y + this.upBtn.height) + (this.slipHeight * ((this.scrollMask.y - this.ui.y) / this.uiHeight)));
            };
        }

    }
}//package GameUI.View.OhterUI.scroll 
