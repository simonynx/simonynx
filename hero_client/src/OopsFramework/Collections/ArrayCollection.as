//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Collections {
    import flash.utils.*;

	/**
	 *数组容器 
	 * @author wengliqiang
	 * 
	 */	
    public dynamic class ArrayCollection extends Proxy {

        public var Added:Function;
        public var Removed:Function;
        private var array:Array;
        public var AddAddChild:Function;

        public function ArrayCollection(){
            array = new Array();
        }
        public function Add(_arg1):void{
            if (this.IndexOf(_arg1) == -1){
                this.push(_arg1);
                if (Added != null){
                    Added(_arg1);
                };
            };
        }
        public function Shift():Object{
            return (this.shift());
        }
        public function Remove(_arg1):Boolean{
            var _local2:int = this.IndexOf(_arg1);
            if (_local2 > -1){
                this.splice(_local2, 1);
                if (Removed != null){
                    Removed(_arg1);
                };
                return (true);
            };
            return (false);
        }
        public function IndexOf(_arg1:Object, _arg2:int=0):int{
            return (this.indexOf(_arg1, _arg2));
        }
        override flash_proxy function getProperty(_arg1){
            return (array[_arg1]);
        }
        public function OtherAdd(_arg1):void{
            if (this.IndexOf(_arg1) == -1){
                this.push(_arg1);
                if (AddAddChild){
                    AddAddChild(_arg1);
                };
            };
        }
        public function Clear():void{
            var _local1:int;
            while (_local1 < this.array.length) {
                if (Removed != null){
                    Removed(this.array[_local1]);
                };
                _local1++;
            };
            array = [];
        }
        public function get Count():uint{
            return (this.length);
        }
        override flash_proxy function setProperty(_arg1, _arg2):void{
            array[_arg1] = _arg2;
        }
        override flash_proxy function callProperty(_arg1, ... _args){
            var _local3:*;
            switch (_arg1.toString()){
                default:
                    _local3 = array[_arg1].apply(array, _args);
            };
            return (_local3);
        }
        public function Concat():Array{
            return (this.array.concat());
        }
        public function SortOn(_arg1:Object, _arg2:Object=null):Array{
            return (this.sortOn(_arg1, _arg2));
        }

    }
}//package OopsFramework.Collections 
