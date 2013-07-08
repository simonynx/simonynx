//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;

    public class VIPAction extends GameAction {

        private static var instance:VIPAction;

        private var _packet:NetPacket;

        public function VIPAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():VIPAction{
            if (instance == null){
                instance = new (VIPAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_VIPLIST:
                    updateVIP(_arg1);
                    break;
                default:
                    trace("VIP面板收到的服务器消息有问题");
            };
        }
        private function updateVIP(_arg1:NetPacket):void{
            var _local4:Object;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:int;
            var _local5:uint;
            var _local6:uint;
            var _local7 = "";
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local11 = "";
            var _local12:Array = [];
            while (_local3 < _local2) {
                _local5 = _arg1.readUnsignedInt();
                _local6 = _arg1.readUnsignedInt();
                _local7 = _arg1.ReadString();
                _local8 = _arg1.readUnsignedInt();
                _local9 = _arg1.readUnsignedInt();
                _local10 = _arg1.readUnsignedInt();
                _local11 = _arg1.ReadString();
                _local4 = new Object();
                _local4.guid = _local5;
                _local4.viptype = _local6;
                _local4.name = _local7;
                _local4.sex = _local8;
                _local4.job = _local9;
                _local4.level = _local10;
                _local4.guild = _local11;
                _local3++;
                if (_local6 == 0){
                    trace("假的VIP");
                } else {
                    _local12.push(_local4);
                };
            };
            sendNotification(EventList.UPDATE_VIP_ARRAY, _local12);
        }

    }
}//package Net.PackHandler 
