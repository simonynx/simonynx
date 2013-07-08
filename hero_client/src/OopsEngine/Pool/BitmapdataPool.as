//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Pool {
    import flash.display.*;
    import GameUI.View.*;

    public class BitmapdataPool {

        private var _maxSize:int;
        private var _objArr:Array;
        private var _name:String;

        public function BitmapdataPool(_arg1:String="", _arg2:int=2147483647){
            if (_arg2 < 0){
                throw (new Error("Pool constructor error , wrong params!"));
            };
            this._name = _arg1;
            this._maxSize = _arg2;
            this._objArr = [];
        }
        public function removeAllObjs():void{
            var _local1:BitmapData;
            for each (_local1 in this._objArr) {
                _local1.dispose();
            };
            this._objArr = [];
        }
        public function resize(_arg1:int):void{
            if (_arg1 < 0){
                return;
            };
            this._maxSize = _arg1;
            while (this._objArr.length > this._maxSize) {
                this._objArr.shift();
            };
        }
        public function getRestingObjsNum():int{
            return (this._objArr.length);
        }
        public function disposeObj(_arg1:BitmapData):void{
            if (_arg1 == null){
                return;
            };
            if (this._objArr.indexOf(_arg1) == -1){
                this._objArr[this._objArr.length] = _arg1;
                this.resize(this._maxSize);
            };
        }
        public function removeObj(_arg1:BitmapData):void{
            _arg1.dispose();
            var _local2:int = this._objArr.indexOf(_arg1);
            if (_local2 != -1){
                this._objArr.splice(_local2, 1);
            };
        }
        public function createObj(_arg1:Class, ... _args):BitmapData{
            var _local3:BitmapData;
            if (this._objArr.length == 0){
                _local3 = ResourcesFactory.getInstanceByClass(_arg1, _args);
            } else {
                _local3 = this._objArr[0];
                if (((!((_local3.width == _args[0]))) || (!((_local3.height == _args[1]))))){
                    return (ResourcesFactory.getInstanceByClass(_arg1, _args));
                };
                _local3 = this._objArr.shift();
            };
            return (_local3);
        }

    }
}//package OopsEngine.Pool 
