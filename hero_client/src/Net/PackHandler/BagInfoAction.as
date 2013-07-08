//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.Modules.PetRace.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.WineParty.Data.*;
    import GameUI.Modules.StoryDisplay.model.data.*;
    import GameUI.Modules.StoryDisplay.model.vo.*;
    import GameUI.Modules.Depot.Data.*;
    import GameUI.Modules.NewInfoTip.Command.*;

    public class BagInfoAction extends GameAction {

        private static var _instance:BagInfoAction;

        public function BagInfoAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():BagInfoAction{
            if (!_instance){
                _instance = new (BagInfoAction)();
            };
            return (_instance);
        }

        private function getGoodList(_arg1:NetPacket):void{
            var _local8:InventoryItemInfo;
            var _local9:uint;
            var _local10:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            if (_local2 == 0){
                if (_local3 > (BagData.GRID_COLS * 3)){
                    facade.sendNotification(BagEvents.EXTENDBAG, _local3);
                };
                facade.sendNotification(PetRaceEvent.HAS_GET_BAG_DATA);
            };
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:int;
            var _local6:int;
            while (_local5 < _local4) {
                _local8 = new InventoryItemInfo();
                _local8.ReadFromPacket(_arg1);
                if ((((_local8.Place >= ItemConst.EQUIP_SLOT_START)) && ((_local8.Place < ItemConst.EQUIP_SLOT_END)))){
                    RolePropDatas.ItemList[(_local8.Place - ItemConst.EQUIP_SLOT_START)] = _local8;
                    facade.sendNotification(AutoPlayEventList.UPDATE_MAGIC_WEAPON);
                } else {
                    if (_local8.Place < ItemConst.NORMAL_SLOT_END){
                        _local9 = ItemConst.placeToPanel(_local8.Place);
                        _local10 = ItemConst.placeToOffset(_local8.Place);
                        _local8.index = _local10;
                        BagData.AllLocks[_local9][_local8.index] = false;
                        BagData.AllItems[_local9][_local8.index] = _local8;
                    } else {
                        if ((((_local8.Place >= ItemConst.BANK_SLOT_START)) && ((_local8.Place < ItemConst.BANK_SLOT_END)))){
                            _local8.index = (_local8.Place - ItemConst.BANK_SLOT_START);
                            DepotConstData.goodList[_local8.index] = _local8;
                        };
                    };
                };
                if (_local8.id > GetRewardConstData.MaxEquipGuild){
                    GetRewardConstData.MaxEquipGuild = _local8.id;
                };
                _local5++;
            };
            var _local7:Array = BagData.AllItems;
            UIFacade.GetInstance().sendNotification(RoleEvents.UPDATEOUTFIT);
            UIFacade.GetInstance().sendNotification(EventList.UPDATEBAG);
            BagData.IsLoadBagGoodList = true;
            if (_local2 == 4){
                if (_local3 > 42){
                    _local3 = 42;
                };
                DepotConstData.gridCount = _local3;
                UIFacade.GetInstance().sendNotification(EventList.SHOWDEPOTVIEW);
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local2:uint;
            var _local3:uint;
            switch (_arg1.opcode){
                case Protocol.SMSG_GOODSLIST:
                    getGoodList(_arg1);
                    break;
                case Protocol.SMSG_GRID_GOODS:
                    updateGridGoods(_arg1);
                    break;
                case Protocol.SMSG_USE_ITEM:
                    itemUse(_arg1);
                    break;
                case Protocol.SMSG_SWAP_ITEM:
                    itemSwap(_arg1);
                    break;
                case Protocol.SMSG_INVENTORY_CHANGE_FAILURE:
                    processError(_arg1);
                    break;
                case Protocol.SMSG_BAGUPDATE:
                    updateBag(_arg1);
                    break;
                case Protocol.SMSG_SLOT_EXPAND:
                    _local2 = _arg1.readUnsignedInt();
                    _local3 = _arg1.readUnsignedInt();
                    if (_local3 > 42){
                        _local3 = 42;
                    };
                    BagData.gotoClickExtendBtn = true;
                    if (BagData.BagNum[BagData.NormalId] != _local2){
                        MessageTip.popup(LanguageMgr.GetTranslation("背包扩充成功"));
                        facade.sendNotification(BagEvents.EXTENDBAG, _local2);
                    } else {
                        if (DepotConstData.gridCount != _local3){
                            MessageTip.popup(LanguageMgr.GetTranslation("仓库扩充成功"));
                            DepotConstData.gridCount = _local3;
                            facade.sendNotification(DepotEvent.EXTENDDEPOT, _local3);
                        };
                    };
                    break;
            };
        }
        private function itemUse(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            facade.sendNotification(EventList.BAGITEMUNLOCK, _local2);
        }
        public function getItemProtoFromFile(_arg1:ByteArray):void{
            var _local4:uint;
            var _local5:ItemTemplateInfo;
            _arg1.endian = "littleEndian";
            var _local2:int = _arg1.readUnsignedInt();
            _arg1.position = (_local2 + 4);
            var _local3:uint = _arg1.readUnsignedInt();
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = new ItemTemplateInfo();
                _local5.ReadTemplateFromPacket(_arg1);
                UIConstData.ItemDic[_local5.TemplateID] = _local5;
                if (_local5.MainClass == ItemConst.ITEM_CLASS_EQUIP){
                    if (_local5.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                        UIConstData.TreasureSeriesDic[(String(_local5.AdditionFields[0]) + "_0")] = _local5;
                    } else {
                        if (_local5.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY){
                            UIConstData.TreasureSeriesDic[(String(_local5.AdditionFields[0]) + "_1")] = _local5;
                        } else {
                            if (_local5.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK){
                                UIConstData.TreasureSeriesDic[(String(_local5.AdditionFields[0]) + "_2")] = _local5;
                            };
                        };
                    };
                };
                _local4++;
            };
            BagData.hasGetItemProto = true;
            BagInfoSend.RequestItems();
            MarketSend.getShopItemList(MarketConstData.SHOPTYPE_PLAZA);
            MailSend.requestMailList();
        }
        private function itemSwap(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = ItemConst.placeToPanel(_local2);
            var _local5:uint = ItemConst.placeToPanel(_local3);
            var _local6:uint = ItemConst.placeToOffset(_local2);
            var _local7:uint = ItemConst.placeToOffset(_local3);
            if ((((((((_local4 >= 0)) && ((_local4 <= 2)))) && ((_local6 >= 0)))) && ((_local6 < 42)))){
                if (((BagData.GridUnitList[_local4][_local6]) && (BagData.GridUnitList[_local4][_local6].Item))){
                    BagData.GridUnitList[_local4][_local6].Item.IsLock = false;
                };
                BagData.AllLocks[_local4][_local6] = false;
            };
            if ((((((((_local5 >= 0)) && ((_local5 <= 2)))) && ((_local7 >= 0)))) && ((_local7 < 42)))){
                if (((BagData.GridUnitList[_local5][_local7]) && (BagData.GridUnitList[_local5][_local7].Item))){
                    BagData.GridUnitList[_local5][_local7].Item.IsLock = false;
                };
                BagData.AllLocks[_local5][_local7] = false;
            };
        }
        private function updateGridGoods(_arg1:NetPacket):void{
            var _local4:InventoryItemInfo;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local8:Boolean;
            var _local9:InventoryItemInfo;
            var _local10:InventoryItemInfo;
            var _local11:int;
            var _local12:StoryVO;
            var _local13:TaskInfoStruct;
            var _local14:QuestItemReward;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = new InventoryItemInfo();
                _local4.Place = _arg1.readUnsignedInt();
                _local4.Count = _arg1.readUnsignedInt();
                if ((((_local4.Place >= ItemConst.QUEST_SLOT_START)) && ((_local4.Place < ItemConst.NORMAL_SLOT_END)))){
                    _local5 = ItemConst.placeToPanel(_local4.Place);
                    _local6 = ItemConst.placeToOffset(_local4.Place);
                    _local4.index = _local6;
                };
                if ((((_local4.Place >= ItemConst.EQUIPMENT_SLOT_PET0)) && ((_local4.Place <= ItemConst.EQUIPMENT_SLOT_PET_END)))){
                    _local9 = RolePropDatas.ItemList[(_local4.Place - ItemConst.EQUIP_SLOT_START)];
                    if (_local9){
                        _local9.Place = _local4.Place;
                        _local9.Count = _local4.Count;
                        _local4 = _local9;
                    };
                };
                if (_local4.Count == 0){
                    if ((((_local4.Place >= ItemConst.EQUIP_SLOT_START)) && ((_local4.Place < ItemConst.EQUIP_SLOT_END)))){
                        RolePropDatas.ItemList[(_local4.Place - ItemConst.EQUIP_SLOT_START)] = null;
                        if (RolePropDatas.ItemList[(_local4.Place - ItemConst.EQUIP_SLOT_START)]){
                            RolePropDatas.ItemList[(_local4.Place - ItemConst.EQUIP_SLOT_START)].Dispose();
                        };
                        facade.sendNotification(RoleEvents.UPDATEOUTFIT);
                        facade.sendNotification(AutoPlayEventList.UPDATE_MAGIC_WEAPON);
                    } else {
                        if ((((_local4.Place >= ItemConst.QUEST_SLOT_START)) && ((_local4.Place < ItemConst.NORMAL_SLOT_END)))){
                            _local8 = false;
                            _local10 = BagData.AllItems[_local5][_local4.index];
                            if ((((((_local5 == 0)) && (_local10))) && ((((_local10.TemplateID == 70200001)) || ((_local10.TemplateID == 70300007)))))){
                                _local8 = true;
                            };
                            BagData.AllLocks[_local5][_local4.index] = false;
                            if (BagData.AllItems[_local5][_local4.index]){
                                BagData.AllItems[_local5][_local4.index].Dispose();
                            };
                            BagData.AllItems[_local5][_local4.index] = null;
                            if (_local8){
                                if (_local10.TemplateID == 70200001){
                                    facade.sendNotification(EquipCommandList.REFRESH_PET_REBUILD);
                                } else {
                                    if (_local10.TemplateID == 70300007){
                                        facade.sendNotification(EquipCommandList.REFRESH_PET_STRENGTHEN, {sucess:false});
                                    };
                                };
                            };
                        } else {
                            if ((((_local4.Place >= ItemConst.BANK_SLOT_START)) && ((_local4.Place < ItemConst.BANK_SLOT_END)))){
                                _local4.index = (_local4.Place - ItemConst.BANK_SLOT_START);
                                DepotConstData.goodList[_local4.index] = null;
                                facade.sendNotification(DepotEvent.UPDATEDEPOT);
                            };
                        };
                    };
                    _local3++;
                } else {
                    _local4.ItemGUID = _arg1.readUnsignedInt();
                    _local4.TemplateID = _arg1.readUnsignedInt();
                    _local7 = _arg1.readUnsignedInt();
                    _local4.isBind = (_local7 % 10);
                    _local4.isBroken = (_local7 / 10);
                    _local4.BeginTime = _arg1.readUnsignedInt();
                    _local4.ValidTime = _arg1.readUnsignedInt();
                    if ((((_local4.BeginTime > 0)) && ((_local4.ValidTime > 0)))){
                        _local4.RemainTime = (((_local4.BeginTime + _local4.ValidTime) - (TimeManager.Instance.Now().time / 1000)) / 60);
                    } else {
                        _local4.RemainTime = 0;
                    };
                    ClassFactory.copyProperties(UIConstData.ItemDic[_local4.TemplateID], _local4);
                    _local4.SetRemainTime();
                    if (((UIConstData.ItemDic[_local4.TemplateID]) && ((((UIConstData.ItemDic[_local4.TemplateID].MainClass == ItemConst.ITEM_CLASS_EQUIP)) || ((((UIConstData.ItemDic[_local4.TemplateID].MainClass == ItemConst.ITEM_CLASS_PET)) && ((UIConstData.ItemDic[_local4.TemplateID].SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))))){
                        _local4.ReadExtraData(_arg1, _local4.TemplateID);
                    } else {
                        _local4.Add1 = _arg1.readUnsignedInt();
                        _local4.Add2 = _arg1.readUnsignedInt();
                        _local4.Add3 = _arg1.readUnsignedInt();
                    };
                    if (((((UIConstData.ItemDic[_local4.TemplateID]) && ((UIConstData.ItemDic[_local4.TemplateID].MainClass == ItemConst.ITEM_CLASS_PET)))) && ((UIConstData.ItemDic[_local4.TemplateID].SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                        _local4.ReadPetData(_arg1);
                    };
                    _local4.id = _local4.ItemGUID;
                    _local4.type = _local4.TemplateID;
                    _local8 = false;
                    if ((((_local4.Place >= ItemConst.EQUIP_SLOT_START)) && ((_local4.Place < ItemConst.EQUIP_SLOT_END)))){
                        RolePropDatas.ItemList[(_local4.Place - ItemConst.EQUIP_SLOT_START)] = _local4;
                        facade.sendNotification(RoleEvents.UPDATEOUTFIT);
                        facade.sendNotification(AutoPlayEventList.UPDATE_MAGIC_WEAPON);
                    } else {
                        if ((((_local4.Place >= ItemConst.QUEST_SLOT_START)) && ((_local4.Place < ItemConst.NORMAL_SLOT_END)))){
                            BagData.AllLocks[_local5][_local4.index] = false;
                            BagData.AllItems[_local5][_local4.index] = _local4;
                            if (_local4.TemplateID == 70200001){
                                facade.sendNotification(EquipCommandList.REFRESH_PET_REBUILD);
                            } else {
                                if (_local4.TemplateID == 70300007){
                                    facade.sendNotification(EquipCommandList.REFRESH_PET_STRENGTHEN, {sucess:false});
                                };
                            };
                            if (BagData.QuickbuyItems.indexOf(_local4.TemplateID) != -1){
                                _local8 = true;
                            };
                            if ((((_local5 == BagData.NormalId)) && (((_local3 + 1) >= _local2)))){
                                if (!(((((_local4.SubClass == ItemConst.ITEM_SUBCLASS_MEDICAL_RECOVER)) || ((_local4.SubClass == ItemConst.MEDICINE_HPBAG)))) || ((_local4.SubClass == ItemConst.MEDICINE_MPBAG)))){
                                    _local11 = ((_local4.index / BagData.MAX_GRIDS) + 1);
                                    facade.sendNotification(BagEvents.UPDATE_BAG_PAGE, {
                                        selectIndex:_local5,
                                        page:_local11
                                    });
                                };
                            };
                        } else {
                            if ((((_local4.Place >= ItemConst.BANK_SLOT_START)) && ((_local4.Place < ItemConst.BANK_SLOT_END)))){
                                _local4.index = (_local4.Place - ItemConst.BANK_SLOT_START);
                                DepotConstData.goodList[_local4.index] = _local4;
                                sendNotification(DepotEvent.ADDITEM, _local4.index);
                                facade.sendNotification(DepotEvent.UPDATEDEPOT);
                            };
                        };
                    };
                    _local3++;
                    if ((((((((_local4.Place >= ItemConst.NORMAL_SLOT_START)) && ((_local4.Place < ItemConst.BACKPACK_SLOT_END)))) && ((_local4.id > GetRewardConstData.MaxEquipGuild)))) && ((GameCommonData.Player.Role.Level < 20)))){
                        for each (_local12 in GameCommonData.StoryDisplayList) {
                            _local13 = GameCommonData.TaskInfoDic[_local12.taskID];
                            if (_local13 == null){
                                break;
                            };
                            if ((((((_local12.type == 2)) && ((_local12.count > _local13.storyCount)))) && ((_local12.taskProgress[_local13.storyCount] == 3)))){
                                for each (_local14 in _local13.ItemRewards) {
                                    if (_local14.ItemId == _local4.TemplateID){
                                        StoryDisplayConst.bagitem = _local4;
                                        sendNotification(StoryDisplayConst.BAG_ITEM, {vo:_local12});
                                        return;
                                    };
                                };
                                for each (_local14 in _local13.ItemRewardsOptionals) {
                                    if (_local14.ItemId == _local4.TemplateID){
                                        StoryDisplayConst.bagitem = _local4;
                                        sendNotification(StoryDisplayConst.BAG_ITEM, {vo:_local12});
                                        return;
                                    };
                                };
                            };
                        };
                        if (((ItemConst.IsEquip(_local4)) || (ItemConst.IsPet(_local4)))){
                            facade.sendNotification(AutoUseEquipCommand.NAME, _local4);
                        };
                    };
                    if (_local4.id > GetRewardConstData.MaxEquipGuild){
                        GetRewardConstData.MaxEquipGuild = _local4.id;
                    };
                    if ([50700020].indexOf(_local4.id) != -1){
                        facade.sendNotification(WinPartEvent.UPDATE_WINPARTBTNSVIEW);
                    };
                };
            };
            facade.sendNotification(EventList.UPDATEBAG);
            facade.sendNotification(EventList.ONSYNC_BAG_QUICKBAR);
            if (_local4){
                facade.sendNotification(EquipCommandList.UPDATE_QUICKBUY_ITEM, _local4.TemplateID);
            };
        }
        private function dealDepot(_arg1:NetPacket, _arg2:uint, _arg3:uint):void{
            var _local10:uint;
            var _local11:uint;
            var _local12:uint;
            var _local13:uint;
            var _local14:uint;
            var _local15:uint;
            var _local4:uint = _arg2;
            var _local5:Dictionary = new Dictionary();
            var _local6:uint;
            while (_local6 < 42) {
                if (DepotConstData.goodList[_local6]){
                    _local10 = DepotConstData.goodList[_local6].ItemGUID;
                    _local5[_local10] = new InventoryItemInfo();
                    ClassFactory.copyProperties(DepotConstData.goodList[_local6], _local5[_local10]);
                };
                _local6++;
            };
            DepotConstData.goodList = new Array(42);
            var _local7:uint;
            var _local8:uint;
            while (_local8 < _arg3) {
                _local11 = _arg1.readUnsignedInt();
                _local12 = _arg1.readUnsignedInt();
                _local13 = _arg1.readUnsignedInt();
                _local14 = (_local12 - ItemConst.BANK_SLOT_START);
                if (_local12 > _local7){
                    _local7 = _local12;
                };
                if (_local5[_local11]){
                    if (DepotConstData.goodList[_local14] == null){
                        DepotConstData.goodList[_local14] = new InventoryItemInfo();
                    };
                    ClassFactory.copyProperties(_local5[_local11], DepotConstData.goodList[_local14]);
                    DepotConstData.goodList[_local14].Count = _local13;
                    DepotConstData.goodList[_local14].Place = _local12;
                    DepotConstData.goodList[_local14].index = _local14;
                    DepotConstData.goodList[_local14].ItemGUID = _local11;
                };
                _local8++;
            };
            var _local9:uint = (_local7 + 1);
            if (_local9 != 0){
                _local15 = _local9;
                while (_local15 < 42) {
                    if (DepotConstData.goodList[_local15]){
                        DepotConstData.goodList[_local15].Dispose();
                    };
                    DepotConstData.goodList[_local15] = null;
                    _local15++;
                };
            };
            if (_arg2 == 4){
                UIFacade.GetInstance().sendNotification(DepotEvent.DEALDEPOT);
            };
        }
        private function processError(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            facade.sendNotification(EventList.UPDATEBAG);
        }
        private function dealBag(_arg1:NetPacket, _arg2:uint, _arg3:uint):void{
            var _local13:uint;
            var _local14:uint;
            var _local15:uint;
            var _local16:uint;
            var _local17:uint;
            var _local18:int;
            var _local19:uint;
            var _local4:uint = _arg2;
            var _local5:int;
            while (_local5 < BagData.SelectIndexList.length) {
                if (_local4 == BagData.SelectIndexList[_local5]){
                    _local4 = (_local5 + 1);
                    break;
                };
                _local5++;
            };
            var _local6:Dictionary = new Dictionary();
            var _local7:int = BagData.AllItems[(_local4 - 1)].length;
            var _local8:uint;
            while (_local8 < _local7) {
                if (BagData.AllItems[(_local4 - 1)][_local8]){
                    _local13 = BagData.AllItems[(_local4 - 1)][_local8].ItemGUID;
                    _local6[_local13] = new InventoryItemInfo();
                    ClassFactory.copyProperties(BagData.AllItems[(_local4 - 1)][_local8], _local6[_local13]);
                };
                _local8++;
            };
            var _local9:uint;
            var _local10:uint;
            while (_local10 < _arg3) {
                _local14 = _arg1.readUnsignedInt();
                _local15 = _arg1.readUnsignedInt();
                _local16 = _arg1.readUnsignedInt();
                _local17 = ItemConst.placeToOffset(_local15);
                if (_local15 > _local9){
                    _local9 = _local15;
                };
                if ((((_local4 >= 1)) && ((_local4 <= 3)))){
                    if (_local6[_local14]){
                        if (BagData.AllItems[(_local4 - 1)][_local17] == null){
                            BagData.AllItems[(_local4 - 1)][_local17] = new InventoryItemInfo();
                        };
                        ClassFactory.copyProperties(_local6[_local14], BagData.AllItems[(_local4 - 1)][_local17]);
                        BagData.AllItems[(_local4 - 1)][_local17].Count = _local16;
                        BagData.AllItems[(_local4 - 1)][_local17].Place = _local15;
                        BagData.AllItems[(_local4 - 1)][_local17].index = _local17;
                        BagData.AllItems[(_local4 - 1)][_local17].ItemGUID = _local14;
                        BagData.AllLocks[(_local4 - 1)][_local17] = false;
                    };
                };
                _local10++;
            };
            var _local11:uint = ItemConst.placeToOffset((_local9 + 1));
            if (_local11 != 0){
                _local18 = (BagData.MAX_PAGE * BagData.MAX_GRIDS);
                _local19 = _local11;
                while (_local19 < _local18) {
                    BagData.AllLocks[(_local4 - 1)][_local19] = false;
                    if (BagData.AllItems[(_local4 - 1)][_local19]){
                        BagData.AllItems[(_local4 - 1)][_local19].Dispose();
                    };
                    BagData.AllItems[(_local4 - 1)][_local19] = null;
                    _local19++;
                };
            };
            var _local12:Array = BagData.AllItems;
            if (_arg2 != 4){
                UIFacade.GetInstance().sendNotification(EventList.UPDATEBAG);
                facade.sendNotification(EventList.CHANGE_QUICKBAR_UI);
            };
        }
        private function updateBag(_arg1:NetPacket):void{
            var _local2:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local11:uint;
            _local2 = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint;
            if (_local2 == 0){
                _local5 = 0;
                for (;_local5 < _local3;_local5++) {
                    _local6 = _arg1.readUnsignedInt();
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readUnsignedInt();
                    if ((((_local7 >= ItemConst.QUEST_SLOT_START)) && ((_local7 < ItemConst.NORMAL_SLOT_END)))){
                        _local9 = ItemConst.placeToOffset(_local7);
                        _local10 = ItemConst.placeToPanel(_local7);
                        if (_local8 == 0){
                            BagData.AllLocks[_local10][_local9] = false;
                            if (BagData.AllItems[_local10][_local9]){
                                BagData.AllItems[_local10][_local9].Dispose();
                            };
                            BagData.AllItems[_local10][_local9] = null;
                            continue;
                        };
                        BagData.AllLocks[_local10][_local9] = false;
                        BagData.AllItems[_local10][_local9].Count = _local8;
                    } else {
                        if ((((_local7 >= ItemConst.BANK_SLOT_START)) && ((_local7 < ItemConst.BANK_SLOT_END)))){
                            _local11 = (_local7 - ItemConst.BANK_SLOT_START);
                            if (_local8 == 0){
                                DepotConstData.goodList[_local11] = null;
                            } else {
                                DepotConstData.goodList[_local11].Count = _local8;
                                facade.sendNotification(DepotEvent.UPDATEDEPOT);
                            };
                        };
                    };
                };
                UIFacade.GetInstance().sendNotification(EventList.UPDATEBAG);
                facade.sendNotification(EventList.ONSYNC_BAG_QUICKBAR);
                return;
            };
            if (_local2 == 4){
                dealDepot(_arg1, _local2, _local3);
            } else {
                dealBag(_arg1, _local2, _local3);
            };
        }

    }
}//package Net.PackHandler 
