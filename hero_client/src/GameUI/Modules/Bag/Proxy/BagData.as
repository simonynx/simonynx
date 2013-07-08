//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Proxy {
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.PetRace.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Bag.*;

    public class BagData {

        public static const MAX_GRIDS:int = 42;
        public static const MAX_PAGE:int = 2;
        public static const HASFACE_GRID:int = 2;
        public static const GRID_ROWS:int = 6;
        public static const GRID_COLS:int = 7;

        public static var PropItemLock:Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
        public static var NormalItemLock:Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
        public static var gotoClickExtendBtn:Boolean = true;
        public static var BagNum:Array = [21, 42, 42];
        public static var NormalId:int = 0;
        public static var TaskUseItemList:Array = new Array(42);
        public static var SelectIndex:int = 0;
        public static var AdditionProperty:Array = ["", "攻击", "防御", "普攻命中", "普攻躲闪", "暴击伤害", "暴击率", "技能命中", "技能躲闪", "生命", "魔法", "眩晕抗性", "虚弱抗性", "昏睡抗性", "魅惑抗性", "定身抗性", "暴击率减免", "暴击伤害减免", "伤害减免"];
        public static var hasGetItemProto:Boolean = false;
        public static var TmpIndex:int = 0;
        public static var TaskItemList:Array = new Array(42);
        public static var TaskItemLock:Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
        public static var AllLocks:Array = [NormalItemLock, PropItemLock, TaskItemLock];
        public static var SplitIsOpen:Boolean = false;
        public static var currentPage:int = 1;
        public static var TipShowItemDic:Dictionary = new Dictionary();
        public static var AllUseItemList:Array = [NormalUseItemList, PropUseItemList, TaskUseItemList];
        public static var IsLoadBagGoodList:Boolean = false;
        public static var QuickbuyItems:Array = [10100004, 10100005, 10100030, 10100031, 10100032, 50700003];
        public static var EXTEND_NUM:uint = 21;
        public static var GridUnitList:Array = [new Array(), new Array(), new Array()];
        public static var bagView = null;
        public static var SelectIndexList:Array = [3, 2, 1];
        public static var AllItems:Array = [NormalItemList, PropItemList, TaskItemList];
        public static var extendGridTipPos:Array = [34, 74, 114, 154, 194, 224];
        public static var currTmpIndex:int = -1;
        public static var itemDrag:uint;
        public static var SelectedItem:GridUnit = null;
        public static var NormalUseItemList:Array = new Array(84);
        public static var PropItemList:Array = new Array(42);
        public static var PropUseItemList:Array = new Array(42);
        public static var NormalItemList:Array = new Array(84);

        public static function comfirmDrop():void{
            var _local1:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            if ((((_local1.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_local1.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                if (PetRaceConstData.findPetInFormationById(_local1.ItemGUID)){
                    MessageTip.popup(LanguageMgr.GetTranslation("forbiddel2"));
                    return;
                };
            };
            BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
            BagInfoSend.ItemThrow(_local1.ItemGUID);
        }
        public static function LockItemByGuid(_arg1:uint):void{
            var _local2:int;
            var _local3:int;
            while (_local2 < BagData.AllItems.length) {
                if (_local2 == BagData.SelectIndex){
                    _local3 = 0;
                    while (_local3 < BagData.GridUnitList[_local2].length) {
                        if (BagData.GridUnitList[_local2][_local3].Item){
                            if (_arg1 == BagData.GridUnitList[_local2][_local3].Item.Id){
                                BagData.GridUnitList[_local2][_local3].Item.IsLock = true;
                            };
                        };
                        _local3++;
                    };
                };
                _local3 = 0;
                while (_local3 < BagData.AllItems[_local2].length) {
                    if (BagData.AllItems[_local2][_local3] == null){
                        BagData.AllLocks[_local2][_local3] = false;
                    } else {
                        if (_arg1 == BagData.AllItems[_local2][_local3].ItemGUID){
                            BagData.AllLocks[_local2][_local3] = true;
                        };
                    };
                    _local3++;
                };
                _local2++;
            };
        }
        public static function LockItem(_arg1:int, _arg2:int):void{
            if (((!((_arg1 == -1))) && (!((_arg2 == -1))))){
                BagData.AllLocks[_arg1][_arg2] = true;
            };
        }
        public static function getItemById(_arg1:uint):InventoryItemInfo{
            var _local2:int;
            var _local3:int;
            var _local4:InventoryItemInfo;
            if (_arg1 == 0){
                _local4 = null;
            } else {
                _local2 = 0;
                while (_local2 < BagData.AllItems.length) {
                    _local3 = 0;
                    while (_local3 < BagData.AllItems[_local2].length) {
                        if (BagData.AllItems[_local2][_local3] == null){
                        } else {
                            if (_arg1 == BagData.AllItems[_local2][_local3].ItemGUID){
                                _local4 = BagData.AllItems[_local2][_local3];
                                break;
                            };
                        };
                        _local3++;
                    };
                    if (_local4){
                        break;
                    };
                    _local2++;
                };
            };
            return (_local4);
        }
        public static function findEmptyPos(_arg1:uint):int{
            var _local2:uint;
            if ((((_arg1 < 0)) && ((_arg1 > 2)))){
                return (-1);
            };
            _local2 = 0;
            while (_local2 < BagData.BagNum[_arg1]) {
                if (!BagData.AllItems[_arg1][_local2]){
                    return (_local2);
                };
                _local2++;
            };
            return (-1);
        }
        public static function isHasItemById(_arg1:uint):Boolean{
            var _local2:int;
            var _local3:int;
            var _local4:Boolean;
            if (_arg1 == 0){
                _local4 = false;
            } else {
                _local2 = 0;
                while (_local2 < BagData.AllItems.length) {
                    _local3 = 0;
                    while (_local3 < BagData.AllItems[_local2].length) {
                        if (BagData.AllItems[_local2][_local3] == undefined){
                        } else {
                            if (_arg1 == BagData.AllItems[_local2][_local3].ItemGUID){
                                _local4 = true;
                                break;
                            };
                        };
                        _local3++;
                    };
                    if (_local4){
                        break;
                    };
                    _local2++;
                };
            };
            return (_local4);
        }
        public static function petCanDeal(_arg1:InventoryItemInfo):Boolean{
            if ((((_arg1.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                if (PetRaceConstData.findPetInFormationById(_arg1.ItemGUID)){
                    return (false);
                };
            };
            return (true);
        }
        public static function isHasItem(_arg1:uint):Boolean{
            var _local2:int;
            var _local3:int;
            var _local4:Boolean;
            if (_arg1 == 0){
                _local4 = false;
            } else {
                _local2 = 0;
                while (_local2 < BagData.AllItems.length) {
                    _local3 = 0;
                    while (_local3 < BagData.AllItems[_local2].length) {
                        if (BagData.AllItems[_local2][_local3] == undefined){
                        } else {
                            if (_arg1 == BagData.AllItems[_local2][_local3].TemplateID){
                                _local4 = true;
                                break;
                            };
                        };
                        _local3++;
                    };
                    if (_local4){
                        break;
                    };
                    _local2++;
                };
            };
            return (_local4);
        }
        public static function comfirmRepair():void{
            var _local1:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            BagInfoSend.ItemRepair(_local1.ItemGUID);
        }
        public static function getItemByType(_arg1:int):InventoryItemInfo{
            var _local2:int;
            var _local3:int;
            var _local4:InventoryItemInfo;
            if (_arg1 == 0){
                _local4 = null;
            } else {
                _local2 = 0;
                while (_local2 < BagData.AllItems.length) {
                    _local3 = 0;
                    while (_local3 < BagData.AllItems[_local2].length) {
                        if (BagData.AllItems[_local2][_local3] == undefined){
                        } else {
                            if (_arg1 == BagData.AllItems[_local2][_local3].TemplateID){
                                _local4 = BagData.AllItems[_local2][_local3];
                                break;
                            };
                        };
                        _local3++;
                    };
                    if (_local4){
                        break;
                    };
                    _local2++;
                };
            };
            return (_local4);
        }
        public static function GetUseItemFromBag(_arg1:InventoryItemInfo):UseItem{
            var _local2:UseItem;
            var _local3:String;
            _arg1 = getItemById(_arg1.ItemGUID);
            if (_arg1){
                _local2 = new UseItem(_arg1.index, _arg1.type, new MovieClip(), _arg1.ItemGUID);
                _local2.Num = _arg1.Count;
                _local2.clearThumbLock();
                _local2.itemIemplateInfo = (UIConstData.ItemDic[_arg1.TemplateID] as ItemTemplateInfo);
                if (_local2.iconName != _arg1.img.toString()){
                    _local2.resetIcon(_arg1.img.toString());
                };
                if ((((((_local2.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_local2.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))) && ((_local2.itemIemplateInfo.HpBonus > 4)))){
                    _local3 = String((_arg1.img + (_arg1.Add1 * 10)));
                    _local2.resetIcon(_local3);
                };
                if (((((_arg1 as InventoryItemInfo).Flags & ItemConst.FlAGS_TRADE)) || ((_arg1 as InventoryItemInfo).isBind))){
                    _local2.setThumbLock();
                };
                _local2.setBroken((_arg1 as InventoryItemInfo).isBroken);
                _local2.Id = _arg1.ItemGUID;
                _local2.IsBind = _arg1.isBind;
                _local2.Type = _arg1.type;
            };
            return (_local2);
        }
        public static function isBagFullByItemId(_arg1:int, _arg2:int=1):Boolean{
            var _local6:InventoryItemInfo;
            var _local3:ItemTemplateInfo = UIConstData.ItemDic[_arg1];
            var _local4:int = ((_local3.MainClass)==ItemConst.ITEM_CLASS_MATERIAL) ? 2 : 0;
            var _local5:Boolean = ((_local3.MaxCount)==1) ? false : true;
            if (getPanelEmptyNum(_local4) == 0){
                if (_local5){
                    for each (_local6 in BagData.AllItems[_local4]) {
                        if (_local6){
                            if ((((_local6.type == _arg1)) && ((_local6.isBind == 0)))){
                                if ((_local6.MaxCount - _local6.Count) >= _arg2){
                                    return (false);
                                };
                            };
                        };
                    };
                    return (true);
                };
                return (true);
            };
            return (false);
        }
        public static function findTingByType(_arg1:int, _arg2:int, _arg3:String, _arg4:int, _arg5:int=0):InventoryItemInfo{
			return (null);//geoffyan
            var _local6:int;
            var _local7:int = BagData.AllItems[_arg5].length;
            while (_local6 < _local7) {
                if (BagData.AllItems[_arg5][_local6]){
                    if (BagData.AllItems[_arg5][_local6].MainClass == _arg1){
                        if (BagData.AllItems[_arg5][_local6].SubClass == _arg2){
                            if (BagData.AllItems[_arg5][_local6][_arg3] > 0){
                                if (_arg4 >= BagData.AllItems[_arg5][_local6]["RequiredLevel"]){
                                    return (BagData.AllItems[_arg5][_local6]);
                                };
                            };
                        };
                    };
                };
                _local6++;
            };
            return (null);
        }
        public static function getCountsByTemplateId(_arg1:uint, _arg2:Boolean=true, _arg3:int=-1):uint{
			return 0;//geoffyan
            var _local4:uint;
            if (_arg1 == 0){
                return (0);
            };
            var _local5:Array = [];
            if (_arg3 == -1){
                _local5 = BagData.AllItems.concat();
            } else {
                if ((((((_arg3 == 0)) || ((_arg3 == 1)))) || ((_arg3 == 2)))){
                    _local5[0] = BagData.AllItems[_arg3].concat();
                };
            };
            var _local6:uint;
            var _local7:uint;
            var _local8:Boolean;
            while (_local6 < _local5.length) {
                _local7 = 0;
                while (_local7 < _local5[_local6].length) {
                    if (((_local5[_local6][_local7]) && ((_arg1 == _local5[_local6][_local7].TemplateID)))){
                        if (((!(_arg2)) || ((_local5[_local6][_local7].isBind == false)))){
                            _local4 = (_local4 + _local5[_local6][_local7].Count);
                        };
                        _local8 = true;
                    };
                    _local7++;
                };
                if (_local8){
                    break;
                };
                _local6++;
            };
            return (_local4);
        }
        public static function clearLocks():void{
			return ;//geoffyan
            var _local1:int;
            while (_local1 < BagData.GridUnitList[BagData.SelectIndex].length) {
                if (BagData.GridUnitList[BagData.SelectIndex][_local1].Item){
                    BagData.GridUnitList[BagData.SelectIndex][_local1].Item.IsLock = false;
                };
                _local1++;
            };
            var _local2:uint;
            while (_local2 < BagData.AllItems.length) {
                _local1 = 0;
                while (_local1 < BagData.AllItems[_local2].length) {
                    if (BagData.AllItems[_local2][_local1]){
                        BagData.AllLocks[_local2][_local1] = false;
                    };
                    _local1++;
                };
                _local2++;
            };
        }
        public static function lockBagGridUnit(_arg1:Boolean):void{
            var _local2:int;
            while (_local2 < BagData.GridUnitList[BagData.SelectIndex].length) {
                BagData.GridUnitList[0][_local2].Grid.mouseEnabled = _arg1;
                _local2++;
            };
        }
        public static function hasItemNum(_arg1:uint):int{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            if (_arg1 == 0){
                _local2 = 0;
            } else {
                _local3 = 0;
                while (_local3 < BagData.AllItems.length) {
                    _local4 = 0;
                    while (_local4 < BagData.AllItems[_local3].length) {
                        if (BagData.AllItems[_local3][_local4] == null){
                        } else {
                            if (_arg1 == BagData.AllItems[_local3][_local4].type){
                                _local2 = (_local2 + BagData.AllItems[_local3][_local4].Count);
                            };
                        };
                        _local4++;
                    };
                    _local3++;
                };
            };
            return (_local2);
        }
        public static function lockBtnCleanAndPage(_arg1:Boolean):void{
            if (bagView){
                bagView.btnStall.enable = _arg1;
                bagView.btnDeal.enable = _arg1;
                bagView.btnSplit.enable = _arg1;
                bagView.btnDrop.enable = _arg1;
            };
        }
        public static function getPanelEmptyNum(_arg1:uint, _arg2:int=2147483647):int{
			return (-1);//geoffyan
            var _local4:uint;
            var _local5:uint;
            if ((((_arg1 < 0)) && ((_arg1 > 2)))){
                return (-1);
            };
            var _local3:uint;
            if (_arg2 == int.MAX_VALUE){
                _local4 = 0;
                _local5 = BagData.BagNum[_arg1];
            } else {
                _local4 = ((_arg2 - 1) * MAX_GRIDS);
                _local5 = (_arg2 * MAX_GRIDS);
            };
            _local4 = 0;
            while (_local4 < _local5) {
                if (!BagData.AllItems[_arg1][_local4]){
                    _local3++;
                };
                _local4++;
            };
            return (_local3);
        }

    }
}//package GameUI.Modules.Bag.Proxy 
