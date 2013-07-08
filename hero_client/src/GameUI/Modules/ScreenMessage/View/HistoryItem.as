//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.display.*;
    import flash.text.*;
    import OopsEngine.Graphics.*;

    public class HistoryItem extends Sprite {

        private var msg:String;
        private var _textTime:TextField;
        private var _textInfo:TextField;

        public function HistoryItem(_arg1:String){
            msg = _arg1;
            init();
            super();
        }
        private function init():void{
            var _local2:String;
            var _local3:String;
            var _local4:String;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            var _local1:Date = new Date();
            _textTime = new TextField();
            _textTime.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            _textTime.mouseEnabled = false;
            _textTime.selectable = false;
            _textTime.textColor = 15728217;
            _textTime.autoSize = TextFieldAutoSize.LEFT;
            _textTime.filters = OopsEngine.Graphics.Font.Stroke(0);
            if (_local1.hours > 9){
                _local2 = String(_local1.hours);
            } else {
                _local2 = ("0" + String(_local1.hours));
            };
            if (_local1.minutes > 9){
                _local3 = String(_local1.minutes);
            } else {
                _local3 = ("0" + String(_local1.minutes));
            };
            if (_local1.seconds > 9){
                _local4 = String(_local1.seconds);
            } else {
                _local4 = ("0" + String(_local1.seconds));
            };
            _textTime.text = (((((("[" + _local2) + ":") + _local3) + ":") + _local4) + "]");
            this.addChild(_textTime);
            _textInfo = new TextField();
            _textInfo.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            _textInfo.mouseEnabled = false;
            _textInfo.selectable = false;
            _textInfo.textColor = 0xFFFFFF;
            _textInfo.autoSize = TextFieldAutoSize.LEFT;
            _textInfo.filters = OopsEngine.Graphics.Font.Stroke(0);
            _textInfo.htmlText = msg;
            _textInfo.wordWrap = true;
            this.addChild(_textInfo);
            _textInfo.x = 65;
            _textInfo.width = 215;
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
