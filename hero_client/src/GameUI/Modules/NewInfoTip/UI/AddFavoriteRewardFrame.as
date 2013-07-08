//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Net.RequestSend.*;
    import flash.external.*;

    public class AddFavoriteRewardFrame extends HFrame {

        private static var _instance:AddFavoriteRewardFrame;

        private var okBtn:HLabelButton;
        private var bgView:MovieClip;

        public function AddFavoriteRewardFrame(){
            initView();
            addEvents();
        }
        public static function getInstance():AddFavoriteRewardFrame{
            if (_instance == null){
                _instance = new (AddFavoriteRewardFrame)();
            };
            return (_instance);
        }

        private function addEvents():void{
            okBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
        }
        private function __clickHandler(_arg1:MouseEvent):void{
            var evt:* = _arg1;
            try {
                ExternalInterface.call("addFavorite");
            } catch(e:Error) {
            };
            PlayerActionSend.addFavoriteReward();
            UIFacade.GetInstance().sendNotification(GetRewardEvent.HIDE_GIFREWARDBTN);
            close();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("收藏英雄王座");
            centerTitle = true;
            setSize(270, 200);
            bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("addFavoriteRewardAssetl");
            bgView.x = 10;
            bgView.y = 30;
            okBtn = new HLabelButton();
            okBtn.label = LanguageMgr.GetTranslation("确定收藏");
            okBtn.x = 90;
            okBtn.y = 122;
            bgView.addChild(okBtn);
            blackGound = true;
            addContent(bgView);
        }
        override public function show():void{
            super.show();
            centerFrame();
        }
        private function removeEvents():void{
            okBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
        }

    }
}//package GameUI.Modules.NewInfoTip.UI 
