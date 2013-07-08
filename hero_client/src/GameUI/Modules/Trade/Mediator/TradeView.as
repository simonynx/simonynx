//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Trade.Mediator {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class TradeView extends HFrame {

        public var btnInputMoney:HLabelButton;
        public var btnLock:HLabelButton;
        public var btnSure:HLabelButton;
        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function TradeView(){
            initView();
        }
        private function initView():void{
            titleText = "交  易";
            centerTitle = true;
            blackGound = false;
            showClose = true;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Trade");
            content.x = 7;
            content.y = 40;
            contentSprite.addChild(content);
            setSize((content.width + 20), (content.height + 55));
            btnInputMoney = new HLabelButton();
            btnInputMoney.name = "btnInputMoney";
            btnInputMoney.label = "输入金币";
            btnInputMoney.x = 188;
            btnInputMoney.y = 344;
            btnInputMoney.width = (btnInputMoney.width - 5);
            contentSprite.addChild(btnInputMoney);
            btnLock = new HLabelButton();
            btnLock.name = "btnLock";
            btnLock.label = "锁定";
            btnLock.x = 263;
            btnLock.y = 344;
            btnLock.width = (btnLock.width - 5);
            contentSprite.addChild(btnLock);
            btnSure = new HLabelButton();
            btnSure.name = "btnSure";
            btnSure.label = "确定";
            btnSure.x = 307;
            btnSure.y = 344;
            btnSure.width = (btnSure.width - 5);
            contentSprite.addChild(btnSure);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Trade.Mediator 
