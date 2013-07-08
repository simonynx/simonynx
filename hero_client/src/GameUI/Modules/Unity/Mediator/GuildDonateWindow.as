//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Unity.Mediator {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class GuildDonateWindow extends HFrame {

        public var prestigeTF:TextField;
        private var mainMc:Sprite;
        public var okBtn:HLabelButton;
        public var allDonateBtn:HLabelButton;
        public var offerTypeTF:TextField;

        public function GuildDonateWindow(){
            initView();
        }
        private function initView():void{
            mainMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("DonatePanel");
            allDonateBtn = new HLabelButton();
            allDonateBtn.label = LanguageMgr.GetTranslation("全部捐献");
            allDonateBtn.x = 10;
            allDonateBtn.y = 340;
            mainMc.addChild(allDonateBtn);
            okBtn = new HLabelButton();
            okBtn.label = LanguageMgr.GetTranslation("捐献");
            okBtn.x = 100;
            okBtn.y = 340;
            mainMc.addChild(okBtn);
            this.prestigeTF = mainMc["prestigeTF"];
            this.offerTypeTF = mainMc["offerTypeTF"];
            setSize(260, 418);
            blackGound = false;
            titleText = LanguageMgr.GetTranslation("公会捐献");
            centerTitle = true;
            mainMc.x = 7;
            mainMc.y = 38;
            addContent(mainMc);
        }

    }
}//package GameUI.Modules.Unity.Mediator 
