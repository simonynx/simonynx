//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.AI.PathFinder {
    import flash.geom.*;
    import flash.utils.*;
    import OopsEngine.Utils.*;

	/**
	 *地图数据模块 
	 * @author wengliqiang
	 * 
	 */	
    public class MapTileModel implements IMapTileModel {

        public static const PATH_PASS:int = 0;
        public static const PATH_TRANSLUCENCE:int = 2;
        public static const PATH_BOOTH:int = 3;
        public static const PATH_BARRIER:int = 1;

        private static var DELTA_Y:Array = [0, -1, -1, 0, -1, 0, 1, 0, 1, 1, 0];
        public static var TITE_HREF_WIDTH:int;
        public static var OFFSET_TAB_X:int;
        public static var TILE_WIDTH:int;
        public static var TILE_HEIGHT:int;
        public static var OFFSET_TAB_Y:int;
        public static var TITE_HREF_HEIGHT:int;
        private static var DELTA_X:Array = [0, 0, 1, 1, -1, 0, 1, -1, -1, 0, 0];
        public static var SCENEMAN_SCALE:Number;

        private var map:Array;

        public static function CreateMapData(_arg1:Number, _arg2:Number, _arg3:int, _arg4:int):Array{
            var _local5:uint;
            var _local11:uint;
            var _local6:Array = new Array();
            var _local7:int = (_arg3 / 2);
            var _local8:int = (_arg4 / 2);
            var _local9:int = (((_arg1 % _arg3) == 0)) ? (_arg1 / _arg3) : ((_arg1 / _arg3) + 1);
            var _local10:int = (((_arg2 % _arg4) == 0)) ? (_arg2 / _arg4) : ((_arg2 / _arg4) + 1);
            while (_local11 < _local9) {
                _local6[_local11] = new Array();
                _local5 = 0;
                while (_local5 < _local10) {
                    _local6[_local11][(_local5 * 2)] = 0;
                    _local6[_local11][((_local5 * 2) + 1)] = 0;
                    _local5++;
                };
                _local11++;
            };
            return (_local6);
        }
        public static function GetNextPos(_arg1:int, _arg2:int, _arg3:int, _arg4:int=1):Point{
            var _local5:Point = new Point();
            _local5.x = (_arg1 + (DELTA_X[_arg3] * _arg4));
            _local5.y = (_arg2 + (DELTA_Y[_arg3] * _arg4));
            return (_local5);
        }
        public static function GetTileStageToPoint(_arg1:int, _arg2:int):Point{
            var _local3:int = (_arg1 - (_arg2 * 2));
            if (_local3 < 0){
                _local3 = (_local3 - TILE_WIDTH);
            };
            var _local4:int = ((_arg2 * 2) + _arg1);
            var _local5:int = ((_local4 + TITE_HREF_WIDTH) / TILE_WIDTH);
            var _local6:int = ((_local3 + TITE_HREF_WIDTH) / TILE_WIDTH);
            return (new Point((OFFSET_TAB_X + _local5), (OFFSET_TAB_Y + _local6)));
        }
        public static function Distance(_arg1:int, _arg2:int, _arg3:int, _arg4:int):int{
            var _local5:int = Math.abs((_arg1 - _arg3));
            var _local6:int = Math.abs((_arg2 - _arg4));
            return (Math.max(_local5, _local6));
        }
        public static function Direction(_arg1:int, _arg2:int, _arg3:int, _arg4:int):int{
            if (_arg1 < _arg3){
                if (_arg2 < _arg4){
                    return (6);
                };
                if (_arg2 > _arg4){
                    return (2);
                };
                return (3);
            };
            if (_arg1 > _arg3){
                if (_arg2 < _arg4){
                    return (8);
                };
                if (_arg2 > _arg4){
                    return (4);
                };
                return (7);
            };
            if (_arg2 < _arg4){
                return (9);
            };
            if (_arg2 > _arg4){
                return (1);
            };
            return (0);
        }
        public static function GetTilePointToStage(_arg1:int, _arg2:int):Point{
            var _local3:Point = new Point();
            var _local4:int = (_arg1 - OFFSET_TAB_X);
            var _local5:int = (_arg2 - OFFSET_TAB_Y);
            _local3.x = ((_local4 * TITE_HREF_WIDTH) + (_local5 * TITE_HREF_WIDTH));
            _local3.y = ((_local4 * TITE_HREF_HEIGHT) - (_local5 * TITE_HREF_HEIGHT));
            return (_local3);
        }

        public function IsPassAToB(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:Number):Boolean{
            var _local6:Point;
            var _local7:Point = new Point(_arg1, _arg2);
            var _local8:Point = new Point(_arg3, _arg4);
            var _local9:Number = Point.distance(_local7, _local8);
            var _local10:Point = Vector2.MoveIncrement(_local7, _local8, _arg5);
            var _local11:Number = 0;
            while (_local11 < _local9) {
                _local7 = _local7.add(_local10);
                _local11 = (_local11 + _arg5);
                _local6 = GetTileStageToPoint(_local7.x, _local7.y);
                if (this.IsPass(_local6.x, _local6.y) == false){
                    return (false);
                };
            };
            return (true);
        }
        public function IsPass(_arg1:int, _arg2:int):Boolean{
            var _local3:int = this.map.length;
            var _local4:int = this.map[0].length;
            if ((((((((_arg1 < 0)) || ((_arg1 >= _local3)))) || ((_arg2 < 0)))) || ((_arg2 >= _local4)))){
                return (false);
            };
            return (((this.map[_arg1][_arg2])!=PATH_BARRIER) ? true : false);
        }
        public function GetTargetTile(_arg1:int, _arg2:int):int{
            return (this.IsBlock(0, 0, _arg1, _arg2));
        }
        public function IsBlock(_arg1:int, _arg2:int, _arg3:int, _arg4:int):int{
            var _local5:int = this.map.length;
            var _local6:int = this.map[0].length;
            if ((((((((_arg3 < 0)) || ((_arg3 >= _local5)))) || ((_arg4 < 0)))) || ((_arg4 >= _local6)))){
                return (0);
            };
            return (this.map[_arg3][_arg4]);
        }
        public function get Map():Array{
            return (this.map);
        }
        public function FindNearPassPoint(_arg1:Point):Point{
            var nextPoint:* = null;
            var endPoint:* = _arg1;
            if (IsPass(endPoint.x, endPoint.y)){
                return (endPoint);
            };
            with (nextPoint = {}) {
				nextPoint.getNextPointByDir = function (_arg1:int, _arg2:Point):Point{
                    var _local3:Point = _arg2.clone();
                    switch (_arg1){
                        case 0:
                            _local3.x = (_local3.x - 1);
                            break;
                        case 1:
                            _local3.y = (_local3.y + 1);
                            break;
                        case 2:
                            _local3.x = (_local3.x + 1);
                            break;
                        case 3:
                            _local3.y = (_local3.y - 1);
                            break;
                    };
                    return (_local3);
                };
            };
            var getNextPointByDir:* = function (_arg1:int, _arg2:Point):Point{
                var _local3:Point = _arg2.clone();
                switch (_arg1){
                    case 0:
                        _local3.x = (_local3.x - 1);
                        break;
                    case 1:
                        _local3.y = (_local3.y + 1);
                        break;
                    case 2:
                        _local3.x = (_local3.x + 1);
                        break;
                    case 3:
                        _local3.y = (_local3.y - 1);
                        break;
                };
                return (_local3);
            };
            var maxDis:* = 5;
            var curDis:* = 0;
            var checkPoint:* = endPoint.clone();
            var checkedMap:* = new Dictionary();
            checkedMap[((checkPoint.x + "_") + checkPoint.y)] = true;
            var dir:* = 0;
            while (!(IsPass(checkPoint.x, checkPoint.y))) {
                checkPoint = getNextPointByDir(dir, checkPoint);
                checkedMap[((checkPoint.x + "_") + checkPoint.y)] = true;
                nextPoint = getNextPointByDir(((dir + 1) % 4), checkPoint);
                if (checkedMap[((nextPoint.x + "_") + nextPoint.y)] == null){
                    dir = (dir + 1);
                };
                if (dir >= 4){
                    curDis = (curDis + 1);
                    dir = (dir - 4);
                };
                if (curDis > maxDis){
                    break;
                };
            };
            checkedMap = null;
            return (checkPoint);
        }
        public function set Map(_arg1:Array):void{
            this.map = _arg1;
        }

    }
}//package OopsEngine.AI.PathFinder 
