//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;

    public class GuideConsignmentView extends HFrame {

        private var btn1:HLabelButton;
        private var bgView:MovieClip;
        private var btnLayer:Sprite;
        private var btn2:HLabelButton;
        private var btn3:HLabelButton;
        private var btn4:HLabelButton;
        private var loadswfTool:LoadSwfTool = null;
        private var contentSprite:Sprite;

        public function GuideConsignmentView(){
            initView();
            addEvents();
        }
        private function loadAsset():void{
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(GameConfigData.GuideConsignmentAssetsSwf, true);
                loadswfTool.sendShow = loadCompleteHandler;
            };
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
                    closeHandler();
                    break;
            };
        }
        private function loadCompleteHandler(_arg1=null):void{
            bgView = loadswfTool.GetClassByMovieClip("GuideConsignmentAssets");
            contentSprite.addChildAt(bgView, 0);
            bgView.gotoAndStop(1);
            btnLayer.visible = true;
        }
        private function initView():void{
            this.setSize(760, 480);
            this.titleText = LanguageMgr.GetTranslation("寄卖行");
            this.centerTitle = true;
            btn1 = new HLabelButton();
            btn1.label = LanguageMgr.GetTranslation("存钱");
            btn1.x = 570;
            btn1.y = 50;
            btn2 = new HLabelButton();
            btn2.label = LanguageMgr.GetTranslation("挂单");
            btn2.x = 570;
            btn2.y = 145;
            btn3 = new HLabelButton();
            btn3.label = LanguageMgr.GetTranslation("收钱");
            btn3.x = 570;
            btn3.y = 265;
            btn4 = new HLabelButton();
            btn4.label = LanguageMgr.GetTranslation("我知道了");
            btn4.x = 613;
            btn4.y = 385;
            contentSprite = new Sprite();
            btnLayer = new Sprite();
            btnLayer.addChild(btn1);
            btnLayer.addChild(btn2);
            btnLayer.addChild(btn3);
            btnLayer.addChild(btn4);
            btnLayer.visible = false;
            contentSprite.addChild(btnLayer);
            contentSprite.x = 7;
            contentSprite.y = 35;
            addContent(contentSprite);
            loadAsset();
        }
        private function closeHandler():void{
            close();
        }
        private function addEvents():void{
            btn1.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn2.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn3.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            btn4.addEventListener(MouseEvent.CLICK, __btnClickHandler);
        }
        override public function close():void{
            super.close();
        }

    }
}//package GameUI.Modules.NewGuide.UI 
