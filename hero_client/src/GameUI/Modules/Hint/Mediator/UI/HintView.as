//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Hint.Mediator.UI {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import OopsEngine.Graphics.*;

    public class HintView extends Sprite {

        private var delayNum:uint = 0;
        private var delayID:uint = 0;
        private var delayCount:uint = 4000;
        private var fadeCount:uint = 1000;
        public var Pos:int = 0;
        private var textFeild:TextField = null;
        private var fadeID:uint = 0;
        private var content:String = "";
        private var color:uint = 0xFFFF00;

        public function HintView(_arg1:String, _arg2:uint){
            this.content = _arg1;
            this.color = _arg2;
            this.mouseEnabled = false;
        }
        private function fadeShow():void{
            if (textFeild.alpha <= 0){
                clearInterval(fadeID);
                textFeild.text = "";
                this.removeChild(textFeild);
                textFeild = null;
                this.dispatchEvent(new Event(Event.COMPLETE));
                return;
            };
            textFeild.alpha = (textFeild.alpha - 0.01);
        }
        public function StartShow():void{
            delayID = setInterval(clearShow, delayCount);
            textFeild = new TextField();
            textFeild.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            textFeild.width = 183;
            textFeild.wordWrap = true;
            textFeild.mouseEnabled = false;
            textFeild.selectable = false;
            textFeild.textColor = this.color;
            textFeild.htmlText = content;
            textFeild.autoSize = TextFieldAutoSize.CENTER;
            textFeild.filters = OopsEngine.Graphics.Font.Stroke(0);
            this.addChild(textFeild);
        }
        private function clearShow():void{
            clearInterval(delayID);
            fadeID = setInterval(fadeShow, fadeCount);
        }
        public function dispose():void{
            clearInterval(delayID);
            clearInterval(fadeID);
            if (textFeild){
                if (textFeild.parent){
                    this.removeChild(textFeild);
                };
                textFeild = null;
            };
        }

    }
}//package GameUI.Modules.Hint.Mediator.UI 
