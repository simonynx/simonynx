//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCExchange.Data {
    import flash.utils.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class NPCExchangeConstData {

        public static const TRADE_ERROR_NONE = 0;
        public static const TRADE_ERROR_POSITION = 1;
        public static const TRADE_ERROR_MONEY = 3;
        public static const TRADE_ERROR_SLOT = 5;
        public static const TRADE_ERROR_ITEM = 2;
        public static const TRADE_ERROR_EXISTANCE = 4;

        public static var GridUnitList:Array = [];
        public static var currType:uint = 0;
        public static var goodTypeIdList:Array = [];
        public static var TmpIndex:int = 0;
        public static var currMosterID:uint;
        public static var currPage:int = 0;
        public static var goodSaleList:Array = [];
        public static var payWay:uint = 0;
        public static var towerMosterID:uint;
        public static var SelectedItem:GridUnit = null;
        public static var selectedIndex:int = -1;
        public static var goodList:Dictionary = new Dictionary();

        public static function getGridById(_arg1:uint):GridUnit{
            var _local2:uint;
            while (_local2 < goodList[currMosterID][currType].length) {
                if (goodList[currMosterID][currType][_local2].TemplateID == _arg1){
                    return (GridUnitList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public static function getNPCExchangeItemById(_arg1:uint):ShopItemInfo{
            if ((((goodList[currMosterID] == null)) || ((goodList[currMosterID][currType] == null)))){
                return (null);
            };
            var _local2:uint;
            while (_local2 < goodList[currMosterID][currType].length) {
                if (goodList[currMosterID][currType][_local2].TemplateID == _arg1){
                    return (goodList[currMosterID][currType][_local2]);
                };
                _local2++;
            };
            return (null);
        }

    }
}//package GameUI.Modules.NPCExchange.Data 
