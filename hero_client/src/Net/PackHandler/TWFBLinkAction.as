//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;

    public class TWFBLinkAction extends GameAction {

        private static var instance:TWFBLinkAction;

        public static function getInstance():TWFBLinkAction{
            if (instance == null){
                instance = new (TWFBLinkAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_RESULT_FACEBOOK:
                    fbLinkResult(_arg1);
                    break;
                case Protocol.SMSG_HEROS_TOGETHER:
                    getHerosRecord(_arg1);
                    break;
            };
        }
        private function getHerosRecord(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Array = [];
            var _local4:int;
            while (_local4 < _local2) {
                _local3.push(_arg1.readUnsignedInt());
                _local4++;
            };
            facade.sendNotification(EventList.FBLINK_UPDATEHEROESRECORD, _local3);
        }
        private function fbLinkResult(_arg1:NetPacket):void{
            var _local2:String = _arg1.ReadString();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:int = _arg1.readInt();
            var _local5:String = _arg1.ReadString();
            facade.sendNotification(EventList.FBLINK_RESULT, [_local2, _local3, _local4, _local5]);
        }

    }
}//package Net.PackHandler 
