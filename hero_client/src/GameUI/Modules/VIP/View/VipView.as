//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.VIP.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.text.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.Modules.VIP.Command.*;

    public class VipView extends HFrame {

        private var bgPic:Bitmap = null;
        private var powers:Array;
        private var desContainer:UISprite;
        private var pageArray:Array;
        private var des:TextField;
        private var maxPage:int = 0;
        private var currentPage:int = 0;
        private var panel1:Sprite;
        private var panel2:Sprite;
        private var vipplayer:ToggleButton;
        private var hor0:HorizonToggleButton;
        private var hor1:HorizonToggleButton;
        private var hor2:HorizonToggleButton;
        private var vipinfo:ToggleButton;
        private var scroll:UIScrollPane;
        private var btnArray:Array;
        private var head:Sprite;
        private var welcome:TextField;
        private var pageText:TextField;
        private var viptime:TextField;
        private var buy1:HLabelButton;
        private var playername:TextField;
        private var buy0:HLabelButton;
        private var infoContainer:Sprite;
        private var buy2:HLabelButton;

        public function VipView(){
            btnArray = [];
            powers = ["", "周卡", "月卡", "半年卡"];
            super();
            fuck();
        }
        public function updatePages(_arg1:uint):void{
            if (_arg1 > 0){
                pageText.text = ((((currentPage < 1)) ? 1 : currentPage + "/") + countMaxPage());
            } else {
                pageText.text = "0/0";
            };
        }
        private function sortContainer():void{
            var _local2:DisplayObject;
            var _local1:int;
            while (_local1 < infoContainer.numChildren) {
                _local2 = infoContainer.getChildAt(_local1);
                _local2.y = (_local1 * 31);
                _local1++;
            };
        }
        private function countMaxPage():uint{
            var _local1:uint = (pageArray.length / 10);
            if ((pageArray.length % 10) != 0){
                _local1 = (_local1 + 1);
            };
            return (_local1);
        }
        private function onLeft(_arg1:MouseEvent):void{
            if (currentPage > 1){
                currentPage--;
                updatePlayerInfos(pageArray);
                updatePages(currentPage);
            };
        }
        private function updateDes(_arg1:int):void{
            var _local5:String;
            var _local6:String;
            var _local2:uint = VIPConstants.viprightscount[_arg1];
            var _local3 = "";
            des.text = "";
            des.height = 1;
            var _local4:int;
            while (_local4 <= _local2) {
                _local3 = (_local3 + "<FONT FACE='宋体' SIZE='12' COLOR='#FFFFFF' LETTERSPACING='0' KERNING='0'>");
                _local5 = LanguageMgr.GetTranslation(((("VIPRight" + _arg1.toString()) + "_") + _local4.toString()));
                for each (_local6 in LanguageMgr.replaceArray) {
                    _local5 = _local5.replace(_local6, (("<FONT COLOR='#A4E002'>" + _local6) + "</FONT>"));
                };
                _local3 = (_local3 + _local5);
                _local3 = (_local3 + "</FONT></P></TEXTFORMAT><br>");
                des.height = (des.height + 16);
                _local4++;
            };
            des.htmlText = _local3;
            des.width = 440;
            desContainer.height = des.height;
            panel1.addChild(scroll);
            scroll.refresh();
            scroll.scrollTop();
        }
        public function updatePlayerInfos(_arg1:Array):void{
            clearContainer();
            pageArray = _arg1;
            if (_arg1.length > 0){
                if ((currentPage == 0)){
                    currentPage = 1;
                } else {
                    currentPage;
                };
            } else {
                updatePages(0);
                return;
            };
            var _local2:int = ((currentPage - 1) * 10);
            var _local3:int = _local2;
            while ((((_local3 < pageArray.length)) && ((_local3 < (currentPage * 10))))) {
                infoContainer.addChild(_arg1[_local3]);
                _local3++;
            };
            sortContainer();
            updatePages(currentPage);
        }
        public function updateStatus():void{
            if (vipinfo.selected){
                this.addChild(vipinfo);
            } else {
                this.addChild(vipplayer);
            };
        }
        public function updateWelcomeInfo(_arg1:int):void{
            if (_arg1 == 0){
                this.welcome.htmlText = (((((("<TEXTFORMAT LEADING='6'><P ALIGN='LEFT'><FONT FACE='宋体' SIZE='12' COLOR='#ffffff' LETTERSPACING='0' KERNING='1'>" + LanguageMgr.GetTranslation("欢迎您")) + "！<FONT FACE='宋体' SIZE='12' COLOR='#ff0000' LETTERSPACING='0' KERNING='1'>") + LanguageMgr.GetTranslation("您还不是VIP玩家")) + "</FONT>，") + LanguageMgr.GetTranslation("成为VIP可享受非一般的服务")) + "。</P></TEXTFORMAT>");
            } else {
                this.welcome.htmlText = (((((("<TEXTFORMAT LEADING='6'><P ALIGN='LEFT'><FONT FACE='宋体' SIZE='12' COLOR='#ffffff' LETTERSPACING='0' KERNING='1'>" + LanguageMgr.GetTranslation("欢迎您")) + "！<FONT FACE='宋体' SIZE='12' COLOR='#A4E002' LETTERSPACING='0' KERNING='1'>") + LanguageMgr.GetTranslation("您是尊贵的VIPx玩家", powers[_arg1])) + "</FONT>，") + LanguageMgr.GetTranslation("可享受非一般的服务")) + "。</FONT></P></TEXTFORMAT>");
            };
            this.welcome.filters = VIPConstants.filter;
        }
        private function clearContainer():void{
            while (infoContainer.numChildren > 0) {
                infoContainer.removeChildAt(0);
            };
        }
        public function updatePlayerName(_arg1:String):void{
            this.playername.text = _arg1;
            panel1["txtPrice1"].text = String((MarketConstData.getShopItemByTemplateID(10700003, true).APriceArr[2] / 100));
            panel1["txtPrice2"].text = String((MarketConstData.getShopItemByTemplateID(10700002, true).APriceArr[2] / 100));
            panel1["txtPrice3"].text = String((MarketConstData.getShopItemByTemplateID(10700001, true).APriceArr[2] / 100));
        }
        public function updateTime(_arg1:String):void{
            this.viptime.text = ((LanguageMgr.GetTranslation("VIP剩余时间") + ":") + _arg1);
        }
        private function onLoabdComplete():void{
            bgPic = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "viphead") + ".png"));
            this.addChild(bgPic);
            bgPic.x = ((width - bgPic.width) / 2);
            bgPic.y = -10;
        }
        private function onDes(_arg1:MouseEvent):void{
            var _local2:int;
            while (_local2 < btnArray.length) {
                btnArray[_local2].selected = false;
                _local2++;
            };
            _arg1.currentTarget.selected = true;
            updateDes(_arg1.currentTarget.name);
        }
        private function initBtns():void{
            buy0 = new HLabelButton();
            buy0.label = LanguageMgr.GetTranslation("购买");
            buy0.x = 104;
            buy0.y = 160;
            buy1 = new HLabelButton();
            buy1.label = LanguageMgr.GetTranslation("购买");
            buy1.x = 278;
            buy1.y = 160;
            buy2 = new HLabelButton();
            buy2.label = LanguageMgr.GetTranslation("购买");
            buy2.x = 450;
            buy2.y = 160;
            buy0.name = "10700003";
            buy0.addEventListener(MouseEvent.CLICK, onClick);
            buy1.name = "10700002";
            buy1.addEventListener(MouseEvent.CLICK, onClick);
            buy2.name = "10700001";
            buy2.addEventListener(MouseEvent.CLICK, onClick);
            panel1.addChild(buy0);
            panel1.addChild(buy1);
            panel1.addChild(buy2);
            hor0 = new HorizonToggleButton(0, LanguageMgr.GetTranslation("VIP半年卡"));
            hor1 = new HorizonToggleButton(0, LanguageMgr.GetTranslation("VIP月卡"));
            hor2 = new HorizonToggleButton(0, LanguageMgr.GetTranslation("VIP周卡"));
            hor0.x = 1;
            hor0.y = 228;
            hor1.x = 1;
            hor1.y = 263;
            hor2.x = 1;
            hor2.y = 298;
            hor0.name = "0";
            hor1.name = "1";
            hor2.name = "2";
            panel1.addChild(hor0);
            panel1.addChild(hor1);
            panel1.addChild(hor2);
            btnArray.push(hor0);
            hor0.addEventListener(MouseEvent.CLICK, onDes);
            btnArray.push(hor1);
            hor1.addEventListener(MouseEvent.CLICK, onDes);
            btnArray.push(hor2);
            hor2.addEventListener(MouseEvent.CLICK, onDes);
            hor0.selected = true;
        }
        private function loadPic():void{
            if (bgPic == null){
                ResourcesFactory.getInstance().getResource((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "viphead") + ".png"), onLoabdComplete);
            } else {
                this.addChild(bgPic);
            };
        }
        private function onClick(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:_arg1.currentTarget.name});
        }
        private function onChange(_arg1:MouseEvent):void{
            vipinfo.selected = false;
            vipplayer.selected = false;
            if (panel1.parent){
                panel1.parent.removeChild(panel1);
            };
            if (panel2.parent){
                panel2.parent.removeChild(panel2);
            };
            _arg1.currentTarget.selected = true;
            if (_arg1.currentTarget == vipinfo){
                this.addChild(panel1);
            } else {
                this.addChild(panel2);
            };
            this.addChild(vipinfo);
            this.addChild(vipplayer);
        }
        private function fuck():void{
            this.blackGound = false;
            panel1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("vippanel1");
            panel2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("vippanel2");
            panel1.x = 4;
            panel1.y = 52;
            panel2.x = 8;
            panel2.y = 52;
            infoContainer = new Sprite();
            infoContainer.x = 9;
            infoContainer.y = 32;
            panel2.addChild(infoContainer);
            pageText = panel2["page"];
            pageText.text = "0/0";
            var _local1:HLabelButton = new HLabelButton(0);
            var _local2:HLabelButton = new HLabelButton(0);
            _local1.label = LanguageMgr.GetTranslation("上一页");
            _local2.label = LanguageMgr.GetTranslation("下一页");
            _local1.x = 183;
            _local1.y = 347;
            _local2.x = 296;
            _local2.y = 347;
            panel2.addChild(_local1);
            panel2.addChild(_local2);
            _local1.addEventListener(MouseEvent.CLICK, onLeft);
            _local2.addEventListener(MouseEvent.CLICK, onRight);
            playername = panel1["playername"];
            playername.textColor = 0xFFFFFF;
            welcome = panel1["welcome"];
            viptime = panel1["viptime"];
            head = panel1["head"];
            viptime.autoSize = TextFieldAutoSize.LEFT;
            vipinfo = new ToggleButton(1, LanguageMgr.GetTranslation("VIP信息"));
            vipplayer = new ToggleButton(1, LanguageMgr.GetTranslation("VIP玩家"));
            vipinfo.addEventListener(MouseEvent.CLICK, onChange);
            vipplayer.addEventListener(MouseEvent.CLICK, onChange);
            vipinfo.x = 15;
            vipinfo.y = 33;
            vipplayer.x = ((vipinfo.x + vipinfo.width) + 2);
            vipplayer.y = 33;
            vipinfo.selected = true;
            this.addChild(panel1);
            initBtns();
            setSize(544, 428);
            var _local3:GameRole = GameCommonData.Player.Role;
            var _local4:FaceItem = new FaceItem(GameCommonData.Player.Role.Face.toString(), head, "face", (48 / 72), 1);
            head.addChild(_local4);
            _local4.x = 1;
            _local4.y = 1;
            desContainer = new UISprite();
            des = new TextField();
            des.autoSize = TextFieldAutoSize.LEFT;
            desContainer.width = 440;
            des.selectable = false;
            des.multiline = true;
            des.wordWrap = true;
            desContainer.addChild(des);
            scroll = new UIScrollPane(desContainer);
            scroll.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            scroll.x = 73;
            scroll.y = 234;
            scroll.width = 458;
            scroll.height = 127;
            scroll.refresh();
            panel1.addChild(scroll);
            updateDes(0);
            VIPConstants.filter = welcome.filters;
            VIPConstants.welcomeColor = welcome.textColor;
            this.addChild(vipinfo);
            this.addChild(vipplayer);
            loadPic();
        }
        private function onRight(_arg1:MouseEvent):void{
            if (currentPage < countMaxPage()){
                currentPage++;
                updatePlayerInfos(pageArray);
                updatePages(currentPage);
            };
        }

    }
}//package GameUI.Modules.VIP.View 
