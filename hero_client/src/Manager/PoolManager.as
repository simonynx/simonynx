//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.utils.*;
    import OopsEngine.Pool.*;

    public class PoolManager {

        private static var _poolArr:Array = [];

        public function PoolManager(){
            throw (new Error("Can not New!"));
        }
        public static function deletePoolByName(_arg1:String):void{
            var _local2:Pool;
            for each (_local2 in _poolArr) {
                if (_local2.name == _arg1){
                    _poolArr.splice(_poolArr.indexOf(_local2), 1);
                    _local2.removeAllObjs();
                    break;
                };
            };
        }
        public static function deleteAllPools():void{
            var _local1:Pool;
            for each (_local1 in _poolArr) {
                _local1.removeAllObjs();
            };
            _poolArr = [];
        }
        public static function getPool(_arg1:String):Pool{
            var _local2:Pool;
            for each (_local2 in _poolArr) {
                if (_local2.name == _arg1){
                    return (_local2);
                };
            };
            return (null);
        }
        public static function getPoolsNum():int{
            return (_poolArr.length);
        }
        public static function creatPool(_arg1:String="", _arg2:int=2147483647):Pool{
            var _local3:Pool;
            if (!hasNamedPool(_arg1)){
                _local3 = (_poolArr[_poolArr.length] = new Pool(_arg1, _arg2));
            } else {
                _local3 = getPool(_arg1);
                _local3.resize(_arg2);
            };
            return (_local3);
        }
        public static function hasPool(_arg1:Pool):Boolean{
            return (!((_poolArr.indexOf(_arg1) == -1)));
        }
        public static function deletePool(_arg1:Pool):void{
            if (!_arg1){
                return;
            };
            var _local2:int = _poolArr.indexOf(_arg1);
            if (_local2 != -1){
                _poolArr.splice(_local2, 1);
            };
            _arg1.removeAllObjs();
        }
        public static function hasNamedPool(_arg1:String):Boolean{
            var _local2:Pool;
            for each (_local2 in _poolArr) {
                if (_local2.name == _arg1){
                    return (true);
                };
            };
            return (false);
        }

    }
}//package Manager 
