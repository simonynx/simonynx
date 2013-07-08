//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetViewPanel2 {

        private var bgPic:Bitmap = null;
        private var viewHelp:MovieClip = null;
        private var faceItem:FaceItem;
        public var startRebuild:Function;
        private var viewPanel:MovieClip = null;
        private var RebuildBtn:HLabelButton;
        private var BatchBtn:HLabelButton;
        private var QuickBuyBtn:HLabelButton;
        private var view:MovieClip;
        private var SkillCells:Array;
        private var itemInfo:InventoryItemInfo;
        private var petInfo:GamePetRole;
        private var viewData:MovieClip = null;
        private var skillPanel:MovieClip = null;

        public function PetViewPanel2(_arg1:MovieClip){
            view = _arg1;
            viewPanel = view.petViewPanel2;
            viewData = view.petViewData;
            skillPanel = view.petSkillPanel;
            viewHelp = view.petViewHelp;
            view.removeChild(viewPanel);
            view.removeChild(viewHelp);
        }
        private function onLoabdComplete():void{
            bgPic = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "pet_bg2") + ".jpg"));
            view.petViewPanel2.addChildAt(bgPic, 1);
            bgPic.x = 5;
            bgPic.y = 4;
        }
        public function refreshPic():void{
            var _local2:String;
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            var _local1:uint = BagData.getCountsByTemplateId(70200001, false);
            if (_local1 > 0){
                faceItem = new FaceItem(String(UIConstData.ItemDic[70200001].img), null, "bagIcon", 1, _local1);
                faceItem.Num = _local1;
                faceItem.x = (view.petViewPanel2.PetRebuild_1.x - 1);
                faceItem.y = (view.petViewPanel2.PetRebuild_1.y - 0.5);
                view.petViewPanel2.addChild(faceItem);
                faceItem.name = ("PetRebuildT_" + 70200001);
                faceItem.setEnable(true);
                _local2 = EquipDataConst.getInstance().getFeeByValue(0, LanguageMgr.GetTranslation("洗炼费用"));
            };
        }
        private function loadPic():void{
            if (bgPic == null){
                ResourcesFactory.getInstance().getResource((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "pet_bg2") + ".jpg"), onLoabdComplete);
            } else {
                view.petViewPanel2.addChildAt(bgPic, 1);
            };
        }
        private function __rebuildHandler(_arg1:MouseEvent):void{
            if (!itemInfo){
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
                return;
            };
            if (BagData.getCountsByTemplateId(70200001, false) == 0){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("宠物秘纹不足句")
                });
                return;
            };
            if (itemInfo.PetInfo.IsUsing){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("出战中宠物不洗炼句")
                });
                return;
            };
            if ((((itemInfo.PetInfo.MainType == LanguageMgr.GetTranslation("攻击"))) && ((itemInfo.PetInfo.CommonSkills[2] > 600000)))){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:startRebuild,
                    cancel:Cancel,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("已洗炼出极品宠物徐闻还要洗炼")
                });
                return;
            };
            startRebuild();
        }
        public function requestRebuild():void{
            EquipSend.PetRebuild(itemInfo.ItemGUID);
        }
        private function sure():void{
        }
        private function createPetSkillCell():void{
            var _local2:NewSkillCell;
            var _local1:int;
            if (((SkillCells) && ((SkillCells.length > 0)))){
                while (_local1 < SkillCells.length) {
                    if (SkillCells[_local1].parent){
                        SkillCells[_local1].dispose();
                        SkillCells[_local1].parent.removeChild(SkillCells[_local1]);
                        SkillCells[_local1] = null;
                    };
                    _local1++;
                };
            };
            SkillCells = [];
            var _local3:Array = [];
            _local3.push(itemInfo.PetInfo.SpecialSkill);
            _local3 = _local3.concat(itemInfo.PetInfo.CommonSkills);
            _local1 = 0;
            while (_local1 < _local3.length) {
                if (GameCommonData.SkillList[_local3[_local1]] == null){
                    _local1++;
                } else {
                    _local2 = new NewSkillCell();
                    _local2.setPetSkillInfo(GameCommonData.SkillList[_local3[_local1]]);
                    _local2.x = ((view.petSkillPanel[("petskill_" + _local1)].x + view.petSkillPanel[("petskill_" + _local1)].parent.x) + 1.5);
                    _local2.y = ((view.petSkillPanel[("petskill_" + _local1)].y + view.petSkillPanel[("petskill_" + _local1)].parent.y) + 1.5);
                    view.addChild(_local2);
                    SkillCells.push(_local2);
                    _local1++;
                };
            };
        }
        private function updateInfo():void{
            var _local1:String;
            if (!petInfo){
                return;
            };
            view.petViewData.mcMain.y = (-2 + (uint((GamePetRole.getPanelPos((petInfo.PetType / 10000)) - 1)) * 24.3));
            view.petViewData.mcSub.y = (-2 + (uint((GamePetRole.getPanelPos((petInfo.PetType % 10000)) - 1)) * 24.3));
            if (viewData){
                for each (_local1 in PetPropConstData.petColorObj) {
                    viewData[_local1].textColor = 14074524;
                };
                viewData[PetPropConstData.petColorObj[petInfo.MainType]].textColor = 0xFF00FF;
                viewData[PetPropConstData.petColorObj[petInfo.SubType]].textColor = 0xFF00;
            };
            view.petViewData.hpTF.text = ((petInfo.Hp + "/") + petInfo.HpMax);
            view.petViewData.mpTF.text = ((petInfo.Mp + "/") + petInfo.MpMax);
            view.petViewData.attTF.text = petInfo.Attack;
            view.petViewData.defTF.text = petInfo.Defense;
            view.petViewData.hitTF.text = petInfo.Hit;
            view.petViewData.dodgeTF.text = petInfo.Dodge;
            view.petViewData.critTF.text = (Number((petInfo.Crit * 100)).toFixed(1) + "%");
            view.petViewData.critRateTF.text = (Number((petInfo.CritRate * 100)).toFixed(1) + "%");
            view.petViewData.mcMain.visible = true;
            view.petViewData.mcSub.visible = true;
            refreshPic();
            createPetSkillCell();
        }
        public function removeView():void{
            removeEvents();
            QuickBuyBtn.dispose();
            QuickBuyBtn = null;
            RebuildBtn.dispose();
            RebuildBtn = null;
            BatchBtn.dispose();
            BatchBtn = null;
            var _local1:int;
            if (((SkillCells) && ((SkillCells.length > 0)))){
                while (_local1 < SkillCells.length) {
                    if (SkillCells[_local1].parent){
                        SkillCells[_local1].dispose();
                        SkillCells[_local1].parent.removeChild(SkillCells[_local1]);
                        SkillCells[_local1] = null;
                    };
                    _local1++;
                };
            };
            SkillCells = [];
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            view.removeChild(viewPanel);
            view.removeChild(viewData);
            view.removeChild(skillPanel);
            view.removeChild(viewHelp);
        }
        public function clearInfo():void{
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
            var _local1:int;
            if (((SkillCells) && ((SkillCells.length > 0)))){
                while (_local1 < SkillCells.length) {
                    if (SkillCells[_local1].parent){
                        SkillCells[_local1].parent.removeChild(SkillCells[_local1]);
                        SkillCells[_local1] = null;
                    };
                    _local1++;
                };
            };
            SkillCells = [];
        }
        private function initView():void{
            var _local1:uint;
            _local1 = 0;
            while (_local1 < PetPropConstData.EQUIP_NUM) {
                view[("pet_" + _local1)].petNameTF.mouseEnabled = false;
                view[("pet_" + _local1)].selectAsset.mouseEnabled = false;
                view[("pet_" + _local1)].selectAsset.visible = false;
                _local1++;
            };
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
            loadPic();
        }
        private function __batchHandler(_arg1:MouseEvent):void{
            if (itemInfo.PetInfo.IsUsing){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("出战中宠物不洗炼句")
                });
                return;
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.SHOW_PET_BATCHREBUILD_UI, itemInfo);
        }
        public function addEvents():void{
            QuickBuyBtn.addEventListener(MouseEvent.CLICK, __quickBuyBtnHandler);
            RebuildBtn.addEventListener(MouseEvent.CLICK, __rebuildHandler);
            BatchBtn.addEventListener(MouseEvent.CLICK, __batchHandler);
        }
        private function __quickBuyBtnHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:70200001});
        }
        public function addView():void{
            if (viewPanel){
                view.addChild(viewPanel);
                viewData.x = 166;
                viewData.y = 40;
                view.addChild(viewData);
                view.addChild(skillPanel);
                skillPanel.x = 337;
                skillPanel.y = 40;
                view.addChild(viewHelp);
                viewHelp.txt_Help.htmlText = (GameCommonData.HelpConfigItems["PetRebuild"].Text as String);
                view.addChild(view.getChildByName("toggleBtn_1"));
            } else {
                viewPanel = view.petViewPanel2;
                viewData = view.petViewData;
                skillPanel = view.petSkillPanel;
                viewHelp = view.petViewHelp;
            };
            QuickBuyBtn = new HLabelButton();
            QuickBuyBtn.label = LanguageMgr.GetTranslation("快速购买");
            QuickBuyBtn.x = 427;
            QuickBuyBtn.y = 178;
            view.addChild(QuickBuyBtn);
            RebuildBtn = new HLabelButton();
            RebuildBtn.label = LanguageMgr.GetTranslation("洗炼");
            RebuildBtn.x = 377;
            RebuildBtn.y = 215;
            view.addChild(RebuildBtn);
            BatchBtn = new HLabelButton();
            BatchBtn.label = LanguageMgr.GetTranslation("批量洗炼");
            BatchBtn.x = 427;
            BatchBtn.y = 215;
            view.addChild(BatchBtn);
            initView();
            addEvents();
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
                    updateInfo();
                };
            };
        }
        private function Cancel():void{
        }
        private function removeEvents():void{
            QuickBuyBtn.removeEventListener(MouseEvent.CLICK, __quickBuyBtnHandler);
            RebuildBtn.removeEventListener(MouseEvent.CLICK, __rebuildHandler);
            BatchBtn.removeEventListener(MouseEvent.CLICK, __batchHandler);
        }

    }
}//package GameUI.Modules.Pet.Mediator 
