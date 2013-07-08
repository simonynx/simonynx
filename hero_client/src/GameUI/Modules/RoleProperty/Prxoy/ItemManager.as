//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Prxoy {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Bag.*;
    //import GameUI.Modules.RoleProperty.Net.*;

    public class ItemManager extends Proxy {

        public static const NAME:String = "ItemManager";

        private var dataProxy:DataProxy = null;

        public function ItemManager(_arg1:Array=null){
            super(NAME);
        }
        public function Initialize():void{
            var _local1:ItemUnit;
            var _local2:int;
            while (_local2 < RolePropDatas.ItemUnitList.length) {
                _local1 = (RolePropDatas.ItemUnitList[_local2] as ItemUnit);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.doubleClickEnabled = true;
                _local1.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            switch (_arg1.Data.type){
                case "bag":
                    if (BagData.SelectIndex == 0){
                        BagInfoSend.ItemSwap(_arg1.Data.source.Pos, ItemConst.gridUnitToPlace(BagData.SelectIndex, _arg1.Data.index));
                    };
                    if (dataProxy.BagIsDrag){
                        dataProxy.BagIsDrag = false;
                    };
                    break;
            };
        }
        private function onMouseMove(_arg1:MouseEvent):void{
        }
        private function onMouseOut(_arg1:MouseEvent):void{
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            var _local2:* = BagUtils.getNullItemIndex(0);
            var _local3:* = uint((_arg1.target as MovieClip).name.split("_")[1]);
            if ((((RolePropDatas.ItemUnitList[_local3] == undefined)) || ((RolePropDatas.ItemUnitList[_local3].Item == null)))){
                return;
            };
            if (RolePropDatas.ItemUnitList[_local3].Item){
                RolePropDatas.ItemUnitList[_local3].Item.gc();
            };
            if (_local2 > -1){
                BagInfoSend.ItemSwap(_local3, ItemConst.gridUnitToPlace(0, _local2));
            } else {
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("背包已满多余物品存仓库"),
                    color:0xFFFF00
                });
            };
        }
        public function Gc():void{
            var _local1:ItemUnit;
            var _local2:int;
            while (_local2 < RolePropDatas.ItemUnitList.length) {
                _local1 = (RolePropDatas.ItemUnitList[_local2] as ItemUnit);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        private function dragThrewHandler(_arg1:DropEvent):void{
            _arg1.target.removeEventListener(DropEvent.DRAG_THREW, dragThrewHandler);
            if (RolePropDatas.SelectedOutfit.Item){
            };
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            var _local2:DisplayObject;
            var _local4:uint;
            var _local5:uint;
            var _local6:String;
            var _local7:uint;
            var _local8:uint;
            var _local9:InventoryItemInfo;
            var _local10:uint;
            var _local11:uint;
            var _local12:String;
            var _local13:String;
            if (dataProxy.BagIsDrag){
                return;
            };
            if (GameCommonData.Player.Role.HP == 0){
                return;
            };
            var _local3:int = int(_arg1.target.name.split("_")[1]);
            if (RolePropDatas.ItemUnitList[_local3].Item){
                if (_arg1.ctrlKey){
                    _local4 = RolePropDatas.ItemUnitList[_local3].Item.Id;
                    _local5 = RolePropDatas.ItemUnitList[_local3].Item.Type;
                    _local6 = UIConstData.ItemDic[RolePropDatas.ItemUnitList[_local3].Item.Type].Name;
                    _local7 = 1;
                    _local8 = 0;
                    _local9 = RolePropDatas.ItemList[_local3];
                    if (_local9){
                        _local8 = _local9.Color;
                    };
                    _local10 = _local9.MainClass;
                    _local11 = _local9.SubClass;
                    _local12 = "";
                    _local12 = RolePropDatas.ItemList[_local3].WriteConcatString();
                    _local13 = (((((((((((((("<1_[" + _local6) + "]_") + _local4) + "_") + _local5) + "_") + GameCommonData.Player.Role.Id) + "_") + _local7) + "_") + _local8) + "_") + _local12) + ">");
                    facade.sendNotification(ChatEvents.ADDITEMINCHAT, _local13);
                    return;
                };
            };
            if (RolePropDatas.ItemUnitList[_local3].Item){
                _local2 = (_arg1.target as DisplayObject);
                if ((((_local2.mouseX <= 2)) || ((_local2.mouseX >= (_local2.width - 2))))){
                    return;
                };
                if ((((_local2.mouseY <= 2)) || ((_local2.mouseY >= (_local2.height - 2))))){
                    return;
                };
                RolePropDatas.ItemUnitList[_local3].Item.onMouseDown();
                RolePropDatas.ItemUnitList[_local3].Item.addEventListener(DropEvent.DRAG_THREW, dragThrewHandler);
                RolePropDatas.ItemUnitList[_local3].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
                RolePropDatas.SelectedOutfit = RolePropDatas.ItemUnitList[_local3];
            };
        }

    }
}//package GameUI.Modules.RoleProperty.Prxoy 
