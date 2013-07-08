//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class Linear {

        public static const power:uint = 0;

        public static function easeOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return ((((_arg3 * _arg1) / _arg4) + _arg2));
        }
        public static function easeIn(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return ((((_arg3 * _arg1) / _arg4) + _arg2));
        }
        public static function easeNone(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return ((((_arg3 * _arg1) / _arg4) + _arg2));
        }
        public static function easeInOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return ((((_arg3 * _arg1) / _arg4) + _arg2));
        }

    }
}//package com.greensock.easing 
