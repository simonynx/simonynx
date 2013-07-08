//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.GoldLeaf.VO.*;

    public class GoldLeafAction extends GameAction {

        private static var instance:GoldLeafAction;

        private var _packet:NetPacket;

        public function GoldLeafAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():GoldLeafAction{
            if (instance == null){
                instance = new (GoldLeafAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_BANKMONEY:
                    updateBankMoney(_arg1);
                    break;
                case Protocol.SMSG_EXCHANGE_LOG:
                    updateExchangeLog(_arg1);
                    break;
                case Protocol.SMSG_EXCHANGE_RATE:
                    updateExchageRate(_arg1);
                    break;
                default:
                    trace("金叶子寄卖行收到的服务器消息有问题");
            };
        }
        private function updateExchageRate(_arg1:NetPacket):void{
            var _local4:GLRateVO;
            var _local7:uint;
            var _local2:uint = _arg1.readUnsignedByte();
            var _local3:int;
            var _local5:Array = [];
            var _local6:Array = [];
            while (_local3 < _local2) {
                _local4 = new GLRateVO();
                _local7 = _arg1.readUnsignedInt();
                _local4.price = (_local7 / 100);
                _local4.price2 = (_local7 % 100);
                _local4.amount = (_arg1.readUnsignedInt() / 100);
                _local4.type = 0;
                _local6.push(_local4);
                _local3++;
            };
            _local6.reverse();
            var _local8:uint = _arg1.readUnsignedByte();
            _local3 = 0;
            while (_local3 < _local8) {
                _local4 = new GLRateVO();
                _local7 = _arg1.readUnsignedInt();
                _local4.price = (_local7 / 100);
                _local4.price2 = (_local7 % 100);
                _local4.amount = (_arg1.readUnsignedInt() / 100);
                _local4.type = 1;
                _local5.push(_local4);
                _local3++;
            };
            facade.sendNotification(EventList.UPDATE_EXCHANGERATE, [_local5, _local6]);
        }
        private function updateExchangeLog(_arg1:NetPacket):void{
            var _local4:GLLogVO;
            var _local6:uint;
            var _local7:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:int;
            var _local5:Array = [];
            while (_local3 < _local2) {
                _local4 = new GLLogVO();
                _local4.logID = _arg1.readUnsignedInt();
                _local4.logType = _arg1.readByte();
                _local4.logStatus = _arg1.readByte();
                _local4.logTotal = (_arg1.readUnsignedInt() / 100);
                _local4.logCount = (_arg1.readUnsignedInt() / 100);
                _local6 = _arg1.readUnsignedInt();
                _local4.logPrice = (_local6 / 100);
                _local4.logPrice2 = (_local6 % 100);
                _local7 = (_arg1.readUnsignedInt() / 100);
                _local4.logDealPrice = (_local7 / 100);
                _local4.logDealPrice2 = (_local7 % 100);
                _local4.logDealTime = _arg1.readUnsignedInt();
                _local5.push(_local4);
                _local3++;
            };
            _local5.sortOn(["logStatus", "logID"], [Array.NUMERIC, Array.NUMERIC]);
            _local5.reverse();
            facade.sendNotification(EventList.UPDATE_EXCHANGELOG, _local5);
        }
        private function updateBankMoney(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Object = new Object();
            _local4[0] = _local2;
            _local4[1] = _local3;
            facade.sendNotification(EventList.UPDATE_BANKMONEY, _local4);
        }

    }
}//package Net.PackHandler 
