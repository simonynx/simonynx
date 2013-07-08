//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Verification.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class VerificationView2 extends HFrame {

        public var contentSprite:Sprite;
        public var btnCancel:HLabelButton;
        public var btnOK:HLabelButton;
        public var txtPlayerName:TextField;
        public var txtIdentity:TextField;

        public function VerificationView2(){
            initView();
        }
        private function initView():void{
            var _local1:MovieClip;
            titleText = LanguageMgr.GetTranslation("防沉迷系统");
            centerTitle = true;
            blackGound = true;
            showClose = false;
            contentSprite = new Sprite();
            _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("VerificationView2");
            _local1.x = 10;
            _local1.y = 40;
            contentSprite.addChild(_local1);
            setSize((_local1.width + 40), (_local1.height + 90));
            _local1.txt_content1.mouseEnabled = false;
            _local1.txt_content2.mouseEnabled = false;
            _local1.txt_content1.x = 10;
            _local1.txt_content2.x = 10;
            txtPlayerName = _local1.txtPlayerName;
            _local1.txtPlayerName.maxChars = 16;
            _local1.txtPlayerName.text = "";
            _local1.txtPlayerName.restrict = "一-龥";
            txtPlayerName.tabEnabled = true;
            txtPlayerName.tabIndex = 0;
            txtIdentity = _local1.txtIdentity;
            _local1.txtIdentity.maxChars = 18;
            _local1.txtIdentity.restrict = "0-9a-zA-Z";
            _local1.txtIdentity.text = "";
            txtIdentity.tabEnabled = true;
            txtIdentity.tabIndex = 1;
            btnOK = new HLabelButton();
            btnOK.name = "btnView2OK";
            btnOK.label = LanguageMgr.GetTranslation("确定");
            btnOK.x = 150;
            btnOK.y = (frameHeight - 36);
            contentSprite.addChild(btnOK);
            btnOK.tabEnabled = true;
            btnOK.tabIndex = 2;
            btnCancel = new HLabelButton();
            btnCancel.name = "btnView2Cancel";
            btnCancel.label = LanguageMgr.GetTranslation("取消");
            btnCancel.x = 280;
            btnCancel.y = (frameHeight - 36);
            contentSprite.addChild(btnCancel);
            btnCancel.tabEnabled = true;
            btnCancel.tabIndex = 3;
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Verification.Mediator 
