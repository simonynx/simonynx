//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.Datas {

    public class TeamVo {

        private var _leaderName:String;
        private var _Face:int;
        private var _leaderId:int;
        private var _isAutoJoinMode:Boolean;
        private var _curCnt:int;
        private var _name:String;
        private var _teamLevel;
        private var _teamId:int;

        public function get leaderId():int{
            return (_leaderId);
        }
        public function set leaderId(_arg1:int):void{
            _leaderId = _arg1;
        }
        public function get curCnt():int{
            return (_curCnt);
        }
        public function set isAutoJoinMode(_arg1:Boolean):void{
            _isAutoJoinMode = _arg1;
        }
        public function get isAutoJoinMode():Boolean{
            return (_isAutoJoinMode);
        }
        public function set teamLevel(_arg1):void{
            _teamLevel = _arg1;
        }
        public function set curCnt(_arg1:int):void{
            _curCnt = _arg1;
        }
        public function set Name(_arg1:String):void{
            _name = _arg1;
        }
        public function get teamId():int{
            return (_teamId);
        }
        public function get teamLevel(){
            return (_teamLevel);
        }
        public function get Name():String{
            return (_name);
        }
        public function set teamId(_arg1:int):void{
            _teamId = _arg1;
        }
        public function get leaderName():String{
            return (_leaderName);
        }
        public function set leaderName(_arg1:String):void{
            _leaderName = _arg1;
        }
        public function set Face(_arg1:int):void{
            _Face = _arg1;
        }
        public function get Face():int{
            return (_Face);
        }

    }
}//package GameUI.Modules.Team.Datas 
