//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;

    public class GuideTreasureView extends HFrame {

        private var bgView:MovieClip;
        private var btn1:HLabelButton;
        private var btn2:HLabelButton;
        private var btn3:HLabelButton;
        private var btn4:HLabelButton;
        private var btn5:HLabelButton;
        private var loadswfTool:LoadSwfTool = null;
        private var contentSprite:Sprite;
        private var btn6:HLabelButton;
        private var btnLayer:Sprite;

        public function GuideTreasureView(){
            initView();
            addEvents();
        }
        private function closeHandler():void{
            close();
        }
        private function loadCompleteHandler(_arg1=null):void{
            bgView = loadswfTool.GetClassByMovieClip("GuideTreasureAssets");
            contentSprite.addChildAt(bgView, 0);
            bgView.gotoAndStop(1);
            btnLayer.visible = true;
        }
        private function addEvents():void{
            btn1.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn2.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn3.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn4.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn5.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn6.addEventListener(MouseEvent.CLICK, __btnClickHandler);
        }
        private function initView():void{
            this.setSize(580, 530);
            this.titleText = LanguageMgr.GetTranslation("神兵介绍");
            this.centerTitle = true;
            btn1 = new HLabelButton();
            btn1.label = LanguageMgr.GetTranslation("神兵等级");
            btn1.x = 245;
            btn1.y = 6;
            btn2 = new HLabelButton();
            btn2.label = LanguageMgr.GetTranslation("神兵属性");
            btn2.x = 245;
            btn2.y = 80;
            btn3 = new HLabelButton();
            btn3.label = LanguageMgr.GetTranslation("特有技能");
            btn3.x = 245;
            btn3.y = 155;
            btn4 = new HLabelButton();
            btn4.label = LanguageMgr.GetTranslation("人物技能");
            btn4.x = 245;
            btn4.y = 241;
            btn5 = new HLabelButton();
            btn5.label = LanguageMgr.GetTranslation("神兵套装");
            btn5.x = 245;
            btn5.y = 328;
            btn6 = new HLabelButton();
            btn6.label = LanguageMgr.GetTranslation("我知道了");
            btn6.x = 350;
            btn6.y = 448;
            contentSprite = new Sprite();
            btnLayer = new Sprite();
            btnLayer.addChild(btn1);
            btnLayer.addChild(btn2);
            btnLayer.addChild(btn3);
            btnLayer.addChild(btn4);
            btnLayer.addChild(btn5);
            btnLayer.addChild(btn6);
            btnLayer.visible = false;
            contentSprite.addChild(btnLayer);
            contentSprite.x = 7;
            contentSprite.y = 35;
            addContent(contentSprite);
            loadAsset();
        }
        private function loadAsset():void{
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(GameConfigData.GuideTreasureAssetsSwf, true);
                loadswfTool.sendShow = loadCompleteHandler;
            };
        }
        override public function close():void{
            super.close();
        }
        private function __btnClickHandler(_arg1:MouseEvent):void{
            switch (_arg1.currentTarget){
                case btn1:
                    bgView.gotoAndStop(1);
                    break;
                case btn2:
                    bgView.gotoAndStop(2);
                    break;
                case btn3:
                    bgView.gotoAndStop(3);
                    break;
                case btn4:
                    bgView.gotoAndStop(4);
                    break;
                case btn5:
                    bgView.gotoAndStop(5);
                    break;
                case btn6:
                    closeHandler();
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.UI 
