//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.MainScene.Data {
    import GameUI.UICore.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;

    public class QuickBarData {

        public static var SkillItemList:Array = new Array();
        private static var _instance:QuickBarData;

        public var expandKeyDic:Dictionary;
        public var quickKeyDic:Dictionary;

        public function QuickBarData(){
            this.quickKeyDic = new Dictionary();
            this.expandKeyDic = new Dictionary();
        }
        public static function getInstance():QuickBarData{
            if (_instance == null){
                _instance = new (QuickBarData)();
            };
            return (_instance);
        }

        public function getGuildSkillItemById(_arg1:uint):NewSkillCell{
            var _local2:Array;
            var _local3:int;
            while (_local3 < SkillItemList.length) {
                if (((((((SkillItemList[_local3]) && ((SkillItemList[_local3] is NewSkillCell)))) && ((SkillItemList[_local3].skillInfo is GuildSkillInfo)))) && ((SkillItemList[_local3].skillInfo.TypeID == int((_arg1 / 100)))))){
                    return (SkillItemList[_local3]);
                };
                _local3++;
            };
            return (null);
        }
        public function getSameSkillItemById(_arg1:uint):Array{
            var _local2:NewSkillCell;
            var _local3:int = GameCommonData.SkillList[_arg1].TypeID;
            var _local4:Array = new Array();
            var _local5:Array = new Array();
            var _local6:Array = new Array();
            for each (_local2 in SkillItemList) {
                if (((!((_local2 == null))) && (!(_local2.IsCdTimer)))){
                    if (((!((_local2.skillInfo == null))) && (!((_local2.skillInfo.Type == SkillInfo.ATTRIBUTES_PASSIVE))))){
                        if (_local2.skillInfo.TypeID == _local3){
                            _local5.push(_local2);
                        } else {
                            _local6.push(_local2);
                        };
                    };
                };
            };
            _local4.push(_local5);
            _local4.push(_local6);
            return (_local4);
        }
        public function getItemFromBag(_arg1:UseItem):InventoryItemInfo{
            var _local2:InventoryItemInfo;
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (_local2 != null){
                    if ((((((_local2.type == _arg1.Type)) && ((_local2.isBind == _arg1.IsBind)))) && ((_local2.Count > 0)))){
                        return (_local2);
                    };
                };
            };
            return (null);
        }
        public function getSkillItemByNoCd():Array{
            var _local1:NewSkillCell;
            var _local2:Array = [];
            for each (_local1 in SkillItemList) {
                if (((((!((_local1 == null))) && (!((_local1.skillInfo == null))))) && (!(_local1.IsCdTimer)))){
                    if (((_local1.isLearn) && (!((_local1.skillInfo.Type == SkillInfo.ATTRIBUTES_PASSIVE))))){
                        _local2.push(_local1);
                    } else {
                        if (_local1.skillInfo.Job == 8){
                            _local2.push(_local1);
                            trace("push神兵技能");
                        };
                    };
                };
            };
            return (_local2);
        }
        public function getItemIdFromBag(_arg1:UseItem):Boolean{
            var _local2:*;
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (_local2 != null){
                    if (_local2.ItemGUID == _arg1.Id){
                        return (true);
                    };
                };
            };
            return (false);
        }
        public function getQuickUseItemByCd():Array{
            var _local1:*;
            var _local2:*;
            var _local3:UseItem;
            var _local4:UseItem;
            var _local5:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local6:Dictionary = QuickBarData.getInstance().expandKeyDic;
            var _local7:Array = [];
            for (_local1 in _local5) {
                if (_local5[_local1] != null){
                    if ((_local5[_local1] is UseItem)){
                        _local3 = _local5[_local1];
                        if (ItemConst.IsMedicalExceptBAG(_local3.itemIemplateInfo)){
                            _local7.push(_local3);
                        };
                    };
                };
            };
            for (_local2 in _local6) {
                if (_local6[_local2] != null){
                    if ((_local6[_local2] is UseItem)){
                        _local4 = _local6[_local2];
                        if (ItemConst.IsMedicalExceptBAG(_local4.itemIemplateInfo)){
                            _local7.push(_local4);
                        };
                    };
                };
            };
            return (_local7);
        }
        public function getItemIdFromBagNoBind(_arg1:UseItem):uint{
            var _local2:*;
            for each (_local2 in (BagData.AllItems[0] as Array)) {
                if (_local2 == null){
                } else {
                    if (_local2.type == _arg1.Type){
                        return (_local2.ItemGUID);
                    };
                };
            };
            return (0);
        }

    }
}//package GameUI.Modules.MainScene.Data 
