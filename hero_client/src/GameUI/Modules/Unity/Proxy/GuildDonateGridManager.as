//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Unity.Proxy {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;

    public class GuildDonateGridManager extends Proxy {

        public static const NAME:String = "GuildDonateGridManager";

        private var gridList:Array;
        private var gridSprite:MovieClip;
        private var yellowFrame:MovieClip;
        private var redFrame:MovieClip = null;

        public function GuildDonateGridManager(_arg1:Array, _arg2:MovieClip){
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
        private function returnItem(_arg1:ItemBase):void{
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            _arg1.parent.addChild(yellowFrame);
            UnityConstData.SelectedItem = UnityConstData.GridUnitList[_arg1.Pos];
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (UnityConstData.SelectedItem){
                if (_arg1.currentTarget.name.split("_")[1] == UnityConstData.SelectedItem.Index){
                    return;
                };
            };
            _arg1.currentTarget.parent.addChild(redFrame);
            redFrame.x = _arg1.currentTarget.x;
            redFrame.y = _arg1.currentTarget.y;
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
        public function showItems(_arg1:Array):void{
            var _local2:UseItem;
            var _local3:int;
            if (UnityConstData.GridUnitList.length == 0){
                return;
            };
            while (_local3 < _arg1.length) {
                UnityConstData.GridUnitList[_local3].HasBag = true;
                if (_arg1[_local3] == undefined){
                } else {
                    _local2 = new UseItem(_arg1[_local3].index, _arg1[_local3].type, gridSprite);
                    _local2.Num = _arg1[_local3].Count;
                    _local2.x = (UnityConstData.GridUnitList[_local3].Grid.x + 2);
                    _local2.y = (UnityConstData.GridUnitList[_local3].Grid.y + 2);
                    _local2.Id = _arg1[_local3].id;
                    _local2.IsBind = _arg1[_local3].isBind;
                    _local2.Type = _arg1[_local3].type;
                    _local2.IsLock = false;
                    UnityConstData.GridUnitList[_local3].Item = _local2;
                    UnityConstData.GridUnitList[_local3].IsUsed = true;
                    gridSprite.addChild(_local2);
                };
                _local3++;
            };
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            var _local3:int;
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
                UnityConstData.TmpIndex = gridList[_local3].Index;
                gridList[_local3].Item.onMouseDown();
                _arg1.currentTarget.parent.addChild(yellowFrame);
                yellowFrame.x = _arg1.currentTarget.x;
                yellowFrame.y = _arg1.currentTarget.y;
                UnityConstData.SelectedItem = gridList[_local3];
                return;
            };
            UnityConstData.SelectedItem = null;
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
            var _local2:UseItem = new UseItem(UnityConstData.goodSaleList[_arg1].index, UnityConstData.goodSaleList[_arg1].type, gridSprite);
            _local2.Num = UnityConstData.goodSaleList[_arg1].Count;
            var _local3:Array = UnityConstData.GridUnitList;
            _local2.x = (UnityConstData.GridUnitList[_arg1].Grid.x + 2);
            _local2.y = (UnityConstData.GridUnitList[_arg1].Grid.y + 2);
            _local2.Id = UnityConstData.goodSaleList[_arg1].id;
            _local2.IsBind = UnityConstData.goodSaleList[_arg1].isBind;
            _local2.Type = UnityConstData.goodSaleList[_arg1].type;
            _local2.IsLock = false;
            UnityConstData.GridUnitList[_arg1].Item = _local2;
            UnityConstData.GridUnitList[_arg1].IsUsed = true;
            gridSprite.addChild(_local2);
        }
        public function removeItem(_arg1:int):void{
            var _local2:int;
            while (_local2 < UnityConstData.GridUnitList.length) {
                if (UnityConstData.GridUnitList[_local2].Item){
                    if (UnityConstData.GridUnitList[_local2].Item.Id == _arg1){
                        removeChild(UnityConstData.GridUnitList[_local2].Item);
                        UnityConstData.GridUnitList[_local2].Item = null;
                        UnityConstData.GridUnitList[_local2].IsUsed = false;
                        if (UnityConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame")){
                            UnityConstData.GridUnitList[_local2].Grid.parent.removeChild(UnityConstData.GridUnitList[_local2].Grid.parent.getChildByName("redFrame"));
                        };
                        if (UnityConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame")){
                            UnityConstData.GridUnitList[_local2].Grid.parent.removeChild(UnityConstData.GridUnitList[_local2].Grid.parent.getChildByName("yellowFrame"));
                        };
                    };
                };
                _local2++;
            };
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            var _local3:int;
            var _local2:int = _arg1.currentTarget.name.split("_")[1];
            if (((UnityConstData.goodSaleList) && (UnityConstData.goodSaleList[_local2]))){
                sendNotification(EventList.BAGITEMUNLOCK, UnityConstData.goodSaleList[_local2].id);
                removeItem(UnityConstData.goodSaleList[_local2].id);
                _local3 = 0;
                while (_local3 < UnityConstData.goodSaleList.length) {
                    if (UnityConstData.goodSaleList[_local3].id == UnityConstData.goodSaleList[_local2].id){
                        UnityConstData.goodSaleList.splice(_local3, 1);
                        break;
                    };
                    _local3++;
                };
                removeAllItem();
                showItems(UnityConstData.goodSaleList);
            };
        }
        public function removeAllItem():void{
            var _local1:ItemBase;
            var _local2:int;
            var _local3:int;
            var _local4:Object;
            if (gridSprite != null){
                _local2 = (gridSprite.numChildren - 1);
                while (_local2 >= 0) {
                    if ((gridSprite.getChildAt(_local2) is ItemBase)){
                        _local1 = (gridSprite.getChildAt(_local2) as ItemBase);
                        gridSprite.removeChild(_local1);
                        _local1 = null;
                    };
                    _local2--;
                };
                _local4 = UnityConstData.GridUnitList;
                while (_local3 < 18) {
                    if (((((((UnityConstData.GridUnitList) && (UnityConstData.GridUnitList[_local3]))) && (UnityConstData.GridUnitList[_local3].Grid))) && (UnityConstData.GridUnitList[_local3].Grid.parent))){
                        if (UnityConstData.GridUnitList[_local3].Grid.parent.getChildByName("redFrame")){
                            UnityConstData.GridUnitList[_local3].Grid.parent.removeChild(UnityConstData.GridUnitList[_local3].Grid.parent.getChildByName("redFrame"));
                        };
                        if (UnityConstData.GridUnitList[_local3].Grid.parent.getChildByName("yellowFrame")){
                            UnityConstData.GridUnitList[_local3].Grid.parent.removeChild(UnityConstData.GridUnitList[_local3].Grid.parent.getChildByName("yellowFrame"));
                        };
                    };
                    if (((UnityConstData.GridUnitList) && (UnityConstData.GridUnitList[_local3]))){
                        UnityConstData.GridUnitList[_local3].Item = null;
                        UnityConstData.GridUnitList[_local3].IsUsed = false;
                    };
                    _local3++;
                };
            };
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            var _local2:int;
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            switch (_arg1.Data.type){
                case "bag":
                    sendNotification(EventList.BAGITEMUNLOCK, _arg1.Data.source.Id);
                    removeItem(_arg1.Data.source.Id);
                    _local2 = 0;
                    while (_local2 < UnityConstData.goodSaleList.length) {
                        if (UnityConstData.goodSaleList[_local2].id == _arg1.Data.source.Id){
                            UnityConstData.goodSaleList.splice(_local2, 1);
                            break;
                        };
                        _local2++;
                    };
                    removeAllItem();
                    showItems(UnityConstData.goodSaleList);
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        private function removeChild(_arg1:DisplayObject):void{
            if (gridSprite.contains(_arg1)){
                gridSprite.removeChild(_arg1);
            };
        }

    }
}//package GameUI.Modules.Unity.Proxy 
