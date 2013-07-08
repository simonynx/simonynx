//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Mediator.DealItem {
    import GameUI.ConstData.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;

    public class SplitItem {

        public static function Split(_arg1:GridUnit, _arg2:uint):void{
            var _local5:uint;
            var _local6:uint;
            var _local3:int = _arg1.Index;
            var _local4:uint = ItemConst.gridUnitToPlace(BagData.SelectIndex, _local3);
            if (BagData.SelectIndex == 0){
                _local5 = ItemConst.NORMAL_SLOT_START;
            } else {
                if (BagData.SelectIndex == 1){
                    _local5 = ItemConst.QUEST_SLOT_START;
                } else {
                    if (BagData.SelectIndex == 2){
                        _local5 = ItemConst.MATERIAL_SLOT_START;
                    };
                };
            };
            var _local7:uint;
            while (_local7 < 42) {
                if (BagData.AllItems[BagData.SelectIndex][_local7] == null){
                    _local6 = (_local7 + _local5);
                    break;
                };
                _local7++;
            };
            BagInfoSend.ItemSplit(_local4, _local6, _arg2);
        }

    }
}//package GameUI.Modules.Bag.Mediator.DealItem 
