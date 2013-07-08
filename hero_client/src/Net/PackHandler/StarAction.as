//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Constellation.Mediator.*;

    public class StarAction extends GameAction {

        private static var instance:StarAction;

        private var _packet:NetPacket;

        public function StarAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():StarAction{
            if (instance == null){
                instance = new (StarAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_PLAYER_CONSTELLATION_STATE:
                    updateStarState(_arg1);
                    break;
                case Protocol.SMSG_CONSTELLATION_TRAIN_START:
                    startResult(_arg1);
                    break;
                case Protocol.SMSG_CONSTELLATION_TRAIN_FINISH:
                    trainResult(_arg1);
                    break;
                default:
                    trace("星座面板收到的服务器消息有问题");
            };
        }
        private function trainResult(_arg1:NetPacket):void{
            var _local2:Object = new Object();
            _local2.result = _arg1.readByte();
            if (_local2.result == 0){
                _local2.node = _arg1.readUnsignedInt();
                _local2.newTime = _arg1.readUnsignedInt();
                sendNotification(EventList.UPDATE_FINISH_STATE, _local2);
            } else {
                if (_local2.result == 1){
                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("时间未到无法完成"));
                } else {
                    if (_local2.result == 2){
                        sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("金叶子不够无法完成"));
                    } else {
                        if (_local2.result == 3){
                            sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("其他原因无法完成"));
                        };
                    };
                };
            };
        }
        private function updateStarState(_arg1:NetPacket):void{
            var _local2:Object = new Object();
            _local2["current"] = _arg1.readUnsignedInt();
            _local2["time"] = _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:int;
            _local2["finish"] = new Array();
            while (_local4 < _local3) {
                _local2["finish"].push(_arg1.readUnsignedInt());
                _local4++;
            };
            if (facade.retrieveMediator(StarMediator.NAME) == null){
                facade.registerMediator(new StarMediator(null));
            };
            sendNotification(EventList.UPDATE_STAR_STATE, _local2);
        }
        private function startResult(_arg1:NetPacket):void{
            var _local2:Object = new Object();
            _local2.result = _arg1.readByte();
            if (_local2.result == 0){
                _local2.current = _arg1.readUnsignedInt();
                _local2.time = _arg1.readUnsignedInt();
                _local2.end = _arg1.readUnsignedInt();
                sendNotification(EventList.UPDATE_START_STATE, _local2);
            } else {
                if (_local2.result == 1){
                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("无法同时修习两个"));
                } else {
                    if (_local2.result == 2){
                        sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("等级不够"));
                    } else {
                        if (_local2.result == 3){
                            sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("金钱不够"));
                        } else {
                            if (_local2.result == 4){
                                sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("经验值不够"));
                            } else {
                                if (_local2.result == 5){
                                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("星辰碎片不够"));
                                } else {
                                    if (_local2.result == 6){
                                        sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("上层星座还没完成"));
                                    } else {
                                        sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("其他原因无法完成"));
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

    }
}//package Net.PackHandler 
