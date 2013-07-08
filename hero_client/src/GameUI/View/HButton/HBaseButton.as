//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HButton {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.Content.*;
    import Manager.*;
    import flash.text.*;
    import OopsEngine.Graphics.*;

    public class HBaseButton extends Sprite {

        protected var _container:Sprite;
        protected var _textField:TextField;
        protected var _enable:Boolean = true;
        protected var _bg:DisplayObject;
        protected var _buttonFormat:IButtonFormat;
        protected var _effect:MovieClip;
        protected var _label:String;

        public function HBaseButton(_arg1:DisplayObject, _arg2:String=""){
            _bg = _arg1;
            _label = _arg2;
            init();
        }
        public function get container():DisplayObjectContainer{
            return (_container);
        }
        public function get enable():Boolean{
            return (_enable);
        }
        public function get bg():DisplayObject{
            return (_bg);
        }
        override public function get width():Number{
            return (_bg.width);
        }
        public function get buttonFormat():IButtonFormat{
            return (_buttonFormat);
        }
        protected function creatTextField():TextField{
            _textField = new TextField();
            _textField.autoSize = "left";
            _textField.selectable = false;
            _textField.mouseEnabled = false;
            _textField.text = _label;
            _textField.filters = OopsEngine.Graphics.Font.Stroke(0);
            return (_textField);
        }
        override public function set width(_arg1:Number):void{
            _bg.width = _arg1;
            center();
        }
        public function set enable(_arg1:Boolean):void{
            if (_arg1){
                _buttonFormat.setEnable(this);
                buttonMode = true;
                mouseEnabled = true;
                mouseChildren = true;
                addEvent();
            } else {
                stopEffect();
                _buttonFormat.setNotEnable(this);
                buttonMode = false;
                mouseEnabled = false;
                mouseChildren = false;
                removeEvent();
            };
            _enable = _arg1;
        }
        protected function downHandler(_arg1:MouseEvent):void{
            _buttonFormat.setDownFormat(this);
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "downBtnSound");
        }
        protected function get UILib():ContentTypeReader{
            if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary)){
                return (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary));
            };
            return (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole));
        }
        public function get textField():TextField{
            return (_textField);
        }
        protected function overHandler(_arg1:MouseEvent):void{
            _buttonFormat.setOverFormat(this);
        }
        protected function init():void{
            _container = new Sprite();
            addChild(_container);
            creatButtonFormat();
            _container.addChild(_bg);
            if (_label != ""){
                creatTextField();
                _container.addChild(_textField);
            };
            _buttonFormat.setUpFormat(this);
            buttonMode = true;
            center();
            addEvent();
        }
        override public function set height(_arg1:Number):void{
            _bg.height = _arg1;
            center();
        }
        public function dispose():void{
            removeEvent();
            removeEventListener(MouseEvent.CLICK, clickHandler);
            if (_bg.parent){
                _bg.parent.removeChild(_bg);
            };
            _bg = null;
            _container = null;
            if (_buttonFormat){
                _buttonFormat.dispose();
            };
            _buttonFormat = null;
            if (this.parent){
                this.parent.removeChild(this);
            };
        }
        protected function outHandler(_arg1:MouseEvent):void{
            _buttonFormat.setOutFormat(this);
        }
        public function playEffect():void{
            if (_effect == null){
                _effect = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("FrameEffect");
                _effect.mouseEnabled = false;
                _effect.mouseChildren = false;
                _effect.width = (this.width * 1.2);
                _effect.height = 22;
                _effect.stop();
            };
            if (_effect.parent == null){
                this.addChild(_effect);
            };
            _effect.play();
        }
        override public function get height():Number{
            return (_bg.height);
        }
        protected function clickHandler(_arg1:MouseEvent):void{
            if (!enable){
                _arg1.stopImmediatePropagation();
            };
        }
        public function center():void{
            if (_textField){
                _textField.x = int((((_bg.x + _bg.width) - _textField.width) / 2));
                _textField.y = int((((_bg.y + _bg.height) - _textField.height) / 2));
            };
        }
        protected function upHandler(_arg1:MouseEvent):void{
            _buttonFormat.setUpFormat(this);
        }
        protected function creatButtonFormat():void{
            _buttonFormat = new SimpleButtonFormat();
        }
        public function stopEffect():void{
            if (((_effect) && (_effect.parent))){
                _effect.parent.removeChild(_effect);
                _effect.stop();
            };
        }
        public function get label():String{
            return (_label);
        }
        protected function removeEvent():void{
            removeEventListener(MouseEvent.ROLL_OVER, overHandler);
            removeEventListener(MouseEvent.ROLL_OUT, outHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            removeEventListener(MouseEvent.MOUSE_UP, upHandler);
        }
        public function set label(_arg1:String):void{
            if (_textField){
                _textField.text = _arg1;
                _label = _arg1;
            };
            center();
        }
        protected function addEvent():void{
            addEventListener(MouseEvent.ROLL_OVER, overHandler);
            addEventListener(MouseEvent.ROLL_OUT, outHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            addEventListener(MouseEvent.MOUSE_UP, upHandler);
            addEventListener(MouseEvent.CLICK, clickHandler);
        }
        public function addIcon(_arg1:DisplayObject, _arg2:int=0, _arg3:int=0):void{
            _container.addChild(_arg1);
        }
        public function set useBackgoundPos(_arg1:Boolean):void{
            if (_arg1){
                this.x = int(_bg.x);
                this.y = int(_bg.y);
                _bg.x = 0;
                _bg.y = 0;
                center();
            };
        }

    }
}//package GameUI.View.HButton 
