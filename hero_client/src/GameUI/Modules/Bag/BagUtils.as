//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag {
    import GameUI.Modules.Bag.Proxy.*;

    public class BagUtils {

        public static function getNullItemIndex(_arg1:int):int{
            var _local2:* = BagData.AllItems[_arg1];
            var _local3 = -1;
            var _local4:int;
            while (_local4 < BagData.BagNum[_arg1]) {
                if (_local2[_local4] == undefined){
                    _local3 = _local4;
                    break;
                };
                _local4++;
            };
            return (_local3);
        }
        public static function TestBagIsFull(_arg1:int):uint{
            var _local3:uint;
            var _local4:int;
            var _local2:Array = BagData.AllItems[_arg1];
            while (_local4 < BagData.BagNum[_arg1]) {
                if (_local2[_local4] != undefined){
                    _local3++;
                };
                _local4++;
            };
            return (_local3);
        }

    }
}//package GameUI.Modules.Bag 
