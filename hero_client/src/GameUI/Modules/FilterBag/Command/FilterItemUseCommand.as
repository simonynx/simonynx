//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.FilterBag.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.FilterBag.Proxy.*;
    import GameUI.Modules.Convoy.Data.*;
    import GameUI.Modules.PlayerInfo.Mediator.*;
    import GameUI.*;

    public class FilterItemUseCommand extends SimpleCommand {

        public static const NAME:String = "FilterItemUseCommand";

        private function processTreasureReset(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (((ItemConst.IsEquip(_arg2.itemIemplateInfo)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)))){
                _local3 = 0;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                    if (_arg2.itemIemplateInfo.TemplateID == 10100030){
                        _local3 = 1;
                    };
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_RESET_TREASURE, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipStrength(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (ItemConst.IsEquip(_arg2.itemIemplateInfo)){
                _local3 = 0;
            };
            if (_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE){
                if ((((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_UPSTARSTONE)) && ((_arg2.itemIemplateInfo.Attack == 2)))){
                    _local3 = 1;
                } else {
                    if (_arg2.itemIemplateInfo.TemplateID == 10100004){
                        _local3 = 4;
                    } else {
                        if ((((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)) && ((((_arg2.itemIemplateInfo.Attack == 2)) || ((_arg2.itemIemplateInfo.Attack == 3)))))){
                            _local3 = 5;
                        };
                    };
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_STRENGTH_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipPour(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (ItemConst.IsEquip(_arg2.itemIemplateInfo)){
                _local3 = 0;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                    _local3 = 1;
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_POUR_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processTreasureTransform(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (_arg2.itemIemplateInfo.TemplateID == EquipDataConst.treasureTransformUse){
                _local3 = 3;
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_TRANSFORM_TREASURE, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipActive(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (ItemConst.IsEquip(_arg2.itemIemplateInfo)){
                _local3 = 0;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                    _local3 = 1;
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_ACTIVE_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processTreasureTransfer(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (((ItemConst.IsEquip(_arg2.itemIemplateInfo)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)))){
                _local3 = 0;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                    if (_arg2.itemIemplateInfo.Attack == 4){
                        _local3 = 1;
                    };
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_TRANSFER_TREASURE, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipTransform(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_TRANSFORM_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipTransfer(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_TRANSFER_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processConvoy(_arg1:DataProxy, _arg2:UseItem):void{
            if (_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_EQUIP){
                if (ConvoyData.ConvoyTypes.indexOf(_arg2.itemIemplateInfo.SubClass) != -1){
                    FilterBagData.SelectedItem.Item.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EventList.BAGTOCONVOY, BagData.getItemById(_arg2.Id));
                } else {
                    MessageTip.popup(LanguageMgr.GetTranslation("放入的装备类型不对"));
                };
            } else {
                MessageTip.popup(LanguageMgr.GetTranslation("请放入装备类型不对"));
            };
        }
        private function processEquipUpStar(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE){
                if ((((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_UPSTARSTONE)) && ((_arg2.itemIemplateInfo.Attack == 1)))){
                    _local3 = 1;
                } else {
                    if (_arg2.itemIemplateInfo.TemplateID == 10100004){
                        _local3 = 4;
                    } else {
                        if ((((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)) && ((_arg2.itemIemplateInfo.Attack == 2)))){
                            _local3 = 5;
                        };
                    };
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_UPSTAR_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipCompose(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (_arg2.itemIemplateInfo.TemplateID == 10100053){
                _local3 = 5;
            } else {
                if (_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE){
                    if (_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE){
                        _local3 = 999;
                    } else {
                        if (_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_UPSTARSTONE){
                            _local3 = 999;
                        };
                    };
                } else {
                    return;
                };
            };
            sendNotification(EquipCommandList.UPDATE_COMPOSE_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processTreasureSacrifice(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (((ItemConst.IsEquip(_arg2.itemIemplateInfo)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)))){
                _local3 = 0;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                    if (_arg2.itemIemplateInfo.NormalDodge > 0){
                        _local3 = 1;
                    };
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_SACRIFICE_TREASURE, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipIdentify(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (_arg2.itemIemplateInfo.TemplateID == 50700003){
                _local3 = 1;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))){
                    _local3 = 0;
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_IDENTIFY_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipEmbed(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))){
                _local3 = 999;
            } else {
                if (ItemConst.IsEquip(_arg2.itemIemplateInfo)){
                    _local3 = 0;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_EMBED_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processPetOperator(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (((ItemConst.IsPet(_arg2.itemIemplateInfo)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                _local3 = 0;
            } else {
                if (_arg1.PetOperatorFlag == 1){
                    if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_PET_REBUILD)))){
                        _local3 = 1;
                    };
                } else {
                    if (_arg1.PetOperatorFlag == 2){
                        if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_PET_LEARN)))){
                            _local3 = 1;
                        };
                    } else {
                        if (_arg1.PetOperatorFlag == 3){
                            if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_PET_STRENGTHEN)))){
                                _local3 = 1;
                            };
                        } else {
                            return;
                        };
                    };
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
        }
        override public function execute(_arg1:INotification):void{
            if (GameCommonData.Player.Role.HP == 0){
                return;
            };
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local3:UseItem = (FilterBagData.SelectedItem.Item as UseItem);
            var _local4:Boolean;
            if (_local2.ForgeOpenFlag > 0){
                switch (_local2.ForgeOpenFlag){
                    case DataProxy.FORGE_EQUIP_STRENGTH:
                        processEquipStrength(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_IDENTIFY:
                        processEquipIdentify(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_COMPOSE:
                        processEquipCompose(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_EMBED:
                        processEquipEmbed(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_REFINE:
                        processEquipRefine(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_UPSTAR:
                        processEquipUpStar(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_TRANSFER:
                        processEquipTransfer(_local2, _local3);
                        return;
                    case DataProxy.FORGE_EQUIP_TRANSFORM:
                        processEquipTransform(_local2, _local3);
                        return;
                    case DataProxy.FORGE_TREASURE_SACRIFICE:
                        processTreasureSacrifice(_local2, _local3);
                        return;
                    case DataProxy.FORGE_TREASURE_RESET:
                        processTreasureReset(_local2, _local3);
                        return;
                    case DataProxy.FORGE_TREASURE_REBUILD:
                        processTreasureRebuild(_local2, _local3);
                        return;
                    case DataProxy.FORGE_TREASURE_TRANSFER:
                        processTreasureTransfer(_local2, _local3);
                        return;
                    case DataProxy.FORGE_TREASURE_TRANSFORM:
                        processTreasureTransform(_local2, _local3);
                        return;
                };
            };
            if (_local2.PetOperatorFlag){
                processPetOperator(_local2, _local3);
                return;
            };
            if (_local2.ConvoyIsOpen){
                processConvoy(_local2, _local3);
                return;
            };
            if (ItemConst.IsCSBMedical(UIConstData.ItemDic[FilterBagData.AllItems[0][FilterBagData.SelectedItem.Index].TemplateID])){
                BagInfoSend.ItemUse(FilterBagData.AllItems[0][FilterBagData.SelectedItem.Index].ItemGUID);
                return;
            };
        }
        private function processEquipRefine(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint = 999;
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_REFINE_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processEquipBreak(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (ItemConst.IsEquip(_arg2.itemIemplateInfo)){
                _local3 = 0;
            } else {
                return;
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_BREAK_EQUIP, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }
        private function processTreasureRebuild(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:uint;
            if (((ItemConst.IsEquip(_arg2.itemIemplateInfo)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)))){
                _local3 = 0;
            } else {
                if ((((_arg2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                    if (_arg2.itemIemplateInfo.TemplateID == 10100032){
                        _local3 = 1;
                    };
                } else {
                    return;
                };
            };
            FilterBagData.SelectedItem.Item.IsLock = true;
            FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
            sendNotification(EquipCommandList.UPDATE_REBUILD_TREASURE, {
                index:_local3,
                useItem:FilterBagData.SelectedItem.Item
            });
        }

    }
}//package GameUI.Modules.FilterBag.Command 
