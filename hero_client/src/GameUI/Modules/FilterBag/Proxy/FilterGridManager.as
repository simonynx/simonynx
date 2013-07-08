//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.FilterBag.Proxy {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    import GameUI.Modules.FilterBag.Mediator.*;
    import GameUI.Modules.FilterBag.Command.*;
    import GameUI.Modules.FilterBag.Datas.*;
    import GameUI.*;

    public class FilterGridManager extends Proxy {

        public static const NAME:String = "FilterGridManager";

        private var dataProxy:DataProxy = null;

        public function FilterGridManager(){
            super(NAME);
        }
        public function Initialize():void{
            var _local1:GridUnit;
            var _local2:int;
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            while (_local2 < FilterBagData.GridUnitList.length) {
                _local1 = (FilterBagData.GridUnitList[_local2] as GridUnit);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            if (!FilterBagData.SelectedItem){
                return;
            };
            if (!FilterBagData.SelectedItem.Item){
                return;
            };
            FilterBagData.SelectedItem.Item.gc();
            if (FilterBagData.SelectedItem.Item.IsLock == true){
                return;
            };
            if (FilterBagData.AllItems[0][FilterBagData.SelectedItem.Index] == null){
                sendNotification(EventList.UPDATEFILTERBAG);
                return;
            };
            facade.sendNotification(FilterItemUseCommand.NAME);
        }
        public function returnItem(_arg1:ItemBase):void{
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            FilterBagData.SelectedItem = FilterBagData.GridUnitList[_arg1.Pos];
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            var _local2:Object = UIConstData.ItemDic[_arg1.Data.source.Type];
            switch (_arg1.Data.type){
                case "Strengthen":
                case "Strengen":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_STRENGTH_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipPour":
                case "EquipPourT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_POUR_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipBreak":
                case "EquipBreakT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_BREAK_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipActive":
                case "EquipActiveT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_ACTIVE_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipIdentify":
                case "EquipIdentifyT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_IDENTIFY_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipRefine":
                case "EquipRefineT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_REFINE_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipUpStar":
                case "EquipUpStarT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_UPSTAR_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipTransform":
                case "EquipTransformT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_TRANSFORM_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipTransfer":
                case "EquipTransferT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_TRANSFER_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "TreasureTransform":
                case "TreasureTransformT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_TRANSFORM_TREASURE, {
                        index:3,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipCompose":
                case "EquipComposeT":
                case "EquipComposeT2":
                    facade.sendNotification(EquipCommandList.UPDATE_COMPOSE_EQUIP, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "EquipEmbed":
                case "EquipEmbedT":
                case "EquipEmbedT2":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    if (_arg1.Data.index == 0){
                        facade.sendNotification(EquipCommandList.UPDATE_EMBED_EQUIP, {
                            index:_arg1.Data.index,
                            useItem:_arg1.Data.source
                        });
                    } else {
                        facade.sendNotification(EquipCommandList.UPDATE_EMBED_EQUIP, {
                            index:_arg1.Data.index,
                            useItem:_arg1.Data.source
                        });
                    };
                    break;
                case "TreasureSacrifice":
                case "TreasureSacrificeT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_SACRIFICE_TREASURE, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "TreasureReset":
                case "TreasureResetT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_RESET_TREASURE, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "TreasureRebuild":
                case "TreasureRebuildT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_REBUILD_TREASURE, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "TreasureTransfer":
                case "TreasureTransferT":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EquipCommandList.UPDATE_TRANSFER_TREASURE, {
                        index:_arg1.Data.index,
                        useItem:_arg1.Data.source
                    });
                    break;
                case "Convoy":
                    _arg1.Data.source.IsLock = true;
                    FilterBagData.AllLocks[0][FilterBagData.SelectedItem.Index] = true;
                    facade.sendNotification(EventList.BAGTOCONVOY, BagData.getItemById(FilterBagData.SelectedItem.Item.Id));
                    break;
                case "quick":
                case "quickf":
                    returnItem(_arg1.Data.source);
                    facade.sendNotification(EventList.DROPINQUICK, {
                        target:_arg1.Data.target,
                        source:_arg1.Data.source,
                        index:_arg1.Data.index,
                        type:_arg1.Data.type
                    });
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            SetFrame.RemoveFrame(_arg1.currentTarget.parent, "RedFrame");
        }
        public function Gc():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < FilterBagData.GridUnitList.length) {
                _local1 = (FilterBagData.GridUnitList[_local2] as GridUnit);
                SetFrame.RemoveFrame(_local1.Grid.parent);
                SetFrame.RemoveFrame(_local1.Grid.parent, "RedFrame");
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (FilterBagData.SelectedItem){
                if (_arg1.currentTarget.name.split("_")[1] == FilterBagData.SelectedItem.Index){
                    return;
                };
            };
            SetFrame.UseFrame((_arg1.currentTarget as DisplayObject), "RedFrame");
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            var _local2:DisplayObject;
            if (dataProxy.BagIsDrag){
                return;
            };
            SetFrame.RemoveFrame(_arg1.currentTarget.parent);
            SetFrame.RemoveFrame(_arg1.currentTarget.parent, "RedFrame");
            var _local3:int = int(_arg1.target.name.split("_")[1]);
            if (FilterBagData.GridUnitList[_local3].Item){
                if (FilterBagData.GridUnitList[_local3].Item.IsLock){
                    FilterBagData.SelectedItem = FilterBagData.GridUnitList[_local3];
                    return;
                };
                FilterBagData.SelectedItem = FilterBagData.GridUnitList[_local3];
                _local2 = (_arg1.target as DisplayObject);
                if ((((_local2.mouseX <= 2)) || ((_local2.mouseX >= (_local2.width - 2))))){
                    return;
                };
                if ((((_local2.mouseY <= 2)) || ((_local2.mouseY >= (_local2.height - 2))))){
                    return;
                };
                FilterBagData.GridUnitList[_local3].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
                FilterBagData.GridUnitList[_local3].Item.onMouseDown();
                FilterBagData.TmpIndex = FilterBagData.GridUnitList[_local3].Index;
                return;
            };
            if (dataProxy.BagIsSplit){
                dataProxy.BagIsSplit = false;
            };
            if (dataProxy.BagIsDestory){
                dataProxy.BagIsDestory = false;
            };
            FilterBagData.SelectedItem = null;
        }

    }
}//package GameUI.Modules.FilterBag.Proxy 
