//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Trade.Data {
    import OopsEngine.Role.*;
    import flash.utils.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class TradeConstData {

        public static var goodOpList:Array = new Array(6);
        public static var AllItems:Array = new Array(6);
        public static var idItemSelfArr:Array = [-1, -1, -1, -1, -1];
        public static var GridUnitList:Array = new Array();
        public static var GridUnitListOp:Array = new Array();
        public static var opName:String = "";
        public static var SelectIndex:int = 0;
        public static var petSelectOfTrade:GamePetRole = null;
        public static var TmpIndex:int = 0;
        public static var goodSelfList:Array = new Array(6);
        public static var SelectedItem:GridUnit = null;
        public static var petSelectOfList:GamePetRole = null;
        public static var petSelfDic:Dictionary = new Dictionary();
        public static var petListSelfDic:Dictionary = new Dictionary();
        public static var petSelectOp:GamePetRole = null;
        public static var petOpDic:Dictionary = new Dictionary();

    }
}//package GameUI.Modules.Trade.Data 
