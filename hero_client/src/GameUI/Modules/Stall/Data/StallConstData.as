//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Stall.Data {
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class StallConstData {

        public static const STALL_DEFAULT_POS:Point = new Point(180, 20);
        public static const DOWN_GRID_NUM:uint = 12;
        public static const GRID_NUM:uint = 18;
        public static const MONEY_DEFAULT_POS:Point = new Point(365, 200);

        public static var timeStamp:uint;
        public static var GridDownUnitList:Array = new Array();
        public static var otherStallName:Dictionary = new Dictionary();
        public static var stallOwnerName:String = "";
        public static var stallLookDic:Dictionary = new Dictionary();
        public static var idToPlace1:int = -1;
        public static var idToPlace2:int = -1;
        public static var SelectIndex:int = 0;
        public static var buyNum:uint = 0;
        public static var TmpIndex:int = 0;
        public static var SelectedDownItem:GridUnit = null;
        public static var stallIdToQuery:int = 0;
        public static var goodDownList:Array = new Array(DOWN_GRID_NUM);
        public static var moneyDownAll:Array = [0, 0, 0];
        public static var moneyAll:Array = [0, 0, 0];
        public static var stallSelfId:int = 0;
        public static var moneyPay:Array = [0, 0, 0];
        public static var copyGoodUpList:Array = new Array(GRID_NUM);
        public static var stallMsg:Array = [];
        public static var copyGoodDownList:Array = new Array(DOWN_GRID_NUM);
        public static var copyStallName:String = "";
        public static var GridUnitList:Array = new Array();
        public static var sellNum:uint = 0;
        public static var stallName:String = "";
        public static var SelectedItem:GridUnit = null;
        public static var tempGoodList:Array = [];
        public static var stallInfo:String = "";
        public static var goodUpList:Array = new Array(GRID_NUM);
        public static var moneyGet:Array = [0, 0, 0];

    }
}//package GameUI.Modules.Stall.Data 
