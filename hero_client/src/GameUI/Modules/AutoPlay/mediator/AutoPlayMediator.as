//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.AutoPlay.mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.AutoPlay.Data.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class AutoPlayMediator extends Mediator {

        private static const DefaultValue:String = "80";
        public static const NAME:String = "AutoPlayMediator";

        private var isOpenBg:Boolean = false;
        private var gridManager:GridManager;
        private var resetBtn:HLabelButton;
        private var skillHChenckBox1:HCheckBox;
        private var skillHChenckBox2:HCheckBox;
        private var weaponUI:MovieClip;
        private var isautoplaying:Boolean;
        private var levelBtn:HLabelButton;
        private var _autoflashmc:MovieClip = null;
        private var bg:HFrame;
        private var setSkillBtn:HLabelButton;
        private var skillCell:NewSkillCell;
        private var isInit:Boolean;
        private var dataProxy:DataProxy = null;
        private var pickHCheckBox1:HCheckBox;
        private var pickHCheckBox3:HCheckBox;
        private var pickHCheckBox5:HCheckBox;
        private var pickHCheckBox6:HCheckBox;
        private var pickHCheckBox2:HCheckBox;
        public var dataDic:Dictionary;
        private var shapEffect:MovieClip;
        private var pickHCheckBox4:HCheckBox;
        private var confirmBtn:HLabelButton;

        public function AutoPlayMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
            this.dataDic = new Dictionary();
        }
        private function onSyn():void{
            var _local1:*;
            var _local2:uint;
            var _local3:int;
            var _local4:InventoryItemInfo;
            var _local5:UseItem;
            for (_local1 in this.dataDic) {
                _local4 = getItemFromBag(dataDic[_local1]);
                _local5 = (dataDic[_local1] as UseItem);
                if (((_local5) && (_local4))){
                    _local5.IsBind = _local4.isBind;
                    if (_local4.isBind == 1){
                        _local5.setThumbLock();
                    };
                };
                _local2 = this.onSynNumInBag(this.dataDic[_local1]);
                if (_local2 == 0){
                    this.dataDic[_local1].canUse(false);
                } else {
                    this.dataDic[_local1].canUse(true);
                };
                (this.dataDic[_local1] as UseItem).Num = _local2;
            };
        }
        private function initEvent():void{
            var _local1 = 1;
            (this.viewUI.txt_minLimitHp as TextField).addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            (this.viewUI.txt_minLimitMp as TextField).addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            (this.viewUI.txt_minLimitPetHp as TextField).addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            (this.viewUI.txt_minLimitPetMp as TextField).addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            levelBtn.addEventListener(MouseEvent.CLICK, onLevelUpHandler);
            resetBtn.addEventListener(MouseEvent.CLICK, onResetHandler);
            confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmHandler);
            setSkillBtn.addEventListener(MouseEvent.CLICK, onSetSkillHandler);
            while (_local1 < 7) {
                this[("pickHCheckBox" + _local1)].addEventListener(Event.CHANGE, setPickHandler);
                _local1++;
            };
            _local1 = 1;
            while (_local1 < 3) {
                this[("skillHChenckBox" + _local1)].addEventListener(Event.CHANGE, setSkillHandler);
                _local1++;
            };
        }
        private function setAttHandler(_arg1:Event):void{
        }
        private function onUseSkillHandler(_arg1:MouseEvent):void{
            if (((!((skillCell.skillInfo == null))) && (!(skillCell.IsCdTimer)))){
                PlayerController.UseSkill(skillCell.skillInfo);
            };
        }
        private function isRightItem(_arg1:ItemTemplateInfo, _arg2:uint):Boolean{
            switch (_arg2){
                case 1:
                    if (_arg1.MainClass == ItemConst.ITEM_CLASS_MEDICAL){
                        if ((((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_MEDICAL_RECOVER)) && ((_arg1.HpBonus > 0)))){
                            return (true);
                        };
                        if (_arg1.SubClass == ItemConst.MEDICINE_HPBAG){
                            return (true);
                        };
                        if ((((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_MEDICINE_CSB)) && ((_arg1.HpBonus > 0)))){
                            return (true);
                        };
                    };
                    break;
                case 2:
                    if (_arg1.MainClass == ItemConst.ITEM_CLASS_MEDICAL){
                        if ((((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_MEDICAL_RECOVER)) && ((_arg1.MpBonus > 0)))){
                            return (true);
                        };
                        if (_arg1.SubClass == ItemConst.MEDICINE_MPBAG){
                            return (true);
                        };
                        if ((((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_MEDICINE_CSB)) && ((_arg1.MpBonus > 0)))){
                            return (true);
                        };
                    };
                    break;
            };
            return (false);
        }
        public function guide_mp():MovieClip{
            return (this.weaponUI.autoPlayMp);
        }
        private function initWeaponUi():void{
            gridManager = (UIFacade.GetInstance().retrieveProxy(GridManager.NAME) as GridManager);
            this.weaponUI = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("MagicWeapon");
            this.weaponUI.x = 253;
            this.weaponUI.y = 429;
            this.weaponUI.autoPlayBtn.gotoAndStop(1);
            this.weaponUI.autoPlayBtn.buttonMode = true;
            this.weaponUI.weaponBg.addEventListener(MouseEvent.MOUSE_DOWN, onUIDownHandler);
            this.weaponUI.weaponBg.addEventListener(MouseEvent.MOUSE_UP, onUIUpHandler);
            skillCell = new NewSkillCell();
            this.weaponUI.addChildAt(skillCell, (weaponUI.numChildren - 1));
            skillCell.x = (149 - 22);
            skillCell.y = (29 + 11);
            skillCell.addEventListener(MouseEvent.CLICK, onUseSkillHandler);
            this.weaponUI.autoPlayBtn.addEventListener(MouseEvent.CLICK, onAutoPlayHandler);
            this.weaponUI.autoSetBtn.addEventListener(MouseEvent.CLICK, onAutoSetHandler);
            weaponUI.weaponExp.height = 7;
            AutoPlayBtnFlash = false;
        }
        public function get viewUI():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function onAutoPlayHandler(_arg1:MouseEvent):void{
            if ((((GameCommonData.Player.IsAutomatism == false)) && ((AutoFbManager.IsAutoFbing == false)))){
                AutoFbManager.instance().beginAutoPlay();
                sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("你已经开始挂机"),
                    color:0xFFFF00
                });
                if (shapEffect){
                    shapEffect.stop();
                    if (shapEffect.parent){
                        shapEffect.parent.removeChild(shapEffect);
                    };
                    shapEffect = null;
                };
            } else {
                PlayerController.EndAutomatism();
                sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("你已经停止挂机"),
                    color:0xFFFF00
                });
            };
        }
        public function guide_autoPlayBtn():MovieClip{
            return (this.weaponUI.autoPlayBtn);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.RESIZE_STAGE, AutoPlayEventList.QUICK_AUTO_PLAY, AutoPlayEventList.QUICK_AUTO_SET, AutoPlayEventList.SHOW_AUTOPLAY_UI, AutoPlayEventList.HIDE_AUTOPLAY_UI, AutoPlayEventList.ADD_ITEM_AUTOPLAYUI, AutoPlayEventList.ONSYN_BAG_NUM, AutoPlayEventList.ATT_CHANGE_EVENT, AutoPlayEventList.CANCEL_AUTOPLAY_EVENT, AutoPlayEventList.UPDATE_MAGIC_WEAPON, AutoPlayEventList.UPDATE_TREASURE_EXP, AutoPlayEventList.UPDATE_TEXT, AutoPlayEventList.UPDATE_ITEM, AutoPlayEventList.START_AUTOPLAY_EVENT]);
        }
        private function OnAutoFlashComplete():void{
            if (_autoflashmc == null){
                _autoflashmc = ResourcesFactory.getInstance().getswfResourceByUrl((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Effect/guajishanshuo.swf"));
                _autoflashmc.autoplayFlashMc.mouseEnabled = false;
                _autoflashmc.autoplayFlashMc.mouseChildren = false;
                weaponUI.addChild(_autoflashmc);
                if (!isautoplaying){
                    _autoflashmc.autoplayFlashMc.visible = false;
                    _autoflashmc.autoplayFlashMc.stop();
                };
            };
        }
        private function onUIDownHandler(_arg1:MouseEvent):void{
            this.weaponUI.startDrag();
        }
        private function setPick():void{
            AutoPlayData.PickAll = false;
            AutoPlayData.PickGold = pickHCheckBox1.selected;
            AutoPlayData.PickEquip = pickHCheckBox2.selected;
            AutoPlayData.PickMaterial = pickHCheckBox3.selected;
            AutoPlayData.PickMedicinal = pickHCheckBox4.selected;
            AutoPlayData.PickMagicStone = pickHCheckBox5.selected;
        }
        private function onTextFieldFocusOut(_arg1:FocusEvent):void{
            var _local2:TextField = (_arg1.currentTarget as TextField);
            var _local3:uint = uint(_local2.text);
            if (_local3 < 0){
                _local2.text = "0";
            };
            if (_local3 > 100){
                _local2.text = "100";
            };
        }
        private function setPickHandler(_arg1:Event):void{
            var _local3:Boolean;
            var _local2 = 1;
            if (_arg1.currentTarget == pickHCheckBox6){
                if (_arg1.currentTarget.selected){
                    while (_local2 < 6) {
                        this[("pickHCheckBox" + _local2)].selected = false;
                        _local2++;
                    };
                };
            } else {
                _local3 = false;
                if (_arg1.currentTarget.selected){
                    pickHCheckBox6.selected = false;
                };
            };
        }
        private function onConfirmHandler(_arg1:MouseEvent):void{
            SharedManager.getInstance().hpPercent = (this.viewUI.txt_minLimitHp as TextField).text;
            SharedManager.getInstance().mpPercent = (this.viewUI.txt_minLimitMp as TextField).text;
            SharedManager.getInstance().petHpPercent = (this.viewUI.txt_minLimitPetHp as TextField).text;
            SharedManager.getInstance().petMpPercent = (this.viewUI.txt_minLimitPetMp as TextField).text;
            if (pickHCheckBox6.selected){
                setPickTRUE();
            } else {
                setPick();
            };
            AutoPlayData.UseImmortalsSkill = skillHChenckBox1.selected;
            AutoPlayData.UseCommonSkill = skillHChenckBox2.selected;
            var _local2 = 1;
            while (_local2 < 7) {
                SharedManager.getInstance().SetSkillAutoInfo(this[("pickHCheckBox" + _local2)].selected, ("pickHCheckBox" + _local2));
                _local2++;
            };
            _local2 = 1;
            while (_local2 < 3) {
                SharedManager.getInstance().SetSkillAutoInfo(this[("skillHChenckBox" + _local2)].selected, ("skillHChenckBox" + _local2));
                _local2++;
            };
            onAutoSetHandler();
            sendNotification(PlayerInfoComList.UPDATE_LEVER);
        }
        private function setMagicWeaponSkill():void{
            var _local1:InventoryItemInfo = RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE];
            skillCell.setWeaponSkill(_local1);
            if (isInit == false){
                return;
            };
            if (_local1 == null){
                dataProxy.autoPlayIsOpen = false;
                this.onCancleHandler(null);
                if (isOpenBg){
                    onAutoSetHandler();
                };
                if (GameCommonData.Player.IsAutomatism == true){
                    onAutoPlayHandler(null);
                };
            };
        }
        private function findTheItem(_arg1:int):UseItem{
            var _local2:UseItem;
            for each (_local2 in dataDic) {
                if (isRightItem(_local2.itemIemplateInfo, _arg1)){
                    return (_local2);
                };
            };
            return (null);
        }
        private function setTreasureExp(_arg1:uint, _arg2:uint):void{
            var _local3:InventoryItemInfo = RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE];
            if (_local3 == null){
                return;
            };
            var _local4:Number = (Number(_arg2) / IntroConst.TreasureExp[_arg1]);
            viewUI.Treasure_Exp.width = uint((Math.min(_local4, 1) * 312));
            weaponUI.weaponExp.width = uint((Math.min(_local4, 1) * 134));
            GameCommonData.MagicWeaponExp = ((String(_arg2) + "/") + String(IntroConst.TreasureExp[_arg1]));
            viewUI.txt_TreasureExp.text = GameCommonData.MagicWeaponExp;
            if (isInit){
                if (_local4 >= 1){
                    levelBtn.enable = true;
                    levelBtn.playEffect();
                } else {
                    levelBtn.enable = false;
                };
                if ((((((_local4 >= 1)) && ((_arg1 < (Math.floor((GameCommonData.Player.Role.Level / 5)) + 1))))) && (!(isOpenBg)))){
                    facade.sendNotification(NewInfoTipNotiName.NEWINFOTIP_SHENBIN_SHOW);
                };
                doguide_uplevel(_local4);
            };
        }
        private function setPickTRUE():void{
            AutoPlayData.PickAll = true;
            AutoPlayData.PickGold = true;
            AutoPlayData.PickEquip = true;
            AutoPlayData.PickMaterial = true;
            AutoPlayData.PickMedicinal = true;
            AutoPlayData.PickMagicStone = true;
        }
        public function guide_hp():MovieClip{
            return (this.weaponUI.autoPlayHp_0);
        }
        private function moveHandler(_arg1:MouseEvent):void{
            var _local2:UseItem = (_arg1.currentTarget as UseItem);
            _local2.addEventListener(DropEvent.DRAG_DROPPED, gridManager.dragDroppedHandler);
            _local2.removeEventListener(MouseEvent.CLICK, onUseItemClick);
        }
        private function setSkillHandler(_arg1:Event):void{
        }
        private function onUIUpHandler(_arg1:MouseEvent):void{
            this.weaponUI.stopDrag();
        }
        private function useItem(_arg1:uint):void{
            var _local2:GameRole;
            var _local9:UseItem;
            var _local10:InventoryItemInfo;
            if (GameCommonData.Player.Role.canUseItem != true){
                return;
            };
            var _local3:uint = uint(SharedManager.getInstance().hpPercent);
            var _local4:uint = uint(SharedManager.getInstance().mpPercent);
            var _local5:uint = uint(SharedManager.getInstance().petHpPercent);
            var _local6:uint = uint(SharedManager.getInstance().petMpPercent);
            var _local7:Number = 0;
            var _local8:int;
            switch (_arg1){
                case 1:
                    _local7 = ((GameCommonData.Player.Role.HP / (GameCommonData.Player.Role.MaxHp + GameCommonData.Player.Role.AdditionAtt.MaxHP)) * 100);
                    if (_local7 <= _local3){
                        _local9 = findTheItem(1);
                        if (_local9 != null){
                            if (_local9.IsCdTimer){
                                return;
                            };
                            _local10 = getItemFromBag(_local9);
                            if (_local10){
                                if (ItemConst.IsMedicalExceptBAG(_local10)){
                                    sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                                };
                                BagInfoSend.ItemUse(_local10.ItemGUID);
                            } else {
                                _local8 = AutomatismController.AutoUseItem(1);
                            };
                        } else {
                            _local8 = AutomatismController.AutoUseItem(1);
                        };
                    };
                    break;
                case 2:
                    _local7 = ((GameCommonData.Player.Role.MP / GameCommonData.Player.Role.MaxMp) * 100);
                    if (_local7 <= _local4){
                        _local9 = findTheItem(2);
                        if (_local9 != null){
                            if (_local9.IsCdTimer){
                                return;
                            };
                            _local10 = getItemFromBag(_local9);
                            if (_local10){
                                if (ItemConst.IsMedicalExceptBAG(_local10)){
                                    sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                                };
                                BagInfoSend.ItemUse(_local10.ItemGUID);
                            } else {
                                _local8 = AutomatismController.AutoUseItem(2);
                            };
                        } else {
                            _local8 = AutomatismController.AutoUseItem(2);
                        };
                    };
                    break;
                case 3:
                    if (GameCommonData.Player.Role.UsingPetAnimal != null){
                        _local2 = GameCommonData.Player.Role.UsingPetAnimal.Role;
                        _local7 = ((_local2.HP / _local2.MaxHp) * 100);
                        if (_local7 <= _local5){
                            _local8 = AutomatismController.AutoUseItem(3);
                        };
                    };
                    break;
                case 4:
                    if (GameCommonData.Player.Role.UsingPetAnimal != null){
                        _local2 = GameCommonData.Player.Role.UsingPetAnimal.Role;
                        _local7 = ((_local2.MP / _local2.MaxMp) * 100);
                        if (_local7 <= _local6){
                            _local8 = AutomatismController.AutoUseItem(4);
                        };
                    };
                    break;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:uint;
            var _local4:uint;
            var _local5:Number;
            var _local6:InventoryItemInfo;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"AutoPlayUI"
                    });
                    initWeaponUi();
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    break;
                case AutoPlayEventList.SHOW_AUTOPLAY_UI:
                    if (isInit == false){
                        initView();
                        isInit = true;
                    };
                    if (_autoflashmc == null){
                        ResourcesFactory.getInstance().getResource((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Effect/guajishanshuo.swf"), OnAutoFlashComplete);
                    };
                    dataProxy.autoPlayIsOpen = true;
                    GameCommonData.GameInstance.GameUI.addChild(this.weaponUI);
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    _local6 = RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE];
                    if (_local6){
                        _local5 = (Number(RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE].Experience) / IntroConst.TreasureExp[RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE].Strengthen]);
                        weaponUI.weaponExp.width = uint((Math.min(_local5, 1) * 134));
                        setTreasureExp(RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE].Strengthen, RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE].Experience);
                    };
                    setMagicWeaponSkill();
                    onResize();
                    doGuide_show();
                    break;
                case AutoPlayEventList.HIDE_AUTOPLAY_UI:
                    dataProxy.autoPlayIsOpen = false;
                    this.onCancleHandler(null);
                    if (isOpenBg){
                        onAutoSetHandler();
                    };
                    break;
                case AutoPlayEventList.UPDATE_MAGIC_WEAPON:
                    setMagicWeaponSkill();
                    break;
                case AutoPlayEventList.UPDATE_TREASURE_EXP:
                    setTreasureExp(_arg1.getBody().level, _arg1.getBody().exp);
                    break;
                case AutoPlayEventList.QUICK_AUTO_PLAY:
                    onAutoPlayHandler(null);
                    GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    break;
                case AutoPlayEventList.QUICK_AUTO_SET:
                    if (isInit == false){
                        initView();
                        isInit = true;
                    };
                    bg.X = ((GameCommonData.GameInstance.ScreenWidth - bg.width) / 2);
                    bg.Y = ((GameCommonData.GameInstance.ScreenHeight - bg.height) / 2);
                    onAutoSetHandler(null);
                    GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    break;
                case AutoPlayEventList.CANCEL_AUTOPLAY_EVENT:
                    this.weaponUI.autoPlayBtn.gotoAndStop(1);
                    AutoPlayBtnFlash = false;
                    break;
                case AutoPlayEventList.START_AUTOPLAY_EVENT:
                    this.weaponUI.autoPlayBtn.gotoAndStop(2);
                    AutoPlayBtnFlash = true;
                    break;
                case AutoPlayEventList.UPDATE_TEXT:
                    if (isInit){
                        setConfig();
                    };
                    break;
                case AutoPlayEventList.ADD_ITEM_AUTOPLAYUI:
                    _local2 = _arg1.getBody();
                    this.addItem(_local2.type, _local2.source, _local2.target);
                    break;
                case AutoPlayEventList.ATT_CHANGE_EVENT:
                    this.useItem(uint(_arg1.getBody()));
                    break;
                case AutoPlayEventList.ONSYN_BAG_NUM:
                    this.onSyn();
                    break;
                case AutoPlayEventList.UPDATE_ITEM:
                    _local2 = _arg1.getBody();
                    if (_local2.type == 0){
                        this.addItem("autoPlayHp", _local2.item, weaponUI["autoPlayHp_0"]);
                    } else {
                        this.addItem("autoPlayMp", _local2.item, weaponUI["autoPlayMp"]);
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    onResize();
                    break;
            };
        }
        private function setConfig():void{
            (this.viewUI.txt_minLimitHp as TextField).text = SharedManager.getInstance().hpPercent;
            (this.viewUI.txt_minLimitMp as TextField).text = SharedManager.getInstance().mpPercent;
            (this.viewUI.txt_minLimitPetHp as TextField).text = SharedManager.getInstance().petHpPercent;
            (this.viewUI.txt_minLimitPetMp as TextField).text = SharedManager.getInstance().petMpPercent;
            var _local1 = 1;
            if (SharedManager.getInstance().GetSkillAutoInfo("pickHCheckBox6")){
                pickHCheckBox6.selected = true;
                while (_local1 < 6) {
                    this[("pickHCheckBox" + _local1)].selected = false;
                    _local1++;
                };
                setPickTRUE();
            } else {
                _local1 = 1;
                while (_local1 < 6) {
                    this[("pickHCheckBox" + _local1)].selected = SharedManager.getInstance().GetSkillAutoInfo(("pickHCheckBox" + _local1));
                    _local1++;
                };
                setPick();
            };
            _local1 = 1;
            while (_local1 < 3) {
                this[("skillHChenckBox" + _local1)].selected = SharedManager.getInstance().GetSkillAutoInfo(("skillHChenckBox" + _local1));
                _local1++;
            };
            AutoPlayData.UseImmortalsSkill = skillHChenckBox1.selected;
            AutoPlayData.UseCommonSkill = skillHChenckBox2.selected;
        }
        private function onCancleHandler(_arg1:MouseEvent=null):void{
            setConfig();
            if (this.weaponUI.parent != null){
                this.weaponUI.parent.removeChild(this.weaponUI);
                this.dataProxy.autoPlayIsOpen = false;
            };
        }
        private function makeUseItemBind(_arg1:UseItem):void{
            var _local2:int;
            if (_arg1.IsBind == 0){
                _arg1.IsBind = 1;
                if (isRightItem(_arg1.itemIemplateInfo, 1)){
                    _local2 = 16;
                } else {
                    _local2 = 17;
                };
                PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local2, PlayerActionSend.BAG_TYPE, _arg1.Type, _arg1.IsBind);
            };
        }
        private function onLevelUpHandler(_arg1:MouseEvent):void{
            if (GameCommonData.IsInCrossServer){
                MessageTip.popup(LanguageMgr.GetTranslation("跨服战中不能升级神兵"));
                return;
            };
            EquipSend.TreasureLevelUp();
        }
        private function doGuide_show():void{
            if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep == 2)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:6
                });
            };
            if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep == 12)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:13
                });
            };
            if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep == 15)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:16
                });
            };
            if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep == 18)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:19
                });
            };
            if (((((((((bg.parent) && (bg.visible))) && ((NewGuideData.newerHelpIsOpen == true)))) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 7)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:9,
                    POINT:levelBtn
                });
            };
            if ((((((((bg.parent == null)) && ((NewGuideData.newerHelpIsOpen == true)))) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 10)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:11
                });
            };
        }
        private function onUseItemMouseDown(_arg1:MouseEvent):void{
            var _local2:UseItem = (_arg1.currentTarget as UseItem);
            _local2.onMouseDown();
            _arg1.stopPropagation();
            _local2.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            _local2.addEventListener(MouseEvent.CLICK, onUseItemClick);
        }
        private function initView():void{
            this.bg = new HFrame();
            this.bg.blackGound = false;
            this.bg.showClose = true;
            this.bg.moveEnable = true;
            this.bg.closeCallBack = onAutoSetHandler;
            this.bg.setSize(478, 306);
            this.bg.titleText = LanguageMgr.GetTranslation("挂机设置");
            this.bg.centerTitle = true;
            this.bg.addContent(this.viewUI);
            this.viewUI.mouseEnabled = false;
            this.bg.x = ((GameCommonData.GameInstance.ScreenWidth - bg.width) / 2);
            this.bg.y = ((GameCommonData.GameInstance.ScreenHeight - bg.height) / 2);
            (this.viewUI.txt_minLimitHp as TextField).restrict = "0-9";
            (this.viewUI.txt_minLimitHp as TextField).maxChars = 3;
            (this.viewUI.txt_minLimitMp as TextField).restrict = "0-9";
            (this.viewUI.txt_minLimitMp as TextField).maxChars = 3;
            (this.viewUI.txt_minLimitPetHp as TextField).restrict = "0-9";
            (this.viewUI.txt_minLimitPetHp as TextField).maxChars = 3;
            (this.viewUI.txt_minLimitPetMp as TextField).restrict = "0-9";
            (this.viewUI.txt_minLimitPetMp as TextField).maxChars = 3;
            UIUtils.addFocusLis(this.viewUI.txt_minLimitHp);
            UIUtils.addFocusLis(this.viewUI.txt_minLimitMp);
            UIUtils.addFocusLis(this.viewUI.txt_minLimitPetHp);
            UIUtils.addFocusLis(this.viewUI.txt_minLimitPetMp);
            levelBtn = new HLabelButton();
            levelBtn.label = LanguageMgr.GetTranslation("升级");
            bg.addChild(levelBtn);
            levelBtn.x = 420;
            levelBtn.y = 35;
            resetBtn = new HLabelButton();
            resetBtn.label = LanguageMgr.GetTranslation("恢复默认");
            bg.addChild(resetBtn);
            resetBtn.x = 165;
            resetBtn.y = 268;
            setSkillBtn = new HLabelButton();
            setSkillBtn.label = LanguageMgr.GetTranslation("设置");
            bg.addChild(setSkillBtn);
            setSkillBtn.x = 420;
            setSkillBtn.y = 228;
            confirmBtn = new HLabelButton();
            confirmBtn.label = LanguageMgr.GetTranslation("保存设置");
            bg.addChild(confirmBtn);
            confirmBtn.x = 0xFF;
            confirmBtn.y = 268;
            pickHCheckBox6 = new HCheckBox(LanguageMgr.GetTranslation("自动拾取所有物品"));
            pickHCheckBox6.fireAuto = true;
            bg.addChild(pickHCheckBox6);
            pickHCheckBox6.x = 20;
            pickHCheckBox6.y = 100;
            pickHCheckBox1 = new HCheckBox(LanguageMgr.GetTranslation("自动拾取金币"));
            pickHCheckBox1.fireAuto = true;
            bg.addChild(pickHCheckBox1);
            pickHCheckBox1.x = 20;
            pickHCheckBox1.y = (pickHCheckBox6.y + 26);
            pickHCheckBox2 = new HCheckBox(LanguageMgr.GetTranslation("自动拾取装备"));
            pickHCheckBox2.fireAuto = true;
            bg.addChild(pickHCheckBox2);
            pickHCheckBox2.x = 20;
            pickHCheckBox2.y = (pickHCheckBox1.y + 26);
            pickHCheckBox3 = new HCheckBox(LanguageMgr.GetTranslation("自动拾取材料"));
            pickHCheckBox3.fireAuto = true;
            bg.addChild(pickHCheckBox3);
            pickHCheckBox3.x = 20;
            pickHCheckBox3.y = (pickHCheckBox2.y + 26);
            pickHCheckBox4 = new HCheckBox(LanguageMgr.GetTranslation("自动拾取药品"));
            pickHCheckBox4.fireAuto = true;
            bg.addChild(pickHCheckBox4);
            pickHCheckBox4.x = 20;
            pickHCheckBox4.y = (pickHCheckBox3.y + 26);
            pickHCheckBox5 = new HCheckBox(LanguageMgr.GetTranslation("自动拾取强化石"));
            pickHCheckBox5.fireAuto = true;
            bg.addChild(pickHCheckBox5);
            pickHCheckBox5.x = 20;
            pickHCheckBox5.y = (pickHCheckBox4.y + 26);
            skillHChenckBox1 = new HCheckBox(LanguageMgr.GetTranslation("使用神兵技能"));
            skillHChenckBox1.fireAuto = true;
            bg.addChild(skillHChenckBox1);
            skillHChenckBox1.x = 185;
            skillHChenckBox1.y = 230;
            skillHChenckBox2 = new HCheckBox(LanguageMgr.GetTranslation("使用人物技能"));
            skillHChenckBox2.fireAuto = true;
            bg.addChild(skillHChenckBox2);
            skillHChenckBox2.x = 305;
            skillHChenckBox2.y = 230;
            setConfig();
            viewUI.txt_TreasureExp.mouseEnabled = false;
        }
        private function getItemFromBag(_arg1:UseItem):InventoryItemInfo{
            var _local2:InventoryItemInfo;
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (((((!((_local2 == null))) && ((_local2.type == _arg1.Type)))) && ((_local2.Count > 0)))){
                    if (_local2.ItemGUID == _arg1.Id){
                        return (_local2);
                    };
                };
            };
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (((((!((_local2 == null))) && ((_local2.type == _arg1.Type)))) && ((_local2.Count > 0)))){
                    if (_local2.isBind != 0){
                        _arg1.Id = _local2.ItemGUID;
                        return (_local2);
                    };
                };
            };
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (((((!((_local2 == null))) && ((_local2.type == _arg1.Type)))) && ((_local2.Count > 0)))){
                    _arg1.Id = _local2.ItemGUID;
                    return (_local2);
                };
            };
            return (null);
        }
        private function addItem(_arg1:String, _arg2:UseItem, _arg3):void{
            var _local4:UseItem;
            var _local5:int;
            var _local6:InventoryItemInfo;
            if (this.isHasTheItem(_arg2.Type, _arg2.IsBind)){
                return;
            };
            if (_arg2.itemIemplateInfo.RequiredLevel > GameCommonData.Player.Role.Level){
                MessageTip.show(LanguageMgr.GetTranslation("物品使用等级过高"));
                return;
            };
            switch (_arg1){
                case "autoPlayHp":
                    if (!this.isRightItem(_arg2.itemIemplateInfo, 1)){
                        sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("放入的物品类型不符"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    break;
                case "autoPlayMp":
                    if (!this.isRightItem(_arg2.itemIemplateInfo, 2)){
                        sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("放入的物品类型不符"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    break;
            };
            if (_arg2.Id == 0){
                for each (_local6 in (BagData.AllItems[0] as Array)) {
                    if (((((!((_local6 == null))) && ((_local6.type == _arg2.Type)))) && ((_local6.Count > 0)))){
                        if (_local6.isBind == _arg2.IsBind){
                            _arg2.Id = _local6.ItemGUID;
                        };
                        break;
                    };
                };
            };
            _local4 = new UseItem(_arg2.Pos, _arg2.Type, null, _arg2.Id);
            _local4.IsBind = _arg2.IsBind;
            if (_local4.IsBind == 1){
                _local4.setThumbLock();
            };
            _local4.mouseEnabled = true;
            _local4.addEventListener(MouseEvent.MOUSE_DOWN, onUseItemMouseDown);
            _local4.addEventListener(DropEvent.DRAG_THREW, onThrowItemHandler);
            _local4.addEventListener(MouseEvent.CLICK, onUseItemClick);
            _local4.addEventListener(DropEvent.DRAG_DROPPED, gridManager.dragDroppedHandler);
            if (isRightItem(_local4.itemIemplateInfo, 1)){
                _local5 = 16;
                _local4.name = ("autoPlayHp_" + _arg2.Type);
                weaponUI["autoPlayHp_0"].addChild(_local4);
            } else {
                _local5 = 17;
                _local4.name = ("autoPlayMp_" + _arg2.Type);
                weaponUI["autoPlayMp"].addChild(_local4);
            };
            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local5, PlayerActionSend.BAG_TYPE, _local4.Type, _local4.IsBind);
            if ((_arg3 is UseItem)){
                if (_arg3.parent != null){
                    _arg3.removeEventListener(MouseEvent.MOUSE_DOWN, onUseItemMouseDown);
                    _arg3.removeEventListener(DropEvent.DRAG_THREW, onThrowItemHandler);
                    _arg3.removeEventListener(MouseEvent.CLICK, onUseItemClick);
                    _arg3.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
                    _arg3.removeEventListener(DropEvent.DRAG_DROPPED, gridManager.dragDroppedHandler);
                    _arg3.gc();
                    _arg3.parent.removeChild(_arg3);
                };
                delete this.dataDic[_arg3.Type];
            };
            _local4.x = (_local4.y = 2);
            this.dataDic[_arg2.Type] = _local4;
            _local4.Num = this.onSynNumInBag(_local4);
            if (_local4.Num == 0){
                _local4.canUse(false);
            } else {
                _local4.canUse(true);
            };
        }
        private function onSetSkillHandler(_arg1:MouseEvent):void{
            dataProxy.NewSkillIsOpen = true;
            facade.sendNotification(EventList.SHOWSKILLVIEW);
        }
        private function onAutoSetHandler(_arg1:MouseEvent=null):void{
            setConfig();
            if (!isOpenBg){
                isOpenBg = true;
                GameCommonData.GameInstance.GameUI.addChild(this.bg);
                setTreasureExp(RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE].Strengthen, RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE].Experience);
                initEvent();
                sendNotification(NewInfoTipNotiName.NEWINFOTIP_SHENBIN_HIDE);
            } else {
                if (NewGuideData.newerHelpIsOpen){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                };
                GameCommonData.GameInstance.GameUI.removeChild(this.bg);
                removeEvent();
                isOpenBg = false;
            };
            doGuide_show();
        }
        private function onSynNumInBag(_arg1:UseItem):uint{
            var _local2:InventoryItemInfo;
            var _local3:uint;
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (_local2 != null){
                    if ((((_local2.type == _arg1.Type)) && ((_local2.isBind == _arg1.IsBind)))){
                        _local3 = (_local3 + _local2.Count);
                    };
                };
            };
            if ((((_local3 > 0)) && ((_arg1.itemIemplateInfo.MaxCount == 1)))){
                _local3 = 1;
            };
            return (_local3);
        }
        public function shapAutoBtn():void{
            if (shapEffect == null){
                shapEffect = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BtnShapEffect");
                shapEffect.mouseEnabled = false;
                shapEffect.mouseChildren = false;
            };
            shapEffect.play();
            weaponUI.addChild(shapEffect);
            shapEffect.x = (weaponUI.autoPlayBtn.x + (weaponUI.autoPlayBtn.width / 2));
            shapEffect.y = (weaponUI.autoPlayBtn.y + (weaponUI.autoPlayBtn.height / 2));
        }
        private function doguide_uplevel(_arg1:int):void{
            if (((((((bg.parent) && (NewGuideData.newerHelpIsOpen))) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 9)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:19,
                    STEP:10,
                    POINT:this.bg.closeBtn
                });
            };
        }
        private function onUseItemClick(_arg1:MouseEvent):void{
            var _local3:InventoryItemInfo;
            var _local2:UseItem = (_arg1.currentTarget as UseItem);
            if ((((((((_local2 == null)) || (_local2.IsCdTimer))) || (!(UIConstData.KeyBoardCanUse)))) || (!(_local2.canUseIt)))){
                return;
            };
            if (GameCommonData.Player.Role.canUseItem){
                _local3 = getItemFromBag(_local2);
                if (_local3){
                    if (ItemConst.IsMedicalExceptBAG(_local3)){
                        sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                    };
                    BagInfoSend.ItemUse(_local3.ItemGUID);
                };
            };
        }
        private function set AutoPlayBtnFlash(_arg1:Boolean):void{
            isautoplaying = _arg1;
            if (((isautoplaying) && (!((_autoflashmc == null))))){
                _autoflashmc.autoplayFlashMc.visible = true;
                _autoflashmc.autoplayFlashMc.play();
            } else {
                if (_autoflashmc != null){
                    _autoflashmc.autoplayFlashMc.visible = false;
                    _autoflashmc.autoplayFlashMc.stop();
                };
            };
            if (((isautoplaying) && (((((((((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 6)))) || (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 13)))))) || (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 16)))))) || (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 19)))) && ((NewGuideData.curStep == 19)))))))){
                facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
            };
        }
        private function onResize():void{
            weaponUI.x = (((((GameCommonData.GameInstance.ScreenWidth - 1000) / 1000) * 253) + 253) + 40);
            weaponUI.y = (((GameCommonData.GameInstance.ScreenHeight - 580) + 429) - 20);
        }
        private function removeEvent():void{
            var _local1 = 1;
            (this.viewUI.txt_minLimitHp as TextField).removeEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            (this.viewUI.txt_minLimitMp as TextField).removeEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            (this.viewUI.txt_minLimitPetHp as TextField).removeEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            (this.viewUI.txt_minLimitPetMp as TextField).removeEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
            levelBtn.removeEventListener(MouseEvent.CLICK, onLevelUpHandler);
            resetBtn.removeEventListener(MouseEvent.CLICK, onResetHandler);
            setSkillBtn.removeEventListener(MouseEvent.CLICK, onSetSkillHandler);
            confirmBtn.removeEventListener(MouseEvent.CLICK, onConfirmHandler);
            while (_local1 < 7) {
                this[("pickHCheckBox" + _local1)].removeEventListener(Event.CHANGE, setPickHandler);
                _local1++;
            };
            _local1 = 1;
            while (_local1 < 3) {
                this[("skillHChenckBox" + _local1)].removeEventListener(Event.CHANGE, setSkillHandler);
                _local1++;
            };
        }
        private function onResetHandler(_arg1:MouseEvent):void{
            (this.viewUI.txt_minLimitHp as TextField).text = DefaultValue;
            (this.viewUI.txt_minLimitMp as TextField).text = DefaultValue;
            (this.viewUI.txt_minLimitPetHp as TextField).text = DefaultValue;
            (this.viewUI.txt_minLimitPetMp as TextField).text = DefaultValue;
            pickHCheckBox6.selected = true;
            skillHChenckBox1.selected = true;
            skillHChenckBox2.selected = true;
        }
        private function isHasTheItem(_arg1:int, _arg2:int):Boolean{
            var _local3:UseItem;
            if (this.dataDic[_arg1]){
                _local3 = this.dataDic[_arg1];
                if (_local3.IsBind == _arg2){
                    return (true);
                };
            };
            return (false);
        }
        private function setExpHandler(_arg1:Event):void{
        }
        private function onThrowItemHandler(_arg1:DropEvent):void{
            var _local3:int;
            var _local2:UseItem = (_arg1.Data as UseItem);
            if (_local2.parent != null){
                _local2.removeEventListener(MouseEvent.MOUSE_DOWN, onUseItemMouseDown);
                _local2.removeEventListener(DropEvent.DRAG_THREW, onThrowItemHandler);
                _local2.removeEventListener(MouseEvent.CLICK, onUseItemClick);
                _local2.removeEventListener(DropEvent.DRAG_DROPPED, gridManager.dragDroppedHandler);
                _local3 = (isRightItem(_local2.itemIemplateInfo, 1)) ? 16 : 17;
                PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, _local3);
                _local2.gc();
                _local2.parent.removeChild(_local2);
            };
            delete this.dataDic[_arg1.Data.Type];
        }

    }
}//package GameUI.Modules.AutoPlay.mediator 
