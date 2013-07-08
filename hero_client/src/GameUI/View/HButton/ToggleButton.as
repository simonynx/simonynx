//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HButton {
    import flash.events.*;
    import flash.display.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.View.*;
    import OopsEngine.Graphics.*;

    public class ToggleButton extends Sprite {

        private var posX:int = 0;
        private var bg:MovieClip;
        private var posY:int = 0;
        private var _textField:TextField;
        private var _label:String;
        private var _selected:Boolean;

        public function ToggleButton(_arg1:int=0, _arg2:String=".."){
            if (_arg1 == 0){
                bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToggleButtonMc");
            } else {
                if (_arg1 == 1){
                    bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToggleButtonMc2");
                } else {
                    if (_arg1 == 2){
                        bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToggleButtonMc3");
                    } else {
                        if (_arg1 == 3){
                            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToggleButtonMc4");
                        };
                    };
                };
            };
            _label = _arg2;
            this.addChild(bg);
            (bg as MovieClip).gotoAndStop(2);
            creatTextField();
            mouseChildren = false;
        }
        public function textGape(_arg1:int, _arg2:int):void{
            posX = _arg1;
            posY = _arg2;
            center();
        }
        public function set enable(_arg1:Boolean):void{
            if (!_arg1){
                this.filters = [ColorFilters.BWFilter];
                this.mouseEnabled = false;
                this.mouseChildren = false;
            } else {
                this.filters = null;
                this.mouseEnabled = true;
                this.mouseChildren = true;
            };
        }
        private function creatTextField():void{
            _textField = new TextField();
            _textField.autoSize = "left";
            _textField.selectable = false;
            _textField.mouseEnabled = false;
            _textField.text = _label;
            _textField.textColor = 250597;
            var _local1:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            _textField.defaultTextFormat = _local1;
            _textField.filters = OopsEngine.Graphics.Font.Stroke(0);
            this.addChild(_textField);
            textGape(0, 0);
        }
        public function center():void{
            if (_textField){
                _textField.x = ((bg.x + ((bg.width - _textField.width) / 2)) + posX);
                _textField.y = ((bg.y + ((bg.height - _textField.height) / 2)) + posY);
            };
        }
        public function set selected(_arg1:Boolean):void{
            if (_selected != _arg1){
                _selected = _arg1;
                if (_selected){
                    (bg as MovieClip).gotoAndStop(1);
                    _textField.textColor = 16496146;
                    SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
                } else {
                    (bg as MovieClip).gotoAndStop(2);
                    _textField.textColor = 250597;
                };
                dispatchEvent(new Event(Event.SELECT));
            };
        }
        public function get selected():Boolean{
            return (_selected);
        }
        public function setBgWidth(_arg1:uint):void{
            bg.width = _arg1;
        }

    }
}//package GameUI.View.HButton 
