//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.VIP.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Net.RequestSend.*;
    import OopsEngine.Graphics.*;

    public class VipWarnView extends Sprite {

        private var loadCount:int;
        private var hview:HFrame;
        private var pic:Bitmap;
        private var warnText:TextField;
        private var btns:Array;
        private var nameText:TextField;
        private var mov:MovieClip;
        private var pathPic:String;
        private var pathMov:String;
        private var blueBg:Sprite;

        public function VipWarnView(){
            pathPic = (GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/guidepic_vip.jpg");
            pathMov = (GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/mov_vip.swf");
            super();
            btns = [];
            init();
        }
        private function setupView():void{
            var _local1:int;
            var _local3:HLabelButton;
            nameText = new TextField();
            nameText.mouseEnabled = false;
            nameText.width = 300;
            nameText.filters = OopsEngine.Graphics.Font.Stroke();
            nameText.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 15, 0xFBFE00, true);
            nameText.htmlText = (((LanguageMgr.GetTranslation("尊敬的VIP会员") + "<font color ='#ff0000'>") + GameCommonData.Player.Role.Name) + "</font>");
            nameText.x = 25;
            nameText.y = 54;
            hview.addContent(nameText);
            var _local2 = 3;
            while (_local1 < _local2) {
                _local3 = new HLabelButton();
                switch (_local1){
                    case 0:
                        _local3.label = LanguageMgr.GetTranslation("成为半年卡VIP");
                        break;
                    case 1:
                        _local3.label = LanguageMgr.GetTranslation("成为月卡VIP");
                        break;
                    case 2:
                        _local3.label = LanguageMgr.GetTranslation("成为周卡VIP");
                        break;
                };
                _local3.x = 330;
                _local3.y = ((_local1 * 25) + 240);
                hview.addContent(_local3);
                btns.push(_local3);
                _local1++;
            };
            blueBg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BlueBack2");
            blueBg.width = 500;
            blueBg.height = 30;
            blueBg.x = 10;
            blueBg.y = 318;
            hview.addContent(blueBg);
            warnText = new TextField();
            warnText.selectable = false;
            warnText.width = 500;
            warnText.filters = OopsEngine.Graphics.Font.Stroke();
            warnText.defaultTextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFBFE00);
            warnText.htmlText = ((((("    " + LanguageMgr.GetTranslation("VIP过期提示很长句")) + "    ") + "<u><font color='#ff0000'><a href=\"event:\">") + LanguageMgr.GetTranslation("详情")) + "</a></font></u>");
            hview.addContent(warnText);
            warnText.x = 20;
            warnText.y = 322;
            initEvent();
        }
        private function loadPic():void{
            ResourcesFactory.getInstance().getResource(pathPic, onLoabdCompletePic);
        }
        private function onLoabdCompletePic():void{
            pic = ResourcesFactory.getInstance().getBitMapResourceByUrl(pathPic);
            hview.addContent(pic);
            if (mov){
                hview.addContent(mov);
            };
            pic.x = 8;
            pic.y = 32;
            checkLoad();
        }
        private function loadMov():void{
            ResourcesFactory.getInstance().getResource(pathMov, onLoabdCompleteMov);
        }
        private function init():void{
            hview = new HFrame();
            hview.showClose = true;
            hview.closeCallBack = hide;
            hview.blackGound = false;
            hview.moveEnable = true;
            hview.setSize(522, 360);
            hview.titleText = LanguageMgr.GetTranslation("温馨提示");
            hview.centerTitle = true;
            loadPic();
            loadMov();
        }
        private function onSelectType(_arg1:MouseEvent):void{
            var _local2:ShopItemInfo;
            if (_arg1.currentTarget == btns[0]){
                _local2 = MarketConstData.getShopItemByTemplateID(10700003, true);
                if (GameCommonData.Player.Role.Money >= _local2.APriceArr[2]){
                    MarketSend.buyItemForMarket(_local2.ShopId, 1, true);
                    hide();
                } else {
                    UIFacade.GetInstance().LackofGoldLeaf();
                };
            } else {
                if (_arg1.currentTarget == btns[1]){
                    _local2 = MarketConstData.getShopItemByTemplateID(10700002, true);
                    if (GameCommonData.Player.Role.Money >= _local2.APriceArr[2]){
                        MarketSend.buyItemForMarket(_local2.ShopId, 1, true);
                        hide();
                    } else {
                        UIFacade.GetInstance().LackofGoldLeaf();
                    };
                } else {
                    if (_arg1.currentTarget == btns[2]){
                        _local2 = MarketConstData.getShopItemByTemplateID(10700001, true);
                        if (GameCommonData.Player.Role.Money >= _local2.APriceArr[2]){
                            MarketSend.buyItemForMarket(_local2.ShopId, 1, true);
                            hide();
                        } else {
                            UIFacade.GetInstance().LackofGoldLeaf();
                        };
                    };
                };
            };
        }
        private function checkLoad():void{
            loadCount++;
            if (loadCount == 2){
                setupView();
                show();
            };
        }
        public function hide():void{
            var _local1:HLabelButton;
            removeEvent();
            for each (_local1 in btns) {
                _local1.dispose();
                _local1 = null;
            };
            btns = null;
            if (hview){
                hview.dispose();
                hview = null;
            };
        }
        private function initEvent():void{
            var _local1:HLabelButton;
            warnText.addEventListener(TextEvent.LINK, linkHandler);
            for each (_local1 in btns) {
                _local1.addEventListener(MouseEvent.CLICK, onSelectType);
            };
        }
        private function removeEvent():void{
            var _local1:HLabelButton;
            warnText.removeEventListener(TextEvent.LINK, linkHandler);
            for each (_local1 in btns) {
                _local1.removeEventListener(MouseEvent.CLICK, onSelectType);
            };
        }
        private function linkHandler(_arg1:TextEvent):void{
            UIFacade.GetInstance().sendNotification(EventList.SHOW_VIP);
        }
        private function onLoabdCompleteMov():void{
            mov = ResourcesFactory.getInstance().getswfResourceByUrl(pathMov);
            hview.addContent(mov);
            mov.x = (8 - 400);
            mov.y = (45 - 160);
            checkLoad();
        }
        public function show():void{
            hview.x = int(((GameCommonData.GameInstance.ScreenWidth - hview.width) / 2));
            hview.y = int(((GameCommonData.GameInstance.ScreenHeight - hview.height) / 2));
            GameCommonData.GameInstance.GameUI.addChild(hview);
        }

    }
}//package GameUI.Modules.VIP.View 
