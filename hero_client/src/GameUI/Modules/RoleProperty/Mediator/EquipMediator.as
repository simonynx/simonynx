//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.RoleProperty.Prxoy.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.*;
  //  import GameUI.Modules.RoleProperty.Net.*;
   // import GameUI.Modules.RoleProperty.Mediator.UI.*;

    public class EquipMediator extends Mediator {

        public static const TYPE:int = 0;
        public static const NAME:String = "EquipMediator";

        private var attributePanel:MovieClip;
        private var tmpItem:Object = null;
        private var isGet:Boolean = false;
        private var faceItem:FaceItem;
        private var itemManager:ItemManager;
        private var curJob:RoleJob = null;
        private var parentView:Sprite;

        public function EquipMediator(_arg1:Sprite){
            parentView = _arg1;
            super(NAME);
        }
        private function initItem():void{
            var _local1:UseItem;
            var _local2:Object;
            var _local3:Object;
            var _local4:int;
            removeAllItem();
            if (RolePropDatas.ItemUnitList.length == 0){
                return;
            };
            while (_local4 < ItemConst.EQUIPMENT_SLOT_END) {
                if (RolePropDatas.ItemList[_local4]){
                    _local1 = new UseItem(RolePropDatas.ItemList[_local4].Place, RolePropDatas.ItemList[_local4].type, equip, RolePropDatas.ItemList[_local4].ItemGUID);
                    _local1.x = (RolePropDatas.ItemUnitList[_local4].Grid.x + 2);
                    _local1.y = (RolePropDatas.ItemUnitList[_local4].Grid.y + 2);
                    _local1.Id = RolePropDatas.ItemList[_local4].ItemGUID;
                    _local1.IsBind = RolePropDatas.ItemList[_local4].isBind;
                    _local1.setBroken(RolePropDatas.ItemList[_local4].isBroken);
                    _local1.Type = RolePropDatas.ItemList[_local4].type;
                    _local1.Pos = _local4;
                    RolePropDatas.ItemUnitList[RolePropDatas.ItemList[_local4].Place].Item = _local1;
                    RolePropDatas.ItemUnitList[RolePropDatas.ItemList[_local4].Place].IsUsed = true;
                    _local2 = UIConstData.ItemDic[_local1.Type];
                    _local3 = IntroConst.ItemInfo[_local1.Id];
                    _local1.setNoFitJobShape(false);
                    if (_local3 != null){
                        if (_local3.Count == 0){
                            _local1.setNoFitJobShape(true);
                        };
                        if (_local3.isActive == 2){
                            _local1.setNoFitJobShape(true);
                        };
                    };
                    _local1.IsLock = false;
                    equip.addChild(_local1);
                };
                _local4++;
            };
        }
        private function __faceLoadCompleteHandler(_arg1:Event):void{
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
            _arg1.currentTarget.x = 45;
            _arg1.currentTarget.y = 35;
            equip.addChild(faceItem);
            equip.mcRadio.parent.addChild(equip.mcRadio);
            equip.txtRadio.parent.addChild(equip.txtRadio);
        }
        public function UpDateAttribute(_arg1:String):void{
            var _local2:uint;
            var _local3:uint;
            switch (_arg1){
                case "Level":
                    equip.txtLevel.text = (GameCommonData.Player.Role.Level + LanguageMgr.GetTranslation("级"));
                    equip.txtExp.text = ((GameCommonData.Player.Role.Exp + "/") + UIConstData.ExpDic[GameCommonData.Player.Role.Level]);
                    equip.expBarMask.width = ((GameCommonData.Player.Role.Exp / UIConstData.ExpDic[GameCommonData.Player.Role.Level]) * equip.expBar.width);
                    break;
                case "Exp":
                    equip.txtExp.text = ((GameCommonData.Player.Role.Exp + "/") + UIConstData.ExpDic[GameCommonData.Player.Role.Level]);
                    break;
                case "Hp":
                    _local2 = (GameCommonData.Player.Role.MaxHp + GameCommonData.Player.Role.AdditionAtt.MaxHP);
                    attributePanel.txtHp.text = ((Math.min(GameCommonData.Player.Role.HP, _local2) + "/") + _local2);
                    attributePanel.hpBarMask.width = ((Math.min(GameCommonData.Player.Role.HP, _local2) / _local2) * attributePanel.hpBar.width);
                    break;
                case "Mp":
                    _local3 = (GameCommonData.Player.Role.MaxMp + GameCommonData.Player.Role.AdditionAtt.MaxMP);
                    attributePanel.txtMp.text = ((Math.min(GameCommonData.Player.Role.MP, _local3) + "/") + _local3);
                    attributePanel.mpBar.mask = attributePanel.mpBarMask;
                    attributePanel.mpBarMask.width = ((Math.min(GameCommonData.Player.Role.MP, _local3) / _local3) * attributePanel.mpBar.width);
                    break;
            };
        }
        private function initView():void{
            var _local1:ItemUnit;
            var _local2:int;
            while (_local2 < ItemConst.EQUIPMENT_SLOT_END) {
                _local1 = new ItemUnit();
                _local1.Grid = equip[("hero_" + _local2)];
                _local1.Item = null;
                _local1.Index = _local2;
                _local1.IsUsed = false;
                RolePropDatas.ItemUnitList.push(_local1);
                _local2++;
            };
            equip.expBar.mask = equip.expBarMask;
            equip.expBarMask.visible = false;
            itemManager.Initialize();
            attributePanel = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RoleAttributePanel");
            attributePanel.x = equip.width;
            attributePanel.y = 0;
            equip.addChild(attributePanel);
            equip.mcRadio.gotoAndStop((RolePropDatas.isShowFashion) ? 2 : 1);
            equip.txtRadio.mouseEnabled = false;
            if (((RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_ADORN]) && (RolePropDatas.isShowFashion))){
                equip.mcRadio.parent.addChild(equip.mcRadio);
                equip.txtRadio.parent.addChild(equip.txtRadio);
                equip.mcRadio.visible = true;
                equip.txtRadio.visible = true;
            } else {
                equip.mcRadio.visible = false;
                equip.txtRadio.visible = false;
            };
            equip.mcRadio.x = (equip.mcRadio.x + 50);
            equip.txtRadio.x = (equip.txtRadio.x + 50);
            equip.mcRadio.addEventListener(MouseEvent.CLICK, showDress);
        }
        private function showFigure(_arg1:GameRole):void{
            if (_arg1.MainJob.Job >= 0){
                if (((faceItem) && (faceItem.parent))){
                    faceItem.removeEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
                    faceItem.parent.removeChild(faceItem);
                    faceItem = null;
                };
                faceItem = new FaceItem(String(((_arg1.MainJob.Job + "_") + _arg1.Sex)), equip, "JobFigure");
                faceItem.x = 45;
                faceItem.y = 35;
                faceItem.addEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
                equip.addChild(faceItem);
            };
        }
        private function cancelDress():void{
            if (tmpItem){
                sendNotification(EventList.BAGITEMUNLOCK, tmpItem.source.Id);
                tmpItem = null;
            };
        }
        private function getOutFitByClick(_arg1:Object):void{
            BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex), -1);
            BagData.AllLocks[BagData.SelectIndex][BagData.SelectedItem.Index] = false;
            _arg1.IsLock = false;
        }
        private function updateAttData(_arg1:GameRole):void{
            curJob = _arg1.MainJob;
            equip.txtGuildName.text = ((_arg1.GuildName == null)) ? "" : _arg1.GuildName;
            equip.txtLevel.text = (_arg1.Level + LanguageMgr.GetTranslation("级"));
            equip.txtJob.text = GameCommonData.RolesListDic[_arg1.MainJob.Job];
            equip.txtPower.text = _arg1.MainJob.FightPower;
            equip.txtExp.text = ((_arg1.Exp + "/") + UIConstData.ExpDic[_arg1.Level]);
            equip.expBarMask.width = ((_arg1.Exp / UIConstData.ExpDic[_arg1.Level]) * equip.expBar.width);
            updateAttRightData(_arg1);
        }
        private function updateFashionStatus(_arg1:Boolean):void{
            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_ADORN] == null){
                return;
            };
            RolePropDatas.isShowFashion = _arg1;
            if (RolePropDatas.isShowFashion){
                equip.mcRadio.gotoAndStop(2);
            } else {
                equip.mcRadio.gotoAndStop(1);
            };
        }
        private function updateAttRightData(_arg1:GameRole):void{
            var _local2:RoleJob = _arg1.MainJob;
            attributePanel.txtCharmResistance.mouseEnabled = false;
            attributePanel.txtVertigoResistance.mouseEnabled = false;
            attributePanel.txtSleepResistance.mouseEnabled = false;
            attributePanel.txtFixedBodyResistance.mouseEnabled = false;
            attributePanel.txtWeakResistance.mouseEnabled = false;
            attributePanel.txtAttack.mouseEnabled = false;
            attributePanel.txtDefense.mouseEnabled = false;
            attributePanel.txtHit.mouseEnabled = false;
            attributePanel.txtDodge.mouseEnabled = false;
            attributePanel.txtCrit.mouseEnabled = false;
            attributePanel.txtCritRate.mouseEnabled = false;
            attributePanel.txtSkillHit.mouseEnabled = false;
            attributePanel.txtSkillDodge.mouseEnabled = false;
            attributePanel.txtCharmResistance.text = (_local2.CharmResistance + _arg1.AdditionAtt.CharmResistance);
            attributePanel.txtVertigoResistance.text = (_local2.VertigoResistance + _arg1.AdditionAtt.VertigoResistance);
            attributePanel.txtSleepResistance.text = (_local2.SleepResistance + _arg1.AdditionAtt.SleepResistance);
            attributePanel.txtFixedBodyResistance.text = (_local2.FixedBodyResistance + _arg1.AdditionAtt.FixedBodyResistance);
            attributePanel.txtWeakResistance.text = (_local2.WeakResistance + _arg1.AdditionAtt.WeakResistance);
            if ((((_local2.AttackMin == 0)) && ((_local2.AttackMax == 0)))){
                attributePanel.txtAttack.text = "0";
            } else {
                attributePanel.txtAttack.text = (((_local2.AttackMin + _arg1.AdditionAtt.Attack).toString() + "-") + (_local2.AttackMax + _arg1.AdditionAtt.Attack).toString());
            };
            attributePanel.txtDefense.text = (_local2.Defense + _arg1.AdditionAtt.Defense);
            attributePanel.txtHit.text = (_local2.Hit + _arg1.AdditionAtt.Hit);
            attributePanel.txtDodge.text = (_local2.Dodge + _arg1.AdditionAtt.Dodge);
            attributePanel.txtCrit.text = (Number((Number((_local2.Crit + _arg1.AdditionAtt.Crit)) * 100)).toFixed(2) + "%");
            attributePanel.txtCritRate.text = (Number((Number((_local2.CritRate + _arg1.AdditionAtt.CritRate)) * 100)).toFixed(2) + "%");
            attributePanel.txtSkillDodge.text = (_local2.SkillDodge + _arg1.AdditionAtt.SkillDodge);
            attributePanel.txtSkillHit.text = (_local2.SkillHit + _arg1.AdditionAtt.SkillHit);
            var _local3:uint = (_arg1.MaxHp + _arg1.AdditionAtt.MaxHP);
            var _local4:uint = (_arg1.MaxMp + _arg1.AdditionAtt.MaxMP);
            attributePanel.txtHp.text = ((Math.min(_arg1.HP, _local3) + "/") + _local3);
            attributePanel.hpBar.mask = attributePanel.hpBarMask;
            attributePanel.hpBarMask.width = ((Math.min(_arg1.HP, _local3) / _local3) * attributePanel.hpBar.width);
            attributePanel.txtMp.text = ((Math.min(_arg1.MP, _local4) + "/") + _local4);
            attributePanel.mpBar.mask = attributePanel.mpBarMask;
            attributePanel.mpBarMask.width = ((Math.min(_arg1.MP, _local4) / _local4) * attributePanel.mpBar.width);
        }
        override public function listNotificationInterests():Array{
            return ([RoleEvents.INITROLEVIEW, RoleEvents.SHOWPROPELEMENT, RoleEvents.GETOUTFIT, EventList.CLOSEHEROPROP, EventList.GOHEROVIEW, RoleEvents.UPDATEOUTFIT, RoleEvents.GETOUTFITBYCLICK, RoleEvents.GETFITOUTBYBAG, EventList.UPDATEATTRIBUATT, RoleEvents.UPDATEADDATT, RoleEvents.ATTENDPROPELEMENT, RoleEvents.PLAYER_CHANGE_JOB, EventList.UPDATE_MYATTRIBUATT, PlayerInfoComList.UPDATE_ATTACK, RoleEvents.UPDATE_FASHION_STATUS]);
        }
        private function get equip():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Array;
            var _local3:uint;
            var _local4:int;
            switch (_arg1.getName()){
                case RoleEvents.INITROLEVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.EQUIPPANE
                    });
                    this.equip.mouseEnabled = false;
                    itemManager = new ItemManager();
                    facade.registerProxy(itemManager);
                    initView();
                    break;
                case RoleEvents.SHOWPROPELEMENT:
                    if ((_arg1.getBody() as int) != TYPE){
                        facade.sendNotification(RoleEvents.HIDE_ATTRIBUTE);
                        if (parentView.contains(equip)){
                            parentView.removeChild(equip);
                        };
                        return;
                    };
                    parentView.addChildAt(equip, 4);
                    initItem();
                    updateAttData(GameCommonData.Player.Role);
                    showFigure(GameCommonData.Player.Role);
                    break;
                case RoleEvents.GETOUTFIT:
                    initItem();
                    updateAttData(GameCommonData.Player.Role);
                    break;
                case RoleEvents.UPDATEOUTFIT:
                    facade.sendNotification(EventList.UPDATEFILTERBAG);
                    initItem();
                    if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_ADORN]){
                        equip.mcRadio.parent.addChild(equip.mcRadio);
                        equip.txtRadio.parent.addChild(equip.txtRadio);
                        equip.mcRadio.visible = true;
                        equip.txtRadio.visible = true;
                    };
                    break;
                case EventList.GOHEROVIEW:
                    getoutFit(_arg1.getBody());
                    break;
                case RoleEvents.GETOUTFITBYCLICK:
                    getOutFitByClick(_arg1.getBody());
                    break;
                case EventList.UPDATE_MYATTRIBUATT:
                    if (_arg1.getBody() == null){
                        updateAttData(GameCommonData.Player.Role);
                    } else {
                        UpDateAttribute((_arg1.getBody() as String));
                    };
                    break;
                case PlayerInfoComList.UPDATE_ATTACK:
                    updateAttData(GameCommonData.Player.Role);
                    break;
                case RoleEvents.UPDATE_FASHION_STATUS:
                    updateFashionStatus(_arg1.getBody());
                    break;
            };
        }
        private function removeAllItem():void{
            var _local1:UseItem;
            var _local3:int;
            var _local2:int = (equip.numChildren - 1);
            while (_local2 >= 0) {
                if ((equip.getChildAt(_local2) is UseItem)){
                    _local1 = (equip.getChildAt(_local2) as UseItem);
                    equip.removeChild(_local1);
                    _local1 = null;
                };
                _local2--;
            };
            if (RolePropDatas.ItemUnitList.length == 0){
                return;
            };
            while (_local3 < ItemConst.EQUIPMENT_SLOT_END) {
                RolePropDatas.ItemUnitList[_local3].Item = null;
                RolePropDatas.ItemUnitList[_local3].IsUsed = false;
                _local3++;
            };
        }
        private function getoutFit(_arg1:Object):void{
            var _local2:Object;
            var _local3:int = int((_arg1.source.Type / 10000));
            var _local4:int = _arg1.index;
            var _local5:ItemTemplateInfo = (_arg1.source.itemIemplateInfo as ItemTemplateInfo);
            if (((ItemConst.IsEquip(_local5)) && ((RolePropDatas.ItemPos[_local4] == _local5.SubClass)))){
                BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex), _arg1.index);
            } else {
                BagData.AllLocks[BagData.SelectIndex][BagData.SelectedItem.Index] = false;
                _arg1.source.IsLock = false;
            };
        }
        private function showDress(_arg1:MouseEvent):void{
            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_ADORN]){
                if (RolePropDatas.isShowFashion){
                    CharacterSend.requestChange(CharacterSend.FASHION_VISIBLE_CHANGE, true);
                } else {
                    CharacterSend.requestChange(CharacterSend.FASHION_VISIBLE_CHANGE, false);
                };
            } else {
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("请先穿上时装"),
                    color:0xFFFF00
                });
            };
        }
        private function noticeNewerHelp(_arg1:uint):void{
        }

    }
}//package GameUI.Modules.RoleProperty.Mediator 
