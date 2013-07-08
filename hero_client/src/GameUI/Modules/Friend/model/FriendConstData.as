//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.model {
    import GameUI.Modules.Friend.model.vo.*;

    public class FriendConstData {

        public static var EnemyList:Array = [];
        public static var TempFriendList:Array = [];
        public static var EnemyTempList:Array = [];
        public static var BlackFriendList:Array = [];
        public static var FriendList:Array = [];

        public static function searchFriend(_arg1:Array, _arg2:int, _arg3:uint=1, _arg4:String=""):FriendInfoStruct{
            var _local5:uint;
            while (_local5 < _arg1.length) {
                if (_arg3 == 1){
                    if ((_arg1[_local5] as FriendInfoStruct).frendId == _arg2){
                        return (_arg1[_local5]);
                    };
                } else {
                    if ((_arg1[_local5] as FriendInfoStruct).roleName == _arg4){
                        return (_arg1[_local5]);
                    };
                };
                _local5++;
            };
            return (null);
        }

    }
}//package GameUI.Modules.Friend.model 
