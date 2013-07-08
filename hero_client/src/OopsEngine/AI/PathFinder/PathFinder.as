//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.AI.PathFinder {
    import flash.geom.*;

	/**
	 *寻路类 
	 * @author wengliqiang
	 * 
	 */	
    public class PathFinder {

        private static const MAX_COUNT:int = 50000;
        private static const D_COST:int = 10;
        private static const HV_COST:int = 10;

        public static var CLOSED:int = 1;

        private var _mapData:Array;
        private var _mapStatus:Array;
        private var _openList:Array;
        private var checkCount:int;

        public function PathFinder(_arg1:Array){
            _openList = new Array();
            _mapData = _arg1;
            _openList.length = 0;
            _mapStatus = [];
        }
        private function resortOpoenList(_arg1:int):void{
            var _local2:int;
            var _local3:Object;
            var _local4:Object;
            var _local5:Object;
            var _local6:Object;
            while (_arg1 > 1) {
                _local2 = Math.floor((_arg1 / 2));
                _local3 = _openList[(_arg1 - 1)];
                _local4 = _openList[(_local2 - 1)];
                _local5 = _mapStatus[_local3.x][_local3.y];
                _local6 = _mapStatus[_local4.x][_local4.y];
                if (_local5.F < _local6.F){
                    _openList[(_arg1 - 1)] = _local4;
                    _openList[(_local2 - 1)] = _local3;
                    _local5.openIndex = (_local2 - 1);
                    _local6.openIndex = (_arg1 - 1);
                    _arg1 = _local2;
                } else {
                    break;
                };
            };
        }
        public function findpath(_arg1:int, _arg2:int, _arg3:int, _arg4:int):Array{
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:Number;
            var _local14:int;
            var _local15:Array;
            var _local16:Point;
            var _local5:int = _mapData.length;
            var _local6:int = _mapData[0].length;
            if ((((((((_arg3 < 0)) || ((_arg3 >= _local5)))) || ((_arg4 < 0)))) || ((_arg4 >= _local6)))){
                return (null);
            };
            if (_mapData[_arg3][_arg4] == CLOSED){
                return (null);
            };
            _openList.length = 0;
            _mapStatus = [];
            _openList.push(new Point(_arg1, _arg2));
            _mapStatus[_arg1] = [];
            _mapStatus[_arg1][_arg2] = {
                parent:null,
                H:0,
                F:0,
                G:0,
                openIndex:0
            };
            checkCount = 1;
            var _local7:Point = new Point(-1, -1);
            while ((((_openList.length > 0)) && (!(isClosed(_arg3, _arg4))))) {
                _local7 = _openList[0];
                _local9 = _local7.x;
                _local10 = _local7.y;
                _mapStatus[_local9][_local10].openIndex = -1;
                shiftOpenList();
                _local11 = (_local9 - 1);
                while (_local11 < (_local9 + 2)) {
                    _local12 = (_local10 - 1);
                    while (_local12 < (_local10 + 2)) {
                        if ((((((((((((_local11 >= 0)) && ((_local11 < _local5)))) && ((_local12 >= 0)))) && ((_local12 < _local6)))) && (!((((_local11 == _local9)) && ((_local12 == _local10))))))) && ((((((_local11 == _local9)) || ((_local12 == _local10)))) || (((!((_mapData[_local11][_local10] == CLOSED))) && (!((_mapData[_local9][_local12] == CLOSED))))))))){
                            if (_mapData[_local11][_local12] != CLOSED){
                                if (!isClosed(_local11, _local12)){
                                    _local13 = (int(_mapStatus[_local9][_local10].G) + 10);
                                    if (isOpen(_local11, _local12)){
                                        if (_local13 < _mapStatus[_local11][_local12].G){
                                            _mapStatus[_local11][_local12].parent = _local7;
                                            _mapStatus[_local11][_local12].G = _local13;
                                            _mapStatus[_local11][_local12].F = (_local13 + _mapStatus[_local11][_local12].H);
                                            resortOpoenList((_mapStatus[_local11][_local12].openIndex + 1));
                                        };
                                    } else {
                                        _local14 = ((Math.abs((_local11 - _arg3)) + Math.abs((_local12 - _arg4))) * 10);
                                        _openList.push(new Point(_local11, _local12));
                                        if (!_mapStatus[_local11]){
                                            _mapStatus[_local11] = [];
                                        };
                                        _mapStatus[_local11][_local12] = {
                                            parent:_local7,
                                            H:_local14,
                                            G:_local13,
                                            F:(_local13 + _local14),
                                            openIndex:(_openList.length - 1)
                                        };
                                        resortOpoenList(_openList.length);
                                    };
                                };
                            };
                        };
                        _local12++;
                    };
                    _local11++;
                };
                checkCount++;
                if (checkCount > MAX_COUNT){
                    trace("寻路超出检查次数了..");
                    break;
                };
            };
            var _local8:Boolean = isClosed(_arg3, _arg4);
            if (_local8){
                _local15 = new Array();
                _local16 = new Point(_arg3, _arg4);
                while (((!((_local16.y == _arg2))) || (!((_local16.x == _arg1))))) {
                    _local15.push(_local16);
                    _local16 = _mapStatus[_local16.x][_local16.y].parent;
                };
                _local16.x = _arg1;
                _local16.y = _arg2;
                _local15.push(_local16);
                _local15.reverse();
                return (_local15);
            };
            return (null);
        }
        private function shiftOpenList():void{
            var _local2:int;
            var _local3:Object;
            var _local4:Object;
            if (_openList.length == 1){
                _openList.length = 0;
                return;
            };
            _openList[0] = _openList.pop();
            _mapStatus[_openList[0].x][_openList[0].y].openIndex = 0;
            var _local1 = 1;
            while (true) {
                _local2 = _local1;
                if ((2 * _local2) <= _openList.length){
                    if (_mapStatus[_openList[(_local1 - 1)].x][_openList[(_local1 - 1)].y].F > _mapStatus[_openList[((2 * _local2) - 1)].x][_openList[((2 * _local2) - 1)].y].F){
                        _local1 = (2 * _local2);
                    };
                    if (((2 * _local2) + 1) <= _openList.length){
                        if (_mapStatus[_openList[(_local1 - 1)].x][_openList[(_local1 - 1)].y].F > _mapStatus[_openList[(2 * _local2)].x][_openList[(2 * _local2)].y].F){
                            _local1 = ((2 * _local2) + 1);
                        };
                    };
                };
                if (_local2 == _local1){
                    break;
                };
                _local3 = _openList[(_local2 - 1)];
                _local4 = _openList[(_local1 - 1)];
                _openList[(_local2 - 1)] = _local4;
                _openList[(_local1 - 1)] = _local3;
                _mapStatus[_local3.x][_local3.y].openIndex = (_local1 - 1);
                _mapStatus[_local4.x][_local4.y].openIndex = (_local2 - 1);
            };
        }
        public function set mapData(_arg1:Array):void{
            _mapData = _arg1;
            _openList.length = 0;
            _mapStatus = [];
        }
        private function isOpen(_arg1:int, _arg2:int):Boolean{
            var _local3:* = _mapStatus[_arg1];
            if (_local3 != undefined){
                _local3 = _local3[_arg2];
                if (_local3 != undefined){
                    return (!((_local3.openIndex == -1)));
                };
                return (false);
            };
            return (false);
        }
        private function isClosed(_arg1:int, _arg2:int):Boolean{
            var _local3:* = _mapStatus[_arg1];
            if (_local3 != undefined){
                _local3 = _local3[_arg2];
                if (_local3 != undefined){
                    return ((_local3.openIndex == -1));
                };
                return (false);
            };
            return (false);
        }

    }
}//package OopsEngine.AI.PathFinder 
