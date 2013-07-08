//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Depot.Data {
    import OopsEngine.Role.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class DepotConstData {

        public static const EXTENDS_DEFAULT_POS:Point = new Point(540, 120);
        public static const DEPOT_DEFAULT_POS:Point = new Point(200, 60);
        public static const MONEY_DEFAULT_POS:Point = new Point(420, 150);
        public static const PANEL_DEFAULT_POS:Point = new Point(0, 17);

        public static var itemExtIsOpen:Boolean = false;
        public static var depot_0_lock:Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
        public static var GridUnitList:Array = new Array();
        public static var goodList:Array = new Array(42);
        public static var moneyDepot:int = 0;
        public static var SelectIndex:int = 0;
        public static var TmpIndex:int = 0;
        public static var curDepotIndex:int = 0;
        public static var gridCount:int = 18;
        public static var moneySelf:int = 0;
        public static var SelectedItem:GridUnit = null;
        public static var curMoneyType:int = 0;

        public static function getItemById(_arg1):InventoryItemInfo{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < goodList.length) {
                if (((goodList[_local2]) && ((goodList[_local2].ItemGUID == _arg1)))){
                    return (goodList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public static function getHasUseNum():int{
            var _local1:uint;
            var _local2:uint;
            _local2 = 0;
            while (_local2 < gridCount) {
                if (GridUnitList[_local2].HasBag){
                    if (GridUnitList[_local2].IsUsed){
                        _local1++;
                    };
                };
                _local2++;
            };
            return (_local1);
        }
        public static function findEmptyPos():int{
            var _local1:uint;
            _local1 = 0;
            while (_local1 < gridCount) {
                if (GridUnitList[_local1].HasBag){
                    if (GridUnitList[_local1].IsUsed == false){
                        return (_local1);
                    };
                };
                _local1++;
            };
            return (-1);
        }

    }
}//package GameUI.Modules.Depot.Data 
