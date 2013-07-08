//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Roll.Data {
    import flash.utils.*;
    import GameUI.ConstData.*;

    public class RollInfo {

        public static var dic:Dictionary = new Dictionary();

        public var index:int;
        public var itemNum:int;
        private var _itemId:int;
        public var itemName:String = "未知物品";

        public function get itemId():int{
            return (_itemId);
        }
        public function set itemId(_arg1:int):void{
            _itemId = _arg1;
            var _local2:ItemTemplateInfo = UIConstData.ItemDic[_itemId];
            if (_local2){
                itemName = _local2.Name;
            };
        }

    }
}//package GameUI.Modules.Roll.Data 
