//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Stall.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;

    public class StallView extends HFrame {

        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function StallView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("摆  摊");
            centerTitle = true;
            blackGound = false;
            showClose = true;
            x = 226;
            y = 50;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Stall");
            content.x = 15;
            content.y = 40;
            contentSprite.addChild(content);
            setSize(250, 484);
            UIUtils.ReplaceButtonNTextFieldToButton(content, LanguageMgr.GetTranslation("收摊"), "btnCloseStall");
            UIUtils.ReplaceButtonNTextFieldToButton(content, LanguageMgr.GetTranslation("私聊"), "btnPrivate");
            UIUtils.ReplaceButtonNTextFieldToButton(content, LanguageMgr.GetTranslation("摆摊"), "btnStartStall");
            UIUtils.ReplaceButtonNTextFieldToButton(content, LanguageMgr.GetTranslation("清空"), "btnClearStall");
            UIUtils.ReplaceButtonNTextFieldToButton(content.content23, LanguageMgr.GetTranslation("出售"), "btnSell");
            UIUtils.ReplaceButtonNTextFieldToButton(content.content13, LanguageMgr.GetTranslation("购买"), "btnBuy");
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Stall.Mediator 
