//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.model.vo {
    import Net.*;

    public class FriendInfoStruct {

        public var idTeamLeader:uint;
        public var level:uint;
        public var sex:uint;
        public var frendId:uint = 0;
        private var _lineId:int;
        public var idTeam:uint;
        public var roleName:String;
        public var type:int;
        private var _isOnline:Boolean;

        public function ReadFromPacket(_arg1:NetPacket):void{
            lineId = _arg1.readUnsignedInt();
            frendId = _arg1.readUnsignedInt();
            roleName = _arg1.ReadString();
            sex = _arg1.readUnsignedInt();
            level = _arg1.readUnsignedInt();
        }
        public function set isOnline(_arg1:Boolean):void{
            _isOnline = _arg1;
        }
        public function get lineId():int{
            return (_lineId);
        }
        public function get isOnline():Boolean{
            return (_isOnline);
        }
        public function set lineId(_arg1:int):void{
            _lineId = _arg1;
            _isOnline = ((_lineId == 0)) ? false : true;
        }

    }
}//package GameUI.Modules.Friend.model.vo 
