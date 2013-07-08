//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import flash.ui.*;

    public class HConfirmFrame extends HFrame {

        public static var OK_LABEL:String = "确 定";
        public static var CANCEL_LABEL:String = "取 消";

        protected var _cancelBtn:HLabelButton;
        protected var tFormat:TextFormat;
        private var _cancelFunction:Function;
        public var stopKeyEvent:Boolean = false;
        private var _buttonContainer:Sprite;
        private var _buttonGape:Number = 50;
        protected var _contentTextField:TextField;
        protected var _okBtn:HLabelButton;
        private var _autoClearn:Boolean = true;
        private var _okFunction:Function;
        private var _showCancel:Boolean;

        public function HConfirmFrame(){
            _buttonContainer = new Sprite();
            _okBtn = new HLabelButton();
            _okBtn.label = OK_LABEL;
            _cancelBtn = new HLabelButton();
            _cancelBtn.label = CANCEL_LABEL;
            _buttonContainer.addChild(_okBtn);
            _buttonContainer.addChild(_cancelBtn);
            addChild(_buttonContainer);
            _contentTextField = new TextField();
            tFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFFFF, false);
            tFormat.leading = 5;
            _contentTextField.defaultTextFormat = tFormat;
            _contentTextField.mouseEnabled = false;
            _contentTextField.filters = [new GlowFilter(0, 1, 3, 3, 3)];
            _contentTextField.autoSize = "left";
            _contentTextField.text = "";
            addChild(_contentTextField);
            initEvent();
        }
        public function get cancelBtn():HLabelButton{
            return (_cancelBtn);
        }
        public function get fireEvent():Boolean{
            return (_fireEvent);
        }
        public function set buttonGape(_arg1:Number):void{
            _buttonGape = _arg1;
            _cancelBtn.x = (_buttonGape + _okBtn.width);
            center();
        }
        public function get okBtnEnable():Boolean{
            return (_okBtn.enable);
        }
        public function set okBtnEnable(_arg1:Boolean):void{
            this._okBtn.enable = _arg1;
        }
        override public function removeActiveEvent():void{
            super.removeActiveEvent();
            _okBtn.removeEventListener(MouseEvent.CLICK, __ok);
            _cancelBtn.removeEventListener(MouseEvent.CLICK, __cancel);
            removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownd);
        }
        public function get cancelLabel():String{
            return (_cancelBtn.label);
        }
        override public function dispose():void{
            super.dispose();
            removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownd);
            if (_okBtn){
                _okBtn.removeEventListener(MouseEvent.CLICK, __ok);
                if (_okBtn.parent){
                    _okBtn.parent.removeChild(_okBtn);
                };
                _okBtn.dispose();
            };
            _okBtn = null;
            if (_cancelBtn){
                _cancelBtn.removeEventListener(MouseEvent.CLICK, __cancel);
                if (_cancelBtn.parent){
                    _cancelBtn.parent.removeChild(_cancelBtn);
                };
                _cancelBtn.dispose();
            };
            _cancelBtn = null;
            _okFunction = null;
            _cancelFunction = null;
        }
        public function set autoClearn(_arg1:Boolean):void{
            _autoClearn = _arg1;
        }
        public function set okFunction(_arg1:Function):void{
            _okFunction = _arg1;
        }
        public function set showCancel(_arg1:Boolean):void{
            _showCancel = _arg1;
            if (_showCancel){
                _buttonContainer.addChild(_cancelBtn);
            } else {
                if (_cancelBtn.parent){
                    _cancelBtn.parent.removeChild(_cancelBtn);
                };
            };
            buttonGape = _buttonGape;
        }
        public function set cancelLabel(_arg1:String):void{
            _cancelBtn.label = _arg1;
        }
        private function __ok(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            if (_okFunction != null){
                _okFunction();
            } else {
                if (_autoClearn){
                    hide();
                };
            };
        }
        override protected function __removeToStage(_arg1:Event):void{
            super.__removeToStage(_arg1);
            removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownd);
        }
        protected function __onKeyDownd(_arg1:KeyboardEvent):void{
            if (stopKeyEvent){
                _arg1.stopImmediatePropagation();
            };
            if (_arg1.keyCode == Keyboard.ENTER){
                if (_okBtn.enable){
                    if (_okFunction != null){
                        _okFunction();
                    };
                };
            } else {
                if (_arg1.keyCode == Keyboard.ESCAPE){
                    if (_cancelBtn.enable){
                        if (_cancelFunction != null){
                            _cancelFunction();
                        } else {
                            hide();
                        };
                    };
                };
            };
        }
        public function set cancelBtnEnable(_arg1:Boolean):void{
            this._cancelBtn.enable = _arg1;
        }
        override protected function __closeClick(_arg1:MouseEvent):void{
            super.__closeClick(_arg1);
        }
        public function hide():void{
            if (parent){
                parent.removeChild(this);
            };
        }
        override public function addActiveEvent():void{
            super.addActiveEvent();
            _okBtn.addEventListener(MouseEvent.CLICK, __ok);
            _cancelBtn.addEventListener(MouseEvent.CLICK, __cancel);
            addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownd);
        }
        public function get okFunction():Function{
            return (_okFunction);
        }
        override public function center():void{
            super.center();
            _contentTextField.x = int(((frameWidth - _contentTextField.width) / 2));
            _contentTextField.y = int(((frameHeight - 45) / 2));
            _buttonContainer.y = ((frameHeight - _buttonContainer.height) - 6);
            _buttonContainer.x = int(((frameWidth - _buttonContainer.width) / 2));
        }
        public function get autoClearn():Boolean{
            return (_autoClearn);
        }
        private function __cancel(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            if (_cancelFunction != null){
                _cancelFunction();
            } else {
                if (_autoClearn){
                    hide();
                };
            };
        }
        public function set cancelFunction(_arg1:Function):void{
            _cancelFunction = _arg1;
        }
        public function get okBtn():HLabelButton{
            return (_okBtn);
        }
        private function initEvent():void{
            _okBtn.addEventListener(MouseEvent.CLICK, __ok);
            _cancelBtn.addEventListener(MouseEvent.CLICK, __cancel);
        }
        public function set okLabel(_arg1:String):void{
            _okBtn.label = _arg1;
        }
        public function get cancelFunction():Function{
            return (_cancelFunction);
        }
        public function get okLabel():String{
            return (_okBtn.label);
        }
        override protected function __addToStage(_arg1:Event):void{
            super.__addToStage(_arg1);
            addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownd);
        }
        public function removeKeyDown():void{
            removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownd);
        }

    }
}//package GameUI.View.BaseUI 
