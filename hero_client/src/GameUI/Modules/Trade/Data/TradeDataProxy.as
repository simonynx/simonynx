//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Trade.Data {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Hint.Events.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;

    public class TradeDataProxy extends Proxy {

        public static const NAME:String = "TradeDataProxy";

        public var moneyOp:uint = 0;
        private var gridList:Array;
        private var gridOpList:Array;
        public var opLocked:Boolean = false;
        private var yellowFrame:MovieClip = null;
        private var redFrame:MovieClip = null;
        private var dataProxy:DataProxy = null;
        public var moneySelf:uint = 0;
        public var goodOpList:Array;
        public var sfLocked:Boolean = false;
        public var goodPetOperating:Object;

        public function TradeDataProxy(_arg1:Array, _arg2:Array){
            gridList = new Array();
            gridOpList = new Array();
            goodOpList = new Array(5);
            goodPetOperating = new Object();
            super(NAME);
            gridList = _arg1;
            gridOpList = _arg2;
            init();
        }
        public function removeAllFrames():void{
            var _local1:int;
            while (_local1 < 5) {
                if (TradeConstData.GridUnitList[_local1].Grid.parent.getChildByName("redFrame")){
                    TradeConstData.GridUnitList[_local1].Grid.parent.removeChild(TradeConstData.GridUnitList[_local1].Grid.parent.getChildByName("redFrame"));
                };
                if (TradeConstData.GridUnitList[_local1].Grid.parent.getChildByName("yellowFrame")){
                    TradeConstData.GridUnitList[_local1].Grid.parent.removeChild(TradeConstData.GridUnitList[_local1].Grid.parent.getChildByName("yellowFrame"));
                };
                _local1++;
            };
        }
        private function dragDroppedHandler(_arg1:DropEvent):void{
            var _local2:uint;
            _arg1.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
            switch (_arg1.Data.type){
                case "bag":
                    if (!sfLocked){
                        _local2 = TradeConstData.TmpIndex;
                        facade.sendNotification(EventList.GOBAGVIEW, TradeConstData.TmpIndex);
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易提示4"),
                            color:0xFFFF00
                        });
                    };
                    if (dataProxy.BagIsDrag){
                        dataProxy.BagIsDrag = false;
                    };
                    break;
                case "mcPhoto":
                    if (dataProxy.BagIsDrag){
                        dataProxy.BagIsDrag = false;
                    };
                    break;
                default:
                    returnItem(_arg1.Data.source);
            };
        }
        private function init():void{
            var _local1:GridUnit;
            redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
            redFrame.name = "redFrame";
            yellowFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowFrame");
            yellowFrame.name = "yellowFrame";
            var _local2:int;
            while (_local2 < gridList.length) {
                _local1 = (gridList[_local2] as GridUnit);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
                _local2++;
            };
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            var _local2:uint;
            if (!sfLocked){
                _local2 = int(_arg1.target.name.split("_")[1]);
                if (TradeConstData.goodSelfList[_local2]){
                    facade.sendNotification(EventList.GOBAGVIEW, TradeConstData.TmpIndex);
                };
            };
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            if (dataProxy.BagIsDrag){
                return;
            };
            var _local2:* = int(_arg1.target.name.split("_")[1]);
            if (!TradeConstData.goodSelfList[_local2]){
                return;
            };
            var _local3:* = (_arg1.currentTarget.parent.numChildren - 1);
            while (_local3) {
                if (_arg1.currentTarget.parent.getChildByName("yellowFrame")){
                    _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("yellowFrame"));
                };
                _local3--;
            };
            var _local4:* = gridList;
            if (gridList[_local2].Item){
                if (gridList[_local2].Item.IsLock){
                    return;
                };
                gridList[_local2].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
                TradeConstData.TmpIndex = gridList[_local2].Index;
                TradeConstData.SelectedItem = gridList[_local2];
                gridList[_local2].Item.onMouseDown();
                _arg1.currentTarget.parent.addChild(yellowFrame);
                yellowFrame.x = _arg1.currentTarget.x;
                yellowFrame.y = _arg1.currentTarget.y;
                return;
            };
            TradeConstData.SelectedItem = null;
        }
        private function returnItem(_arg1:ItemBase):void{
            _arg1.ItemParent.addChild(_arg1);
            _arg1.x = _arg1.tmpX;
            _arg1.y = _arg1.tmpY;
            TradeConstData.SelectedItem = TradeConstData.GridUnitList[_arg1.Pos];
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (_arg1.currentTarget.parent.getChildByName("redFrame")){
                _arg1.currentTarget.parent.removeChild(_arg1.currentTarget.parent.getChildByName("redFrame"));
            };
        }
        public function Initialize():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            _arg1.currentTarget.parent.addChild(redFrame);
            redFrame.x = _arg1.currentTarget.x;
            redFrame.y = _arg1.currentTarget.y;
        }

    }
}//package GameUI.Modules.Trade.Data 
