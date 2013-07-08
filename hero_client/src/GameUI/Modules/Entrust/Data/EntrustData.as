//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Entrust.Data {
    import GameUI.ConstData.*;

    public class EntrustData {

        public static const EntrustType:Array = [["战士", "法师", "牧师", "刺客", "猎人"], ["战士", "法师", "牧师", "刺客", "猎人"], ["战士", "法师", "牧师", "刺客", "猎人"], ["战士", "法师", "牧师", "刺客", "猎人"], ["戒指", "项链", "护符", "圣契"], ["强化石", "保护道具", "符文", "鉴定符"], ["神兵", "洗炼水晶", "重生药剂", "技能水晶", "神兵碎片", "神兵经验药"], ["宠物", "宠物秘纹", "强化道具", "资质刷新石", "宠物药品"], ["药品"], ["其他"], ["材料"]];
        public static const EntrustTimes:Array = ["8小时", "16小时", "24小时"];
        public static const EntrustJobs:Array = ["按职业", "战士", "法师", "牧师", "刺客", "猎人"];
        public static const PAGE_NUM:uint = 6;
        public static const MY_ENTRUST_PAGE_NUM:uint = 4;
        public static const EntrustColors:Array = ["按品质", "白色", "绿色", "蓝色", "紫色"];

        public static var posY:int = -18;
        public static var entrustArr:Array = ["武器", "衣服", "帽子", "鞋子", "饰品", "装备锻造", "神兵锻造", "宠物精进", "药品", "其他", "材料"];
        public static var totalEntrustPage:uint = 1;
        public static var MyEntrustList:Array = new Array();
        public static var currPageEntrustList:Array = new Array();
        public static var currEntrustPage:uint = 0;

        public static function findItemInAllEntrust(_arg1:uint):InventoryItemInfo{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < currPageEntrustList.length) {
                if (currPageEntrustList[_local2]){
                    if ((currPageEntrustList[_local2] as EntrustInfo).item.ItemGUID == _arg1){
                        return (currPageEntrustList[_local2].item);
                    };
                };
                _local2++;
            };
            _local2 = 0;
            _local2 = 0;
            while (_local2 < MyEntrustList.length) {
                if (MyEntrustList[_local2]){
                    if ((MyEntrustList[_local2] as EntrustInfo).item.ItemGUID == _arg1){
                        return ((MyEntrustList[_local2] as EntrustInfo).item);
                    };
                };
                _local2++;
            };
            return (null);
        }
        public static function findItemInMyEntrust(_arg1:uint):Boolean{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < MyEntrustList.length) {
                if ((MyEntrustList[_local2] as EntrustInfo).itemguid == _arg1){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }

    }
}//package GameUI.Modules.Entrust.Data 
