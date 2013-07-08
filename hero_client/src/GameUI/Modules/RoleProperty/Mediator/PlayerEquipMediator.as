//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.RoleProperty.Prxoy.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.*;
    //import GameUI.Modules.RoleProperty.Net.*;

    public class PlayerEquipMediator extends Mediator {

        public static const NAME:String = "PlayerEquipMediator";

        private var attributePanel:MovieClip;
        private var tmpItem:Object = null;
        private var isGet:Boolean = false;
        private var ItemUnitList:Array;
        private var faceItem:FaceItem;
        private var curJob:RoleJob = null;
        private var frame:HFrame;
        public var ItemList:Array;

        public function PlayerEquipMediator(){
            super(NAME);
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
        private function initItem():void{
            var _local1:UseItem;
            var _local2:Object;
            var _local3:Object;
            var _local4:int;
            removeAllItem();
            if (ItemUnitList.length == 0){
                return;
            };
            while (_local4 < ItemConst.EQUIPMENT_SLOT_END) {
                if (ItemList[_local4]){
                    _local1 = new UseItem(ItemList[_local4].Place, ItemList[_local4].type, equip, ItemList[_local4].ItemGUID);
                    _local1.x = (ItemUnitList[_local4].Grid.x + 2);
                    _local1.y = (ItemUnitList[_local4].Grid.y + 2);
                    _local1.Id = ItemList[_local4].ItemGUID;
                    _local1.IsBind = ItemList[_local4].isBind;
                    _local1.Type = ItemList[_local4].type;
                    _local1.Pos = _local4;
                    ItemUnitList[ItemList[_local4].Place].Item = _local1;
                    ItemUnitList[ItemList[_local4].Place].IsUsed = true;
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
        }
        public function addEvents():void{
            frame.closeCallBack = closeHandler;
        }
        private function initView():void{
            var _local1:ItemUnit;
            var _local3:Sprite;
            frame = new HFrame();
            frame.setSize(295, 417);
            frame.titleText = "";
            frame.centerTitle = true;
            frame.blackGound = false;
            frame.addContent(equip);
            frame.IsTop = true;
            equip.x = 9;
            equip.y = 29;
            ItemUnitList = [];
            ItemList = [];
            var _local2:int;
            while (_local2 < ItemConst.EQUIPMENT_SLOT_END) {
                _local1 = new ItemUnit();
                _local1.Grid = equip[("hero_" + _local2)];
                _local1.Grid.mouseEnabled = false;
                _local3 = new Sprite();
                _local3.graphics.beginFill(0, 0);
                _local3.graphics.drawRect(0, 0, _local1.Grid.width, _local1.Grid.height);
                _local3.graphics.endFill();
                _local3.name = ("playerinfo_" + _local2);
                _local1.Grid.addChild(_local3);
                _local1.Item = null;
                _local1.Index = _local2;
                _local1.IsUsed = false;
                ItemUnitList.push(_local1);
                _local2++;
            };
            equip.expBar.mask = equip.expBarMask;
            equip.expBarMask.visible = false;
            equip.mcRadio.visible = false;
            equip.txtRadio.visible = false;
            attributePanel = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RoleAttributePanel");
            attributePanel.x = (frame.width - 2);
            attributePanel.y = 1;
            equip.addChild(attributePanel);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, RoleEvents.SHOW_PLAYER_PROPELEMENT]);
        }
        private function updateAttData(_arg1:GameRole):void{
            frame.titleText = _arg1.Name;
            curJob = _arg1.MainJob;
            equip.txtGuildName.text = _arg1.GuildName;
            equip.txtLevel.text = (_arg1.Level + "级");
            equip.txtJob.text = GameCommonData.RolesListDic[_arg1.MainJob.Job];
            equip.txtPower.text = _arg1.MainJob.FightPower;
            equip.txtExp.text = ((_arg1.Exp + "/") + UIConstData.ExpDic[_arg1.Level]);
            equip.expBarMask.width = ((_arg1.Exp / UIConstData.ExpDic[_arg1.Level]) * equip.expBar.width);
            updateAttRightData(_arg1);
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
            attributePanel.hpBarMask.width = ((Math.min(_arg1.HP, _local3) / _local3) * attributePanel.hpBar.width);
            attributePanel.txtMp.text = ((Math.min(_arg1.MP, _local4) + "/") + _local4);
            attributePanel.mpBarMask.width = ((Math.min(_arg1.MP, _local4) / _local4) * attributePanel.mpBar.width);
        }
        private function get equip():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function closeHandler():void{
            GameCommonData.GameInstance.GameUI.removeChild(frame);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:GameRole;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.EQUIPPANE
                    });
                    this.equip.mouseEnabled = false;
                    initView();
                    addEvents();
                    break;
                case RoleEvents.SHOW_PLAYER_PROPELEMENT:
                    ItemList = (_arg1.getBody()["itemlist"] as Array);
                    _local2 = (_arg1.getBody()["role"] as GameRole);
                    frame.x = 270;
                    frame.y = 77;
                    GameCommonData.GameInstance.GameUI.addChild(frame);
                    initItem();
                    updateAttData(_local2);
                    showFigure(_local2);
                    break;
            };
        }
        private function removeAllItem():void{
            var _local1:ItemBase;
            var _local3:int;
            var _local2:int = (equip.numChildren - 1);
            while (_local2 >= 0) {
                if ((equip.getChildAt(_local2) is ItemBase)){
                    _local1 = (equip.getChildAt(_local2) as ItemBase);
                    equip.removeChild(_local1);
                    _local1 = null;
                };
                _local2--;
            };
            if (ItemUnitList.length == 0){
                return;
            };
            while (_local3 < ItemConst.EQUIPMENT_SLOT_END) {
                ItemUnitList[_local3].Item = null;
                ItemUnitList[_local3].IsUsed = false;
                _local3++;
            };
        }

    }
}//package GameUI.Modules.RoleProperty.Mediator 
