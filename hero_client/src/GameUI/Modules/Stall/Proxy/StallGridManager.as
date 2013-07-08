//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Stall.Proxy {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    import GameUI.Modules.Stall.Data.*;

    public class StallGridManager extends Proxy {

        public static const NAME:String = "StallGridManager";

        private var gridList:Array;
        private var yellowFrame:MovieClip = null;
        private var redFrame:MovieClip = null;
        private var dataProxy:DataProxy = null;
        private var gridSprite:Sprite;

        public function StallGridManager(_arg1:Array, _arg2:Sprite){
            gridList = new Array();
            super(NAME);
            this.gridList = _arg1;
            this.gridSprite = _arg2;
            init();
        }
        public function lockGrids():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.mouseEnabled = false;
                _local2++;
            };
        }
        public function removeMouseDown():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, enableMouseDown);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, disableMouseDown);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, disableMouseDown);
                _local2++;
            };
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            switch (_arg1.Data.type){
                case "bag":
                    facade.sendNotification(StallEvents.DELSTALLITEM, {
                        index:StallConstData.TmpIndex,
                        id:_arg1.Data.source.Id
                    });
                    if (dataProxy.BagIsDrag){
                        dataProxy.BagIsDrag = false;
                    };
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        public function addMouseDown():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, enableMouseDown);
                _local1.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, disableMouseDown);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, enableMouseDown);
                _local2++;
            };
        }
        public function removeAllFrames():void{
            var _local1:int;
            while (_local1 < StallConstData.GRID_NUM) {
                if (StallConstData.GridUnitList[_local1].Grid.parent.getChildByName("redFrame")){
                    StallConstData.GridUnitList[_local1].Grid.parent.removeChild(StallConstData.GridUnitList[_local1].Grid.parent.getChildByName("redFrame"));
                };
                if (StallConstData.GridUnitList[_local1].Grid.parent.getChildByName("yellowFrame")){
                    StallConstData.GridUnitList[_local1].Grid.parent.removeChild(StallConstData.GridUnitList[_local1].Grid.parent.getChildByName("yellowFrame"));
                };
                _local1++;
            };
        }
        private function init():void{
            var _local1:GridUnit;
            redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
            redFrame.name = "redFrame";
            redFrame.mouseEnabled = false;
            yellowFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowFrame");
            yellowFrame.name = "yellowFrame";
            yellowFrame.mouseEnabled = false;
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        public function showItems(_arg1:Array):void{
            var _local2:UseItem;
            var _local3:int;
            while (_local3 < _arg1.length) {
                if (_arg1[_local3] == undefined){
                } else {
                    _local2 = new UseItem(_local3, _arg1[_local3].type, gridSprite);
                    _local2.name = ("upitem" + _local3);
                    _local2.Num = _arg1[_local3].Count;
                    _local2.x = (StallConstData.GridUnitList[_local3].Grid.x + 2);
                    _local2.y = (StallConstData.GridUnitList[_local3].Grid.y + 2);
                    _local2.Id = _arg1[_local3].id;
                    _local2.IsBind = _arg1[_local3].isBind;
                    _local2.Type = _arg1[_local3].type;
                    _local2.IsLock = false;
                    StallConstData.GridUnitList[_local3].Item = _local2;
                    StallConstData.GridUnitList[_local3].IsUsed = true;
                    gridSprite.addChild(_local2);
                };
                _local3++;
            };
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            if ((((GameCommonData.Player.Role.isStalling > 0)) || (((!((GameCommonData.Player.Role.Id == StallConstData.stallIdToQuery))) && (!((StallConstData.stallIdToQuery == 0))))))){
                return;
            };
            var _local2:* = int(_arg1.target.name.split("_")[1]);
            var _local3:uint;
            while (_local3 < StallConstData.goodUpList.length) {
                if (((!((StallConstData.goodUpList[_local3] == null))) && (!((StallConstData.goodUpList[_local2] == null))))){
                    if (StallConstData.goodUpList[_local3].id == StallConstData.goodUpList[_local2].id){
                        sendNotification(EventList.BAGITEMUNLOCK, StallConstData.goodUpList[_local3].id);
                        StallConstData.goodUpList.splice(_local3, 1);
                        StallConstData.goodUpList.push(null);
                        StallConstData.sellNum--;
                        StallConstData.idToPlace1--;
                        break;
                    };
                };
                _local3++;
            };
            removeAllItem();
            showItems(StallConstData.goodUpList);
        }
        public function refreshItemNum(_arg1:uint, _arg2:uint):void{
            StallConstData.GridUnitList[_arg1].Item.Num = String(_arg2);
        }
        private function disableMouseDown(_arg1:MouseEvent):void{
            var _local2:Object;
            var _local3:int;
            var _local4:int;
            var _local5:String;
            var _local6:int;
            var _local7:int;
            var _local8:* = undefined;
            var _local9:uint;
            var _local10:Object;
            var _local11:GameElementAnimal;
            var _local12:Object;
            var _local13:* = (_arg1.currentTarget.parent.numChildren - 1);
            while (_local13) {
                if (_arg1.currentTarget.parent.getChildByName("yellowFrame")){
                    _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("yellowFrame"));
                };
                _local13--;
            };
            var _local14:* = int(_arg1.target.name.split("_")[1]);
            if (gridList[_local14].Item){
                if (gridList[_local14].Item.IsLock){
                    return;
                };
                _local2 = gridList[_local14].Item;
                StallConstData.TmpIndex = gridList[_local14].Index;
                StallConstData.SelectedItem = gridList[_local14];
                sendNotification(StallEvents.REFRESHMONEY);
                sendNotification(StallEvents.RESETCOUNT, 1);
                _arg1.currentTarget.parent.addChild(yellowFrame);
                yellowFrame.x = _arg1.currentTarget.x;
                yellowFrame.y = _arg1.currentTarget.y;
                return;
            };
            StallConstData.SelectedItem = null;
            sendNotification(StallEvents.REFRESHMONEY);
        }
        private function returnItem(_arg1:ItemBase):void{
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            _arg1.parent.addChild(yellowFrame);
            StallConstData.SelectedItem = StallConstData.GridUnitList[_arg1.Pos];
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (_arg1.currentTarget.parent.getChildByName("redFrame")){
                _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("redFrame"));
            };
        }
        public function unLockGrids():void{
            var _local1:GridUnit;
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.mouseEnabled = true;
                _local2++;
            };
        }
        private function enableMouseDown(_arg1:MouseEvent):void{
            if (dataProxy.BagIsDrag){
                return;
            };
            var _local2:DisplayObject;
            var _local3:Object;
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local7:int;
            var _local8:uint;
            var _local9:Object;
            var _local10:Object;
            var _local11:* = (_arg1.currentTarget.parent.numChildren - 1);
            while (_local11) {
                if (_arg1.currentTarget.parent.getChildByName("yellowFrame")){
                    _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("yellowFrame"));
                };
                _local11--;
            };
            var _local12:* = int(_arg1.target.name.split("_")[1]);
            if (gridList[_local12].Item){
                if (gridList[_local12].Item.IsLock){
                    return;
                };
                _local2 = (_arg1.target as DisplayObject);
                if ((((_local2.mouseX <= 2)) || ((_local2.mouseX >= (_local2.width - 2))))){
                    return;
                };
                if ((((_local2.mouseY <= 2)) || ((_local2.mouseY >= (_local2.height - 2))))){
                    return;
                };
                _local3 = gridList[_local12].Item;
                gridList[_local12].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
                StallConstData.TmpIndex = gridList[_local12].Index;
                StallConstData.SelectedItem = gridList[_local12];
                sendNotification(StallEvents.REFRESHMONEY);
                gridList[_local12].Item.onMouseDown();
                _arg1.currentTarget.parent.addChild(yellowFrame);
                yellowFrame.x = _arg1.currentTarget.x;
                yellowFrame.y = _arg1.currentTarget.y;
                return;
            };
            StallConstData.SelectedItem = null;
            sendNotification(StallEvents.REFRESHMONEY);
        }
        public function Initialize():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        public function removeItem(_arg1:uint):void{
            gridSprite.removeChild(gridSprite.getChildByName(("upitem" + _arg1)));
            if (StallConstData.GridUnitList[_arg1].Grid.parent.getChildByName("redFrame")){
                StallConstData.GridUnitList[_arg1].Grid.parent.removeChild(StallConstData.GridUnitList[_arg1].Grid.parent.getChildByName("redFrame"));
            };
            if (StallConstData.GridUnitList[_arg1].Grid.parent.getChildByName("yellowFrame")){
                StallConstData.GridUnitList[_arg1].Grid.parent.removeChild(StallConstData.GridUnitList[_arg1].Grid.parent.getChildByName("yellowFrame"));
            };
            StallConstData.GridUnitList[_arg1].Item = null;
            StallConstData.GridUnitList[_arg1].IsUsed = false;
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (StallConstData.SelectedItem){
                if ((((_arg1.currentTarget.name.split("_")[0] == "stall")) && ((_arg1.currentTarget.name.split("_")[1] == StallConstData.SelectedItem.Index)))){
                    return;
                };
            };
            _arg1.currentTarget.parent.addChild(redFrame);
            redFrame.x = _arg1.currentTarget.x;
            redFrame.y = _arg1.currentTarget.y;
        }
        public function removeAllItem():void{
            var _local1:ItemBase;
            var _local2:* = (gridSprite.numChildren - 1);
            while (_local2 >= 0) {
                if ((gridSprite.getChildAt(_local2) is ItemBase)){
                    _local1 = (gridSprite.getChildAt(_local2) as ItemBase);
                    gridSprite.removeChild(_local1);
                    _local1 = null;
                };
                _local2--;
            };
            var _local3:int;
            while (_local3 < StallConstData.GRID_NUM) {
                if (StallConstData.GridUnitList[_local3].Grid.parent.getChildByName("redFrame")){
                    StallConstData.GridUnitList[_local3].Grid.parent.removeChild(StallConstData.GridUnitList[_local3].Grid.parent.getChildByName("redFrame"));
                };
                if (StallConstData.GridUnitList[_local3].Grid.parent.getChildByName("yellowFrame")){
                    StallConstData.GridUnitList[_local3].Grid.parent.removeChild(StallConstData.GridUnitList[_local3].Grid.parent.getChildByName("yellowFrame"));
                };
                StallConstData.GridUnitList[_local3].Item = null;
                StallConstData.GridUnitList[_local3].IsUsed = false;
                _local3++;
            };
        }

    }
}//package GameUI.Modules.Stall.Proxy 
