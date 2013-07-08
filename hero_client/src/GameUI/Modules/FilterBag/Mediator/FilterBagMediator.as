//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.FilterBag.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Bag.Datas.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.FilterBag.Proxy.*;
    import GameUI.Modules.FilterBag.Command.*;
    import GameUI.Modules.FilterBag.Datas.*;
    import GameUI.*;

    public class FilterBagMediator extends Mediator {

        public static const STARTPOS:Point = new Point(7, 7);
        public static const NAME:String = "FilterBagMediator";

        private var flagPageBtn:MovieClip;
        private var gridManager:FilterGridManager = null;
        private var bag:MovieClip;
        private var bagMask:Shape;
        private var BAG_POSX:uint = 329;
        private var initBagPos:Point;
        private var BAG_POSY:uint = 82;
        private var dataProxy:DataProxy = null;
        private var FilterBagGridNum:int = 104;
        private var totalPage:int = 1;
        private var flipHeight:int;
        private var panelBase:PanelBase = null;
        private var curPage:int = 1;

        public function FilterBagMediator(){
            super(NAME);
        }
        private function showItems():void{
            var _local2:MovieClip;
            var _local3:int;
            var _local5:uint;
            var _local1:Array = BagData.AllItems[BagData.NormalId];
            FilterBagData.currTmpIndex = -1;
            removeAllItem();
            initView();
            gridManager.Initialize();
            setPageTxt(0);
            if (FilterBagData.GridUnitList.length == 0){
                return;
            };
            var _local4:int;
            while (_local3 < _local1.length) {
                FilterBagData.AllItems[0][_local3] = null;
                _local3++;
            };
            _local3 = 0;
            while (_local3 < _local1.length) {
                FilterBagData.GridUnitList[(_local4 % BagData.MAX_GRIDS)].HasBag = true;
                if (_local1[_local3] == null){
                } else {
                    addItem(_local1[_local3]);
                    FilterBagData.GridUnitList[(_local4 % BagData.MAX_GRIDS)].HasBag = true;
                    _local4++;
                };
                _local3++;
            };
            if ((((((dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_STRENGTH)) || ((dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_EMBED)))) || ((dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_TRANSFER)))){
                addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON);
                addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_HAT);
                addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH);
                addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_SHOE);
            } else {
                if ((((((dataProxy.ForgeOpenFlag == DataProxy.FORGE_TREASURE_SACRIFICE)) || ((dataProxy.ForgeOpenFlag == DataProxy.FORGE_TREASURE_REBUILD)))) || ((dataProxy.ForgeOpenFlag == DataProxy.FORGE_TREASURE_TRANSFER)))){
                    addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE);
                } else {
                    if (dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_UPSTAR){
                        addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE);
                        addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY);
                        addRoleItem(ItemConst.ITEM_SUBCLASS_EQUIP_VIGOUR);
                        if (RolePropDatas.ItemList[5]){
                            addItem(RolePropDatas.ItemList[5], false);
                        };
                        if (RolePropDatas.ItemList[6]){
                            addItem(RolePropDatas.ItemList[6], false);
                        };
                    } else {
                        if (dataProxy.ConvoyIsOpen){
                        };
                    };
                };
            };
        }
        private function bagItemUnLock(_arg1:int):void{
            var _local2:int;
            while (_local2 < FilterBagData.GridUnitList.length) {
                if (FilterBagData.GridUnitList[_local2].Item){
                    if (_arg1 == FilterBagData.GridUnitList[_local2].Item.Id){
                        FilterBagData.GridUnitList[_local2].Item.IsLock = false;
                    };
                };
                _local2++;
            };
            _local2 = 0;
            while (_local2 < FilterBagData.AllItems[0].length) {
                if (FilterBagData.AllItems[0][_local2] == null){
                } else {
                    if (_arg1 == FilterBagData.AllItems[0][_local2].ItemGUID){
                        FilterBagData.AllLocks[0][_local2] = false;
                    };
                };
                _local2++;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local3:int;
            var _local2:Boolean;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    GameCommonData.GameInstance.GameUI.tabChildren = false;
                    GameCommonData.GameInstance.GameUI.tabEnabled = false;
                    break;
                case EventList.SHOWFILTERBAG:
                    if (!viewUI){
                        initViewUI();
                    };
                    if (dataProxy.ConvoyIsOpen){
                        viewUI.x = 5;
                        viewUI.y = 30;
                    } else {
                        viewUI.x = BAG_POSX;
                        viewUI.y = BAG_POSY;
                    };
                    _local2 = false;
                    if (dataProxy.ForgeOpenFlag > 0){
                        _local2 = true;
                    };
                    if (((_local2) && (dataProxy.PetIsOpen))){
                        facade.sendNotification(EventList.CLOSEPETVIEW);
                    };
                    showItems();
                    dataProxy.FilterBagIsOpen = true;
                    nexpreBtnVisible = true;
                    break;
                case EventList.UPDATEFILTERBAG:
                    if (!bag){
                        return;
                    };
                    if (dataProxy.ConvoyIsOpen){
                        viewUI.x = 5;
                        viewUI.y = 30;
                    } else {
                        if (dataProxy.CSBBagIsOpen){
                            viewUI.x = 2;
                            viewUI.y = 57;
                        } else {
                            viewUI.x = BAG_POSX;
                            viewUI.y = BAG_POSY;
                        };
                    };
                    _local2 = false;
                    if (dataProxy.ForgeOpenFlag > 0){
                        _local2 = true;
                    };
                    if (dataProxy.ConvoyIsOpen){
                        _local2 = true;
                    };
                    if (dataProxy.CSBBagIsOpen){
                        _local2 = true;
                    };
                    if (dataProxy.PetOperatorFlag > 0){
                        _local2 = true;
                    };
                    if (_local2){
                        showItems();
                        facade.sendNotification(EquipCommandList.UPDATE_EQUIP_FILTER);
                    };
                    break;
                case EventList.FILTERBAGITEMUNLOCK:
                    _local3 = (_arg1.getBody() as int);
                    bagItemUnLock(_local3);
                    break;
                case EventList.CLOSEFILTERBAG:
                    panelCloseHandler(null);
                    break;
            };
        }
        private function setBagMask(_arg1:int, _arg2:int, _arg3:int):void{
            flipHeight = (((36.05 + _arg2) * (BagData.MAX_GRIDS / _arg3)) + _arg2);
            bagMask.x = (bag.x + STARTPOS.x);
            bagMask.y = (bag.y + STARTPOS.y);
            bagMask.graphics.clear();
            bagMask.graphics.beginFill(0);
            bagMask.graphics.drawRect(0, 0, bag.width, flipHeight);
            bagMask.graphics.endFill();
            flagPageBtn.x = ((((bag.width - flagPageBtn.width) / 2) + bag.x) + STARTPOS.x);
            flagPageBtn.y = ((flipHeight + bag.y) + (STARTPOS.y / 2));
        }
        private function panelCloseHandler(_arg1:Event):void{
            gridManager.Gc();
            dataProxy.FilterBagIsOpen = false;
            nexpreBtnVisible = true;
            if (dataProxy.ForgeOpenFlag >= DataProxy.FORGE_TREASURE_START){
                facade.sendNotification(EquipCommandList.CLOSETREASURE_CMDLIST[(dataProxy.ForgeOpenFlag - DataProxy.FORGE_TREASURE_START)]);
            } else {
                if (dataProxy.ForgeOpenFlag >= DataProxy.FORGE_EQUIP_START){
                    facade.sendNotification(EquipCommandList.CLOSEEQUIP_CMDLIST[(dataProxy.ForgeOpenFlag - DataProxy.FORGE_EQUIP_START)]);
                };
            };
        }
        private function showLock():void{
            var _local1:int;
            while (_local1 < FilterBagData.AllItems[0].length) {
                FilterBagData.GridUnitList[_local1].Item.IsLock = FilterBagData.AllLocks[0][_local1];
                _local1++;
            };
        }
        private function clearLock():void{
            var _local1:int;
            while (_local1 < FilterBagData.AllItems[0].length) {
                if (((FilterBagData.GridUnitList[_local1]) && (FilterBagData.GridUnitList[_local1].Item))){
                    FilterBagData.GridUnitList[_local1].Item.IsLock = false;
                };
                _local1++;
            };
        }
        private function onFlagPage(_arg1:MouseEvent):void{
            switch (_arg1.currentTarget){
                case flagPageBtn.pre:
                    if (curPage <= 1){
                        return;
                    };
                    setPageTxt();
                    break;
                case flagPageBtn.next:
                    if (curPage >= totalPage){
                        return;
                    };
                    setPageTxt(-1, false);
                    break;
            };
        }
        public function set nexpreBtnVisible(_arg1:Boolean):void{
            flagPageBtn.visible = _arg1;
        }
        private function setPageTxt(_arg1:int=-1, _arg2:Boolean=true):void{
            if (_arg1 != -1){
                totalPage = ((_arg1 / BagData.MAX_GRIDS) + 1);
                if (curPage > totalPage){
                    curPage = 1;
                };
            } else {
                if (_arg2){
                    curPage--;
                } else {
                    curPage++;
                };
            };
            bag.y = (((1 - curPage) * flipHeight) + initBagPos.y);
            if (flagPageBtn){
                flagPageBtn.txt.text = ((curPage + "/") + totalPage);
            };
        }
        protected function getCells(_arg1:int, _arg2:int, _arg3:DisplayObjectContainer, _arg4:uint=0):UseItem{
            var _local5:UseItem;
            if (FilterBagData.GridUnitList[_arg1].Item == null){
                _local5 = new UseItem(_arg1, _arg2, _arg3, _arg4);
                return (_local5);
            };
            return (FilterBagData.GridUnitList[_arg1].Item);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.SHOWFILTERBAG, EventList.UPDATEFILTERBAG, EventList.FILTERBAGITEMUNLOCK, EventList.CLOSEFILTERBAG]);
        }
        private function initViewUI():void{
            var _local1:MovieClip = new MovieClip();
            bag = new MovieClip();
            bag.name = "bag";
            _local1.addChild(bag);
            setViewComponent(_local1);
            gridManager = new FilterGridManager();
            facade.registerProxy(gridManager);
            facade.registerCommand(FilterItemUseCommand.NAME, FilterItemUseCommand);
            initGrid();
        }
        public function alignGrid(_arg1:uint):void{
            var _local2:int;
            var _local3:uint = ((_arg1 + 1) * 3);
            if (_local3 == 6){
                viewUI.x = BAG_POSX;
                viewUI.y = BAG_POSY;
            };
            while (_local2 < FilterBagGridNum) {
                FilterBagData.GridUnitList[_local2].Grid.x = (STARTPOS.x + ((FilterBagData.GridUnitList[_local2].Grid.width + 3) * (_local2 % _local3)));
                FilterBagData.GridUnitList[_local2].Grid.y = (STARTPOS.y + ((FilterBagData.GridUnitList[_local2].Grid.height + 3) * int((_local2 / _local3))));
                if (FilterBagData.GridUnitList[_local2].Item){
                    FilterBagData.GridUnitList[_local2].Item.x = (FilterBagData.GridUnitList[_local2].Grid.x + 2);
                    FilterBagData.GridUnitList[_local2].Item.y = (FilterBagData.GridUnitList[_local2].Grid.y + 2);
                };
                _local2++;
            };
        }
        private function addItem(_arg1:InventoryItemInfo, _arg2:Boolean=true):void{
            var _local6:String;
            var _local3:Boolean;
            if (_arg2){
                if (dataProxy.ForgeOpenFlag > 0){
                    switch (dataProxy.ForgeOpenFlag){
                        case DataProxy.FORGE_EQUIP_STRENGTH:
                            _local3 = ItemConst.IsStrengthOperType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_EMBED:
                            _local3 = ItemConst.IsEmbedOperType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_IDENTIFY:
                            _local3 = ItemConst.IsIdentifyOperType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_COMPOSE:
                            _local3 = ItemConst.IsComposeOperType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_REFINE:
                            _local3 = ItemConst.IsRefineType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_UPSTAR:
                            _local3 = ItemConst.IsUpStarType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_TRANSFER:
                            _local3 = ItemConst.IsEquipTransfer(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_EQUIP_TRANSFORM:
                            _local3 = ItemConst.IsEquipTransform(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_TREASURE_REBUILD:
                            _local3 = ItemConst.IsTreasureRebuildType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_TREASURE_SACRIFICE:
                            _local3 = ItemConst.IsSacrificeType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_TREASURE_RESET:
                            _local3 = ItemConst.IsTreasureResetType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_TREASURE_TRANSFER:
                            _local3 = ItemConst.IsTreasureTransferType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                        case DataProxy.FORGE_TREASURE_TRANSFORM:
                            _local3 = ItemConst.IsTreasureTransformType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                            break;
                    };
                };
                if (_local3){
                    _local3 = ItemConst.IsWornEquipType(BagData.AllItems[BagData.NormalId][_arg1.index]);
                };
                if (dataProxy.PetOperatorFlag){
                    _local3 = ItemConst.IsPetOperatorType(BagData.AllItems[BagData.NormalId][_arg1.index], dataProxy.PetOperatorFlag);
                } else {
                    if (dataProxy.ConvoyIsOpen){
                        _local3 = ItemConst.IsConvoyType(_arg1);
                    } else {
                        if (dataProxy.CSBBagIsOpen){
                            _local3 = ItemConst.IsCSBMedical(_arg1);
                        };
                    };
                };
                if (_local3 == false){
                    return;
                };
            };
            if (_local3 == false){
                return;
            };
            FilterBagData.currTmpIndex++;
            FilterBagData.AllItems[0][FilterBagData.currTmpIndex] = new FilterInventory();
            FilterBagData.AllItems[0][FilterBagData.currTmpIndex].index = FilterBagData.currTmpIndex;
            FilterBagData.AllItems[0][FilterBagData.currTmpIndex].Place = _arg1.Place;
            FilterBagData.AllItems[0][FilterBagData.currTmpIndex].ItemGUID = _arg1.ItemGUID;
            FilterBagData.AllItems[0][FilterBagData.currTmpIndex].TemplateID = _arg1.TemplateID;
            FilterBagData.AllItems[0][FilterBagData.currTmpIndex].Count = _arg1.Count;
            setPageTxt(FilterBagData.currTmpIndex);
            var _local4:Array = FilterBagData.GridUnitList;
            var _local5:UseItem = this.getCells(FilterBagData.currTmpIndex, _arg1.type, bag, _arg1.ItemGUID);
            _local5.Num = _arg1.Count;
            _local5.clearThumbLock();
            if (_local5.iconName != String(_arg1.img)){
                _local5.resetIcon(String(_arg1.img));
            };
            if ((((((_local5.itemIemplateInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_local5.itemIemplateInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))) && ((_local5.itemIemplateInfo.HpBonus > 4)))){
                _local6 = String((_arg1.img + (BagData.getItemById(_arg1.ItemGUID).Add1 * 10)));
                _local5.resetIcon(_local6);
            };
            if ((((_arg1.Flags & ItemConst.FlAGS_TRADE)) || (_arg1.isBind))){
                _local5.setThumbLock();
            };
            _local5.x = (_local4[FilterBagData.currTmpIndex].Grid.x + 2);
            _local5.y = (_local4[FilterBagData.currTmpIndex].Grid.y + 2);
            _local5.Id = _arg1.ItemGUID;
            _local5.IsBind = _arg1.isBind;
            _local5.Type = _arg1.type;
            _local5.IsLock = false;
            _local4[FilterBagData.currTmpIndex].Item = _local5;
            _local4[FilterBagData.currTmpIndex].IsUsed = true;
            bag.addChild(_local5);
        }
        private function initView():void{
        }
        public function setGridGap(_arg1:int=3, _arg2:int=3, _arg3:int=6):void{
            var _local5:MovieClip;
            var _local4:int;
            while (_local4 < FilterBagGridNum) {
                _local5 = (bag.getChildByName(("filterBag_" + _local4)) as MovieClip);
                if (_local5){
                    _local5.x = (((_local5.width + _arg1) * (_local4 % _arg3)) + STARTPOS.x);
                    _local5.y = (((_local5.height + _arg2) * int((_local4 / _arg3))) + STARTPOS.y);
                };
                _local4++;
            };
            setBagMask(_arg1, _arg2, _arg3);
        }
        private function addRoleItem(_arg1:uint):void{
            var _local2:int = RolePropDatas.ItemPos.indexOf(_arg1);
            if (!ItemConst.IsWornEquipType(RolePropDatas.ItemList[_local2])){
                return;
            };
            if (((!((_local2 == -1))) && (RolePropDatas.ItemList[_local2]))){
                if (dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_EMBED){
                    if (RolePropDatas.ItemList[_local2].Add1 > 0){
                        addItem(RolePropDatas.ItemList[_local2], false);
                    };
                } else {
                    if (dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_TRANSFER){
                        if ((((RolePropDatas.ItemList[_local2].RequiredLevel >= 72)) && ((RolePropDatas.ItemList[_local2].Color >= 2)))){
                            addItem(RolePropDatas.ItemList[_local2], false);
                        };
                    } else {
                        if (dataProxy.ForgeOpenFlag == DataProxy.FORGE_EQUIP_REFINE){
                            if (RolePropDatas.ItemList[_local2].Color >= 3){
                                addItem(RolePropDatas.ItemList[_local2], false);
                            };
                        } else {
                            addItem(RolePropDatas.ItemList[_local2], false);
                        };
                    };
                };
                FilterBagData.GridUnitList[_local2].HasBag = true;
                _local2++;
            };
        }
        private function removeAllItem():void{
            var _local1:ItemBase;
            var _local2:int = (bag.numChildren - 1);
            while (_local2 >= 0) {
                if ((bag.getChildAt(_local2) is ItemBase)){
                    _local1 = (bag.getChildAt(_local2) as ItemBase);
                    bag.removeChild(_local1);
                    _local1 = null;
                };
                _local2--;
            };
            SetFrame.RemoveFrame(bag);
            _local2 = 0;
            while (_local2 < FilterBagGridNum) {
                if (FilterBagData.GridUnitList[_local2] == null){
                } else {
                    FilterBagData.GridUnitList[_local2].Item = null;
                    FilterBagData.GridUnitList[_local2].IsUsed = false;
                };
                _local2++;
            };
        }
        private function get viewUI():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            bagMask = new Shape();
            bag.mask = bagMask;
            viewUI.addChild(bagMask);
            initBagPos = new Point(bag.x, bag.y);
            flagPageBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("FilterFligPageMC");
            flagPageBtn.pre.addEventListener(MouseEvent.CLICK, onFlagPage);
            flagPageBtn.next.addEventListener(MouseEvent.CLICK, onFlagPage);
            viewUI.addChild(flagPageBtn);
            var _local3:int;
            while (_local3 < FilterBagGridNum) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = (((_local1.width + 3) * (_local3 % 6)) + STARTPOS.x);
                _local1.y = (((_local1.height + 1) * int((_local3 / 6))) + STARTPOS.y);
                _local1.name = ("filterBag_" + _local3.toString());
                bag.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = bag;
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                FilterBagData.GridUnitList.push(_local2);
                _local3++;
            };
            setBagMask(3, 1, 6);
        }

    }
}//package GameUI.Modules.FilterBag.Mediator 
