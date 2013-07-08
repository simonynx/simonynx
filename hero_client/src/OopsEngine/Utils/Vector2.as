//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Utils {
    import flash.geom.*;

    public class Vector2 {

        public static function OppositeDirection(_arg1:int):int{
            return ((10 - _arg1));
        }
        public static function DirectionByTan(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):int{
            var _local5:Number = ((_arg4 - _arg2) / (_arg3 - _arg1));
            if ((((Math.abs(_local5) >= Math.tan(((Math.PI * 3) / 8)))) && ((_arg4 <= _arg2)))){
                return (8);
            };
            if ((((((((Math.abs(_local5) > Math.tan((Math.PI / 8)))) && ((Math.abs(_local5) < Math.tan(((Math.PI * 3) / 8)))))) && ((_arg3 > _arg1)))) && ((_arg4 < _arg2)))){
                return (9);
            };
            if ((((Math.abs(_local5) <= Math.tan((Math.PI / 8)))) && ((_arg3 >= _arg1)))){
                return (6);
            };
            if ((((((((Math.abs(_local5) > Math.tan((Math.PI / 8)))) && ((Math.abs(_local5) < Math.tan(((Math.PI * 3) / 8)))))) && ((_arg3 > _arg1)))) && ((_arg4 > _arg2)))){
                return (3);
            };
            if ((((Math.abs(_local5) >= Math.tan(((Math.PI * 3) / 8)))) && ((_arg4 >= _arg2)))){
                return (2);
            };
            if ((((((((Math.abs(_local5) > Math.tan((Math.PI / 8)))) && ((Math.abs(_local5) < Math.tan(((Math.PI * 3) / 8)))))) && ((_arg3 < _arg1)))) && ((_arg4 > _arg2)))){
                return (1);
            };
            if ((((Math.abs(_local5) <= Math.tan((Math.PI / 8)))) && ((_arg3 <= _arg1)))){
                return (4);
            };
            if ((((((((Math.abs(_local5) > Math.tan((Math.PI / 8)))) && ((Math.abs(_local5) < Math.tan(((Math.PI * 3) / 8)))))) && ((_arg3 < _arg1)))) && ((_arg4 < _arg2)))){
                return (7);
            };
            return (4);
        }
        public static function MoveIncrement(_arg1:Point, _arg2:Point, _arg3:Number):Point{
            var _local4:Number = Point.distance(_arg1, _arg2);
            var _local5:Number = (_arg3 / _local4);
            var _local6:Number = ((_arg2.x - _arg1.x) * _local5);
            var _local7:Number = ((_arg2.y - _arg1.y) * _local5);
            return (new Point(_local6, _local7));
        }
        public static function MoveDistance(_arg1:Point, _arg2:Point, _arg3:int):Point{
            var _local4:Number = Point.distance(_arg1, _arg2);
            var _local5:Number = (_arg3 / _local4);
            var _local6:int = int((_arg1.x + ((_arg2.x - _arg1.x) * _local5)));
            var _local7:int = int((_arg1.y + ((_arg2.y - _arg1.y) * _local5)));
            return (new Point(_local6, _local7));
        }

    }
}//package OopsEngine.Utils 
