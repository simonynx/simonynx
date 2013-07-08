//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Debug {

    public class TraceAppender implements ILogAppender {

        public function addLogMessage(_arg1:String, _arg2:String, _arg3:String):void{
            trace(((((_arg1 + ": ") + _arg2) + " - ") + _arg3));
        }

    }
}//package OopsFramework.Debug 
