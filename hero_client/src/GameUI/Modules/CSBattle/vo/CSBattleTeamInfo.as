//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.CSBattle.vo {

    public class CSBattleTeamInfo {

        public var TotlaBattleCnt:int;
        public var MemberArr:Array;
        public var LeaderGuid:int;
        public var PlatformId:int;
        public var ServerId:int;
        public var RankId:int;
        public var Level:int;
        public var Name:String;
        public var State:int;
        public var WinBattleCnt:int;
        public var TeamId:int;
        public var PlatformName:String;

        public function IsMemberPlayer(_arg1:int):Boolean{
            var _local2:int;
            var _local3:int = MemberArr.length;
            while (_local2 < _local3) {
                if (((MemberArr[_local2]) && ((MemberArr[_local2].Guid == _arg1)))){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }

    }
}//package GameUI.Modules.CSBattle.vo 
