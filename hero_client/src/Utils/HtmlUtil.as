//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.text.*;

    public class HtmlUtil {

        private static var _hrefSheet:StyleSheet;

        public static function sizeColor(_arg1:String, _arg2:String=null, _arg3:int=0):String{
            var _local4 = "<font ";
            if (_arg3 != 0){
                _local4 = (_local4 + (("size='" + _arg3) + "' "));
            };
            if (_arg2 != null){
                _local4 = (_local4 + (("color='" + _arg2) + "' "));
            };
            _local4 = (_local4 + ((">" + _arg1) + "</font>"));
            return (_local4);
        }
        public static function color(_arg1:String, _arg2:String):String{
            return ((((("<font color='" + _arg2) + "'>") + _arg1) + "</font>"));
        }
        public static function bold(_arg1:String):String{
            return ((("<b>" + _arg1) + "</b>"));
        }
        public static function hrefAndU(_arg1:String, _arg2:String, _arg3:String="#FF0000"):String{
            return ((("<u>" + href(_arg1, _arg2, _arg3)) + "</u>"));
        }
        public static function href(_arg1:String, _arg2:String, _arg3:String="#FF0000"):String{
            var _local4 = (((((("<font color='" + _arg3) + "'><a href='event:") + _arg2) + "'>") + _arg1) + "</a></font>");
            return (_local4);
        }
        public static function removeHtml(_arg1:String):String{
            var _local2:String = _arg1.replace(/\<\/?[^\<\>]+\>/gmi, "");
            _local2 = _local2.replace(/[\r\n ]+/g, "");
            return (_local2);
        }
        public static function br(_arg1:String):String{
            return ((_arg1 + "\n"));
        }
        public static function customColor(_arg1:String, _arg2:String):String{
            return (((("&" + _arg2) + "&") + _arg1));
        }
        public static function get hrefSheet():StyleSheet{
            if (!_hrefSheet){
                _hrefSheet = new StyleSheet();
                _hrefSheet.setStyle("a:hover", {color:"#fc3636"});
                _hrefSheet.setStyle("a:active", {color:"#fc3636"});
            };
            return (_hrefSheet);
        }
        public static function MakeLeading(_arg1:String, _arg2:int=5):String{
            return ((((("<textformat leading='" + _arg2) + "'>") + _arg1) + "</textformat>"));
        }
        public static function autoBr(_arg1:String, _arg2:int=15):String{
            return (_arg1);
        }

    }
}//package Utils 
