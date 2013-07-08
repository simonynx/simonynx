//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.MainScene.Mediator.*;

    public class GuidePicFrame extends HFrame {

        public static const TYPE_TEAM:int = 1;
        public static const TYPE_PETRACE:int = 9;
        public static const TYPE_STRENGTHEN:int = 11;
        public static const TYPE_TREASURE:int = 12;
        public static const TYPE_SHILIAN:int = 10;

        private static var TipsDic:Dictionary = new Dictionary();
        private static var BtnsDic:Dictionary = new Dictionary();
        private static var _instanceDic:Dictionary = new Dictionary();

        private var bgPic:Bitmap;
        private var bg0:MovieClip;
        private var bg1:MovieClip;
        private var bg2:MovieClip;
        private var bgAll:Sprite;
        private var contentSprite:Sprite;
        private var okBtn:HLabelButton;
        private var tf_tips:TextField;
        private var btnBitmap:Bitmap;
        private var type:int = -1;

        public function GuidePicFrame(_arg1:int){
            this.type = _arg1;
            initView();
            addEvents();
            loadPic();
            setInfo();
        }
        public static function show(_arg1:int):GuidePicFrame{
            var _local2:GuidePicFrame;
            if (_instanceDic[_arg1] == null){
                _local2 = new GuidePicFrame(_arg1);
                _instanceDic[_arg1] = _local2;
            };
            _instanceDic[_arg1].centerFrame();
            _instanceDic[_arg1].show();
            return (_instanceDic[_arg1]);
        }

        private function onLoabdComplete():void{
            this.visible = true;
            bgPic = ResourcesFactory.getInstance().getBitMapResourceByUrl(picPathUrl);
            contentSprite.addChild(bgPic);
            bgPic.x = 10;
            bgPic.y = 10;
            doLayout();
            this.centerFrame();
        }
        private function loadPic():void{
            if (bgPic == null){
                ResourcesFactory.getInstance().getResource(picPathUrl, onLoabdComplete);
            } else {
                this.visible = true;
                contentSprite.addChild(bgPic);
                doLayout();
                this.centerFrame();
            };
        }
        private function __clikcHandler(_arg1:MouseEvent):void{
            close();
        }
        private function initView():void{
            contentSprite = new Sprite();
            setSize(500, 500);
            titleText = "";
            centerTitle = true;
            contentSprite.x = 10;
            contentSprite.y = 30;
            blackGound = true;
            addContent(contentSprite);
            bgAll = new Sprite();
            contentSprite.addChild(bgAll);
            bg0 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BlueBack2");
            bg1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BlueBack2");
            bg2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BlueBack2");
            bgAll.addChild(bg0);
            bgAll.addChild(bg1);
            bgAll.addChild(bg2);
            okBtn = new HLabelButton();
            okBtn.label = LanguageMgr.GetTranslation("我知道了");
            okBtn.x = ((frameWidth - okBtn.width) / 2);
            okBtn.y = ((frameHeight - okBtn.height) - 50);
            contentSprite.addChild(okBtn);
            okBtn.visible = false;
            this.visible = false;
            tf_tips = new TextField();
            tf_tips.multiline = true;
            tf_tips.wordWrap = false;
            tf_tips.mouseEnabled = false;
            tf_tips.selectable = false;
            tf_tips.height = 60;
            var _local1:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 14, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
            _local1.leading = 2;
            tf_tips.defaultTextFormat = _local1;
            contentSprite.addChild(tf_tips);
            TipsDic[TYPE_TREASURE] = LanguageMgr.GetTranslation("GuidePicFrame中tips0");
            TipsDic[TYPE_STRENGTHEN] = LanguageMgr.GetTranslation("GuidePicFrame中tips1");
            TipsDic[TYPE_SHILIAN] = LanguageMgr.GetTranslation("GuidePicFrame中tips2");
            TipsDic[TYPE_PETRACE] = LanguageMgr.GetTranslation("GuidePicFrame中tips3");
            BtnsDic[TYPE_TREASURE] = (((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_12"].getChildAt(0) as SimpleButton);
            BtnsDic[TYPE_STRENGTHEN] = (((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_11"].getChildAt(0) as SimpleButton);
            BtnsDic[TYPE_SHILIAN] = (((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_10"].getChildAt(0) as SimpleButton);
            BtnsDic[TYPE_PETRACE] = (((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_9"].getChildAt(0) as SimpleButton);
            var _local2 = "";
            switch (type){
                case TYPE_TREASURE:
                    _local2 = LanguageMgr.GetTranslation("神兵相关");
                    break;
                case TYPE_STRENGTHEN:
                    _local2 = LanguageMgr.GetTranslation("装备强化");
                    break;
                case TYPE_SHILIAN:
                    _local2 = LanguageMgr.GetTranslation("武神试炼");
                    break;
                case TYPE_PETRACE:
                    _local2 = LanguageMgr.GetTranslation("斗宠相关");
                    break;
            };
            titleText = _local2;
        }
        private function addEvents():void{
            okBtn.addEventListener(MouseEvent.CLICK, __clikcHandler);
        }
        private function doLayout():void{
            if (bgPic){
                bg0.width = (bgPic.width + 20);
                bg0.height = (bgPic.height + 20);
                setSize((bgPic.width + 38), (bgPic.height + 120));
            };
            if (okBtn){
                okBtn.x = ((frameWidth - okBtn.width) / 2);
                okBtn.y = ((frameHeight - okBtn.height) - 50);
            };
            if (((bgPic) && (tf_tips))){
                tf_tips.width = (bgPic.width - 80);
                tf_tips.x = 10;
                tf_tips.y = ((frameHeight - tf_tips.height) - 35);
                bg1.width = tf_tips.width;
                bg1.height = tf_tips.height;
                bg1.x = 0;
                bg1.y = (tf_tips.y - 5);
            };
            if (btnBitmap){
                btnBitmap.x = ((frameWidth - btnBitmap.width) - 50);
                btnBitmap.y = (tf_tips.y + 2);
                bg2.width = 100;
                bg2.height = bg1.height;
                bg2.x = (frameWidth - 120);
                bg2.y = bg1.y;
            };
        }
        private function get picPathUrl():String{
            var _local1 = "";
            switch (type){
                case TYPE_TREASURE:
                    _local1 = "guidepic_treasure.jpg";
                    break;
                case TYPE_TEAM:
                    _local1 = "guidepic_treasure.jpg";
                    break;
                case TYPE_SHILIAN:
                    _local1 = "guidepic_shilian.jpg";
                    break;
                case TYPE_STRENGTHEN:
                    _local1 = "guidepic_strengthen.jpg";
                    break;
                case TYPE_PETRACE:
                    _local1 = "guidepic_petrace.jpg";
                    break;
            };
            return (((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + _local1));
        }
        private function setInfo():void{
            var _local1:BitmapData;
            if (TipsDic[type]){
                tf_tips.htmlText = TipsDic[type];
            };
            if (BtnsDic[type]){
                btnBitmap = new Bitmap();
                _local1 = new BitmapData(BtnsDic[type].width, BtnsDic[type].height, true, 0);
                _local1.draw(BtnsDic[type]);
                btnBitmap.bitmapData = _local1;
                contentSprite.addChild(btnBitmap);
            };
            doLayout();
        }
        override public function show():void{
            GameCommonData.GameInstance.TooltipLayer.addChild(this);
        }
        override public function close():void{
            var rr:* = null;
            var fromPoint:* = null;
            var toPoint:* = null;
            if (((((BtnsDic[type]) && (btnBitmap))) && ((BtnsDic[type].parent.visible == false)))){
                rr = btnBitmap.getBounds(btnBitmap.stage);
                fromPoint = new Point(rr.x, rr.y);
                rr = BtnsDic[type].getBounds(BtnsDic[type].stage);
                toPoint = new Point(rr.x, rr.y);
                GameCommonData.GameInstance.GameUI.addChild(btnBitmap);
                btnBitmap.x = fromPoint.x;
                btnBitmap.y = fromPoint.y;
                TweenLite.to(btnBitmap, 1, {
                    x:toPoint.x,
                    y:toPoint.y,
                    onComplete:function ():void{
                        if (btnBitmap.parent){
                            btnBitmap.parent.removeChild(btnBitmap);
                        };
                        UIFacade.GetInstance().sendNotification(EventList.UPDATE_MAINBTN_RIGHT);
                    }
                });
            };
            super.close();
        }

    }
}//package GameUI.Modules.NewGuide.UI 
