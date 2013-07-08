//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.Datas {

    public class TeamPlayerVo {

        private var _id:int;
        private var _Face:int;
        private var _Job:int;
        private var _Level:int;
        private var _name:String;
        private var _teamId:int;
        private var _isLeader:Boolean;

        public function set Job(_arg1:int):void{
            _Job = _arg1;
        }
        public function set Level(_arg1:int):void{
            _Level = _arg1;
        }
        public function get isLeader():Boolean{
            return (_isLeader);
        }
        public function set Name(_arg1:String):void{
            _name = _arg1;
        }
        public function get teamId():int{
            return (_teamId);
        }
        public function get Job():int{
            return (_Job);
        }
        public function set isLeader(_arg1:Boolean):void{
            _isLeader = _arg1;
        }
        public function get Level():int{
            return (_Level);
        }
        public function set teamId(_arg1:int):void{
            _teamId = _arg1;
        }
        public function get Name():String{
            return (_name);
        }
        public function set Id(_arg1:int):void{
            _id = _arg1;
        }
        public function set Face(_arg1:int):void{
            _Face = _arg1;
        }
        public function get Id():int{
            return (_id);
        }
        public function get Face():int{
            return (_Face);
        }

    }
}//package GameUI.Modules.Team.Datas 
