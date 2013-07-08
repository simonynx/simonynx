//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import OopsEngine.AI.PathFinder.*;

    public class GameElementConvoycar extends GameElementAnimal {

        public function GameElementConvoycar(_arg1:Game){
            super(_arg1, new GameElementEnemySkin(this));
        }
        override public function Initialize():void{
            super.Initialize();
            this.mouseEnabled = false;
            this.mouseChildren = false;
        }
        override public function Move(_arg1:Point, _arg2:int=0):void{
            var _local3:Point;
            var _local4:Point;
            if (!(((this.GameX == _arg1.x)) && ((this.GameY == _arg1.y)))){
                _local3 = _arg1.add(new Point(-(this.excursionX), -(this.excursionY)));
                if (smoothMove.getPath()){
                    _local4 = smoothMove.EndPoint;
                    if (smoothMove.getPath().length > 0){
                        _local4 = smoothMove.getPath()[(smoothMove.getPath().length - 1)];
                    };
                    if (((_local4) && ((((_local4.x == _local3.x)) && ((_local4.y == _local3.y)))))){
                        return;
                    };
                };
                if (this.smoothMove.IsMoving){
                    this.smoothMove.AddPath(_local3);
                } else {
                    this.smoothMove.Move([_local3]);
                };
            };
        }
        override protected function onMoveNode(_arg1:int):Boolean{
            super.onMoveNode(_arg1);
            var _local2:Boolean;
            this.Role.Direction = _arg1;
            this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);
            if (MoveNode != null){
                _local2 = MoveNode(_arg1);
            };
            return (_local2);
        }
        override public function Stop():void{
            this.smoothMove.IsMoving = false;
            super.Stop();
        }
        public function onConvoyCarMoveToMaster():void{
            var _local1:GameElementPlayer = this.Role.MasterPlayer;
            if (((((_local1) && ((((_local1.Role.Type == GameRole.TYPE_OWNER)) || ((_local1.Role.Type == GameRole.TYPE_PLAYER)))))) && ((_local1.Role.ConvoyFlag > 0)))){
                if (!_local1.Role.preTilePoint){
                    return;
                };
                MoveTile(_local1.Role.preTilePoint);
            };
        }
        override public function SetAction(_arg1:String, _arg2:int=0):void{
            super.SetAction(_arg1, _arg2);
        }
        override protected function onMoveComplete():void{
            super.onMoveComplete();
            this.SetAction(GameElementSkins.ACTION_STATIC);
            if (MoveComplete != null){
                MoveComplete();
            };
        }
        public function MoveAStar(_arg1:Array):void{
            var _local2:int;
            if (((_arg1) && ((_arg1.length > 0)))){
                if (_arg1.length > 0){
                    if (this.smoothMove.IsMoving){
                        _local2 = 0;
                        while (_local2 < _arg1.length) {
                            this.smoothMove.AddPath((_arg1[_local2] as Point));
                            _local2++;
                        };
                    } else {
                        this.smoothMove.Move(_arg1);
                    };
                };
            } else {
                this.Stop();
            };
        }
        override public function MoveTile(_arg1:Point, _arg2:int=0):void{
            this.Move(MapTileModel.GetTilePointToStage(_arg1.x, _arg1.y));
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
