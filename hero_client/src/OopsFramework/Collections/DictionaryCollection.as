//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Collections {
    import flash.utils.*;

	/**
	 *字典容器 
	 * @author wengliqiang
	 * 
	 */	
    public class DictionaryCollection extends Proxy {

        private var count:uint = 0;
        private var weakKeys:Boolean;
        private var dict:Dictionary;

        public function DictionaryCollection(_arg1:Boolean=false){
            this.weakKeys = _arg1;
            dict = new Dictionary(this.weakKeys);
        }
        public function Add(_arg1, _arg2):void{
            this[_arg1] = _arg2;
            count++;
        }
        public function Remove(_arg1):Boolean{
            if (this.dict[_arg1] != null){
                delete this.dict[_arg1];
                count--;
                return (true);
            };
            return (false);
        }
        override flash_proxy function getProperty(_arg1){
            return (dict[_arg1]);
        }
        public function Clear():void{
            this.dict = new Dictionary(this.weakKeys);
            count = 0;
        }
        public function get Count():uint{
            return (count);
        }
        override flash_proxy function setProperty(_arg1, _arg2):void{
            dict[_arg1] = _arg2;
        }
        override flash_proxy function callProperty(_arg1, ... _args){
            var _local3:*;
            switch (_arg1.toString()){
                default:
                    _local3 = dict[_arg1].apply(dict, _args);
            };
            return (_local3);
        }

    }
}//package OopsFramework.Collections 
