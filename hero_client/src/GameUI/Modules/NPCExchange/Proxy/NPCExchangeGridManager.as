//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCExchange.Proxy {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    import GameUI.Modules.NPCExchange.Data.*;

    public class NPCExchangeGridManager extends Proxy {

        public static const NAME:String = "NPCExchangeGridManager";

        private var dataProxy:DataProxy = null;
        private var gridList:Array;
        private var yellowFrame:MovieClip = null;
        private var gridSprite:MovieClip;
        private var redFrame:MovieClip = null;

        public function NPCExchangeGridManager(_arg1:Array, _arg2:MovieClip){
            gridList = new Array();
            super(NAME);
            this.gridList = _arg1;
            this.gridSprite = _arg2;
            init();
        }
        public function onMouseDown(_arg1:MouseEvent):void{
            var _local2:uint;
            var _local3:MovieClip;
            if (_arg1){
                _local2 = _arg1.currentTarget.name.split("_")[1];
            } else {
                _local2 = NPCExchangeConstData.selectedIndex;
            };
            if (NPCExchangeConstData.goodList[NPCExchangeConstData.currMosterID][NPCExchangeConstData.currType][_local2]){
                if (_arg1){
                    _local3 = (_arg1.currentTarget as MovieClip);
                } else {
                    if (NPCExchangeConstData.GridUnitList[_local2]){
                        _local3 = NPCExchangeConstData.GridUnitList[_local2].Grid;
                    };
                };
                if (((_local3) && (_local3.parent))){
                    _local3.parent.addChild(redFrame);
                    redFrame.x = _local3.x;
                    redFrame.y = _local3.y;
                };
            };
        }
        public function dispose():void{
            var _local2:GridUnit;
            var _local1:int;
            while (_local1 < gridList.length) {
                _local2 = (gridList[_local1] as GridUnit);
                _local2.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local2.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local1++;
            };
        }
        public function removeFrame():void{
            redFrame.parent.removeChild(redFrame);
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
                _local1.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _local1.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                _local2++;
            };
        }
        private function onMouseOut(_arg1:MouseEvent):void{
        }
        private function removeChild(_arg1:DisplayObject):void{
            if (gridSprite.contains(_arg1)){
                gridSprite.removeChild(_arg1);
            };
        }
        public function Initialize():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }

    }
}//package GameUI.Modules.NPCExchange.Proxy 
