//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyScene {
    import OopsFramework.*;
    import OopsEngine.Scene.*;
    import flash.geom.*;
    import OopsEngine.Utils.*;
    import OopsEngine.AI.PathFinder.*;

    public class GameScenePlay extends GameScene {

        public var IsUpdateNicetyPoint:Point = null;
        private var SquareBox:Rectangle;
        private var BoxHeight:uint = 174;
        public var IsUpdateNicety:Boolean = false;
        public var MinMoveDistance:Number = 30;
        private var BoxWidth:uint = 300;
        private var RealPos:Point;
        private var _ScrollFlag:Boolean = false;

        public function GameScenePlay(_arg1:Game){
            SquareBox = new Rectangle();
            RealPos = new Point();
            super(_arg1);
            this.MouseEnabled = true;
        }
        public function SetSquareBox():void{
            if (ScrollFlag){
                this.SquareBox.left = (this.x - (BoxWidth / 2));
                this.SquareBox.top = (this.y - (BoxHeight / 2));
                this.SquareBox.width = BoxWidth;
                this.SquareBox.height = BoxHeight;
                RealPos.x = x;
                RealPos.y = y;
            };
        }
        public function set ScrollFlag(_arg1:Boolean):void{
            var _local2:Point;
            var _local3:Number;
            var _local4:Number;
            _ScrollFlag = _arg1;
            if (_ScrollFlag){
                SetSquareBox();
            } else {
                _local2 = MapTileModel.GetTilePointToStage(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
                _local3 = ((this.Games.ScreenWidth / 2) - _local2.x);
                _local4 = ((this.Games.ScreenHeight / 2) - _local2.y);
                if (_local3 > 0){
                    _local3 = 0;
                } else {
                    if (_local3 < -(((this.MapWidth + this.OffsetX) - this.Games.ScreenWidth))){
                        _local3 = -(((this.MapWidth + this.OffsetX) - this.Games.ScreenWidth));
                    };
                };
                if (_local4 > 0){
                    _local4 = 0;
                } else {
                    if (_local4 < -(((this.MapHeight + this.OffsetY) - this.Games.ScreenHeight))){
                        _local4 = -(((this.MapHeight + this.OffsetY) - this.Games.ScreenHeight));
                    };
                };
            };
            IsUpdateNicetyPoint = new Point(_local3, _local4);
        }
        public function SceneMove(_arg1:Number, _arg2:Number, _arg3:Boolean=false):Point{
            var _local4:Point;
            var _local5:Point;
            var _local6:Number;
            var _local7:Point;
            var _local10:Point;
            var _local8:Number = ((this.Games.ScreenWidth / 2) - _arg1);
            var _local9:Number = ((this.Games.ScreenHeight / 2) - _arg2);
            if (ScrollFlag == false){
                if (_local8 > 0){
                    _local8 = 0;
                } else {
                    if (_local8 < -(((this.MapWidth + this.OffsetX) - this.Games.ScreenWidth))){
                        _local8 = -(((this.MapWidth + this.OffsetX) - this.Games.ScreenWidth));
                    };
                };
                if (_local9 > 0){
                    _local9 = 0;
                } else {
                    if (_local9 < -(((this.MapHeight + this.OffsetY) - this.Games.ScreenHeight))){
                        _local9 = -(((this.MapHeight + this.OffsetY) - this.Games.ScreenHeight));
                    };
                };
            } else {
                if (_local8 > 175){
                    _local8 = 175;
                } else {
                    if (_local8 < (-(((this.MapWidth + this.OffsetX) - this.Games.ScreenWidth)) - 175)){
                        _local8 = (-(((this.MapWidth + this.OffsetX) - this.Games.ScreenWidth)) - 175);
                    };
                };
                if (_local9 > 76){
                    _local9 = 76;
                } else {
                    if (_local9 < (-(((this.MapHeight + this.OffsetY) - this.Games.ScreenHeight)) - 76)){
                        _local9 = (-(((this.MapHeight + this.OffsetY) - this.Games.ScreenHeight)) - 76);
                    };
                };
            };
            IsUpdateNicetyPoint = new Point(_local8, _local9);
            if (_arg3){
                return (new Point(_local8, _local9));
            };
            _local4 = new Point(this.x, this.y);
            _local5 = new Point(_local8, _local9);
            _local6 = Point.distance(_local4, _local5);
            if (_local6 < MinMoveDistance){
                RealPos = _local4;
            } else {
                _local7 = Vector2.MoveDistance(_local4, _local5, (_local6 - MinMoveDistance));
                RealPos = _local7;
            };
            if (ScrollFlag){
                _local10 = CalcSquareOffset(RealPos);
                CalcSquareOffset(RealPos).x = (_local10.x + this.x);
                _local10.y = (_local10.y + this.y);
                return (_local10);
            };
            return (RealPos);
        }
        override public function Update(_arg1:GameTime):void{
            var _local2:Point;
            var _local3:Number;
            var _local4:Point;
            if (((((IsUpdateNicety) && (IsUpdateNicetyPoint))) && ((ScrollFlag == false)))){
                _local2 = new Point(this.x, this.y);
                _local3 = Point.distance(_local2, IsUpdateNicetyPoint);
                if (_local3 > 4){
                    _local4 = Vector2.MoveDistance(_local2, IsUpdateNicetyPoint, 4);
                    this.x = _local4.x;
                    this.y = _local4.y;
                } else {
                    IsUpdateNicety = false;
                    IsUpdateNicetyPoint = null;
                };
                if (UpdateNicety != null){
                    UpdateNicety();
                };
            };
            super.Update(_arg1);
        }
        private function CalcSquareOffset(_arg1:Point):Point{
            var _local2:Point = new Point(0, 0);
            if ((((((((_arg1.x >= SquareBox.left)) && ((_arg1.x <= SquareBox.right)))) && ((_arg1.y >= SquareBox.top)))) && ((_arg1.y <= SquareBox.bottom)))){
                return (_local2);
            };
            if (_arg1.x < SquareBox.left){
                _local2.x = (_arg1.x - SquareBox.x);
                SquareBox.x = _arg1.x;
            } else {
                if (_arg1.x > SquareBox.right){
                    _local2.x = (_arg1.x - (SquareBox.x + SquareBox.width));
                    SquareBox.x = (_arg1.x - SquareBox.width);
                };
            };
            if (_arg1.y < SquareBox.top){
                _local2.y = (_arg1.y - SquareBox.y);
                SquareBox.y = _arg1.y;
            } else {
                if (_arg1.y > SquareBox.bottom){
                    _local2.y = (_arg1.y - (SquareBox.y + SquareBox.height));
                    SquareBox.y = (_arg1.y - SquareBox.height);
                };
            };
            return (_local2);
        }
        public function get ScrollFlag():Boolean{
            return (_ScrollFlag);
        }

    }
}//package OopsEngine.Scene.StrategyScene 
