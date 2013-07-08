//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import GameUI.View.items.*;
    import Net.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.View.*;
    import OopsEngine.AI.PathFinder.*;
    import OopsEngine.Graphics.*;

    public class MapItem extends GameAction {

        public function MapItem(_arg1:Boolean=true){
            super(_arg1);
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            SysCursor.GetInstance().revert();
            (_arg1.currentTarget as DragItem).filters = null;
        }
        protected function onRemoveFromStageHandler(_arg1:Event):void{
            var _local2:DragItem = (_arg1.target as DragItem);
            _local2.hideTip();
            _local2.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            _local2.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            _local2.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStageHandler);
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local2:uint;
            var _local3:*;
            var _local4:DragItem;
            var _local5:uint;
            switch (_arg1.opcode){
                case Protocol.SMSG_LOOT_DROPITEM:
                    _local2 = _arg1.readUnsignedInt();
                    _local3 = 0;
                    while (_local3 < _local2) {
                        _local4 = new DragItem();
                        if (GameCommonData.IsSelfDead){
                            _local4.filters = [ColorFilters.BWFilter];
                        };
                        _local4.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
                        _local4.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                        _local4.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStageHandler);
                        _local4.ID = _arg1.readUnsignedInt();
                        _local4.name = ("Package_" + _local4.ID);
                        _local5 = _arg1.readUnsignedInt();
                        _local4.TileX = _arg1.readInt();
                        _local4.TileY = _arg1.readInt();
                        _local4.OwnerTime = _arg1.readUnsignedInt();
                        _local4.OwnerGUID = _arg1.readUnsignedInt();
                        _local4.Data = _local5;
                        _local4.isPicked = false;
                        ShowPackage(_local4.ID, _local4);
                        _local4.showTip();
                        _local3++;
                    };
                    break;
                case Protocol.SMSG_LOOT_REMOVED:
                    break;
            };
        }
        private function onMouseOver(_arg1:MouseEvent):void{
            SysCursor.GetInstance().setMouseType(SysCursor.PICK_CURSOR);
            (_arg1.currentTarget as DragItem).filters = Font.ObjectFilter();
        }
        private function ShowPackage(_arg1:uint, _arg2:DragItem):void{
            var _local3:Point;
            if (GameCommonData.Scene.IsSceneLoaded == true){
                _local3 = MapTileModel.GetTilePointToStage(_arg2.TileX, _arg2.TileY);
                _arg2.x = _local3.x;
                _arg2.y = _local3.y;
                GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.addChild(_arg2);
                GameCommonData.PackageList[_arg1] = _arg2;
            };
            if (GameCommonData.Player.IsAutomatism){
            };
        }

    }
}//package Net.PackHandler 
