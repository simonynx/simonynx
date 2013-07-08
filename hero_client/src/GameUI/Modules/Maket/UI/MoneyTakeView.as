//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.UI {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class MoneyTakeView extends HFrame {

        public var btnFillMoney:HLabelButton;
        public var btnTake:HLabelButton;
        public var btnMax:HLabelButton;
        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function MoneyTakeView(){
            initView();
        }
        public function resetPos():void{
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("金叶子提取");
            centerTitle = true;
            blackGound = true;
            showClose = true;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MoneyExchange");
            content.x = 8;
            content.y = 40;
            contentSprite.addChild(content);
            setSize((235 + 40), (118 + 50));
            btnMax = new HLabelButton();
            btnMax.name = "btnMax";
            btnMax.label = LanguageMgr.GetTranslation("最大");
            btnMax.x = 210;
            btnMax.y = 73;
            contentSprite.addChild(btnMax);
            btnTake = new HLabelButton();
            btnTake.name = "btnTake";
            btnTake.label = LanguageMgr.GetTranslation("提取");
            btnTake.x = 80;
            btnTake.y = 110;
            contentSprite.addChild(btnTake);
            btnFillMoney = new HLabelButton();
            btnFillMoney.name = "btnFillMoney";
            btnFillMoney.label = LanguageMgr.GetTranslation("充值");
            btnFillMoney.x = 150;
            btnFillMoney.y = 110;
            contentSprite.addChild(btnFillMoney);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Maket.UI 
