//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.UI {
    import flash.display.*;
    import OopsEngine.Role.*;
    import GameUI.Modules.PlayerInfo.Command.*;

    public class TeamList extends Sprite {

        public static const PADDING:uint = 5;

        protected var _dataPro:Array;
        protected var cells:Array;

        public function TeamList(_arg1:Array=null){
            this._dataPro = _arg1;
            this.cells = [];
        }
        public function get dataPro():Array{
            return (_dataPro);
        }
        public function set dataPro(_arg1:Array):void{
            this.removeAll();
            this._dataPro = _arg1;
            this.createChildren();
        }
        protected function onCellCLick(_arg1:TeamEvent):void{
            var _local2:TeamEvent = new TeamEvent(TeamEvent.CELL_CLICK, false, false);
            _local2.flagStr = _arg1.flagStr;
            _local2.role = _arg1.role;
            this.dispatchEvent(_local2);
        }
        public function upDate(_arg1:Array):void{
            var _local2:GameRole;
            var _local3:TeamCell;
            var _local5:int;
            var _local4:uint = _arg1.length;
            while (_local5 < _local4) {
                _local2 = (_arg1[_local5] as GameRole);
                _local3 = (cells[_local5] as TeamCell);
                _local3.setHp(_local2.HP, (_local2.MaxHp + _local2.AdditionAtt.MaxHP));
                _local3.setMp(_local2.MP, (_local2.MaxMp + _local2.AdditionAtt.MaxMP));
                _local3.setLevel(_local2.Level);
                _local3.setFace(_local2.Face);
                _local3.setBuffs(_local2);
                _local5++;
            };
        }
        protected function createChildren():void{
            var _local1:GameRole;
            var _local2:TeamCell;
            var _local3:Sprite;
            var _local4:uint;
            this.cells = [];
            for each (_local1 in this._dataPro) {
                _local2 = new TeamCell(_local1);
                _local2.mouseEnabled = false;
                _local2.addEventListener(TeamEvent.CELL_CLICK, onCellCLick);
                this.addChild(_local2);
                this.cells.push(_local2);
                _local4++;
            };
            this.doLayout();
        }
        protected function doLayout():void{
            var _local1:TeamCell;
            var _local2:Number = 0;
            for each (_local1 in this.cells) {
                _local1.x = 0;
                _local1.y = _local2;
                _local2 = (_local2 + 70);
            };
        }
        protected function searchTeamCellById(_arg1:uint):TeamCell{
            var _local2:TeamCell;
            for each (_local2 in this.cells) {
                if (_local2.role.Id == _arg1){
                    return (_local2);
                };
            };
            return (null);
        }
        public function updateStatus(_arg1:uint, _arg2:uint=0):void{
            var _local3:TeamCell = this.searchTeamCellById(_arg1);
            if (_local3 == null){
                return;
            };
            var _local4:* = "";
            switch (_arg2){
                case 0:
                    _local3.setFarTeam(false);
                    break;
                case 1:
                    _local3.setFarTeam(true);
                    break;
                case 2:
                    break;
                case 3:
                    break;
            };
            _local3.updateLineDes(_local4, _arg2);
        }
        public function removeAll():void{
            var _local1:TeamCell;
            for each (_local1 in this.cells) {
                if (this.contains(_local1)){
                    _local1.removeEventListener(TeamEvent.CELL_CLICK, onCellCLick);
                    this.removeChild(_local1);
                    _local1 = null;
                };
            };
        }

    }
}//package GameUI.Modules.PlayerInfo.UI 
