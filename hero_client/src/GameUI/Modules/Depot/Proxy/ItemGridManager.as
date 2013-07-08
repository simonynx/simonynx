//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Depot.Proxy {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Depot.Mediator.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import GameUI.Modules.Depot.Data.*;

    public class ItemGridManager extends Proxy {

        public static const NAME:String = "ItemGridManager";

        private var gridList:Array;
        private var getOutTimer:Timer;
        private var yellowFrame:MovieClip = null;
        private var redFrame:MovieClip = null;
        private var dataProxy:DataProxy = null;
        private var gridSprite:MovieClip;

        public function ItemGridManager(_arg1:Array, _arg2:MovieClip){
            gridList = new Array();
            getOutTimer = new Timer(500, 1);
            super(NAME);
            this.gridList = _arg1;
            this.gridSprite = _arg2;
            init();
        }
        public function getPageNum():int{
            return (0);
        }
        public function lockGrids(_arg1:Boolean):void{
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < gridList.length) {
                _local2 = (gridList[_local3] as GridUnit);
                _local2.Grid.mouseEnabled = _arg1;
                _local3++;
            };
        }
        public function showItems(_arg1:Array):void{
            var _local2:int;
            var _local3:UseItem;
            var _local4:MovieClip;
            var _local5:int;
            var _local6:UseItem;
            if (DepotConstData.GridUnitList.length == 0){
                return;
            };
            var _local7:int = getGridNum();
            var _local8:int = getPageNum();
            if (_local8 == DepotConstData.curDepotIndex){
                _local2 = 0;
                while (_local2 < _arg1.length) {
                    DepotConstData.GridUnitList[_local2].HasBag = true;
                    if (_local2 >= _local7){
                        DepotConstData.GridUnitList[_local2].HasBag = false;
                        DepotConstData.GridUnitList[_local2].Grid.visible = false;
                    } else {
                        if (_arg1[_local2] == null){
                            DepotConstData.GridUnitList[_local2].IsUsed = false;
                        } else {
                            _local3 = new UseItem(_arg1[_local2].index, _arg1[_local2].type, gridSprite, _arg1[_local2].ItemGUID);
                            _local3.Num = _arg1[_local2].Count;
                            _local3.clearThumbLock();
                            if ((((_local3.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)) || (_arg1[_local2].isBind))){
                                _local3.setThumbLock();
                            };
                            _local3.x = (DepotConstData.GridUnitList[_local2].Grid.x + 2);
                            _local3.y = (DepotConstData.GridUnitList[_local2].Grid.y + 2);
                            _local3.Id = _arg1[_local2].ItemGUID;
                            _local3.IsBind = _arg1[_local2].isBind;
                            _local3.Type = _arg1[_local2].type;
                            _local3.IsLock = false;
                            DepotConstData.GridUnitList[_local2].Item = _local3;
                            DepotConstData.GridUnitList[_local2].IsUsed = true;
                            gridSprite.addChild(_local3);
                        };
                    };
                    _local2++;
                };
            };
            if (DepotConstData.gridCount == 36){
                gridSprite.txt_extend.visible = false;
            } else {
                if (DepotConstData.gridCount == 42){
                    gridSprite.txt_extend.visible = false;
                    gridSprite.txt_extendDepot.visible = false;
                };
            };
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            var _local2:int;
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            switch (_arg1.Data.type){
                case "bag":
                    if (BagData.GridUnitList[BagData.SelectIndex][(_arg1.Data.index % BagData.MAX_GRIDS)].HasBag == false){
                        returnItem(_arg1.Data.source);
                        return;
                    };
                    BagInfoSend.ItemSwap((ItemConst.BANK_SLOT_START + _arg1.Data.source.Pos), ItemConst.gridUnitToPlace(BagData.SelectIndex, _arg1.Data.index));
                    _local2 = 0;
                    while (_local2 < DepotConstData.GridUnitList.length) {
                        if (DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame")){
                            DepotConstData.GridUnitList[_local2].Grid.parent.removeChild(DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame"));
                        };
                        if (DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame")){
                            DepotConstData.GridUnitList[_local2].Grid.parent.removeChild(DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame"));
                        };
                        _local2++;
                    };
                    DepotConstData.SelectedItem = null;
                    if (dataProxy.BagIsDrag){
                        dataProxy.BagIsDrag = false;
                    };
                    break;
                case "depot":
                    if (DepotConstData.GridUnitList[_arg1.Data.index].HasBag == false){
                        returnItem(_arg1.Data.source);
                        return;
                    };
                    BagInfoSend.ItemSwap((ItemConst.BANK_SLOT_START + _arg1.Data.source.Pos), (ItemConst.BANK_SLOT_START + _arg1.Data.index));
                    _local2 = 0;
                    while (_local2 < DepotConstData.GridUnitList.length) {
                        if (DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame")){
                            DepotConstData.GridUnitList[_local2].Grid.parent.removeChild(DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame"));
                        };
                        if (DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame")){
                            DepotConstData.GridUnitList[_local2].Grid.parent.removeChild(DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame"));
                        };
                        _local2++;
                    };
                    DepotConstData.SelectedItem = null;
                    if (dataProxy.BagIsDrag){
                        dataProxy.BagIsDrag = false;
                    };
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        private function startTimer():Boolean{
            if (getOutTimer.running){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("请稍后"),
                    color:0xFFFF00
                });
                return (false);
            };
            getOutTimer.reset();
            getOutTimer.start();
            return (true);
        }
        private function init():void{
            var _local1:GridUnit;
            var _local2:int;
            redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
            redFrame.name = "redFrame";
            redFrame.mouseEnabled = false;
            yellowFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowFrame");
            yellowFrame.name = "yellowFrame";
            yellowFrame.mouseEnabled = false;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        public function removeAllItem():void{
            var _local1:ItemBase;
            var _local2:MovieClip;
            var _local5:int;
            var _local3:int = (gridSprite.numChildren - 1);
            while (_local3 >= 0) {
                if ((gridSprite.getChildAt(_local3) is ItemBase)){
                    _local1 = (gridSprite.getChildAt(_local3) as ItemBase);
                    gridSprite.removeChild(_local1);
                    _local1 = null;
                };
                _local3--;
            };
            var _local4:int = (gridSprite.numChildren - 1);
            while (_local5 < 42) {
                if (DepotConstData.GridUnitList[_local5].Grid.parent.getChildByName("redFrame")){
                    DepotConstData.GridUnitList[_local5].Grid.parent.removeChild(DepotConstData.GridUnitList[_local5].Grid.parent.getChildByName("redFrame"));
                };
                if (DepotConstData.GridUnitList[_local5].Grid.parent.getChildByName("yellowFrame")){
                    DepotConstData.GridUnitList[_local5].Grid.parent.removeChild(DepotConstData.GridUnitList[_local5].Grid.parent.getChildByName("yellowFrame"));
                };
                DepotConstData.GridUnitList[_local5].Item = null;
                DepotConstData.GridUnitList[_local5].IsUsed = false;
                _local5++;
            };
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            var _local4:int;
            var _local5:uint;
            var _local2:* = int(_arg1.target.name.split("_")[1]);
            if ((((((((DepotConstData.GridUnitList[_local2].HasBag == false)) || (!(gridList[_local2].Item)))) || (gridList[_local2].Item.IsLock))) || (!(startTimer())))){
                return;
            };
            if (DepotConstData.GridUnitList[_local2].Item){
                DepotConstData.GridUnitList[_local2].Item.gc();
            };
            var _local3:uint = DepotConstData.goodList[_local2].MainClass;
            if ((((((((((_local3 == ItemConst.ITEM_CLASS_USABLE)) || ((_local3 == ItemConst.ITEM_CLASS_EQUIP)))) || ((_local3 == ItemConst.ITEM_CLASS_CONSUMABLE)))) || ((_local3 == ItemConst.ITEM_CLASS_MEDICAL)))) || ((_local3 == ItemConst.ITEM_CLASS_PET)))){
                _local5 = 0;
            } else {
                if (_local3 == ItemConst.ITEM_CLASS_MATERIAL){
                    _local5 = 1;
                } else {
                    if (_local3 == ItemConst.ITEM_CLASS_TASK){
                        _local5 = 2;
                    };
                };
            };
            BagData.SelectIndex = _local5;
            _local4 = BagData.findEmptyPos(_local5);
            if (_local4 != -1){
                BagInfoSend.ItemSwap((ItemConst.BANK_SLOT_START + _local2), ItemConst.gridUnitToPlace(_local5, _local4));
            };
        }
        public function addItem(_arg1:int):void{
            var _local3:UseItem;
            var _local2:Array = DepotConstData.GridUnitList;
            _local3 = new UseItem(DepotConstData.goodList[_arg1].index, DepotConstData.goodList[_arg1].type, gridSprite, DepotConstData.goodList[_arg1].ItemGUID);
            _local3.Num = DepotConstData.goodList[_arg1].Count;
            _local3.clearThumbLock();
            if ((((_local3.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)) || (DepotConstData.goodList[_arg1].isBind))){
                _local3.setThumbLock();
            };
            _local3.x = (DepotConstData.GridUnitList[_arg1].Grid.x + 2);
            _local3.y = (DepotConstData.GridUnitList[_arg1].Grid.y + 2);
            _local3.Id = DepotConstData.goodList[_arg1].ItemGUID;
            _local3.IsBind = DepotConstData.goodList[_arg1].isBind;
            _local3.Type = DepotConstData.goodList[_arg1].type;
            _local3.IsLock = false;
            DepotConstData.GridUnitList[_arg1].Item = _local3;
            DepotConstData.GridUnitList[_arg1].IsUsed = true;
            gridSprite.addChild(_local3);
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            var _local3:int;
            if (dataProxy.BagIsDrag){
                return;
            };
            var _local2:int = (_arg1.currentTarget.parent.numChildren - 1);
            while (_local2) {
                if (_arg1.currentTarget.parent.getChildByName("yellowFrame")){
                    _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("yellowFrame"));
                };
                _local2--;
            };
            _local3 = int(_arg1.target.name.split("_")[1]);
            if (gridList[_local3].Item){
                if (gridList[_local3].Item.IsLock){
                    return;
                };
                gridList[_local3].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
                DepotConstData.TmpIndex = gridList[_local3].Index;
                DepotConstData.SelectedItem = gridList[_local3];
                _arg1.currentTarget.parent.addChild(yellowFrame);
                yellowFrame.x = _arg1.currentTarget.x;
                yellowFrame.y = _arg1.currentTarget.y;
                gridList[_local3].Item.onMouseDown();
                return;
            };
            DepotConstData.SelectedItem = null;
        }
        private function returnItem(_arg1:ItemBase):void{
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            _arg1.parent.addChild(yellowFrame);
            DepotConstData.SelectedItem = DepotConstData.GridUnitList[((_arg1.Pos - 1) - (DepotConstData.curDepotIndex * 36))];
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (_arg1.currentTarget.parent.getChildByName("redFrame")){
                _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("redFrame"));
            };
        }
        public function getGridNum():int{
            return (DepotConstData.gridCount);
        }
        public function Initialize():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        private function DroppedIsDepot(_arg1:int, _arg2:MovieClip, _arg3:UseItem):void{
            var _local4:int;
            if (_arg1 == ((_arg3.Pos - 1) - (DepotConstData.curDepotIndex * 36))){
                return;
            };
            while (_local4 < DepotConstData.GridUnitList.length) {
                if (DepotConstData.GridUnitList[_local4].Grid.parent.getChildByName("redFrame")){
                    DepotConstData.GridUnitList[_local4].Grid.parent.removeChild(DepotConstData.GridUnitList[_local4].Grid.parent.getChildByName("redFrame"));
                };
                if (DepotConstData.GridUnitList[_local4].Grid.parent.getChildByName("yellowFrame")){
                    DepotConstData.GridUnitList[_local4].Grid.parent.removeChild(DepotConstData.GridUnitList[_local4].Grid.parent.getChildByName("yellowFrame"));
                };
                _local4++;
            };
            DepotConstData.SelectedItem = null;
        }
        public function removeItem(_arg1:int):void{
            var _local2:int;
            while (_local2 < DepotConstData.GridUnitList.length) {
                if (DepotConstData.GridUnitList[_local2].Item){
                    if (DepotConstData.GridUnitList[_local2].Item.Id == _arg1){
                        removeChild(DepotConstData.GridUnitList[_local2].Item);
                        DepotConstData.GridUnitList[_local2].Item = null;
                        DepotConstData.GridUnitList[_local2].IsUsed = false;
                        if (DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame")){
                            DepotConstData.GridUnitList[_local2].Grid.parent.removeChild(DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame"));
                        };
                        if (DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame")){
                            DepotConstData.GridUnitList[_local2].Grid.parent.removeChild(DepotConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame"));
                        };
                    };
                };
                _local2++;
            };
        }
        public function Gc():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (DepotConstData.SelectedItem){
                if (_arg1.currentTarget.name.split("_")[1] == DepotConstData.SelectedItem.Index){
                    return;
                };
            };
            _arg1.currentTarget.parent.addChild(redFrame);
            redFrame.x = _arg1.currentTarget.x;
            redFrame.y = _arg1.currentTarget.y;
        }
        private function removeChild(_arg1:DisplayObject):void{
            if (gridSprite.contains(_arg1)){
                gridSprite.removeChild(_arg1);
            };
        }

    }
}//package GameUI.Modules.Depot.Proxy 
