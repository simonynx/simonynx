//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HTree {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.filters.*;
    import GameUI.View.Components.*;

    public class HTreeCellRenderer extends UISprite {

        private var _isSelected:Boolean = false;
        protected var taskFinishTf:TextField;
        private var des:String;
        private var mouseOverAsset:Bitmap;
        private var remainTime:int;
        private var selectAsset:Bitmap;
        public var id:uint;
        protected var desTf:TextField;
        private var rightColor:String = "#D6C29C";
        public var data:uint;
        private var leftColor:String = "#00FF00";
        private var info:HTreeInfoStruct;

        public function HTreeCellRenderer(_arg1:String, _arg2:Boolean=false, _arg3:uint=0){
            this.mouseEnabled = true;
            this.width = 100;
            this.height = 16;
            this.id = _arg3;
            this.isSelected = _arg2;
            this.des = _arg1;
            this.data = _arg3;
            this.createChildren();
        }
        private function showOverAsset():void{
            mouseOverAsset = new Bitmap(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("shooter.task.accet.TaskCellOverAsset"));
            mouseOverAsset.width = 100;
            mouseOverAsset.height = 16;
            addChild(mouseOverAsset);
        }
        public function get DesTf():TextField{
            return (desTf);
        }
        public function set isSelected(_arg1:Boolean):void{
            this._isSelected = _arg1;
            if (mouseOverAsset){
                if (mouseOverAsset.parent){
                    mouseOverAsset.parent.removeChild(mouseOverAsset);
                };
                mouseOverAsset.bitmapData.dispose();
                mouseOverAsset = null;
            };
            if (this.isSelected){
                showSelectAsset();
            } else {
                removeSelectAsset();
            };
        }
        protected function doLayout():void{
        }
        private function removeOverAsset():void{
            if (mouseOverAsset){
                if (mouseOverAsset.parent){
                    mouseOverAsset.parent.removeChild(mouseOverAsset);
                };
                mouseOverAsset.bitmapData.dispose();
                mouseOverAsset = null;
            };
        }
        private function showSelectAsset():void{
            selectAsset = new Bitmap(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("shooter.task.accet.TaskCellSelectAsset"));
            selectAsset.width = 100;
            selectAsset.height = 16;
            addChild(selectAsset);
        }
        protected function onMouseClickHandler(_arg1:MouseEvent):void{
        }
        protected function onDoubleClickHandler(_arg1:MouseEvent):void{
        }
        public function get isSelected():Boolean{
            return (this._isSelected);
        }
        private function removeSelectAsset():void{
            if (selectAsset){
                if (selectAsset.parent){
                    selectAsset.parent.removeChild(selectAsset);
                };
                selectAsset.bitmapData.dispose();
                selectAsset = null;
            };
        }
        protected function onRollOverHandler(_arg1:MouseEvent):void{
            if (!this.isSelected){
                showOverAsset();
            };
        }
        protected function createChildren():void{
            this.buttonMode = true;
            this.doubleClickEnabled = true;
            this.mouseChildren = true;
            this.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
            this.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandler);
            this.addEventListener(MouseEvent.MOUSE_OVER, onRollOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, onRollOutHandler);
            var _local1:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12);
            this.desTf = new TextField();
            this.desTf.mouseEnabled = false;
            this.desTf.defaultTextFormat = _local1;
            this.desTf.autoSize = TextFieldAutoSize.LEFT;
            this.desTf.type = TextFieldType.DYNAMIC;
            this.desTf.selectable = false;
            this.desTf.filters = [new GlowFilter(0, 1)];
            var _local2:Array = this.des.split("_");
            if (_local2.length == 2){
                this.desTf.htmlText = (((((((((("<font color=\"" + leftColor) + "\">") + _local2[0]) + "</font>") + "<font color=\"") + rightColor) + "\">") + "-") + _local2[1]) + "</font>");
            } else {
                this.desTf.htmlText = (((("<font color=\"" + "#9ADAF8") + "\">") + _local2[0]) + "</font>");
            };
            this.addChild(this.desTf);
            this.doLayout();
        }
        protected function onRollOutHandler(_arg1:MouseEvent):void{
            if (!this.isSelected){
                removeOverAsset();
            };
        }

    }
}//package GameUI.View.HTree 
