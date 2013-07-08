//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Friend.view.ui.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.PlayerInfo.UI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Pet.Data.*;
    import GameUI.*;

    public class PetInfoMediator extends Mediator {

        public static const NAME:String = "PetInfoMediator";
        public static const DEFAULT_POS:Point = new Point(95, 70);

        private var _buffs:HeadImgList;
        private var _face:uint;
        private var _menu:MenuItem;
        private var levelupMc:MovieClip;
        private var showPetMc:MovieClip;
        private var _role:GameRole;
        private var isShowPet:Boolean;
        private var preLevel:int = -1;
        private var _dataProxy:DataProxy;
        private var HpRectangle:Rectangle;
        private var MpRectangle:Rectangle;
        private var _head:MovieClip;

        public function PetInfoMediator(_arg1:String=null, _arg2:Object=null){
            HpRectangle = new Rectangle(51, 27, 83, 0);
            MpRectangle = new Rectangle(47, 36, 77, 0);
            super(NAME, _arg2);
        }
        private function addBloodHandler(_arg1:MouseEvent):void{
            var _local2:InventoryItemInfo;
            _local2 = BagData.getItemByType(30400001);
            if (_local2 == null){
                _local2 = BagData.getItemByType(30400002);
            };
            if (_local2 == null){
                MessageTip.popup(LanguageMgr.GetTranslation("缺少宠物药"));
                return;
            };
            BagInfoSend.ItemUse(_local2.id);
        }
        private function setBoold():void{
            (this.petInfoUI.redOneMask as MovieClip).width = (Math.min((this.role.HP / this.role.MaxHp), 1) * 87);
            (this.petInfoUI.greenOneMask as MovieClip).width = (Math.min((this.role.MP / this.role.MaxMp), 1) * 81);
        }
        public function get petInfoUI():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:int;
            switch (_arg1.getName()){
                case PlayerInfoComList.INIT_PLAYERINFO_UI:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"PetInfo"
                    });
                    this.petInfoUI.mouseEnabled = false;
                    this._dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    (this.petInfoUI.txt_level as TextField).mouseEnabled = false;
                    this.petInfoUI.faceMask.visible = false;
                    (this.petInfoUI.mc_headImg as MovieClip).mask = this.petInfoUI.faceMask;
                    (this.petInfoUI.mc_headImg as MovieClip).addEventListener(MouseEvent.CLICK, onHeadClickHandler);
                    this.petInfoUI["redOne"].mask = this.petInfoUI["redOneMask"];
                    this.petInfoUI["greenOne"].mask = this.petInfoUI["greenOneMask"];
                    this.petInfoUI["hpLever"].addEventListener(MouseEvent.MOUSE_DOWN, onLeverDown);
                    this.petInfoUI["hpLever"].addEventListener(MouseEvent.MOUSE_OVER, onLeverOver);
                    this.petInfoUI["hpLever"].addEventListener(MouseEvent.MOUSE_OUT, onMpLeverOut);
                    this.petInfoUI["mpLever"].addEventListener(MouseEvent.MOUSE_DOWN, onLeverDown);
                    this.petInfoUI["mpLever"].addEventListener(MouseEvent.MOUSE_OVER, onLeverOver);
                    this.petInfoUI["mpLever"].addEventListener(MouseEvent.MOUSE_OUT, onMpLeverOut);
                    this.petInfoUI["hpLever"].gotoAndStop(1);
                    this.petInfoUI["mpLever"].gotoAndStop(1);
                    this.petInfoUI["addBloodBtn"].addEventListener(MouseEvent.CLICK, addBloodHandler);
                    this.levelupMc = this.petInfoUI["levelupMc"];
                    this.levelupMc.stop();
                    this.petInfoUI.removeChild(this.levelupMc);
                    this.showPetMc = this.petInfoUI["showPetMc"];
                    this.showPetMc.stop();
                    this.petInfoUI.removeChild(this.showPetMc);
                    this._buffs = new HeadImgList(2);
                    this._buffs.x = 55;
                    this._buffs.y = 20;
                    this._head = this.petInfoUI.mc_headImg;
                    this._head.alpha = 1;
                    this._menu = new MenuItem();
                    this.initMenu();
                    this.petInfoUI["hpLever"].x = (int(((Number(SharedManager.getInstance().petHpPercent) * 87) / 100)) + 51);
                    this.petInfoUI["mpLever"].x = (int(((Number(SharedManager.getInstance().petMpPercent) * 77) / 100)) + 47);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    this.petInfoUI.x = DEFAULT_POS.x;
                    this.petInfoUI.y = DEFAULT_POS.y;
                    break;
                case PlayerInfoComList.SHOW_PET_UI:
                    this._role = (_arg1.getBody() as GameRole);
                    if (((GameCommonData.Player.Role.UsingPetAnimal) && (this._role))){
                        (this.petInfoUI.txt_roleName as TextField).text = this._role.Name;
                    } else {
                        (this.petInfoUI.txt_roleName as TextField).text = "???";
                    };
                    if (!this.isShowPet){
                        GameCommonData.GameInstance.GameUI.addChild(this.petInfoUI);
                        this.isShowPet = true;
                        this._head.stage.addEventListener(MouseEvent.CLICK, onStageMouseClickHandler);
                    };
                    this.updatePetInfo();
                    this.petInfoUI.addChild(this.showPetMc);
                    this.showPetMc.play();
                    _local2 = 0;
                    GameCommonData.lastPlayPetIdx = -1;
                    while (_local2 < PetPropConstData.EQUIP_NUM) {
                        if (((RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local2)]]) && (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local2)]].PetInfo.IsUsing))){
                            GameCommonData.lastPlayPetIdx = ItemConst[("EQUIPMENT_SLOT_PET" + _local2)];
                        };
                        _local2++;
                    };
                    break;
                case PlayerInfoComList.REMOVE_PET_UI:
                    if (GameCommonData.GameInstance.GameUI.contains(this.petInfoUI)){
                        this._head.stage.removeEventListener(MouseEvent.CLICK, onStageMouseClickHandler);
                        GameCommonData.GameInstance.GameUI.removeChild(this.petInfoUI);
                        this.isShowPet = false;
                        this._role = null;
                    };
                    break;
                case PlayerInfoComList.UPDATE_PET_UI:
                    if (this.isShowPet){
                        this.updatePetInfo();
                    };
                    break;
                case PlayerInfoComList.UPDATE_LEVER:
                    this.petInfoUI["hpLever"].x = (int(((Number(SharedManager.getInstance().petHpPercent) * 87) / 100)) + 51);
                    this.petInfoUI["mpLever"].x = (int(((Number(SharedManager.getInstance().petMpPercent) * 77) / 100)) + 47);
                    break;
            };
        }
        private function setFace(_arg1:uint):void{
            if (this._face == _arg1){
                return;
            };
            this._face = _arg1;
            var _local2:FaceItem = new FaceItem(String(_arg1), null, "face", (48 / 50));
            while ((this.petInfoUI.mc_headImg as MovieClip).numChildren > 0) {
                (this.petInfoUI.mc_headImg as MovieClip).removeChildAt(0);
            };
            (this.petInfoUI.mc_headImg as MovieClip).addChild(_local2);
        }
        private function setName():void{
            (this.petInfoUI.txt_roleName as TextField).text = this._role.Name;
        }
        private function initMenu():void{
            this._menu.dataPro = [{
                cellText:LanguageMgr.GetTranslation("休息"),
                data:{type:"休息"}
            }];
            this._menu.addEventListener(MenuEvent.Cell_Click, onCellClickHandler);
        }
        private function setLevel(_arg1:uint):void{
            var _local2:String = (this.petInfoUI.txt_level as TextField).text;
            if (_local2 == String(_arg1)){
                return;
            };
            if (((!((preLevel == -1))) && ((_arg1 > preLevel)))){
                this.petInfoUI.addChild(this.levelupMc);
                this.levelupMc.play();
            };
            (this.petInfoUI.txt_level as TextField).text = String(_arg1);
            preLevel = _arg1;
        }
        private function setBuffs():void{
            var _local1:GameSkillBuff;
            var _local2:GameSkillBuff;
            var _local4:int;
            var _local3:Array = [];
            for each (_local1 in this.role.DotBuff) {
                _local4++;
                if (_local4 > 5){
                    break;
                };
                _local3.push({
                    icon:_local1.TypeID,
                    tip:_local1.BuffName,
                    isDeBuff:true
                });
            };
            for each (_local2 in this.role.PlusBuff) {
                _local4++;
                if (_local4 > 5){
                    break;
                };
                _local3.push({
                    icon:_local2.TypeID,
                    tip:_local2.BuffName,
                    isDeBuff:false
                });
            };
            this._buffs.dataPro = [_local3];
            this.petInfoUI.addChild(this._buffs);
        }
        private function onStageMouseClickHandler(_arg1:MouseEvent):void{
            if (this._menu.stage != null){
                GameCommonData.GameInstance.GameUI.removeChild(this._menu);
            };
        }
        private function onLeverMove(_arg1:MouseEvent):void{
            SharedManager.getInstance().petHpPercent = String(int((((this.petInfoUI["hpLever"].x - 51) / 83) * 100)));
            SharedManager.getInstance().petMpPercent = String(int((((this.petInfoUI["mpLever"].x - 47) / 77) * 100)));
        }
        private function updatePetInfo():void{
            this.setName();
            this.setBoold();
            this.setFace(this._role.Face);
            this.setLevel(this._role.Level);
            this.setBuffs();
        }
        private function onLeverUp(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.petInfoUI["hpLever"]){
                this.petInfoUI["hpLever"].stopDrag();
            } else {
                this.petInfoUI["mpLever"].stopDrag();
            };
            sendNotification(AutoPlayEventList.UPDATE_TEXT);
            GameCommonData.GameInstance.removeEventListener(MouseEvent.MOUSE_MOVE, onLeverMove);
            GameCommonData.GameInstance.removeEventListener(MouseEvent.MOUSE_UP, onLeverUp);
        }
        private function onHeadClickHandler(_arg1:MouseEvent):void{
            if (GameCommonData.IsInCrossServer){
                return;
            };
            var _local2:Point = new Point(this._head.mouseX, this._head.mouseY);
            var _local3:Point = this._head.localToGlobal(_local2);
            var _local4:DisplayObject = GameCommonData.GameInstance.GameUI.getChildByName("MENU");
            if (_local4 != null){
                GameCommonData.GameInstance.GameUI.removeChild(_local4);
            };
            GameCommonData.GameInstance.GameUI.addChild(this._menu);
            this._menu.x = _local3.x;
            this._menu.y = _local3.y;
            _arg1.stopPropagation();
            if (GameCommonData.Player.Role.UsingPetAnimal){
                TargetController.SetTarget(GameCommonData.Player.Role.UsingPetAnimal);
            };
            sendNotification(PlayerInfoComList.SELECT_ELEMENT, this.role);
        }
        private function onLeverDown(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.petInfoUI["hpLever"]){
                this.petInfoUI["hpLever"].startDrag(false, HpRectangle);
            } else {
                this.petInfoUI["mpLever"].startDrag(false, MpRectangle);
            };
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_UP, onLeverUp);
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_MOVE, onLeverMove);
        }
        private function onLeverOver(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.petInfoUI["hpLever"]){
                this.petInfoUI["hpLever"].gotoAndStop(2);
            } else {
                this.petInfoUI["mpLever"].gotoAndStop(2);
            };
        }
        override public function listNotificationInterests():Array{
            return ([PlayerInfoComList.INIT_PLAYERINFO_UI, EventList.ENTERMAPCOMPLETE, PlayerInfoComList.SHOW_PET_UI, PlayerInfoComList.REMOVE_PET_UI, PlayerInfoComList.UPDATE_PET_UI, PlayerInfoComList.UPDATE_LEVER]);
        }
        private function onCellClickHandler(_arg1:MenuEvent):void{
            switch (_arg1.cell.data["type"]){
                case "休息":
                    PetSend.Rest();
                    break;
            };
        }
        private function onMpLeverOut(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.petInfoUI["hpLever"]){
                this.petInfoUI["hpLever"].gotoAndStop(1);
            } else {
                this.petInfoUI["mpLever"].gotoAndStop(1);
            };
        }
        public function get role():GameRole{
            return (this._role);
        }

    }
}//package GameUI.Modules.PlayerInfo.Mediator 
