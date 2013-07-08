//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.QuickBuy.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.*;

    public class QuickBuyMediator extends Mediator {

        public static const NAME:String = "QuickBuyMediator";

        private var shopitem:ShopItemInfo;
        private var maxCount:uint;
        private var currSelect:uint = 0;
        private var faceItem:Array;
        private var moneyContainer:Sprite;
        private var dataProxy:DataProxy;
        private var quickbuyItem:Array;
        private var moneyTextField:TextField;
        private var txtField:TextField;
        private var templateId:uint;
        private var type:uint = 0;

        public function QuickBuyMediator(){
            faceItem = new Array();
            quickbuyItem = new Array();
            super(NAME);
        }
        protected function onCommitHandler():void{
            if (GameCommonData.Player.Role.isStalling > 0){
                MessageTip.show(LanguageMgr.GetTranslation("购买提示2"));
                return;
            };
            if (shopitem == null){
                MessageTip.show(LanguageMgr.GetTranslation("购买提示3"));
                return;
            };
            var _local1:uint = uint(viewUI.content.QuickBuyInfo.txtInputCount.text);
            if (GameCommonData.Player.Role.Money < (_local1 * MarketConstData.getShopItemByTemplateID(templateId, true).APriceArr[2])){
                UIFacade.GetInstance().LackofGoldLeaf();
                return;
            };
            var _local2:Object = new Object();
            _local2.ShopId = MarketConstData.getShopItemByTemplateID(templateId, true).ShopId;
            _local2.buyNum = _local1;
            MarketSend.buyItemForMarket(_local2.ShopId, _local2.buyNum);
            onClosePanelHandler();
        }
        protected function onMouseOutHandler(_arg1:MouseEvent):void{
            if (type != 0){
                return;
            };
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            SetFrame.RemoveFrame(_local2.parent, "RedFrame");
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    this.dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case QuickBuyCommandList.SHOW_QUICKBUY_UI:
                    if (!viewUI){
                        initViewUI();
                    };
                    MarketSend.getShopItemList(MarketConstData.SHOPTYPE_SALES);
                    templateId = _arg1.getBody().TemplateID;
                    _local2 = _arg1.getBody().num;
                    if (_local2 == 0){
                        _local2 = 1;
                    };
                    if (!MarketConstData.getShopItemByTemplateID(templateId, true)){
                        MessageTip.popup(LanguageMgr.GetTranslation("购买提示5"));
                        return;
                    };
                    GameCommonData.GameInstance.GameUI.addChild(viewUI);
                    viewUI.closeCallBack = onClosePanelHandler;
                    addLis();
                    maxCount = UIConstData.ItemDic[templateId].MaxCount;
                    type = _arg1.getBody().Type;
                    _local3 = 1;
                    if (type != 0){
                        _local3 = type;
                        if (_local3 == 5){
                            currSelect = ((GameCommonData.Player.Role.CurrentJobID > 0)) ? (GameCommonData.Player.Role.CurrentJobID - 1) : 0;
                        };
                    };
                    _local4 = 0;
                    faceItem = new Array(_local3);
                    quickbuyItem = new Array(_local3);
                    while (_local4 < _local3) {
                        quickbuyItem[_local4] = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("QuickbuyItem");
                        this.viewUI.content.addChild(quickbuyItem[_local4]);
                        if (_local3 == 1){
                            this.viewUI.content.bg.width = 230;
                            this.viewUI.content.bg.height = 136;
                            this.viewUI.setSize((230 + 8), (136 + 66));
                            moneyContainer.x = (((230 - 300) / 2) + 90);
                            moneyContainer.y = (136 - 25);
                            this.viewUI.content.QuickBuyInfo.x = ((230 - this.viewUI.content.QuickBuyInfo.width) / 2);
                            this.viewUI.content.QuickBuyInfo.y = (136 - 61);
                            quickbuyItem[_local4].x = 98;
                            quickbuyItem[_local4].y = 8;
                            viewUI.center();
                        } else {
                            if (_local3 == 8){
                                this.viewUI.content.bg.width = 320;
                                this.viewUI.content.bg.height = 201;
                                this.viewUI.setSize((this.viewUI.content.bg.width + 8), (this.viewUI.content.height + 66));
                                quickbuyItem[_local4].x = (35 + ((_local4 % 4) * 72));
                                quickbuyItem[_local4].y = (13 + (uint((_local4 / 4)) * 64));
                                moneyContainer.x = (((320 - 300) / 2) + 90);
                                moneyContainer.y = (201 - 25);
                                this.viewUI.content.QuickBuyInfo.x = ((320 - this.viewUI.content.QuickBuyInfo.width) / 2);
                                this.viewUI.content.QuickBuyInfo.y = (201 - 61);
                                viewUI.center();
                            } else {
                                if (_local3 == 5){
                                    this.viewUI.content.bg.width = 393;
                                    this.viewUI.content.bg.height = 136;
                                    this.viewUI.setSize((393 + 8), (this.viewUI.content.height + 66));
                                    quickbuyItem[_local4].x = (35 + ((_local4 % 5) * 72));
                                    quickbuyItem[_local4].y = (13 + 0);
                                    moneyContainer.x = (((393 - 300) / 2) + 90);
                                    moneyContainer.y = (136 - 25);
                                    this.viewUI.content.QuickBuyInfo.x = ((393 - this.viewUI.content.QuickBuyInfo.width) / 2);
                                    this.viewUI.content.QuickBuyInfo.y = (136 - 61);
                                    viewUI.center();
                                } else {
                                    if (_local3 == 2){
                                        this.viewUI.content.bg.width = 240;
                                        this.viewUI.content.bg.height = 136;
                                        this.viewUI.setSize((240 + 8), (this.viewUI.content.height + 66));
                                        if (templateId == 10100004){
                                            if (!txtField){
                                                txtField = new TextField();
                                                txtField.text = LanguageMgr.GetTranslation("购买提示1");
                                                txtField.mouseEnabled = false;
                                                txtField.width = 240;
                                                txtField.textColor = 0xFF00;
                                                txtField.name = "txtField";
                                                txtField.x = 30;
                                                txtField.y = 126;
                                            };
                                            viewUI.addChild(txtField);
                                        };
                                        quickbuyItem[_local4].x = (67 + ((_local4 % 2) * 72));
                                        quickbuyItem[_local4].y = (13 + 0);
                                        moneyContainer.x = 60;
                                        moneyContainer.y = (136 - 25);
                                        this.viewUI.content.QuickBuyInfo.x = ((240 - this.viewUI.content.QuickBuyInfo.width) / 2);
                                        this.viewUI.content.QuickBuyInfo.y = (136 - 61);
                                        viewUI.center();
                                    };
                                };
                            };
                        };
                        quickbuyItem[_local4].txtName.text = MarketConstData.getShopItemByTemplateID((templateId + _local4), true).Name;
                        if (_local3 == 5){
                            quickbuyItem[_local4].txtName.text = MarketConstData.getShopItemByTemplateID((templateId + _local4), true).Name.substr(0, 2);
                        };
                        faceItem[_local4] = new FaceItem(String(UIConstData.ItemDic[(templateId + _local4)].img), null, "bagIcon", 1);
                        faceItem[_local4].Num = MarketConstData.getShopItemByTemplateID(templateId, true).SCount;
                        if (_local3 == 1){
                            faceItem[_local4].addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
                        };
                        faceItem[_local4].addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
                        if (_local3 != 1){
                            faceItem[_local4].addEventListener(MouseEvent.MOUSE_DOWN, onSelect);
                        };
                        faceItem[_local4].name = ((("QuickBuyT_" + String((templateId + _local4))) + "_") + _local4);
                        faceItem[_local4].setEnable(true);
                        this.viewUI.content.addChild(faceItem[_local4]);
                        faceItem[_local4].x = quickbuyItem[_local4].x;
                        faceItem[_local4].y = quickbuyItem[_local4].y;
                        if (((!((_local3 == 1))) && ((_local4 == currSelect)))){
                            SetFrame.UseFrame2(faceItem[_local4], "RedFrame", 0, 0, 38, 38);
                        };
                        _local4++;
                    };
                    if (type == 5){
                        templateId = (templateId + currSelect);
                    };
                    shopitem = MarketConstData.getShopItemByTemplateID(templateId, true);
                    viewUI.content.QuickBuyInfo.txtInputCount.text = _local2.toString();
                    inputHandler(null);
                    break;
                case QuickBuyCommandList.CLOSE_QUICKBUY_UI:
                    break;
            };
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            switch (_arg1.target.name){
                case "btnAdd":
                    if (int(viewUI.content.QuickBuyInfo.txtInputCount.text) < maxCount){
                        viewUI.content.QuickBuyInfo.txtInputCount.text = String((int(viewUI.content.QuickBuyInfo.txtInputCount.text) + 1));
                    };
                    inputHandler(null);
                    break;
                case "btnSub":
                    if (int(viewUI.content.QuickBuyInfo.txtInputCount.text) > 1){
                        viewUI.content.QuickBuyInfo.txtInputCount.text = String((int(viewUI.content.QuickBuyInfo.txtInputCount.text) - 1));
                    };
                    inputHandler(null);
                    break;
            };
        }
        protected function onClosePanelHandler():void{
            currSelect = 0;
            removeLis();
            var _local1:uint;
            if (viewUI.getChildByName("txtField")){
                viewUI.removeChild(viewUI.getChildByName("txtField"));
            };
            SetFrame.RemoveFrame(faceItem[currSelect].parent, "RedFrame");
            while (_local1 < quickbuyItem.length) {
                viewUI.content.removeChild(quickbuyItem[_local1]);
                viewUI.content.removeChild(faceItem[_local1]);
                _local1++;
            };
            if (GameCommonData.GameInstance.GameUI.contains(this.viewUI)){
                GameCommonData.GameInstance.GameUI.removeChild(viewUI);
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, QuickBuyCommandList.SHOW_QUICKBUY_UI]);
        }
        private function initViewUI():void{
            setViewComponent(new QuickBuyView());
            viewUI.content.QuickBuyInfo.txtInputCount.restrict = "0-9";
            this.moneyContainer = new Sprite();
            moneyContainer.x = ((viewUI.content.width - 300) / 2);
            moneyContainer.y = (viewUI.content.height - 64);
            this.moneyTextField = new TextField();
            this.moneyTextField.autoSize = TextFieldAutoSize.LEFT;
            this.moneyTextField.wordWrap = false;
            this.moneyTextField.mouseEnabled = false;
            this.moneyTextField.selectable = false;
            this.moneyContainer.addChild(this.moneyTextField);
            this.moneyTextField.width = 300;
            viewUI.content.addChild(moneyContainer);
        }
        protected function onMouseOverHandler(_arg1:MouseEvent):void{
            if (((!((type == 0))) && ((currSelect == uint(_arg1.target.name.split("_")[2]))))){
                return;
            };
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            SetFrame.UseFrame2(_local2, "RedFrame", 0, 0, 38, 38);
        }
        private function removeLis():void{
            viewUI.content.QuickBuyInfo.btnAdd.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            viewUI.content.QuickBuyInfo.btnSub.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            viewUI.content.QuickBuyInfo.txtInputCount.removeEventListener(Event.CHANGE, inputHandler);
        }
        private function inputHandler(_arg1:Event):void{
            var _local2:uint = int(viewUI.content.QuickBuyInfo.txtInputCount.text);
            if (_local2 <= 0){
                viewUI.content.QuickBuyInfo.txtInputCount.text = "1";
            } else {
                if (_local2 > maxCount){
                    viewUI.content.QuickBuyInfo.txtInputCount.text = String(maxCount);
                };
            };
            _local2 = uint(viewUI.content.QuickBuyInfo.txtInputCount.text);
            shopitem = MarketConstData.getShopItemByTemplateID(templateId, true);
            if (shopitem == null){
                return;
            };
            var _local3:uint = (_local2 * shopitem.APriceArr[2]);
            var _local4 = "";
            if (_local3 >= 100){
                _local4 = (String((_local3 / 100)) + "      \\ab");
                if ((_local3 % 100)){
                    _local4 = (_local4 + String((_local3 % 100)));
                    _local4 = (_local4 + "      \\aa");
                };
            } else {
                _local4 = (String(_local3) + "      \\aa");
            };
            moneyTextField.htmlText = LanguageMgr.GetTranslation("购买提示4", _local4);
            ShowMoney.ShowIcon(moneyContainer, moneyTextField);
            faceItem[currSelect].Num = (MarketConstData.getShopItemByTemplateID(templateId, true).SCount * _local2);
        }
        public function get viewUI():QuickBuyView{
            return ((this.viewComponent as QuickBuyView));
        }
        protected function onSelect(_arg1:MouseEvent):void{
            if (currSelect == uint(_arg1.target.name.split("_")[2])){
                return;
            };
            SetFrame.RemoveFrame(faceItem[currSelect].parent, "RedFrame");
            currSelect = uint(_arg1.target.name.split("_")[2]);
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            SetFrame.UseFrame2(_local2, "RedFrame", 0, 0, 38, 38);
            if (type == 8){
                templateId = (10100038 + currSelect);
            } else {
                if (type == 5){
                    templateId = (10100033 + currSelect);
                } else {
                    if (type == 2){
                        templateId = (10100004 + currSelect);
                    };
                };
            };
            viewUI.content.QuickBuyInfo.txtInputCount.text = faceItem[currSelect].Num;
            inputHandler(null);
        }
        private function addLis():void{
            this.viewUI.okFunction = onCommitHandler;
            viewUI.content.QuickBuyInfo.btnAdd.addEventListener(MouseEvent.CLICK, btnClickHandler);
            viewUI.content.QuickBuyInfo.btnSub.addEventListener(MouseEvent.CLICK, btnClickHandler);
            viewUI.content.QuickBuyInfo.txtInputCount.addEventListener(Event.CHANGE, inputHandler);
        }

    }
}//package GameUI.Modules.QuickBuy.Mediator 
