//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import Net.RequestSend.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.FilterBag.Mediator.*;
    import GameUI.Modules.FilterBag.Proxy.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetViewPanel4 {

        private var useItem:UseItem;
        public var startLearn:Function;
        private var viewHelp:MovieClip = null;
        private var faceItem:FaceItem;
        private var filterUI:MovieClip;
        private var skillBookId:uint;
        private var LearnBtn:HLabelButton;
        private var viewPanel:MovieClip = null;
        private var itemInfo:InventoryItemInfo;
        private var QuickBuyBtn:HLabelButton;
        private var view:MovieClip;
        private var SkillCells:Array;
        private var petInfo:GamePetRole;
        private var viewData:MovieClip = null;
        private var listView:ListComponent = null;
        private var skillPanel:MovieClip = null;
        private var iScrollPane:UIScrollPane;

        public function PetViewPanel4(_arg1:MovieClip){
            view = _arg1;
            viewPanel = view.petViewPanel4;
            skillPanel = view.petSkillPanel;
            viewHelp = view.petViewHelp;
            view.removeChild(viewPanel);
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
        public function refreshPic(_arg1:Boolean=false):void{
            var _local2:uint;
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            if (useItem){
                if (_arg1){
                    useItem.Num = (useItem.Num - 1);
                };
                _local2 = useItem.Num;
                if (_local2 > 0){
                    faceItem = new FaceItem(String(UIConstData.ItemDic[useItem.itemIemplateInfo.TemplateID].img), null, "bagIcon", 1, _local2);
                    faceItem.Num = _local2;
                    faceItem.Id = useItem.Id;
                    faceItem.x = 0;
                    faceItem.y = 0;
                    view.petViewPanel4.PetLearn_1.addChild(faceItem);
                    faceItem.name = ("PetLearnT_" + useItem.itemIemplateInfo.TemplateID);
                    faceItem.setEnable(true);
                    view.petViewPanel4.txt_goldNeed.text = LanguageMgr.GetTranslation("1金");
                    faceItem.addEventListener(MouseEvent.CLICK, onContainerMouseClickHandler);
                };
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
        private function updateInfo():void{
            if (!petInfo){
                return;
            };
            createPetSkillCell();
        }
        public function clearInfo():void{
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
            view.petViewPanel4.txt_goldNeed.text = "";
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
        }
        private function sure():void{
        }
        public function requestLearn():void{
            EquipSend.PetLearn(itemInfo.ItemGUID, skillBookId);
        }
        private function initView():void{
            view.petViewPanel4.txt_goldNeed.text = "";
        }
        public function addEvents():void{
            QuickBuyBtn.addEventListener(MouseEvent.CLICK, __quickBuyBtnHandler);
            LearnBtn.addEventListener(MouseEvent.CLICK, __learnHandler);
        }
        public function removeView():void{
            if (faceItem){
                if (useItem){
                    UIFacade.GetInstance().sendNotification(EventList.FILTERBAGITEMUNLOCK, useItem.Id);
                    useItem.IsLock = false;
                };
            };
            (UIFacade.GetInstance().retrieveMediator(FilterBagMediator.NAME) as FilterBagMediator).alignGrid(1);
            listView.removeChild(filterUI);
            view.removeChild(iScrollPane);
            removeEvents();
            QuickBuyBtn.dispose();
            QuickBuyBtn = null;
            LearnBtn.dispose();
            LearnBtn = null;
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
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            view.removeChild(viewPanel);
            view.removeChild(skillPanel);
            view.removeChild(viewHelp);
        }
        private function onContainerMouseClickHandler(_arg1:MouseEvent):void{
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            view.petViewPanel4.txt_goldNeed.text = "";
            useItem.IsLock = false;
            UIFacade.GetInstance().sendNotification(EventList.FILTERBAGITEMUNLOCK, useItem.Id);
        }
        private function __quickBuyBtnHandler(_arg1:MouseEvent):void{
        }
        public function addView():void{
            if (viewPanel){
                view.addChild(viewPanel);
                view.addChild(skillPanel);
                skillPanel.x = 170;
                skillPanel.y = 40;
                view.addChild(viewHelp);
                viewHelp.txt_Help.text = (GameCommonData.HelpConfigItems["PetLearn"].Text as String);
            } else {
                viewPanel = view.petViewPanel4;
                skillPanel = view.petSkillPanel;
                viewHelp = view.petViewHelp;
            };
            QuickBuyBtn = new HLabelButton();
            QuickBuyBtn.label = "快速购买";
            QuickBuyBtn.x = 250;
            QuickBuyBtn.y = 178;
            view.addChild(QuickBuyBtn);
            QuickBuyBtn.visible = false;
            LearnBtn = new HLabelButton();
            LearnBtn.label = "学习";
            LearnBtn.x = 280;
            LearnBtn.y = 215;
            view.addChild(LearnBtn);
            filterUI = (UIFacade.GetInstance().retrieveMediator(FilterBagMediator.NAME).getViewComponent() as MovieClip);
            (UIFacade.GetInstance().retrieveMediator(FilterBagMediator.NAME) as FilterBagMediator).alignGrid(0);
            listView = new ListComponent(false);
            listView.addChild(filterUI);
            listView.width = 130;
            listView.upDataPos();
            iScrollPane = new UIScrollPane(listView);
            iScrollPane.x = 370;
            iScrollPane.y = 37;
            iScrollPane.width = 140;
            iScrollPane.height = 200;
            iScrollPane.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            iScrollPane.refresh();
            view.addChild(iScrollPane);
            filterUI.x = 0;
            filterUI.y = 0;
            initView();
            addEvents();
        }
        public function setUseItem(_arg1:UseItem):void{
            if ((((_arg1 == null)) && (useItem))){
                useItem.IsLock = false;
                UIFacade.GetInstance().sendNotification(EventList.FILTERBAGITEMUNLOCK, useItem.Id);
            };
            useItem = _arg1;
            if (useItem){
                skillBookId = FilterBagData.AllItems[0][useItem.Pos].ItemGUID;
            };
            refreshPic();
        }
        private function removeEvents():void{
            QuickBuyBtn.removeEventListener(MouseEvent.CLICK, __quickBuyBtnHandler);
            LearnBtn.removeEventListener(MouseEvent.CLICK, __learnHandler);
        }
        private function __learnHandler(_arg1:MouseEvent):void{
            if (!itemInfo){
                MessageTip.show(LanguageMgr.GetTranslation("请选择宠物"));
                return;
            };
            if (faceItem == null){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("请放入技能书")
                });
                return;
            };
            if (GameCommonData.Player.Role.Gold < 10000){
                UIFacade.GetInstance().LackofGold();
                return;
            };
            if (itemInfo.PetInfo.IsUsing){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:sure,
                    cancel:null,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("出战宠不能学技能")
                });
                return;
            };
            startLearn();
        }

    }
}//package GameUI.Modules.Pet.Mediator 
