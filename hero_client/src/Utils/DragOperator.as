//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import flash.ui.*;

    public class DragOperator extends Sprite {

        public static const WIDTH:uint = 32;
        public static const HEIGHT:uint = 32;

        private var startDragTmp:Sprite = null;
        private var dataProxy:DataProxy;
        private var iconMC:MovieClip;
        private var bag:Sprite;
        private var icon:Bitmap;

        public function DragOperator(_arg1:Sprite, _arg2:uint){
            var _local3:Bitmap;
            super();
            bag = _arg1;
            if (_arg2 == 0){
                _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("Split");
            } else {
                if (_arg2 == 1){
                    _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("Throw");
                };
            };
            iconMC = new MovieClip();
            iconMC.addChild(_local3);
            dataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        private function gameUIMouseDown(_arg1:MouseEvent):void{
            var _local2:String;
            GameCommonData.GameInstance.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.GameUI.mouseEnabled = false;
            GameCommonData.GameInstance.WorldMap.mouseEnabled = true;
            if (startDragTmp){
                startDragTmp.stopDrag();
                GameCommonData.GameInstance.GameUI.removeChild(startDragTmp);
                startDragTmp = null;
            };
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.MainStage.removeEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            Mouse.show();
            _local2 = _arg1.target.name.split("_")[0];
            _local2 = _arg1.target.name.split("_")[0];
            if (_local2 != "bag"){
                dataProxy.BagIsSplit = false;
                dataProxy.BagIsDestory = false;
                _arg1.stopImmediatePropagation();
            };
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            GameCommonData.GameInstance.GameUI.setChildIndex(startDragTmp, (GameCommonData.GameInstance.GameUI.numChildren - 1));
            _arg1.updateAfterEvent();
        }
        private function mouseOutHandler(_arg1:MouseEvent):void{
            gc();
        }
        public function setDrag(_arg1:MouseEvent):void{
            startDragTmp = new Sprite();
            startDragTmp.addChild(iconMC);
            startDragTmp.mouseChildren = false;
            startDragTmp.mouseEnabled = false;
            var _local2:Point = new Point();
            _local2.x = GameCommonData.GameInstance.MainStage.mouseX;
            _local2.y = GameCommonData.GameInstance.MainStage.mouseY;
            if (_arg1.target.parent.name == "btnSplit"){
                startDragTmp.name = "SplitOperator";
                dataProxy.BagIsSplit = true;
            } else {
                if (_arg1.target.parent.name == "btnDrop"){
                    startDragTmp.name = "DestoryOperator";
                    dataProxy.BagIsDestory = true;
                };
            };
            startDragTmp.x = _local2.x;
            startDragTmp.y = _local2.y;
            startDragTmp.startDrag();
            GameCommonData.GameInstance.GameUI.mouseEnabled = true;
            GameCommonData.GameInstance.GameUI.addChild(startDragTmp);
            GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.MainStage.addEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            GameCommonData.GameInstance.WorldMap.mouseEnabled = false;
        }
        public function gc():void{
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.GameUI.mouseEnabled = false;
            if (startDragTmp){
                startDragTmp.stopDrag();
                GameCommonData.GameInstance.GameUI.removeChild(startDragTmp);
                startDragTmp = null;
            };
            Mouse.show();
        }

    }
}//package Utils 
