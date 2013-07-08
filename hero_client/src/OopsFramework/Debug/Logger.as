//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Debug {
    import OopsFramework.Utils.*;

    public class Logger {

        public static var IsRun:Boolean = true;
        public static var LogAppender:ILogAppender = new TraceAppender();

        public static function Debug(_arg1:Object, _arg2:String, _arg3:String):void{
            var _local4:LogEntry;
            _local4 = new LogEntry();
            _local4.Reporter = Type.GetClass(_arg1);
            _local4.Method = _arg2;
            _local4.Message = ((_arg2 + " - ") + _arg3);
            _local4.Type = LogEntry.DEBUG;
            ProcessEntry(_local4);
        }
        public static function Print(_arg1:Object, _arg2:String):void{
            var _local3:LogEntry = new LogEntry();
            _local3.Reporter = Type.GetClass(_arg1);
            _local3.Message = _arg2;
            _local3.Type = LogEntry.MESSAGE;
            ProcessEntry(_local3);
        }
        public static function Info(_arg1:Object, _arg2:String, _arg3:String):void{
            var _local4:LogEntry;
            _local4 = new LogEntry();
            _local4.Reporter = Type.GetClass(_arg1);
            _local4.Method = _arg2;
            _local4.Message = ((_arg2 + " - ") + _arg3);
            _local4.Type = LogEntry.INFO;
            ProcessEntry(_local4);
        }
        public static function Error(_arg1:Object, _arg2:String, _arg3:String):void{
            var _local4:LogEntry = new LogEntry();
            _local4.Reporter = Type.GetClass(_arg1);
            _local4.Method = _arg2;
            _local4.Message = ((_arg2 + " - ") + _arg3);
            _local4.Type = LogEntry.ERROR;
            ProcessEntry(_local4);
        }
        private static function ProcessEntry(_arg1:LogEntry):void{
            if (IsRun){
                LogAppender.addLogMessage(_arg1.Type, Type.GetObjectClassName(_arg1.Reporter), _arg1.Message);
            };
        }
        public static function Warn(_arg1:Object, _arg2:String, _arg3:String):void{
            var _local4:LogEntry = new LogEntry();
            _local4.Reporter = Type.GetClass(_arg1);
            _local4.Method = _arg2;
            _local4.Message = ((_arg2 + " - ") + _arg3);
            _local4.Type = LogEntry.WARNING;
            ProcessEntry(_local4);
        }
        public static function PrintCustom(_arg1:Object, _arg2:String, _arg3:String, _arg4:String):void{
            var _local5:LogEntry = new LogEntry();
            _local5.Reporter = Type.GetClass(_arg1);
            _local5.Method = _arg2;
            _local5.Message = ((_arg2 + " - ") + _arg3);
            _local5.Type = _arg4;
            ProcessEntry(_local5);
        }

    }
}//package OopsFramework.Debug 
