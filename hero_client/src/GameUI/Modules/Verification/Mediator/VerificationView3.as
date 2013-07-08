//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Verification.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Verification.Proxy.*;

    public class VerificationView3 extends HFrame {

        public var btnOK:HLabelButton;
        private var contentSprite:Sprite;

        public function VerificationView3(_arg1:uint){
            initView(_arg1);
        }
        private function initView(_arg1):void{
            var _local2:MovieClip;
            titleText = "警告";
            centerTitle = true;
            blackGound = true;
            showClose = false;
            contentSprite = new Sprite();
            _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("VerificationView3");
            _local2.x = 10;
            _local2.y = 40;
            contentSprite.addChild(_local2);
            setSize((_local2.width + 40), (_local2.height + 90));
            if (_arg1 == 0){
                VerificationData.TimeLimitFlag = 0;
                _local2.txt_content.text = LanguageMgr.GetTranslation("5分钟系统强制你离开休息");
            } else {
                if (_arg1 == 1){
                    VerificationData.TimeLimitFlag = 1;
                    _local2.txt_content.text = LanguageMgr.GetTranslation("合理安排你游戏提示句");
                } else {
                    if (_arg1 == 2){
                        VerificationData.TimeLimitFlag = 2;
                        _local2.txt_content.text = LanguageMgr.GetTranslation("沉迷了请您稍后登陆句");
                    };
                };
            };
            _local2.txt_content.y = 10;
            _local2.txt_content.mouseEnabled = false;
            btnOK = new HLabelButton();
            btnOK.name = "btnView3OK";
            btnOK.textField.mouseEnabled = false;
            btnOK.label = LanguageMgr.GetTranslation("确定");
            btnOK.x = 110;
            btnOK.y = (frameHeight - 40);
            contentSprite.addChild(btnOK);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Verification.Mediator 
