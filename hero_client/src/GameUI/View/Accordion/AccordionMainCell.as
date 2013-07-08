//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.Accordion {
    import flash.display.*;

    public class AccordionMainCell extends Sprite implements IAccordionMainCell {

        public var bg:MovieClip;
        private var idx:int;

        public function AccordionMainCell(_arg1:int){
            this.idx = _arg1;
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("AccordionMainClassAsset");
            bg.titleTF.mouseEnabled = false;
            this.buttonMode = true;
            addChild(bg);
        }
        public function dispose():void{
        }
        public function set title(_arg1:String):void{
            bg.titleTF.text = _arg1;
        }
        public function get Tips():String{
            return ("");
        }
        public function set param(_arg1:Object):void{
        }

    }
}//package GameUI.View.Accordion 
