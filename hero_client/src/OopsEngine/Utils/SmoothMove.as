//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Utils {
    import flash.display.*;
    import OopsFramework.*;
    import flash.geom.*;

    public class SmoothMove {

        private const dirFactor:Number = 1.6;
        private const dirFactor2:Number = 2;

        private var _direction:int;
        private var _MoveStepLength:int;
        public var MoveComplete:Function;
        private var moveBetweenDistance:Number;
        private var startPoint:Point;
        public var MoveNode:Function;
        public var MoveStep:Function;
        private var moveIncrement:Point;
        private var isMoving:Boolean = false;
        private var displayObject:DisplayObject;
        private var path:Array;
        private var moveDistance:Number;
        private var cacheTime:int = 0;
        private var endPoint:Point;
        private var moveSpeed:Number;

        public function SmoothMove(_arg1:DisplayObject, _arg2:int){
            this.displayObject = _arg1;
            this.MoveStepLength = _arg2;
            this.moveSpeed = _arg2;
        }
        public function set direction(_arg1:int):void{
            if (_direction == _arg1){
                return;
            };
            _direction = _arg1;
        }
        public function AddPath(_arg1:Point):void{
            if (this.path != null){
                this.path.push(_arg1);
            };
        }
        public function set MoveStepLength(_arg1:int):void{
            _MoveStepLength = _arg1;
        }
        private function update(_arg1:int):void{
            var _local2:Number;
            var _local3:Number;
            var _local4:int;
            var _local5:Number;
            var _local6:Number;
            if (this.isMoving){
                _local2 = this.displayObject.x;
                _local3 = this.displayObject.y;
                _local6 = (this.MoveStepLength * (_arg1 / 33));
                this.moveIncrement = Vector2.MoveIncrement(this.startPoint, this.endPoint, _local6);
                this.moveDistance = (this.moveDistance + _local6);
                _local2 = (_local2 + moveIncrement.x);
                _local3 = (_local3 + moveIncrement.y);
                if (this.moveDistance >= this.moveBetweenDistance){
                    if (((!((this.path == null))) && ((this.path.length > 0)))){
                        this.startPoint = this.endPoint;
                        this.endPoint = this.path.shift();
                        _local4 = Vector2.DirectionByTan(this.startPoint.x, this.startPoint.y, endPoint.x, endPoint.y);
                        _local5 = Point.distance(this.startPoint, this.endPoint);
                        this.moveIncrement = Vector2.MoveIncrement(this.startPoint, this.endPoint, _local6);
                        if (_local4 == this.direction){
                            this.moveBetweenDistance = (this.moveBetweenDistance + _local5);
                        } else {
                            _local2 = this.startPoint.x;
                            _local3 = this.startPoint.y;
                            this.moveBetweenDistance = Point.distance(this.startPoint, this.endPoint);
                            this.moveDistance = 0;
                        };
                        this.direction = _local4;
                        if (MoveNode != null){
                            if (!MoveNode(this.direction)){
                                return;
                            };
                        };
                    };
                };
                if (this.isMoving){
                    if (this.moveDistance >= this.moveBetweenDistance){
                        _local2 = this.endPoint.x;
                        _local3 = this.endPoint.y;
                        this.isMoving = false;
                        this.Reset();
                        if (MoveComplete != null){
                            MoveComplete();
                        };
                    };
                } else {
                    this.Reset();
                    if (MoveComplete != null){
                        MoveComplete();
                    };
                };
                this.displayObject.x = _local2;
                this.displayObject.y = _local3;
            };
        }
        public function clearPath():void{
            path = [];
        }
        public function get direction():int{
            return (_direction);
        }
        public function getPath():Array{
            return (path);
        }
        public function get MoveStepLength():int{
            return (_MoveStepLength);
        }
        public function get EndPoint():Point{
            return (this.endPoint);
        }
        public function Update(_arg1:GameTime):void{
            cacheTime = _arg1.ElapsedGameTime;
            while (cacheTime > 50) {
                update(50);
                cacheTime = (cacheTime - 50);
            };
            update(cacheTime);
            if (MoveStep != null){
                MoveStep();
            };
        }
        public function Move(_arg1:Array):void{
            this.Reset();
            this.path = _arg1;
            this.startPoint = new Point(this.displayObject.x, this.displayObject.y);
            this.endPoint = this.path.shift();
            this.direction = Vector2.DirectionByTan(this.startPoint.x, this.startPoint.y, endPoint.x, endPoint.y);
            this.moveIncrement = Vector2.MoveIncrement(this.startPoint, this.endPoint, this.MoveStepLength);
            this.moveBetweenDistance = Point.distance(this.startPoint, this.endPoint);
            this.moveDistance = 0;
            this.isMoving = true;
            if (MoveNode != null){
                MoveNode(this.direction);
            };
        }
        public function set IsMoving(_arg1:Boolean):void{
            this.isMoving = _arg1;
            if (this.isMoving == false){
                this.path = null;
            };
        }
        private function Reset():void{
            this.moveDistance = 0;
            this.moveBetweenDistance = 0;
            this.moveIncrement = null;
            this.path = null;
            this.endPoint = null;
            this.cacheTime = 0;
        }
        public function get IsMoving():Boolean{
            return (this.isMoving);
        }

    }
}//package OopsEngine.Utils 
