//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;

    public class GameTargetAction extends GameAction {

        private static var instance:GameTargetAction;

        private var _packet:NetPacket;

        public function GameTargetAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():GameTargetAction{
            if (instance == null){
                instance = new (GameTargetAction)();
            };
            return (instance);
        }

        private function handleStatus(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Object = new Object();
            var _local5:int;
            while (_local5 < 10) {
                _local4[_local5] = _arg1.readUnsignedByte();
                _local5++;
            };
            _local4.enter = _local2;
            _local4.guild = _local3;
            sendNotification(EventList.UPDATE_TARGET_STATUS, _local4);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_PLAYER_GROWUP_OPERATE_RESULT:
                    handleSingleDay(_arg1);
                    break;
                case Protocol.SMSG_PLAYERGROWUP_STATUS:
                    handleStatus(_arg1);
                    break;
                default:
                    trace("目标面板收到的服务器消息有问题");
            };
        }
        private function handleSingleDay(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Object = {};
            if (_local3 == 2){
                _local3 = 1;
            };
            if (_local3 == 4){
                _local3 = 3;
            };
            if (_local3 == 6){
                _local3 = 4;
            };
            if (_local3 == 7){
                _local3 = 2;
            };
            _local4.day = (_local2 - 1);
            _local4.op = _local3;
            sendNotification(EventList.UPDATE_TARGET_SINGLE, _local4);
        }

    }
}//package Net.PackHandler 
