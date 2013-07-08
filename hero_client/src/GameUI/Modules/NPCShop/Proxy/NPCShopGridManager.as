//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCShop.Proxy {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    import GameUI.Modules.NPCShop.Data.*;

    public class NPCShopGridManager extends Proxy {

        public static const NAME:String = "NPCShopGridManager";

        private var dataProxy:DataProxy = null;
        private var gridList:Array;
        private var yellowFrame:MovieClip = null;
        private var gridSprite:MovieClip;
        private var redFrame:MovieClip = null;

        public function NPCShopGridManager(_arg1:Array, _arg2:MovieClip){
            gridList = new Array();
            super(NAME);
            this.gridList = _arg1;
            this.gridSprite = _arg2;
            init();
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (_arg1.currentTarget.parent.getChildByName("redFrame")){
                _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("redFrame"));
            };
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            var _local2:int = uint(_arg1.currentTarget.name.split("_")[1]);
            if (NPCShopConstData.goodSaleList[_local2]){
                shoptobag(NPCShopConstData.goodSaleList[_local2].ItemGUID);
            };
        }
        private function returnItem(_arg1:ItemBase):void{
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            _arg1.parent.addChild(yellowFrame);
            NPCShopConstData.SelectedItem = NPCShopConstData.GridUnitList[_arg1.Pos];
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            var _local2:int;
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            switch (_arg1.Data.type){
                case "bag":
                    shoptobag(_arg1.Data.source.Id);
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (NPCShopConstData.SelectedItem){
                if (_arg1.currentTarget.name.split("_")[1] == NPCShopConstData.SelectedItem.Index){
                    return;
                };
            };
            _arg1.currentTarget.parent.addChild(redFrame);
            redFrame.x = _arg1.currentTarget.x;
            redFrame.y = _arg1.currentTarget.y;
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
                NPCShopConstData.TmpIndex = gridList[_local3].Index;
                gridList[_local3].Item.onMouseDown();
                _arg1.currentTarget.parent.addChild(yellowFrame);
                yellowFrame.x = _arg1.currentTarget.x;
                yellowFrame.y = _arg1.currentTarget.y;
                NPCShopConstData.SelectedItem = gridList[_local3];
                return;
            };
            NPCShopConstData.SelectedItem = null;
        }
        public function removeAllItem():void{
            var _local1:ItemBase;
            var _local3:int;
            var _local2:int = (gridSprite.numChildren - 1);
            while (_local2 >= 0) {
                if ((gridSprite.getChildAt(_local2) is ItemBase)){
                    _local1 = (gridSprite.getChildAt(_local2) as ItemBase);
                    gridSprite.removeChild(_local1);
                    _local1 = null;
                };
                _local2--;
            };
            while (_local3 < 8) {
                if (NPCShopConstData.GridUnitList[_local3].Grid.parent.getChildByName("redFrame")){
                    NPCShopConstData.GridUnitList[_local3].Grid.parent.removeChild(NPCShopConstData.GridUnitList[_local3].Grid.parent.getChildByName("redFrame"));
                };
                if (NPCShopConstData.GridUnitList[_local3].Grid.parent.getChildByName("yellowFrame")){
                    NPCShopConstData.GridUnitList[_local3].Grid.parent.removeChild(NPCShopConstData.GridUnitList[_local3].Grid.parent.getChildByName("yellowFrame"));
                };
                NPCShopConstData.GridUnitList[_local3].Item = null;
                NPCShopConstData.GridUnitList[_local3].IsUsed = false;
                _local3++;
            };
        }
        public function showItems(_arg1:Array):void{
            var _local2:UseItem;
            var _local3:int;
            if (NPCShopConstData.GridUnitList.length == 0){
                return;
            };
            while (_local3 < _arg1.length) {
                NPCShopConstData.GridUnitList[_local3].HasBag = true;
                if (_arg1[_local3] == undefined){
                } else {
                    _local2 = new UseItem(_arg1[_local3].index, _arg1[_local3].type, gridSprite);
                    _local2.Num = _arg1[_local3].Count;
                    _local2.x = (NPCShopConstData.GridUnitList[_local3].Grid.x + 2);
                    _local2.y = (NPCShopConstData.GridUnitList[_local3].Grid.y + 2);
                    _local2.Id = _arg1[_local3].ItemGUID;
                    _local2.IsBind = _arg1[_local3].isBind;
                    _local2.Type = _arg1[_local3].type;
                    _local2.IsLock = false;
                    NPCShopConstData.GridUnitList[_local3].Item = _local2;
                    NPCShopConstData.GridUnitList[_local3].IsUsed = true;
                    gridSprite.addChild(_local2);
                };
                _local3++;
            };
        }
        private function init():void{
            var _local1:GridUnit;
            var _local2:int;
            redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
            redFrame.name = "redFrame";
            yellowFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowFrame");
            yellowFrame.name = "yellowFrame";
            redFrame.mouseEnabled = false;
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
        public function addItem(_arg1:int):void{
            var _local2:UseItem = new UseItem(NPCShopConstData.goodSaleList[_arg1].index, NPCShopConstData.goodSaleList[_arg1].type, gridSprite, NPCShopConstData.goodSaleList[_arg1].ItemGUID);
            _local2.Num = NPCShopConstData.goodSaleList[_arg1].Count;
            _local2.x = (NPCShopConstData.GridUnitList[_arg1].Grid.x + 2);
            _local2.y = (NPCShopConstData.GridUnitList[_arg1].Grid.y + 2);
            _local2.Id = NPCShopConstData.goodSaleList[_arg1].ItemGUID;
            _local2.IsBind = NPCShopConstData.goodSaleList[_arg1].isBind;
            _local2.Type = NPCShopConstData.goodSaleList[_arg1].type;
            _local2.IsLock = false;
            NPCShopConstData.GridUnitList[_arg1].Item = _local2;
            NPCShopConstData.GridUnitList[_arg1].IsUsed = true;
            gridSprite.addChild(_local2);
        }
        private function shoptobag(_arg1:uint):void{
            sendNotification(EventList.BAGITEMUNLOCK, _arg1);
            removeItem(_arg1);
            var _local2:uint;
            while (_local2 < NPCShopConstData.goodSaleList.length) {
                if (NPCShopConstData.goodSaleList[_local2].ItemGUID == _arg1){
                    NPCShopConstData.goodSaleList.splice(_local2, 1);
                    break;
                };
                _local2++;
            };
            sendNotification(NPCShopEvent.UPDATENPCSALEMONEY);
            removeAllItem();
            showItems(NPCShopConstData.goodSaleList);
            if (dataProxy.BagIsDrag){
                dataProxy.BagIsDrag = false;
            };
        }
        public function Initialize():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        public function removeItem(_arg1:int):void{
            var _local2:int;
            while (_local2 < NPCShopConstData.GridUnitList.length) {
                if (NPCShopConstData.GridUnitList[_local2].Item){
                    if (NPCShopConstData.GridUnitList[_local2].Item.Id == _arg1){
                        removeChild(NPCShopConstData.GridUnitList[_local2].Item);
                        NPCShopConstData.GridUnitList[_local2].Item = null;
                        NPCShopConstData.GridUnitList[_local2].IsUsed = false;
                        if (NPCShopConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame")){
                            NPCShopConstData.GridUnitList[_local2].Grid.parent.removeChild(NPCShopConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame"));
                        };
                        if (NPCShopConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame")){
                            NPCShopConstData.GridUnitList[_local2].Grid.parent.removeChild(NPCShopConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame"));
                        };
                    };
                };
                _local2++;
            };
        }
        private function removeChild(_arg1:DisplayObject):void{
            if (gridSprite.contains(_arg1)){
                gridSprite.removeChild(_arg1);
            };
        }

    }
}//package GameUI.Modules.NPCShop.Proxy 
