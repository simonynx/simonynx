//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.FilterBag.Proxy {
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Bag.*;

    public class FilterBagData {

        public static var NormalItemLock:Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
        public static var AllLocks:Array = [NormalItemLock];
        public static var GridUnitList:Array = new Array();
        public static var currTmpIndex:int = -1;
        public static var SelectedItem:GridUnit = null;
        public static var NormalItemList:Array = new Array(42);
        public static var TmpIndex:int = 0;
        public static var SelectIndex:int = 0;
        public static var AllItems:Array = [NormalItemList];

        public static function IndexToBagIndex(_arg1:uint):int{
            var _local4:uint;
            var _local2 = -1;
            var _local3:uint = _arg1;
            if (AllItems[0][_local3]){
                _local4 = AllItems[0][_local3].Place;
                _local2 = ItemConst.placeToOffset(_local4);
            };
            return (_local2);
        }
        public static function getUseItemByTemplateId(_arg1:int):UseItem{
            var _local2:int;
            while (_local2 < GridUnitList.length) {
                if (((((GridUnitList[_local2]) && (GridUnitList[_local2].Item))) && ((GridUnitList[_local2].Item.Type == _arg1)))){
                    return (GridUnitList[_local2].Item);
                };
                _local2++;
            };
            return (null);
        }
        public static function IndexToBagPlace(_arg1:uint):int{
            var _local2 = -1;
            var _local3:uint = _arg1;
            if (AllItems[0][_local3]){
                _local2 = AllItems[0][_local3].Place;
            };
            return (_local2);
        }
        public static function getIndexById(_arg1:uint):int{
            var _local2 = -1;
            var _local3:uint;
            _local3 = 0;
            while (_local3 < 42) {
                if (((AllItems[0][_local3]) && ((AllItems[0][_local3].ItemGUID == _arg1)))){
                    _local2 = _local3;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        public static function getUnLockItemByTemplateId(_arg1:int):UseItem{
            var _local2:int;
            while (_local2 < GridUnitList.length) {
                if (((((((GridUnitList[_local2]) && (GridUnitList[_local2].Item))) && ((GridUnitList[_local2].Item.IsLock == false)))) && ((GridUnitList[_local2].Item.Type == _arg1)))){
                    return (GridUnitList[_local2].Item);
                };
                _local2++;
            };
            return (null);
        }

    }
}//package GameUI.Modules.FilterBag.Proxy 
