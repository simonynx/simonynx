//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.Pet.Data.*;
    import GameUI.Modules.Bag.*;

    public class PetViewPanel1 {

        private var bgPic:Bitmap = null;
        private var faceItem:FaceItem;
        private var backToBagBtn:HLabelButton;
        private var reNameBtn:HLabelButton;
        private var viewPanel:MovieClip = null;
        private var itemInfo:InventoryItemInfo;
        private var expBarMaskWidth:uint;
        private var view:MovieClip;
        private var SkillCells:Array;
        private var petInfo:GamePetRole;
        public var outBtn:HLabelButton = null;
        private var viewData:MovieClip = null;
        private var skillPanel:MovieClip = null;
        private var showBtn:HLabelButton = null;

        public function PetViewPanel1(_arg1:MovieClip){
            view = _arg1;
        }
        private function onLoabdComplete():void{
            bgPic = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "pet_bg1") + ".jpg"));
            view.petViewPanel1.addChildAt(bgPic, 1);
            bgPic.x = 5;
            bgPic.y = 4;
        }
        private function __outHandler(_arg1:MouseEvent):void{
            if (itemInfo){
                if ((_arg1.currentTarget as HLabelButton).label == LanguageMgr.GetTranslation("出战")){
                    if (GameCommonData.Player.Role.UsingPetAnimal){
                        PetSend.Rest();
                    };
                    PetSend.Out(itemInfo.Place);
                    if (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 4)))) && ((NewGuideData.curStep == 2)))){
                        UIFacade.GetInstance().sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                    };
                } else {
                    PetSend.Rest();
                };
            } else {
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
            };
        }
        private function loadPic():void{
            if (bgPic == null){
                ResourcesFactory.getInstance().getResource((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/") + "pet_bg1") + ".jpg"), onLoabdComplete);
            } else {
                view.petViewPanel1.addChildAt(bgPic, 1);
            };
        }
        public function updatePetInfo(_arg1:InventoryItemInfo):void{
            var _local5:NewSkillCell;
            var _local7:String;
            if (((!(_arg1)) || (!(_arg1.PetInfo)))){
                return;
            };
            var _local2:GamePetRole = _arg1.PetInfo;
            view.petViewPanel1.nameTF.text = _local2.PetName;
            view.petViewPanel1.startTF.text = (_local2.Start + LanguageMgr.GetTranslation("星"));
            view.petViewPanel1.levelTF.text = _local2.Level;
            view.petViewPanel1.expTF.text = (int(((_local2.ExpNow / UIConstData.PetExpDic[_local2.Level]) * 100)) + "%");
            view.petViewPanel1.expBarMask.width = (Number((_local2.ExpNow / UIConstData.PetExpDic[_local2.Level])) * expBarMaskWidth);
            view.petViewPanel1.petTypeTF.text = _local2.MainType;
            view.petViewPanel1.petSubTypeTF.text = _local2.SubType;
            view.petViewData.mcMain.visible = true;
            view.petViewData.mcSub.visible = true;
            view.petViewData.mcMain.y = (-2 + (uint((GamePetRole.getPanelPos((_local2.PetType / 10000)) - 1)) * 24.3));
            view.petViewData.mcSub.y = (-2 + (uint((GamePetRole.getPanelPos((_local2.PetType % 10000)) - 1)) * 24.3));
            view.petViewPanel1.hpTF.text = _arg1.HpBonus;
            view.petViewPanel1.mpTF.text = _arg1.MpBonus;
            view.petViewPanel1.attTF.text = _arg1.Attack;
            view.petViewPanel1.defTF.text = _arg1.Defence;
            view.petViewPanel1.hitTF.text = _arg1.NormalHit;
            view.petViewPanel1.dodgeTF.text = _arg1.NormalDodge;
            view.petViewPanel1.critTF.text = (String(Number(_arg1.CriticalRate).toFixed(1)) + "%");
            view.petViewPanel1.critRateTF.text = (String(Number(_arg1.CriticalDamage).toFixed(1)) + "%");
            if (viewData){
                for each (_local7 in PetPropConstData.petColorObj) {
                    viewData[_local7].textColor = 14074524;
                };
                viewData[PetPropConstData.petColorObj[_local2.MainType]].textColor = 0xFF00FF;
                viewData[PetPropConstData.petColorObj[_local2.SubType]].textColor = 0xFF00;
            };
            view.petViewData.hpTF.text = ((_local2.Hp + "/") + _local2.HpMax);
            view.petViewData.mpTF.text = ((_local2.Mp + "/") + _local2.MpMax);
            view.petViewData.attTF.text = _local2.Attack;
            view.petViewData.defTF.text = _local2.Defense;
            view.petViewData.hitTF.text = _local2.Hit;
            view.petViewData.dodgeTF.text = _local2.Dodge;
            view.petViewData.critTF.text = (Number((_local2.Crit * 100)).toFixed(2) + "%");
            view.petViewData.critRateTF.text = (Number((_local2.CritRate * 100)).toFixed(2) + "%");
            var _local3:int = Math.min((5 * _local2.Level), 500);
            var _local4:int;
            if (((SkillCells) && ((SkillCells.length > 0)))){
                while (_local4 < SkillCells.length) {
                    if (SkillCells[_local4].parent){
                        SkillCells[_local4].dispose();
                        SkillCells[_local4].parent.removeChild(SkillCells[_local4]);
                        SkillCells[_local4] = null;
                    };
                    _local4++;
                };
            };
            SkillCells = [];
            var _local6:Array = [];
            _local6.push(_arg1.PetInfo.SpecialSkill);
            _local6 = _local6.concat(_arg1.PetInfo.CommonSkills);
            _local4 = 0;
            while (_local4 < _local6.length) {
                if (GameCommonData.SkillList[_local6[_local4]] == null){
                    _local4++;
                } else {
                    _local5 = new NewSkillCell();
                    _local5.setPetSkillInfo(GameCommonData.SkillList[_local6[_local4]]);
                    _local5.x = ((view.petSkillPanel[("petskill_" + _local4)].x + view.petSkillPanel[("petskill_" + _local4)].parent.x) + 1.5);
                    _local5.y = ((view.petSkillPanel[("petskill_" + _local4)].y + view.petSkillPanel[("petskill_" + _local4)].parent.y) + 1.5);
                    view.addChild(_local5);
                    SkillCells.push(_local5);
                    _local4++;
                };
            };
            showBtns(false);
        }
        public function selectItem(_arg1:InventoryItemInfo):void{
            this.itemInfo = _arg1;
            if (_arg1){
                petInfo = _arg1.PetInfo;
                outBtn.label = (_arg1.PetInfo.IsUsing) ? LanguageMgr.GetTranslation("休息") : LanguageMgr.GetTranslation("出战");
                updateInfo();
            };
        }
        public function removeView():void{
            removeEvents();
            backToBagBtn.dispose();
            backToBagBtn = null;
            outBtn.visible = false;
            reNameBtn.visible = false;
            showBtn.visible = false;
            reNameBtn.dispose();
            reNameBtn = null;
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
            if (((bgPic) && (bgPic.parent))){
                bgPic.parent.addChild(bgPic);
            };
            view.removeChild(viewPanel);
            view.removeChild(viewData);
            view.removeChild(skillPanel);
        }
        private function createPetPic():void{
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            faceItem = new FaceItem(String(itemInfo.AdditionFields[1]), null, "PetFace", 1);
            faceItem.x = 22;
            faceItem.y = 38;
            view.addChild(faceItem);
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
            view.petViewPanel1.nameTF.text = "";
            view.petViewPanel1.startTF.text = "";
            view.petViewPanel1.levelTF.text = "";
            view.petViewPanel1.expTF.text = "";
            view.petViewPanel1.expBar.mask = view.petViewPanel1.expBarMask;
            if (expBarMaskWidth == 0){
                expBarMaskWidth = view.petViewPanel1.expBarMask.width;
            };
            view.petViewPanel1.expBarMask.width = 0;
            view.petViewPanel1.petTypeTF.text = "";
            view.petViewPanel1.petSubTypeTF.text = "";
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
            view.petViewPanel1.hpTF.text = "";
            view.petViewPanel1.mpTF.text = "";
            view.petViewPanel1.attTF.text = "";
            view.petViewPanel1.defTF.text = "";
            view.petViewPanel1.hitTF.text = "";
            view.petViewPanel1.dodgeTF.text = "";
            view.petViewPanel1.critTF.text = "";
            view.petViewPanel1.critRateTF.text = "";
        }
        private function updateInfo():void{
            var _local2:String;
            if (!petInfo){
                return;
            };
            view.petViewPanel1.nameTF.text = petInfo.PetName;
            view.petViewPanel1.startTF.text = (petInfo.Start + LanguageMgr.GetTranslation("星"));
            view.petViewPanel1.levelTF.text = petInfo.Level;
            view.petViewPanel1.expTF.text = (int(((petInfo.ExpNow / UIConstData.PetExpDic[petInfo.Level]) * 100)) + "%");
            view.petViewPanel1.expBarMask.width = (Number((petInfo.ExpNow / UIConstData.PetExpDic[petInfo.Level])) * expBarMaskWidth);
            view.petViewPanel1.petTypeTF.text = petInfo.MainType;
            view.petViewPanel1.petSubTypeTF.text = petInfo.SubType;
            view.petViewData.mcMain.visible = true;
            view.petViewData.mcSub.visible = true;
            view.petViewData.mcMain.y = (-2 + (uint((GamePetRole.getPanelPos((petInfo.PetType / 10000)) - 1)) * 24.3));
            view.petViewData.mcSub.y = (-2 + (uint((GamePetRole.getPanelPos((petInfo.PetType % 10000)) - 1)) * 24.3));
            view.petViewPanel1.hpTF.text = itemInfo.HpBonus;
            view.petViewPanel1.mpTF.text = itemInfo.MpBonus;
            view.petViewPanel1.attTF.text = itemInfo.Attack;
            view.petViewPanel1.defTF.text = itemInfo.Defence;
            view.petViewPanel1.hitTF.text = itemInfo.NormalHit;
            view.petViewPanel1.dodgeTF.text = itemInfo.NormalDodge;
            view.petViewPanel1.critTF.text = (String(Number(itemInfo.CriticalRate).toFixed(1)) + "%");
            view.petViewPanel1.critRateTF.text = (String(Number(itemInfo.CriticalDamage).toFixed(1)) + "%");
            if (viewData){
                for each (_local2 in PetPropConstData.petColorObj) {
                    viewData[_local2].textColor = 14074524;
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
            view.petViewData.critTF.text = (Number((petInfo.Crit * 100)).toFixed(2) + "%");
            view.petViewData.critRateTF.text = (Number((petInfo.CritRate * 100)).toFixed(2) + "%");
            var _local1:int = Math.min((5 * petInfo.Level), 500);
            createPetSkillCell();
        }
        public function clearInfo():void{
            view.petViewPanel1.nameTF.text = "";
            view.petViewPanel1.startTF.text = "";
            view.petViewPanel1.levelTF.text = "";
            view.petViewPanel1.expTF.text = "";
            view.petViewPanel1.expBarMask.width = 0;
            view.petViewPanel1.petTypeTF.text = "";
            view.petViewPanel1.petSubTypeTF.text = "";
            view.petViewPanel1.hpTF.text = "";
            view.petViewPanel1.mpTF.text = "";
            view.petViewPanel1.attTF.text = "";
            view.petViewPanel1.defTF.text = "";
            view.petViewPanel1.hitTF.text = "";
            view.petViewPanel1.dodgeTF.text = "";
            view.petViewPanel1.critTF.text = "";
            view.petViewPanel1.critRateTF.text = "";
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
        public function addEvents():void{
            backToBagBtn.addEventListener(MouseEvent.CLICK, __backToBagHandler);
            outBtn.addEventListener(MouseEvent.CLICK, __outHandler);
            reNameBtn.addEventListener(MouseEvent.CLICK, __reNameHandler);
            showBtn.addEventListener(MouseEvent.CLICK, __showHandler);
        }
        private function __backToBagHandler(_arg1:MouseEvent):void{
            var _local2:int;
            if (BagData.getPanelEmptyNum(0) <= 0){
                MessageTip.show(LanguageMgr.GetTranslation("背包已满"));
                return;
            };
            if (GameCommonData.IsInCrossServer){
                MessageTip.popup(LanguageMgr.GetTranslation("跨服战宠物不收回"));
                return;
            };
            if (itemInfo){
                if (itemInfo.PetInfo == GameCommonData.Player.Role.UsingPet){
                    PetSend.Rest();
                };
                _local2 = BagUtils.getNullItemIndex(0);
                if (_local2 != -1){
                    BagInfoSend.ItemSwap(itemInfo.Place, ItemConst.gridUnitToPlace(0, _local2));
                };
                itemInfo = null;
            };
        }
        private function __showHandler(_arg1:MouseEvent):void{
            if (itemInfo == null){
                return;
            };
            var _local2:uint = itemInfo.id;
            var _local3:uint = itemInfo.type;
            var _local4:String = itemInfo.Name;
            var _local5:uint = 1;
            var _local6:uint = itemInfo.Color;
            var _local7:uint = itemInfo.MainClass;
            var _local8:uint = itemInfo.SubClass;
            var _local9 = "";
            _local9 = itemInfo.WriteConcatString();
            var _local10 = (((((((((((((("<1_[" + _local4) + "]_") + _local2) + "_") + _local3) + "_") + GameCommonData.Player.Role.Id) + "_") + _local5) + "_") + _local6) + "_") + _local9) + ">");
            UIFacade.GetInstance().sendNotification(ChatEvents.ADDITEMINCHAT, _local10);
        }
        public function addView():void{
            if (viewPanel){
                view.addChild(viewPanel);
                view.addChild(viewData);
                view.addChild(skillPanel);
                view.addChild(view.getChildByName("toggleBtn_0"));
            } else {
                viewPanel = view.petViewPanel1;
                viewData = view.petViewData;
                skillPanel = view.petSkillPanel;
            };
            skillPanel.x = 342;
            skillPanel.y = 236;
            viewData.x = 172;
            viewData.y = 170;
            loadPic();
            backToBagBtn = new HLabelButton();
            backToBagBtn.label = LanguageMgr.GetTranslation("收回背包");
            backToBagBtn.x = 420;
            backToBagBtn.y = 60;
            view.addChild(backToBagBtn);
            if (outBtn == null){
                outBtn = new HLabelButton();
                outBtn.label = LanguageMgr.GetTranslation("出战");
                outBtn.x = 420;
                outBtn.y = 85;
                view.addChild(outBtn);
            } else {
                view.addChild(outBtn);
                outBtn.visible = true;
            };
            reNameBtn = new HLabelButton();
            reNameBtn.label = LanguageMgr.GetTranslation("改名");
            reNameBtn.x = 420;
            reNameBtn.y = 35;
            view.addChild(reNameBtn);
            if (showBtn == null){
                showBtn = new HLabelButton();
                showBtn.label = LanguageMgr.GetTranslation("炫耀");
                showBtn.x = 420;
                showBtn.y = 110;
                view.addChild(showBtn);
            } else {
                view.addChild(showBtn);
                showBtn.visible = true;
            };
            initView();
            addEvents();
        }
        public function showBtns(_arg1:Boolean=true):void{
            if (backToBagBtn){
                backToBagBtn.visible = _arg1;
            };
            if (outBtn){
                outBtn.visible = _arg1;
            };
            if (reNameBtn){
                reNameBtn.visible = _arg1;
            };
            if (showBtn){
                showBtn.visible = _arg1;
            };
        }
        private function __reNameHandler(_arg1:MouseEvent):void{
            if (!itemInfo){
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
                return;
            };
            if (GameCommonData.IsInCrossServer){
                MessageTip.popup(LanguageMgr.GetTranslation("跨服战禁宠物改名"));
                return;
            };
            UIFacade.GetInstance().sendNotification(PetEvent.PET_RENAMEVIEW_SHOW, itemInfo);
        }
        private function removeEvents():void{
            if (backToBagBtn){
                backToBagBtn.removeEventListener(MouseEvent.CLICK, __backToBagHandler);
            };
            if (outBtn){
                outBtn.removeEventListener(MouseEvent.CLICK, __outHandler);
            };
            if (reNameBtn){
                reNameBtn.removeEventListener(MouseEvent.CLICK, __reNameHandler);
            };
            if (showBtn){
                showBtn.removeEventListener(MouseEvent.CLICK, __showHandler);
            };
        }

    }
}//package GameUI.Modules.Pet.Mediator 
