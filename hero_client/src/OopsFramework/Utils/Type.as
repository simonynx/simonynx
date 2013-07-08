//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Utils {
    import flash.utils.*;

    public class Type {

        public static function GetClass(_arg1):Class{
            if ((((_arg1 is Class)) || ((_arg1 == null)))){
                return (_arg1);
            };
            return (Object(_arg1).constructor);
        }
        public static function GetObjectClassName(_arg1):String{
            return (getQualifiedClassName(_arg1));
        }
        public static function GetClassFromName(_arg1:String):Class{
            return ((getDefinitionByName(_arg1) as Class));
        }

    }
}//package OopsFramework.Utils 
