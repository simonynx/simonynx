//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Pool {
    import GameUI.View.*;

    public class Pool {

        private var _maxSize:int;
        private var _objArr:Array;
        private var _name:String;

        public function Pool(_arg1:String="", _arg2:int=2147483647){
            if (_arg2 < 0){
                throw (new Error("Pool constructor error , wrong params!"));
            };
            this._name = _arg1;
            this._maxSize = _arg2;
            this._objArr = [];
        }
        public function removeAllObjs():void{
            var _local1:IPoolClass;
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
        public function get name():String{
            return (this._name);
        }
        public function getRestingObjsNum():int{
            return (this._objArr.length);
        }
        public function disposeObj(_arg1:IPoolClass):void{
            if (_arg1 == null){
                return;
            };
            _arg1.dispose();
            if (this._objArr.indexOf(_arg1) == -1){
                this._objArr[this._objArr.length] = _arg1;
                this.resize(this._maxSize);
            };
        }
        public function removeObj(_arg1:IPoolClass):void{
            _arg1.dispose();
            var _local2:int = this._objArr.indexOf(_arg1);
            if (_local2 != -1){
                this._objArr.splice(_local2, 1);
            };
        }
        public function createObj(_arg1:Class, ... _args):IPoolClass{
            var _local3:IPoolClass;
            if (this._objArr.length == 0){
                _local3 = ResourcesFactory.getInstanceByClass(_arg1, _args);
            } else {
                _local3 = this._objArr.shift();
                _local3.reSet(_args);
            };
            return (_local3);
        }

    }
}//package OopsEngine.Pool 
