//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Proxy {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.Stall.Data.*;
    import GameUI.Modules.Bag.Command.*;
    import GameUI.Modules.Depot.Data.*;
    import GameUI.Modules.NPCShop.Data.*;
    import GameUI.Modules.Bag.*;
    import GameUI.Modules.Bag.Mediator.DealItem.*;
    import GameUI.*;

    public class GridManager extends Proxy {

        public static const NAME:String = "GridManager";

        private var dataProxy:DataProxy = null;
        private var lastSelectObject:DisplayObject;

        public function GridManager(){
            super(NAME);
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            SetFrame.RemoveFrame(_arg1.currentTarget.parent, "RedFrame");
        }
        public function returnItem(_arg1:ItemBase):void{
            if (int(((_arg1.Pos / BagData.MAX_GRIDS) + 1)) != BagData.currentPage){
                return;
            };
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            BagData.SelectedItem = BagData.GridUnitList[BagData.SelectIndex][(_arg1.Pos % BagData.MAX_GRIDS)];
        }
        public function dragDroppedHandler(_arg1:DropEvent):void{
            var _local2:uint;
            var _local3:int;
            var _local5:int;
            var _local6:InventoryItemInfo;
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            var _local4:Object = UIConstData.ItemDic[_arg1.Data.source.Type];
            switch (_arg1.Data.type){
                case "bag":
                    if (BagData.GridUnitList[BagData.SelectIndex][(_arg1.Data.index % BagData.MAX_GRIDS)].HasBag == false){
                        returnItem(_arg1.Data.source);
                        return;
                    };
                    if ((_arg1.Data.target is SimpleButton)){
                        break;
                    };
                    _local5 = _arg1.Data.index;
                    BagData.itemDrag = (_arg1.Data.source as UseItem).dragFlag;
                    DroppedIsBag(_local5, _arg1.Data.target, _arg1.Data.source);
                    break;
                case "key":
                case "keyf":
                case "quickf":
                case "quick":
                    returnItem(_arg1.Data.source);
                    facade.sendNotification(EventList.DROPINQUICK, {
                        target:_arg1.Data.target,
                        source:_arg1.Data.source,
                        index:_arg1.Data.index,
                        type:_arg1.Data.type
                    });
                    break;
                case "autoPlayHp":
                case "autoPlayMp":
                    facade.sendNotification(AutoPlayEventList.ADD_ITEM_AUTOPLAYUI, {
                        target:_arg1.Data.target,
                        source:_arg1.Data.source,
                        type:_arg1.Data.type
                    });
                    break;
                case "mcPhoto":
                    if (_arg1.Data.source.IsCdTimer){
                        return;
                    };
                    if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].isBind == 1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidtrade2"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if ((BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].Flags & ItemConst.FlAGS_TRADE)){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidtrade1"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _local6 = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
                    if (BagData.petCanDeal(_local6) == false){
                        MessageTip.popup(LanguageMgr.GetTranslation("forbidtrade3"));
                        return;
                    };
                    if (UIConstData.useItemTimer.running){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("wait"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _arg1.Data.source.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(EventList.GOTRADEVIEW, {
                        srcPlace:ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex),
                        dstPlace:_arg1.Data.index
                    });
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "stall":
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("stalllimit1"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].isBind == 1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("stalllimit2"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if ((BagData.SelectedItem.Item.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("stalllimit3"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _local6 = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
                    if (BagData.petCanDeal(_local6) == false){
                        MessageTip.popup(LanguageMgr.GetTranslation("stalllimit4"));
                        return;
                    };
                    if (StallConstData.stallOwnerName != GameCommonData.Player.Role.Name){
                        return;
                    };
                    if (UIConstData.useItemTimer.running){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("wait"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _arg1.Data.source.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(EventList.BAGTOSTALL, {
                        ItemGUID:_arg1.Data.source.Id,
                        srcPlace:ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex),
                        dstIndex:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "stalldown":
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("stalllimit1"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (StallConstData.stallOwnerName != GameCommonData.Player.Role.Name){
                        return;
                    };
                    if ((BagData.SelectedItem.Item.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("stalllimit3"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (((ItemConst.IsEquip(BagData.SelectedItem.Item.itemIemplateInfo)) || (((ItemConst.IsPet(BagData.SelectedItem.Item.itemIemplateInfo)) && ((BagData.SelectedItem.Item.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("stalllimit5"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (UIConstData.useItemTimer.running){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("wait"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _arg1.Data.source.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(EventList.BAGTODOWNSTALL, {
                        ItemGUID:_arg1.Data.source.Id,
                        srcPlace:ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex),
                        dstIndex:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "hero":
                    if (_arg1.Data.source.IsCdTimer){
                        return;
                    };
                    if (UIConstData.useItemTimer.running){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("wait"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (this.isEnableUseTheEquip(_arg1.Data.source)){
                        SetFrame.RemoveFrame(_arg1.Data.source.ItemParent, "RedFrame");
                        _arg1.Data.source.IsLock = true;
                        facade.sendNotification(EventList.GOHEROVIEW, _arg1.Data);
                    };
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "depot":
                    if (_arg1.Data.source.IsCdTimer){
                        return;
                    };
                    if (DepotConstData.GridUnitList[_arg1.Data.index].HasBag == false){
                        return;
                    };
                    if (UIConstData.useItemTimer.running){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("wait"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _local6 = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
                    if (BagData.petCanDeal(_local6) == false){
                        MessageTip.popup(LanguageMgr.GetTranslation("forbidtodepot"));
                        return;
                    };
                    _arg1.Data.source.IsLock = true;
                    BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex), (ItemConst.BANK_SLOT_START + _arg1.Data.index));
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "NPCShopSale":
                    if ((_arg1.Data.source.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidsale"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _local6 = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
                    if (BagData.petCanDeal(_local6) == false){
                        MessageTip.popup(LanguageMgr.GetTranslation("forbidsale2"));
                        return;
                    };
                    if (UIConstData.useItemTimer.running){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("wait"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _arg1.Data.source.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(NPCShopEvent.BAGTONPCSHOP, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]);
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "donateprop":
                    _arg1.Data.source.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(UnityEvent.BAGTOGUILDDONATE, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]);
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                case "Entrust":
                    if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].isBind == 1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidtrade2"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if ((BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].Flags & ItemConst.FlAGS_TRADE)){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidtrade1"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    _local6 = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
                    if (BagData.petCanDeal(_local6) == false){
                        MessageTip.popup(LanguageMgr.GetTranslation("forbidtrade3"));
                        return;
                    };
                    _arg1.Data.source.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(EventList.BAGTOENTRUST, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]);
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        public function comfrimDrop():void{
            BagData.comfirmDrop();
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            var _local2:DisplayObject;
            var _local3:int;
            var _local4:int;
            var _local5:String;
            var _local6:int;
            var _local7:uint;
            var _local8:Object;
            var _local11:*;
            var _local12:uint;
            var _local13:uint;
            var _local14:String;
            var _local15:String;
            if (dataProxy.BagIsDrag){
                return;
            };
            var _local9:int = int(_arg1.target.name.split("_")[1]);
            var _local10:int = _local9;
            _local9 = (_local9 % BagData.MAX_GRIDS);
            if (BagData.AllLocks[BagData.SelectIndex][_local10]){
                if (dataProxy.BagIsSplit){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("forbidsplit2"),
                        color:0xFFFF00
                    });
                    dataProxy.BagIsSplit = false;
                };
                if (dataProxy.BagIsDestory){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("forbidsplit1"),
                        color:0xFFFF00
                    });
                    dataProxy.BagIsDestory = false;
                };
                return;
            };
            if (BagData.GridUnitList[BagData.SelectIndex][_local9].Item){
                if (_arg1.ctrlKey){
                    if (UIConstData.ItemDic[BagData.GridUnitList[BagData.SelectIndex][_local9].Item.Type] == undefined){
                        return;
                    };
                    _local3 = BagData.GridUnitList[BagData.SelectIndex][_local9].Item.Id;
                    _local4 = BagData.GridUnitList[BagData.SelectIndex][_local9].Item.Type;
                    _local5 = UIConstData.ItemDic[BagData.GridUnitList[BagData.SelectIndex][_local9].Item.Type].Name;
                    _local6 = BagData.AllItems[BagData.SelectIndex][_local10].isBind;
                    if ((((_local6 == 0)) && ((BagData.AllItems[BagData.SelectIndex][_local10].Binding == 2)))){
                        _local6 = 2;
                    };
                    _local7 = 0;
                    _local8 = BagData.getItemById(_local3);
                    if (_local8){
                        _local7 = _local8.Color;
                    };
                    _local12 = BagData.AllItems[BagData.SelectIndex][_local10].MainClass;
                    _local13 = BagData.AllItems[BagData.SelectIndex][_local10].SubClass;
                    if ((((_local12 == ItemConst.ITEM_CLASS_EQUIP)) || ((((_local12 == ItemConst.ITEM_CLASS_PET)) && ((_local13 == ItemConst.ITEM_SUBCLASS_PET_SELF)))))){
                        _local14 = "";
                        _local14 = BagData.AllItems[BagData.SelectIndex][_local10].WriteConcatString();
                        _local15 = (((((((((((((("<1_[" + _local5) + "]_") + _local3) + "_") + _local4) + "_") + GameCommonData.Player.Role.Id) + "_") + _local6) + "_") + _local7) + "_") + _local14) + ">");
                        facade.sendNotification(ChatEvents.ADDITEMINCHAT, _local15);
                    } else {
                        _local15 = (((((((((((("<1_[" + _local5) + "]_") + _local3) + "_") + _local4) + "_") + GameCommonData.Player.Role.Id) + "_") + _local6) + "_") + _local7) + ">");
                        facade.sendNotification(ChatEvents.ADDITEMINCHAT, _local15);
                    };
                    return;
                };
                if (BagData.GridUnitList[BagData.SelectIndex][_local9].Item.IsLock){
                    BagData.SelectedItem = BagData.GridUnitList[BagData.SelectIndex][_local9];
                    return;
                };
                BagData.SelectedItem = BagData.GridUnitList[BagData.SelectIndex][_local9];
                _local2 = (_arg1.target as DisplayObject);
                if ((((_local2.mouseX <= 2)) || ((_local2.mouseX >= (_local2.width - 2))))){
                    return;
                };
                if ((((_local2.mouseY <= 2)) || ((_local2.mouseY >= (_local2.height - 2))))){
                    return;
                };
                BagData.GridUnitList[BagData.SelectIndex][_local9].Item.addEventListener(DropEvent.DRAG_THREW, dragThrewHandler);
                BagData.GridUnitList[BagData.SelectIndex][_local9].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
                BagData.GridUnitList[BagData.SelectIndex][_local9].Item.onMouseDown();
                BagData.TmpIndex = _local10;
                _local11 = BagData.TmpIndex;
                BagData.itemDrag = BagData.GridUnitList[BagData.SelectIndex][_local9].Item.dragFlag;
                return;
            };
            if (dataProxy.BagIsSplit){
                dataProxy.BagIsSplit = false;
            };
            if (dataProxy.BagIsDestory){
                dataProxy.BagIsDestory = false;
            };
            BagData.SelectedItem = null;
        }
        public function cancelDrop():void{
        }
        private function calRepairCost():uint{
            var _local1:Object = UIConstData.ItemDic[BagData.SelectedItem.Item.Type];
            var _local2:InventoryItemInfo = BagData.getItemById(BagData.SelectedItem.Item.Id);
            var _local3:uint = _local2.Strengthen;
            if ((((((((_local2.SubClass == 5)) || ((_local2.SubClass == 6)))) || ((_local2.SubClass == 10)))) || ((_local2.SubClass == 11)))){
                _local3 = (_local2.Strengthen / 2);
            };
            var _local4:uint = (_local1 as ItemTemplateInfo).RequiredLevel;
            var _local5:uint = (_local2.Color + 1);
            var _local6:uint = 1;
            var _local7:uint = 1;
            while (_local7 <= _local5) {
                _local6 = (_local6 * (_local3 + 1));
                _local7++;
            };
            var _local8:uint = (((2 * _local6) * _local4) / 100);
            if (_local8 == 0){
                _local8 = 1;
            };
            var _local9:int = (Math.ceil((_local8 / 500)) * 50);
            return (_local9);
        }
        public function comfirmRepair():void{
            var _local1:uint = GameCommonData.Player.Role.Gift;
            var _local2:uint = GameCommonData.Player.Role.Money;
            var _local3:uint = calRepairCost();
            var _local4:Boolean;
            if ((((((_local1 >= _local3)) || ((_local2 >= _local3)))) || (((_local1 + _local2) >= _local3)))){
                _local4 = true;
            };
            if (!_local4){
                MessageTip.popup(LanguageMgr.GetTranslation("修理费不足句"));
                return;
            };
            BagData.comfirmRepair();
        }
        private function dragThrewHandler(_arg1:DropEvent):void{
            var _local2:uint;
            _arg1.target.removeEventListener(DropEvent.DRAG_THREW, dragThrewHandler);
            var _local3:BagMediator = (facade.retrieveMediator(BagMediator.NAME) as BagMediator);
            BagData.itemDrag = (_arg1.Data as UseItem).dragFlag;
            if (((!(BagData.SelectedItem)) || (!(BagData.SelectedItem.Item)))){
                return;
            };
            if ((BagData.SelectedItem.Item.itemIemplateInfo.Flags & ItemConst.FlAGS_GIVEUP)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("forbiddel1"),
                    color:0xFFFF00
                });
                return;
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:_local3.comfrim,
                cancel:_local3.cancel,
                info:LanguageMgr.GetTranslation("delconfirm")
            });
        }
        public function Initialize():void{
            var _local1:GridUnit;
            var _local2:int;
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            while (_local2 < BagData.GridUnitList[0].length) {
                _local1 = (BagData.GridUnitList[0][_local2] as GridUnit);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (BagData.SelectedItem){
                if (_arg1.currentTarget.name.split("_")[1] == BagData.SelectedItem.Index){
                    return;
                };
            };
            if (lastSelectObject){
                SetFrame.RemoveFrame(lastSelectObject.parent, "RedFrame");
            };
            SetFrame.UseFrame((_arg1.currentTarget as DisplayObject), "RedFrame");
            lastSelectObject = (_arg1.currentTarget as DisplayObject);
        }
        private function isEnableUseTheEquip(_arg1:UseItem):Boolean{
            var _local2:Object = UIConstData.ItemDic[_arg1.Type];
            if (((!((_local2.Job == 0))) && (!((GameCommonData.Player.Role.CurrentJobID == _local2.Job))))){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("joblimit"),
                    color:0xFFFF00
                });
                return (false);
            };
            return (true);
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            var _local3:*;
            if (!BagData.SelectedItem){
                return;
            };
            if (!BagData.SelectedItem.Item){
                return;
            };
            var _local2:GridUnit = BagData.SelectedItem;
            BagData.SelectedItem.Item.gc();
            if (BagData.SelectedItem.Item.IsLock == true){
                return;
            };
            if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index] == undefined){
                sendNotification(EventList.UPDATEBAG);
                return;
            };
            if ((_local2.Item as UseItem).itemIemplateInfo.TemplateID == 10500002){
                _local3 = DepotConstData.gridCount;
                if (DepotConstData.gridCount >= 42){
                    MessageTip.popup(LanguageMgr.GetTranslation("仓库已完全扩充"));
                    return;
                };
            };
            facade.sendNotification(UseItemCommand.NAME);
        }
        public function Gc():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < BagData.GridUnitList[0].length) {
                _local1 = (BagData.GridUnitList[0][_local2] as GridUnit);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                if (_local1.Item){
                    SetFrame.RemoveFrame(_local1.Item.parent, "RedFrame");
                };
                _local2++;
            };
        }
        private function DroppedIsBag(_arg1:int, _arg2:MovieClip, _arg3:UseItem):void{
            var _local4:Object;
            var _local5:int;
            var _local6:InventoryItemInfo;
            var _local7:uint;
            var _local8:uint;
            var _local9:uint;
            if (BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].IsUsed){
                if (BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].Item.IsLock == true){
                    BagData.SelectedItem = null;
                    return;
                };
            };
            if (dataProxy.BagIsSplit){
                dataProxy.BagIsSplit = false;
                if (BagData.SplitIsOpen){
                    return;
                };
                if (BagData.SelectedItem){
                    if (BagData.SelectedItem.Item.IsLock){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidsplit2"),
                            color:0xFFFF00
                        });
                        if (BagData.SelectedItem.Item){
                            BagData.SelectedItem.Item.gc();
                        };
                        return;
                    };
                    if (BagData.SelectedItem.Item.Num == 1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidsplit1"),
                            color:0xFFFF00
                        });
                        if (BagData.SelectedItem.Item){
                            BagData.SelectedItem.Item.gc();
                        };
                        return;
                    };
                    if (BagUtils.TestBagIsFull(BagData.SelectIndex) == BagData.BagNum[BagData.SelectIndex]){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("forbidsplit3"),
                            color:0xFFFF00
                        });
                        if (BagData.SelectedItem.Item){
                            BagData.SelectedItem.Item.gc();
                        };
                        return;
                    };
                    facade.sendNotification(SplitCommand.NAME);
                };
                return;
            };
            if (dataProxy.BagIsDestory){
                dataProxy.BagIsDestory = false;
                if (BagData.SelectedItem){
                    _local4 = UIConstData.ItemDic[BagData.SelectedItem.Item.Type];
                    if ((_local4 as ItemTemplateInfo).MainClass == ItemConst.ITEM_CLASS_EQUIP){
                        _local6 = BagData.getItemById(BagData.SelectedItem.Item.Id);
                        if (((_local6) && (_local6.isBroken))){
                            _local7 = calRepairCost();
                            _local8 = GameCommonData.Player.Role.Gift;
                            _local9 = GameCommonData.Player.Role.Money;
                            if (_local8 >= _local7){
                                facade.sendNotification(EventList.SHOWALERT, {
                                    comfrim:comfirmRepair,
                                    cancel:cancelDrop,
                                    info:LanguageMgr.GetTranslation("修理花费x礼券句", _local7)
                                });
                            } else {
                                if (_local8 > 0){
                                    facade.sendNotification(EventList.SHOWALERT, {
                                        comfrim:comfirmRepair,
                                        cancel:cancelDrop,
                                        info:LanguageMgr.GetTranslation("修理花费x礼券y金叶子句", _local8, (_local7 - _local8))
                                    });
                                } else {
                                    facade.sendNotification(EventList.SHOWALERT, {
                                        comfrim:comfirmRepair,
                                        cancel:cancelDrop,
                                        info:LanguageMgr.GetTranslation("修理花费x金叶子句", _local7)
                                    });
                                };
                            };
                        };
                    };
                };
            };
            if (dataProxy.BagIsDrag){
                dataProxy.BagIsDrag = false;
            };
            if (BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].IsUsed){
                if (BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].Item.IsLock == true){
                    BagData.SelectedItem = null;
                    return;
                };
                if (((BagData.GridUnitList[BagData.SelectIndex][(_arg1 % BagData.MAX_GRIDS)].Item.IsCdTimer) || (_arg3.IsCdTimer))){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("forbidmove"),
                        color:0xFFFF00
                    });
                    return;
                };
                if (UIConstData.useItemTimer.running){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("wait"),
                        color:0xFFFF00
                    });
                    return;
                };
                if (_arg1 == _arg3.Pos){
                    return;
                };
                if (_arg1 == BagData.TmpIndex){
                    return;
                };
                BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex), ItemConst.gridUnitToPlace(BagData.SelectIndex, _arg1));
                UIConstData.useItemTimer.reset();
                UIConstData.useItemTimer.start();
                BagData.SelectedItem = BagData.GridUnitList[BagData.SelectIndex][_arg1];
            } else {
                if (UIConstData.useItemTimer.running){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("wait"),
                        color:0xFFFF00
                    });
                    return;
                };
                BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex), ItemConst.gridUnitToPlace(BagData.SelectIndex, _arg1));
                UIConstData.useItemTimer.reset();
                UIConstData.useItemTimer.start();
                BagData.SelectedItem = BagData.GridUnitList[BagData.SelectIndex][_arg1];
            };
        }

    }
}//package GameUI.Modules.Bag.Proxy 
