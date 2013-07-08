//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GMMail.Mediator {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class GMMailView extends HFrame {

        public var btnFillMoney:HLabelButton;
        public var btnSend:HLabelButton;
        public var btnCancel:HLabelButton;
        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function GMMailView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("联系GM");
            centerTitle = true;
            blackGound = false;
            showClose = true;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GMMail");
            content.x = 4;
            content.y = 52;
            contentSprite.addChild(content);
            setSize((content.width + 8), (content.height + 92));
            btnFillMoney = new HLabelButton();
            btnFillMoney.name = "btnFillMoney";
            btnFillMoney.label = LanguageMgr.GetTranslation("快速充值");
            btnFillMoney.x = 390;
            btnFillMoney.y = 172;
            btnFillMoney.visible = false;
            contentSprite.addChild(btnFillMoney);
            btnSend = new HLabelButton();
            btnSend.name = "btnSend";
            btnSend.label = LanguageMgr.GetTranslation("send");
            btnSend.x = 252;
            btnSend.y = 360;
            contentSprite.addChild(btnSend);
            btnCancel = new HLabelButton();
            btnCancel.name = "btnCancel";
            btnCancel.label = LanguageMgr.GetTranslation("cancel");
            btnCancel.x = 338;
            btnCancel.y = 360;
            contentSprite.addChild(btnCancel);
            x = int(((GameCommonData.GameInstance.ScreenWidth / 2) - (this.width / 2)));
            y = int(((GameCommonData.GameInstance.ScreenHeight / 2) - (this.height / 2)));
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.GMMail.Mediator 
