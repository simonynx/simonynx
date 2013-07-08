//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;

    public class ActivityAction extends GameAction {

        private static var instance:ActivityAction;

        private var _packet:NetPacket;

        public function ActivityAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():ActivityAction{
            if (instance == null){
                instance = new (ActivityAction)();
            };
            return (instance);
        }

        private function updateActivity(_arg1:NetPacket):void{
            var _local4:uint;
            var _local5:uint;
            var _local2:int;
            var _local3:Object = new Object();
            var _local6:int = _arg1.readInt();
            if (_local6 == -1){
                _local6 = _arg1.readUnsignedInt();
                while (_local2 < _local6) {
                    _local5 = _arg1.readUnsignedInt();
                    _local3[_local2] = _local5;
                    GameCommonData.activityData[_local2] = _local5;
                    _local2++;
                };
            } else {
                while (_local2 < _local6) {
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = _arg1.readUnsignedInt();
                    _local3[_local4] = _local5;
                    GameCommonData.activityData[_local4] = _local5;
                    _local2++;
                };
            };
            facade.sendNotification(EventList.UPDATE_ACTIVITY, _local3);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_DAILY_RECORD:
                    updateActivity(_arg1);
                    break;
                case Protocol.SMSG_DAILY_LOGIN:
                    getDailyLogin(_arg1);
                    break;
                default:
                    trace("活动面板收到的服务器消息有问题");
            };
        }
        private function getDailyLogin(_arg1:NetPacket):void{
            var _local5:uint;
            var _local6:uint;
            _arg1.readUnsignedInt();
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:int;
            var _local4:Object = new Object();
            while (_local3 < _local2) {
                _local5 = _arg1.readUnsignedInt();
                _local6 = _arg1.readUnsignedInt();
                _local4[_local3] = {
                    itemid:_local5,
                    itemcount:_local6
                };
                _local3++;
            };
            facade.sendNotification(EventList.UPDATE_DAILYAWARD, _local4);
        }

    }
}//package Net.PackHandler 
