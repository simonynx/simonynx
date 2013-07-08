//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Data {
    import OopsEngine.Role.*;
    import flash.utils.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class PetPropConstData {

        public static var propColorIndexs:Array = [10, 30, 60, 90, 100];
        public static var selectedPet:GamePetRole = null;
        public static var ItemIds:Array = [70200002, 70200003];
        public static var GridUnitList:Array = new Array();
        public static var PetIdSelectedChooseTask:uint = 0;
        public static var petColorObj:Object = {
            生命:"life",
            魔法:"magic",
            攻击:"attack",
            命中:"fatal",
            防御:"defence",
            躲闪:"dodge"
        };
        public static var potentials:uint = 0;
        public static var TmpIndex:int = 0;
        public static var petBagNum:uint = 0;
        public static var petListOthers:Dictionary = new Dictionary();
        public static var points:Array = [0, 0, 0, 0, 0];
        public static var petPropOrder:Array = ["攻击", "防御", "生命", "魔法", "命中", "躲闪"];
        public static var IntPropColors:Array = ["0xffffff", "0x5ae13b", "0x0389fa", "0xdd3ac4", "0xfb7204"];
        public static var gridSkillList:Array = new Array();
        public static var SelectedItem:GridUnit = null;
        public static var petChooseTaskIsOpen:Boolean = false;
        public static var propColors:Array = ["#ffffff", "#5ae13b", "#0389fa", "#dd3ac4", "#fb7204"];
        public static var petBaseUpValue:Array = [16, 12, 4, 4, 4, 4];
        public static var EQUIP_NUM:uint = 5;
        public static var mainAttrColor:uint = 0;

        public static function getColorIndex(_arg1:int):uint{
            if (_arg1 < 0){
                _arg1 = 0;
            };
            var _local2:uint = 4;
            var _local3:uint;
            _local3 = 0;
            while (_local3 < propColorIndexs.length) {
                if (_arg1 <= propColorIndexs[_local3]){
                    _local2 = _local3;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        public static function getColorStr(_arg1:int):uint{
            return (uint(IntPropColors[getColorIndex(_arg1)]));
        }

    }
}//package GameUI.Modules.Pet.Data 
