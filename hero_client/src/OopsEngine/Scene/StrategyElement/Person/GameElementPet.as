//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsFramework.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import Manager.*;
    import OopsEngine.Utils.*;
    import OopsEngine.AI.PathFinder.*;

    public class GameElementPet extends GameElementAnimal {

        private var _pathFinder:PathFinder;
        private var pathDirArray:Array;
        private var moveStepCount:int;
        public var isWalk:Boolean = true;
        public var MomentMove:Function;
        private var endPoint:Point;
        private var isAStarMoving:Boolean = false;
        public var PetMovePath:Array;

        public function GameElementPet(_arg1:Game){
            pathDirArray = new Array();
            super(_arg1, new GameElementEnemySkin(this));
        }
        public static function AddPetPath(_arg1:Array, _arg2:Point, _arg3:Point, _arg4:int):Array{
            var _local5:Point;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            _arg1.push([_arg3.x, _arg3.y]);
            return (_arg1);
        }
        public static function GetPetPoint(_arg1:Point, _arg2:int, _arg3:Point):Point{
            var _local5:int;
            var _local4:Point = new Point(0, 0);
            switch (_arg2){
                case 1:
                    _local5 = -135;
                    _local4.x = (_arg1.x - 2);
                    _local4.y = _arg1.y;
                    break;
                case 2:
                    _local5 = 180;
                    _local4.x = (_arg1.x - 2);
                    _local4.y = _arg1.y;
                    break;
                case 3:
                    _local5 = 135;
                    _local4.x = _arg1.x;
                    _local4.y = (_arg1.y - 2);
                    break;
                case 4:
                    _local5 = -90;
                    _local4.x = _arg1.x;
                    _local4.y = (_arg1.y + 2);
                    break;
                case 6:
                    _local5 = 90;
                    _local4.x = _arg1.x;
                    _local4.y = (_arg1.y - 2);
                    break;
                case 7:
                    _local5 = -45;
                    _local4.x = _arg1.x;
                    _local4.y = (_arg1.y + 2);
                    break;
                case 8:
                    _local5 = 0;
                    _local4.x = (_arg1.x + 2);
                    _local4.y = _arg1.y;
                    break;
                case 9:
                    _local5 = 45;
                    _local4.x = (_arg1.x + 2);
                    _local4.y = _arg1.y;
                    break;
            };
            if ((((_arg3.x == _local4.x)) && ((_arg3.y == _local4.y)))){
                return (null);
            };
            return (_local4);
        }

        override protected function onMoveStep():void{
            super.onMoveStep();
        }
        public function MoveAStar(_arg1:Array):void{
            var _local2:int;
            var _local3:Point;
            var _local4:int;
            if (smoothMove == null){
                return;
            };
            this.smoothMove.clearPath();
            PetMovePath = _arg1;
            this.isAStarMoving = true;
            this.pathDirArray = new Array();
            var _local5:Array = new Array();
            if (((_arg1) && ((_arg1.length > 1)))){
                _local2 = 1;
                while (_local2 < _arg1.length) {
                    this.pathDirArray.push(MapTileModel.Direction(_arg1[(_local2 - 1)].x, _arg1[(_local2 - 1)].y, _arg1[_local2].x, _arg1[_local2].y));
                    _local3 = MapTileModel.GetTilePointToStage(_arg1[_local2].x, _arg1[_local2].y);
                    _local5.push(_local3.add(new Point(-(this.excursionX), -(this.excursionY))));
                    _local2++;
                };
                if (_local5.length > 0){
                    if (this.smoothMove.IsMoving){
                        _local4 = 0;
                        while (_local4 < _local5.length) {
                            if (!(((this.smoothMove.EndPoint.x == _local5[_local4].x)) && ((this.smoothMove.EndPoint.y == _local5[_local4].y)))){
                                this.smoothMove.AddPath((_local5[_local4] as Point));
                            };
                            _local4++;
                        };
                    } else {
                        this.smoothMove.Move(_local5);
                    };
                };
            } else {
                this.Stop();
            };
        }
        private function AStarMove(_arg1:int=0):void{
            var _local2:int;
            var _local3:int;
            var _local4:Point;
            var _local5:int;
            this.isAStarMoving = true;
            var _local6:Point = new Point(this.Role.TileX, this.Role.TileY);
            this.pathDirArray = new Array();
            var _local7:Array = new Array();
            var _local8:Array = this.pathFinder.findpath(_local6.x, _local6.y, this.endPoint.x, this.endPoint.y);
            if (((!((_local8 == null))) && ((_local8.length > 1)))){
                PetMovePath = _local8;
                _local2 = 1;
                while (_local2 < _local8.length) {
                    this.pathDirArray.push(MapTileModel.Direction(_local8[(_local2 - 1)].x, _local8[(_local2 - 1)].y, _local8[_local2].x, _local8[_local2].y));
                    _local4 = MapTileModel.GetTilePointToStage(_local8[_local2].x, _local8[_local2].y);
                    _local7.push(_local4.add(new Point(-(this.excursionX), -(this.excursionY))));
                    _local2++;
                };
                _local3 = 1;
                while (_local3 <= _arg1) {
                    if (((!((_local7 == null))) && ((_local7.length > 0)))){
                        _local7.pop();
                    };
                    _local3++;
                };
                if (_local7.length > 0){
                    if (this.smoothMove.IsMoving){
                        _local5 = 0;
                        while (_local5 < _local7.length) {
                            this.smoothMove.AddPath((_local7[_local5] as Point));
                            _local5++;
                        };
                    } else {
                        this.smoothMove.Move(_local7);
                    };
                };
            } else {
                this.Stop();
            };
        }
        public function MoveSeek():void{
            if (this.Role.MasterPlayer){
                if (((this.Role.MasterPlayer.prepPoint) && (!((((this.Role.MasterPlayer.prepPoint.x == 0)) && ((this.Role.MasterPlayer.prepPoint.y == 0))))))){
                    this.endPoint = this.Role.MasterPlayer.prepPoint;
                    AStarMove();
                };
                this.isWalk = true;
            };
        }
        public function ToMasterMove():void{
            PetController.getInstance().ToMasterMove(this);
        }
        override public function Stop():void{
            this.pathDirArray = null;
            this.isAStarMoving = false;
            if (this.smoothMove){
                this.smoothMove.IsMoving = false;
            };
            PetMovePath = null;
            if (this.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK){
                this.SetAction(GameElementSkins.ACTION_STATIC);
            };
            super.Stop();
        }
        public function DistanceMaster(_arg1:GameElementAnimal):void{
            if (MomentMove != null){
                MomentMove();
            };
        }
        public function clearPath():void{
            if (this.smoothMove){
                this.smoothMove.clearPath();
            };
        }
        override public function SetParentScene(_arg1:GameScene):void{
            super.SetParentScene(_arg1);
            if (((((this.gameScene) && (this.gameScene.Map))) && (this.gameScene.Map.Map))){
                this._pathFinder = new PathFinder(this.gameScene.Map.Map);
            } else {
                this._pathFinder = null;
            };
        }
        public function get pathFinder():PathFinder{
            return (_pathFinder);
        }
        override protected function onMoveComplete():void{
            super.onMoveComplete();
            this.Stop();
            this.SetAction(GameElementSkins.ACTION_STATIC);
            if (MoveComplete != null){
                MoveComplete();
            };
        }
        override protected function onMoveNode(_arg1:int):Boolean{
            var _local3:int;
            var _local4:int;
            var _local5:Point;
            super.onMoveNode(_arg1);
            var _local2:Boolean;
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))) && (!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))))){
                this.Role.Direction = _arg1;
                this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);
            };
            if ((this.moveStepCount % 2) == 0){
                if (PathDirection){
                    _local3 = PathDirection.shift();
                    _local4 = 0;
                    if (PathDirection.length != 0){
                        _local4 = PathDirection.shift();
                    };
                    _local5 = MapTileModel.GetNextPos(Role.TileX, Role.TileY, _local3);
                    if (_local4 > 0){
                        _local5 = MapTileModel.GetNextPos(_local5.x, _local5.y, _local4);
                    };
                    Role.TileX = _local5.x;
                    Role.TileY = _local5.y;
                };
            };
            this.moveStepCount++;
            if (MoveNode != null){
                _local2 = MoveNode(_arg1);
            };
            return (_local2);
        }
        override public function Move(_arg1:Point, _arg2:int=0):void{
            var _local3:Point;
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))) && (!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                _local3 = _arg1.add(new Point(-(this.excursionX), -(this.excursionY)));
                if (this.smoothMove.IsMoving){
                    this.smoothMove.AddPath(_local3);
                } else {
                    this.smoothMove.Move([_local3]);
                };
                this.Role.Direction = Vector2.DirectionByTan(this.GameX, this.GameY, _arg1.x, _arg1.y);
                this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);
            };
        }
        public function get PathDirection():Array{
            return (this.pathDirArray);
        }
        override public function MoveTile(_arg1:Point, _arg2:int=0):void{
            clearPath();
            this.Move(MapTileModel.GetTilePointToStage(_arg1.x, _arg1.y));
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
