//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Depot.Mediator {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class DepotView extends HFrame {

        public var btnOK:HLabelButton;
        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function DepotView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("仓  库");
            centerTitle = true;
            blackGound = false;
            showClose = true;
            x = 294;
            y = 58;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Depot");
            content.x = 10;
            content.y = 40;
            contentSprite.addChild(content);
            setSize(240, 368);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Depot.Mediator 
