//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HButton {
    import flash.events.*;
    import flash.display.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.View.*;
    import flash.filters.*;
    import OopsEngine.Graphics.*;

    public class HCheckBox extends Sprite {

        private var tipSprite:Sprite;
        private var _displayCheck:MovieClip;
        private var _tipString:String;
        private var _textField:TextField;
        private var _displayText:DisplayObject;
        private var _select:Boolean;
        private var myColorMatrix_filter:ColorMatrixFilter;
        private var _enable:Boolean = true;
        private var _fireAuto:Boolean = false;
        private var _label:String = "";
        private var _lableGape:Number;
        private var _tipField:TextField;

        public function HCheckBox(_arg1:String="checkBox", _arg2:DisplayObject=null, _arg3:MovieClip=null){
            var _local4:Array;
            super();
            buttonMode = true;
            _label = _arg1;
            _displayText = _arg2;
            _displayCheck = _arg3;
            if (_displayCheck == null){
                _displayCheck = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("CheckBoxView");
                _displayCheck.mouseEnabled = false;
            };
            addChild(_displayCheck);
            _displayCheck.gotoAndStop(1);
            if (_displayText == null){
                _textField = creatTextField();
                _textField.text = _label;
                _textField.setTextFormat(new TextFormat(null, 12, 14074524));
                _textField.filters = OopsEngine.Graphics.Font.Stroke(0);
                addChild(_textField);
            } else {
                addChild(_displayText);
            };
            tipSprite = new Sprite();
            _tipField = creatTextField();
            _tipField.defaultTextFormat = new TextFormat(null, 13, 14074524);
            _tipField.filters = OopsEngine.Graphics.Font.Stroke(0);
            tipSprite.addChild(_tipField);
            tipSprite.visible = false;
            addEventListener(MouseEvent.CLICK, onClick);
            addEventListener(MouseEvent.ROLL_OVER, onRollOver);
            addEventListener(MouseEvent.ROLL_OUT, onRollOut);
            labelGape = 10;
            drawRect();
            addChild(tipSprite);
            myColorMatrix_filter = new ColorMatrixFilter(_local4);
        }
        public function get enable():Boolean{
            return (_enable);
        }
        public function set labelGape(_arg1:Number):void{
            _lableGape = _arg1;
            postion();
            drawRect();
        }
        private function creatTextField():TextField{
            var _local1:* = new TextField();
            _local1.autoSize = "left";
            _local1.selectable = false;
            _local1.mouseEnabled = false;
            return (_local1);
        }
        public function get fireAuto():Boolean{
            return (_fireAuto);
        }
        private function drawRect():void{
            if (tipSprite.parent){
                removeChild(tipSprite);
            };
            graphics.clear();
            graphics.beginFill(0xFF00FF, 0);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
        }
        public function set textFilter(_arg1:Array):void{
            _textField.filters = _arg1;
        }
        public function get textField():TextField{
            return (_textField);
        }
        public function set enable(_arg1:Boolean):void{
            _enable = _arg1;
            if (_arg1){
                filters = null;
                _displayCheck.gotoAndStop(1);
            } else {
                filters = [ColorFilters.BWFilter];
                _displayCheck.gotoAndStop(3);
            };
        }
        public function set textFormat(_arg1:TextFormat):void{
            _textField.setTextFormat(_arg1);
        }
        public function set selected(_arg1:Boolean):void{
            if (_select != _arg1){
                _select = _arg1;
                dispatchEvent(new Event(Event.CHANGE));
            };
            if (_select){
                _displayCheck.gotoAndStop(2);
                SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "downBtnSound");
            } else {
                _displayCheck.gotoAndStop(1);
            };
        }
        public function set fireAuto(_arg1:Boolean):void{
            _fireAuto = _arg1;
        }
        public function get selected():Boolean{
            return (_select);
        }
        public function get tipField():TextField{
            return (_tipField);
        }
        public function set label(_arg1:String):void{
            _textField.text = _arg1;
            _textField.setTextFormat(new TextFormat(null, 12, 14074524));
            _textField.filters = OopsEngine.Graphics.Font.Stroke(0);
        }
        private function onClick(_arg1:MouseEvent):void{
            if (!enable){
                _arg1.stopImmediatePropagation();
            } else {
                if (_fireAuto){
                    selected = !(selected);
                };
            };
        }
        public function dispose():void{
            removeEventListener(MouseEvent.CLICK, onClick);
            removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
            removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
            _displayText = null;
            _displayCheck = null;
            _textField = null;
            myColorMatrix_filter = null;
        }
        public function postion():void{
            if (_displayText){
                _displayText.x = ((_displayCheck.x + _displayCheck.width) + _lableGape);
            };
            if (_textField){
                _textField.x = ((_displayCheck.x + _displayCheck.width) + _lableGape);
                _textField.y = ((_displayCheck.height - _textField.height) / 2);
            };
            tipSprite.x = ((width - tipSprite.width) / 2);
            tipSprite.y = (-(tipSprite.height) - 5);
        }
        public function set tips(_arg1:String):void{
            _tipString = _arg1;
            _tipField.text = _tipString;
            tipSprite.graphics.clear();
            tipSprite.graphics.beginFill(0, 0.8);
            tipSprite.graphics.drawRoundRect(-3, -3, (_tipField.width + 6), (_tipField.height + 6), 3, 3);
            postion();
        }
        private function onRollOut(_arg1:MouseEvent):void{
            tipSprite.visible = false;
        }
        private function onRollOver(_arg1:MouseEvent):void{
            if (_tipString != ""){
                tipSprite.visible = true;
                GameCommonData.GameInstance.TooltipLayer.addChild(tipSprite);
                tipSprite.x = (_arg1.stageX + 10);
                tipSprite.y = (_arg1.stageY - 30);
            };
        }
        private function setUpGrayFilter():void{
            var _local1:Array;
            myColorMatrix_filter = new ColorMatrixFilter(_local1);
        }

    }
}//package GameUI.View.HButton 
