//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Debug {

    public class LogEntry {

        public static const DEBUG:String = "DEBUG";
        public static const INFO:String = "INFO";
        public static const MESSAGE:String = "MESSAGE";
        public static const ERROR:String = "ERROR";
        public static const WARNING:String = "WARNING";

        public var Method:String = "";
        public var Depth:int = 0;
        public var Message:String = "";
        public var Reporter:Class = null;
        public var Type:String = null;

        public function get FormattedMessage():String{
            var _local2:int;
            var _local1 = "";
            while (_local2 < Depth) {
                _local1 = (_local1 + "   ");
                _local2++;
            };
            var _local3 = "";
            if (_local3){
                _local3 = (_local3 + ": ");
            };
            var _local4 = "";
            if (((!((_local4 == null))) && (!((_local4 == ""))))){
                _local4 = (_local4 + " - ");
            };
            return ((((_local1 + Reporter) + Method) + Message));
        }

    }
}//package OopsFramework.Debug 
