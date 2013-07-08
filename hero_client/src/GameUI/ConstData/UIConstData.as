//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.ConstData {
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.FilterBag.Proxy.*;

    public class UIConstData {

        public static const PETSAVVYUSEMONEY:String = "petSavvyUseMoney";
        public static const PETTOBABY:String = "petToBaby";
        public static const PETSAVVYJOIN:String = "petSavvyJoin";
        public static const PETSKILLUP:String = "petSkillUp";
        public static const PETBREEDSINGLE:String = "petBreedSingle";
        public static const PETBREEDDOUBLE:String = "petBreedDouble";
        public static const PETSKILLLEARN:String = "petSkillLearn";

        public static var PetExpDic:Dictionary = new Dictionary();
        public static var AppendAttribute:Dictionary = new Dictionary();
        public static var PanelGridList:Array = ["bag", "filterBag", "hero", "depot", "NPCShopSale", "mcPhoto", "stall", "stalldown", "donateprop", "Convoy", "Entrust"];
        public static var ControlIsDown:Boolean = false;
        public static var SelectFaceIsOpen:Boolean = false;
        public static var CoordinatesEquip:Dictionary = new Dictionary();
        public static var DefaultPos1:Point = new Point(200, 58);
        public static var Filter_chat:Array = new Array();
        public static var DefaultPos2:Point = new Point(586, 58);
        public static var FocusIsUsing:Boolean = false;
        public static var useItemTimer:Timer = new Timer(1000, 1);
        public static var QuickUnitList:Array = new Array();
        public static var ExpDic:Dictionary = new Dictionary();
        public static var BagHeight:uint;
        public static var TipsItemList:Array = ["Strengen", "EquipComposeT2", "EquipEmbedT", "EquipEmbedT2", "EquipIdentifyT", "EquipRefineT", "EquipTransformT", "EquipUpStarT", "TreasureSacrificeT", "TreasureResetT", "TreasureRebuildT", "TreasureTransferT", "TreasureTransformT"];
        public static var ItemDic:Dictionary = new Dictionary();
        public static var BagWidth:uint;
        public static var Filter_Switch:Boolean = false;
        public static var KeyBoardCanUse:Boolean = true;
        public static var ToolTipShow:Boolean = true;
        public static var IS_BUSINESSING:Boolean = false;
        public static var RandomNameArr:Array = [[], []];
        public static var MarketGoodList:Array = new Array(10);
        public static var TreasureSeriesDic:Dictionary = new Dictionary();
        public static var IsTrading:Boolean = false;

        public static function InventoryItem(_arg1:UseItem):InventoryItemInfo{
            var _local4:uint;
            var _local2:InventoryItemInfo;
            var _local3:uint = FilterBagData.AllItems[0][_arg1.Pos].Place;
            if (_local3 >= ItemConst.EQUIP_SLOT_END){
                _local4 = ItemConst.placeToOffset(_local3);
                _local2 = BagData.AllItems[0][_local4];
            } else {
                _local2 = RolePropDatas.ItemList[_local3];
            };
            return (_local2);
        }

    }
}//package GameUI.ConstData 
