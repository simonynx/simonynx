//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {
    import flash.events.*;

    public class HandlerHelper {

        public function HandlerHelper(){
            throw (new Event("静态类"));
        }
        public static function execute(_arg1:Function, _arg2:Array=null){
            if (_arg1 == null){
                return (null);
            };
            return (_arg1.apply(null, _arg2));
        }

    }
}//package OopsFramework 
