//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;

    public class MenuItemCell extends Sprite {

        public var content:MovieClip;
        public var data:Object;

        public function MenuItemCell(){
            data = {};
            super();
            this.buttonMode = true;
            this.content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MenuItemRenderer");
            this.addChild(this.content);
            (this.content.txt_name as TextField).mouseEnabled = false;
            this.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutHandler);
        }
        public function setText(_arg1:String):void{
            (this.content.txt_name as TextField).text = _arg1;
        }
        protected function onMouseRollOverHandler(_arg1:MouseEvent):void{
        }
        protected function onMouseRollOutHandler(_arg1:MouseEvent):void{
        }

    }
}//package GameUI.Modules.Friend.view.ui 
