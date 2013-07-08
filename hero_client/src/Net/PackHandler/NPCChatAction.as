//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import Net.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import GameUI.Modules.NPCChat.Command.*;

    public class NPCChatAction extends GameAction {

        private static var _instance:NPCChatAction;

        public function NPCChatAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():NPCChatAction{
            if (!_instance){
                _instance = new (NPCChatAction)();
            };
            return (_instance);
        }

        private function gossIpMessage(_arg1:NetPacket):void{
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:Boolean;
            var _local13:String;
            var _local14:String;
            var _local15:String;
            var _local16:int;
            var _local17:int;
            var _local18:String;
            var _local2:PipeDataProxy = (facade.retrieveProxy(PipeDataProxy.NAME) as PipeDataProxy);
            var _local3:int = _arg1.readUnsignedInt();
            _local2.desText = _arg1.ReadString();
            var _local4:int = _arg1.readUnsignedInt();
            var _local5:int;
            while (_local5 < _local4) {
                _local9 = _arg1.readUnsignedInt();
                _local10 = _arg1.readUnsignedInt();
                _local11 = _arg1.readByte();
                _local12 = _arg1.readBoolean();
                _local13 = DialogConstData.getInstance().getSymbolName(_local11);
                _local14 = _arg1.ReadString();
                _local15 = _arg1.ReadString();
                _local2.linkArr.push({
                    iconUrl:_local13,
                    showText:_local14,
                    EventID:_local10,
                    linkId:_local9,
                    type:DialogConstData.CHATTYPE_OTHER,
                    code:_local12,
                    boxmessage:_local15
                });
                _local5++;
            };
            var _local6:Array = [];
            var _local7:int = _arg1.readUnsignedInt();
            var _local8:int;
            while (_local8 < _local7) {
                _local16 = _arg1.readUnsignedInt();
                _local17 = _arg1.readByte();
                _local18 = _arg1.ReadString();
                _local13 = DialogConstData.getInstance().getTaskSymbolByState(_local17);
                if (_local17 == 2){
                } else {
                    _local6.push({
                        iconUrl:_local13,
                        showText:_local18,
                        linkId:_local16,
                        type:DialogConstData.CHATTYPE_TASK,
                        taskState:_local17
                    });
                };
                _local8++;
            };
            _local6.sortOn("taskState", (Array.NUMERIC | Array.DESCENDING));
            _local2.linkArr = _local2.linkArr.concat(_local6);
            DelayOperation.getInstance().unLockNpcTalk();
            sendNotification(NPCChatComList.SHOW_NPC_CHAT, _local3);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_GOSSIP_MESSAGE:
                    gossIpMessage(_arg1);
                    break;
                case Protocol.SMSG_GOSSIP_COMPLETE:
                    gossIpComplete(_arg1);
                    break;
                case Protocol.SMSG_GOSSIP_OPENDLG:
                    gossIpOpenDlg(_arg1);
                    break;
            };
        }
        private function gossIpOpenDlg(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            switch (_local2){
            };
        }
        private function gossIpComplete(_arg1:NetPacket):void{
            sendNotification(NPCChatComList.HIDE_NPC_CHAT);
        }

    }
}//package Net.PackHandler 
