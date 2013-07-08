//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetViewPanel5 {

        public var refreshBtn:HLabelButton;
        private var applyBtn:HLabelButton;
        private var view:MovieClip;
        private var moneyContainer:Sprite;
        private var nums:Array;
        private var quickBuyBtn:HLabelButton;
        private var templatePet:ItemTemplateInfo;
        private var maxColor:uint = 0;
        private var itemInfo:InventoryItemInfo;
        private var viewPanel:MovieClip = null;
        private var petInfo:GamePetRole;
        private var moneyTextField:TextField;
        private var selectedIndex:uint = 0;

        public function PetViewPanel5(_arg1:MovieClip){
            nums = [0, 0];
            super();
            view = _arg1;
        }
        private function sure():void{
        }
        public function updateNums():void{
            nums[0] = BagData.getCountsByTemplateId(PetPropConstData.ItemIds[0], false);
            nums[1] = BagData.getCountsByTemplateId(PetPropConstData.ItemIds[1], false);
            viewPanel.txt_Num0.text = (("(" + nums[0]) + ")");
            viewPanel.txt_Num1.text = (("(" + nums[1]) + ")");
            viewPanel.txt_Num0.autoSize = TextFieldAutoSize.LEFT;
            viewPanel.txt_Num1.autoSize = TextFieldAutoSize.LEFT;
        }
        private function updateInfo():void{
            var _local3:String;
            nums[0] = BagData.getCountsByTemplateId(PetPropConstData.ItemIds[0], false);
            nums[1] = BagData.getCountsByTemplateId(PetPropConstData.ItemIds[1], false);
            viewPanel.txt_Num0.text = (("(" + nums[0]) + ")");
            viewPanel.txt_Num1.text = (("(" + nums[1]) + ")");
            viewPanel.txt_Num0.autoSize = TextFieldAutoSize.LEFT;
            viewPanel.txt_Num1.autoSize = TextFieldAutoSize.LEFT;
            maxColor = 0;
            viewPanel.hpTF.htmlText = getColorText(getBaseValue(templatePet.HpBonus, 2), petInfo.UpgradeValue[2], petInfo.UpgradeValue[8]);
            viewPanel.mpTF.htmlText = getColorText(getBaseValue(templatePet.MpBonus, 3), petInfo.UpgradeValue[3], petInfo.UpgradeValue[9]);
            viewPanel.attTF.htmlText = getColorText(getBaseValue(templatePet.Attack, 0), petInfo.UpgradeValue[0], petInfo.UpgradeValue[6]);
            viewPanel.defTF.htmlText = getColorText(getBaseValue(templatePet.Defence, 1), petInfo.UpgradeValue[1], petInfo.UpgradeValue[7]);
            viewPanel.hitTF.htmlText = getColorText(getBaseValue(templatePet.NormalHit, 4), petInfo.UpgradeValue[4], petInfo.UpgradeValue[10]);
            viewPanel.dodgeTF.htmlText = getColorText(getBaseValue(templatePet.NormalDodge, 5), petInfo.UpgradeValue[5], petInfo.UpgradeValue[11]);
            viewPanel.hpTF2.htmlText = getColorText2(templatePet.HpBonus, 2);
            viewPanel.mpTF2.htmlText = getColorText2(templatePet.MpBonus, 3);
            viewPanel.attTF2.htmlText = getColorText2(templatePet.Attack, 0);
            viewPanel.defTF2.htmlText = getColorText2(templatePet.Defence, 1);
            viewPanel.hitTF2.htmlText = getColorText2(templatePet.NormalHit, 4);
            viewPanel.dodgeTF2.htmlText = getColorText2(templatePet.NormalDodge, 5);
            arrowVisible(petInfo.UpgradeValue[8], 0);
            arrowVisible(petInfo.UpgradeValue[9], 1);
            arrowVisible(petInfo.UpgradeValue[6], 2);
            arrowVisible(petInfo.UpgradeValue[7], 3);
            arrowVisible(petInfo.UpgradeValue[10], 4);
            arrowVisible(petInfo.UpgradeValue[11], 5);
            var _local1:int = EquipDataConst.petUpgradeNeed[maxColor];
            var _local2:String = EquipDataConst.getInstance().getFeeByValue(_local1, LanguageMgr.GetTranslation("刷新费用"));
            if (GameCommonData.Player.Role.Gold < _local1){
                _local2 = _local2.replace("#ffffff", "#ff0000");
            };
            this.moneyTextField.htmlText = _local2;
            ShowMoney.ShowIcon(this.moneyContainer, this.moneyTextField, true);
            viewPanel.mcMain.y = (-2 + (uint(GamePetRole.getPanelPos((petInfo.PetType / 10000))) * 24.3));
            viewPanel.mcSub.y = (-2 + (uint(GamePetRole.getPanelPos((petInfo.PetType % 10000))) * 24.3));
            for each (_local3 in PetPropConstData.petColorObj) {
                viewPanel[_local3].textColor = 14074524;
                viewPanel[(_local3 + "2")].textColor = 14074524;
            };
            viewPanel[PetPropConstData.petColorObj[petInfo.MainType]].textColor = 0xFF00FF;
            viewPanel[PetPropConstData.petColorObj[petInfo.SubType]].textColor = 0xFF00;
            viewPanel[(PetPropConstData.petColorObj[petInfo.MainType] + "2")].textColor = 0xFF00FF;
            viewPanel[(PetPropConstData.petColorObj[petInfo.SubType] + "2")].textColor = 0xFF00;
        }
        public function addEvents():void{
            refreshBtn.addEventListener(MouseEvent.CLICK, __refreshHandler);
            applyBtn.addEventListener(MouseEvent.CLICK, __applyHandler);
            quickBuyBtn.addEventListener(MouseEvent.CLICK, quickBuy);
            viewPanel.mcRadio_0.addEventListener(MouseEvent.CLICK, selectHandler);
            viewPanel.mcRadio_1.addEventListener(MouseEvent.CLICK, selectHandler);
        }
        public function clearInfo():void{
            viewPanel.hpTF.text = "";
            viewPanel.mpTF.text = "";
            viewPanel.attTF.text = "";
            viewPanel.defTF.text = "";
            viewPanel.hitTF.text = "";
            viewPanel.dodgeTF.text = "";
            viewPanel.hpTF2.text = "";
            viewPanel.mpTF2.text = "";
            viewPanel.attTF2.text = "";
            viewPanel.defTF2.text = "";
            viewPanel.hitTF2.text = "";
            viewPanel.dodgeTF2.text = "";
            viewPanel[("arrow_" + 0)].visible = false;
            viewPanel[("arrow_" + 1)].visible = false;
            viewPanel[("arrow_" + 2)].visible = false;
            viewPanel[("arrow_" + 3)].visible = false;
            viewPanel[("arrow_" + 4)].visible = false;
            viewPanel[("arrow_" + 5)].visible = false;
        }
        private function Cancel():void{
        }
        private function arrowVisible(_arg1:int, _arg2:int):void{
            if (_arg1 == 0){
                viewPanel[("arrow_" + _arg2)].visible = false;
            } else {
                if (_arg1 > 0){
                    viewPanel[("arrow_" + _arg2)].visible = true;
                    viewPanel[("arrow_" + _arg2)].gotoAndStop(1);
                } else {
                    viewPanel[("arrow_" + _arg2)].visible = true;
                    viewPanel[("arrow_" + _arg2)].gotoAndStop(2);
                };
            };
        }
        private function getColor2(_arg1:int):String{
            if (_arg1 > 0){
                return ("#ff0000");
            };
            return ("#00ff00");
        }
        private function selectHandler(_arg1:MouseEvent):void{
            viewPanel.mcRadio_0.gotoAndStop(1);
            viewPanel.mcRadio_1.gotoAndStop(1);
            _arg1.currentTarget.gotoAndStop(2);
            selectedIndex = uint(_arg1.currentTarget.name.split("_")[1]);
        }
        public function selectItem(_arg1:int):void{
            var _local2:int;
            if ((((_arg1 >= 0)) && ((_arg1 < PetPropConstData.EQUIP_NUM)))){
                _local2 = 0;
                while ((((_local2 < PetPropConstData.EQUIP_NUM)) && ((_arg1 >= 0)))) {
                    itemInfo = (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local2)]] as InventoryItemInfo);
                    if (itemInfo){
                        _arg1--;
                    };
                    _local2++;
                };
                if (itemInfo){
                    petInfo = itemInfo.PetInfo;
                    templatePet = UIConstData.ItemDic[itemInfo.TemplateID];
                    updateInfo();
                };
            };
        }
        private function mouseOutHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.mcRed.visible = false;
        }
        private function getColorIndex(_arg1:int):uint{
            var _local2:uint = PetPropConstData.getColorIndex(_arg1);
            if (_local2 > maxColor){
                maxColor = _local2;
            };
            return (_local2);
        }
        private function removeEvents():void{
            refreshBtn.removeEventListener(MouseEvent.CLICK, __refreshHandler);
            applyBtn.removeEventListener(MouseEvent.CLICK, __applyHandler);
            quickBuyBtn.removeEventListener(MouseEvent.CLICK, quickBuy);
            viewPanel.mcRadio_0.removeEventListener(MouseEvent.CLICK, selectHandler);
            viewPanel.mcRadio_1.removeEventListener(MouseEvent.CLICK, selectHandler);
        }
        public function removeView():void{
            view.removeChild(moneyContainer);
            view.removeChild(refreshBtn);
            view.removeChild(applyBtn);
            view.removeChild(quickBuyBtn);
            view.removeChild(viewPanel);
        }
        private function __refreshHandler(_arg1:MouseEvent):void{
            var event:* = _arg1;
            if (!itemInfo){
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
                return;
            };
            if (nums[selectedIndex] == 0){
                if (selectedIndex == 0){
                    UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                        comfrim:sure,
                        cancel:null,
                        isShowClose:false,
                        info:LanguageMgr.GetTranslation("初级资质刷新石不足，可去商城购买！")
                    });
                } else {
                    UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                        comfrim:sure,
                        cancel:null,
                        isShowClose:false,
                        info:LanguageMgr.GetTranslation("缺少高级资质刷新石")
                    });
                };
                return;
            };
            var value:* = EquipDataConst.petUpgradeNeed[maxColor];
            if (GameCommonData.Player.Role.Gold < value){
                UIFacade.GetInstance().LackofGold();
                return;
            };
            var func:* = function ():void{
                EquipSend.PetUpgrade(itemInfo.ItemGUID, selectedIndex);
                UIFacade.GetInstance().sendNotification(Guide_PetQualityRefreshCommand.NAME, {
                    step:4,
                    data:{target:applyBtn}
                });
            };
            if (((!((itemInfo.isBind == 1))) && (!((itemInfo.Binding == 2))))){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    warning:true,
                    comfrim:func,
                    cancel:Cancel,
                    info:LanguageMgr.GetTranslation("该操作会使宠物绑定句")
                });
                return;
            };
            func();
        }
        private function initView():void{
            if (refreshBtn == null){
                refreshBtn = new HLabelButton();
                refreshBtn.label = LanguageMgr.GetTranslation("刷新");
                refreshBtn.x = 320;
                refreshBtn.y = 210;
                applyBtn = new HLabelButton();
                applyBtn.label = LanguageMgr.GetTranslation("替换");
                applyBtn.x = 370;
                applyBtn.y = 210;
                quickBuyBtn = new HLabelButton(2);
                quickBuyBtn.label = LanguageMgr.GetTranslation("快速购买");
                quickBuyBtn.x = 420;
                quickBuyBtn.y = 210;
                viewPanel.txt_Help.htmlText = (GameCommonData.HelpConfigItems["PetUpgrade"].Text as String);
                this.moneyContainer = new Sprite();
                this.moneyContainer.x = 320;
                this.moneyContainer.y = 235;
                this.moneyTextField = new TextField();
                this.moneyTextField.autoSize = TextFieldAutoSize.LEFT;
                this.moneyTextField.wordWrap = false;
                this.moneyTextField.mouseEnabled = false;
                this.moneyTextField.selectable = false;
                this.moneyContainer.addChild(this.moneyTextField);
                this.moneyTextField.width = 300;
                viewPanel.txt_Num0.width = 110;
                viewPanel.txt_Num1.width = 110;
            };
            selectedIndex = 0;
            view.addChild(moneyContainer);
            viewPanel.mcRadio_0.gotoAndStop(2);
            viewPanel.mcRadio_1.gotoAndStop(1);
            view.addChild(refreshBtn);
            view.addChild(applyBtn);
            view.addChild(quickBuyBtn);
        }
        private function quickBuy(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:PetPropConstData.ItemIds[selectedIndex]});
        }
        private function __applyHandler(_arg1:MouseEvent):void{
            if (!itemInfo){
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
                return;
            };
            if ((((((((((((petInfo.UpgradeValue[6] == 0)) && ((petInfo.UpgradeValue[7] == 0)))) && ((petInfo.UpgradeValue[8] == 0)))) && ((petInfo.UpgradeValue[9] == 0)))) && ((petInfo.UpgradeValue[10] == 0)))) && ((petInfo.UpgradeValue[11] == 0)))){
                MessageTip.show(LanguageMgr.GetTranslation("需要刷新之后才能替换"));
                return;
            };
            EquipSend.PetUpgrade(itemInfo.ItemGUID, 2);
            UIFacade.GetInstance().sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETQUALITYREFRESH_SHUTDOWN);
        }
        private function formatString(_arg1:String, _arg2:String, _arg3:uint):String{
            var _local6:uint;
            var _local4:String = _arg1;
            var _local5:int = (_arg3 - _arg2.length);
            if (_local5 > 0){
                _local6 = 0;
                while (_local6 < _local5) {
                    _local4 = (_local4 + " ");
                    _local6++;
                };
            };
            return (_local4);
        }
        private function getBaseValue(_arg1:uint, _arg2:uint):uint{
            return (uint((_arg1 * (1 + (petInfo.UpgradeValue[_arg2] / 100)))));
        }
        private function mouseOverHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.mcRed.visible = true;
        }
        public function addView():void{
            if (viewPanel == null){
                viewPanel = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("PetViewPanel5");
                viewPanel.x = 147;
                viewPanel.y = 27;
                viewPanel.txt_Num0.width = 55;
                viewPanel.txt_Num1.width = 55;
                viewPanel.txt_Help.width = 366;
            };
            view.addChild(viewPanel);
            view.addChild(view.getChildByName("toggleBtn_4"));
            initView();
            addEvents();
        }
        private function getBaseFactor(_arg1:uint):Number{
            var _local2:Number = 1.023;
            if (PetPropConstData.petPropOrder[_arg1] == petInfo.MainType){
                _local2 = 1.029;
            } else {
                if (PetPropConstData.petPropOrder[_arg1] == petInfo.SubType){
                    _local2 = 1.026;
                };
            };
            return (_local2);
        }
        private function getColorText2(_arg1:uint, _arg2:uint):String{
            var _local3 = "";
            var _local4 = "";
            var _local5 = "";
            var _local6:Number = getBaseFactor(_arg2);
            var _local7:Number = (_arg1 * Math.pow(_local6, 104));
            var _local8:Number = (petInfo.UpgradeValue[_arg2] / 100);
            var _local9:Number = ((_arg1 * _local8) * Math.pow(_local6, 104));
            _local7 = uint((_local7 + _local9));
            _local4 = (((("<font color='" + "#E0D33E") + "'>") + _local7) + "</font> ");
            _local4 = formatString(_local4, String(_local7), 7);
            if (_local9 > 0){
                _local5 = (((("<font color='" + "#ff0000") + "'>+") + uint(_local9)) + "</font> ");
            } else {
                _local5 = (((("<font color='" + "#00ff00") + "'> ") + uint(_local9)) + "</font> ");
            };
            _local5 = formatString(_local5, String(uint(_local9)), 5);
            _local3 = (_local4 + _local5);
            return (_local3);
        }
        private function getColorText(_arg1:int, _arg2:int, _arg3:int):String{
            var _local4 = "";
            var _local5 = "";
            var _local6 = "";
            var _local7 = "";
            _local5 = (((("<font color='" + "#E0D33E") + "'>") + _arg1) + "</font> ");
            _local5 = formatString(_local5, String(_arg1), 4);
            var _local8:String = ((_arg2)>0) ? "+" : " ";
            _local6 = ((((("<font color='" + PetPropConstData.propColors[getColorIndex(_arg2)]) + "'>") + _local8) + String(_arg2)) + "%</font> ");
            _local6 = formatString(_local6, String((_local8 + String(_arg2))), 4);
            _local8 = ((_arg3)>0) ? "+" : "";
            _local7 = ((((("<font color='" + getColor2(_arg3)) + "'>") + _local8) + String(_arg3)) + "%</font>");
            _local4 = ((_local5 + _local6) + _local7);
            return (_local4);
        }

    }
}//package GameUI.Modules.Pet.Mediator 
