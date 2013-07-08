//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.Data {

    public class GetRewardConstData {

        public static var IsOpenBox10:Boolean;
        public static var MaxEquipGuild:uint;
        public static var BOX10ITEMGUID_ARR:Array = [50200002, 20210001, 20310001, 20410001, 20220001, 20320001, 20420001, 20230001, 20330001, 20430001, 20240001, 20340001, 20440001, 20250001, 20350001, 20450001];
        public static var GetRewardTypeArr:Array = [GetRewardType.TYPE_RING];
        public static var CurrentUpdateRewardType:int;
        public static var GetRewardTypeArr_mount:Array = [GetRewardType.LEVEL_ITEM_HORSE, GetRewardType.LEVEL_ITEM_HORSE];
        public static var CurrentUpdateType_mount:int;

        public static function get IsCanGetMount():Boolean{
            return (!(((GameCommonData.Player.Role.PermanentRecord & 1) == 0)));
        }
        public static function get IsCanShowGetMountBtn():Boolean{
            return ((GameCommonData.Player.Role.Level >= 13));
        }
        public static function get IsGetMount():Boolean{
            return (!(((GameCommonData.Player.Role.PermanentRecord & 2) == 0)));
        }
        public static function IsGeted(_arg1:uint):Boolean{
            return (!(((GameCommonData.RewardRecord & (_arg1 * 2)) == 0)));
        }
        public static function IsCanGet(_arg1:uint):Boolean{
            return (!(((GameCommonData.RewardRecord & ((_arg1 * 2) - 1)) == 0)));
        }
        public static function get IsCanShowGetRingBtn():Boolean{
            return ((GameCommonData.Player.Role.Level >= 32));
        }

    }
}//package GameUI.Modules.NewInfoTip.Data 
