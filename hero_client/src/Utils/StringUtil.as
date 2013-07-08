//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {

    public class StringUtil {

        public static function replace(_arg1:String, ... _args):String{
            var _local3:int;
            if (_arg1 == null){
                return ("");
            };
            while (_local3 < _args.length) {
                _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}")), _args[_local3]);
                _local3++;
            };
            return (_arg1);
        }

    }
}//package Utils 
