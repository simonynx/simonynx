//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Verification.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class VerificationView1 extends HFrame {

        public var btnUnderAge:HLabelButton;
        public var btnFillIn:HLabelButton;
        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function VerificationView1(){
            initView();
        }
        private function initView():void{
            centerTitle = true;
            titleText = LanguageMgr.GetTranslation("防沉迷系统警告");
            blackGound = true;
            showClose = false;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("VerificationView1");
            content.x = 10;
            content.y = 40;
            contentSprite.addChild(content);
            setSize((content.width + 40), (content.height + 90));
            content.txt_content.mouseEnabled = false;
            btnFillIn = new HLabelButton();
            btnFillIn.name = "btnView1FillIn";
            btnFillIn.textField.mouseEnabled = false;
            btnFillIn.label = LanguageMgr.GetTranslation("填写");
            btnFillIn.x = 50;
            btnFillIn.y = (frameHeight - 36);
            contentSprite.addChild(btnFillIn);
            btnUnderAge = new HLabelButton();
            btnUnderAge.name = "btnView1UnderAge";
            btnUnderAge.textField.mouseEnabled = false;
            btnUnderAge.label = LanguageMgr.GetTranslation("我未成年");
            btnUnderAge.x = 150;
            btnUnderAge.y = (frameHeight - 36);
            contentSprite.addChild(btnUnderAge);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Verification.Mediator 
