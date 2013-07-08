//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Task.Model.*;
    import Utils.*;
    import GameUI.*;

    public class EquPanel extends Sprite {

        public var changeSelectedGood:Function;
        protected var padding:uint = 10;
        private var rowNum:uint = 0;
        protected var goods:Array;
        protected var choose:Boolean;
        protected var cells:Array;
        private var checkJob:Boolean;
        protected var selectedIndex:int = -1;

        public function EquPanel(_arg1:Array=null, _arg2:Boolean=true, _arg3:Boolean=true, _arg4:uint=0){
            this.goods = _arg1;
            this.choose = _arg2;
            this.rowNum = _arg4;
            this.checkJob = _arg3;
            this.mouseEnabled = false;
            this.createChildren();
        }
        protected function onGridUintClick(_arg1:MouseEvent):void{
            var _local4:uint;
            var _local2:uint = _arg1.target.index;
            var _local3:uint = this.cells.length;
            while (_local4 < _local3) {
                SetFrame.RemoveFrame(this.cells[_local4]);
                _local4++;
            };
            var _local5:UseItem = ((this.cells[_local2] as MovieClip).getChildAt(1) as UseItem);
            SetFrame.UseFrame(_local5);
            if (this.changeSelectedGood != null){
                this.changeSelectedGood(goods[_local2].ItemId);
            };
        }
        protected function doLayout():void{
            var _local1:MovieClip;
            var _local4:int;
            var _local2:Number = 0;
            var _local3:Number = 0;
            _local4 = 0;
            for each (_local1 in this.cells) {
                if (rowNum == 0){
                    _local1.x = (_local2 + (_local4 * (_local1.width + padding)));
                    _local1.y = _local3;
                } else {
                    _local1.x = (_local2 + ((_local4 % rowNum) * (_local1.width + padding)));
                    _local1.y = (_local3 + (int((_local4 / rowNum)) * (_local1.height + padding)));
                };
                _local4++;
            };
        }
        protected function createChildren():void{
            var _local1:MovieClip;
            var _local2:UseItem;
            var _local5:QuestItemReward;
            this.cells = [];
            var _local3:uint = goods.length;
            var _local4:uint;
            while (_local4 < _local3) {
                _local5 = goods[_local4];
                if (((((checkJob) && (UIConstData.ItemDic[_local5.ItemId]))) && (!((UIConstData.ItemDic[_local5.ItemId].Job == 0))))){
                    //unresolved if
                    _local4++;
                } else {
                    _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                    _local2 = new UseItem(_local4, _local5.ItemId, this);
                    _local2.Num = _local5.Count;
                    _local2.x = 2;
                    _local2.y = 2;
                    _local1.addChildAt(_local2, 1);
                    _local1.name = ("TaskEqu_" + _local5.ItemId);
                    _local1.index = _local4;
                    if (this.choose){
                    };
                    this.cells.push(_local1);
                    this.addChild(_local1);
                    _local4++;
                };
            };
            this.doLayout();
        }
        public function getUseItemBy(_arg1:int):MovieClip{
            var _local2:MovieClip;
            var _local4:int;
            var _local3:int;
            while (_local3 < cells.length) {
                _local2 = cells[_local3];
                if (_local2){
                    _local4 = 0;
                    while (_local4 < _local2.numChildren) {
                        if ((((_local2.getChildAt(_local4) is UseItem)) && (((_local2.getChildAt(_local4) as UseItem).Type == _arg1)))){
                            return (_local2);
                        };
                        _local4++;
                    };
                };
                _local3++;
            };
            return (null);
        }

    }
}//package GameUI.Modules.Task.View 
