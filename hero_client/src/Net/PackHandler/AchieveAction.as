//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Achieve.Data.*;

    public class AchieveAction extends GameAction {

        private static var _instance:AchieveAction;

        public function AchieveAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():AchieveAction{
            if (_instance == null){
                _instance = new (AchieveAction)();
            };
            return (_instance);
        }

        private function UpdateAchieve(_arg1:NetPacket):void{
            var _local2:int;
            var _local3:AchieveInfo;
            _local2 = _arg1.readUnsignedInt();
            _local3 = GameCommonData.AchieveDic[_local2];
            if (_local3 == null){
                throw (new Error(("客户端缺失成就定义" + _local2.toString())));
            };
            _local3.CurrentProgress = _arg1.readUnsignedInt();
            _local3.CompleteTime = (_arg1.readUnsignedInt() * 1000);
            var _local4:int = _arg1.readUnsignedInt();
            GameCommonData.TotalAchievePoint = _local4;
            facade.sendNotification(EventList.UPDATE_ONE_ACHIEVEVIEW, _local2);
            if (_local3.IsComplete){
                facade.sendNotification(EventList.POP_GETNEWACHIEVE, _local2);
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_ACHIEVEMENT_LIST:
                    GetAchieveLoglistResult(_arg1);
                    break;
                case Protocol.SMSG_ACHIEVEMENT_DATA:
                    UpdateAchieve(_arg1);
                    break;
            };
        }
        private function GetAchieveLoglistResult(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:AchieveInfo;
            var _local5:int;
            var _local2:int = _arg1.readUnsignedInt();
            while (_local5 < _local2) {
                _local3 = _arg1.readUnsignedInt();
                _local4 = GameCommonData.AchieveDic[_local3];
                if (_local4 == null){
                    throw (new Error(("客户端缺失成就定义" + _local3.toString())));
                };
                _local4.CurrentProgress = _arg1.readUnsignedInt();
                _local4.CompleteTime = (_arg1.readUnsignedInt() * 1000);
                _local5++;
            };
            var _local6:int = _arg1.readUnsignedInt();
            GameCommonData.TotalAchievePoint = _local6;
        }

    }
}//package Net.PackHandler 
