//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCShop.Data {
    import flash.utils.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class NPCShopConstData {

        public static var GridUnitList:Array = [];
        public static var currType:uint = 0;
        public static var tradeResultObj:Object = {
            1:"玩家不在NPC旁",
            2:"找不到该商品或物品不支持本交易",
            3:"玩家金钱不足",
            4:"NPC不存在",
            5:"背包空位不足"
        };
        public static var goodTypeIdList:Array = [];
        public static var TmpIndex:int = 0;
        public static var currMosterID:uint;
        public static var currPage:int = 0;
        public static var goodSaleList:Array = [];
        public static var payWay:uint = 0;
        public static var COUNT_PER_PAGE:uint = 8;
        public static var SelectedItem:GridUnit = null;
        public static var selectedIndex:int = -1;
        public static var goodList:Dictionary = new Dictionary();

        public static function getNPCShopItemById(_arg1:uint):ShopItemInfo{
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
}//package GameUI.Modules.NPCShop.Data 
