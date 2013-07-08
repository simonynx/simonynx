//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.View {
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.Components.*;
    import OopsEngine.Graphics.*;

    public class NPCDialogPanel extends UISprite {

        public static const UPDATE_DES_TEXT:String = "updateaDesText";
        public static const UPDATE_CELL_TEXT:String = "updateCellText";
        public static const UPDATE_ALL:String = "updateAll";

        public var onLinkClick:Function;
        protected var cells:Array;
        private var _dataProvider:Array;
        protected var describeTf:TextField;
        private var _desStr:String;
        private var topGoldLine:Bitmap;
        protected var updateHash:Dictionary;
        private var bottomGoldLine:Bitmap;

        public function NPCDialogPanel(){
            cells = [];
            super();
            this.createChildren();
        }
        public function set desStr(_arg1:String):void{
            this._desStr = _arg1;
            updateHash[UPDATE_DES_TEXT] = true;
            this.toRepaint();
        }
        public function get desStr():String{
            return (this._desStr);
        }
        protected function toRepaint():void{
            var _local1:Dictionary = this.updateHash;
            this.updateHash = new Dictionary();
            if (_local1[UPDATE_ALL]){
                _local1[UPDATE_DES_TEXT] = true;
                _local1[UPDATE_CELL_TEXT] = true;
            };
            if (_local1[UPDATE_DES_TEXT]){
                this.describeTf.htmlText = this.desStr;
            };
            if (_local1[UPDATE_CELL_TEXT]){
                this.removeAll();
                this.createCells();
            };
            this.doLayout();
        }
        protected function doLayout():void{
            var _local1:LinkCell;
            this.describeTf.x = 0;
            this.describeTf.y = 5;
            var _local2:Number = (this.describeTf.height + 15);
            if (topGoldLine){
                topGoldLine.y = _local2;
                topGoldLine.width = 230;
                _local2 = (_local2 + 10);
            };
            for each (_local1 in this.cells) {
                _local1.y = _local2;
                _local2 = (_local2 + (_local1.height + 10));
            };
            this.width = 230;
            this.height = (_local2 + 20);
        }
        protected function createChildren():void{
            this.describeTf = new TextField();
            this.describeTf.width = 210;
            this.describeTf.multiline = true;
            this.describeTf.type = TextFieldType.DYNAMIC;
            describeTf.wordWrap = true;
            this.describeTf.autoSize = TextFieldAutoSize.LEFT;
            this.describeTf.filters = OopsEngine.Graphics.Font.Stroke();
            this.describeTf.defaultTextFormat = this.getTextFormat();
            this.describeTf.selectable = false;
            this.describeTf.mouseEnabled = false;
            this.addChild(this.describeTf);
            if (((!((this.desStr == null))) && (!((this.desStr == ""))))){
                this.describeTf.htmlText = this.desStr;
            };
            var _local1:BitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("GoldLine");
            topGoldLine = new Bitmap(_local1);
            topGoldLine.x = -19;
            this.addChild(topGoldLine);
            if (((!((this._dataProvider == null))) && ((this._dataProvider.length > 0)))){
                this.createCells();
            };
            this.updateHash = new Dictionary();
            this.doLayout();
        }
        protected function createCells():void{
            var _local1:Object;
            var _local2:LinkCell;
            for each (_local1 in this._dataProvider) {
                _local2 = new LinkCell(_local1.iconUrl, _local1.EventID, _local1.linkId, _local1.showText, _local1.type, _local1.code, _local1.boxmessage);
                _local2.onLinkClick = this.onLinkClick;
                cells.push(_local2);
                this.addChild(_local2);
            };
        }
        public function set dataProvider(_arg1:Array):void{
            this._dataProvider = _arg1;
            updateHash[UPDATE_CELL_TEXT] = true;
            this.toRepaint();
        }
        protected function getTextFormat():TextFormat{
            var _local1:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            _local1.leading = 5;
            return (_local1);
        }
        public function get dataProvider():Array{
            return (this._dataProvider);
        }
        protected function removeAll():void{
            var _local1:LinkCell;
            for each (_local1 in this.cells) {
                if (this.contains(_local1)){
                    this.removeChild(_local1);
                };
            };
            cells = [];
        }

    }
}//package GameUI.Modules.NPCChat.View 
