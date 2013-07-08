//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.Data {
    import flash.display.*;
    import flash.utils.*;
    import GameUI.ConstData.*;

    public class MarketConstData {

        public static const payWayStrList:Array = ["\\zb", "\\dq", "\\ab"];

        public static var IsLoadMarketGoodList:Boolean = false;
        public static var payWayNameList:Array = ["金币", "点券", "银叶子"];
        public static var curSexDress:int = -1;
        public static var SHOPTYPE_SALES:int = 3;
        public static var MarketTypeNameList:Array = ["全部", "强化", "药品", "传送", "神兵", "宠物", "时装", "其它"];
        public static var curPageIndex:uint = 0;
        public static var SHOPTYPE_PLAZA:int = 1;
        public static var SelfDayLimitCntBuyShopItemObj = {};
        public static var SALES_LISTIDX:int = 1000;
        public static var MarketDayLimitCntBuyRecord:Dictionary;
        public static var SHOPTYPE_VENDOR:int = 2;
        public static var curPageData:Array = [];

        public static function getShopItemByTemplateID(_arg1:uint, _arg2:Boolean=false):ShopItemInfo{
            var _local5:ShopItemInfo;
            var _local3:uint;
            var _local4:uint;
            if (UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX]){
                _local3 = 0;
                while (_local3 < UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX].length) {
                    _local5 = (UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX][_local3] as ShopItemInfo);
                    if (_local5.TemplateID == _arg1){
                        if (((_arg2) && ((_local5.curr_amount == 0)))){
                            break;
                        };
                        return (_local5);
                    };
                    _local3++;
                };
            };
            _local5 = SelfDayLimitCntBuyShopItemObj.info;
            if (((((SelfDayLimitCntBuyShopItemObj) && (SelfDayLimitCntBuyShopItemObj.info))) && ((SelfDayLimitCntBuyShopItemObj.info.TemplateID == _arg1)))){
                if (((((_arg2) && ((_local5.curr_amount > 0)))) && (((MarketConstData.SelfDayLimitCntBuyShopItemObj.cnt - (MarketConstData.MarketDayLimitCntBuyRecord[9] % 100)) > 0)))){
                    return (SelfDayLimitCntBuyShopItemObj.info);
                };
            };
            _local3 = 0;
            while (_local3 < UIConstData.MarketGoodList.length) {
                if (UIConstData.MarketGoodList[_local3]){
                    _local4 = 0;
                    while (_local4 < UIConstData.MarketGoodList[_local3].length) {
                        if (UIConstData.MarketGoodList[_local3][_local4].TemplateID == _arg1){
                            return (UIConstData.MarketGoodList[_local3][_local4]);
                        };
                        _local4++;
                    };
                };
                _local3++;
            };
            return (null);
        }
        public static function GetMoneyText(_arg1:int):String{
            var _local2 = "";
            var _local3:uint = uint((_arg1 / 100));
            var _local4:uint = uint((_arg1 % 100));
            _local2 = (_local2 + ((_local3 == 0)) ? "" : (String(_local3) + "\\ab"));
            _local2 = (_local2 + ((_local4 == 0)) ? "" : (String(_local4) + "\\aa"));
            return (_local2);
        }
        public static function getMarketSaleItem(_arg1:uint):ShopItemInfo{
            var _local2:uint;
            if (UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX] == null){
                return (null);
            };
            _local2 = 0;
            while (_local2 < UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX].length) {
                if ((UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX][_local2] as ShopItemInfo).TemplateID == _arg1){
                    return (UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX][_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public static function getMarketClassByItem(_arg1:ItemTemplateInfo):int{
            if ((((_arg1.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH)))){
                return (1);
            };
            if ((((_arg1.MainClass == ItemConst.ITEM_CLASS_MEDICAL)) && (!((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_MEDICAL_SPECIAL))))){
                return (2);
            };
            if ((((_arg1.MainClass == ItemConst.ITEM_CLASS_CONSUMABLE)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_CONSUMABLE_BACK)))){
                return (3);
            };
            if ((((((_arg1.MainClass == ItemConst.ITEM_CLASS_EQUIP)) && ((((((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)) || ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY)))) || ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK)))))) || ((((_arg1.MainClass == ItemConst.ITEM_CLASS_MEDICAL)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_MEDICAL_SPECIAL)))))){
                return (4);
            };
            if (_arg1.MainClass == ItemConst.ITEM_CLASS_PET){
                return (5);
            };
            if ((((_arg1.MainClass == ItemConst.ITEM_CLASS_EQUIP)) && (!((((((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)) || ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY)))) || ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK))))))){
                return (6);
            };
            return (7);
        }
        public static function getMarketClass(_arg1:uint):uint{
            var _local2:uint;
            var _local3:uint;
            _local2 = 0;
            while (_local2 < UIConstData.MarketGoodList.length) {
                if (UIConstData.MarketGoodList[_local2]){
                    _local3 = 0;
                    while (_local3 < UIConstData.MarketGoodList[_local2].length) {
                        if (UIConstData.MarketGoodList[_local2][_local3].TemplateID == _arg1){
                            return (_local2);
                        };
                        _local3++;
                    };
                };
                _local2++;
            };
            return (0);
        }
        public static function getCostMoney(_arg1:ShopCarInfo):Array{
            var _local2:Number = 0;
            var _local3:Number = 0;
            var _local4:Number = 0;
            if (_arg1){
                if (_arg1.currentPayWay == 0){
                    _local2 = (_local2 + (_arg1.APriceArr[_arg1.currentPayWay] * _arg1.buyNum));
                } else {
                    if (_arg1.currentPayWay == 1){
                        _local3 = (_local3 + (_arg1.APriceArr[_arg1.currentPayWay] * _arg1.buyNum));
                    } else {
                        if (_arg1.currentPayWay == 2){
                            _local4 = (_local4 + (_arg1.APriceArr[_arg1.currentPayWay] * _arg1.buyNum));
                        };
                    };
                };
            };
            var _local5:Array = [];
            _local5.push(_local2);
            _local5.push(_local3);
            _local5.push(_local4);
            return (_local5);
        }

    }
}//package GameUI.Modules.Maket.Data 
