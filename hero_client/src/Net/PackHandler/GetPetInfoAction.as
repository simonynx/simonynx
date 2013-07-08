//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.ConstData.*;
    import Net.*;

    public class GetPetInfoAction extends GameAction {

        private static var instance:GetPetInfoAction;

        private var _packet:NetPacket;

        public function GetPetInfoAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():GetPetInfoAction{
            if (instance == null){
                instance = new (GetPetInfoAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_GET_PETINFO_IN_RANK:
                    updatePetInfo(_arg1);
                    break;
                default:
                    trace("单个宠物信息收到的服务器消息有问题");
            };
        }
        private function updatePetInfo(_arg1:NetPacket):void{
            var _local2:InventoryItemInfo;
            _local2 = new InventoryItemInfo();
            _local2.ReadFromPacket(_arg1);
            sendNotification(EventList.SHOWONEPETVIEW, [_local2]);
        }

    }
}//package Net.PackHandler 
