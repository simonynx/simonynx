//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ChangeLine.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.Modules.ChangeLine.Data.*;

    public class ChgListCell extends Sprite {

        private var content_txt:TextField;
        public var gsName:String = "";
        private var isFull:String;
        private var content_mc:MovieClip;
        private var format:TextFormat;
        public var sIndex:int;

        public function ChgListCell(_arg1:int, _arg2:String){
            sIndex = _arg1;
            isFull = _arg2;
            initUI();
        }
        private function initUI():void{
            this.content_mc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MenuItemRenderer");
            content_mc.width = 89;
            this.addChild(content_mc);
            content_mc.txt_name.mouseEnabled = false;
            content_mc.txt_name.autoSize = TextFieldAutoSize.LEFT;
            content_mc.txt_name.htmlText = (ChgLineData.getNameByIndex(sIndex) + isFull);
            content_mc.txt_name.x = 10;
            content_mc.txt_name.y = 2;
        }

    }
}//package GameUI.Modules.ChangeLine.View 
