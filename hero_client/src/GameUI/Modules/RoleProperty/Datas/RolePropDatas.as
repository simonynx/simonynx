//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Datas {
    import GameUI.ConstData.*;
    import GameUI.Modules.RoleProperty.Prxoy.*;

    public class RolePropDatas {

        public static var OfferTile:Array = ["零级", "一级", "二级", "三级", "四级", "五级", "六级", "七级", "八级", "九级", "十级", "十一级", "十二级"];
        public static var ItemUnitList:Array = new Array();
        public static var SelectedOutfit:ItemUnit = null;
        public static var ItemPos:Array = [1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
        public static var lastRequestOtherTime:Number = 0;
        public static var CurView:int = 0;
        public static var lastOutPet:int = 0;
        public static var OfferTipsArr:Array = [];
        public static var ItemList:Array = new Array(14);
        public static var isShowFashion:Boolean = false;
        public static var OfferLevelDef:Array = [400000, 1000000, 0x249F00, 3600000, 6000000, 0xB71B00, 200000000, 36000000, 60000000, 100000000];

        public static function getCountsByTemplateId(_arg1:uint):int{
            var _local2:int;
            var _local3:uint;
            _local3 = 0;
            while (_local3 < ItemList.length) {
                if (((ItemList[_local3]) && (((ItemList[_local3] as InventoryItemInfo).TemplateID == _arg1)))){
                    _local2++;
                };
                _local3++;
            };
            return (_local2);
        }
        public static function getVipTime(_arg1:int):String{
            if (_arg1 <= 0){
                return ("无");
            };
            var _local2:* = int((_arg1 / 86400)).toString();
            var _local3:* = int(((_arg1 % 86400) / 3600)).toString();
            var _local4:* = int(((_arg1 % 3600) / 60)).toString();
            if (_local2 == "0"){
                if (_local3 == "0"){
                    return ((_local4 + LanguageMgr.GetTranslation("分")));
                };
                return ((((_local3 + LanguageMgr.GetTranslation("时")) + _local4) + LanguageMgr.GetTranslation("分")));
            };
            return ((((((_local2 + LanguageMgr.GetTranslation("天")) + _local3) + LanguageMgr.GetTranslation("时")) + _local4) + LanguageMgr.GetTranslation("分")));
        }
        public static function getDoubleTimeStr(_arg1:uint):String{
            if (_arg1 <= 0){
                return ("0");
            };
            var _local2:* = int((_arg1 / 3600)).toString();
            var _local3:* = int(((_arg1 % 3600) / 60)).toString();
            if (_local2 == "0"){
                return ((_local3 + LanguageMgr.GetTranslation("分")));
            };
            return ((((_local2 + LanguageMgr.GetTranslation("时")) + _local3) + LanguageMgr.GetTranslation("分")));
        }
        public static function GetOfferLevel(_arg1:uint):int{
            var _local2:int;
            while ((((_arg1 >= OfferLevelDef[_local2])) && ((_local2 < 10)))) {
                _local2++;
            };
            return (_local2);
        }
        public static function getItemById(_arg1:uint):InventoryItemInfo{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < ItemList.length) {
                if (((ItemList[_local2]) && ((ItemList[_local2].ItemGUID == _arg1)))){
                    return (ItemList[_local2]);
                };
                _local2++;
            };
            return (null);
        }

    }
}//package GameUI.Modules.RoleProperty.Datas 
