//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetViewPanel3 {

        private var bgPic:Bitmap = null;
        private var viewHelp:MovieClip = null;
        private var faceItem:FaceItem;
        private var effect:MovieClip;
        private var loadswfTool:LoadSwfTool;
        private var SkillCells:Array;
        private var moneyContainer:Sprite;
        private var QuickBuyBtn:HLabelButton;
        private var view:MovieClip;
        public var startStrengthen:Function;
        private var strengthenBtnArr:Array;
        private var typeIndex:uint;
        private var viewPanel:MovieClip = null;
        private var itemInfo:InventoryItemInfo;
        private var viewData:MovieClip = null;
        private var petInfo:GamePetRole;
        private var moneyTextField:TextField;
        private var currPetStar:int = -1;

        public function PetViewPanel3(_arg1:MovieClip){
            view = _arg1;
            viewPanel = view.petViewPanel3;
            viewData = view.petViewData;
            viewHelp = view.petViewHelp;
            view.removeChild(viewPanel);
            this.moneyContainer = new Sprite();
            this.moneyContainer.x = 335;
            this.moneyContainer.y = 215;
            this.moneyTextField = new TextField();
            this.moneyTextField.width = 600;
            this.moneyTextField.autoSize = TextFieldAutoSize.LEFT;
            this.moneyTextField.wordWrap = false;
            this.moneyTextField.mouseEnabled = false;
            this.moneyTextField.selectable = false;
            this.moneyContainer.addChild(this.moneyTextField);
            this.moneyTextField.width = 300;
            loadswfTool = new LoadSwfTool(GameConfigData.PetStrengthenSwf, false);
            loadswfTool.sendShow = sendShow;
        }
        private function sure():void{
        }
        private function updateInfo():void{
            var _local5:String;
            if (!petInfo){
                return;
            };
            if (viewData){
                for each (_local5 in PetPropConstData.petColorObj) {
                    viewData[_local5].textColor = 14074524;
                };
                viewData[PetPropConstData.petColorObj[petInfo.MainType]].textColor = 0xFF00FF;
                viewData[PetPropConstData.petColorObj[petInfo.SubType]].textColor = 0xFF00;
            };
            var _local1:uint = calcValue(uint((itemInfo.Strengthen % 10000)), "生命");
            view.petViewPanel3.hpUpCnt.text = ("+" + String(_local1));
            view.petViewPanel3.hpUpCnt.textColor = uint(PetPropConstData.IntPropColors[getColorIndex(_local1, PetPropConstData.petBaseUpValue[0], "生命")]);
            _local1 = calcValue(uint((itemInfo.Strengthen / 10000)), "魔法");
            view.petViewPanel3.mpUpCnt.text = ("+" + String(_local1));
            view.petViewPanel3.mpUpCnt.textColor = uint(PetPropConstData.IntPropColors[getColorIndex(_local1, PetPropConstData.petBaseUpValue[1], "魔法")]);
            _local1 = calcValue((itemInfo.Enchanting % 10000), "攻击");
            view.petViewPanel3.attUpCnt.text = ("+" + String(calcValue((itemInfo.Enchanting % 10000), "攻击")));
            view.petViewPanel3.attUpCnt.textColor = uint(PetPropConstData.IntPropColors[getColorIndex(_local1, PetPropConstData.petBaseUpValue[2], "攻击")]);
            _local1 = calcValue(uint((itemInfo.Enchanting / 10000)), "防御");
            view.petViewPanel3.defUpCnt.text = ("+" + String(_local1));
            view.petViewPanel3.defUpCnt.textColor = uint(PetPropConstData.IntPropColors[getColorIndex(_local1, PetPropConstData.petBaseUpValue[3], "防御")]);
            _local1 = calcValue((itemInfo.Experience % 10000), "命中");
            view.petViewPanel3.hitUpCnt.text = ("+" + String(_local1));
            view.petViewPanel3.hitUpCnt.textColor = uint(PetPropConstData.IntPropColors[getColorIndex(_local1, PetPropConstData.petBaseUpValue[4], "命中")]);
            _local1 = calcValue(uint((itemInfo.Experience / 10000)), "躲闪");
            view.petViewPanel3.dodgeUpCnt.text = ("+" + String(_local1));
            view.petViewPanel3.dodgeUpCnt.textColor = uint(PetPropConstData.IntPropColors[getColorIndex(_local1, PetPropConstData.petBaseUpValue[5], "躲闪")]);
            view.petViewPanel3.startTF.text = (petInfo.Start + LanguageMgr.GetTranslation("星"));
            currPetStar = petInfo.Start;
            var _local2:int = petInfo.Start;
            if (_local2 > 105){
                _local2 = 105;
            };
            var _local3:int = EquipDataConst.petStrengthenNeed[uint((_local2 / 5))];
            var _local4:String = EquipDataConst.getInstance().getFeeByValue(_local3, LanguageMgr.GetTranslation("提升费用"));
            if (GameCommonData.Player.Role.Gold < _local3){
                _local4 = _local4.replace("#ffffff", "#ff0000");
            };
            this.moneyTextField.htmlText = _local4;
            ShowMoney.ShowIcon(this.moneyContainer, this.moneyTextField, true);
            view.petViewData.mcMain.visible = true;
            view.petViewData.mcSub.visible = true;
            view.petViewData.mcMain.y = (-2 + (uint((GamePetRole.getPanelPos((petInfo.PetType / 10000)) - 1)) * 24.3));
            view.petViewData.mcSub.y = (-2 + (uint((GamePetRole.getPanelPos((petInfo.PetType % 10000)) - 1)) * 24.3));
            view.petViewData.hpTF.text = ((petInfo.Hp + "/") + petInfo.HpMax);
            view.petViewData.mpTF.text = ((petInfo.Mp + "/") + petInfo.MpMax);
            view.petViewData.attTF.text = petInfo.Attack;
            view.petViewData.defTF.text = petInfo.Defense;
            view.petViewData.hitTF.text = petInfo.Hit;
            view.petViewData.dodgeTF.text = petInfo.Dodge;
            view.petViewData.critTF.text = (Number((petInfo.Crit * 100)).toFixed(1) + "%");
            view.petViewData.critRateTF.text = (Number((petInfo.CritRate * 100)).toFixed(1) + "%");
            refreshPic();
        }
        public function requestStrengthen():void{
            EquipSend.PetStrengthen(itemInfo.ItemGUID, typeIndex);
        }
        public function addEvents():void{
            QuickBuyBtn.addEventListener(MouseEvent.CLICK, __quickBuyBtnHandler);
        }
        public function clearInfo():void{
            view.petViewPanel3.hpUpCnt.text = "";
            view.petViewPanel3.mpUpCnt.text = "";
            view.petViewPanel3.attUpCnt.text = "";
            view.petViewPanel3.defUpCnt.text = "";
            view.petViewPanel3.hitUpCnt.text = "";
            view.petViewPanel3.dodgeUpCnt.text = "";
            view.petViewPanel3.startTF.text = "";
            view.petViewData.hpTF.text = "";
            view.petViewData.mpTF.text = "";
            view.petViewData.attTF.text = "";
            view.petViewData.defTF.text = "";
            view.petViewData.hitTF.text = "";
            view.petViewData.dodgeTF.text = "";
            view.petViewData.critTF.text = "";
            view.petViewData.critRateTF.text = "";
            view.petViewData.mcMain.visible = false;
            view.petViewData.mcSub.visible = false;
            currPetStar = -1;
        }
        private function calcValue(_arg1:uint, _arg2:String):uint{
            var _local3:uint;
            var _local4:Number = 0.25;
            var _local5:uint = 4;
            if (_arg2 == "生命"){
                _local5 = 16;
            } else {
                if (_arg2 == "魔法"){
                    _local5 = 12;
                };
            };
            if (itemInfo.PetInfo.MainType == _arg2){
                _local4 = 0.75;
            } else {
                if (itemInfo.PetInfo.SubType == _arg2){
                    _local4 = 0.5;
                };
            };
            _local3 = ((_arg1 * _local5) * _local4);
            return (_local3);
        }
        private function Cancel():void{
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
                    if (petInfo == itemInfo.PetInfo){
                        if (((!((currPetStar == -1))) && ((petInfo.Start > currPetStar)))){
                            playEffect();
                        };
                    };
                    petInfo = itemInfo.PetInfo;
                    updateInfo();
                };
            };
        }
        private function sendShow(_arg1:DisplayObject):void{
            effect = (_arg1 as MovieClip);
            effect.gotoAndStop(1);
        }
        private function onLoabdComplete():void{
            bgPic = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "pet_bg2") + ".jpg"));
            view.petViewPanel3.addChildAt(bgPic, 1);
            bgPic.x = 5;
            bgPic.y = 4;
        }
        private function removeEvents():void{
            QuickBuyBtn.removeEventListener(MouseEvent.CLICK, __quickBuyBtnHandler);
        }
        public function refreshPic():void{
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            var _local1:uint = BagData.getCountsByTemplateId(70300007, false);
            if (_local1 > 0){
                faceItem = new FaceItem(String(UIConstData.ItemDic[70300007].img), null, "bagIcon", 1, _local1);
                faceItem.Num = _local1;
                faceItem.x = (view.petViewPanel3.PetStrengthen_1.x - 1);
                faceItem.y = (view.petViewPanel3.PetStrengthen_1.y - 0.5);
                view.petViewPanel3.addChild(faceItem);
                faceItem.name = ("PetStrengthenT_" + 70300007);
                faceItem.setEnable(true);
            };
        }
        private function loadPic():void{
            if (bgPic == null){
                ResourcesFactory.getInstance().getResource((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "pet_bg2") + ".jpg"), onLoabdComplete);
            } else {
                view.petViewPanel3.addChildAt(bgPic, 1);
            };
        }
        private function getColorIndex(_arg1:uint, _arg2:uint, _arg3:String):uint{
            var _local4:Number = 0.25;
            if (itemInfo.PetInfo.MainType == _arg3){
                _local4 = 0.75;
            } else {
                if (itemInfo.PetInfo.SubType == _arg3){
                    _local4 = 0.5;
                };
            };
            var _local5:Number = 0;
            _local5 = (_arg1 / (((petInfo.Level * 5) * _arg2) * _local4));
            if (_local5 >= 0.8){
                return (4);
            };
            if (_local5 >= 0.6){
                return (3);
            };
            if (_local5 >= 0.4){
                return (2);
            };
            if (_local5 >= 0.2){
                return (1);
            };
            return (0);
        }
        public function refreshStrenPearlCount():void{
            var _local1:int;
            while (_local1 < 6) {
                view.petViewPanel3[("strenPearl" + _local1)].text = (("(" + BagData.getCountsByTemplateId(((70300000 + _local1) + 1), false)) + ")");
                _local1++;
            };
        }
        public function get StrengthenBtnArr():Array{
            return (this.strengthenBtnArr);
        }
        public function removeView():void{
            removeEvents();
            QuickBuyBtn.dispose();
            QuickBuyBtn = null;
            var _local1:uint;
            while (_local1 < 6) {
                strengthenBtnArr[_local1].removeEventListener(MouseEvent.CLICK, __strengthHandler);
                strengthenBtnArr[_local1].dispose();
                strengthenBtnArr[_local1] = null;
                _local1++;
            };
            strengthenBtnArr = null;
            view.removeChild(viewPanel);
            view.removeChild(viewData);
            view.removeChild(viewHelp);
            view.removeChild(moneyContainer);
        }
        private function initView():void{
            view.petViewPanel3.hpUpCnt.text = "";
            view.petViewPanel3.mpUpCnt.text = "";
            view.petViewPanel3.attUpCnt.text = "";
            view.petViewPanel3.defUpCnt.text = "";
            view.petViewPanel3.hitUpCnt.text = "";
            view.petViewPanel3.dodgeUpCnt.text = "";
            view.petViewPanel3.startTF.text = "";
            view.petViewData.hpTF.text = "";
            view.petViewData.mpTF.text = "";
            view.petViewData.attTF.text = "";
            view.petViewData.defTF.text = "";
            view.petViewData.hitTF.text = "";
            view.petViewData.dodgeTF.text = "";
            view.petViewData.critTF.text = "";
            view.petViewData.critRateTF.text = "";
            view.petViewData.mcMain.visible = false;
            view.petViewData.mcSub.visible = false;
            currPetStar = -1;
            loadPic();
        }
        public function playEffect():void{
            view.petViewPanel3.addChild(effect);
            effect.x = (view.petViewPanel3.startTF.x - 140);
            effect.y = (view.petViewPanel3.startTF.y - 133);
            effect.gotoAndPlay(1);
        }
        public function addView():void{
            var _local1:uint;
            var _local2:HLabelButton;
            if (viewPanel){
                strengthenBtnArr = [];
                view.addChild(viewPanel);
                viewData.x = 166;
                viewData.y = 40;
                view.addChild(viewData);
                view.addChild(viewHelp);
                viewHelp.txt_Help.htmlText = (GameCommonData.HelpConfigItems["PetStrengthen"].Text as String);
                view.addChild(view.getChildByName("toggleBtn_2"));
                QuickBuyBtn = new HLabelButton();
                QuickBuyBtn.label = LanguageMgr.GetTranslation("快速购买");
                QuickBuyBtn.x = 435;
                QuickBuyBtn.y = 224;
                view.addChild(QuickBuyBtn);
                view.addChild(moneyContainer);
                _local1 = 0;
                while (_local1 < 6) {
                    _local2 = new HLabelButton();
                    _local2.label = LanguageMgr.GetTranslation("提升");
                    _local2.name = ("strengthen_" + _local1);
                    _local2.x = 465;
                    _local2.y = (40 + (_local1 * 24.2));
                    _local2.height = 18;
                    _local1++;
                    view.addChild(_local2);
                    strengthenBtnArr.push(_local2);
                    _local2.addEventListener(MouseEvent.CLICK, __strengthHandler);
                };
            } else {
                viewPanel = view.petViewPanel3;
                viewData = view.petViewData;
                viewHelp = view.petViewHelp;
            };
            initView();
            addEvents();
            refreshStrenPearlCount();
        }
        private function __quickBuyBtnHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:70300007});
        }
        private function __strengthHandler(_arg1:MouseEvent):void{
            var _local5:String;
            if (!itemInfo){
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
                return;
            };
            var _local2:uint = (uint(_arg1.currentTarget.name.split("_")[1]) + 1);
            if ((((BagData.getCountsByTemplateId((70300000 + _local2), false) == 0)) && ((BagData.getCountsByTemplateId(70300007, false) == 0)))){
                _local5 = "";
                switch (_local2){
                    case 1:
                        _local5 = "生命";
                        break;
                    case 2:
                        _local5 = "魔法";
                        break;
                    case 3:
                        _local5 = "攻击";
                        break;
                    case 4:
                        _local5 = "防御";
                        break;
                    case 5:
                        _local5 = "命中";
                        break;
                    case 6:
                        _local5 = "躲闪";
                        break;
                };
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:(_local5 + LanguageMgr.GetTranslation("x属性强化珠不足"))
                });
                return;
            };
            var _local3:int = petInfo.Start;
            if (_local3 > 105){
                _local3 = 105;
            };
            var _local4:int = EquipDataConst.petStrengthenNeed[uint((_local3 / 5))];
            if (GameCommonData.Player.Role.Gold < _local4){
                UIFacade.GetInstance().LackofGold();
                return;
            };
            typeIndex = _local2;
            if (((!((itemInfo.isBind == 1))) && (!((itemInfo.Binding == 2))))){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    warning:true,
                    comfrim:requestStrengthen,
                    cancel:Cancel,
                    info:LanguageMgr.GetTranslation("该操作宠物会绑定句")
                });
                return;
            };
            requestStrengthen();
        }

    }
}//package GameUI.Modules.Pet.Mediator 
