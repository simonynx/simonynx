//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.events.*;
    import flash.display.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;

    public class PanelBase extends Sprite {

        private static const EDGEHEIGHT:Number = 27;
        private static const EDGEWIDTH:Number = 6;
        private static const YPOS:Number = 28;
        private static const XPOS:Number = 10;

        public var content:MovieClip;
        private var container:Sprite;
        public var closeBtn:SimpleButton;
        private var left:Bitmap;
        private var titleWidth:Number;
        private var title:Bitmap;
        private var right:Bitmap;
        private var backWidth:Number;
        private var back:MovieClip;
        private var tf:TextField;
        private var isDrag:Boolean = true;

        public function PanelBase(_arg1:MovieClip, _arg2:Number, _arg3:Number){
            left = new Bitmap();
            right = new Bitmap();
            title = new Bitmap();
            container = new Sprite();
            tf = new TextField();
            super();
            titleWidth = _arg2;
            backWidth = _arg3;
            this.content = _arg1;
            initialize();
        }
        public function canClose(_arg1:Boolean):void{
            closeBtn.mouseEnabled = _arg1;
        }
        protected function initialize():void{
            left.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("Left");
            right.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("Right");
            title.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("Title");
            back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Back");
            closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseBtn");
            initView();
        }
        private function setChildIndexHandler(_arg1:MouseEvent):void{
            if (GameCommonData.GameInstance.GameUI.contains(this)){
                GameCommonData.GameInstance.GameUI.addChild(this);
            };
        }
        private function dragMcMouseUp(_arg1:MouseEvent):void{
            if (isDrag){
                this.stopDrag();
            };
        }
        public function SetTitleTxt(_arg1:String):void{
            tf.defaultTextFormat = fontTf();
            tf.text = _arg1;
            tf.selectable = false;
            tf.mouseEnabled = false;
            tf.width = (tf.textWidth + 10);
            this.addChild(tf);
            tf.x = int(((this.width - tf.textWidth) / 2));
            tf.y = 0;
        }
        private function getView():void{
            getTitleView();
            getLeftAndRight();
            getBackView();
            getBtnView();
            container.addChild(content);
            container.addChild(closeBtn);
            content.x = XPOS;
            content.y = YPOS;
        }
        public function get IsDrag():Boolean{
            return (isDrag);
        }
        private function fontTf():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 17;
            _local1.color = 14333045;
            _local1.font = "STKaiti";
            _local1.align = TextFormatAlign.LEFT;
            return (_local1);
        }
        private function getBackView():void{
            back.x = title.x;
            back.y = ((title.y + title.height) - 2);
            back.alpha = 0.7;
            back.width = title.width;
            back.height = backWidth;
        }
        public function set backVisible(_arg1:Boolean):void{
            back.visible = _arg1;
        }
        public function set topBarVisible(_arg1:Boolean):void{
            left.visible = _arg1;
            right.visible = _arg1;
            title.visible = _arg1;
        }
        private function getLeftAndRight():void{
            left.x = 1;
            right.x = ((left.width + title.width) - 1);
        }
        private function getBtnView():void{
            closeBtn.x = (((title.width + title.x) - closeBtn.width) - 4);
            closeBtn.y = (title.y + 2);
        }
        private function dragMcMouseDown(_arg1:MouseEvent):void{
            if (isDrag){
                this.startDrag();
            };
        }
        private function initView():void{
            this.addChild(container);
            container.addChild(back);
            container.addChild(left);
            container.addChild(right);
            container.addChild(title);
            container.addChild(closeBtn);
            closeBtn.addEventListener(MouseEvent.CLICK, onCloseHandler);
            this.addEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
            getView();
            setDragBar();
        }
        private function getTitleView():void{
            title.x = (left.x + left.width);
            title.width = titleWidth;
        }
        private function onCloseHandler(_arg1:MouseEvent):void{
            if (this.contains(container)){
                SoundManager.PlaySound(SoundList.PANECLOSE);
                this.dispatchEvent(new Event(Event.CLOSE));
            };
        }
        private function gc():void{
            back = null;
            left = null;
            right = null;
            title = null;
            container = null;
            closeBtn = null;
            content = null;
        }
        public function disableClose():void{
            closeBtn.visible = false;
        }
        public function set IsDrag(_arg1:Boolean):void{
            isDrag = _arg1;
        }
        private function setDragBar():void{
            var _local1:Sprite = new Sprite();
            _local1.graphics.beginFill(0xFF00FF);
            _local1.graphics.drawRect(title.x, title.y, ((title.width - closeBtn.width) - 6), title.height);
            _local1.graphics.endFill();
            _local1.alpha = 0;
            this.addChild(_local1);
            _local1.addEventListener(MouseEvent.MOUSE_DOWN, dragMcMouseDown);
            _local1.addEventListener(MouseEvent.MOUSE_UP, dragMcMouseUp);
        }

    }
}//package GameUI.View.BaseUI 
