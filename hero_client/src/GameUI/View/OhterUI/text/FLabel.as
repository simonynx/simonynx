//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.text {
    import flash.text.*;

    public class FLabel extends TextField {

        private var tf:TextFormat;

        public function FLabel(){
            mouseWheelEnabled = false;
            selectable = false;
            this.tf = new TextFormat();
            this.tf.font = LanguageMgr.DEFAULT_FONT;
            this.tf.color = 0xFFFFFF;
            this.tf.size = 12;
            defaultTextFormat = this.tf;
        }
        override public function set htmlText(_arg1:String):void{
            this.htmlText = _arg1;
        }
        override public function set text(_arg1:String):void{
            if (_arg1){
                super.text = _arg1;
            } else {
                super.text = "";
            };
            width = (textWidth + 4);
            height = (textHeight + 4);
            y = -1;
        }

    }
}//package GameUI.View.OhterUI.text 
