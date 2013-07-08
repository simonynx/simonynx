//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;

    public class BagUIView extends HFrame {

        public var content:MovieClip;
        public var gonghuiIcon:Sprite;
        public var cangkuIcon:Sprite;
        public var btnSplit:HLabelButton;
        public var zhiyeIcon:Sprite;
        public var btnStall:HLabelButton;
        private var contentSprite:Sprite;
        public var btnDeal:HLabelButton;
        public var btnDrop:HLabelButton;
        public var yaodianIcon:Sprite;

        public function BagUIView(){
            initView();
        }
        public function set extendRowTipPos(_arg1:int):void{
            content.extendRowTxt.y = _arg1;
            content.extendBtn4.y = _arg1;
            content.extendTxt4.y = (_arg1 + 3);
        }
        private function setMouseFlase():void{
            content.pageTxt1.mouseEnabled = false;
            content.pageTxt2.mouseEnabled = false;
            content.extendTxt1.mouseEnabled = false;
            content.extendTxt2.mouseEnabled = false;
            content.extendTxt3.mouseEnabled = false;
            content.treasureTxt.mouseEnabled = false;
            content.extendTxt4.mouseEnabled = false;
        }
        private function initView():void{
            centerTitle = true;
            blackGound = false;
            titleActive = true;
            titleText = LanguageMgr.GetTranslation("背 包");
            x = 599;
            y = 58;
            setSize(286, 418);
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Bag2012");
            content.x = 4;
            content.y = 41;
            contentSprite.addChild(content);
            setMouseFlase();
            btnDeal = new HLabelButton();
            btnDeal.label = LanguageMgr.GetTranslation("空格整理");
            btnDeal.name = "btnDeal";
            UIUtils.replaceChild(content, content.btn1, btnDeal, true);
            btnSplit = new HLabelButton();
            btnSplit.label = LanguageMgr.GetTranslation("空格拆分");
            btnSplit.name = "btnSplit";
            UIUtils.replaceChild(content, content.btn2, btnSplit, true);
            btnStall = new HLabelButton();
            btnStall.label = LanguageMgr.GetTranslation("空格摆摊");
            btnStall.name = "btnStall";
            UIUtils.replaceChild(content, content.btn3, btnStall, true);
            btnDrop = new HLabelButton();
            btnDrop.label = LanguageMgr.GetTranslation("空格修理");
            btnDrop.name = "btnDrop";
            UIUtils.replaceChild(content, content.btn4, btnDrop, true);
            addVipContent();
            addContent(contentSprite);
            content.treasureBtn.buttonMode = true;
            content.pageBtn1.buttonMode = true;
            content.pageBtn1.gotoAndStop(2);
            content.pageBtn2.buttonMode = true;
            content.extendBtn1.buttonMode = true;
            content.extendBtn2.buttonMode = true;
            content.extendBtn3.buttonMode = true;
            content.extendBtn4.buttonMode = true;
        }
        private function addVipContent():void{
            var _local1:Bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("vipYDIcon");
            var _local2:Bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("vipCKIcon");
            var _local3:Bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("vipGJIcon");
            var _local4:Bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("vipZJIcon");
            yaodianIcon = new Sprite();
            cangkuIcon = new Sprite();
            gonghuiIcon = new Sprite();
            zhiyeIcon = new Sprite();
            yaodianIcon.addChild(_local1);
            cangkuIcon.addChild(_local2);
            gonghuiIcon.addChild(_local3);
            zhiyeIcon.addChild(_local4);
            yaodianIcon.buttonMode = true;
            cangkuIcon.buttonMode = true;
            gonghuiIcon.buttonMode = true;
            zhiyeIcon.buttonMode = true;
            cangkuIcon.name = "vipItem_0";
            yaodianIcon.name = "vipItem_1";
            gonghuiIcon.name = "vipItem_2";
            zhiyeIcon.name = "vipItem_3";
            UIUtils.replaceChild(content, content.vipBtn1, yaodianIcon, true);
            UIUtils.replaceChild(content, content.vipBtn2, cangkuIcon, true);
            UIUtils.replaceChild(content, content.vipBtn3, gonghuiIcon, true);
            UIUtils.replaceChild(content, content.vipBtn4, zhiyeIcon, true);
        }
        public function set extendRowTip(_arg1:Boolean):void{
            content.extendRowTxt.visible = _arg1;
            content.extendBtn4.visible = _arg1;
            content.extendTxt4.visible = _arg1;
        }

    }
}//package GameUI.Modules.Bag.Mediator 
