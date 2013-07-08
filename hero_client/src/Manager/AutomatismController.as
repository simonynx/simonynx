//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.AutoPlay.Data.*;

    public class AutomatismController {

        public static var AutomatismCoolTime:Number = 0;
        public static var RemindTimePet:int;
        public static var UseSkillList:Dictionary = new Dictionary();
        public static var RemindTimeMp:int;
        public static var ClearNum:int;
        public static var RemindTimeHp:int;
        public static var IsPicking:Boolean;

        public static function AutoUseSkill():void{
            var _local1:SkillInfo;
            var _local3:Point;
            var _local2:Date = new Date();
            if (GameCommonData.TargetAnimal == null){
                return;
            };
            if (GameCommonData.TargetAnimal.Role.HP == 0){
                return;
            };
            if (AutoPlayData.UseImmortalsSkill){
                if (AutoPlayData.MagicWeaponSkillId != 0){
                    if ((_local2.time - GameCommonData.SkillList[AutoPlayData.MagicWeaponSkillId].AutomatismUseTime) > 1000){
                        PlayerController.UsePlayerSkill(GameCommonData.SkillList[AutoPlayData.MagicWeaponSkillId], GameCommonData.TargetAnimal, null);
                        return;
                    };
                };
            };
            if (AutoPlayData.UseCommonSkill){
                if (!FindTheSkill()){
                    for each (_local1 in AutoPlayData.CommonSkillList) {
                        UseSkillList[_local1] = _local1;
                    };
                };
            };
        }
        public static function AutoPickItem(_arg1:DragItem):void{
            clearTimeout(ClearNum);
            var _local2:Point = new Point(_arg1.TileX, _arg1.TileY);
            var _local3:Point = new Point(_arg1.x, _arg1.y);
            var _local4:Object = new Object();
            _local4.id = _arg1.ID;
            _local4.target = _arg1;
            _local4.items = _arg1.Data;
            if (((DistanceController.AnimalTargetDistance(GameCommonData.Player, _local2, 2)) || (!(GameCommonData.Scene.gameScenePlay.Map.IsPass(_local2.x, _local2.y))))){
                UIFacade.GetInstance().PickItem(_local4);
                ClearNum = setTimeout(FindPickItem, 300);
            } else {
                GameCommonData.TargetPickItem = _local4;
                GameCommonData.Scene.playerdistance = 0;
                GameCommonData.TargetScene = "";
                GameCommonData.Scene.PlayerMove(_local3);
            };
        }
        public static function AutoCanPick(_arg1:DragItem):Boolean{
            if (AutoPlayData.PickAll){
                return (true);
            };
            if (((AutoPlayData.PickGold) && (ItemConst.IsGold(_arg1.info)))){
                return (true);
            };
            if (((AutoPlayData.PickEquip) && (ItemConst.IsEquip(_arg1.info)))){
                return (true);
            };
            if (((AutoPlayData.PickMedicinal) && (ItemConst.IsMedical(_arg1.info)))){
                return (true);
            };
            if (((AutoPlayData.PickMagicStone) && (ItemConst.IsMagicStone(_arg1.info)))){
                return (true);
            };
            if (((AutoPlayData.PickMaterial) && (ItemConst.IsMaterial(_arg1.info)))){
                return (true);
            };
            return (false);
        }
        public static function AutoUseItem(_arg1:int):int{
            var _local4:InventoryItemInfo;
            var _local5:InventoryItemInfo;
            var _local6:InventoryItemInfo;
            var _local7:int;
            var _local2:int;
            var _local3:int = GameCommonData.Player.Role.Level;
            switch (_arg1){
                case 1:
                    _local4 = BagData.findTingByType(ItemConst.ITEM_CLASS_MEDICAL, ItemConst.MEDICINE_HPBAG, "Attack", _local3);
                    if (_local4){
                        if (ItemConst.IsMedicalExceptBAG(_local4)){
                            UIFacade.GetInstance().sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                        };
                        BagInfoSend.ItemUse(_local4.ItemGUID);
                    } else {
                        _local4 = BagData.findTingByType(ItemConst.ITEM_CLASS_MEDICAL, ItemConst.ITEM_SUBCLASS_MEDICAL_RECOVER, "HpBonus", _local3);
                        if (_local4){
                            if (ItemConst.IsMedicalExceptBAG(_local4)){
                                UIFacade.GetInstance().sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                            };
                            BagInfoSend.ItemUse(_local4.ItemGUID);
                        } else {
                            _local7 = getTimer();
                            if ((_local7 - RemindTimeHp) > 40000){
                                MessageTip.show("背包内缺少相应加血药品,请及时补充");
                                RemindTimeHp = _local7;
                            };
                        };
                    };
                    break;
                case 2:
                    _local5 = BagData.findTingByType(ItemConst.ITEM_CLASS_MEDICAL, ItemConst.MEDICINE_MPBAG, "Attack", _local3);
                    if (_local5){
                        if (ItemConst.IsMedicalExceptBAG(_local5)){
                            UIFacade.GetInstance().sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                        };
                        BagInfoSend.ItemUse(_local5.ItemGUID);
                    } else {
                        _local5 = BagData.findTingByType(ItemConst.ITEM_CLASS_MEDICAL, ItemConst.ITEM_SUBCLASS_MEDICAL_RECOVER, "MpBonus", _local3);
                        if (_local5){
                            if (ItemConst.IsMedicalExceptBAG(_local5)){
                                UIFacade.GetInstance().sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                            };
                            BagInfoSend.ItemUse(_local5.ItemGUID);
                        } else {
                            _local7 = getTimer();
                            if ((_local7 - RemindTimeMp) > 40000){
                                MessageTip.show("背包内缺少相应加魔药品,请及时补充");
                                RemindTimeMp = _local7;
                            };
                        };
                    };
                    break;
                case 3:
                case 4:
                    _local6 = BagData.findTingByType(ItemConst.ITEM_CLASS_MEDICAL, ItemConst.ITEM_SUBCLASS_MEDICAL_PET, "Attack", _local3);
                    if (_local6){
                        if (ItemConst.IsMedicalExceptBAG(_local6)){
                            UIFacade.GetInstance().sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                        };
                        BagInfoSend.ItemUse(_local6.ItemGUID);
                    } else {
                        _local7 = getTimer();
                        if ((_local7 - RemindTimePet) > 40000){
                            MessageTip.show("背包内缺少相应宠物药品,请及时补充");
                            RemindTimePet = _local7;
                        };
                    };
                    break;
            };
            return (_local2);
        }
        public static function FindTheSkill():Boolean{
            var _local1:SkillInfo;
            var _local3:Point;
            var _local2:Date = new Date();
            for each (_local1 in UseSkillList) {
                if (AutoPlayData.CommonSkillList[_local1.TypeID] == null){
                    delete UseSkillList[_local1];
                } else {
                    if (_local2.time > _local1.AutomatismUseTime){
                        if (GameSkillMode.IsShowRect(_local1.SkillType)){
                            _local3 = new Point(GameCommonData.TargetAnimal.Role.TileX, GameCommonData.TargetAnimal.Role.TileY);
                            PlayerController.UsePlayerSkill(_local1, GameCommonData.TargetAnimal, _local3);
                            delete UseSkillList[_local1];
                            return (true);
                        };
                        if (GameSkillMode.IsTargetSelfSkill(_local1)){
                            if (GameSkillMode.isBuffSkill(_local1)){
                                if (!GameCommonData.Player.Role.IsSameTpyeBuff(_local1.buffId)){
                                    PlayerController.UsePlayerSkill(_local1, GameCommonData.Player, null);
                                    delete UseSkillList[_local1];
                                    return (true);
                                };
                            } else {
                                PlayerController.UsePlayerSkill(_local1, GameCommonData.TargetAnimal, null);
                                delete UseSkillList[_local1];
                                return (true);
                            };
                        } else {
                            PlayerController.UsePlayerSkill(_local1, GameCommonData.TargetAnimal, null);
                            delete UseSkillList[_local1];
                            return (true);
                        };
                    };
                };
            };
            return (false);
        }
        public static function FindPickItem(_arg1:Boolean=true):void{
            var _local2:DragItem;
            var _local3:int;
            clearTimeout(ClearNum);
            trace("拾取物品");
            AutomatismController.IsPicking = true;
            for each (_local2 in GameCommonData.PackageList) {
                if (DistanceController.AnimalTargetDistance(GameCommonData.Player, new Point(_local2.TileX, _local2.TileY), 10)){
                    if (_local2.isPicked == false){
                        if ((((_local2.OwnerGUID == GameCommonData.Player.Role.Id)) || ((_local2.OwnerGUID == 0)))){
                            if (_local2.info.MainClass == ItemConst.ITEM_CLASS_MATERIAL){
                                _local3 = 2;
                            } else {
                                _local3 = 0;
                            };
                            if (((!(ItemConst.IsGold(_local2.info))) && (BagData.isBagFullByItemId(_local2.info.type)))){
                                UIFacade.GetInstance().sendNotification(HintEvents.RECEIVEINFO, {
                                    info:"包裹格子已满",
                                    color:0xFF0000
                                });
                            } else {
                                if (((AutoCanPick(_local2)) || ((_arg1 == false)))){
                                    AutoPickItem(_local2);
                                    return;
                                };
                            };
                        };
                    };
                };
            };
            if (((_arg1) || (GameCommonData.Player.IsAutomatism))){
                ClearNum = setTimeout(PlayerController.Automatism, 600);
                AutomatismController.IsPicking = false;
            } else {
                MessageTip.show("附近没有可拾取的物品");
            };
        }

    }
}//package Manager 
