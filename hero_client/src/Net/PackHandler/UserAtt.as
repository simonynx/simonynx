//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import Net.*;

    public class UserAtt extends GameAction {

        private static var _instance:UserAtt;

        public function UserAtt(_arg1:Boolean=true){
            super(_arg1);
            if (_instance != null){
                throw (new Error("单体出错了"));
            };
        }
        public static function getInstance():UserAtt{
            if (_instance == null){
                _instance = new (UserAtt)();
            };
            return (_instance);
        }

        private function getInfoProperty(_arg1:NetPacket):void{
            var _local2:GameRole = GameCommonData.Player.Role;
            _local2.ReadProperties(_arg1);
            facade.sendNotification(EventList.ALLROLEINFO_UPDATE, {
                id:_local2.Id,
                type:1001
            });
            facade.sendNotification(EventList.UPDATE_MYATTRIBUATT);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_PROPUPDATE:
                    getInfoProperty(_arg1);
                    break;
            };
        }

    }
}//package Net.PackHandler 
