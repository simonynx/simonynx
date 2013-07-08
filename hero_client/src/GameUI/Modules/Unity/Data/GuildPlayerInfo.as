//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Unity.Data {

    public class GuildPlayerInfo {

        public var LastLoginTime:String;
        public var BuildValue:int;
        public var FightPower:int;
        public var Sex:int;
        public var GuildId:int;
        public var DutyID:int;
        public var Job:int;
        public var DutyName:String;
        public var Permissions:int;
        public var BuildValue_Today:int;
        public var Level:int;
        public var NickName:String;
        private var _BanChatFlag:int;
        public var DutyLevel:int;
        public var PlayerId:int;
        public var IsOnline:Boolean;

        public function get BanChatFlag():int{
            if (((!((_BanChatFlag == 0))) && ((_BanChatFlag <= (new Date().time / 1000))))){
                _BanChatFlag = 0;
            };
            return (_BanChatFlag);
        }
        public function set BanChatFlag(_arg1:int):void{
            _BanChatFlag = _arg1;
        }

    }
}//package GameUI.Modules.Unity.Data 
