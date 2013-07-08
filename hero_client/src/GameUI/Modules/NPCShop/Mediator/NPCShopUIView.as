//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCShop.Mediator {
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class NPCShopUIView extends HFrame {

        public var content:MovieClip;
        public var btnSale:HLabelButton;
        public var btnBuy:HLabelButton;
        public var btnFrontPage:HLabelButton;
        public var btnBackPage:HLabelButton;
        private var contentSprite:Sprite;

        public function NPCShopUIView(_arg1:String){
            initView(_arg1);
        }
        private function initView(_arg1:String):void{
            centerTitle = true;
            blackGound = false;
            titleActive = true;
            titleText = _arg1;
            x = UIConstData.DefaultPos1.x;
            y = UIConstData.DefaultPos1.y;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("NPCShopView");
            content.x = 10;
            content.y = 32;
            contentSprite.addChild(content);
            setSize(333, 500);
            btnFrontPage = new HLabelButton(2);
            btnFrontPage.label = LanguageMgr.GetTranslation("上页");
            btnFrontPage.name = "btnFrontPage";
            btnFrontPage.x = 95;
            btnFrontPage.y = 288;
            contentSprite.addChild(btnFrontPage);
            btnBackPage = new HLabelButton(2);
            btnBackPage.label = LanguageMgr.GetTranslation("下页");
            btnBackPage.name = "btnBackPage";
            btnBackPage.x = 183;
            btnBackPage.y = 288;
            contentSprite.addChild(btnBackPage);
            btnBuy = new HLabelButton();
            btnBuy.label = LanguageMgr.GetTranslation("购买");
            btnBuy.name = "btnBuy";
            btnBuy.x = 265;
            btnBuy.y = 360;
            contentSprite.addChild(btnBuy);
            btnSale = new HLabelButton();
            btnSale.label = LanguageMgr.GetTranslation("出售");
            btnSale.name = "btnSale";
            btnSale.x = 265;
            btnSale.y = 461;
            contentSprite.addChild(btnSale);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.NPCShop.Mediator 
