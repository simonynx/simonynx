//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Net {
    import flash.events.*;

    public class BaseSocketEvent extends Event {

        public static const RECEIVED:String = "received";
        public static const CONNECT:String = "connect";
        public static const IO_ERROR:String = "ioError";
        public static const SECURITY_ERROR:String = SecurityErrorEvent.SECURITY_ERROR;
        public static const DECODE_ERROR:String = "decode_error";
        public static const CLOSE:String = "close";
        public static const SENDING:String = "sending";

        private var data:Object;

        public function BaseSocketEvent(_arg1:String, _arg2:Object=null){
            super(_arg1, true);
            this.data = _arg2;
        }
        public function get Data():Object{
            return (data);
        }
        override public function clone():Event{
            return (new BaseSocketEvent(type, data));
        }
        override public function toString():String{
            return (formatToString("BaseSocketEvent", "type", "bubbles", "cancelable", "data"));
        }

    }
}//package OopsFramework.Net 
