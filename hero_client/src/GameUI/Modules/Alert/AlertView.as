//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Alert {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class AlertView extends HFrame {

        private var textformat:TextFormat;
        private var contentBackBoard:MovieClip;
        private var bitmap:Bitmap;
        public var btnComfrim:HLabelButton;
        public var btnCancel:HLabelButton;
        public var txtparent:Sprite;
        public var txtInfo:TextField;

        public function AlertView(_arg1:Boolean=false){
            btnComfrim = new HLabelButton();
            btnCancel = new HLabelButton();
            txtInfo = new TextField();
            super();
            initView(_arg1);
        }
        public function updateBackBoardLayout():void{
        }
        public function set txtComfrim(_arg1:String):void{
            btnComfrim.label = _arg1;
        }
        private function initView(_arg1:Boolean):void{
            txtparent = new Sprite();
            this.addChild(txtparent);
            if (_arg1){
                textformat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
            } else {
                textformat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
            };
            textformat.leading = 4;
            txtInfo.defaultTextFormat = textformat;
            if (_arg1){
                txtInfo.autoSize = TextFieldAutoSize.LEFT;
                bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("Warning");
                addChild(bitmap);
                bitmap.x = 10;
                bitmap.y = 40;
                txtInfo.wordWrap = true;
                txtInfo.x = 50;
                txtInfo.width = 235;
            } else {
                txtInfo.autoSize = TextFieldAutoSize.CENTER;
                txtInfo.width = 290;
            };
            txtInfo.multiline = true;
            txtInfo.wordWrap = false;
            txtInfo.mouseEnabled = false;
            this.addChild(btnComfrim);
            this.addChild(btnCancel);
            txtparent.addChild(txtInfo);
            titleText = "提示";
            centerTitle = true;
            blackGound = false;
            showClose = false;
        }
        public function set txtCancel(_arg1:String):void{
            btnCancel.label = _arg1;
        }
        override public function dispose():void{
            if (bitmap){
                removeChild(bitmap);
            };
            bitmap = null;
            btnComfrim.dispose();
            btnComfrim = null;
            btnCancel.dispose();
            btnCancel = null;
        }

    }
}//package GameUI.Modules.Alert 
