//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.QuickBuy.Mediator {
    import flash.display.*;
    import GameUI.View.BaseUI.*;

    public class QuickBuyView extends HConfirmFrame {

        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function QuickBuyView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("快速购买");
            centerTitle = true;
            blackGound = true;
            showClose = true;
            showCancel = false;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("QuickBuy");
            content.x = 4;
            content.y = 31;
            contentSprite.addChild(content);
            setSize((content.width + 8), (content.height + 66));
            x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (content.width / 2));
            y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (content.height / 2));
            addContent(contentSprite);
            okLabel = "购买";
        }

    }
}//package GameUI.Modules.QuickBuy.Mediator 
