//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.View {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.Components.*;

    public class NpcChatTaskNextLink extends UISprite {

        public var linkTf:TextField;
        public var linkBuff:MovieClip;
        private var mouseOverAsset:MovieClip;

        public function NpcChatTaskNextLink(){
            initView();
        }
        private function __mouseOutHandler(_arg1:MouseEvent):void{
            if (((mouseOverAsset) && (mouseOverAsset.parent))){
                mouseOverAsset.parent.removeChild(mouseOverAsset);
            };
        }
        public function reSetTextFormat():void{
            this.linkTf.defaultTextFormat = textFormat;
        }
        private function get textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.color = 16776513;
            _local1.size = 15;
            return (_local1);
        }
        override public function set visible(_arg1:Boolean):void{
            super.visible = _arg1;
            if (linkBuff){
                if (_arg1){
                    linkBuff.gotoAndPlay(1);
                } else {
                    linkBuff.gotoAndStop(1);
                };
            };
        }
        public function set htmlText(_arg1:String):void{
            this.linkTf.htmlText = _arg1;
        }
        private function __mouseOverHandler(_arg1:MouseEvent):void{
            this.addChildAt(mouseOverAsset, 0);
        }
        private function initView():void{
            linkBuff = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LinkCellBuff");
            linkBuff.mouseEnabled = false;
            linkBuff.x = -25;
            linkBuff.y = 9;
            linkBuff.gotoAndStop(1);
            this.addChild(linkBuff);
            this.linkTf = new TextField();
            this.linkTf.defaultTextFormat = textFormat;
            this.linkTf.autoSize = TextFieldAutoSize.CENTER;
            this.linkTf.selectable = false;
            linkTf.mouseEnabled = false;
            linkTf.x = 50;
            this.addChild(this.linkTf);
            this.width = 250;
            this.height = 25;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
            mouseOverAsset = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LinkCellLightAsset");
            mouseOverAsset.x = -50;
            addChildAt(mouseOverAsset, 0);
            mouseOverAsset.width = this.width;
            mouseOverAsset.mouseEnabled = false;
            mouseOverAsset.mouseChildren = false;
        }
        public function get htmlText():String{
            return (linkTf.htmlText);
        }

    }
}//package GameUI.Modules.NPCChat.View 
