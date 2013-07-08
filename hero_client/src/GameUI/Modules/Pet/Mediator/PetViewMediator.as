//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetViewMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "PetViewMediator";

        private var hframe:HFrame;
        public var toggleBtns:Array;
        private var itemArray:Array;
        private var faceItem:FaceItem;
        private var initFlag:Boolean = false;
        private var currentSelectIdx:int;
        private var panel1:PetViewPanel1 = null;
        private var panel2:PetViewPanel2 = null;
        private var panel3:PetViewPanel3 = null;
        private var panel4:PetViewPanel4 = null;
        private var panel5:PetViewPanel5 = null;
        private var showBtns:Boolean = false;
        public var outBtn:HLabelButton;
        private var enabled:Boolean = true;
        private var commitFlag:Boolean = false;
        private var localMS:Number;
        private var dataProxy:DataProxy;
        private var currPage:uint = 0;
        private var loadPro:MovieClip;
        private var itemInfo:InventoryItemInfo;
        private var timeCounter:Number = 2000;
        private var labels:Array;

        public function PetViewMediator(){
            itemArray = [];
            labels = ["宠物属性", "宠物洗炼", "宠物升星", "技能学习", "宠物资质"];
            super(NAME);
        }
        private function createPetPic():void{
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            var _local1:Array = getPetList();
            if (_local1.length > 0){
                if (itemInfo != null){
                    faceItem = new FaceItem(String(itemInfo.AdditionFields[1]), null, "PetFace", 1);
                } else {
                    if (_local1[currentSelectIdx] == null){
                        currentSelectIdx = 0;
                    };
                    if (_local1[currentSelectIdx] == null){
                        return;
                    };
                    faceItem = new FaceItem(String(_local1[currentSelectIdx].AdditionFields[1]), null, "PetFace", 1);
                };
                faceItem.x = 1;
                faceItem.y = 33;
                view.addChild(faceItem);
            };
        }
        private function __clickHandler(_arg1:MouseEvent):void{
            var _local2:int = _arg1.currentTarget.name.split("_")[1];
            selectItem(_local2);
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        private function removePanel(_arg1:uint):void{
            switch (_arg1){
                case 0:
                    panel1.removeView();
                    break;
                case 1:
                    panel2.removeView();
                    break;
                case 2:
                    panel3.removeView();
                    break;
                case 3:
                    panel4.removeView();
                    break;
                case 4:
                    panel5.removeView();
                    break;
            };
        }
        private function addEvents():void{
            var _local1:uint;
            _local1 = 0;
            while (_local1 < PetPropConstData.EQUIP_NUM) {
                view[("pet_" + _local1)].addEventListener(MouseEvent.CLICK, __clickHandler);
                _local1++;
            };
        }
        public function get Enabled():Boolean{
            return (enabled);
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        private function getPetList():Array{
            var _local1:int;
            var _local2:Array = [];
            while (_local1 < PetPropConstData.EQUIP_NUM) {
                if (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local1)]]){
                    _local2.push(RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local1)]]);
                };
                _local1++;
            };
            return (_local2);
        }
        private function get view():MovieClip{
            return ((getViewComponent() as MovieClip));
        }
        private function closeHandler():void{
            if (NewGuideData.newerHelpIsOpen){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                if ((((NewGuideData.curType == 8)) && ((NewGuideData.curStep <= 6)))){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:8,
                        STEP:7
                    });
                };
                facade.sendNotification(Guide_PetUpstarCommand.NAME, {step:5});
                facade.sendNotification(Guide_PetQualityRefreshCommand.NAME, {step:5});
            };
            var _local1:int;
            endLoading();
            removePanel(currPage);
            dataProxy.PetIsOpen = false;
            if (GameCommonData.GameInstance.GameUI.contains(hframe)){
                hframe.close();
            };
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
            currentSelectIdx = 0;
            currPage = 0;
            _local1 = 0;
            while (_local1 < toggleBtns.length) {
                if (_local1 == 0){
                    (toggleBtns[_local1] as ToggleButton).selected = true;
                } else {
                    (toggleBtns[_local1] as ToggleButton).selected = false;
                };
                _local1++;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    if (!initFlag){
                        initFlag = true;
                        facade.sendNotification(EventList.GETRESOURCE, {
                            type:UIConfigData.MOVIECLIP,
                            mediator:this,
                            name:"PetViewAsset"
                        });
                        facade.registerMediator(new PetRenameMediator());
                        initView();
                        addEvents();
                    };
                    break;
                case EventList.SHOWPETVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    if (dataProxy.ForgeOpenFlag >= DataProxy.FORGE_TREASURE_START){
                        facade.sendNotification(EquipCommandList.CLOSETREASURE_CMDLIST[(dataProxy.ForgeOpenFlag - DataProxy.FORGE_TREASURE_START)]);
                    } else {
                        if (dataProxy.ForgeOpenFlag >= DataProxy.FORGE_EQUIP_START){
                            facade.sendNotification(EquipCommandList.CLOSEEQUIP_CMDLIST[(dataProxy.ForgeOpenFlag - DataProxy.FORGE_EQUIP_START)]);
                        };
                    };
                    if (!dataProxy.PetIsOpen){
                        dataProxy.PetIsOpen = true;
                        GameCommonData.GameInstance.GameUI.addChild(hframe);
                    };
                    showBtns = true;
                    initPanel();
                    showTogBtns(showBtns);
                    updatePetList();
                    if (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 8)))) && ((NewGuideData.curStep == 4)))){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:8,
                            STEP:5
                        });
                    };
                    facade.sendNotification(Guide_PetUpstarCommand.NAME, {
                        step:2,
                        data:{target:toggleBtns[2]}
                    });
                    facade.sendNotification(Guide_PetQualityRefreshCommand.NAME, {
                        step:2,
                        data:{target:toggleBtns[4]}
                    });
                    break;
                case EventList.CLOSEPETVIEW:
                    closeHandler();
                    break;
                case RoleEvents.UPDATEOUTFIT:
                    if (dataProxy == null){
                        dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    };
                    if (showBtns == false){
                        return;
                    };
                    if (!dataProxy.PetIsOpen){
                        return;
                    };
                    updatePetList();
                    break;
                case PlayerInfoComList.UPDATE_PET_UI:
                    if (dataProxy == null){
                        dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    };
                    if (showBtns == false){
                        return;
                    };
                    if (!dataProxy.PetIsOpen){
                        return;
                    };
                    if ((((((this.getPetList().length > 0)) && (this.getPetList()[currentSelectIdx]))) && (!((this.getPetList()[currentSelectIdx].PetInfo == GameCommonData.Player.Role.UsingPet))))){
                        return;
                    };
                    if (((GameCommonData.Player.Role.UsingPet) && (GameCommonData.Player.Role.UsingPetAnimal))){
                        GameCommonData.Player.Role.UsingPet.Hp = GameCommonData.Player.Role.UsingPetAnimal.Role.HP;
                        GameCommonData.Player.Role.UsingPet.Mp = GameCommonData.Player.Role.UsingPetAnimal.Role.MP;
                        updatePetList();
                    };
                    break;
                case RoleEvents.FIT_PET:
                    _local2 = getFirstNull();
                    if (_local2 == -1){
                        MessageTip.show(LanguageMgr.GetTranslation("宠物栏没空位"));
                    } else {
                        BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex), _local2);
                    };
                    break;
                case EquipCommandList.REFRESH_PET_STRENGTHEN:
                    if (showBtns == false){
                        return;
                    };
                    if (currPage == 2){
                        panel3.refreshPic();
                        selectItem(currentSelectIdx);
                    };
                    if (_arg1.getBody().sucess){
                    };
                    break;
                case EquipCommandList.REFRESH_PET_REBUILD:
                    if (showBtns == false){
                        return;
                    };
                    if (currPage == 1){
                        panel2.refreshPic();
                        selectItem(currentSelectIdx);
                    };
                    break;
                case EquipCommandList.REFRESH_PET_LEARN:
                    if (showBtns == false){
                        return;
                    };
                    if (currPage == 3){
                        panel4.refreshPic(true);
                        selectItem(currentSelectIdx);
                    };
                    break;
                case EquipCommandList.UPDATE_LEARN_PET:
                    if (showBtns == false){
                        return;
                    };
                    if (currPage == 3){
                        panel4.setUseItem(_arg1.getBody().useItem);
                    };
                    break;
                case EventList.UPDATEBAG:
                    if (panel3 != null){
                        panel3.refreshStrenPearlCount();
                    };
                    break;
                case EventList.SHOWONEPETVIEW:
                    showBtns = false;
                    showPanelWithInfo((_arg1.getBody() as Array));
                    break;
                case EquipCommandList.UPDATE_QUICKBUY_ITEM:
                    if ((((currPage == 4)) && (!((PetPropConstData.ItemIds.indexOf(uint(_arg1.getBody())) == -1))))){
                        panel5.updateNums();
                    };
                    break;
            };
        }
        private function showPanelWithInfo(_arg1:Array):void{
            var _local3:uint;
            var _local4:Array;
            var _local5:InventoryItemInfo;
            itemArray = _arg1;
            initPanel();
            if (panel1){
                _local3 = 0;
                _local3 = 0;
                while (_local3 < PetPropConstData.EQUIP_NUM) {
                    view[("pet_" + _local3)].selectAsset.visible = false;
                    _local3++;
                };
                if (((faceItem) && (faceItem.parent))){
                    faceItem.parent.removeChild(faceItem);
                    faceItem = null;
                };
                _local4 = _arg1;
                if (_local4.length > 0){
                    faceItem = new FaceItem(String(_local4[0].AdditionFields[1]), null, "PetFace", 1);
                    faceItem.x = 1;
                    faceItem.y = 38;
                    view.addChild(faceItem);
                };
                _local3 = 0;
                while (_local3 < PetPropConstData.EQUIP_NUM) {
                    view[("pet_" + _local3)].visible = false;
                    view[("pet_" + _local3)].petNameTF.text = "";
                    _local3++;
                };
                view.petCntTF.text = (("(0/" + PetPropConstData.EQUIP_NUM) + ")");
                panel1.clearInfo();
            };
            var _local2:int;
            while (_local2 < _arg1.length) {
                _local5 = _arg1[_local2];
                if (!dataProxy.PetIsOpen){
                    dataProxy.PetIsOpen = true;
                    GameCommonData.GameInstance.GameUI.addChild(hframe);
                };
                view[("pet_" + _local2)].visible = true;
                view[("pet_" + _local2)].petNameTF.text = _local5.PetInfo.PetName;
                view[("pet_" + _local2)].petNameTF.textColor = IntroConst.EquipColors[_local5.Color];
                view.petCntTF.text = (((("(" + (_local2 + 1)) + "/") + PetPropConstData.EQUIP_NUM) + ")");
                _local2++;
            };
            panel1.updatePetInfo(_arg1[0]);
            if (_arg1[0]){
                view.pet_0.selectAsset.visible = true;
            };
            showTogBtns(false);
        }
        private function removeEvents():void{
            var _local1:uint;
            _local1 = 0;
            while (_local1 < PetPropConstData.EQUIP_NUM) {
                view[("pet_" + _local1)].removeEventListener(MouseEvent.CLICK, __clickHandler);
                _local1++;
            };
        }
        private function initPage():void{
            var _local1:int;
            if (toggleBtns == null){
                toggleBtns = new Array(labels.length);
                _local1 = 0;
                while (_local1 < toggleBtns.length) {
                    if (toggleBtns[_local1] == null){
                        toggleBtns[_local1] = new ToggleButton(1, labels[_local1]);
                        (toggleBtns[_local1] as ToggleButton).y = 9;
                        (toggleBtns[_local1] as ToggleButton).name = ("toggleBtn_" + _local1);
                        (toggleBtns[_local1] as ToggleButton).addEventListener(MouseEvent.CLICK, choicePageHandler);
                        if (_local1 == 0){
                            (toggleBtns[_local1] as ToggleButton).selected = true;
                            (toggleBtns[_local1] as ToggleButton).x = 153;
                        } else {
                            (toggleBtns[_local1] as ToggleButton).selected = false;
                            if (_local1 == 4){
                                (toggleBtns[_local1] as ToggleButton).x = (((toggleBtns[2] as ToggleButton).x + (toggleBtns[2] as ToggleButton).width) + 2);
                            } else {
                                (toggleBtns[_local1] as ToggleButton).x = (((toggleBtns[(_local1 - 1)] as ToggleButton).x + (toggleBtns[(_local1 - 1)] as ToggleButton).width) + 2);
                            };
                        };
                    };
                    view.addChild(toggleBtns[_local1]);
                    _local1++;
                };
            };
            toggleBtns[3].visible = false;
        }
        private function commitEquip():void{
            if (currPage == 1){
                panel2.requestRebuild();
            } else {
                if (currPage == 2){
                    panel3.requestStrengthen();
                } else {
                    if (currPage == 3){
                        panel4.requestLearn();
                    };
                };
            };
            endLoading();
        }
        public function get closeBtn():SimpleButton{
            return (hframe.closeBtn);
        }
        private function showTogBtns(_arg1:Boolean):void{
            var _local2:int;
            while (_local2 < toggleBtns.length) {
                toggleBtns[_local2].visible = _arg1;
                _local2++;
            };
            toggleBtns[3].visible = false;
        }
        private function selectItem(_arg1:int):void{
            var _local3:int;
            currentSelectIdx = _arg1;
            var _local2:uint;
            _local2 = 0;
            while (_local2 < PetPropConstData.EQUIP_NUM) {
                view[("pet_" + _local2)].selectAsset.visible = false;
                _local2++;
            };
            if (showBtns){
                if ((((_arg1 >= 0)) && ((_arg1 < PetPropConstData.EQUIP_NUM)))){
                    _local3 = 0;
                    while ((((_local3 < PetPropConstData.EQUIP_NUM)) && ((_arg1 >= 0)))) {
                        itemInfo = (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local3)]] as InventoryItemInfo);
                        if (itemInfo){
                            _arg1--;
                        };
                        _local3++;
                    };
                };
            } else {
                itemInfo = itemArray[_arg1];
            };
            createPetPic();
            _arg1 = currentSelectIdx;
            if ((((_arg1 >= 0)) && ((_arg1 < PetPropConstData.EQUIP_NUM)))){
                view[("pet_" + _arg1)].selectAsset.visible = true;
            };
            if (currPage == 0){
                if (panel1){
                    panel1.selectItem(itemInfo);
                    panel1.showBtns(showBtns);
                };
            } else {
                if (currPage == 1){
                    if (panel2){
                        panel2.selectItem(_arg1);
                        endLoading();
                    };
                } else {
                    if (currPage == 2){
                        if (panel3){
                            panel3.selectItem(_arg1);
                            endLoading();
                        };
                    } else {
                        if (currPage == 3){
                            if (panel4){
                                panel4.selectItem(_arg1);
                                panel4.setUseItem(null);
                                endLoading();
                            };
                        } else {
                            if (currPage == 4){
                                if (panel5){
                                    panel5.selectItem(_arg1);
                                    endLoading();
                                };
                            };
                        };
                    };
                };
            };
        }
        private function initPanel():void{
            hframe.x = uint(((GameCommonData.GameInstance.ScreenWidth - hframe.frameWidth) / 2));
            hframe.y = uint(((GameCommonData.GameInstance.ScreenHeight - hframe.frameHeight) / 2));
            if (panel1 == null){
                panel1 = new PetViewPanel1(this.view);
                panel2 = new PetViewPanel2(this.view);
                panel2.startRebuild = startPeting;
                panel3 = new PetViewPanel3(this.view);
                panel3.startStrengthen = startPeting;
                panel4 = new PetViewPanel4(this.view);
                panel4.startLearn = startPeting;
                panel5 = new PetViewPanel5(this.view);
                panel1.addView();
                selectItem(0);
                outBtn = panel1.outBtn;
            } else {
                addPanel(currPage);
            };
            initPage();
        }
        private function initView():void{
            UIUtils.fangDou(view);
            hframe = new HFrame();
            hframe.titleText = LanguageMgr.GetTranslation("宠 物");
            hframe.centerTitle = true;
            hframe.setContentSize(487, 340);
            hframe.addContent(view);
            view.x = -16;
            view.y = -18;
            hframe.blackGound = false;
            hframe.x = int(((GameCommonData.GameInstance.ScreenWidth - hframe.frameWidth) / 2));
            hframe.y = int(((GameCommonData.GameInstance.ScreenHeight - hframe.frameHeight) / 2));
            hframe.closeCallBack = closeHandler;
            var _local1:uint;
            _local1 = 0;
            while (_local1 < PetPropConstData.EQUIP_NUM) {
                view[("pet_" + _local1)].petNameTF.mouseEnabled = false;
                view[("pet_" + _local1)].selectAsset.mouseEnabled = false;
                view[("pet_" + _local1)].selectAsset.visible = false;
                _local1++;
            };
            loadPro = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("CollectProgressAsset");
            loadPro.progressMc.mask = loadPro.progressMask;
            this.view.addChild(loadPro);
            loadPro.x = 56;
            loadPro.y = 160;
            loadPro.progressMask.width = 0;
            loadPro.visible = false;
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function updatePetList():void{
            var _local4:InventoryItemInfo;
            var _local7:uint;
            if (showBtns == false){
                return;
            };
            var _local1:int;
            var _local2:Array = getPetList();
            var _local3:int = _local2.length;
            _local1 = 0;
            if (currentSelectIdx >= _local2.length){
                currentSelectIdx = 0;
            };
            if (getPetList().length == 0){
                if (panel1){
                    _local7 = 0;
                    _local7 = 0;
                    while (_local7 < PetPropConstData.EQUIP_NUM) {
                        view[("pet_" + _local7)].selectAsset.visible = false;
                        _local7++;
                    };
                    createPetPic();
                    _local7 = 0;
                    while (_local7 < PetPropConstData.EQUIP_NUM) {
                        view[("pet_" + _local7)].visible = false;
                        view[("pet_" + _local7)].petNameTF.text = "";
                        _local7++;
                    };
                    view.petCntTF.text = (("(0/" + PetPropConstData.EQUIP_NUM) + ")");
                    panel1.clearInfo();
                    this.itemInfo = null;
                    selectItem(currentSelectIdx);
                    return;
                };
            };
            var _local5:String = LanguageMgr.GetTranslation("出战");
            var _local6:String = LanguageMgr.GetTranslation("休息");
            if (((((_local2[currentSelectIdx]) && (_local2[currentSelectIdx].PetInfo))) && (outBtn))){
                outBtn.label = (_local2[currentSelectIdx].PetInfo.IsUsing) ? _local6 : _local5;
            };
            while (_local1 < PetPropConstData.EQUIP_NUM) {
                if (_local2.length > 0){
                    _local4 = (_local2.shift() as InventoryItemInfo);
                    view[("pet_" + _local1)].visible = true;
                    view[("pet_" + _local1)].petNameTF.text = _local4.PetInfo.PetName;
                    if (_local4.PetInfo.IsUsing){
                        view[("pet_" + _local1)].petNameTF.text = (((_local4.PetInfo.PetName + "(") + _local5) + ")");
                    };
                    view[("pet_" + _local1)].petNameTF.textColor = IntroConst.EquipColors[_local4.Color];
                } else {
                    view[("pet_" + _local1)].visible = false;
                };
                _local1++;
            };
            view.petCntTF.text = (((("(" + _local3) + "/") + PetPropConstData.EQUIP_NUM) + ")");
            selectItem(currentSelectIdx);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWPETVIEW, EventList.SHOWONEPETVIEW, EventList.CLOSEPETVIEW, RoleEvents.UPDATEOUTFIT, RoleEvents.FIT_PET, PlayerInfoComList.UPDATE_PET_UI, EquipCommandList.REFRESH_PET_REBUILD, EquipCommandList.REFRESH_PET_LEARN, EquipCommandList.REFRESH_PET_STRENGTHEN, EquipCommandList.UPDATE_LEARN_PET, EquipCommandList.UPDATE_QUICKBUY_ITEM, EventList.UPDATEBAG]);
        }
        public function getCurrSelect():int{
            if (getPetList().length > 0){
                if (RolePropDatas.ItemList[RolePropDatas.lastOutPet]){
                    return (RolePropDatas.lastOutPet);
                };
                return (ItemConst.EQUIPMENT_SLOT_PET0);
            };
            return (-1);
        }
        public function Update(_arg1:GameTime):void{
            if (commitFlag == false){
                return;
            };
            localMS = (localMS + ((1 / 12) * 1000));
            loadPro.progressMask.width = (((localMS * 1) / timeCounter) * loadPro.progressMc.width);
            loadPro.lightAsset.x = (loadPro.progressMask.x + loadPro.progressMask.width);
            loadPro.load_txt.text = (int((100 * ((localMS * 1) / timeCounter))) + "%");
            if (localMS > timeCounter){
                loadPro.visible = false;
                commitEquip();
                commitFlag = false;
            };
        }
        private function addPanel(_arg1:uint):void{
            switch (_arg1){
                case 0:
                    panel1.addView();
                    panel1.clearInfo();
                    selectItem(currentSelectIdx);
                    break;
                case 1:
                    panel2.addView();
                    panel2.clearInfo();
                    selectItem(currentSelectIdx);
                    break;
                case 2:
                    panel3.addView();
                    panel3.clearInfo();
                    selectItem(currentSelectIdx);
                    break;
                case 3:
                    panel4.addView();
                    panel4.clearInfo();
                    selectItem(currentSelectIdx);
                    dataProxy.PetOperatorFlag = 2;
                    facade.sendNotification(EventList.UPDATEFILTERBAG);
                    break;
                case 4:
                    panel5.addView();
                    panel5.clearInfo();
                    selectItem(currentSelectIdx);
                    break;
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            var _local2:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            if (GameCommonData.IsInCrossServer){
                if ([1, 2, 3, 4].indexOf(_local2) != -1){
                    return;
                };
            };
            var _local3:int;
            _local3 = 0;
            while (_local3 < toggleBtns.length) {
                (toggleBtns[_local3] as ToggleButton).selected = false;
                _local3++;
            };
            (toggleBtns[_local2] as ToggleButton).selected = true;
            removePanel(currPage);
            currPage = _local2;
            addPanel(_local2);
            if (_local2 == 2){
                facade.sendNotification(Guide_PetUpstarCommand.NAME, {
                    step:3,
                    data:{target:panel3.StrengthenBtnArr[2]}
                });
            } else {
                facade.sendNotification(Guide_PetUpstarCommand.NAME, {
                    step:2,
                    data:{target:toggleBtns[2]}
                });
            };
            if (_local2 == 4){
                facade.sendNotification(Guide_PetQualityRefreshCommand.NAME, {
                    step:3,
                    data:{target:panel5.refreshBtn}
                });
            } else {
                facade.sendNotification(Guide_PetQualityRefreshCommand.NAME, {
                    step:2,
                    data:{target:toggleBtns[4]}
                });
            };
        }
        private function getFirstNull():int{
            var _local1:uint;
            _local1 = ItemConst.EQUIPMENT_SLOT_PET0;
            while (_local1 <= ItemConst.EQUIPMENT_SLOT_PET_END) {
                if (!RolePropDatas.ItemList[_local1]){
                    return (_local1);
                };
                _local1++;
            };
            return (-1);
        }
        private function endLoading():void{
            localMS = 0;
            loadPro.progressMask.width = 0;
            loadPro.visible = false;
            commitFlag = true;
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
        }
        private function startPeting():void{
            loadPro.visible = true;
            loadPro.x = 280;
            loadPro.y = 250;
            localMS = 0;
            commitFlag = true;
            loadPro.progressMask.width = 0;
            if (currPage == 1){
                loadPro.TargetNameTF.text = LanguageMgr.GetTranslation("正在洗炼");
            } else {
                if (currPage == 2){
                    loadPro.TargetNameTF.text = LanguageMgr.GetTranslation("正在提升");
                } else {
                    if (currPage == 3){
                        loadPro.TargetNameTF.text = LanguageMgr.GetTranslation("正在学习");
                    };
                };
            };
            this.view.addChild(loadPro);
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            GameCommonData.GameInstance.GameUI.Elements.Add(this);
        }

    }
}//package GameUI.Modules.Pet.Mediator 
